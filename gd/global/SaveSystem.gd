extends Node

var save_path = "user://save_data.cfg"  # Save file location

# Saves the current level and marks it as completed
func save_level(level_name: String) -> void:
	var save_file = ConfigFile.new()
	if save_file.load(save_path) != OK:
		save_file.set_value("progress", "completed_levels", [])  # Initialize if no save exists
	var completed_levels = save_file.get_value("progress", "completed_levels", [])
	if level_name not in completed_levels:
		completed_levels.append(level_name)  # Add level to completed list
	save_file.set_value("progress", "completed_levels", completed_levels)
	save_file.set_value("progress", "current_level", level_name)
	save_file.save(save_path)
	print("Progress saved: ", level_name)

# Loads the list of completed levels
func load_completed_levels() -> Array:
	var save_file = ConfigFile.new()
	if save_file.load(save_path) == OK:
		return save_file.get_value("progress", "completed_levels", [])
	return []  # Return empty list if no save file exists

# Loads the last played level
func load_current_level() -> String:
	var save_file = ConfigFile.new()
	if save_file.load(save_path) == OK:
		return save_file.get_value("progress", "current_level", "Level1")
	return "Level1"  # Default level
