extends Node

export (PackedScene) var Number
export (PackedScene) var Mob

var score
var total

const MAX_NUMBER = 2

func _ready():
	randomize()
	# new_game()

func _input(ev):
	if Input.is_key_pressed(KEY_P):
		get_tree().paused = true
		$HUD/ResumeButton.show()
	if Input.is_key_pressed(KEY_ESCAPE):
		game_over()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$NumberTimer.stop()
	$HUD.show_game_over()
	# Take a little pause to take a look to the last scene
	get_tree().paused = true
	yield(get_tree().create_timer(1), "timeout")
	get_tree().paused = false
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("numbers", "queue_free")
	$Music.stop()
	$DeathSound.play()

func check_sum():
	if int($HUD/Goal.text) != $Player.total_sum:
		game_over()
	else:
		$HUD.update_goal($Player.total_sum, MAX_NUMBER)

func new_game():
	score = 0
	total = 0
	# $HUD.update_score(score)
	$HUD.update_goal(total, MAX_NUMBER)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()
	
func add_number():
	# Create a Mob instance and add it to the scene.
	var number = Number.instance()
	add_child(number)
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.offset = randi()
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	number.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	number.rotation = direction
	# Set the velocity (speed & direction).
	number.linear_velocity = Vector2(rand_range(number.min_speed, number.max_speed), 0)
	number.linear_velocity = number.linear_velocity.rotated(direction)
	number.show_number(str(round(rand_range(0, MAX_NUMBER))))

func add_mob():
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	add_child(mob)
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.offset = randi()
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	
func _on_MobTimer_timeout():
	add_mob()
	pass
	
func _on_NumberTimer_timeout():
	add_number()
	
func _on_ScoreTimer_timeout():
	score += 1
	# $HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$NumberTimer.start()
	$ScoreTimer.start()

func _on_HUD_resume_game():
	get_tree().paused = false
