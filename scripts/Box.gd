extends AnimatableBody2D
	
const MAX_TICK_BEFORE_MOVE := 3

var tick_before_move := MAX_TICK_BEFORE_MOVE
var is_moving := true

func _ready():
	$Emote.hide()

func _physics_process(_delta):
	if is_moving:
		tick_before_move -= 1
		if tick_before_move <= 0:
			position.x += 1
			tick_before_move = MAX_TICK_BEFORE_MOVE

func _on_front_box_detector_body_entered(body):
	if body != self:
		is_moving = false

func assign_item(item_image : CompressedTexture2D):
	%ItemInside.texture = item_image

func get_item_tex() -> CompressedTexture2D:
	return %ItemInside.texture

func _on_player_detector_body_entered(_body):
	$Emote.show()

func _on_player_detector_body_exited(_body):
	$Emote.hide()
