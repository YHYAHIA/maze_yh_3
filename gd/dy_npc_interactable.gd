class_name dy_npc_interactable


extends interactable


	

@export var dy_ui :Control

	
func _ready() -> void:
	dy_ui.hide()

func interact(_user: Node2D):
	dy_ui.show()
	
	
func stop_interaction(_user : Node2D):
	dy_ui.hide()
