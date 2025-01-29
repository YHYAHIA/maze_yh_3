extends Control




@onready var gold: Label = $CanvasLayer2/Panel/MarginContainer/GridContainer/gold
@onready var meet: Label = $CanvasLayer2/PanelContainer/MarginContainer/GridContainer/meet
@onready var wood: Label = $CanvasLayer2/Panel/MarginContainer/GridContainer/wood
@onready var keyes: Label = $CanvasLayer2/Panel/MarginContainer/GridContainer/key2



func _process(_delta: float) -> void:
	update_inventory_display()

func update_inventory_display() -> void:
	gold.text = "Gold: " + GlobalInteract.gold()
	meet.text = "Meat: " + GlobalInteract.meet()
	wood.text = "Wood: " + GlobalInteract.wood()
	keyes.text=  "key: " + GlobalInteract.key()
