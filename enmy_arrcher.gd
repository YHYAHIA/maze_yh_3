extends CharacterBody2D

@export var player: Node2D  # Reference to the player
@onready var fire_timer: Timer = $Timer2  # Timer for firing arrows
@export var arrow_scene: PackedScene  # Drag your arrow scene here
@export var fire_interval: float = 5.0  # Time between shots
@export var SPEED: float = 150.0  # Movement speed
@export var damage: int = 0  # Damage dealt by the archer
#@onready var arrow_start: Marker2D = $Marker2D  # Reference to the Marker2D node
var current_arrow: Node = null  # Tracks the currently active arrow
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer  # Timer for recalculating paths
@onready var anim: AnimationPlayer = $AnimationPlayer  # Animation player
var is_attacking: bool = false  # Tracks if the enemy is attacking
var is_player_in_path_area: bool = false  # Tracks if the player is in the path area
var is_player_in_attack_area: bool = false  # Tracks if the player is in the attack area
var attack_finished: bool = true  # Ensures attack animation finishes before switching
var facing_left: bool = true  # Tracks the facing direction
var fire_arrow_time: float = 0.5  # Time during the animation to fire the arrow (in seconds)

func _ready() -> void:
	if fire_interval <= 0:
		fire_interval = 1.0  # Default value to prevent errors
	fire_timer.wait_time = fire_interval
	fire_timer.start()

	# Connect the animation finished signal
	anim.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(_delta: float) -> void:
	# Handle movement only if not attacking
	if is_player_in_path_area and not is_attacking:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * SPEED

		# Update facing direction
		if dir.x > 0:
			facing_left = false
		elif dir.x < 0:
			facing_left = true
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Update animations
	if attack_finished:
		update_anim()

func update_anim() -> void:
	# Handle animations
	if is_attacking:
		play_attack_animation()
	elif is_player_in_path_area:
		if facing_left:
			anim.play("run_left")
		else:
			anim.play("run_right")
	else:
		if facing_left:
			anim.play("idle_left")
		else:
			anim.play("idle_right")

func play_attack_animation() -> void:
	# Calculate the direction to the player
	var dir = (player.global_position - global_position).normalized()

	# Determine the direction and play the corresponding animation
	if dir.x > 0.5 and abs(dir.y) <= 0.5:
		anim.play("attack_right")
	elif dir.x < -0.5 and abs(dir.y) <= 0.5:
		anim.play("attack_left")
	elif dir.y > 0.5 and abs(dir.x) <= 0.5:
		anim.play("attack_down")
	elif dir.y < -0.5 and abs(dir.x) <= 0.5:
		anim.play("attack_up")
	elif dir.x > 0 and dir.y < 0:
		anim.play("attack_right_up")
	elif dir.x > 0 and dir.y > 0:
		anim.play("attack_right_down")
	elif dir.x < 0 and dir.y < 0:
		anim.play("attack_left_up")
	elif dir.x < 0 and dir.y > 0:
		anim.play("attack_left_down")

	# Fire arrow only when the animation reaches the specific time
	if anim.current_animation_position >= fire_arrow_time:
		fire_arrow()

func fire_arrow() -> void:
	# Only fire if no active arrow exists
	if current_arrow != null:
		return

	# Defer the arrow instantiation to avoid flushing queries
	call_deferred("_spawn_arrow")

func _spawn_arrow() -> void:
	# Instantiate the arrow
	var arrow = arrow_scene.instantiate() as RigidBody2D
	arrow.global_position = self.global_position  # Start at the Marker2D position

	# Calculate direction and apply it to the arrow
	var direction = (player.global_position - arrow.global_position).normalized()
	arrow.direction = direction

	# Set the arrow's rotation to face the direction
	arrow.rotation = direction.angle()

	# Track the active arrow
	current_arrow = arrow

	# Add the arrow to the scene
	get_parent().add_child(arrow)

	arrow.connect("tree_exiting", Callable(self, "_on_arrow_disabled"))

func _on_arrow_disabled() -> void:
	# Reset the current arrow reference when it leaves the scene
	current_arrow = null

func makepath() -> void:
	# Update the navigation target position
	nav_agent.target_position = player.global_position

func _on_timer_timeout() -> void:
	# Recalculate path periodically if the player is in the path area
	if is_player_in_path_area and not is_attacking:
		makepath()

func _on_navigation_agent_2d_navigation_finished() -> void:
	# Stop movement when navigation finishes
	velocity = Vector2.ZERO

func _on_path_body_entered(body: Node2D) -> void:
	# Recalculate path when the player enters the detection area
	if body == player:
		is_player_in_path_area = true
		makepath()
		timer.start()

func _on_path_body_exited(body: Node2D) -> void:
	# Stop pathfinding updates when the player exits the detection area
	if body == player:
		is_player_in_path_area = false
		timer.stop()

		# If the player is not in the attack area, stop moving and switch to idle
		if not is_player_in_attack_area:
			velocity = Vector2.ZERO
			update_anim()

func _on_attack_body_entered(body: Node2D) -> void:
	# Stop movement and switch to attack animation
	if body == player:
		is_player_in_attack_area = true
		is_attacking = true
		attack_finished = false
		velocity = Vector2.ZERO

		# Play attack animation
		play_attack_animation()

func _on_attack_body_exited(body: Node2D) -> void:
	# Resume movement after the player exits the attack area
	if body == player:
		is_player_in_attack_area = false
		is_attacking = false

		# If the player is in the path area, return to running
		if is_player_in_path_area:
			makepath()
		else:
			# Otherwise, stop moving and switch to idle
			velocity = Vector2.ZERO
			update_anim()

func _on_animation_finished(animation_name: String) -> void:
	# Ensure the attack animation is finished before transitioning
	if animation_name.begins_with("attack_"):
		attack_finished = true
		if not is_player_in_attack_area:
			if is_player_in_path_area:
				makepath()
			else:
				velocity = Vector2.ZERO
				update_anim()
