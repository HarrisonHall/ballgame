extends KinematicBody

var start_position
var current_time
var move_time
var move_up_velocity
var move_side_velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = get_global_transform().origin
	var par = get_parent()
	
	move_time = par.move_time
	current_time = par.current_time
	move_up_velocity = par.move_up_velocity
	move_side_velocity = par.move_side_velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_time += delta
	if current_time >= move_time:
		start_position = get_global_transform().origin
		current_time = 0
		move_up_velocity = -move_up_velocity
		move_side_velocity = -move_side_velocity
	#move_and_slide(move_up_velocity)
	#move_and_collide(move_up_velocity*delta)
	#global_position.x = 5
	#print(get_global_transform().origin)
	#var p = get_global_transform()
	#p.origin += move_up_velocity*delta
	#set_transform(p)
	global_translate((move_up_velocity+move_side_velocity)*delta)
