extends CharacterBody3D

@onready var health: Health = $Health
@onready var player_sprite : AnimatedSprite3D = %PlayerSprite
@onready var exp_bar : ProgressBar = %ExpBar
@onready var level_label : Label = %LevelLabel
@onready var health_bar : ProgressBar = %PlayerHealthBar
@onready var health_label : Label = %HealthLabel

@onready var death_screen : Panel = %DeathPanel
@onready var upgrade_screen : Control = %UpgradeUI

var exp_rate : float = 1.0
var level : int = 1 
var current_exp : int
var exp_to_next_level : int
@export var exp_to_level1 : int

@export var SPEED = 2.5


func _ready():
	exp_to_next_level = exp_to_level1
	health_bar.max_value = health.max_health
	update_exp_ui()
	update_health_ui()
	
	health.death.connect(_on_death)
	EventsBus.phase_changed.connect(shapeshift)
	EventsBus.xp_gained.connect(gain_exp)
	EventsBus.upgrade_selected.connect(apply_player_upgrade)

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
	current_exp += amount * exp_rate
	exp_bar.value += amount * exp_rate
	while current_exp >= exp_to_next_level:
		if get_tree().paused == false:
			level_up()

func level_up():
	level += 1
	current_exp -= exp_to_next_level
	exp_to_next_level = exp_to_level1 * (level + .3)
	update_exp_ui()
	get_tree().paused = true
	upgrade_screen.check_and_update_upgrades()
	upgrade_screen.visible = true


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
	health_bar.max_value = health.max_health
	health_label.text = str(health.health) + "/" + str(health.max_health)


func apply_player_upgrade(upgrade : Upgrade):
	if upgrade.stat_modified == Upgrade.StatModified.HEALTH:
		
		health.max_health *= upgrade.stat_modifier
		health.health *= upgrade.stat_modifier
		update_health_ui()
	if upgrade.stat_modified == Upgrade.StatModified.XP_GAIN:
		exp_rate *= upgrade.stat_modifier
	if upgrade.stat_modified == Upgrade.StatModified.MOVEMENT_SPEED:
		SPEED *= upgrade.stat_modifier
