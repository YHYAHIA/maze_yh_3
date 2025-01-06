extends Control

@onready var healthbar1 = $CanvasLayer/ProgressBar1
@onready var healthbar2 = $CanvasLayer/ProgressBar2

# Changes the health bar value
func change_health(newvalue: int):
	var oldvalue = healthbar1.value
	var stylebox: StyleBox = healthbar1.get_theme_stylebox("fill")

	# Update health bar values
	if newvalue > 0:
		healthbar1.value = oldvalue + newvalue
		stylebox.bg_color = Color("1a340b")  # Green for healing
		_catch_up_change(healthbar2, newvalue)
	elif newvalue < 0:
		healthbar1.value = oldvalue + newvalue
		stylebox.bg_color = Color("ca0020")  # Red for damage
		_catch_up_change(healthbar2, newvalue)

	# Apply the stylebox
	healthbar1.add_theme_stylebox_override("fill", stylebox)

# Smoothly adjusts the secondary health bar to match the primary one
func _catch_up_change(healthbar: ProgressBar, changevalue: int):
	for _i in range(abs(changevalue)):
		await get_tree().create_timer(0.05).timeout
		if changevalue < 0:
			healthbar.value -= 1
		elif changevalue > 0:
			healthbar.value += 1
