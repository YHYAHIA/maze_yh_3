extends RigidBody2D

@export var speed: float = 200  # Speed of the arrow
@export var lifespan: float = 10
  # Arrow exists for 3 seconds
@export var arrow_damage: int = 10  # Damage dealt by the arrow
var direction: Vector2 = Vector2.ZERO  # Direction of the arrow

func _ready() -> void:
	# Destroy the arrow after its lifespan
	await get_tree().create_timer(lifespan).timeout
	queue_free()

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	# Set the linear velocity based on the direction and speed
	var player: CharacterBody2D = get_tree().get_first_node_in_group('player');
	var x = global_position.direction_to(player.global_position)
	direction = (player.global_position - global_position)
	linear_velocity = (x - Vector2(0,0.03)) * speed
	rotation = x.angle()



func _on_tree_exiting() -> void:
	# Optional: Debugging or cleanup logic when the arrow leaves the scene
	pass

func _on_tree_exited() -> void:
	# Optional: Additional cleanup logic
	pass


func _on_tree_entered() -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	# Handle collision with the player
	if body.is_in_group("player"):
		if body.has_method("set_health"):  # Ensure the player has a health setter
			body.set_health(body.get_health() - arrow_damage)  # Apply damage
			print("Player hit! Damage:", arrow_damage)
		queue_free()  # Destroy the arrow after hitting the player

	# Handle collision with obstacles
	elif body.is_in_group("obstacle"):
		
		queue_free()  # Destroy the arrow on impact
	# Handle collision with obstacles
	elif body.is_in_group("obstacle"):
		
		queue_free()  # Destroy the arrow on
	 # Replace with function body.


func _on_area_2d_tree_exiting() -> void:
	pass
	 # Replace with function body.
