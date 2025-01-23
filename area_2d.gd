extends "res://gd/interactable.gd"
class_name Resorses1

@export var item_type: String = "meet"  # Type of item (e.g., gold, meet, wood)
@export var amount: int = 1  # Amount to add
@export var associated_sheep: Area2D = null  # Reference to the specific sheep
@onready var coll: CollisionShape2D = $CollisionShape2D
@onready var anim: AnimationPlayer = $AnimationPlayer

var animation_played: bool = false  # Flag to track if the animation has been played

func interact(_user: Node2D):
	# Add the item to the global inventory and remove it from the scene
	GlobalInteract.add_item(item_type, amount)
	queue_free()

func stop_interaction(_user: Node2D):
	pass

func _process(_delta: float) -> void:
	# Ensure the associated sheep exists
	if associated_sheep is Node2D and associated_sheep.has_variable("is_dead") and associated_sheep.is_dead:
		if not is_visible():
			coll.set_deferred("disabled", false)
			show()  # Show the item if it was hidden

		# Play the animation only once
		if not animation_played:
			anim.play("dead")
			animation_played = true
	else:
		if is_visible():
			coll.set_deferred("disabled", true)
			hide()  # Hide the item if the sheep is not dead
		animation_played = false  # Reset the flag if the sheep becomes alive again
