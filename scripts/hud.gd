extends Node

onready var canvas = get_node("canvas")
onready var label_score_top     = canvas.get_node("label_score_top")
onready var label_score_current = canvas.get_node("label_score_current")
onready var label_ammo          = canvas.get_node("label_ammo")
onready var label_lives         = canvas.get_node("label_lives")
const OFFSET_HIDE = Vector2(-1000,-1000)
const OFFSET_SHOW = Vector2(0,0)

func _ready():
	show()
	pass

func hide():
	canvas.set_offset(OFFSET_HIDE)
	
func show():
	canvas.set_offset(OFFSET_SHOW)
	
func set_current_score(score):
	label_score_current.set_text("Score: " + str(score))

func set_lives(lives):
	label_lives.set_text("Lives: " + str(lives))

func set_ammo(ammo):
	label_ammo.set_text("Ammo: " + str(ammo))