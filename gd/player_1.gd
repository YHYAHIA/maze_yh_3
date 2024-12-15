extends CharacterBody2D


var health =100

#var looking=Vector2.ZERO

var speed=300
func handled_input():
	var direction = Input.get_vector("left","right","up","down")
	velocity=direction*speed
func updateanmition():
	if velocity.length() ==0:
		$AnimatedSprite2D.stop()
	else :
		if velocity.x<0:
			
			$AnimatedSprite2D.play("move_left")
		if velocity.x>0:
			
			$AnimatedSprite2D.play("move_right")
		if velocity.y <0:
			
			$AnimatedSprite2D.play("move_up")
		if velocity.y>0:
			
			$AnimatedSprite2D.play("move_down")
		

			#var animdirection = velocity.zero
		#if velocity.x < 0:animdirection = $AnimatedSprite2D.play("move_left")
		#else :
			#pass
			
		#elif velocity.x >0 :animdirection = $AnimatedSprite2D.play("move_right")
		#elif velocity.y <0 :animdirection = $AnimatedSprite2D.play("move_up")
		#elif velocity.y >0 :animdirection = $AnimatedSprite2D.play("move_down")
	
	
func _physics_process(_delta):
	#if velocity.x<0:
		#velocity.y =0
	#if velocity.x>0:
	#	velocity.y =0
	#if velocity.y<0:
	#	velocity.x=0
	#if velocity.y>0:
	#	velocity.x=0
	
	
	
		handled_input()
		move_and_slide()
		updateanmition()
		velocity=velocity.normalized()
		
		
func _process(delta: float) -> void:
	$ProgressBar.max_value = health
	
#func _on_exit_body_entered(body: Node2D) -> void:
	#pass # Replace with function body.


#func _on_texture_button_2_pressed() -> void:
	#get_tree().change_scene_to_file("res://scene/start.tscn")
	#pass # Replace with function body.


#func _on_flor_dc_tree_entered() -> void:
	#if body.is_in_group("player"):
	#	if velocity.x >0 :velocity.y+=speed/1.3
		#elif  velocity.x <0 : velocity.y -=speed/1.3
		
	
	
	
	#pass # Replace with function body.


#func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body: is_in_group("player")
		#set_velocity(velocity.y/1.3)
	
	 
	
 # Replace with function body.
