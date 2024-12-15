extends TouchScreenButton
@onready var noob =$noob
@onready var max_distance = shape.radius

var stick_center:Vector2 = texture_normal.get_size() /2
var touched:bool=false
func _ready():
	set_process(false)
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			set_process(true)
		elif not event.pressed:
			set_process(false)
			noob.position = stick_center
			
			
func _process(delta):
	noob.global_position = get_global_mouse_position()
	noob.position = stick_center + (noob.position - stick_center).limit_length(max_distance)


func get_joystick_dir() ->Vector2:
	var dir = noob.position - stick_center
	return dir.normalized()
	
	
