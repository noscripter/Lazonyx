extends Node2D

export var jump_force = Vector2(0,-450)
export var move_force = Vector2(150, 0)
export var max_horizontal_velocity = 200
export var max_vertical_velocity = 450

onready var body     = get_node("body")

func _ready():
	set_fixed_process(true)
	pass
	
func _fixed_process(delta):
	
	# deal with left and right movement
	if Input.is_action_pressed("move_left"):
		addxvel(-max_horizontal_velocity)
	elif Input.is_action_pressed("move_right"):
		addxvel(max_horizontal_velocity)
	else:
		setxvel(0)
		
	#deal with jumping
	if Input.is_action_pressed("jump"):
		var colliding_bodies = body.get_colliding_bodies()
		for body in colliding_bodies:
			if body.is_in_group("jump_surface"):
				addyvel(-max_vertical_velocity)
	
	pass

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
