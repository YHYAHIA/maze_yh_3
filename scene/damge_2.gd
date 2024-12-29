extends Area2D





func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.health -=100
		print("p")
	 # Replace with function body.


func _on_body_exited(_body: Node2D) -> void:
	print("d")
	pass # Replace with function body.
