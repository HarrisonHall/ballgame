extends Spatial

export var spin_speed = 3
export var dead_timer = 0.05
export var rise_speed = 2
export var rotate_offset = 0

var dead = false
var pi_counter = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	rotate_y(rotate_offset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pi_counter += delta / 8
	if pi_counter >= 3.14 * 2:
		pi_counter = 0
	rotate_y(spin_speed*delta)
	translate(Vector3(0,sin(rad2deg(pi_counter))*0.015,0))
	if not dead:
		#rotate_y(spin_speed*delta)
		pass
	else:
		if dead_timer <= 0:
			queue_free()
		else:
			dead_timer -= delta
			translate(Vector3(0,rise_speed*delta,0))


func _on_Area_body_entered(body):
	if body.get_name() == "Player":
		body.increase_coin()
		dead = true
