extends UpgradableStructure

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	activation_area.visible = false
	unavailable = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
