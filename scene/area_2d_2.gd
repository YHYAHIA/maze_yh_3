extends "res://gd/interactable.gd"
@onready var sheep: Node2D = $".."
@onready var timer: Timer = $"../Timer"


func interact(_user: Node2D):
	sheep.die()
	GlobalInteract.sheep_dead = true
	timer.start()
	print("true")

func stop_interaction(_user: Node2D):
	pass
	
func _on_timer_timeout() -> void:
	GlobalInteract.sheep_dead = false
	pass
	
