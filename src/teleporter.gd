extends Spatial

export var teleport_to = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body.get_name() == "Player":
		body.teleport(teleport_to)
