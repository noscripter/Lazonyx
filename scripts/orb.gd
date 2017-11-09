extends RigidBody2D

var target_goal = "goal_left"

signal entered_goal

func _ready():
	connect("body_enter", self, "_body_enter")
	pass

func _body_enter(body_entered):
	if body_entered.is_in_group("goals"):
		emit_signal("entered_goal", self, body_entered)