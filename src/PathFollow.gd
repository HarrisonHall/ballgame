extends PathFollow

export var current_offset = 0
export var hop_speed = .3

# Called when the node enters the scene tree for the first time.
func _ready():
	set_offset(current_offset)


func _process(delta):
	set_offset(get_offset()+hop_speed)
