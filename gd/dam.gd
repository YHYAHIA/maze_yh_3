extends Area2D





func _on_body_entered(body: Node2D) -> void:
	# Check if the body is the player
	if body.is_in_group("player"):
		# Start the timer to apply periodic damage
		$Timer.start()
		# Apply immediate damage when entering the area
		body.health -= 10
		print("Player entered the area! Health reduced by 10.")

#func _on_Timer_timeout() -> void:
	# Called every time the timer times out
	#var player = get_node_or_null("../Player")  # Adjust the path to your player node
	#if player and player.is_in_group("player"):
		#player.health -= 10
		#print("Timer damage applied! Health reduced by 10.")
	 # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	print("d")
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	var player = get_node_or_null("../player1")  # Adjust the path to your player node
	if player and player.is_in_group("player"):
		player.health -= 10
		print("Timer damage applied! Health reduced by 10.")
	pass # Replace with function body.
