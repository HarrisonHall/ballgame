extends Spatial

export var boost = 1.2
var body

# Called when the node enters the scene tree for the first time.
func _ready():
	body = get_node("MeshInstance/Area")
	#print(get_tree().get_root())
	#self.connect("is_boosting", get_tree().get_root(), "_on_boost_area_enter")


func _on_Area_body_entered(body):
	if body.get_name() == "Player":
		body.is_boosting = true
		body.boost_factor = boost


func _on_Area_body_exited(body):
	if body.get_name() == "Player":
		body.is_boosting = false
