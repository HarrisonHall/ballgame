extends Spatial

# Declare member variables here. Examples:
var s

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_pos = get_global_transform().origin
	var cam = get_tree().get_root().get_camera()
	var screen_pos = cam.unproject_position(current_pos)
	get_node("Node2D").set_position(screen_pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
