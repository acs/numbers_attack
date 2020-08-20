extends CanvasLayer

signal start_game

var current_total
var goal_number

func show_message(text, timeout=1):
	$Message.text = text
	$Message.show()
	$MessageTimer.wait_time = timeout
	$MessageTimer.start()

func show_game_over():
	show_message("Goal number: " + str(goal_number), 5)
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")
	show_message("Game Over")
	yield($MessageTimer, "timeout")

	$Message.text = "Numbers Attack!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	
#func update_score(score):
#	$ScoreLabel.text = str(score)
	
func update_goal(total, max_number):
	$Operation.text = str(total) + " + ? = "
	goal_number = round(rand_range(0, max_number))
	$Goal.text = str(total + goal_number)

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Message.hide()
