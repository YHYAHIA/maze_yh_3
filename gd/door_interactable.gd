extends "res://gd/interactable.gd"


var collected_key = 0


@export var is_open = true :
	set(value):
		if (is_open==value):
			return
		is_open=value
		_update_animations()
		

			

@export var anim : AnimatedSprite2D:
	set(value):
		anim =value
		_update_animations()

@export_group("animation names")
@export var open_anim : StringName = "open"
@export var closed_anim :StringName = "closed"
var door_open:bool

@onready var collision_polygon_2d: CollisionShape2D = $"../Camera2D/CollisionPolygon2D"


@onready var collision=$CollisionShape2D
var locked = true;


func interact(user: Node2D):
	# Check if the door is already unlocked
	if not locked:
		is_open=not is_open
		print("The door is already open.")
		return  # Do nothing further if the door is already open
	
	# Check if the player has keys to unlock the door
	if GlobalInteract.collectedKeys > 0:
		GlobalInteract.collectedKeys -= 1  # Use a key to unlock the door
		locked = false  # Unlock the door
		is_open = true  # Open the door
		print("Door unlocked!")
	else:
		print("The door is locked. You need a key!")
	

			
		#if (is_open)=(is_open):
		#	collision_polygon_2d.set_disabled(true)
		#door_open=true
		#$collision.set_deferred("disable",true)
		#$"../Camera2D/CollisionPolygon2D".disabled
	

	
func _update_animations():
	if (anim!=null):
		if(is_open):
			
			anim.play(open_anim)
			#set_collision_layer_value(1,false)
			collision_polygon_2d.set_disabled(true)
		else :
			anim.play(closed_anim)
			
func stop_interaction(user : Node2D):
	#collision_polygon_2d.set_disabled(false)
	collision_polygon_2d.set_deferred("disabled",false)
	anim.play(closed_anim)
	is_open = false;
#func _process(_delta):
	#if (is_open):
		#collision.set_deferred("disable",true)
		#print("d")
	#else :
		
