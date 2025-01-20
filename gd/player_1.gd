extends CharacterBody2D

@onready var anime: AnimationPlayer = $AnimationPlayer
@onready var flash_hit: AnimationPlayer = $flash_hit
  # Ensure the Timer node is named correctly
@onready var death_timer: Timer = $death_timer

# Player stats
@export var health: int = 100
@export var max_health: int = 100
@export var speed: float = 255

# Reference to the health bar
@export var health_bar: Node = null
var is_dead: bool = false  # Track if the player is dead
var is_taking_damage: bool = false  # Tracks if the player is currently taking damage

# Handles input and updates velocity
func handle_input() -> void:
	if is_dead:
		return  # Prevent input if the player is dead
	velocity = Vector2.ZERO
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
	if is_dead:
		return  # Prevent animation updates if the player is dead
	if velocity.length() == 0:
		anime.stop()
	else:
		var anim = ""
		if velocity.x < 0:
			anim = "walk_left"
		elif velocity.x > 0:
			anim = "walk_right"
		elif velocity.y < 0:
			anim = "walk_up"
		elif velocity.y > 0:
			anim = "walk_down"

		if anime.current_animation != anim:
			anime.play(anim)

# Handles physics and movement
func _physics_process(_delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO  # Stop movement if dead
		return
	handle_input()
	move_and_slide()
	update_animation()

# Updates health and checks for death
func _process(_delta: float) -> void:
	if is_dead:
		return  # Skip further logic if the player is dead
	
	if health <= 0 and not is_dead:
		die()


# Applies damage and updates the health bar
func apply_damage_effect(damage: int) -> void:
	set_health(health - damage)
	flash_hit.play()

# Updates player speed
func set_speed(new_speed: float) -> void:
	speed = new_speed
func get_health() -> int:
	return health
# Sets the player's health and updates the health bar
func set_health(new_health: int) -> void:
	health = clamp(new_health, 0, max_health)
	if health_bar:
		var current_value = health_bar.get("healthbar1").value
		health_bar.call("change_health", health - current_value)
	if health <= 0:
		die()

# Handles player death

func die() -> void:
	if is_dead:
		return  # Prevent repeated calls to die()
	
	is_dead = true
	velocity = Vector2.ZERO  # Stop movement
	anime.play("dead")  # Play the death animation
	print("Playing dead animation")
	death_timer.start()  # Start the death timer
	print("Timer started")
	GlobalInteract.collectedKeys = 0


# Called when the death timer times out






func _on_death_timer_timeout() -> void:
	print("Timer timeout triggered")
	TransitionScene.transition()
	print("Scene transitioning")
	get_tree().reload_current_scene()
