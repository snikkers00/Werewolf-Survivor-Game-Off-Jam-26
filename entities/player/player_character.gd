extends CharacterBody3D

@onready var health: Health = $Health
@onready var human_sprite : AnimatedSprite3D = %HumanSprite
@onready var ww_sprite : AnimatedSprite3D = %WWSprite
@onready var exp_bar : ProgressBar = %ExpBar
@onready var level_label : Label = %LevelLabel
@onready var health_bar : ProgressBar = %PlayerHealthBar
@onready var health_label : Label = %HealthLabel
@onready var lives_label : Label = %LivesLabel

@onready var end_screen : Panel = %EndPanel
@onready var upgrade_screen : Control = %UpgradeUI

var starting_position : Vector3
var exp_rate : float = 1.0
var level : int = 1 
var current_exp : int
var exp_to_next_level : int
@export var exp_to_level1 : int

@export var lives_remaining : int = 3

@export var speed : float

@onready var introlabel : Label3D = %IntroLabel

var human_base_modulate: Color
var ww_base_modulate: Color
var damage_tween: Tween

func _ready():
	starting_position = global_position
	exp_to_next_level = exp_to_level1
	health_bar.max_value = health.max_health
	human_base_modulate = human_sprite.modulate
	ww_base_modulate = ww_sprite.modulate
	update_exp_ui()
	update_health_ui()
	human_sprite.play("idle")
	_setup_sprite_shader(human_sprite)
	_setup_sprite_shader(ww_sprite)

	introlabelfade()

	health.death.connect(_on_death)
	EventsBus.phase_changed.connect(shapeshift)
	EventsBus.xp_gained.connect(gain_exp)
	EventsBus.upgrade_selected.connect(apply_player_upgrade)
	EventsBus.game_fail.connect(gamefailstate)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if velocity.x > 0:
		human_sprite.flip_h = false
		ww_sprite.flip_h = false
	
	elif velocity.x < 0:
		human_sprite.flip_h = true
		ww_sprite.flip_h = true

	if velocity.x or velocity.z != 0:
		human_sprite.play("walk")
	else:
		human_sprite.play("idle")


	move_and_slide()
	global_position.x = clampf(global_position.x, -40.0, 40.0)
	global_position.z = clampf(global_position.z, -40.0, 40.0)



func _setup_sprite_shader(sprite: AnimatedSprite3D) -> void:
	if sprite.material_override is ShaderMaterial:
		sprite.material_override = sprite.material_override.duplicate()
		sprite.frame_changed.connect(_sync_sprite_shader.bind(sprite))
		sprite.animation_changed.connect(_sync_sprite_shader.bind(sprite))
		_sync_sprite_shader(sprite)

func _sync_sprite_shader(sprite: AnimatedSprite3D) -> void:
	if sprite.material_override is ShaderMaterial and sprite.sprite_frames:
		var tex := sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
		sprite.material_override.set_shader_parameter("albedo_tex", tex.atlas if tex is AtlasTexture else tex)

func _on_death():
	if lives_remaining > 0:
		lives_remaining -= 1
		EventsBus.reset_to_day.emit(true)
		respawn_player(starting_position)
		update_health_ui()
	else:
		print("Player has died (for good)")
		get_tree().paused = true
		end_screen.on_game_win(false)

func shapeshift(is_night):
	if is_night == true:
		ww_sprite.visible = true
		human_sprite.visible = false
		ww_sprite.play("walk")
	elif is_night == false:
		ww_sprite.visible = false
		human_sprite.visible = true
		ww_sprite.pause()
		

func gain_exp(amount):
	current_exp += amount * exp_rate
	exp_bar.value += amount * exp_rate
	if current_exp >= exp_to_next_level:
		if get_tree().paused == false:
			level_up()
	RunStats.total_exp_gained += amount * exp_rate
	AudioManager.play_sound("gain_exp")

func level_up():
	AudioManager.play_sound("level_up")
	level += 1
	current_exp -= exp_to_next_level
	exp_to_next_level = int(exp_to_level1 * (level + 0.3))
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
		flash_damage()
		update_health_ui()

func flash_damage():
	if damage_tween:
		damage_tween.kill()
	var human_mat := human_sprite.material_override as ShaderMaterial
	var ww_mat := ww_sprite.material_override as ShaderMaterial
	if human_mat:
		human_mat.set_shader_parameter("unshaded", 1.0)
		human_mat.set_shader_parameter("modulate", Color(2.0, 2.0, 2.0))
	if ww_mat:
		ww_mat.set_shader_parameter("unshaded", 1.0)
		ww_mat.set_shader_parameter("modulate", Color(2.0, 2.0, 2.0))
	damage_tween = create_tween()
	if human_mat:
		damage_tween.tween_property(human_mat, "shader_parameter/modulate", Color(2.0, 0.3, 0.3), 0.06)
	if ww_mat:
		damage_tween.parallel().tween_property(ww_mat, "shader_parameter/modulate", Color(2.0, 0.3, 0.3), 0.06)
	if human_mat:
		damage_tween.tween_property(human_mat, "shader_parameter/modulate", human_base_modulate, 0.16)
	if ww_mat:
		damage_tween.parallel().tween_property(ww_mat, "shader_parameter/modulate", ww_base_modulate, 0.16)
	if human_mat:
		damage_tween.tween_property(human_mat, "shader_parameter/unshaded", 0.0, 0.0)
	if ww_mat:
		damage_tween.parallel().tween_property(ww_mat, "shader_parameter/unshaded", 0.0, 0.0)

func update_health_ui():
	health_bar.value = health.health
	health_bar.max_value = health.max_health
	health_label.text = str(health.health) + "/" + str(health.max_health)
	lives_label.text = "Lives Remaining: " + str(lives_remaining)


func apply_player_upgrade(upgrade : Upgrade):
	if upgrade.stat_modified == Upgrade.StatModified.HEALTH:
		health.max_health *= upgrade.stat_modifier
		health.health *= upgrade.stat_modifier
		update_health_ui()
	if upgrade.stat_modified == Upgrade.StatModified.XP_GAIN:
		exp_rate *= upgrade.stat_modifier
	if upgrade.stat_modified == Upgrade.StatModified.MOVEMENT_SPEED:
		speed *= upgrade.stat_modifier
	if upgrade.stat_modified == Upgrade.StatModified.RESOURCE_GAIN:
		Resources.resource_rate += upgrade.stat_modifier

func respawn_player(starting_position: Vector3):
	if lives_remaining == 2:
		health.health = int(health.max_health * 0.5)
	elif lives_remaining == 1:
		health.health = int(health.max_health * 0.25)
	else:
		return
	update_health_ui()
	global_position = starting_position
	
	
func introlabelfade():
	introlabel.visible = true
	create_tween().tween_property(introlabel, "modulate", Color.TRANSPARENT, 10)
	create_tween().tween_property(introlabel, "outline_modulate", Color.TRANSPARENT, 10)
	await get_tree().create_timer(10).timeout
	introlabel.visible = false

func gamefailstate():
	lives_remaining = 0
	_on_death()