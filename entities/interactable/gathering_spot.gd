extends Area3D

@onready var parent_node: Node3D = get_parent()

@export var gather_type: Resources.ResourceType
@export var resource_value: int = 1
@export var visual: MeshInstance3D
var visual_base_scale: Vector3

@onready var activation_visual: MeshInstance3D = %ActivationVisual
@onready var gathering_timer: Timer = %GatheringTimer

func _ready() -> void:
	EventsBus.phase_changed.connect(pause_gathering)
	if visual != null:
		visual_base_scale = visual.scale

func _on_gathering_timer_timeout() -> void:
	if gather_type == null:
		print("Gather type is not set for this gathering spot.")
	elif gather_type != null:
		Resources.gain_resource(gather_type, resource_value)
		if visual != null:
			var get_feedback = create_tween()
			get_feedback.tween_property(visual, "scale", visual_base_scale * 1.15, 0.1)
			get_feedback.tween_property(visual, "scale", visual_base_scale, 0.1)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		gathering_timer.start()


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		gathering_timer.stop()

func pause_gathering(is_night: bool) -> void:
	if is_night == true:
		gathering_timer.stop()
		monitoring = false
		activation_visual.visible = false
		print("Gathering paused")
	elif is_night == false:
		monitoring = true
		activation_visual.visible = true
