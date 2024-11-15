extends Area2D

signal delivered(npc, item : CompressedTexture2D)

func _ready():
	$Emote.hide()

func _on_body_entered(_body):
	$Emote.show()

func _on_body_exited(_body):
	$Emote.hide()

func assign_item(item_image : CompressedTexture2D):
	%ItemInside.texture = item_image

func get_tex() -> CompressedTexture2D:
	return %ItemInside.texture

func item_delivered():
	delivered.emit(self, %ItemInside.texture)
