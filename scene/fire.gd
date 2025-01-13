extends Area2D


@export var duration: float = 1.0  # How long the fire lasts
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim.play("fire_" + get_current_direction())
	yield(get_tree().create_timer(duration), "timeout")
	queue_free()

func get_current_direction() -> String:
	# This function can determine the direction based on the rotation or other logic
	return "up"  # Example default, update as needed
