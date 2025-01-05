extends Control


@onready var healthbar1 = $CanvasLayer/ProgressBar1
@onready var healthbar2 = $CanvasLayer/ProgressBar2


func change_health(newvalue):
	var oldvalue=healthbar2.value
	var stylebox:StyleBox=healthbar1.get_theme_stylebox("fill")
	
	if newvalue >0:
		healthbar1.value = oldvalue +newvalue
		stylebox.bg_color= Color("1a340b")
		_catch_up_change(healthbar1,newvalue)
	elif newvalue<0:
		healthbar2.value = oldvalue+ newvalue
		stylebox.bg_color = Color("ca0020")
		
	healthbar1.add_theme_stylebox_override("fill",stylebox)
	
		
func _catch_up_change(healthbar,changevalue):
	for i in abs(changevalue):
		await get_tree().current_timer(0.05).timeout
		if changevalue<0:healthbar.value -=1
		elif changevalue>0:healthbar.value +=1
