extends Control

var esc_held_time = 0
var player
var camera

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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


func _on_exit_pressed():
	get_tree().quit()


func _on_debug_pressed():
	get_tree().change_scene("res://Room1.tscn")


func _on_mountain_pressed():
	get_tree().change_scene("res://mountain.tscn")
