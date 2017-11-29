extends Node2D

const SOUND_SWING_DOWN = "swosh"
const SOUND_SWING_UP   = "swosh"

var anim_index = 0
var anim_names = ["level_to_leftdown", "leftdown_to_level", "level_to_rightdown", "rightdown_to_level"]


onready var anim          = get_node("anim_player")
onready var sample_player = get_node("sample_player")

const STATE_LEVEL     = 0
const STATE_LEFTDOWN  = 1
const STATE_RIGHTDOWN = 2

var state = STATE_LEVEL

func _ready():
	get_node("btn_right").connect("pressed", self, "_btn_right_pressed")
	get_node("btn_left"). connect("pressed", self, "_btn_left_pressed")
	pass

func _btn_left_pressed():
	if state == STATE_LEVEL:
		change_state(STATE_LEFTDOWN)
	elif state == STATE_RIGHTDOWN or state == STATE_LEFTDOWN:
		change_state(STATE_LEVEL)
	
func _btn_right_pressed():
	if state == STATE_LEVEL:
		change_state(STATE_RIGHTDOWN)
	elif state == STATE_RIGHTDOWN or state == STATE_LEFTDOWN:
		change_state(STATE_LEVEL)

func change_state(new_state):
	var prev_state = state
	if new_state == STATE_LEVEL:
		if prev_state == STATE_LEFTDOWN:
			#TODO get sound volume from centralised place
			var voice_id = sample_player.play(SOUND_SWING_UP)
			sample_player.set_volume(voice_id, get_parent().get_parent().sound_volume)
			anim.play("leftdown_to_level")
		elif prev_state == STATE_RIGHTDOWN:
			var voice_id = sample_player.play(SOUND_SWING_UP)
			sample_player.set_volume(voice_id, get_parent().get_parent().sound_volume)
			anim.play("rightdown_to_level")
	elif new_state == STATE_LEFTDOWN:
		if prev_state == STATE_LEVEL:
			var voice_id = sample_player.play(SOUND_SWING_DOWN)
			sample_player.set_volume(voice_id, get_parent().get_parent().sound_volume)
			anim.play("level_to_leftdown")
	elif new_state == STATE_RIGHTDOWN:
		if prev_state == STATE_LEVEL:
			var voice_id = sample_player.play(SOUND_SWING_DOWN)
			sample_player.set_volume(voice_id, get_parent().get_parent().sound_volume)
			anim.play("level_to_rightdown")
	state = new_state