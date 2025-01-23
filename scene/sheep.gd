extends Node2D


@onready var timer: Timer = $"../Timer"
var is_dead: bool = false  # Tracks if the sheep is dead
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var player: Node2D = null  # Assign the player node in the editor or dynamically
var facing_left: bool = false
# Signal to notify meat about sheep's death
signal sheep_died
func _ready() -> void:
	# You can initialize any setup here if needed
	pass

# Update the sheep's facing direction based on the player's position
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.global_position.x < global_position.x:
			facing_left = true
			anim.play("h_sheep_left")
			print("h_left")
		elif body.global_position.x > global_position.x:
			facing_left = false
			anim.play("h_sheep_right")
			print("h_right")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.global_position.x < global_position.x:
			facing_left = true
			anim.play("idle_left")
			print("left")
		elif body.global_position.x > global_position.x:
			facing_left = false
			anim.play("idle_right")
			print("right")

# Called when the player interacts with the sheep



# Timer timeout logic
func _on_timer_timeout() -> void:
	is_dead = false  # Reset local state if needed
	pass

# Handle sheep death
func die():
	is_dead = true
	emit_signal("sheep_died")  # Notify meat
	queue_free()  # Remove the sheep from the scene
