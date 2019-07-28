extends AnimatedSprite3D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	# Needs to turn towards camera
#	var up = Vector3(0,1,0)
#	var pos = get_global_transform().origin
#	var target = get_node("../pCamera").get_global_transform()
#
#
#	look_at_from_position(pos, target, up)
    var camera_pos = get_node("../pCamera").global_transform.origin
    camera_pos.y = 0
    look_at(camera_pos, Vector3(0, 1, 0))
