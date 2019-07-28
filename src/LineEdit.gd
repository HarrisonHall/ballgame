extends LineEdit

# Declare member variables here. Examples:
var txtLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	txtLabel = get_text()
	set_text(txtLabel)
	get_node("RichTextLabel").set_text(txtLabel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#get_node("RichTextLabel").set_text(text_entered())
	pass
