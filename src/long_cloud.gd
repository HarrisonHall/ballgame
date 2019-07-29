extends Spatial

export var translate_vector = Vector3(0,15,0)
export var pi_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pi_counter += delta / 8
	if pi_counter >= 3.14 * 2:
		pi_counter = 0
	#translate(Vector3(0,sin(rad2deg(pi_counter))*0.015,0))
	print(sin(pi_counter))
	translate(translate_vector*delta*sin(deg2rad(pi_counter)))
