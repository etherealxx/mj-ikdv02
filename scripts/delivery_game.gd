extends Node2D

@export var possible_item : Array[CompressedTexture2D]

@onready var producer = $Producer

const box := preload("res://scenes/items/box.tscn")

var first_time_box := false
var last_box_reference

func _ready():
	$Player.picked_box.connect(_on_player_picking_box)
	producer.frame_changed.connect(_on_producer_anim_framechange)
	for npc in $Recipients.get_children():
		if npc.has_node("PlayerDetector"):
			var npc_code = npc.get_node("PlayerDetector")
			npc_code.assign_item(possible_item.pick_random())
			npc_code.delivered.connect(_on_npc_item_delivered)
			
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

func _on_player_picking_box():
	if box_count() < 5:
		producer.play()
