extends Node2D

# References to the player and mission locations
@export var player: NodePath
@export var missions: Array[NodePath] = []  # List of mission locations
@onready var sprite: Sprite2D = $Sprite2D2

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
var current_mission_index: int = 0  # Tracks the current mission

func _ready():
	player_last_position = Vector2.ZERO

func _process(delta):
	# Ensure the player and mission nodes are valid
	if not player or missions.size() == 0:
		return

	var player_node = get_node(player)
	var current_mission_node = get_current_mission_node()

	if not current_mission_node:
		return

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

	# Check mission completion
	check_mission_completion(player_node)

	# Behavior when close to the mission location
	var distance_to_target = player_node.global_position.distance_to(current_mission_node.global_position)
	if distance_to_target <= hide_distance:
		show_pointer(current_mission_node)
	else:
		show_arrow(current_mission_node)
		follow_player(player_node, current_mission_node, delta)

func get_current_mission_node() -> Node:
	if missions.size() > current_mission_index:
		return get_node(missions[current_mission_index])
	return null

func check_mission_completion(player_node):
	var current_mission_node = get_current_mission_node()
	if current_mission_node and player_node.global_position.distance_to(current_mission_node.global_position) <= hide_distance:
		complete_current_mission()

func complete_current_mission():
	# Get the current mission node
	var current_mission_node = get_current_mission_node()
	if not current_mission_node:
		return

	# Trigger mission-specific logic if the node has a script
	if current_mission_node.get_script() != null:
		if current_mission_node.has_method("on_mission_complete"):
			current_mission_node.call("on_mission_complete")
		else:
			print("Mission node has a script but no 'on_mission_complete' method.")
	else:
		print("Mission node has no script attached.")

	# General mission completion logic
	print("Mission", current_mission_index + 1, "completed!")

	# Move to the next mission
	current_mission_index += 1

	# Check if all missions are completed
	if current_mission_index >= missions.size():
		handle_all_missions_completed()
	else:
		print("Next mission unlocked!")

func handle_all_missions_completed():
	print("All missions completed! Congratulations!")
	#sprite.hide()  # Hide the arrow
	# Example: Show a victory screen or restart the game
	#var ui = get_node("Path/To/UI")
	#ui.show_victory_screen()

func follow_player(player_node, mission_node, delta):
	# Calculate the direction vector
	var direction = (mission_node.global_position - player_node.global_position).normalized()

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

# Show the pointer scene when the player is close to the mission location
func show_pointer(mission_node):
	if pointer_instance == null:
		pointer_instance = POINTER.instantiate()
		get_parent().add_child(pointer_instance)

	# Set the pointer's global position to the mission node's position
	pointer_instance.global_position = mission_node.global_position
	# Hide the arrow
	sprite.hide()  # Removes the arrow from the scene

# Show the arrow again and remove the pointer when the player is far enough
func show_arrow(mission_node):
	if pointer_instance != null:
		pointer_instance.queue_free()  # Remove the pointer scene
		pointer_instance = null

	# Ensure the arrow is visible and positioned correctly
	sprite.show()
