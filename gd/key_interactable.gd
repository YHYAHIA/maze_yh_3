extends "res://gd/interactable.gd"

class_name door_keys



@onready var key: Node2D = $".."


func interact(_user: Node2D):
	GlobalInteract.collectedKeys += 1;
	key.queue_free()
	push_warning("not_implemented")
	
	
func stop_interaction(_user : Node2D):
	push_warning("not_implemented")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if GlobalInteract.is_pox_open == false:
		key.hide()
		#print("-1")
	if GlobalInteract.is_pox_open == true:
		key.show()
		#print("+1")
		
		
		
	
		
	
