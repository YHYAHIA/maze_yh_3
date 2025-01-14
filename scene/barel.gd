extends CharacterBody2D

@export var player: Node2D
@export var jump_force: float = 600.0  # Force of the jump
@export var explosion_damage: int = 30  # Damage caused by the explosion
@export var explosion_radius: float = 100.0  # Radius of the explosion
@export var speed: float = 150.0  # Movement speed
@export var explosion_effect: PackedScene  # Optional: Explosion effect

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer
@onready var anim: AnimationPlayer = $barel_animation

var is_player_in_path_area: bool = false  # Tracks if the player is in the path area
var facing_left: bool = true  # Tracks the facing direction
var is_exploding: bool = false  # Tracks if the enemy is in the middle of the explosion animation

func _ready() -> void:
	# Ensure the player is assigned
	pass  # Free the enemy if no player is found

	# Start the timer for periodic path recalculation
	timer.start()

func _physics_process(delta: float) -> void:
	# Disable movement if the enemy is exploding
	if is_exploding:
		velocity = Vector2.ZERO
	elif is_player_in_path_area:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed

		# Update facing direction
		facing_left = dir.x < 0

		# Check proximity to the player
		if player.global_position.distance_to(global_position) <= 50:
			explode()
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Update animations
	if not is_exploding:
		update_anim()

func update_anim() -> void:
	# Handle animations
	if is_player_in_path_area:
		anim.play("run_left" if facing_left else "run_right")
	else:
		anim.play("idle")

func explode() -> void:
	# Prevent multiple explosions at the same time
	if is_exploding:
		return

	# Apply damage to the player if within the explosion radius
	if player and player.global_position.distance_to(global_position) <= explosion_radius:
		if player.has_method("set_health"):
			player.set_health(player.get_health() - explosion_damage)

	# Optional: Create explosion effect
	if explosion_effect:
		var explosion_instance = explosion_effect.instantiate()
		explosion_instance.global_position = global_position
		get_tree().current_scene.add_child(explosion_instance)

	# Play explosion animation
	if anim.has_animation("explode"):
		is_exploding = true
		anim.play("explode")
		anim.connect("animation_finished",Callable( self, "_on_explosion_animation_finished"))
	else:
		print("Explosion animation 'explode' not found.")

func _on_explosion_animation_finished(anim_name: String) -> void:
	if anim_name == "explode":
		is_exploding = false  # Allow the enemy to move again
		anim.disconnect("animation_finished",Callable( self, "_on_explosion_animation_finished"))

func makepath() -> void:
	# Update the navigation target position
	nav_agent.target_position = player.global_position

func _on_timer_timeout() -> void:
	# Recalculate path only if player has moved significantly
	if is_player_in_path_area:
		if player.global_position.distance_to(nav_agent.target_position) > 10.0:
			makepath()

func _on_path_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_in_path_area = true
		makepath()

func _on_path_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_in_path_area = false
