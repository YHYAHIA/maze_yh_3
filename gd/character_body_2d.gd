extends CharacterBody2D


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
	
	
func _physics_process(delta):
	
		handled_input()
		move_and_slide()
		updateanmition()
		velocity=velocity.normalized()
