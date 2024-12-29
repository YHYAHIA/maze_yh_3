extends "res://gd/interactable.gd"

@export var is_open = false:  # Default to closed
	set(value):
		if is_open == value:
			return
		is_open = value
		_update_animations()

@export var anim: AnimatedSprite2D:
	set(value):
		anim = value
		_update_animations()

@export_group("Animation Names")
@export var open_anim: StringName = "open"
@export var closed_anim: StringName = "closed"

@onready var collision = $CollisionShape2D  # Collision shape for the box
@onready var key = "res://scene/key.tscn" # Reference to the key scene (ensure the node path is correct)


func interact(_user: Node2D):
	# Toggle the box state
	is_open = not is_open
	if is_open:
		print("The box is now open.")
	else:
		print("The box is now closed.")

func _update_animations():
	# Update animations based on the `is_open` state
	if anim != null:
		if is_open:
			anim.play(open_anim)
			GlobalInteract.is_pox_open += 1
			# Optionally disable collision when open
			#collision.set_disabled(true)
			# Show the key when the box is open
			#if key != null:
				#key.set_v()
		else:
			anim.play(closed_anim)
			GlobalInteract.is_pox_open -= 1
			# Re-enable collision when closed
			#collision.set_deferred("disabled",false)
			# Hide the key when the box is closed
		#	if key != null:
				#key.hide()

func stop_interaction(_user: Node2D):
	pass
	# Reset the box to the closed state
	#is_open = false
	#_update_animations()
	#print("Interaction stopped. The box is now closed.")
