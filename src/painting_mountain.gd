extends Spatial

# Declare member variables here. Examples:
export var next_level = "res://mountain.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Area_body_entered(body):
	if body.get_name() == "Player":
		body.detach_camera_and_die(next_level)
