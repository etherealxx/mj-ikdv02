extends Node2D

@export_file("*.tscn") var main_gameplay_scene := ""

func _ready() -> void:
		%HighScoreLabel.text = "Highscore : %d" % GlobalVar.high_score
		get_window().set_mode(Window.MODE_MAXIMIZED)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("confirm"):
		get_tree().change_scene_to_file(main_gameplay_scene)
