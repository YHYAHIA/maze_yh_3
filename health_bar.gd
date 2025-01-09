extends Control

@onready var healthbar1: ProgressBar = $ProgressBar1
@onready var healthbar2: ProgressBar = $ProgressBar2

# Changes the health bar value
func change_health(change_value: int) -> void:
	var old_value = healthbar1.value
	var new_value = clamp(old_value + change_value, 0, healthbar1.max_value)

	# Update the primary health bar value
	healthbar1.value = new_value

	# Update the style based on healing or damage
	var stylebox: StyleBox = healthbar1.get_theme_stylebox("fill").duplicate()
	if change_value > 0:
		stylebox.bg_color = Color("1a340b")  # Green for healing
	elif change_value < 0:
		stylebox.bg_color = Color("ca0020")  # Red for damage
	healthbar1.add_theme_stylebox_override("fill", stylebox)

	# Smoothly adjust the secondary health bar
	_catch_up_change(new_value)

# Smoothly adjusts the secondary health bar to match the primary one
func _catch_up_change(target_value: int) -> void:
	while healthbar2.value != target_value:
		await get_tree().create_timer(0.05).timeout
		if healthbar2.value < target_value:
			healthbar2.value += 1
		elif healthbar2.value > target_value:
			healthbar2.value -= 1
