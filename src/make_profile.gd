extends Control

var vbox

var shown_saves = []

var text_box

# Called when the node enters the scene tree for the first time.
func _ready():
	vbox = get_node("profiles/VBoxContainer")
	print(global.all_saves)
	text_box = get_node("current_player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for save in global.all_saves:
		if !(save in shown_saves):
			shown_saves.append(save)
			var prof_button = ResourceLoader.load("res://profile_button.tscn") #ResourceLoader.load(path)
			
			var new_button = prof_button.instance()
			new_button.get_children()[0].set_text(save)
			vbox.add_child(new_button)
	for con in vbox.get_children():
		if !(con.get_children()[0].text in global.all_saves):
			con.queue_free()
	
	if global.save_profile in global.all_saves:
		var txt = global.save_profile
		txt += "\nSnow Globes: " + str(global.all_saves[global.save_profile]["snowglobes"])
		txt += "\nStory %: " + str(global.all_saves[global.save_profile]["story_counter"])
		text_box.set_text(txt)

# Make new profile
func _on_Button_pressed():
	var text_node = get_node("new profile/TextEdit")
	if !(text_node.text in global.all_saves) and "" != text_node.text:
		global.add_save(text_node.text)


func _on_play_pressed():
	if global.save_profile != "":
		get_tree().change_scene("res://main_menu_debug.tscn")


func _on_remove_save_pressed():
	if global.save_profile in global.all_saves:
		global.all_saves.erase(global.save_profile)
	global.save_profile = ""


func _on_profile_menu_tree_exiting():
	pass


func _on_EXIT_pressed():
	global._exit_tree()
	get_tree().quit()
