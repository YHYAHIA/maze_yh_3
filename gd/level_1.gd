extends Node2D

# Exported player NodePath for easy assignment in the editor
@export var player: NodePath

# Reference to the SaveSystem script
@onready var save_system = preload("res://gd/global/SaveSystem.gd").new()

# Define the level name explicitly
@export var level_name: String = "level_1"

# Reference to the target node the player must reach
@onready var target_node: Node2D = $Node2D2

func _ready() -> void:
	# Play the level's audio when the scene starts
	$AudioStreamPlayer2D2.play()

func _process(delta: float) -> void:
	# Ensure the player node exists before checking its position
	if not player or not target_node:
		return
	
	var player_node = get_node(player)
	if player_node.global_position.distance_to(target_node.global_position) < 50:  # Tolerance for collision
		complete_level()
		# Optionally stop further checks after level completion
		set_process(false)

# Call this when the level is completed
func complete_level() -> void:
	SaveSystem.save_level(level_name)
	print("Level completed: ", level_name)

	# Optionally transition to the next scene or level selection
	# Example: get_tree().change_scene_to_file("res://scene/level_selection.tscn")
