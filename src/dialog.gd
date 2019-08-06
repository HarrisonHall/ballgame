extends Spatial

export var current_dialog = "test1"
export var area_radius = 1

var player
var in_dialogue = false
var can_dialogue = true
var current_char = 0

var control
var picture 
var text

var auto_timer = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	var area = get_node("area")
	
	picture = get_node("Control/TextureRect")
	control = get_node("Control")
	control.set_visible(false)
	text = get_node("Control/RichTextLabel")
	get_node("area/MeshInstance").queue_free()

func _process(delta):
	if in_dialogue and current_dialog in global_dialog.dialogs:
		player.in_dialogue = global_dialog.dialogs[current_dialog].get("in_dialogue",false)
		picture.set_texture(load(global_dialog.dialogs[current_dialog].get("picture","res://marble_test.png")))
		text.set_text(global_dialog.dialogs[current_dialog].get("dialogue","bug, json's fault"))
		
		if global_dialog.dialogs[current_dialog].get("stop",false) and current_char > len(text.get_text()):
			auto_timer -= delta
			if auto_timer < 0:
				in_dialogue = false
				current_char = 0
				player.in_dialogue = false
				control.set_visible(false)
				current_dialog = global_dialog.dialogs[current_dialog].get("next",current_dialog)
		
		if Input.is_action_just_pressed("ui_select") or Input.is_action_just_pressed("ui_left_click"):
			if current_char > len(text.get_text()) and current_dialog != global_dialog.dialogs[current_dialog].get("next",current_dialog):
				if not global_dialog.dialogs[current_dialog].get("stop",false):
					current_char = 0
					current_dialog = global_dialog.dialogs[current_dialog].get("next",current_dialog)
			else:
				current_char = len(text.get_text())
		current_char += delta*global_dialog.dialogs[current_dialog].get("speed",30)
		text.set_visible_characters(floor(current_char))
		
		if current_char > len(text.get_text()) and global_dialog.dialogs[current_dialog].get("auto",false):
			auto_timer -= delta
			if auto_timer < 0:
				auto_timer = 2
				current_dialog = global_dialog.dialogs[current_dialog].get("next",current_dialog)
				current_char = 0
				
		if "rel_cam_position" in global_dialog.dialogs[current_dialog]:
			player.look_dialogue = true
			var cam_pos = global_dialog.dialogs[current_dialog].get("rel_cam_position",[0,0,0])
			player.dialogue_pos = get_global_transform().origin + Vector3(cam_pos[0],cam_pos[1],cam_pos[2])
			player.dialogue_pos_look = get_global_transform().origin
		else:
			player.look_dialogue = false

# Exit area for dialog
func _on_Area_body_exited(body):
	if body.get_name() == "Player":
		can_dialogue = true
		in_dialogue = false
		player.in_dialogue = false
		control.set_visible(false)
		current_char = 0
		text.set_visible_characters(floor(current_char))

# Enter area for dialog
func _on_Area_body_entered(body):
	print(body, body.get_name())
	if body.get_name() == "Player" and can_dialogue:
		can_dialogue = false
		player = body
		player.look_dialogue = false
		player.in_dialogue = global_dialog.dialogs[current_dialog].get("in_dialogue",false)
		in_dialogue = true
		auto_timer = 2
		
		control.set_visible(true)
