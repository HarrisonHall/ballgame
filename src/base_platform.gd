extends Spatial

#export(Color) var new_color = Color(80/256,250/256,123/256, 1)
export(Color) var new_color = Color(80/256,250/256,123/256, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#get_child(0).material_override.albedo_color = new_color
	#get_child(0).get_surface_material(0).albedo_color = new_color
	#material_override.albedo_color = new_color
	pass
