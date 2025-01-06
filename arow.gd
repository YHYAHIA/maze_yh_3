extends RigidBody2D

@export var speed: float = 300  # Speed of the arrow
@export var lifespan: float = 3.0  # Arrow exists for 3 seconds
var direction: Vector2 = Vector2.ZERO  # Direction of the arrow

func _ready() -> void:
	# Destroy the arrow after its lifespan
	await get_tree().create_timer(lifespan).timeout
	queue_free()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Set the linear velocity based on the direction and speed
	linear_velocity = direction * speed

	rotation = direction.angle()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Check if the collided body is the player
		if body.has_method("set_health"):  # Ensure the player has a health setter
			body.set_health(body.get_health() - 10)  # Apply damage to the player
		queue_free()  # Destroy the arrow
	elif body.is_in_group("obstacle"):  # Optional: Handle collisions with obstacles
		queue_free()  # Destroy the arrow on impact
func _on_tree_exiting() -> void:
	print("Arrow is leaving the scene.")
