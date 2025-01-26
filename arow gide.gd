extends Node2D

# References to the player and target
@export var player: NodePath
@export var end_location: NodePath
@onready var sprite: Sprite2D = $Sprite2D

# Arrow behavior parameters
@export var distance_from_player: float = 100.0
@export var follow_speed: float = 5.0  # Speed for the arrow to catch up
@export var rotation_speed: float = 8.0  # Speed for smooth rotation
@export var float_speed: float = 2.0  # Speed for floating to the endpoint
@export var free_distance: float = 500.0  # Distance threshold for free movement
@export var hide_distance: float = 50.0  # Distance threshold for stopping follow
@export var idle_time_threshold: float = 3.0  # Time before nudging the player

# Internal variables
var target_position: Vector2
var bobbing_offset: float = 0.0  # To control the bobbing motion
var player_last_position: Vector2
var idle_timer: float = 0.0

func _ready():
	player_last_position = Vector2.ZERO

func _process(delta):
	# Ensure the player and target nodes are valid
	if not player or not end_location:
		return

	var player_node = get_node(player)
	var end_node = get_node(end_location)

	# Calculate the distance between the player and the end location
	var distance_to_target = player_node.global_position.distance_to(end_node.global_position)

	# Check if the player is idle
	if player_node.global_position == player_last_position:
		idle_timer += delta
	else:
		idle_timer = 0.0
		player_last_position = player_node.global_position

	# If the player is idle for too long, nudge the arrow
	if idle_timer >= idle_time_threshold:
		nudge_arrow_toward_end(delta, end_node)
		return

	# Behavior when close to the end location
	if distance_to_target <= hide_distance:
		stop_follow_and_bob(end_node, delta)
	elif distance_to_target <= free_distance:
		move_arrow_to_end_location(end_node, delta)
	else:
		follow_player(player_node, end_node, delta)

func follow_player(player_node, end_node, delta):
	# Calculate the direction vector
	var direction = (end_node.global_position - player_node.global_position).normalized()

	# Calculate the target position for the arrow (100 pixels away from the player)
	target_position = player_node.global_position + direction * distance_from_player

	# Smoothly move the arrow towards the target position
	global_position = global_position.lerp(target_position, follow_speed * delta)

	# Smoothly rotate the arrow to point toward the target
	var target_rotation = direction.angle()
	rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)

func move_arrow_to_end_location(end_node, delta):
	# Move the arrow toward the end location smoothly
	global_position = global_position.lerp(end_node.global_position, float_speed * delta)

	# Point the arrow at the end location
	var direction_to_target = (end_node.global_position - global_position).normalized()
	var target_rotation = direction_to_target.angle()
	rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)

func stop_follow_and_bob(end_node, delta):
	# Arrow stops following and performs a top-to-bottom bobbing motion
	var direction_to_target = (end_node.global_position - global_position).normalized()
	var target_rotation = direction_to_target.angle()
	rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)

	# Apply smooth bobbing effect
	bobbing_offset = sin(Time.get_ticks_msec() / 200.0) * 10  # Sine wave for smooth up and down motion
	global_position.y = end_node.global_position.y + bobbing_offset

func nudge_arrow_toward_end(delta, end_node):
	# Slightly nudge the arrow toward the end location
	global_position = global_position.lerp(end_node.global_position, 0.5 * delta)

	# Rotate the arrow to point toward the end location
	var direction_to_target = (end_node.global_position - global_position).normalized()
	var target_rotation = direction_to_target.angle()
	rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)
