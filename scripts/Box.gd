extends AnimatableBody2D

var is_moving := true

func _ready():
	$Emote.hide()
	add_collision_exception_with(self)

func _physics_process(delta):
	var x_base_speed := 20.0 if is_moving else 0.0
	var motion_vec := Vector2(x_base_speed * delta, 0.0)
	move_and_collide(motion_vec)

func _on_front_box_detector_body_entered(body):
	if body != self:
		is_moving = false

func _on_front_box_detector_body_exited(body):
	if body != self:
		is_moving = true

func assign_item(item_image : CompressedTexture2D):
	%ItemInside.texture = item_image

func get_item_tex() -> CompressedTexture2D:
	return %ItemInside.texture

func _on_player_detector_body_entered(_body):
	$Emote.show()

func _on_player_detector_body_exited(_body):
	$Emote.hide()
