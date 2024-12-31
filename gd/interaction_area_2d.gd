extends Area2D


@export var interactor: Node2D
@export var interaction_action: StringName = "interact"

# Current selected interactable
var selected_interactable: interactable

# List of nearby interactables
var nearby_interactables: Array = []

func _ready() -> void:
	# Connect signals for area entry and exit
	self.connect("area_entered", _on_area_entered)
	self.connect("area_exited", _on_area_exited)

func _process(_delta: float) -> void:
	# Continuously update the closest interactable
	_set_selected_interactable_to_closest()

func _input(event: InputEvent) -> void:
	# Check for interaction input
	if event.is_action_pressed(interaction_action):
		if selected_interactable != null:
			selected_interactable.interact(interactor)

func _on_area_entered(area: Area2D) -> void:
	# Add interactable to the list when entered
	if area is interactable:
		nearby_interactables.append(area)
		# Automatically select the first interactable
		if selected_interactable == null:
			selected_interactable = area

func _on_area_exited(area: Area2D) -> void:
	# Remove interactable from the list when exited
	if area is interactable:
		nearby_interactables.erase(area)
		# Stop interaction if the interactable is the current one
		if selected_interactable == area:
			selected_interactable.stop_interaction(interactor)

	# Update the selected interactable
	if nearby_interactables.size() > 0:
		selected_interactable = nearby_interactables[0]
	else:
		selected_interactable = null

func _set_selected_interactable_to_closest() -> void:
	# Find the closest interactable
	if nearby_interactables.size() > 0:
		var closest_distance: float = INF
		var closest_interactable: interactable = null

		for interactable in nearby_interactables:
			var distance_to_interactable = interactor.global_position.distance_to(interactable.global_position)
			if distance_to_interactable < closest_distance:
				closest_distance = distance_to_interactable
				closest_interactable = interactable

		selected_interactable = closest_interactable
