extends Node

signal input_mode_changed(mode: String)

const MODE_IDLE := "idle"
const MODE_TOUCH := "touch"
const MODE_CONTROLLER := "controller"

var current_mode: String = MODE_IDLE
var touch_controls: Control

func _ready() -> void:	
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	if not Input.get_connected_joypads().is_empty():
		_set_mode(MODE_CONTROLLER)
	else:
		_set_mode(MODE_TOUCH)

func set_touch_controls(control: Control) -> void:
	touch_controls = control
	_update_visibility()

func _input(event: InputEvent) -> void:
	if _is_controller_event(event):
		_set_mode(MODE_CONTROLLER)
	elif _is_touch_event(event):
		_set_mode(MODE_TOUCH)

func _is_controller_event(event: InputEvent) -> bool:
	if event is InputEventJoypadButton:
		return event.pressed
	if event is InputEventJoypadMotion:
		return absf(event.axis_value) > 0.25
	return false

func _is_touch_event(event: InputEvent) -> bool:
	if event is InputEventScreenTouch:
		return event.pressed
	if event is InputEventScreenDrag:
		return true
	# Mouse input is useful for desktop testing; ignore synthetic mouse events
	# generated from touch so the mode logic remains consistent on phones.
	if event is InputEventMouseButton:
		return event.pressed and event.device != InputEvent.DEVICE_ID_EMULATION
	return false

func _on_joy_connection_changed(_device: int, connected: bool) -> void:
	if connected:
		_set_mode(MODE_CONTROLLER)
	elif Input.get_connected_joypads().is_empty():
		_set_mode(MODE_TOUCH)

func _set_mode(new_mode: String) -> void:
	if current_mode == new_mode:
		_update_visibility()
		return
	current_mode = new_mode
	_update_visibility()
	input_mode_changed.emit(current_mode)

func _update_visibility() -> void:
	if is_instance_valid(touch_controls):
		touch_controls.visible = current_mode != MODE_CONTROLLER
