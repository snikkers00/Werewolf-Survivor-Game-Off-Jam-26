extends CharacterBody3D

@onready var health: Health = $Health
@onready var player_sprite : AnimatedSprite3D = %PlayerSprite
@onready var exp_bar : ProgressBar = %ExpBar
@onready var level_label : Label = %LevelLabel
@onready var health_bar : ProgressBar = %PlayerHealthBar
@onready var death_screen : Panel = %DeathPanel

var level : int = 1 
var current_exp : int
var exp_to_next_level : int
@export var exp_to_level1 : int

const SPEED = 2.5
const JUMP_VELOCITY = 4.5

func _ready():
	exp_to_next_level = exp_to_level1
	health_bar.max_value = health.health
	update_exp_ui()
	update_health_ui()
	
	health.death.connect(_on_death)
	EventsBus.phase_changed.connect(shapeshift)
	EventsBus.xp_gained.connect(gain_exp)

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
	print("Player has died")
	get_tree().paused = true
	death_screen.visible = true

func shapeshift(is_night):
	if is_night == true:
		create_tween().tween_property(player_sprite, "modulate", Color.DIM_GRAY, 3)
	elif is_night == false:
		create_tween().tween_property(player_sprite, "modulate", Color.WHITE, 3)
		

func gain_exp(amount):
	current_exp += amount
	exp_bar.value += amount
	if current_exp >= exp_to_next_level:
		level_up()

func level_up():
	level += 1
	current_exp = 0
	exp_to_next_level = exp_to_level1 * level
	exp_bar.value = 0
	update_exp_ui()

func update_exp_ui():
	exp_bar.value = current_exp
	exp_bar.max_value = exp_to_next_level
	level_label.text = "Level: " + str(level)


func _on_hurt_box_area_entered(area: Area3D) -> void:
	if area.is_in_group("Attack"):
		health.damage(area.damage)
		update_health_ui()

func update_health_ui():
	health_bar.value = health.health
