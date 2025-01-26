extends Control

# Signals for better communication


# Use an enum for state management
enum MenuState {PAUSE_MENU, VOLUME_SETTINGS, HIDDEN}
@onready var control_1: Control = $Control
@onready var volume_setting: Control = $volume_setting

# Current menu state
var current_state = MenuState.HIDDEN
var previous_volume: float = 0

func _ready():
	hide_all_menus()  # Ensure the entire menu is hidden initially

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	if current_state == MenuState.HIDDEN:
		show_pause_menu()
	else:
		hide_all_menus()

func show_pause_menu():
	# Show the pause menu with the control node visible
	show()
	control_1.show()
	volume_setting.hide()
	current_state = MenuState.PAUSE_MENU
	get_tree().paused = true
	

func show_volume_settings():
	# Show the volume settings menu
	control_1.hide()
	volume_setting.show()
	current_state = MenuState.VOLUME_SETTINGS

func hide_all_menus():
	# Hide all menus and unpause the game
	hide()
	control_1.hide()
	volume_setting.hide()
	current_state = MenuState.HIDDEN
	get_tree().paused = false
	

func _on_resume_pressed():
	# Unpause and hide the menu
	hide_all_menus()

func _on_setting_pressed():
	# Show the volume settings menu
	show_volume_settings()

func _on_quit_pressed():
	# Quit the game
	get_tree().quit()

func _on_volume_value_changed(value: float):
	# Update the volume within a valid range
	
	AudioServer.set_bus_volume_db(0, value)

func _on_mute_toggled(toggled_on: bool):
	# Mute or unmute the audio
	if toggled_on:
		previous_volume = AudioServer.get_bus_volume_db(0)
		AudioServer.set_bus_volume_db(0, -80)  # Mute
	else:
		AudioServer.set_bus_volume_db(0, previous_volume)  # Restore previous volume




func _on_voluem_setting_back_pressed() -> void:
	hide_all_menus()
	# Replace with function body.


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/start.tscn")#go pack to home 
	
	
