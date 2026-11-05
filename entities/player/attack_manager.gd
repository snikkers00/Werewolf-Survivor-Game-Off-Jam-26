extends Node3D

@onready var active_attacks : Array[Node] = get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	EventsBus.phase_changed.connect(toggle_attacks)

func toggle_attacks(is_night):
	if is_night == true:
		var timers : Array[Node] = get_tree().get_nodes_in_group("Timer")
		for t in timers:
			t.start()
	elif is_night == false:
		var timers : Array[Node] = get_tree().get_nodes_in_group("Timer")
		for t in timers:
			t.stop()
