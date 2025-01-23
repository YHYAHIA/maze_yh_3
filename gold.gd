extends "res://gd/interactable.gd"
class_name Resources

@export var item_type: String = "gold"  # Type of item (gold, meat, wood)
@export var amount: int = 1  # Amount to add
@export var gold_mine: Node2D = null  # Reference to the gold mine node

@onready var coll: CollisionShape2D = $CollisionShape2D
@onready var anim: AnimationPlayer = $AnimationPlayer

var animation_played: bool = false

func _ready() -> void:
	# Ensure the collision shape is initially disabled
	coll.disabled = true

	# Connect to the gold mine's "destroyed" signal if it exists
	if gold_mine and gold_mine.has_signal("destroyed"):
		if not gold_mine.is_connected("destroyed", Callable(self, "_on_gold_mine_destroyed")):
			gold_mine.connect("destroyed", Callable(self, "_on_gold_mine_destroyed"))
			print("Connected to gold mine's destroyed signal.")  # Debugging message
	else:
		print("Gold mine or destroyed signal not found.")  # Debugging message

func _on_gold_mine_destroyed() -> void:
	if animation_played:
		print("Gold animation already played. Ignoring repeated signal.")  # Debugging message
		return

	# Enable the collision shape and show the resource node
	print("Gold mine destroyed. Resources are now available.")  # Debugging message
	coll.set_deferred("disabled", false)  # Enable the collision shape
	show()  # Make the resource node visible

	# Play the animation once
	print("Playing gold animation.")  # Debugging message
	anim.play("gold")
	animation_played = true

func interact(_user: Node2D):
	# Add the item to the global inventory and remove the resource node
	GlobalInteract.add_item(item_type, amount)
	print("Added ", amount, " of ", item_type, " to inventory.")  # Debugging message
	queue_free()  # Remove the resource from the scene

func stop_interaction(_user: Node2D):
	# Functionality for stopping interaction (if needed in the future)
	pass
