extends PanelContainer

signal unpaused
signal backtomenu

var is_game_over := false

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause") and !is_game_over:
		toggle_pause()
	elif Input.is_action_just_pressed("confirm"):
		toggle_pause()
		backtomenu.emit()

func toggle_pause():
	self.visible = false
	get_tree().paused = false
	unpaused.emit()

func game_over_screen(score : int):
	is_game_over = true
	$PauseMenu.hide()
	$GameOverMenu.show()
	%ScoreHighscore.text = "Score : %d\nHighscore : %d" % [score, GlobalVar.high_score]
