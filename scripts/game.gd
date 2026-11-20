extends Control

var input_manager: Node
var status_label: Label

func _ready() -> void:
	_build_scene()
	input_manager = preload("res://scripts/touch_controller_manager.gd").new()
	add_child(input_manager)
	input_manager.set_touch_controls(touch_controls)
	input_manager.input_mode_changed.connect(_on_input_mode_changed)
	_on_input_mode_changed(input_manager.current_mode)

var touch_controls: Control

func _build_scene() -> void:
	var bg := ColorRect.new()
	bg.color = Color("101020")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var heading := Label.new()
	heading.text = "SHATTERED REALITY"
	heading.position = Vector2(16, 12)
	heading.add_theme_color_override("font_color", Color("b9a8d8"))
	add_child(heading)

	status_label = Label.new()
	status_label.position = Vector2(16, 42)
	status_label.add_theme_font_size_override("font_size", 12)
	status_label.add_theme_color_override("font_color", Color("d8d0e8"))
	add_child(status_label)

	var center := Label.new()
	center.text = "GAMEPLAY FOUNDATION\n\nRoom generation, Sonic movement, combat,\nenemies, items and bosses are planned next."
	center.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	center.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.add_theme_color_override("font_color", Color("e7e0f4"))
	add_child(center)

	touch_controls = _make_touch_controls()
	add_child(touch_controls)

func _make_touch_controls() -> Control:
	var layer := Control.new()
	layer.name = "TouchControls"
	layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var stick := Label.new()
	stick.text = "◉\nMOVE"
	stick.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stick.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	stick.position = Vector2(24, 238)
	stick.size = Vector2(92, 92)
	stick.add_theme_font_size_override("font_size", 16)
	stick.add_theme_color_override("font_color", Color("ffffff"))
	stick.add_theme_color_override("font_shadow_color", Color("000000"))
	stick.add_theme_constant_override("shadow_offset_x", 2)
	stick.add_theme_constant_override("shadow_offset_y", 2)
	layer.add_child(stick)

	var attack_button := Button.new()
	attack_button.text = "SPIN"
	attack_button.position = Vector2(514, 260)
	attack_button.size = Vector2(92, 64)
	attack_button.add_theme_font_size_override("font_size", 15)
	attack_button.mouse_filter = Control.MOUSE_FILTER_STOP
	layer.add_child(attack_button)
	return layer

func _on_input_mode_changed(mode: String) -> void:
	if not is_instance_valid(status_label):
		return
	if mode == "controller":
		status_label.text = "CONTROLLER INPUT • TOUCH CONTROLS HIDDEN"
	elif mode == "touch":
		status_label.text = "TOUCH INPUT • CONTROLS VISIBLE"
	else:
		status_label.text = "CONTROLS READY"
