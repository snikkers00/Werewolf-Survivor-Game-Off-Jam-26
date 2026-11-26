extends Node

const HOVER_SCALE := Vector2(1.02, 1.02)
const PRESS_SCALE := Vector2(0.97, 0.97)
const NORMAL_SCALE := Vector2.ONE


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().node_added.connect(_hook)
	_walk(get_tree().root)


func _walk(node: Node) -> void:
	_hook(node)
	for child in node.get_children():
		_walk(child)


func _hook(node: Node) -> void:
	if not node is BaseButton or node.has_meta(&"_juice_hooked"):
		return
	var btn := node as BaseButton
	btn.set_meta(&"_juice_hooked", true)
	btn.mouse_entered.connect(_tween.bind(btn, HOVER_SCALE, 0.08))
	btn.mouse_exited.connect(_tween.bind(btn, NORMAL_SCALE, 0.08))
	btn.button_down.connect(_tween.bind(btn, PRESS_SCALE, 0.05))
	btn.button_up.connect(func() -> void: _tween(btn, HOVER_SCALE if btn.is_hovered() else NORMAL_SCALE, 0.10))
	btn.hidden.connect(_reset.bind(btn))


func _tween(btn: BaseButton, target: Vector2, duration: float) -> void:
	if btn.disabled or not btn.is_inside_tree():
		return
	btn.pivot_offset = btn.size * 0.5
	var prev: Tween = btn.get_meta(&"_juice_tween", null)
	if is_instance_valid(prev):
		prev.kill()
	var tw := btn.create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.tween_property(btn, "scale", target, duration)
	btn.set_meta(&"_juice_tween", tw)


func _reset(btn: BaseButton) -> void:
	var prev: Tween = btn.get_meta(&"_juice_tween", null)
	if is_instance_valid(prev):
		prev.kill()
	btn.scale = NORMAL_SCALE
