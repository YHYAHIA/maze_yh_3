class_name dy_npc_interactable


extends interactable


@onready var nbc: Node2D = $".."



@export var dy_ui :Control

	
func _ready() -> void:
	dy_ui.hide()

func interact(_user: Node2D):
	dy_ui.show()
	nbc.call("on_item_collected")
	
func stop_interaction(_user : Node2D):
	dy_ui.hide()
