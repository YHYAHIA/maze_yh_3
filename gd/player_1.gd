extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var flash_hit: AnimationPlayer = $AnimatedSprite2D/flash_hit

# Player stats
@export var health: int = 100
@export var max_health: int = 100
@export var speed: float = 255

# Reference to the health bar (drag and drop in the editor)
@export var health_bar: Node

# Handles input and updates velocity
func handle_input() -> void:
	velocity = Vector2.ZERO  # Reset velocity to prevent diagonal movement
	if Input.is_action_pressed("up"):
		velocity.y = -1
	elif Input.is_action_pressed("down"):
		velocity.y = 1
	elif Input.is_action_pressed("left"):
		velocity.x = -1
	elif Input.is_action_pressed("right"):
		velocity.x = 1

	velocity = velocity.normalized() * speed

# Updates animations based on movement direction
func update_animation() -> void:
	if velocity.length() == 0:
		animated_sprite_2d.stop()
	else:
		var anim = ""
		if velocity.x < 0:
			anim = "move_left"
		elif velocity.x > 0:
			anim = "move_right"
		elif velocity.y < 0:
			anim = "move_up"
		elif velocity.y > 0:
			anim = "move_down"

		if animated_sprite_2d.animation != anim:
			animated_sprite_2d.play(anim)

# Handles physics and movement
func _physics_process(_delta: float) -> void:
	handle_input()
	move_and_slide()
	update_animation()

# Updates health and UI elements
func _process(_delta: float) -> void:
	var current_scene_file = get_tree().current_scene.scene_file_path

	if health <= 0:
		GlobalInteract.collectedKeys = 0
		queue_free()
		TransitionScene.transition()
		get_tree().change_scene_to_file(current_scene_file)

	if GlobalInteract.plyer_geting_damge:
		flash_hit.play()

# Handles damage area entry
func _on_damge_body_entered(body: Node2D) -> void:
	if body == self:
		apply_damage_effect(10)  # Example: Apply 10 damage

# Applies damage and updates the health bar
func apply_damage_effect(damage: int) -> void:
	set_health(health - damage)
	flash_hit.play()

# Updates player speed
func set_speed(new_speed: float) -> void:
	speed = new_speed

# Gets the player's health
func get_health() -> int:
	return health

# Sets the player's health and updates the health bar
func set_health(new_health: int) -> void:
	health = clamp(new_health, 0, max_health)  # Ensure health stays within valid range
	if health_bar:
		health_bar.value = health
