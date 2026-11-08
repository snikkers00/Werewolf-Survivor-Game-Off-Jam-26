extends Area3D


@export var gather_type : Resources.ResourceType
@export var resource_value : int = 1

func _on_gathering_timer_timeout() -> void:
	if gather_type == null:
		print("Gather type is not set for this gathering spot.")
	elif gather_type != null:
		Resources.gain_resource(gather_type, resource_value)

