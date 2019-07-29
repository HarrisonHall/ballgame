extends Spatial

# Declare member variables here. Examples:
var star
var rotation_speed = 0
var time_alive = 0
var max_time_alive = 1
var look_vector = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	#star = get_node("trail_ball")
	#star.look_at(look_vector.normalized(),Vector3(0,1,0))
	pass

func _process(delta):
	time_alive += delta
	#star.rotate_y(rotation_speed*delta)
	#star.orthonormalize ( )
	#star.look_at(look_vector,Vector3(0,1,0))
#	var orientation = look_object.get_global_transform().origin.normalized()
#	star.look_at(orientation,Vector3(0,1,0))
	#ball2.rotate_y(-rotation_speed*delta)
	
	if time_alive > max_time_alive:
		self.queue_free() # destroy self
