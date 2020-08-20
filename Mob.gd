extends RigidBody2D

export var min_speed = 150  # Minimum speed range.
export var max_speed = 250  # Maximum speed range.

var type

func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	type = mob_types[randi() % mob_types.size()]
	$AnimatedSprite.animation = type


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_type():
	return type

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
