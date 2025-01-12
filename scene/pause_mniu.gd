extends Control

# Tracks whether the game is paused
var is_paused: bool = false:
	set = set_paused

# Tracks if the volume settings should be shown
var control_node_hide: bool = false

func _ready() -> void:
	$volume_setting.hide()  # Initially hide the volume settings

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		is_paused = !is_paused  # Toggle the paused state

func _process(delta: float) -> void:
	if control_node_hide:
		$volume_setting.show()

# Sets the paused state and updates the game tree
func set_paused(value: bool) -> void:
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused  # Show/hide this control based on pause state

# Resumes the game
func _on_resume_pressed() -> void:
	is_paused = false

# Shows the settings menu
func _on_setting_pressed() -> void:
	$Control.hide()  # Hide the pause menu
	control_node_hide = true

# Quits the game
func _on_quit_pressed() -> void:
	get_tree().quit()
