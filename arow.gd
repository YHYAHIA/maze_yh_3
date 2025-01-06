extends RigidBody2D

@export var speed: float = 300
@export var lifespan: float = 3.0  # Time before the arrow disappears
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Queue the arrow for deletion after its lifespan
	await get_tree().create_timer(lifespan).timeout
	queue_free()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Set the linear velocity based on the direction and speed
		linear_velocity = direction * speed

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Ensure the player is in the "player" group
		body.take_damage(10)  # Call a method on the player to apply damage
		queue_free()  # Destroy the arrow on impact
