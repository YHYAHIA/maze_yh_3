extends "res://gd/interactable.gd"

var collected_key = 0

@export var is_open = true:
	set(value):
		if is_open == value:
			return
		is_open = value
		_update_animations()
		_update_label()

@export var anim: AnimatedSprite2D:
	set(value):
		anim = value
		_update_animations()

@export_group("animation names")
@export var open_anim: StringName = "open"
@export var closed_anim: StringName = "closed"

var door_open: bool
var locked = true


@onready var collision_polygon_2d: CollisionShape2D = $"../Camera2D/CollisionPolygon2D"
@onready var collision = $CollisionShape2D
@onready var status_label: Label = $"../Label"
@onready var fade_timer: Timer = $"../fade_Timer"

func interact(_user: Node2D):
	if not locked:
		is_open = not is_open
		_update_label()
		return
	
	if GlobalInteract.key_amount > 0:
		GlobalInteract.key_amount -= 1
		locked = false
		is_open = true
		print("Door unlocked!")
	else:
		print("The door is locked. You need a key!")
		_update_label()

func _update_animations():
	if anim != null:
		if is_open:
			anim.play(open_anim)
			if collision_polygon_2d != null:
				collision_polygon_2d.set_disabled(true)
				
			else:
				print("CollisionPolygon2D is null. Check the node path or scene setup.")
		else:
			anim.play(closed_anim)
			if collision_polygon_2d != null:
				collision_polygon_2d.set_disabled(false)

			else:
				print("CollisionPolygon2D is null. Check the node path or scene setup.")

func _update_label():
	if status_label != null:
		if locked:
			status_label.text = "The door is locked. You need a key!"
		elif is_open:
			status_label.text = "The door is open."
		else:
			status_label.text = "The door is closed."
		status_label.show()
		fade_timer.start()



func stop_interaction(_user: Node2D):
	if collision_polygon_2d != null:
		collision_polygon_2d.set_deferred("disabled", false)
	else:
		print("CollisionPolygon2D is null. Check the node path or scene setup.")
	anim.play(closed_anim)
	is_open = false
	_update_label()


func _on_fade_timer_timeout() -> void:
	if status_label != null:
		status_label.hide()
	 # Replace with function body.
