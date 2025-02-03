extends Area2D

const file_start="res://scene/level_"
@export var level_name : String = "Level2"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$"../AudioStreamPlayer2D".play()
		SaveSystem.save_level(level_name)
		var currnt_scene_file=get_tree().current_scene.scene_file_path
		var next_level_numper=currnt_scene_file.to_int()+1
		var next_level_path = file_start+str(next_level_numper)+".tscn"
		TransitionScene.transition()
		await TransitionScene.on_transition_finished
		get_tree().change_scene_to_file(next_level_path)
		#get_tree().change_scene_to_file(next_level_path)
	 # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
