extends Spatial

export var teleport_to = Vector3(0,0,0)
export var new_scene = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	var tele = get_node("teleporter")
	tele.new_scene = new_scene
	tele.teleport_to = teleport_to

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
