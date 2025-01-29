extends CharacterBody2D

@export var jump_force: float = 800.0  # Increased force for a higher jump
@export var explosion_damage: int = 30  # Damage caused by the explosion
@export var explosion_radius: float = 100.0  # Radius of the explosion
@export var speed: float = 150.0  # Movement speed
@export var explosion_effect: PackedScene  # Optional: Explosion effect
@export var jump_duration: float = 0.8  # Time taken to complete the jump
@export var charge_time: float = 0.5  # Time spent charging before jumping

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer
@onready var anim: AnimationPlayer = $barel_animation

var is_player_in_path_area: bool = false  # Tracks if the player is in the path area
var facing_left: bool = true  # Tracks the facing direction
var is_exploding: bool = false  # Tracks if the enemy is in the middle of the explosion animation
var is_charging: bool = false  # Tracks if the enemy is charging before the jump
var player: Node2D = null
var jump_start_position: Vector2
var jump_target_position: Vector2
var jump_elapsed_time: float = 0.0
var is_jumping: bool = false

func _ready() -> void:
	# Find the player in the group
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		queue_free()
		return

	# Start the timer for periodic path recalculation
	timer.start()

func _physics_process(delta: float) -> void:
	if is_exploding or is_charging:
		velocity = Vector2.ZERO
	elif is_jumping:
		jump_elapsed_time += delta
		var t = jump_elapsed_time / jump_duration
		var jump_arc = -4 * (t - 0.5) * (t - 0.5) + 1  # Creates a parabolic jump curve
		if t >= 1.0:
			global_position = jump_target_position
			explode()
			is_jumping = false
		else:
			global_position = jump_start_position.lerp(jump_target_position, t) + Vector2(0, -jump_arc * jump_force)
	else:
		if is_player_in_path_area:
			var dir = to_local(nav_agent.get_next_path_position()).normalized()
			velocity = dir * speed
			facing_left = dir.x < 0

			if player.global_position.distance_to(global_position) <= 100:
				charge_before_jump()
		else:
			velocity = Vector2.ZERO

		move_and_slide()

	if not is_exploding and not is_jumping and not is_charging:
		update_anim()

func update_anim() -> void:
	if is_player_in_path_area:
		anim.play("run_left" if facing_left else "run_right")
	else:
		anim.play("idle")

func charge_before_jump() -> void:
	if is_exploding or is_jumping or is_charging:
		return

	is_charging = true
	anim.play("charging")
	await get_tree().create_timer(charge_time).timeout
	is_charging = false
	jump_to_player()

func jump_to_player() -> void:
	if is_exploding or is_jumping:
		return

	jump_start_position = global_position
	jump_target_position = player.global_position
	jump_elapsed_time = 0.0
	is_jumping = true
	anim.play("jump")

func explode() -> void:
	is_exploding = true

	if player and player.global_position.distance_to(global_position) <= explosion_radius:
		if player.has_method("set_health"):
			player.set_health(player.get_health() - explosion_damage)

	if explosion_effect:
		var explosion_instance = explosion_effect.instantiate()
		explosion_instance.global_position = global_position
		get_tree().current_scene.add_child(explosion_instance)

	if anim.has_animation("explode"):
		anim.play("explode")
		anim.connect("animation_finished", Callable(self, "_on_explosion_animation_finished"))
	else:
		queue_free()

func _on_explosion_animation_finished(anim_name: String) -> void:
	if anim_name == "explode":
		queue_free()

func makepath() -> void:
	nav_agent.target_position = player.global_position

func _on_timer_timeout() -> void:
	if is_player_in_path_area and player.global_position.distance_to(nav_agent.target_position) > 10.0:
		makepath()

func _on_path_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_in_path_area = true
		makepath()

func _on_path_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_in_path_area = false
