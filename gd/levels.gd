extends Control



# Reference to the save system
@onready var save_system = preload("res://gd/global/SaveSystem.gd").new()

# List of level buttons (add all your level buttons here)
@onready var level_buttons = {

	"Level2": $CanvasLayer/MarginContainer/GridContainer/level2,
	"Level3": $CanvasLayer/MarginContainer/GridContainer/level3,
	"Level4": $CanvasLayer/MarginContainer/GridContainer/level4,
	"Level5": $CanvasLayer/MarginContainer/GridContainer/level5,
	"Level6": $CanvasLayer/MarginContainer/GridContainer/level6,
	"Level7": $CanvasLayer/MarginContainer/GridContainer/level7,
	"Level8": $CanvasLayer/MarginContainer/GridContainer/level8,

}

func _ready() -> void:
	update_level_buttons()

# Updates the state of level buttons based on completed levels
func update_level_buttons() -> void:
	var completed_levels = SaveSystem.load_completed_levels()
	for level_name in level_buttons.keys():
		var button = level_buttons[level_name]
		if level_name in completed_levels:
			button.disabled = false  # Enable button if level is completed
		else:
				button.disabled = true  # Disable button if level is not completed



func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/level_1.tscn")
	 # Replace with function body.


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/level_2.tscn")
	 # Replace with function body.


func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/level_3.tscn")
	 # Replace with function body.


func _on_level_4_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/level_4.tscn")
	# Replace with function body.


func _on_level_5_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/level_5.tscn")
	 # Replace with function body.


func _on_level_6_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/level_6.tscn")
	 # Replace with function body.


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/start.tscn")
	 # Replace with function body.


func _on_level_7_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/level_7.tscn")
	pass # Replace with function body.


func _on_level_8_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/level_8.tscn")
	pass # Replace with function body.


func _on_level_9_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/level_9.tscn")
	pass # Replace with function body.
