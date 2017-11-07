extends Node2D

export var jump_force = Vector2(0,-450)
export var move_force = Vector2(150, 0)
export var max_horizontal_velocity = 200
export var max_vertical_velocity = 450

onready var rigidbody     = get_node("body")

func _ready():
	set_process_input(true)
	pass
	
	
func _input(event):
	if event.is_action("jump"):
		var new_linear_velocity = rigidbody.get_linear_velocity() + jump_force
		if new_linear_velocity.y < -max_vertical_velocity:
			new_linear_velocity.y = -max_vertical_velocity
		rigidbody.set_linear_velocity(new_linear_velocity)

	if event.is_action("move_right"):
		var new_linear_velocity = rigidbody.get_linear_velocity() + move_force
		if new_linear_velocity.x > max_horizontal_velocity:
			new_linear_velocity.x = max_horizontal_velocity
		rigidbody.set_linear_velocity(new_linear_velocity)

	if event.is_action("move_left"):
		var new_linear_velocity = rigidbody.get_linear_velocity() - move_force
		if new_linear_velocity.x < -max_horizontal_velocity:
			new_linear_velocity.x = -max_horizontal_velocity
		rigidbody.set_linear_velocity(new_linear_velocity)
