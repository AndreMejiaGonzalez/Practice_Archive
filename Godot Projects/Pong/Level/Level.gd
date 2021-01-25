extends Node

var playerScore = 0
var opponentScore = 0

func _on_Left_body_entered(body):
	opponentScore += 1
	scored()

func _on_Right_body_entered(body):
	playerScore += 1
	scored()

func _process(delta):
	$"Score Board/Player Score".text = str(playerScore)
	$"Score Board/Opponent Score".text = str(opponentScore)
	$"CountDown/CountDown Label".text = str(int($CountDown.time_left) + 1)

func _on_CountDown_timeout():
	get_tree().call_group('BallGroup', 'restartBall')
	$"CountDown/CountDown Label".visible = false

func scored():
	if playerScore > 0 && playerScore % 5 == 0:
		get_tree().call_group('OpponentGroup', 'getFaster')
	get_tree().call_group('BallGroup', 'stopBall')
	$Ball.position = Vector2(640,360)
	$CountDown.start()
	$"CountDown/CountDown Label".visible = true
	$"SFX/Score Sound".play()
	$Player.position.x = 60
	$Opponent.position.x = 1220
