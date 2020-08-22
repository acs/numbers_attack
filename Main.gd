extends Node

export (PackedScene) var Number
export (PackedScene) var Mob

var operation  # operation for the game: add, subtract, multiply, divide
var score
var total

const MAX_NUMBER = 2

func _ready():
	randomize()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$NumberTimer.stop()
	$HUD.show_game_over()
	# Take a little pause to take a look to the last scene
	get_tree().paused = true
	yield(get_tree().create_timer(2), "timeout")
	get_tree().paused = false
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("numbers", "queue_free")
	$Player.hide()
	$Music.stop()
	$DeathSound.play()

func check_operation():
	if operation == "add":
		check_sum()
	elif operation == "subtract":
		check_subtract()

func check_sum():
	if int($HUD/Goal.text) != $Player.total_add:
		game_over()
	else:
		$HUD.update_goal(operation, $Player.total_add, MAX_NUMBER)
		$Player.last_hit_number.queue_free()

func check_subtract():
	if int($HUD/Goal.text) != $Player.total_subtract:
		game_over()
	else:
		$HUD.update_goal(operation, $Player.total_subtract, MAX_NUMBER)
		$Player.last_hit_number.queue_free()

func new_game(op="add"):
	operation = op
	score = 0
	total = 0
	# $HUD.update_score(score)
	$HUD.update_goal(operation, total, MAX_NUMBER)
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
	# add_mob()
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

func _on_HUD_start_game_add():
	new_game("add")

func _on_HUD_start_game_subtract():
	new_game("subtract")

func _on_HUD_start_game_multiply():
	new_game("multiply")

func _on_HUD_start_game_divide():
	new_game("divide")

