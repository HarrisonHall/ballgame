extends KinematicBody


var start_trans


var jump_height = 14
var current_jump_length = 0
var max_jump_time = 0.4
var gravity_time = 0
var jump_time = 0.01
var can_jump = false
var going_up = false
var movement_speed = 25
var GRAVITY = 20
var GRAVITY_CONST = 50
var screen_size
var last_collision = Vector3(0,0,0)

var was_falling = false
var was_was_falling = false

var is_boosting = false
var boost_factor = 1

var is_bouncing = false
var spring_factor = 1
var base_spring = 20

var air_friction_move = 0.15
var bounce_factor = 0.4
var wall_bounce_factor = 1.5
var floor_move_factor = 0.5

var mass = 5
var velocity = Vector3(0,0,0)
var momentum = Vector3(0,0,0)
var friction = 0.97  # Higher is less friction
var air_friction = 0.7
var max_momentum = 12
var high_momentum_friction = 0.9

var test_body 

var game_time = 0.0

var can_dash = false
var dash_timer_reset = 1
var dash_timer = 0
var spawn_trail = false
var spawn_trail_timer = 0
var spawn_trail_timer_reset = 0.06
var dash_constant = 10

var trail
var camera

var player_go

var gone = false

var eyes_center
var blink_eyes = preload("res://textures/blink_eyes.png")
var wide_eyes = preload("res://textures/wide_eyes.png")
var normal_eyes = preload("res://textures/normal_eyes.png")
var interaction_time = 0
var z_timer = 0

var rng = RandomNumberGenerator.new()
var blink_timer = 0

var coin_count = 0

var pause = false

var in_dialogue = false

func _ready():
	rng.randomize()
	start_trans = get_global_transform()
	trail = preload("trail_ball.tscn")
	#camera = get_node("Spatial/pCamera")
	camera = get_node("Spatial/p_camera")
	player_go = camera.player_go
	eyes_center = get_node("eyes_center")



func _process(delta):
	player_go = camera.player_go
	if player_go and not pause:
		game_time += delta
		_process_physics(delta)  # Game movement


func _process_physics(delta):
	if gone:
		return
		
	# Timers
	dash_timer -= delta
	spawn_trail_timer -= delta
	was_was_falling = was_falling
	interaction_time += delta
		
	# Spawn trail
	if spawn_trail:
		var t = trail.instance()
		t.max_time_alive = 0.2
		if spawn_trail_timer < 0 and dash_timer > 0:
			var temp_trans = t.get_global_transform()
			temp_trans.origin = get_global_transform().origin
			t.look_vector = get_global_transform().origin + velocity
			t.set_global_transform(temp_trans)
			get_tree().get_root().add_child(t)
			spawn_trail_timer = spawn_trail_timer_reset
		elif dash_timer < 0:
			spawn_trail = false
	
	# Move relative to Camera
	velocity = momentum
	var cam_xform = camera.get_global_transform()
	var x_axis = cam_xform.basis[0].normalized()
	x_axis.y = 0
	x_axis = x_axis.normalized()
	var z_axis = cam_xform.basis[2].normalized()
	z_axis.y = 0
	z_axis = z_axis.normalized()

	# Movement (w/ momentum)
	if is_on_floor():
		if Input.is_action_pressed("ui_right"):
			velocity += x_axis * movement_speed * delta
			interaction_time = 0
		if Input.is_action_pressed("ui_left"):
			velocity -= x_axis * movement_speed * delta
			interaction_time = 0
		if Input.is_action_pressed("ui_up"):
			velocity -= z_axis * movement_speed * delta
			interaction_time = 0
		if Input.is_action_pressed("ui_down"):
			velocity += z_axis * movement_speed * delta
			interaction_time = 0
	else:  # In air
		if Input.is_action_pressed("ui_right"):
			velocity += x_axis * movement_speed * delta * air_friction_move
			interaction_time = 0
		if Input.is_action_pressed("ui_left"):
			velocity -= x_axis * movement_speed * delta * air_friction_move
			interaction_time = 0
		if Input.is_action_pressed("ui_up"):
			velocity -= z_axis * movement_speed * delta * air_friction_move
			interaction_time = 0
		if Input.is_action_pressed("ui_down"):
			velocity += z_axis * movement_speed * delta * air_friction_move
			interaction_time = 0

	# Jumping
	if (Input.is_action_pressed("ui_jump")):
		if is_on_floor() and Input.is_action_just_pressed("ui_jump"):
			velocity.y += jump_height 
			interaction_time = 0
		elif jump_time < max_jump_time and not is_on_ceiling():
			velocity.y += jump_height * delta 
			jump_time += delta
	else:
		if is_on_floor():
			jump_time = 0
			if velocity.y < -3:
				velocity.y = -3
	if is_on_ceiling():
		if velocity.y > 0:
			velocity.y = 0
		if momentum.y > 0:
			momentum.y = 0
			
	
	
	if is_on_floor():
		if was_falling:
			velocity.y = - momentum.y * bounce_factor
			if velocity.y < 2:
				velocity.y = 0
		was_falling = false
	else:
		was_falling = true
		# End infinite jumps
