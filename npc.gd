extends Node2D

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
var player: Node = null





func show_dialogue():
	if quest_complete:
		$Label.text = dialogue[2]
	elif player_gold < quest_gold_required:
		$Label.text = dialogue[dialogue_index]
	else:
		$Label.text = "Do you want to complete the quest? Press [E] to confirm."

	$Label.visible = true

func _process(delta):
	if player and Input.is_action_just_pressed("interact"): # Assuming "ui_accept" is mapped to a key like 'E'
		handle_interaction()

func handle_interaction():
	if quest_complete:
		return

	if player_gold < quest_gold_required:
		dialogue_index = min(dialogue_index + 1, 1)  # Loop through initial dialogue
	else:
		complete_quest()

	show_dialogue()

func complete_quest():
	quest_complete = true
	player_gold -= quest_gold_required
	# Call your custom function here
	reward_player()
	print("Quest completed!")

func reward_player():
	# Add custom reward logic here
	print("Player rewarded!")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		show_dialogue()
	


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
