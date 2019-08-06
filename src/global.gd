extends Node


var save_profile = ""

var all_saves = {}

var settings = {}

var effect_level = 3
var view_distance = 3

var gamefile = File.new()

var settingsfile = File.new()

var minute_save_counter = 60

var reset_vals = {
	"snowglobes": 0,
	"story_counter": 0,
}

var reset_settings = {
	"effect_level": effect_level,
	"view_distance": view_distance,
	"profile_name": save_profile,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	print("global reset")
	if gamefile.file_exists("saves.json"):
		print("saves exist")
		gamefile.open("saves.json", File.READ_WRITE)
		all_saves = JSON.parse(gamefile.get_as_text()).result
		#all_saves.parse_json(gamefile.get_as_text())
		print(all_saves)
	else:
		print("No save existed")
		all_saves = {}
		
	if settingsfile.file_exists("settings.json"):
		print("settings exist")
		settingsfile.open("settings.json", File.READ_WRITE)
		settings = JSON.parse(settingsfile.get_as_text()).result
		print(settings)
		effect_level = settings["effect_level"]
		view_distance = settings["view_distance"]
		save_profile = settings["profile_name"]
	else:
		print("No settings existed")
		settings = reset_settings


func _process(delta):
	minute_save_counter -= delta
	if minute_save_counter < 0:
		minute_save_counter = 60
		_exit_tree()
	
func write_save(profile_name):
	gamefile.open("saves.json", File.WRITE)
	#gamefile.store_string(String(all_saves))
	gamefile.store_line(JSON.print(all_saves))
	gamefile.close()
	print("wrote save")
	
func write_settings():
	settings = {
		"effect_level": effect_level,
		"view_distance": view_distance,
		"profile_name": save_profile,
	}
	settingsfile.open("settings.json", File.WRITE)
	print(JSON.print(settings))
	settingsfile.store_line(JSON.print(settings))
	settingsfile.close()
	#settingsfile.store_string(String(settings))
	print("wrote settings")
	
func _exit_tree():
	print("exit tree")
	write_save(all_saves)
	write_settings()
	
func _enter_tree():
	print("entered")
	
func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_exit_tree()
		
func _tree_exited():
	_exit_tree()
	
func _tree_exiting():
	_exit_tree()

func load_save():
	return 
	

func reset_save(profile_name):
	all_saves[profile_name] = reset_vals
	return
	
func add_save(profile_name):
	all_saves[profile_name] = reset_vals
	return




