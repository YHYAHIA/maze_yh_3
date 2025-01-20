extends Control




func _process(delta: float) -> void:
		if Game.quest1acceoted:
			get_node("QUESTS").text = "boars sline:" str(Game.boars_sline)
