extends Spatial

var rng = RandomNumberGenerator.new()

var blink = false
var blink_timer = 0
var blink_scale = Vector3(0.2,0.2,0.2)
var original_scale

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	original_scale = scale


func _process(delta):
	if blink:
		blink_timer -= delta
		if blink_timer < 0:
			scale = original_scale
			blink = false
	else:
		if rng.randi_range(0,500) == 9:
			blink = true
			blink_timer = rng.randi_range(0,3)
			scale = blink_scale
