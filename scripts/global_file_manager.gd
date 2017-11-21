extends Node


const LEVEL_1_FILE   = "res://stages/lvl_1.tscn"
const MAIN_MENU_FILE = "res://stages/main_menu.tscn"

const FILEPATH_TOP_SCORE_SAVE = "user://topscore.save"

const ORB_PREFAB                = preload("res://prefabs/orb.tscn")
const ENEMY_PREFAB              = preload("res://prefabs/enemy.tscn")
const AMMO_PICKUP_PREFAB        = preload("res://prefabs/pickup_ammo.tscn")

func save_top_score(score):
	var savegame = File.new()
	var savedict = {topscore = score}
	savegame.open(FILEPATH_TOP_SCORE_SAVE, File.WRITE)
	savegame.store_line(savedict.to_json())
	savegame.close()
	
func load_top_score():
	var savegame = File.new()
	if savegame.file_exists(FILEPATH_TOP_SCORE_SAVE):
		savegame.open(FILEPATH_TOP_SCORE_SAVE, File.READ)
		var filedata = {}
		filedata.parse_json(savegame.get_as_text())
		if filedata.topscore:
			return filedata.topscore
	return 0

	