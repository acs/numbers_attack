extends Area2D

signal hit
signal hit_mob

export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.
var total_add  # Total sum for collected numbers
var total_subtract  # Total sum for collected numbers
var last_hit_number  # last number hit

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	last_hit_number = body
	if body.get_type() == "number":
		total_add += int(body.get_number())
		total_subtract -= int(body.get_number())
		emit_signal("hit")
	else:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		emit_signal("hit_mob")

func start(pos):
	total_add = 0
	total_subtract = 0
	position = pos
	show()
	$CollisionShape2D.disabled = false
