extends Node

onready var canvas          = get_node("canvas")
onready var anim            = canvas.get_node("anim")
onready var btn_play        = canvas.get_node("play_quit_button_box/btn_play")
onready var btn_quit        = canvas.get_node("play_quit_button_box/btn_quit")
onready var btn_settings    = canvas.get_node("btn_settings")
onready var menu_settings   = get_node("menu_settings")
onready var label_score_top = canvas.get_node("label_score_top")

func _ready():
	btn_play.connect    ("pressed", self, "_btn_play_pressed")
	btn_quit.connect    ("pressed", self, "_btn_quit_pressed")
	btn_settings.connect("pressed", self, "_btn_settings_pressed")
	menu_settings.hide()
	var menu_settings_btn_return = menu_settings.get_node("canvas").get_node("btn_return")
	menu_settings_btn_return.connect("pressed", self, "_menu_settings_btn_return_pressed")
	set_top_score(file_manager.load_top_score())
	pass

func _btn_play_pressed():
	stage_manager.load_level(stage_manager.LEVEL_1)
	
func _btn_quit_pressed():
	get_tree().quit()
	
func _btn_settings_pressed():
	menu_settings.show()

func _menu_settings_btn_return_pressed():
	menu_settings.hide()
	
func set_top_score(score):
	label_score_top.set_text("TOP SCORE: " + str(score))