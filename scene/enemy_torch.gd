extends CharacterBody2D

@export var speed: int = 150
@export var attack_damage: int = 30
@export var nav_update_time: float = 0.5  # Interval to update navigation path
@export var line_of_fire_scene: PackedScene  # Drag and drop the Line of Fire scene here

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var fire_spawn_points: Dictionary = {
	"up": $spawenpoits/up,
	"down": $spawenpoits/down,
	"left": $spawenpoits/left,
	"right": $spawenpoits/right
}
@onready var attack_timer: Timer = $attack_timer
@onready var fire_timer: Timer = $fire_timer
@onready var nav_timer: Timer = $nav_timer
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

@export var player: Node2D

var facing_direction: String = "down"
var is_attacking: bool = false
var is_player_in_path_area: bool = false
var is_player_in_attack_area: bool = false
var active_line_of_fire: Node = null  # To track the active line of fire

func _ready() -> void:
	# Ensure the timers are properly initialized
	if attack_timer == null:
		print("Error: attack_timer is null!")
		return
	if fire_timer == null:
		print("Error: fire_timer is null!")
		return

	if player == null:
		print("Player not assigned. Freeing the enemy.")
		queue_free()
		return

	# Start timers
	attack_timer.start()
	nav_timer.start()

func _physics_process(delta: float) -> void:
	if is_player_in_attack_area:
		velocity = Vector2.ZERO
		align_to_player()
		if not is_attacking and !attack_timer.is_stopped():
			attack_player()
	elif is_player_in_path_area:
		move_toward_player()
	else:
		velocity = Vector2.ZERO
		play_idle_animation()

	move_and_slide()

func move_toward_player() -> void:
	if nav_agent.target_position != player.global_position:
		nav_agent.target_position = player.global_position

	var next_position = nav_agent.get_next_path_position()
	if next_position != Vector2.ZERO:
		var dir = (next_position - global_position).normalized()
		velocity = dir * speed
		facing_direction = determine_direction(dir)
		play_run_animation()
	else:
		velocity = Vector2.ZERO

func determine_direction(dir: Vector2) -> String:
	if abs(dir.x) > abs(dir.y):
		return "right" if dir.x > 0 else "left"
	else:
		return "down" if dir.y > 0 else "up"

func align_to_player() -> void:
	# Adjust enemy's position slightly to align with the player
	var alignment_offset = 10.0
	if facing_direction in ["up", "down"]:
		velocity.x = (player.global_position.x - global_position.x) * .9
	elif facing_direction in ["left", "right"]:
		velocity.y = (player.global_position.y - global_position.y) * .9

func attack_player() -> void:
	if is_attacking or active_line_of_fire != null:
		return
	is_attacking = true
	velocity = Vector2.ZERO

	anim.play("attack_" + facing_direction)
	if not anim.is_connected("animation_finished", Callable(self, "_on_attack_animation_finished")):
		anim.connect("animation_finished", Callable(self, "_on_attack_animation_finished"))

	# Attack Type 1: Regular Attack (Damage to player)
	attack_damage_to_player()

	# Attack Type 2: Line of Fire (Triggered during the attack animation)
	# We will trigger the line of fire in a keyframe event in the animation

func attack_damage_to_player() -> void:
	if player.global_position.distance_to(global_position) <= 100:
		if player.has_method("set_health"):
			player.set_health(player.get_health() - attack_damage)

func spawn_line_of_fire() -> void:
	if not line_of_fire_scene or fire_timer == null:
		print("Fire timer is not initialized!")
		return

	# Check the current status of the fire timer
	print("Fire Timer is running: ", fire_timer.is_stopped())

	# Stop the timer if it's already running
	if fire_timer.is_stopped() == false:
		print("Stopping the fire timer")
		fire_timer.stop()

	# Spawn the line of fire
	var line_of_fire = line_of_fire_scene.instantiate()
	var spawn_point = fire_spawn_points.get(facing_direction, null)
	if spawn_point:
		line_of_fire.global_position = spawn_point.global_position
		get_tree().current_scene.add_child(line_of_fire)
		active_line_of_fire = line_of_fire

		if line_of_fire.has_node("AnimationPlayer"):
			var fire_anim = line_of_fire.get_node("AnimationPlayer")
			if fire_anim.has_animation("fire_" + facing_direction):
				fire_anim.play("fire_" + facing_direction)
				fire_anim.connect("animation_finished", Callable(self, "_on_fire_animation_finished"))
			else:
				print("Animation 'fire_" + facing_direction + "' not found!")
		else:
			print("Line of Fire does not have an AnimationPlayer node!")

	# Start the fire timer after spawning the line of fire
	print("Starting the fire timer")
	fire_timer.start()

func _on_fire_animation_finished(anim_name: String) -> void:
	# Remove the line of fire when the fire animation is finished
	if active_line_of_fire:
		active_line_of_fire.queue_free()
		active_line_of_fire = null

func _on_fire_timer_timeout() -> void:
	# This function is triggered when the fire cooldown timer expires.
	if active_line_of_fire:
		active_line_of_fire.queue_free()
		active_line_of_fire = null

func play_run_animation() -> void:
	if facing_direction == "left":
		anim.play("run_left")
	elif facing_direction == "right":
		anim.play("run_right")

func play_idle_animation() -> void:
	if facing_direction == "left":
		anim.play("idle_left")
	elif facing_direction == "right":
		anim.play("idle_right")

func _on_attack_animation_finished(anim_name: String) -> void:
	if anim_name.begins_with("attack_"):
		is_attacking = false
		anim.disconnect("animation_finished", Callable(self, "_on_attack_animation_finished"))
		attack_timer.start()  # Restart the attack cooldown timer

		# Trigger the line of fire after the animation finishes
		# You can either trigger this manually or use an AnimationPlayer event (keyframe) to call spawn_line_of_fire
		# Here, we trigger it manually for now
		spawn_line_of_fire()

	# Reset attack cooldown timer here as well
	attack_timer.start()

func _on_nav_timer_timeout() -> void:
	if is_player_in_path_area:
		nav_agent.target_position = player.global_position

func _on_path_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_in_path_area = true
		nav_timer.start(nav_update_time)

func _on_path_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_in_path_area = false
		nav_timer.stop()
		velocity = Vector2.ZERO

func _on_attack_body_entered(body: Node2D) -> void:
	if body == player:
		is_player_in_attack_area = true

func _on_attack_body_exited(body: Node2D) -> void:
	if body == player:
		is_player_in_attack_area = false
		is_attacking = false
