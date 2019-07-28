extends KinematicBody


var delta_since_last = 1
var camera_delta = 0.3
var camera_rotation = PI / 6

var min_camera_distance = 2
var camera_distance = 6
var real_distance = camera_distance
var camera_scroll_speed = 0.2
var max_camera_distance = 10

var camera_speed = 0.01
var mouse_captured = false

var pitch = 0
var yaw = 0 
var roll = 0

var detach = false
var detach_pos = Vector3(0,0,0)
var player_pos = Vector3(0,0,0)

var next_level = "res://debug.tscn"
var next_level_timer = 3

var pos
var offset
var target

var camera

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("InterpolatedCamera")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true
	var pos = get_global_transform().origin
	var target = get_node("../../../Player").get_global_transform().origin
	pos = target - (target - pos).normalized() * camera_distance
	camera.look_at_from_position(pos, target, Vector3(0,1,0))
	#area = get_node("camera_area")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if mouse_captured:
			mouse_captured = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouse_captured = true
	if detach:
		camera.look_at_from_position(detach_pos, player_pos, Vector3(0,1,0))
		next_level_timer -= delta
	if next_level_timer < 0:
		call_deferred("_deferred_goto_scene", next_level)
	#look_at_from_position(pos, target, Vector3(0,1,0))
		
	
func _input(event):
	if detach:
		camera.look_at_from_position(detach_pos, player_pos, Vector3(0,1,0))
		return
	pos = get_global_transform().origin
	target = get_node("../../../Player").get_global_transform().origin
	#var player_xform = get_node("../ball_sprite").get_global_transform()
	var current_xform = get_global_transform()
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN:
			camera_distance += camera_scroll_speed
			if camera_distance > max_camera_distance:
				camera_distance = max_camera_distance
		if event.button_index == BUTTON_WHEEL_UP:
			camera_distance -= camera_scroll_speed
			if camera_distance < min_camera_distance:
				camera_distance = min_camera_distance
				
	if event is InputEventMouseMotion:
		# While dragging, move the sprite with the mouse.
		if mouse_captured:
			var motion = event.get_relative()
			var x_change = motion[0]
			var y_change = motion[1]
			
			pos += -current_xform.basis[0] * x_change * camera_speed
			pos += current_xform.basis[1] * y_change * camera_speed
		
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_RIGHT:
			pos += current_xform.basis[0] * 300 * camera_speed
		if event.scancode == KEY_LEFT:
			pos += -current_xform.basis[0] * 300 * camera_speed
		if event.scancode == KEY_UP:
			pos += current_xform.basis[1] * 300 * camera_speed
		if event.scancode == KEY_DOWN:
			pos += -current_xform.basis[1] * 300 * camera_speed
		if event.scancode == KEY_SHIFT:
			var vel = get_parent().get_parent().momentum
			if vel.length() > 1:
				pos += -(vel.normalized())*camera_distance
	

#	while(len(area.get_overlapping_bodies()) > 0):
#		camera_distance -= 1
#		offset = (pos - target).normalized() * camera_distance
#		pos = target + offset
#		look_at_from_position(pos, target, Vector3(0,1,0))

	offset = (pos - target).normalized() * camera_distance
	pos = target + offset

	camera.look_at_from_position(pos, target, Vector3(0,1,0))

func painting(level):
	detach = true
	detach_pos = get_global_transform().origin
	player_pos = get_node("../../../Player").get_global_transform().origin
	next_level = level
	
	
func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	print(path)
	var current_scene = get_tree().get_root().get_child(0)
	#print(current_scene.get_children()[0].get_name())

	current_scene.queue_free()

	# Load the new scene.
	var s = ResourceLoader.load(path) #ResourceLoader.load(path)

	# Instance the new scene.
	var new_scene = s.instance()

    # Add it to the active scene, as child of root.
	get_tree().get_root().add_child(new_scene)

    # Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(new_scene)
	self.queue_free()
	
	
