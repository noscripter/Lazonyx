extends Node

#children
onready var enemy_spawner  = get_node("enemy_spawner")
onready var player         = get_node("player")
onready var debug_circle   = get_node("debug_circle")
onready var menu_settings  = get_node("menu_settings")
onready var menu_game_over = get_node("menu_game_over")
onready var hud            = get_node("hud")

var laser_ignore_objects =[player]

#game
var start_time = OS.get_unix_time()
var game_time = start_time
var time_to_spawn_enemy = 1.0
var current_level = 1

#enemies
var number_of_enemies = 0
var max_number_of_enemies = 1
var time_between_enemy_spawns = 1.0



#player
var current_score   = 0
var top_score       = 0
var points_per_goal = 1

func _ready():
	player.connect("entered_goal", self, "_player_entered_goal")
	player.connect("fired_shot", self, "_player_fired_shot")
	menu_settings. hide()
	menu_game_over.hide()
	menu_game_over.connect("btn_menu_main_pressed", self, "_menu_game_over_btn_menu_main_pressed")
	top_score = file_manager.load_top_score()
	hud.set_top_score(top_score)
	hud.set_current_score(current_score)
	hud.set_ammo(player.ammo)
	hud.set_lives(player.lives)
	hud.show()
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
	spawn_orb(death_position, death_velocity)
	number_of_enemies -= 1
	
func enemy_exploded():
	number_of_enemies -= 1
	
func _player_fired_shot():
	hud.set_ammo(player.ammo)
	
func spawn_orb(position,velocity):
	var new_orb = file_manager.ORB_PREFAB.instance()
	new_orb.set_pos(position)
	new_orb.set_linear_velocity(velocity)
	new_orb.connect("entered_goal", self, "_orb_entered_goal")
	laser_ignore_objects.append(new_orb)
	add_child(new_orb)
	
func player_hit_enemy(enemy):
	enemy.die()
	
	
func _orb_entered_goal(orb, goal):
	if orb.target_goal == goal.get_name():
		current_score += points_per_goal
		current_level = floor(current_score/10) + 1
		max_number_of_enemies = current_level
		hud.set_current_score(current_score)
		hud.set_level(current_level)
	print(current_score)
	# remove this orb from the laser ignore array
	laser_ignore_objects.remove(laser_ignore_objects.find(orb))
	orb.queue_free()
	
func _enemy_entered_goal(enemy):
	enemy.set_pos(enemy_spawner.get_pos())
	
func _player_entered_goal(player):
	deduct_life()
	reset_player_position()
	
func reset_player_position():
	player.set_pos(enemy_spawner.get_pos())
	player.body.set_pos(Vector2(0,0))
	player.body.set_linear_velocity(Vector2(0,0))

func find_scene_node(name):
	get_node(name)
	
func attempt_spawn_enemy():
	
	var new_spawner_pos_x = rand_range(100,get_viewport().get_rect().size.x - 200)
	var new_spawner_pos_y = enemy_spawner.get_pos().y
	
	enemy_spawner.set_pos(Vector2(new_spawner_pos_x, new_spawner_pos_y))
	if number_of_enemies < max_number_of_enemies:
		var new_enemy = enemy_spawner.spawn_enemy()
		new_enemy.connect("entered_goal", self, "_enemy_entered_goal")
		number_of_enemies += 1

func deduct_life():
	player.lives -= 1
	if player.lives < 1:
		game_over()
		return
	hud.set_lives(player.lives)

func enemy_hit_player(enemy_body):
	enemy_body.get_parent().explode()
	deduct_life()
		

func game_over():
	if current_score > top_score:
		top_score = current_score
		file_manager.save_top_score(current_score)
		
	menu_game_over.set_score(current_score)
	menu_game_over.set_score_top(top_score)
	
	menu_game_over.show()
	
func draw_debug_circle(location):
	debug_circle.set_pos(location)
	
func _menu_game_over_btn_menu_main_pressed():
	stage_manager.load_level(stage_manager.MENU_MAIN)
