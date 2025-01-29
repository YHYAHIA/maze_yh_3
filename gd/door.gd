extends Node2D


@onready var is_completed :bool = false

func is_mission_completed() -> bool:
	return is_completed
	
func on_item_collected():
	is_completed = true
	print("Item collected! Mission completed.")
