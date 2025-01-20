extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body. is_in_group("player"):
		anim.play("h_sheep_left")


func _on_area_2d_body_exited(body: Node2D) -> void:
	anim.play("idle_left")
