extends Area2D


@export var erea_damage : int = 10


func _on_body_entered(body: Node2D) -> void:
	# Check if the body is the player
	if body.is_in_group("player"):
		if body.has_method("set_health"):
		# Start the timer to apply periodic damage
			$Timer.start()
			body.set_health(body.get_health()-erea_damage)
			GlobalInteract.plyer_geting_damge =true
		# Apply immediate damage when entering the area
			body.health -= 10
		
			print("Player hit! Damage:", erea_damage)

func _on_Timer_timeout() -> void:
	# Called every time the timer times out
	var player = get_node_or_null("../Player")  # Adjust the path to your player node
	if player.is_in_group("player"):
		player.health -= 10
		print("Timer damage applied! Health reduced by 10.")
	 # Replace with function body.


func _on_body_exited(_body: Node2D) -> void:
	$Timer.stop()
	GlobalInteract.plyer_geting_damge =false
	print()
	 # Replace with function body.
