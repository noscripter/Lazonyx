extends RigidBody2D

export var move_speed = Vector2(150, 0)
export var max_horizontal_speed = 200
export var max_vertical_speed = 450

# 1 = right, -1 = left
var direction = 1

var body = self

signal entered_goal

func _ready():
	# TODO: delete this functionality
	set_process_input(true)
	connect("body_enter", self, "_body_enter")
	set_fixed_process(true)
	pass

func _body_enter(body):
	print(body.get_groups())
	if body.is_in_group("enemy_direction_switchers"):
		print("enemy changing direction")
		change_direction()
	if body.is_in_group("goals"):
		emit_signal("entered_goal", self)

func _input(event):
	if event.is_action_pressed("kill_all_enemies"):
		die()
	
	
func die():
	get_parent().enemy_died(get_pos(),get_linear_velocity())
	queue_free()


func change_direction():
	direction *= -1

	
func _fixed_process(delta):
	setxvel(max_horizontal_speed * direction)
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