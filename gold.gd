
extends "res://gd/interactable.gd"
class_name resorses
@export var item_type: String = "gold"  # Type of item (gold, meet, wood)
@export var amount: int = 1  # Amount to add

func interact(_user: Node2D):
	GlobalInteract.add_item(item_type, amount)
	queue_free()  # Remove the item from the scene
func stop_interaction(_user : Node2D):
	pass
