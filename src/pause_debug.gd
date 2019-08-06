extends Control

var esc_held_time = 0
var player
var camera

var view_distance
var effect_level 

# Called when the node enters the scene tree for the first time.
func _ready():
	view_distance = get_node("config/view distance")
	effect_level = get_node("config/effect level")
	
	view_distance.value = global.view_distance
	effect_level.value = global.effect_level


func _process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		queue_free()
	if Input.is_action_pressed("ui_cancel"):
		esc_held_time += delta
	if esc_held_time > .5:
		player.respawn()
		player.pause = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		camera.mouse_captured = true
		queue_free()
		
	global.view_distance = view_distance.value
	global.effect_level = effect_level.value


func _on_exit_pressed():
	global._exit_tree()
	get_tree().quit()


func _on_debug_pressed():
	get_tree().change_scene("res://Room1.tscn")


func _on_mountain_pressed():
	get_tree().change_scene("res://mountain.tscn")
