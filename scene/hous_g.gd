extends Node2D

@export var player: Node2D = null
@export var enemy: PackedScene
@onready var timer: Timer = $Timer
@onready var spawn_marker: Marker2D = $Marker2D  # Reference to the spawn position

var enemy_count: int = 0  # Counter for the number of spawned enemies
@export var max_enemies: int = 3  # Maximum number of enemies allowed

func _ready() -> void:
	# Connect the timer's timeout signal to the instantiation function
	timer.timeout.connect(_on_timer_timeout)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		if enemy_count < max_enemies:
			timer.start()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		timer.stop()

func _on_timer_timeout() -> void:
	if enemy_count >= max_enemies:
		timer.stop()
		return

	if enemy and spawn_marker:
		# Instantiate the enemy and add it to the scene
		var new_enemy = enemy.instantiate()
		add_child(new_enemy)

		# Set the spawn position to the Marker2D's position
		new_enemy.global_position = spawn_marker.global_position

		# Assign the player to the enemy if the enemy script has a "player" property
		if new_enemy is CharacterBody2D and new_enemy.get_script().has_method("set_player"):
			new_enemy.set("player", player)

		# Increment the enemy count
		enemy_count += 1

		# Connect the enemy's `queue_free` signal to decrease the count when it's removed
		#new_enemy.queue_free.connect(_on_enemy_removed)

#func _on_enemy_removed() -> void:
	# Decrement the enemy count when an enemy is removed
	#enemy_count -= 1
	#if enemy_count < max_enemies and player in $Area2D.get_overlapping_bodies():
		#timer.start()
