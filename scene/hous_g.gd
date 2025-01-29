extends Node2D

@export var player: Node2D = null
@export var enemy: PackedScene
@onready var timer: Timer = $Timer
@onready var spawn_marker: Marker2D = $Marker2D  # Reference to the spawn position

var enemy_count: int = 0  # Counter for the number of spawned enemies
@export var max_enemies: int = 3  # Maximum number of enemies allowed

func _ready() -> void:

	# Ensure the timer is connected
	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)


	# Check if the timer has a valid wait time
	if timer.wait_time <= 0:
		timer.wait_time = 1.0  # Ensure it has a valid wait time



func _on_area_2d_body_entered(body: Node2D) -> void:

	if body.is_in_group("player"):

		if enemy_count < max_enemies:
			timer.start()


func _on_area_2d_body_exited(body: Node2D) -> void:

	if body.is_in_group("player"):
		timer.stop()

func _on_timer_timeout() -> void:

	if enemy_count >= max_enemies:
		timer.stop()
		return

	if enemy and spawn_marker:
		var new_enemy = enemy.instantiate()
		add_child(new_enemy)

		# Set enemy position
		new_enemy.global_position = spawn_marker.global_position

		# Increment the enemy count
		enemy_count += 1

		# Connect enemy removal signal
		new_enemy.tree_exited.connect(_on_enemy_removed)


func _on_enemy_removed() -> void:

	enemy_count -= 1

	if enemy_count < max_enemies:
		if player in $Area2D.get_overlapping_bodies():
			 
			timer.start()
