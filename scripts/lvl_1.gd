extends Node

#game
var start_time
var game_time
var time_to_spawn_enemy

#enemies
var number_of_enemies
var max_number_of_enemies
var time_between_enemy_spawns

#player
var player_lives
var current_level_name

func reset_defaults():
	start_time = OS.get_unix_time()
	game_time = start_time
	time_to_spawn_enemy = 1.0
	number_of_enemies = 0
	max_number_of_enemies = 5
	time_between_enemy_spawns = 1.0
	player_lives = 1

func _ready():
	print("ready")
	reset_defaults()
	set_process(true)
	pass

func _process(delta):
	# calculate game time
	game_time = OS.get_unix_time() - start_time
	if game_time >= time_to_spawn_enemy:
		attempt_spawn_enemy()
	time_to_spawn_enemy = game_time + time_between_enemy_spawns
	pass

func enemy_died(death_position, death_velocity):
	var new_orb = file_manager.ORB_PREFAB.instance()
	new_orb.set_pos(death_position)
	new_orb.set_linear_velocity(death_velocity)
	add_child(new_orb)
	number_of_enemies -= 1
	
	
func find_scene_node(name):
	get_node(name)
	
func attempt_spawn_enemy():
	if number_of_enemies < max_number_of_enemies:
		get_node("enemy_spawner").spawn_enemy()
		number_of_enemies += 1

func enemy_hit_player():
	player_lives -= 1
	if player_lives < 1:
		game_over()
		
func game_over():
	print("game_over")
