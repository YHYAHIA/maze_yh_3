extends "res://gd/interactable.gd"
class_name resorses1
@export var item_type: String = "meet"  # Type of item (gold, meet, wood)
@export var amount: int = 1  # Amount to add
@export var player :CharacterBody2D = null
func interact(_user: Node2D):
	GlobalInteract.add_item(item_type, amount)
	player.health += 10
	
	queue_free()  # Remove the item from the scene
func stop_interaction(_user : Node2D):
	pass
