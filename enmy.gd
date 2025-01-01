extends CharacterBody2D
const SPEED = 100

@export var player: Node2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var is_attacking: bool = false
var is_facing_left: bool = false

func _ready() -> void:
	# Initialize the navigation agent
	timer.start()

func _physics_process(delta: float) -> void:
	# Handle movement only if not attacking
	if not is_attacking:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * SPEED

		# Update animations based on movement direction
		if velocity.length() > 0:
			if velocity.x < 0:
				if not is_facing_left:
					is_facing_left = true
					$AnimatedSprite2D.flip_h = true
				anim.play("run_left")
			elif velocity.x > 0:
				if is_facing_left:
					is_facing_left = false
					$AnimatedSprite2D.flip_h = false
				anim.play("run")
			else:
				anim.play("run")
		else:
			anim.play("idle")

		# Move the character
		move_and_slide()

func makepath() -> void:
	# Update the navigation agent's target position
	nav_agent.target_position = player.global_position

func _on_timer_timeout() -> void:
	# Update path periodically
	if not is_attacking:
		makepath()

func _on_area_2d_body_entered(body: Node2D) -> void:
	# Handle player entering detection area
	if body == player:
		makepath()
	else:
		timer.stop()

func _on_area_2d_body_exited(body: Node2D) -> void:
	# Handle player exiting detection area
	if body == player:
		velocity = Vector2.ZERO
		timer.stop()
		anim.play("idle")

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	# Handle player entering attack area
	if body == player:
		is_attacking = true
		anim.play("attack")
		velocity = Vector2.ZERO  # Stop movement during attack

func _on_area_2d_2_body_exited(body: Node2D) -> void:
	# Handle player exiting attack area
	if body == player:
		is_attacking = false
		anim.play("idle")
