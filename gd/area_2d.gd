extends Area2D

@export var speed_modifier: float = 0.5  # Speed adjustment percentage (e.g., 0.1 for 10%)
@export var player: Node2D
var dir = Vector2.ZERO
func _on_body_entered(body: Node2D) -> void:
	if body == player:
		# Reduce the player's speed by the percentage
		if body.has_method("set_speed"):
			body.set_speed(body.speed * (1 - speed_modifier))
		if player.dir.x < 0:
			player.velocity.y +=player.speed /1.3
		elif player.dir.x > 0:
			player.velocity.y -= player.speed/1.3

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		# Restore the player's speed by reversing the percentage reduction
		if body.has_method("set_speed"):
			body.set_speed(body.speed / (1 - speed_modifier))