#		if velocity.y > 0 and velocity.y < 0.5:
#			velocity.y = 0
	
	# Wall collisions
	if last_collision:
		if is_on_wall():

			var rv = velocity
			var vel_at_wall = velocity.dot(last_collision.normal.normalized())
			velocity -= last_collision.normal.normalized() * vel_at_wall * wall_bounce_factor


		if is_on_floor():
			pass
#			var rv = velocity
#			var vel_at_wall = velocity.dot(last_collision.normal.normalized())
#			velocity += last_collision.normal.normalized() * vel_at_wall * floor_move_factor
	# Boost
	boost()
	
	# Bounce
	bounce()
	
	# Dash
	if Input.is_action_just_pressed("ui_left_click"):
		if can_dash and dash_timer < 0:
			if velocity.length() > 0:
				var x_axis_dash = cam_xform.basis[0].normalized()
				var z_axis_dash = cam_xform.basis[2].normalized()
				x_axis_dash.y = 0
				z_axis_dash.y = 0
				x_axis_dash = x_axis_dash.normalized()
				z_axis_dash = z_axis_dash.normalized()
				var dashed = false
				if Input.is_action_pressed("ui_right"):
					velocity = x_axis_dash * dash_constant 
					dashed = true
				if Input.is_action_pressed("ui_left"):
					velocity = -x_axis_dash * dash_constant 
					dashed = true
				if Input.is_action_pressed("ui_up"):
					velocity = -z_axis_dash * dash_constant 
					dashed = true
				if Input.is_action_pressed("ui_down"):
					velocity = z_axis_dash * dash_constant 
					dashed = true
				if Input.is_action_pressed("ui_shift_camera"):
					velocity += Vector3(0,-1,0) * dash_constant 
					dashed = true
				if Input.is_action_pressed("ui_jump"):
					velocity += Vector3(0,1,0) * dash_constant 
					dashed = true
				if dashed:
					dash_timer = dash_timer_reset
					can_dash = false
					spawn_trail = true
	
	# Gravity and normalization
	momentum = velocity
	if is_on_floor():
		can_dash = true
		momentum *= friction
		if momentum.length() < 0.5:
			momentum = Vector3(0,0,0)
		if momentum.length() > max_momentum:
			print(velocity.length())
			velocity = velocity * high_momentum_friction
			momentum = momentum * high_momentum_friction
		if spawn_trail and dash_timer > (dash_timer_reset - dash_timer_reset*.06):
			print("1")
			if was_was_falling:
				print("2")
				velocity.y = jump_height * 0.9
				velocity.x = velocity.normalized().x*24
				velocity.z = velocity.normalized().z*24
			else:
				print(3)
				velocity.x = velocity.normalized().x*24
				velocity.z = velocity.normalized().z*24
			momentum = velocity
	else:
		#air_friction = 100
		#momentum *= air_friction * delta
		momentum.y = momentum.y - momentum.y*air_friction*delta
		momentum.x = momentum.x - momentum.x*air_friction*delta/3
		momentum.z = momentum.z - momentum.z*air_friction*delta/3
	
	# Gravity
	velocity.y -= GRAVITY * delta
	momentum.y -= GRAVITY * delta
	
	
	var snap = Vector3(0,-1,0) * delta
	move_and_slide_with_snap(velocity, snap, Vector3(0,1,0), false, 4, 0.85)
	last_collision = move_and_collide(velocity.normalized()*delta*0.01, true, true, true)
	
	# Update eyes
	var rot = momentum
	rot.y = momentum.y - velocity.y
	if rot.length() > .6:
		eyes_center.rotate(-rot.normalized(), abs(rot.length())*delta)
		#eyes_center.rotate_x(-rot.x*delta)
		
	if velocity.length() > 16:
		eyes_center.get_node("eyes").set_texture(wide_eyes)
	elif interaction_time > 15:
		eyes_center.get_node("eyes").set_texture(blink_eyes)
		if z_timer <= 0:
			var sleepynode = load("res://sleep_z.tscn")
			var z = sleepynode.instance()
			add_child(z)
			z_timer = .5
		else:
			z_timer -= delta
		
	else:
		var r = rng.randi_range(0,400)
		if r == 9 or blink_timer > 0:
			eyes_center.get_node("eyes").set_texture(blink_eyes)
			if r == 9:
				blink_timer = .2
		else:
			eyes_center.get_node("eyes").set_texture(normal_eyes)
		blink_timer -= delta

func boost():
	if is_boosting:
		velocity.x = velocity.x * boost_factor
		velocity.z = velocity.z * boost_factor
		momentum.x = momentum.x * boost_factor
		momentum.z = momentum.z * boost_factor


func bounce():
	if is_bouncing:
		print("hit")
		if abs(velocity.y) > base_spring:
			velocity.y = abs(velocity.y) * spring_factor
			momentum.y = abs(momentum.y) * spring_factor
		else:
			velocity.y = base_spring
			momentum.y = base_spring
			
	is_bouncing = false


func respawn():
	set_global_transform(start_trans)
	camera.respawn()


func detach_camera_and_die(level):
	gone = true
	camera.painting(level)
	camera.get_parent().remove_child(camera)
	get_tree().get_root().add_child(camera)
	#get_tree().get_root().set_owner(camera)
	self.queue_free()


func teleport(some_vect):
	if some_vect.length() > 0:
		var trans = get_global_transform()
		trans.origin = some_vect
		set_global_transform(trans)
	

func increase_coin():
	coin_count += 1





