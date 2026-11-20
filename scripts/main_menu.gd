extends Control

const GAME_SCENE := "res://scenes/game.tscn"

func _ready() -> void:
	_build_menu()

func _build_menu() -> void:
	var background := ColorRect.new()
	background.color = Color("090713")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var title := Label.new()
	title.text = "SONIC"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 64)
	title.add_theme_color_override("font_color", Color("46b9ff"))
	title.position = Vector2(0, 62)
	title.size = Vector2(640, 74)
	add_child(title)

	var subtitle := Label.new()
	subtitle.text = "SHATTERED REALITY"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 22)
	subtitle.add_theme_color_override("font_color", Color("e6d9ff"))
	subtitle.position = Vector2(0, 137)
	subtitle.size = Vector2(640, 35)
	add_child(subtitle)

	var warning := Label.new()
	warning.text = "THE WORLD IS NOT WHAT IT WAS"
	warning.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	warning.add_theme_font_size_override("font_size", 12)
	warning.add_theme_color_override("font_color", Color("a58cae"))
	warning.position = Vector2(0, 184)
	warning.size = Vector2(640, 24)
	add_child(warning)

	var start_button := _make_button("START", Vector2(220, 235))
	start_button.pressed.connect(_start_game)
	add_child(start_button)

	var footer := Label.new()
	footer.text = "TOUCH OR CONTROLLER • PRESS START"
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	footer.add_theme_font_size_override("font_size", 10)
	footer.add_theme_color_override("font_color", Color("746b83"))
	footer.position = Vector2(0, 316)
	footer.size = Vector2(640, 20)
	add_child(footer)

func _make_button(caption: String, button_position: Vector2) -> Button:
	var button := Button.new()
	button.text = caption
	button.position = button_position
	button.size = Vector2(200, 48)
	button.focus_mode = Control.FOCUS_ALL
	button.add_theme_font_size_override("font_size", 20)
	button.add_theme_color_override("font_color", Color("ffffff"))
	button.add_theme_color_override("font_hover_color", Color("65d2ff"))
	return button

func _start_game() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)
