extends "res://gd/interactable.gd"
class_name Resorses1

@export var item_type: String = "meet"  # Type of item (e.g., gold, meet, wood)
@export var amount: int = 1  # Amount to add
@export var associated_sheep: Node2D = null  # Reference to the specific sheep
@onready var coll: CollisionShape2D = $CollisionShape2D
@onready var anim: AnimationPlayer = $AnimationPlayer

var animation_played: bool = false  # Flag to track if the animation has been played

func _ready() -> void:
	coll.disabled = true
	# Connect to the sheep's death signal
	if associated_sheep and associated_sheep.has_signal("sheep_died"):
		associated_sheep.connect("sheep_died", Callable(self, "_on_sheep_died"))

func _on_sheep_died() -> void:
	# Trigger meat visibility and animation when the sheep dies
	coll.set_deferred("disabled", false)
	show()
	if not animation_played:
		anim.play("dead")
		animation_played = true

func interact(_user: Node2D):
	# Add the item to the global inventory and remove it from the scene
	GlobalInteract.add_item(item_type, amount)
	queue_free()

func stop_interaction(_user: Node2D):
	pass
