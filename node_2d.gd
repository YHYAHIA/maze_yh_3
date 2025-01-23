extends Node2D

@onready var area: Area2D = $Area2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var coll: CollisionShape2D = $Area2D/CollisionShape2D

var interaction_count: int = 0
var max_interactions: int = 3

signal destroyed

func _ready():
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.stop()  # Ensure the timer is stopped at the start
	  # Debug

# Function to handle interactions
func interact():
	interaction_count += 1
	

	if interaction_count < max_interactions:
		anim.play("active")
		timer.start()  # Start the timer to play the "active" animation for 0.3 seconds
	elif interaction_count == max_interactions:
		play_destroyed_animation()

# Function to play the destroyed animation and stop interaction
func play_destroyed_animation():
	  # Debug
	anim.play("destroyed")
	emit_signal("destroyed")
	  # Debug
	
	# Disable further interactions by disabling the collision shape
	coll.disabled = true  # This disables the collision shape, preventing further interaction

func _on_timer_timeout():
	if interaction_count < max_interactions:
		anim.play("idle")  # Play idle animation after 0.3 seconds
	else:
		 # Debug
		anim.play("destroyed")  # Keep in idle animation after being destroyed
