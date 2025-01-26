extends Node2D

# References to the player and target
@export var player: NodePath
@export var end_location: NodePath

# Arrow behavior parameters
@export var distance_from_player: float = 100.0
@export var follow_speed: float = 5.0  # Speed for the arrow to catch up
@export var rotation_speed: float = 8.0  # Speed for smooth rotation
@export var float_speed: float = 2.0  # Speed for floating to the endpoint
@export var free_distance: float = 500.0  # Distance threshold for free movement

# Internal variable for the arrow's target position
var target_position: Vector2
var bobbing_offset: float = 0.0  # To control the bobbing motion

func _process(delta):
	# Ensure the player and target nodes are valid
	if not player or not end_location:
		return

	var player_node = get_node(player)
	var end_node = get_node(end_location)

	# Calculate the distance between the player and the end location
	var distance_to_target = player_node.global_position.distance_to(end_node.global_position)

	if distance_to_target <= free_distance:
		# The arrow stops following the player and starts floating towards the end location smoothly
		global_position = global_position.lerp(end_node.global_position, float_speed * delta)

		# Point the arrow at the endpoint
		var direction_to_target = (end_node.global_position - global_position).normalized()
		var target_rotation = direction_to_target.angle()
		rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)

		# Apply smooth bobbing effect
		bobbing_offset = sin(Time.get_ticks_msec() / 150.0) * 6 # Sine wave for smooth up and down motion
		global_position.y += bobbing_offset
	else:
		# Calculate the direction vector
		var direction = (end_node.global_position - player_node.global_position).normalized()

		# Calculate the target position for the arrow (100 pixels away from the player)
		target_position = player_node.global_position + direction * distance_from_player

		# Smoothly move the arrow towards the target position
		global_position = global_position.lerp(target_position, follow_speed * delta)

		# Smoothly rotate the arrow to point toward the target
		var target_rotation = direction.angle()
		rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)
