extends CharacterBody2D

# Player stats
var health: int = 100
var speed: float = 300

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
		$AnimatedSprite2D.stop()
	else:
		if velocity.x < 0:
			if $AnimatedSprite2D.animation != "move_left":
				$AnimatedSprite2D.play("move_left")
		elif velocity.x > 0:
			if $AnimatedSprite2D.animation != "move_right":
				$AnimatedSprite2D.play("move_right")
		elif velocity.y < 0:
			if $AnimatedSprite2D.animation != "move_up":
				$AnimatedSprite2D.play("move_up")
		elif velocity.y > 0:
			if $AnimatedSprite2D.animation != "move_down":
				$AnimatedSprite2D.play("move_down")

# Handles physics and movement
func _physics_process(delta: float) -> void:
	handle_input()
	move_and_slide()
	update_animation()

# Updates health and UI elements
func _process(delta: float) -> void:
	$ProgressBar.max_value = 100
	$ProgressBar.value = health
	if health <= 0:
		queue_free()
		
