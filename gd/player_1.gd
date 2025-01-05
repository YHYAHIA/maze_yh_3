extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var flash_hit: AnimationPlayer = $AnimatedSprite2D/flash_hit

# Player stats
@export var health: int = 100
@export var speed: float = 255

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
func _physics_process(_delta: float) -> void:
	handle_input()
	move_and_slide()
	update_animation()

# Updates health and UI elements
func _process(_delta: float) -> void:
	var currnt_scene_file=get_tree().current_scene.scene_file_path
	$ProgressBar.max_value =100
	$ProgressBar.value = health
	if health <= 0:
		#$AudioStreamPlayer2D.play()
		GlobalInteract.collectedKeys = 0
		queue_free()
		TransitionScene.transition()
		
		#await TransitionScene.on_transition_finished
		get_tree().change_scene_to_file(currnt_scene_file)
		
	if GlobalInteract.plyer_geting_damge ==true:
		$AnimatedSprite2D/flash_hit.play()
		
		
	
	print(speed)

func _on_damge_body_entered(body: Node2D) -> void:
	print("da5al");
	if(body == self):
		#apply_dameg_effect()
		print("player da5al")
	pass # Replace with function body.
#func apply_damge_effect():
	#var tween = get_tree().create_tween()
	#tween.tween_method(self,"setshader_blinkintensity", 1.0, 0.0, 0.5)
	#tween.start()  # Ensure the tween starts
	
func set_speed(new_speed:float)->void:
	speed=new_speed

#func setshader_blinkintensity(new_value:float):
	#if animated_sprite_2d.material and animated_sprite_2d.material.has_shader_param("blink_intensity"):
		#animated_sprite_2d.material.set_shader_parameter("blink_intensity",new_value)
