extends Node

export (PackedScene) var Number
export (PackedScene) var Mob

var operation  # operation for the game: add, subtract, multiply, divide
var score
var total
var operations = ['add']

const MAX_NUMBER = 4
const LEVEL1_SCORE = 3

func _ready():
	randomize()

func game_over():
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

func check_number():
	if operation == "add":
		check_sum()
	elif operation == "subtract":
		check_subtract()

func check_sum():
	if int($HUD/Goal.text) != total + $Player.hit_number.get_number():
		game_over()
	else:
		score += 1
		total += $Player.hit_number.get_number()
		if score == LEVEL1_SCORE:
			print_debug(operations)
			operations.append("subtract")
			print_debug(operations)
		$HUD.update_score(score)
		operation = operations[randi() % operations.size()]
		$HUD.update_goal(operation, total, MAX_NUMBER)
		$Player.hit_number.queue_free()

func check_subtract():
	if int($HUD/Goal.text) != total - $Player.hit_number.get_number():
		game_over()
	else:
		score += 1
		total -= $Player.hit_number.get_number()
		$HUD.update_score(score)
		operation = operations[randi() % operations.size()]
		$HUD.update_goal(operation, total, MAX_NUMBER)
		$Player.hit_number.queue_free()

func new_game(op="add"):
	operation = op
	score = 0
	total = 0
	# $HUD.update_score(score)
	$HUD.update_score(score)
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
	
func _on_StartTimer_timeout():
	$MobTimer.start()
	$NumberTimer.start()

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
