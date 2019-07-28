extends Spatial

# Declare member variables here. Examples:
var ball1
var ball2
var rotation_speed = 0
var time_alive = 0
var max_time_alive = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	ball1 = get_node("ball1")
	ball2 = get_node("ball2")

func _process(delta):
	time_alive += delta
	ball1.rotate_y(rotation_speed*delta)
	ball2.rotate_y(-rotation_speed*delta)
	
	if time_alive > max_time_alive:
		self.queue_free() # destroy self
