extends "res://gd/interactable.gd"

class_name npc_area

@export var player :PackedScene=null

@export var quest_gold_required: int = 4
var player_gold: int = GlobalInteract.gold_amount
var quest_complete: bool = false
# Dialogue lines
var dialogue = [
	"Hello there, traveler!",
	"I need 4 gold. Can you help me out?",
	"Thank you for the gold! Here's your reward."
]

# Current dialogue index
var dialogue_index: int = 0

# Reference to the player (set dynamically)
var player_1: Node = null

# Reference to the Label (Dialogue Box)

@onready var dialogue_label: Label = $"../Label"

# Called when the node enters the scene tree for the first time
func _ready():
	# Make sure the player reference is set dynamically when the player enters the area
	player = null
	
	
func _process(_delta):
	if Input.is_action_just_pressed("interact") and player_1:
		if dialogue_label.visible and dialogue_label.text == "Do you want to complete the quest? Press [E] to confirm." and player_gold >= quest_gold_required:
			complete_quest()  # Complete the quest if requirements are met
		else:
			interact(player_1)  # Proceed with the regular interaction

# Show the appropriate dialogue based on quest progress
func show_dialogue():
	if quest_complete:
		dialogue_label.text = dialogue[2]
	elif player_gold < quest_gold_required:
		dialogue_label.text = dialogue[dialogue_index]
	else:
		dialogue_label.text = "Do you want to complete the quest? Press [E] to confirm."

	dialogue_label.visible = true

func interact(_user: Node2D):
	if quest_complete:
		return

	if player_gold < quest_gold_required:
		dialogue_index = min(dialogue_index + 1, 1)  # Loop through initial dialogue
	else:
		dialogue_index = 2  # Skip to the quest completion dialogue
		show_dialogue()

	
func complete_quest():
	quest_complete = true
	player_gold -= quest_gold_required
	reward_player()
	print("Quest completed!")  # Debug line
	dialogue_label.text = dialogue[2]

	
func reward_player():
	# Add custom reward logic here (e.g., giving the player an item or gold)
	print("Player rewarded with gold or items!")
	
	
# Called when the player enters the interaction area
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_1 = body  # Set the player reference when they enter the area
		show_dialogue()

# Called when the player exits the interaction area
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		dialogue_label.visible = false  # Hide dialogue when player exits area
		player = null  # Reset player reference
func stop_interaction(_user : Node2D):
	pass
# Called when the node enters the scene tree for the first time.
