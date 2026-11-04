extends Node3D

@onready var enemy_spawn_timer = %EnemySpawnTimer
@export var enemy_types : Array [PackedScene] 

func _ready():
	EventsBus.phase_changed.connect(toggle_spawns)
	enemy_spawn_timer.timeout.connect(spawn_enemy)


func toggle_spawns(is_night):
	if is_night == false:
		enemy_spawn_timer.paused = true
		for c in get_tree().get_nodes_in_group("Enemy"):
			c.queue_free()
	elif is_night == true:
		enemy_spawn_timer.paused = false
		enemy_spawn_timer.start()

func spawn_enemy():
	var player_postion : Vector3 = get_tree().get_first_node_in_group("Player").global_position
	var spawn_angle = randf_range(0, TAU)
	var spawn_distance = 10
	var x_offset = cos(spawn_angle) * spawn_distance
	var y_offset = sin(spawn_angle) * spawn_distance
	var spawn_pos : Vector3 = Vector3((player_postion.x + x_offset) , 0 , (player_postion.y + y_offset) )
	var enemy_picked = enemy_types.pick_random()
	var enemy_to_spawn = enemy_picked.instantiate()
	add_child(enemy_to_spawn)
	enemy_to_spawn.global_position = spawn_pos
