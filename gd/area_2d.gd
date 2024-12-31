extends Area2D
#var direction = get_tree()
var player = null
#func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body: is_in_group("player")
		#.x > 0 :$"../CharacterBody2D".velocity.y +=speed/1.3
		#.x < 0 :$"../CharacterBody2D".velocity.y -=speed/1.3
func _ready() -> void:
	player =$"../../player1"

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		body.speed = 150  # Set a new speed
	 # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body == player:
		body.speed = 300  # Reset to base speed
	 # Replace with function body.
