extends Spatial

export var current_dialog = "test1"
export var area_radius = 1

var player
var in_dialogue = false
var current_char = 0

var picture 

# Called when the node enters the scene tree for the first time.
func _ready():
	var area = get_node("Area/CollisionShape")
	area.set_scale(area.get_scale()*area_radius)
	
	picture = get_node("Control/TextureRect")


func _process(delta):
	if in_dialogue and current_dialog in global_dialog.dialogs:
		if "picture" in global_dialog.dialogs[current_dialog]:
			picture.set_texture(global_dialog.dialogs[current_dialog]["picture"])


# Enter area for dialog
func _on_Area_body_exited(body):
	if body.get_name() == "Player":
		player = body
		player.in_dialogue = false
		in_dialogue = true
