extends KinematicBody
signal comm

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var jump_height = 5
var movement_speed = 6
var screen_size
var r = get_transform()

# Called when the node enters the scene tree for the first time.
func _ready():
	#screen_size = get_viewport_rect().size
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector3(0,0,0)
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.z += jump_height
	#translate(Vector3(100,0,0))
	var direction = velocity.normalized() * delta
	move_and_slide(velocity, Vector3(0,1,0))
