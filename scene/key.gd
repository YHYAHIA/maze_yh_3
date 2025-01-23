extends "res://gd/interactable.gd"

class_name door_keys

@export var item_type: String = "key"  # Type of item (gold, meet, wood)
@export var amount: int = 1  # Amount to add




func interact(_user: Node2D):
	GlobalInteract.add_item(item_type, amount)
	queue_free()
	
	
	
func stop_interaction(_user : Node2D):
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if GlobalInteract.is_pox_open == false:
		hide()
		#print("-1")
	if GlobalInteract.is_pox_open == true:
		show()
		#print("+1")
		
		
		
	
		
	
