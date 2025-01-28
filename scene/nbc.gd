extends Node2D



var is_completed: bool = false

# Called to check if the mission is completed
func is_mission_completed() -> bool:
	return is_completed

# Custom logic: Mark mission as completed when the player collects an item
func on_item_collected():
	is_completed = true
	print("Item collected! Mission completed.")
