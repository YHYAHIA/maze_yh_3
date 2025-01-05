extends Area2D

@export var speed_modifier: float = 0.5  # Speed adjustment percentage (e.g., 0.1 for 10%)
@onready var player: Node2D = $"../../player1"

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		# Reduce the player's speed by the percentage
		if body.has_method("set_speed"):
			body.set_speed(body.speed * (1 - speed_modifier))

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		# Restore the player's speed by reversing the percentage reduction
		if body.has_method("set_speed"):
			body.set_speed(body.speed / (1 - speed_modifier))
