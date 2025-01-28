extends Control





func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/level_1.tscn")
	
	 # Replace with function body.




func _on_exit_pressed() -> void:
	get_tree().quit()
	 # Replace with function body.
	
	


func _on_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/levels.tscn")
	 # Replace with function body.


func _on_continue_pressed() -> void:
	pass # Replace with function body.
