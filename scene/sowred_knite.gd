extends CharacterBody2D
class_name knight

@export var SPEED = 150
@export var damage = 0

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer
@onready var anim: AnimationPlayer = $AnimationPlayer
@export var player: Node2D

var is_attacking: bool = false  # Tracks if the enemy is attacking
var is_player_in_path_area: bool = false  # Tracks if the player is in the path area
var is_player_in_attack_area: bool = false  # Tracks if the player is in the attack area
var attack_finished: bool = true  # Ensures attack animation finishes before switching
var facing_left: bool = true  # Tracks the facing direction

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

	# Update animations if the attack is finished
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

		# Play attack animation based on direction
		play_attack_animation()

		# Connect the signal to handle animation completion
		anim.animation_finished.connect(_on_attack_finished)

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

func _on_attack_finished(animation_name: String) -> void:
	# Ensure the attack animation is finished before transitioning
	if animation_name.begins_with("attack_"):
		attack_finished = true
		anim.animation_finished.disconnect(_on_attack_finished)

		# If the player is not in the attack area, resume pathfinding or idle
		if not is_player_in_attack_area:
			if is_player_in_path_area:
				makepath()
			else:
				velocity = Vector2.ZERO
				update_anim()

func _on_damage_area_body_entered(body: Node2D) -> void:
	# Apply damage to the player when it enters the damage area
	if body.is_in_group("player"):
		if body.has_method("set_health"):  # Ensure the player has a health setter
			body.set_health(body.get_health() - damage)  # Apply damage
			print("Player hit! Damage:", damage)