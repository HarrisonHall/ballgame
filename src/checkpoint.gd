extends Spatial

# Declare member variables here. Examples:
export var rotate_base = Vector3(0,1,0)
export var rotate_fast = Vector3(0,6,0)
var rotate_current
export var camera_direction = Vector3(0,0,0)

var area

# Called when the node enters the scene tree for the first time.
func _ready():
	rotate_current = rotate_base
	area = get_node("Area")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	area.rotate(rotate_current.normalized(), rotate_current.length()*delta)



func _on_Area_body_entered(body):
	if body.get_name() == "Player":
		rotate_current = rotate_fast
		body.start_trans = body.get_global_transform()
		body.camera.camera_spawn = camera_direction


func _on_Area_body_exited(body):
	if body.get_name() == "Player":
		rotate_current = rotate_base
