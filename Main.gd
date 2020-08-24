extends Node

export (PackedScene) var Number
export (PackedScene) var Mob

var mobs = false  # mobs active or not
var operation  # operation for the game: add, subtract, multiply, divide
var operations  # active operations
var score = 0
var total = 0

var max_number

var levels  # dict with the info about the levels of the game

func init_levels():
	# key is the score needed to reach the level
	levels = {
		0: {
			"numbers_speed": 3,
			"max_number": 2,
			"operations": [$HUD.ADD],
			"mobs": false
		},
		10: {
			"numbers_speed": 2,
			"max_number": 3,
			"operations": [$HUD.ADD],
			"mobs": true
		},
		20: {
			"numbers_speed": 2,
			"max_number": 3,
			"operations": [$HUD.ADD, $HUD.SUBTRACT],
			"mobs": false
		},
		30: {
			"numbers_speed": 3,
			"max_number": 2,
			"operations": [$HUD.ADD, $HUD.SUBTRACT, $HUD.MULTIPLY],
			"mobs": false
		},
		40: {
			"numbers_speed": 2,
			"max_number": 2,
			"operations": [$HUD.ADD, $HUD.SUBTRACT, $HUD.MULTIPLY, $HUD.DIVIDE],
			"mobs": true
		}
	}

func check_level():
	if score in levels:
		operations = levels[score]["operations"]
		mobs = levels[score]["mobs"]
		$NumberTimer.wait_time = levels[score]["numbers_speed"]
		max_number = levels[score]['max_number']

func _ready():
	randomize()
	init_levels()
	check_level()

func new_game():
	total = 0
	score = 0
	operation = operations[0]
	$HUD.update_score(score)
	$HUD.update_goal(operation, total, max_number)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()

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

func update_score():
		score += 1
		$HUD.update_score(score)

func check_number():
	var hit_number = $Player.hit_number.get_number()
	if operation == $HUD.ADD:
		total += hit_number
	elif operation == $HUD.SUBTRACT:
		total -= hit_number
	elif operation == $HUD.MULTIPLY:
		total *= hit_number
	elif operation == $HUD.DIVIDE && hit_number != 0:
		total = round(total / $Player.hit_number.get_number())
	if int($HUD/Goal.text) != total:
		game_over()
	else:
		# Correct answer
		update_score()
		check_level()
		operation = operations[randi() % operations.size()]
		if operation == $HUD.MULTIPLY:
			$HUD.update_goal(operation, total, max_number)
		elif operation == $HUD.DIVIDE:
			$HUD.update_goal(operation, total, max_number)
		else:
			$HUD.update_goal(operation, total, max_number)
		$Player.hit_number.queue_free()
	
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
	number.show_number(str(round(rand_range(0, max_number))))

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
	if mobs:
		add_mob()
	
func _on_NumberTimer_timeout():
	add_number()
	
func _on_StartTimer_timeout():
	$MobTimer.start()
	$NumberTimer.start()

func _on_HUD_resume_game():
	get_tree().paused = false

func _on_HUD_start_game():
	new_game()
