extends CanvasLayer

signal start_game
signal resume_game

var goal_number

const ADD = "add"
const SUBTRACT = "subtract"
const MULTIPLY = "multiply"
const DIVIDE = "divide"

func _ready():
	$ResumeButton.hide()

func show_message(text, timeout=1):
	$Message.text = text
	$Message.show()
	$MessageTimer.wait_time = timeout
	$MessageTimer.start()

func show_game_over():
	show_message("Goal number: " + str(goal_number), 2)
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")
	show_message("Game Over")
	yield($MessageTimer, "timeout")

	$Message.text = "Numbers Attack!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	show_buttons()
	

func _input(ev):
	if Input.is_key_pressed(KEY_P):
		get_tree().paused = !get_tree().paused
		$ResumeButton.hide()
		if get_tree().paused:
			$ResumeButton.show()
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene("res://Main.tscn")
	
func update_goal(operation, total, max_number):
	if operation == ADD:
		$Operation.text = str(total) + " + ? = "
		goal_number = round(rand_range(0, max_number))
		$Goal.text = str(total + goal_number)
	elif operation == SUBTRACT:
		$Operation.text = str(total) + " - ? = "
		goal_number = round(rand_range(0, max_number))
		$Goal.text = str(total - goal_number)
	elif operation == MULTIPLY:
		$Operation.text = str(total) + " x ? = "
		goal_number = round(rand_range(0, max_number))
		$Goal.text = str(total * goal_number)
	elif operation == DIVIDE:
		$Operation.text = str(total) + " / ? = "
		goal_number = round(rand_range(1, max_number))
		$Goal.text = str(round(total / goal_number))
	
func update_score(score):
	$Score.text = "Score: " + str(score)
	

func hide_buttons():
	$StartButton.hide()
	$ExitButton.hide()
	
func show_buttons():
	$StartButton.show()
	$ExitButton.show()

func _on_MessageTimer_timeout():
	$Message.hide()

func _on_ResumeButton_pressed():
	$ResumeButton.hide()
	emit_signal("resume_game")

func _on_StartButton_pressed():
	hide_buttons()
	emit_signal("start_game")

func _on_ExitButton_pressed():
	get_tree().quit()
