extends "res://gd/interactable.gd"
@onready var sheep: Node2D = $".."


func interact(_user: Node2D):
	sheep.queue_free()
	GlobalInteract.sheep_dead = true
	print("true")

func stop_interaction(_user: Node2D):
	pass
	
func _on_timer_timeout() -> void:
	
	pass
	
