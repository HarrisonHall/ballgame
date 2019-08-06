extends Camera


var delta_since_last = 1
var camera_delta = 0.3
var camera_rotation = PI / 6

var min_camera_distance = 2
var camera_distance = 6
var set_camera_distance = 6
var real_distance = camera_distance
var camera_scroll_speed = 0.2
var max_camera_distance = 12

var camera_speed = .02
var mouse_captured = false

var pitch = 0
var yaw = 0 
var roll = 0

var detach = false
var detach_pos = Vector3(0,0,0)
var player_pos = Vector3(0,0,0)

var last_pos = Vector3(0,0,0)

var next_level = "res://debug.tscn"
var next_level_timer = 3

var area 
var last_bodies

var pos
var offset
var target

var cam_body 
var player
var last_delta = 0.01

var cam_start_nodes = []
var level 
var player_go = true
var cam_start_trans

var level_start_hud

var camera_spawn

var orig_far = 0


func _ready():
	#orig_far = far
	#print("far",far," ",orig_far," ", global.view_distance/5," ", far*(global.view_distance/5))
	#far = orig_far*(global.view_distance/5)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam_body = get_node("../cam_body")
	mouse_captured = true
	cam_start_trans = get_global_transform()
	pos = get_global_transform().origin
	target = get_node("../../../Player").get_global_transform().origin
	pos = target - (target - pos).normalized() * camera_distance
	look_at_from_position(pos, target, Vector3(0,1,0))
	player = get_node("../../../Player")
	area = get_node("Area")
	last_bodies = area.get_overlapping_bodies()
	level_start_hud = get_node("level_start_hud")
	print("lvs", level_start_hud)
	
	
	level = get_tree().get_root()
	var children = []
	for child in level.get_children():
		children.append(child.get_name())
	if "Beeg Mountain" in children:
		var camera_sps = get_tree().get_root().get_node("Beeg Mountain/level/camera_sps")
		cam_start_nodes = [[camera_sps.get_node("cam_path2"), Vector3(0,30,0), 50, 2, 0]
							,[camera_sps.get_node("cam_path1"), Vector3(0,150,0), 50, 2, 0.2]]
		level_start_hud.change_text("Blizzardo Peak")
	else:
		print("no level found")
		for child in level.get_children():
			print(child.get_name())
		level_start_hud.delete()
	if len(cam_start_nodes) > 0:
		player_go = false
		var path = cam_start_nodes[0][0]
		var follow = path.get_children()[0]
		var trans = get_global_transform()
		trans.origin = follow.get_global_transform().origin
		set_global_transform(trans)
		look_at(cam_start_nodes[0][1], Vector3(0,1,0))
	camera_spawn = get_global_transform().origin


func _process(delta):
	# Reset draw distance
	if orig_far == 0:
		orig_far = get_zfar()
	else:
		#print(get_zfar(), " zfar ", global.view_distance)
		if get_zfar() != orig_far*(global.view_distance/5):
			#print("reset cam")
			#print(orig_far, " ", global.view_distance, float(global.view_distance) / 5)
			set_zfar(orig_far*(float(global.view_distance)/5))
	
	last_delta = delta
	if Input.is_action_just_pressed("ui_cancel"):
		if len(cam_start_nodes) > 0:
			cam_start_nodes = []
			player_go = true
			level_start_hud.delete()
			return
		if mouse_captured:
			mouse_captured = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			player.pause = true
			var pause_menu = ResourceLoader.load("res://pause_debug.tscn") 
			var p = pause_menu.instance()
			p.camera = self
			p.player = player
			get_tree().get_root().add_child(p)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouse_captured = true
			player.pause = false
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
	if len(cam_start_nodes) > 0:
		var path = cam_start_nodes[0][0]
		var follow = path.get_children()[0]
		var trans = get_global_transform()
		trans.origin = follow.get_global_transform().origin
		set_global_transform(trans)
		look_at(cam_start_nodes[0][1], Vector3(0,1,0))
		follow.set_offset(follow.get_offset() + cam_start_nodes[0][2]*delta)
		if (follow.get_offset()/path.curve.get_baked_length()) >= 1 + cam_start_nodes[0][4]:
			cam_start_nodes.erase(cam_start_nodes[0])
		if len(cam_start_nodes) == 0:
			player_go = true
			set_global_transform(cam_start_trans)
			level_start_hud.delete()
		return

		
	if detach:
		look_at_from_position(detach_pos, player_pos, Vector3(0,1,0))
		next_level_timer -= delta
	else:
		#look_at_from_position(pos, target, Vector3(0,1,0))
		
		#print(area.get_overlapping_bodies())
		#pos = get_global_transform().origin
		#target = get_node("../../../Player").get_global_transform().origin
		#look_at_from_position(pos, target, Vector3(0,1,0))
		pos = get_global_transform().origin
		target = get_node("../../../Player").get_global_transform().origin
