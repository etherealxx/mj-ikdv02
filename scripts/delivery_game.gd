extends Node2D

@export var possible_item : Array[CompressedTexture2D]
@export_file("*.tscn") var main_menu_scene := ""

@onready var producer = $Producer

const box := preload("res://scenes/items/box.tscn")

var first_time_box := false
var time_left := 60
var score := 0
var is_paused := false
var is_game_over := true

func _ready():
	%MenuPopup.hide()
	%PauseRect.hide()
	$Player.picked_box.connect(_on_player_picking_box)
	producer.frame_changed.connect(_on_producer_anim_framechange)
	%MenuPopup.unpaused.connect(_on_unpause)
	%MenuPopup.backtomenu.connect(_on_backtomenu)
	for npc in $Recipients.get_children():
		if npc.has_node("PlayerDetector"):
			var npc_code = npc.get_node("PlayerDetector")
			npc_code.assign_item(possible_item.pick_random())
			npc_code.delivered.connect(_on_npc_item_delivered)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause") and !is_paused:
		is_paused = true
		toggle_pause()
		
func _on_unpause():
	%PauseRect.hide()
	await get_tree().create_timer(0.1, true, true).timeout
	is_paused = false

func _on_backtomenu():
	if score > GlobalVar.high_score: GlobalVar.high_score = score
	get_tree().change_scene_to_file(main_menu_scene)
	
func toggle_pause():
	get_tree().paused = true
	%MenuPopup.show()
	%PauseRect.show()

func box_count() -> int:
	return $Boxes.get_child_count()

func _on_producer_anim_framechange():
		match (producer.frame):
			0:
				if box_count() >= 4:
					producer.pause()
				else:
					producer.play()
			5:
				if (randi_range(1,3) == 1 and box_count() < 5) \
				or !first_time_box:
					var new_box = box.instantiate()
					new_box.position = %BoxSpawnSpot.position
					new_box.assign_item(possible_item.pick_random())
					$Boxes.add_child(new_box)
					#last_box_reference = new_box
					first_time_box = true

func _on_npc_item_delivered(npc, item : CompressedTexture2D):
	var next_chosen_item = possible_item.pick_random()
	while item == next_chosen_item:
		next_chosen_item = possible_item.pick_random()
	npc.assign_item(next_chosen_item)
	score += 1
	update_score_label()
	%AnimationPlayer.play("label_pop")

func _on_player_picking_box():
	if box_count() < 5:
		producer.play()

func update_score_label():
	%ScoreTimeLabel.text = "Score: %d | Time left: %d" % [score, time_left]

func _on_second_timer_timeout():
	if time_left > 0:
		time_left -= 1
		update_score_label()
	else:
		if score > GlobalVar.high_score: GlobalVar.high_score = score
		toggle_pause()
		%MenuPopup.game_over_screen(score)
