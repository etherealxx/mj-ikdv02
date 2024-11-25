extends CharacterBody2D

signal picked_box

const SPEED = 150.0

@onready var anim = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_carrying := false
var box_pickup_sfx = load("res://assets/sfx/Cancel.wav")
var box_given_sfx = load("res://assets/sfx/Confirm.wav")

func _ready():
	$Emote.hide()
	%XSign.hide()

func play_audio(audio : AudioStream):
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = audio
	$AudioStreamPlayer.play()

func change_anim(anim_name : StringName):
	if !anim.get_animation() == anim_name: anim.play(anim_name)

func empty_item():
	%ItemInside.texture = Texture2D.new()
	$Emote.hide()
	%XSign.hide()
	is_carrying = false

func _unhandled_input(_event):
	if Input.is_action_just_pressed("confirm"):
		if !is_carrying: # code for picking box
			for body : Node2D in $BoxDetector.get_overlapping_bodies():
				if body.is_in_group("box"):
					$Emote.show()
					%ItemInside.texture = body.get_item_tex()
					body.queue_free()
					is_carrying = true
					picked_box.emit()
					$JKey.visible = false
					play_audio(box_pickup_sfx)
					return
		else: # code for giving box
			for body : Node2D in $BoxDetector.get_overlapping_bodies():
				if body.is_in_group("trash"):
					empty_item()
					$JKey.visible = false
					return
			for area : Node2D in $BoxDetector.get_overlapping_areas():
				if area.is_in_group("npc"):
					if %ItemInside.texture == area.get_tex():
						area.item_delivered()
						empty_item()
						$JKey.visible = false
						play_audio(box_given_sfx)
					else:
						print("wrong object")
					return
		print("you clicked on nothing")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		anim.flip_h = true if direction < 0 else false
		anim.offset.x = -20 if anim.flip_h else 0
		change_anim("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.x == 0:
			position.x = roundf(position.x)
		change_anim("idle")
	move_and_slide()

func _on_box_detector_body_entered(body): # also detect trashcan
	if body.is_in_group("trash"):
		%XSign.show()
		if is_carrying: $JKey.show()

func _on_box_detector_body_exited(body):
	if body.is_in_group("trash"):
		%XSign.hide()
		$JKey.hide()

func toggle_jkey(from : String):
	if (from == "box" and is_carrying) \
	or (from == "npc" and !is_carrying):
		return

	$JKey.visible = !$JKey.visible
