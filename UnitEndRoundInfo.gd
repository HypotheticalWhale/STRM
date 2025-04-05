extends VBoxContainer

@onready var texture_node = get_node("UnitTextureMarginContainer/UnitTexture")
@onready var name_label = get_node("UnitName")
@onready var stats_label = get_node("UnitStats")

func show_unit_info(unit: Object):
	var red_sprite = unit.get_node("RedSprite")
	var blue_sprite = unit.get_node("BlueSprite")
	
	# only one of red sprite or blue sprite should be visible at one time.
	assert(red_sprite.visible != blue_sprite.visible)

	if red_sprite.visible:
		texture_node.texture = red_sprite.texture

	if blue_sprite.visible:
		texture_node.texture = blue_sprite.texture

	name_label.text = unit.NAME
	stats_label.text = "DMG DEALT: " + str(unit.damage_dealt)
	stats_label.text += "\n"
	stats_label.text += "DMG TAKEN: " + str(unit.damage_taken)
	
