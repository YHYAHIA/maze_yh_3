extends Control

@export var player: NodePath
@export var quest_target_position :Vector2
@onready var texture_rect: TextureRect = $TextureRect
const arrow = preload("res://arrow_gide_2/Pointers/01.png")
const cross = preload("res://arrow_gide_2/Pointers/Pressed_01.png")
@export var idle_time_threshold: float = 3.0

var player_last_position: Vector2
var idle_timer: float = 0.0

var scale_cooldown = 1.0  # Time before resetting scale
var scale_reset_timer = 0.0

var camera_zoom 
func _ready() -> void:
	camera_zoom = get_viewport().get_camera_2d().zoom
func _process(delta: float) -> void:
	if quest_target_position == Vector2.ZERO :return
	
	var quest_target_screen_position = (quest_target_position- _get_camera_rect().position) *camera_zoom
	
	
	var player_node = get_node(player)
	
	if _target_on_screen():
		texture_rect.texture = cross
		rotation = 0
		global_position = quest_target_screen_position
	else :
		texture_rect.texture = arrow
		
		_set_screen_position(quest_target_screen_position)
		_rutate_to_target()
		
		
		
		# Check if the player is idle
	if player_node.global_position == player_last_position:
		idle_timer += delta
	else:
		idle_timer = 0.0
		player_last_position = player_node.global_position

	# If the player is idle for too long, nudge the arrow
	if idle_timer >= idle_time_threshold:
		_arrow_change_scale()
		scale_reset_timer = scale_cooldown  # Start cooldown
	elif scale_reset_timer > 0.0:
		scale_reset_timer -= delta
func _target_on_screen():
	return _get_camera_rect().has_point(quest_target_position)
func _get_camera_rect():
	var pos = get_viewport().get_camera_2d().get_screen_center_position()

	var screen_size = get_viewport_rect().size/camera_zoom
	
	return Rect2(pos - screen_size / 2 , screen_size)
	
	
func _rutate_to_target():
	var current_position = get_viewport().get_camera_2d().get_screen_center_position()
	var direction = (quest_target_position-current_position).normalized()
	rotation = direction .angle() +  2
func _set_screen_position(screen_target_positin):

	var screen_size = get_viewport_rect().size
	var borderoffset_x= 150
	var borderoffset_y= 50
	var target_position = screen_target_positin
	
	if target_position.x < borderoffset_x:
		target_position.x = borderoffset_x
	if target_position.x >screen_size.x - borderoffset_x:
		target_position.x = screen_size.x - borderoffset_x
	if target_position.y < borderoffset_y:
		target_position.y = borderoffset_y
	if target_position.y >screen_size.y - borderoffset_y:
		target_position.y = screen_size.y - borderoffset_y
	global_position = target_position
func _arrow_change_scale():
	texture_rect.scale = Vector2(1.3, 1.3)  # Temporarily increase size
	await get_tree().create_timer(0.5).timeout  # Wait for half a second
	texture_rect.scale = Vector2(1, 1)  # Reset to normal size
