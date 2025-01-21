extends Node

var collectedKeys = 0;
var is_pox_open=false
var plyer_geting_damge=false
var dameg_value = 0



var gold_amount: int = 0
var meet_amount: int = 0
var wood_amount: int = 0

func gold() -> String:
	return str(gold_amount)

func meet() -> String:
	return str(meet_amount)

func wood() -> String:
	return str(wood_amount)

func add_item(item: String, amount: int) -> void:
	match item:
		"gold":
			gold_amount += amount
		"meet":
			meet_amount += amount
		"wood":
			wood_amount += amount
