extends Spatial

export var bounciness = 3
export var base_spring = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Area_body_entered(body):
	print(body)
	if body.get_name() == "Player":
		body.spring_factor = bounciness
		body.base_spring = base_spring
		body.is_bouncing = true


func _on_Area_body_exited(body):
	if body.get_name() == "Player":
		pass
