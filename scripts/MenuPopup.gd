extends PanelContainer

signal unpaused
signal backtomenu

var is_game_over := false
var safe_to_click := false

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause") and !is_game_over:
		toggle_pause()
	elif Input.is_action_just_pressed("confirm"):
		if is_game_over and !safe_to_click:
			return
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
	await get_tree().create_timer(0.6, true, true).timeout
	safe_to_click = true
