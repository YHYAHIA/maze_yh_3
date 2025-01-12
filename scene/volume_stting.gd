extends Control





func _on_resume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,value)


func _on_setting_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)
