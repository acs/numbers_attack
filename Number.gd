extends RigidBody2D

export var min_speed = 150  # Minimum speed range.
export var max_speed = 250  # Maximum speed range.

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show_number(text):
	$Label.text = text
	$Label.show()

func get_number():
	queue_free()
	return $Label.text
	
func get_type():
	return "number"
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
