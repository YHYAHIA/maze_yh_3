extends CharacterBody2D


@export var player: Node2D

@export var attack_damage: int = 30  # Damage caused by the explosion

@export var speed: float = 150.0  # Movement speed


@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer
@onready var anim: AnimationPlayer = $AnimationPlayer

var is_player_in_path_area: bool = false  # Tracks if the player is in the path area
var facing_left: bool = true  # Tracks the facing direction
var is_attacking: bool = false  # Tracks if the enemy is in the middle of the explosion animation

func _ready() -> void:
	# Ensure the player is assigned
	pass  # Free the enemy if no player is found

	# Start the timer for periodic path recalculation
	timer.start()

func _physics_process(delta: float) -> void:
	# Disable movement if the enemy is exploding
	if is_attacking:
		velocity = Vector2.ZERO
	elif is_player_in_path_area:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed

		# Update facing direction
		facing_left = dir.x < 0

		
	
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Update animations
	if not is_attacking:
		update_anim()

func update_anim() -> void:
	# Handle animations
	if is_player_in_path_area:
		anim.play("run_left" if facing_left else "run_right")
	else:
		anim.play("idle_left"if facing_left else "idle_right")

func explode() -> void:
	# Prevent multiple explosions at the same time
	if is_attacking:
		return

	# Apply damage to the player if within the explosion radius
	
	if player.has_method("set_health"):
		player.set_health(player.get_health() - attack_damage)

	# Optional: Create explosion effect
	

	# Play explosion animation
	if anim.has_animation("attack_"):
		is_attacking = true
		anim.play("attack")
		anim.connect("animation_finished",Callable( self, "_on_explosion_animation_finished"))
	else:
		print("attack animation 'attack' not found.")

func _on_explosion_animation_finished(anim_name: String) -> void:
	if anim_name == "attack":
		is_attacking = false  # Allow the enemy to move again
		anim.disconnect("animation_finished",Callable( self, "_on_attacking_animation_finished"))

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
