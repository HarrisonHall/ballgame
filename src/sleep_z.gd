extends Spatial

# Declare member variables here. Examples:
var sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_node("Sprite3D")


func _process(delta):
	var s = size_up(delta)
	translate(Vector3(0,1*delta,0))
	if s >= .05:
		queue_free()

func size_up(delta):
	sprite.pixel_size += 0.05 * delta
	return sprite.pixel_size