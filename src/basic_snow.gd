extends Spatial

var snow 
var orig_particles
var num_particles

# Called when the node enters the scene tree for the first time.
func _ready():
	snow = get_node("Particles")
	num_particles = snow.get_amount()
	orig_particles = num_particles
	print(orig_particles)
	

func _process(delta):
	if num_particles != orig_particles * (float(global.effect_level)/5):
		num_particles = orig_particles * (float(global.effect_level)/5)
		#snow.amount = num_particles
		snow.set_amount(num_particles)
