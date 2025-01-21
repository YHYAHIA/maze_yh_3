extends Control




func _process(delta: float) -> void:
		if Game.quest1acceoted:
			get_node("QUESTS").text = "boars sline:" +str(Game.boars_sline)
		else:
			get_node("QUESTS").text = "no quest active at the moment !" 
