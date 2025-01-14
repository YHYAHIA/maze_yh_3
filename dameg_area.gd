extends Area2D


@export var erea_damage : int = 10


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("set_health"):  # Ensure the player has a health setter
			body.set_health(body.get_health()-erea_damage)  # Apply damage
			print("Player hit! Damage:", erea_damage)
			pass
				
	 # Replace with function body.






func _on_dameg_area_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
