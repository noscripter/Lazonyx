extends Node

onready var canvas          = get_node("canvas")
onready var label_score     = canvas.get_node("label_score")
onready var label_score_top = canvas.get_node("label_score_top")

const OFFSET_HIDE = Vector2(1000,1000)
const OFFSET_SHOW = Vector2(0,0)

signal btn_menu_main_pressed

func _ready():
	show()
	get_node("canvas").get_node("btn_menu_main").connect("pressed", self, "_btn_menu_main_pressed")
	pass

func hide():
	canvas.set_offset(OFFSET_HIDE)
	
func show():
	canvas.set_offset(OFFSET_SHOW)

func _btn_menu_main_pressed():
	emit_signal("btn_menu_main_pressed")
	
func set_score(score):
	label_score.set_text(str(score))

func set_score_top(score):
	label_score_top.set_text(str(score))