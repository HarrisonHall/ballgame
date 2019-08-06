extends Node

var dialogs

# Called when the node enters the scene tree for the first time.
func _ready():
	var f = File.new()
	if f.file_exists("res://dialog/dialog.json"):
		print("dialogs exist")
		f.open("res://dialog/dialog.json", File.READ_WRITE)
		dialogs = JSON.parse(f.get_as_text()).result
		print(dialogs)
	else:
		print("No dialog exists")
		dialogs = {}


