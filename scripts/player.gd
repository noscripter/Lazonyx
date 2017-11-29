extends Node2D

const SOUND_LASER       = "laser1"
const SOUND_JUMP        = "Jump_00"

export var jump_force = Vector2(0,-450)
export var move_force = Vector2(150, 0)
export var max_horizontal_velocity = 200
export var max_vertical_velocity = 450
export var lives = 0
export var feet_distance = 20
export var ammo = 0

var should_shoot        = false
var jump_button_pressed = false

const LASER_MAX_LENGTH = 700
onready var body           = get_node("body")
onready var laser_sprite   = get_node("sprite_laser")
onready var anim           = get_node("anim")
onready var sample_player  = get_node("sample_player")
onready var music_player   = get_node("music_player")

signal entered_goal
signal fired_shot

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	body.connect("body_enter", self, "_body_enter")
	pass

func _input(event):
	if event.is_action_pressed("shoot"):
		if ammo > 0:
			should_shoot = true
	if event.is_action_pressed("jump"):
		jump_button_pressed = true

func shoot():
	var space_state = get_world_2d().get_direct_space_state()
	# use global coordinates, not local to node
	
	var raytrace_end_point = get_global_mouse_pos() - body.get_global_pos()
	var raytrace_length = raytrace_end_point.length()
	raytrace_end_point *= (LASER_MAX_LENGTH / raytrace_length)
	raytrace_end_point = body.get_global_pos() + raytrace_end_point
	var laser_end_point = raytrace_end_point
	var result = space_state.intersect_ray( body.get_global_pos(), raytrace_end_point, get_parent().laser_ignore_objects)
	# deal with left and right movement
	if (not result.empty()):
		
		#get_parent().draw_debug_circle(result.position)
		if result.collider.is_in_group("enemy_hit_zones"):
			var enemy_hit = result.collider
			get_parent().player_hit_enemy(enemy_hit.get_parent())
			laser_end_point = enemy_hit.get_global_pos()
		else:
			laser_end_point = result.position
	should_shoot = false
	ammo -= 1
	# TODO, calculate end pos if hit was empty
	draw_laser(body.get_global_pos(), laser_end_point)
	var voice_id = sample_player.play(SOUND_LASER)
	sample_player.set_volume(voice_id, get_parent().sound_volume)
	emit_signal("fired_shot")
	
func _fixed_process(delta):
	body.set_rot(0)
	feet_distance = max_horizontal_velocity * 0.2;
	if jump_button_pressed:
		attempt_jump()
	if should_shoot:
		shoot()
	if Input.is_action_pressed("move_left"):
		addxvel(-max_horizontal_velocity)
	elif Input.is_action_pressed("move_right"):
		addxvel(max_horizontal_velocity)
	else:
		setxvel(0)

	pass

func attempt_jump():
	var space_state = get_world_2d().get_direct_space_state()
	# use global coordinates, not local to node
	var player_pos = body.get_global_pos()
	var feet_pos = body.get_global_pos() + Vector2(0,feet_distance)
	var result = space_state.intersect_ray( player_pos, feet_pos, [self])
	# deal with left and right movement
	if (not result.empty()):
		#get_parent().draw_debug_circle(result.position)
		if result.collider.is_in_group("jump_surfaces"):
			jump()
	jump_button_pressed = false

func jump():
	body.set_linear_velocity(body.get_linear_velocity() + Vector2(0,-max_vertical_velocity))
	var voice_id = sample_player.play(SOUND_JUMP)
	var jump_sound_volume = 0.4
	sample_player.set_volume(voice_id, get_parent().sound_volume * jump_sound_volume)

func _body_enter(other_body):
	if other_body.is_in_group("ammo_pickups"):
		get_parent().player_touched_ammo_pickup(self, other_body)
	if other_body.is_in_group("enemies"):
		get_parent().enemy_hit_player(other_body)
	if other_body.is_in_group("goals"):
		emit_signal("entered_goal", self)

# add x velocity
func addxvel(amount):
	var current_vel = body.get_linear_velocity()
	var current_y_vel = current_vel.y
	var new_vel = current_vel + Vector2(amount,0)
	new_vel.x = clamp(new_vel.x,-max_horizontal_velocity, max_horizontal_velocity)
	body.set_linear_velocity(new_vel)

# add y velocity
func addyvel(amount):
	var current_vel = body.get_linear_velocity()
	var current_x_vel = current_vel.x
	var new_vel = current_vel + Vector2(0,amount)
	new_vel.y = clamp(new_vel.y,-max_vertical_velocity, max_vertical_velocity)
	body.set_linear_velocity(new_vel)
	
# set x velocity
func setxvel(amount):
	body.set_linear_velocity(Vector2(amount,body.get_linear_velocity().y))

func draw_laser(start, end):
	
	# move laser sprite to start position
	laser_sprite.set_global_pos(start)
	
	# calculate the angle to rotate it by
	var x_diff = end.x - start.x
	var y_diff = end.y - start.y
	var angle = atan2(x_diff, y_diff) - (PI/2)
	
	# rotate to correct position
	laser_sprite.set_rot(angle)
	
	# calculate correct length for sprite
	var laser_length = sqrt(pow(x_diff,2)+pow(y_diff,2))
	var texture_width = laser_sprite.get_texture().get_width()
	
	# resize the sprite to correct width
	laser_sprite.set_scale(Vector2(laser_length/texture_width, laser_sprite.get_scale().y))
	
	# play the laser flash animation
	anim.play("flash_laser_beam")
	
	pass