#		if (len(area.get_overlapping_bodies()) > 0):
#			print(area.get_overlapping_bodies())
#			camera_distance_decrease()
#		else:
#			move_set_camera_to_real()
		offset = (pos - target).normalized() * camera_distance
		pos = target + offset
		cam_body.move_and_slide((pos - cam_body.get_global_transform().origin)/delta, Vector3(0,0,0),false, 4, 0.7)
		look_at_from_position(cam_body.get_global_transform().origin, target, Vector3(0,1,0))
		#look_at_from_position(pos, target, Vector3(0,1,0))
	if next_level_timer < 0:
			call_deferred("_deferred_goto_scene", next_level)


func _input(event):
	if not player_go:
		return
	if detach:
		look_at_from_position(detach_pos, player_pos, Vector3(0,1,0))
		return
	pos = get_global_transform().origin
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
			var new_pos = pos
			new_pos += current_xform.basis[1] * y_change * camera_speed
			
			var vect_btwn = (new_pos - player.get_global_transform().origin).normalized()
			var n_vect = vect_btwn
			var old_vect = (pos - player.get_global_transform().origin).normalized()
			n_vect.y = 0
			old_vect.y = 0
			if rad2deg(n_vect.dot(vect_btwn)) > 10 or (old_vect.dot(vect_btwn) < n_vect.dot(vect_btwn)):
				pos = new_pos

	
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
			pass
				
	
	
	var real_camera_distance = camera_distance
	offset = (pos - target).normalized() * real_camera_distance
	pos = target + offset
	
	cam_body.move_and_slide((pos - cam_body.get_global_transform().origin)/last_delta, Vector3(0,0,0), false, 4, 0.7)
	look_at_from_position(cam_body.get_global_transform().origin, target, Vector3(0,1,0))
	#look_at_from_position(pos, target, Vector3(0,1,0))



func painting(level):
	detach = true
	detach_pos = get_global_transform().origin
	player_pos = get_node("../../../Player").get_global_transform().origin
	next_level = level


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
#	print(path)
#	var current_scene = get_tree().get_root().get_child(0)
#	#print(current_scene.get_children()[0].get_name())
#
#	current_scene.queue_free()
#
#	# Load the new scene.
#	var s = ResourceLoader.load(path) #ResourceLoader.load(path)
#
#	# Instance the new scene.
#	var new_scene = s.instance()
#
#    # Add it to the active scene, as child of root.
#	get_tree().get_root().add_child(new_scene)
#
#    # Optionally, to make it compatible with the SceneTree.change_scene() API.
#	get_tree().set_current_scene(new_scene)
#	self.queue_free()
	#var current_scene = get_tree().get_root().get_child(0)
	#current_scene.queue_free()
	get_tree().change_scene(path)
	queue_free()


func camera_distance_decrease():
	if set_camera_distance > 0.6:
		set_camera_distance -= 0.2
	if set_camera_distance < 0.4:
		set_camera_distance = 0.5


func move_set_camera_to_real():
	if abs(set_camera_distance - camera_distance) < 0.3:
		#set_camera_distance = camera_distance
		pass
	else:
		if set_camera_distance < camera_distance:
			set_camera_distance += 0.2
		else:
			set_camera_distance -= 0.2


func move_body_to_pos(some_pos):
	var current_pos = cam_body.get_global_transform().origin
	cam_body.move_and_slide(some_pos - current_pos, Vector3(0,1,0))
	return cam_body.get_global_transform().origin
	
	
func respawn():
	if camera_spawn != Vector3(0,0,0):
		print(camera_spawn)
		var real_camera_distance = camera_distance
		target = player.get_global_transform().origin
		#offset = (target + camera_spawn*target.length()).normalized() * real_camera_distance
		pos = target + camera_spawn.normalized()*real_camera_distance
		
		#cam_body.move_and_slide((pos - cam_body.get_global_transform().origin)/last_delta, Vector3(0,0,0), false, 4, 0.7)
		#cam_body.translate(pos - cam_body.get_global_transform().origin)
		var cam_body_trans = cam_body.get_global_transform()
		cam_body_trans.origin = pos
		cam_body.set_global_transform(cam_body_trans)
		look_at_from_position(pos, target, Vector3(0,1,0))
