extends Area2D

signal delivered(npc, item : CompressedTexture2D)

func _ready():
	$Emote.hide()
	$PlusOne.hide()

func _on_body_entered(body):
	$Emote.show()
	body.toggle_jkey("npc")

func _on_body_exited(body):
	$Emote.hide()
	body.toggle_jkey("npc")

func assign_item(item_image : CompressedTexture2D):
	%ItemInside.texture = item_image

func get_tex() -> CompressedTexture2D:
	return %ItemInside.texture

func item_delivered():
	delivered.emit(self, %ItemInside.texture)
	$CPUParticles2D.set_emitting(true)
	$PlusOne.show()
	$TimeToLabelDisappear.stop()
	$TimeToLabelDisappear.start()

func _on_time_to_label_disappear_timeout():
	$PlusOne.hide()
