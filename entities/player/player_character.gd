extends CharacterBody3D

@onready var health: Health = $Health
@onready var player_sprite : AnimatedSprite3D = %PlayerSprite

const SPEED = 2.5
const JUMP_VELOCITY = 4.5

func _ready():
	health.death.connect(_on_death)
	EventsBus.phase_changed.connect(shapeshift)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_death():
	queue_free()

func shapeshift(is_night):
	if is_night == true:
		create_tween().tween_property(player_sprite, "modulate", Color.DIM_GRAY, 3)
	elif is_night == false:
		create_tween().tween_property(player_sprite, "modulate", Color.WHITE, 3)
