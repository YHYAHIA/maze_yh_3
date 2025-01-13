extends CharacterBody2D

@export var attack_damage: int = 30
@export var attack_range: float = 90.0
@export var attack_cooldown: float = 1.5
@export var line_of_fire_scene: PackedScene  # Drag and drop the Line of Fire scene here

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var fire_spawn_points: Dictionary = {
	"up": $SpawnPoints/Up,
	"down": $SpawnPoints/Down,
	"left": $SpawnPoints/Left,
	"right": $SpawnPoints/Right
}

var facing_direction: String = "down"
var is_attacking: bool = false

func _physics_process(delta: float) -> void:
	if not is_attacking:
		move_toward_player()
	move_and_slide()

func move_toward_player() -> void:
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * speed

	if abs(dir.x) > abs(dir.y):
		facing_direction = "right" if dir.x > 0 else "left"
	else:
		facing_direction = "down" if dir.y > 0 else "up"

func attack_player() -> void:
	if is_attacking:
		return
	is_attacking = true
	velocity = Vector2.ZERO

	# Play attack animation
	anim.play("attack_" + facing_direction)
	anim.connect("animation_finished", Callable(self, "_on_attack_animation_finished"))

	# Spawn line of fire
	spawn_line_of_fire()

func spawn_line_of_fire() -> void:
	if not line_of_fire_scene:
		return
	var line_of_fire = line_of_fire_scene.instantiate()
	var spawn_point = fire_spawn_points[facing_direction]
	if spawn_point:
		line_of_fire.global_position = spawn_point.global_position
		get_tree().current_scene.add_child(line_of_fire)

		# Play the correct animation on the line of fire
		if line_of_fire.has_node("AnimationPlayer"):
			var fire_anim = line_of_fire.get_node("AnimationPlayer")
			fire_anim.play("fire_" + facing_direction)

func _on_attack_animation_finished(anim_name: String) -> void:
	if anim_name.begins_with("attack_"):
		is_attacking = false
		anim.disconnect("animation_finished", Callable(self, "_on_attack_animation_finished"))
