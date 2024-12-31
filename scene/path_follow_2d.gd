extends PathFollow2D
var speed = .6



# Called when the node epass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_ratio +=delta*speed
