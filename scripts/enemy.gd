extends RigidBody2D

export var move_speed = Vector2(150, 0)
export var max_horizontal_speed = 200
export var max_vertical_speed = 450

var body = self


func _ready():
	set_fixed_process(true)
	pass
	
func _fixed_process(delta):
	
	pass
	
# add x velocity
func addxvel(amount):
	var current_vel = body.get_linear_velocity()
	var current_y_vel = current_vel.y
	var new_vel = current_vel + Vector2(amount,0)
	new_vel.x = clamp(new_vel.x,-max_horizontal_speed, max_horizontal_speed)
	body.set_linear_velocity(new_vel)

# add y velocity
func addyvel(amount):
	var current_vel = body.get_linear_velocity()
	var current_x_vel = current_vel.x
	var new_vel = current_vel + Vector2(0,amount)
	new_vel.y = clamp(new_vel.y,-max_vertical_speed, max_vertical_speed)
	body.set_linear_velocity(new_vel)
	
# set x velocity
func setxvel(amount):
	body.set_linear_velocity(Vector2(amount,body.get_linear_velocity().y))