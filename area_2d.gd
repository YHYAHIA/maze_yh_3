extends "res://gd/interactable.gd"
class_name Resorses1

@export var item_type: String = "meet"  # Type of item (e.g., gold, meet, wood)
@export var amount: int = 1  # Amount to add
@export var player: CharacterBody2D = null  # Reference to the player
@onready var anim: AnimationPlayer = $AnimationPlayer


var animation_played: bool = false  # Flag to track if the animation has been played

func interact(_user: Node2D):
	# Add the item to the global inventory and remove it from the scene
	GlobalInteract.add_item(item_type, amount)
	queue_free()


func stop_interaction(_user: Node2D):
	# Define behavior for stopping interaction (optional)
	pass

func _process(_delta: float) -> void:
	if GlobalInteract.sheep_dead:
		if not is_visible():
			show()  # Show the item if it was hidden
		
		# Play the animation only once
		if not animation_played:
			anim.play("dead")
			animation_played = true
	else:
		if is_visible():
			hide()  # Hide the item if the sheep is not dead
		animation_played = false  # Reset the flag if sheep_dead becomes false
