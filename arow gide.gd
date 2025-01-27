extends Node2D

# References to the player and target
@export var player: NodePath
@export var end_location: NodePath
@onready var sprite: Sprite2D = $Sprite2D

# Arrow behavior parameters
@export var distance_from_player: float = 100.0
@export var follow_speed: float = 5.0  # Speed for the arrow to catch up
@export var rotation_speed: float = 8.0  # Speed for smooth rotation

@export var hide_distance: float = 50.0  # Distance threshold for stopping follow
@export var idle_time_threshold: float = 3.0  # Time before nudging the player
const POINTER = preload("res://scene/pointer.tscn")

# Internal variables
var target_position: Vector2
var bobbing_offset: float = 0.0  # To control the bobbing motion
var player_last_position: Vector2
var idle_timer: float = 0.0
var pointer_instance: Node2D = null  # Pointer scene instance

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
		idle_arrow_motion(delta)
		return

	# Behavior when close to the end location
	if distance_to_target <= hide_distance:
		# Show the pointer scene at the end node's position
		show_pointer(end_node)
	elif distance_to_target > hide_distance:
		# Player is far enough from the end location, show the arrow again
		show_arrow(end_node)
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

# Oscillate the arrow when idle
func idle_arrow_motion(delta):
	if player_last_position == get_node(player).global_position:
		var oscillation_amplitude = 20.0  # How much the arrow moves back and forth
		var oscillation_speed = 2.0  # Speed of the oscillation
		bobbing_offset = sin(Time.get_ticks_msec() / (1000.0 / oscillation_speed)) * oscillation_amplitude
		global_position.x = get_node(player).global_position.x + bobbing_offset

# Show the pointer scene when the player is close to the end location
func show_pointer(end_node):
	if pointer_instance == null:
		pointer_instance = POINTER.instantiate()
		get_parent().add_child(pointer_instance)
	
	# Set the pointer's global position to the end node's position
	pointer_instance.global_position = end_node.global_position
	# Hide the arrow
	sprite.hide() # Removes the arrow from the scene

# Show the arrow again and remove the pointer when the player is far enough
func show_arrow(end_node):
	if pointer_instance != null:
		pointer_instance.queue_free()  # Remove the pointer scene
		pointer_instance = null

	# Ensure the arrow is visible and positioned correctly
	sprite.show()
