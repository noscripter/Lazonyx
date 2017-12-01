extends Node

const SOUND_SCORE_POINT        = "collect_point_01"
const SOUND_ENEMY_BECOMES_COIN = "collect_point_00"
const SOUND_HIT_BY_ENEMY       = "hit_03"
const MUSIC_BACKGROUND         = "lazonyx_idea_2_v2"

#game
var ammo_per_pickup = 10
var max_number_of_enemies = 1
var time_between_enemy_spawns = 1.0
var time_before_level_increase = 20.0
var time_to_increase_level = time_before_level_increase
var points_per_goal = 10
var starting_lives = 3

#audio

var music_volume = 1.0
var sound_volume = 1.0

# get references to children
onready var hud                 = get_node("hud")
onready var menu_settings       = get_node("menu_settings")
onready var menu_controls       = get_node("menu_controls")
onready var menu_game_over      = get_node("menu_game_over")
onready var menu_pause          = get_node("menu_pause")
onready var player              = get_node("player")
onready var debug_circle        = get_node("debug_circle")
onready var enemy_spawner       = get_node("enemy_spawner")
onready var ammo_pickup_spawner = get_node("ammo_pickup_spawner")
onready var sample_player       = get_node("sample_player")
onready var music_player        = get_node("music_player")

## defaults
var start_time = OS.get_unix_time()
var game_time = start_time
var current_level = 1
var time_to_spawn_enemy = 1.0
var number_of_enemies = 0
var current_score   = 0
var top_score       = 0
# array of objects for laser to ignore
var laser_ignore_objects = [player]
var music_voice_id


func _ready():
	# connect events to functions
	player.connect("entered_goal", self, "_player_entered_goal")
	player.connect("fired_shot", self, "_player_fired_shot")
	player.ammo = ammo_per_pickup
	player.lives = starting_lives
	menu_game_over.connect("btn_menu_main_pressed", self, "_menu_game_over_btn_menu_main_pressed")
	menu_pause.btn_resume.connect("pressed", self, "_menu_pause_btn_resume_pressed")
	menu_pause.btn_main_menu.connect("pressed", self, "_menu_pause_btn_main_menu_pressed")
	menu_pause.btn_settings.connect("pressed", self, "_menu_pause_btn_settings_pressed")
	menu_pause.btn_controls.connect("pressed", self, "_menu_pause_btn_controls_pressed")
	menu_controls.btn_return.connect("pressed", self, "_menu_controls_btn_return_pressed")
	menu_settings.connect("btn_return_pressed", self, "_menu_settings_btn_return_pressed")
	menu_settings.connect("music_volume_value_changed", self, "_music_volume_value_changed")
	
	# hide menus
	menu_settings. hide()
	menu_game_over.hide()
	
	# load top score from savegame
	top_score = file_manager.load_top_score()
	
	# initialise HUD
	hud.set_top_score(top_score)
	hud.set_current_score(current_score)
	hud.set_ammo(player.ammo)
	hud.set_lives(player.lives)
	hud.set_level(current_level)
	hud.show()
	
	#audio
	sound_volume = file_manager.load_sound_volume()
	music_volume = file_manager.load_music_volume()
	music_voice_id = music_player.play(MUSIC_BACKGROUND)
	music_player.set_volume(music_voice_id, music_volume)
	
	set_process(true)
	set_process_input(true)
	
	pass

func _process(delta):
	# calculate game time
	game_time = OS.get_unix_time() - start_time
	
	if game_time >= time_to_spawn_enemy:
		attempt_spawn_enemy()
		time_to_spawn_enemy = game_time + time_between_enemy_spawns
		
	if game_time >= time_to_increase_level:
		max_number_of_enemies += 1
		current_level += 1
		hud.set_level(current_level)
		
		time_to_increase_level = game_time + time_before_level_increase
	

	pass
	
func _music_volume_value_changed(value):
	if music_voice_id != null:
		music_player.set_volume(music_voice_id, value)

func _input(event):
	if event.is_action_pressed("pause"):
		pause_game()
		
func pause_game():
	get_tree().set_pause(true)
	menu_pause.show()
	
	
func unpause_game():
	print("unpause game")
	get_tree().set_pause(false)
	music_volume = file_manager.load_music_volume()
	sound_volume = file_manager.load_sound_volume()
	menu_pause.hide()

# deal with enemy death by player
func enemy_died(death_position, death_velocity):
	spawn_orb(death_position, death_velocity)
	number_of_enemies -= 1
	
# deal with enemy dying by contact with player
func enemy_exploded():
	number_of_enemies -= 1
	
func _player_fired_shot():
	hud.set_ammo(player.ammo)
	if player.ammo < 1:
		spawn_ammo_pickup()
		
