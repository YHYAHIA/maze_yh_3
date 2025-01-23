extends "res://gd/interactable.gd"


@onready var gold_mine: Node2D = $".."
@onready var coll: CollisionShape2D = $CollisionShape2D

signal action

func interact(_user: Node2D):
	emit_signal("action")
	gold_mine.interact()  # Call interact on the gold mine

func stop_interaction(_user: Node2D):
	coll.set_deferred("disable",true)
