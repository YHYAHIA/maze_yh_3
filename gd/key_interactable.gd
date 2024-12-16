extends "res://gd/interactable.gd"

class_name door_keys



@onready var key: Node2D = $".."


func interact(user: Node2D):
	
	key.queue_free()
	push_warning("not_implemented")
	
	
func stop_interaction(user : Node2D):
	push_warning("not_implemented")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