func spawn_ammo_pickup():
	var pickup_spawn_location = ammo_pickup_spawner.get_random_location()
	var new_ammo_pickup = file_manager.AMMO_PICKUP_PREFAB.instance()
	new_ammo_pickup.set_global_pos(pickup_spawn_location)
	laser_ignore_objects.append(new_ammo_pickup)
	add_child(new_ammo_pickup)
	
func spawn_orb(position,velocity):
	var new_orb = file_manager.ORB_PREFAB.instance()
	new_orb.set_pos(position)
	new_orb.set_linear_velocity(velocity)
	new_orb.connect("entered_goal", self, "_orb_entered_goal")
	laser_ignore_objects.append(new_orb)
	add_child(new_orb)
	
func player_hit_enemy(enemy):
	var voice_id = sample_player.play(SOUND_ENEMY_BECOMES_COIN)
	sample_player.set_volume(voice_id, sound_volume)
	enemy.die()
	
func player_touched_ammo_pickup(player_that_touched, ammo_pickup):
	player_that_touched.ammo += ammo_per_pickup
	hud.set_ammo(player_that_touched.ammo)
	ammo_pickup.queue_free()
	
func _orb_entered_goal(orb, goal):
	
	# if it's the right goal for this orb
	if orb.target_goal == goal.get_name():
		
		var voice_id = sample_player.play(SOUND_SCORE_POINT)
		sample_player.set_volume(voice_id, sound_volume)
		# increase score
		current_score += points_per_goal
		# calculate current level based on score
		# increase enemy count in line with level increase
		max_number_of_enemies = current_level
		# update HUD
		hud.set_current_score(current_score)
		hud.set_level(current_level)
		
	# remove this orb from the laser ignore array
	laser_ignore_objects.remove(laser_ignore_objects.find(orb))
	# remove orb from scene
	orb.queue_free()
	
func _enemy_entered_goal(enemy):
	# reset enemy position
	enemy.set_pos(enemy_spawner.get_pos())
	
func _player_entered_goal(player):
	deduct_life()
	var voice_id = sample_player.play(SOUND_HIT_BY_ENEMY)
	sample_player.set_volume(voice_id, sound_volume)
	player.anim.play("player_hit_animation")
	reset_player_position()
	
func reset_player_position():
	player.set_pos(enemy_spawner.get_pos())
	player.body.set_pos(Vector2(0,0))
	player.body.set_linear_velocity(Vector2(0,0))

func find_scene_node(name):
	get_node(name)
	
func attempt_spawn_enemy():
	
	# create bounds so it doesn't spawn in walls
	var spawner_min_x = 100
	var spawner_max_x = get_viewport().get_rect().size.x - spawner_min_x
	
	# move spawner to new position
	var new_spawner_pos_x = rand_range(spawner_min_x, spawner_max_x)
	var new_spawner_pos_y = enemy_spawner.get_pos().y
	enemy_spawner.set_pos(Vector2(new_spawner_pos_x, new_spawner_pos_y))
	
	# if there aren't enough enemies, spawn a new one
	if number_of_enemies < max_number_of_enemies:
		var new_enemy = enemy_spawner.spawn_enemy()
		new_enemy.connect("entered_goal", self, "_enemy_entered_goal")
		number_of_enemies += 1
		
	current_level = max_number_of_enemies
	hud.set_level(current_level)

func deduct_life():
	player.lives -= 1
	if player.lives < 1:
		game_over()
		return
	hud.set_lives(player.lives)

func enemy_hit_player(enemy_body):
	var voice_id = sample_player.play(SOUND_HIT_BY_ENEMY)
	sample_player.set_volume(voice_id, sound_volume)
	enemy_body.get_parent().explode()
	player.anim.play("player_hit_animation")
	deduct_life()
		

func game_over():
	if current_score > top_score:
		top_score = current_score
		file_manager.save_top_score(current_score)
		
	menu_game_over.set_score(current_score)
	menu_game_over.set_score_top(top_score)
	
	menu_game_over.show()
	get_tree().set_pause(true)

func show_settings_menu():
	menu_settings.show()
	
func draw_debug_circle(location):
	debug_circle.set_pos(location)
	
func _menu_game_over_btn_menu_main_pressed():
	stage_manager.load_level(stage_manager.MENU_MAIN)

func _menu_pause_btn_resume_pressed():
	if get_tree().is_paused():
		unpause_game()
		
func _menu_pause_btn_settings_pressed():
	print("settings button pressed")
	show_settings_menu()
	
func _menu_pause_btn_main_menu_pressed():
	unpause_game()
	stage_manager.load_level(stage_manager.MENU_MAIN)
	
func _menu_pause_btn_controls_pressed():
	menu_controls.show()

func _menu_settings_btn_return_pressed():
	menu_settings.hide()
	
func _menu_controls_btn_return_pressed():
	menu_controls.hide()