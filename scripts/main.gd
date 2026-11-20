extends Node2D

enum Screen { TITLE, GAME, PAUSE, GAME_OVER }
var screen: Screen = Screen.TITLE
var player := Vector2(480, 285)
var player_velocity := Vector2.ZERO
var hp := 3
var rings := 0
var elapsed := 0.0
var enemies: Array[Dictionary] = []
var ring_items: Array[Vector2] = []
var attack_cooldown := 0.0
var invulnerable := 0.0
var spawn_timer := 0.0
var touch_vector := Vector2.ZERO
var touch_attack := false
var active_touches: Dictionary = {}
var controls_visible := true
var last_input_was_touch := false
var font: Font
const PLAYER_SPEED := 220.0
const ARENA := Rect2(64, 82, 832, 390)

func _ready() -> void:
    font = ThemeDB.fallback_font
    randomize()
    set_process(true)
    set_process_input(true)

func _process(delta: float) -> void:
    elapsed += delta
    attack_cooldown = maxf(0.0, attack_cooldown - delta)
    invulnerable = maxf(0.0, invulnerable - delta)
    if screen == Screen.GAME:
        _update_game(delta)
    queue_redraw()

func _update_game(delta: float) -> void:
    var axis := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if axis.length() < 0.1:
        axis = touch_vector
    if axis.length() > 1.0:
        axis = axis.normalized()
    player += axis * PLAYER_SPEED * delta
    player.x = clampf(player.x, ARENA.position.x + 15, ARENA.end.x - 15)
    player.y = clampf(player.y, ARENA.position.y + 15, ARENA.end.y - 15)

    if Input.is_action_just_pressed("attack") or touch_attack:
        _attack()
        touch_attack = false

    for i in range(enemies.size() - 1, -1, -1):
        var enemy: Dictionary = enemies[i]
        var pos: Vector2 = enemy["pos"]
        var to_player := player - pos
        if to_player.length() > 2.0:
            pos += to_player.normalized() * float(enemy["speed"]) * delta
        enemy["pos"] = pos
        enemy["flash"] = maxf(0.0, float(enemy["flash"]) - delta)
        enemies[i] = enemy
        if pos.distance_to(player) < 25.0 and invulnerable <= 0.0:
            hp -= 1
            invulnerable = 1.0
            if hp <= 0:
                screen = Screen.GAME_OVER

    for i in range(ring_items.size() - 1, -1, -1):
        if ring_items[i].distance_to(player) < 24.0:
            rings += 1
            ring_items.remove_at(i)

    spawn_timer -= delta
    if spawn_timer <= 0.0 and enemies.size() < 7:
        _spawn_enemy()
        spawn_timer = maxf(1.2, 3.2 - elapsed * 0.025)

func _spawn_enemy() -> void:
    var side := randi_range(0, 3)
    var pos := Vector2.ZERO
    match side:
        0: pos = Vector2(randf_range(ARENA.position.x, ARENA.end.x), ARENA.position.y + 18)
        1: pos = Vector2(ARENA.end.x - 18, randf_range(ARENA.position.y, ARENA.end.y))
        2: pos = Vector2(randf_range(ARENA.position.x, ARENA.end.x), ARENA.end.y - 18)
        _: pos = Vector2(ARENA.position.x + 18, randf_range(ARENA.position.y, ARENA.end.y))
    enemies.append({"pos": pos, "speed": randf_range(52.0, 78.0) + elapsed * 0.25, "flash": 0.0})

func _attack() -> void:
    if attack_cooldown > 0.0:
        return
    attack_cooldown = 0.38
    for i in range(enemies.size() - 1, -1, -1):
        if Vector2(enemies[i]["pos"]).distance_to(player) < 82.0:
            var defeated: Vector2 = enemies[i]["pos"]
            enemies.remove_at(i)
            ring_items.append(defeated)
            break

func _start_game() -> void:
    screen = Screen.GAME
    player = Vector2(480, 285)
    hp = 3
    rings = 0
    elapsed = 0.0
    enemies.clear()
    ring_items.clear()
    spawn_timer = 0.8
    attack_cooldown = 0.0
    invulnerable = 0.0
    touch_vector = Vector2.ZERO
    touch_attack = false

func _input(event: InputEvent) -> void:
    if event is InputEventJoypadButton or event is InputEventJoypadMotion:
        controls_visible = false
        last_input_was_touch = false
        if event is InputEventJoypadButton and event.pressed:
            if screen == Screen.TITLE:
                _start_game()
            elif screen == Screen.GAME_OVER:
                _start_game()
    elif event is InputEventScreenTouch or event is InputEventScreenDrag or event is InputEventMouseButton or event is InputEventMouseMotion:
        if event is InputEventScreenTouch and event.pressed:
            controls_visible = true
            last_input_was_touch = true
        elif event is InputEventMouseButton and event.pressed:
            controls_visible = true
            last_input_was_touch = true

    if event.is_action_pressed("ui_cancel"):
        if screen == Screen.GAME:
            screen = Screen.PAUSE
        elif screen == Screen.PAUSE:
            screen = Screen.GAME
        return

    if event is InputEventScreenTouch:
        if event.pressed:
            if screen != Screen.GAME:
                _handle_pointer(event.position)
            active_touches[event.index] = event.position
        else:
            active_touches.erase(event.index)
            _refresh_touch_controls()
        _handle_touch_positions()
    elif event is InputEventScreenDrag:
        active_touches[event.index] = event.position
        _handle_touch_positions()
    elif event is InputEventMouseButton and event.pressed:
        _handle_pointer(event.position)

func _refresh_touch_controls() -> void:
    touch_vector = Vector2.ZERO
    touch_attack = false

func _handle_touch_positions() -> void:
    touch_vector = Vector2.ZERO
    touch_attack = false
    for p in active_touches.values():
        var pos: Vector2 = p
        if pos.x < 230 and pos.y > 330:
            var center := Vector2(118, 425)
            var v := (pos - center) / 62.0
            if v.length() > 1.0:
                v = v.normalized()
            touch_vector = v
        elif pos.x > 730 and pos.y > 330:
            touch_attack = true

func _handle_pointer(pos: Vector2) -> void:
    if screen == Screen.TITLE:
        if Rect2(365, 330, 230, 62).has_point(pos):
            _start_game()
    elif screen == Screen.PAUSE:
        if Rect2(365, 290, 230, 60).has_point(pos):
            screen = Screen.GAME
        elif Rect2(365, 365, 230, 60).has_point(pos):
            screen = Screen.TITLE
    elif screen == Screen.GAME_OVER:
        if Rect2(365, 340, 230, 60).has_point(pos):
            screen = Screen.TITLE
    elif screen == Screen.GAME:
        if Rect2(0, 0, 100, 75).has_point(pos):
            screen = Screen.PAUSE
        elif pos.x > 730 and pos.y > 330:
            _attack()

func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, Vector2(960, 540)), Color("#090d18"))
    _draw_stars()
    match screen:
        Screen.TITLE: _draw_title()
        Screen.GAME: _draw_game()
        Screen.PAUSE: 
            _draw_game()
            _draw_overlay("PAUSED", "Tap RESUME or press Start / Options")
            _draw_button(Rect2(365, 290, 230, 60), "RESUME")
            _draw_button(Rect2(365, 365, 230, 60), "TITLE")
        Screen.GAME_OVER:
            _draw_game()
            _draw_overlay("RUN ENDED", "Rings collected: " + str(rings))
            _draw_button(Rect2(365, 340, 230, 60), "TITLE")

func _draw_stars() -> void:
    for i in range(46):
        var x := fposmod(float(i * 173 + 41), 960.0)
        var y := fposmod(float(i * 97 + 19), 540.0)
        draw_rect(Rect2(x, y, 2, 2), Color(0.25, 0.35, 0.48, 0.45))

func _draw_title() -> void:
    _center_text("SONIC", 150, 64, Color("#32a8ff"))
    _center_text("SHATTERED REALITY", 205, 27, Color("#f3d56b"))
    _center_text("A CORRUPTED WORLD AWAITS", 252, 15, Color("#aab7cb"))
    _draw_pixel_sonic(Vector2(480, 300), 1.7)
    _draw_button(Rect2(365, 390, 230, 62), "START")
    _center_text("TOUCH  •  CONTROLLER  •  KEYBOARD", 495, 13, Color("#8190a8"))

func _draw_game() -> void:
    draw_rect(ARENA, Color("#172238"), true)
    for x in range(ARENA.position.x, int(ARENA.end.x), 32):
        draw_line(Vector2(x, ARENA.position.y), Vector2(x, ARENA.end.y), Color("#22314b"), 1)
    for y in range(ARENA.position.y, int(ARENA.end.y), 32):
        draw_line(Vector2(ARENA.position.x, y), Vector2(ARENA.end.x, y), Color("#22314b"), 1)
    draw_rect(ARENA, Color("#53647d"), false, 3)
    for r in ring_items:
        _draw_ring(r)
    for enemy in enemies:
        _draw_enemy(enemy["pos"], float(enemy["flash"]))
    if invulnerable <= 0.0 or int(elapsed * 12.0) % 2 == 0:
        _draw_pixel_sonic(player, 1.0)
    draw_rect(Rect2(24, 18, 912, 48), Color("#101827"))
    _text("RINGS  " + str(rings), Vector2(42, 49), 20, Color("#f3d56b"))
    _text("HEALTH  " + "♥".repeat(maxi(0, hp)), Vector2(260, 49), 20, Color("#ff7185"))
    _text("TIME  " + str(int(elapsed)), Vector2(790, 49), 18, Color("#dce6f5"))
    _text("II  PAUSE", Vector2(26, 69), 12, Color("#aab7cb"))
    if controls_visible:
        _draw_touch_controls()

func _draw_touch_controls() -> void:
    draw_circle(Vector2(118, 425), 57, Color(0.45, 0.62, 0.85, 0.20))
    draw_arc(Vector2(118, 425), 57, 0, TAU, 40, Color(0.65, 0.78, 1.0, 0.75), 3)
    draw_circle(Vector2(118, 425) + touch_vector * 24, 22, Color(0.72, 0.84, 1.0, 0.45))
    draw_circle(Vector2(820, 425), 53, Color(0.85, 0.28, 0.38, 0.24))
    draw_arc(Vector2(820, 425), 53, 0, TAU, 40, Color("#ff8494"), 3)
    _center_text_at("SPIN", Vector2(820, 431), 17, Color.WHITE)

func _draw_pixel_sonic(pos: Vector2, scale: float) -> void:
    var s := 8.0 * scale
    draw_rect(Rect2(pos + Vector2(-3*s, -2*s), Vector2(6*s, 5*s)), Color("#1674d1"))
    draw_rect(Rect2(pos + Vector2(-3*s, -3*s), Vector2(5*s, 2*s)), Color("#258ff0"))
    draw_rect(Rect2(pos + Vector2(-4*s, -4*s), Vector2(2*s, 2*s)), Color("#1674d1"))
    draw_rect(Rect2(pos + Vector2(1*s, -4*s), Vector2(2*s, 2*s)), Color("#1674d1"))
    draw_rect(Rect2(pos + Vector2(-2*s, -1*s), Vector2(4*s, 2*s)), Color("#f1c6a1"))
    draw_rect(Rect2(pos + Vector2(1*s, -2*s), Vector2(1*s, 2*s)), Color.WHITE)
    draw_rect(Rect2(pos + Vector2(2*s, -2*s), Vector2(1*s, 1*s)), Color("#101827"))
    draw_rect(Rect2(pos + Vector2(-3*s, 2*s), Vector2(3*s, 2*s)), Color("#e83c48"))
    draw_rect(Rect2(pos + Vector2(1*s, 2*s), Vector2(3*s, 2*s)), Color("#e83c48"))
    draw_rect(Rect2(pos + Vector2(-4*s, 3*s), Vector2(4*s, s)), Color.WHITE)
    draw_rect(Rect2(pos + Vector2(1*s, 3*s), Vector2(4*s, s)), Color.WHITE)

func _draw_enemy(pos: Vector2, flash: float) -> void:
    var c := Color("#ff405d") if flash <= 0.0 else Color.WHITE
    draw_rect(Rect2(pos + Vector2(-13, -12), Vector2(26, 24)), c)
    draw_rect(Rect2(pos + Vector2(-17, -17), Vector2(10, 8)), Color("#a51f42"))
    draw_rect(Rect2(pos + Vector2(7, -17), Vector2(10, 8)), Color("#a51f42"))
    draw_rect(Rect2(pos + Vector2(-7, -4), Vector2(4, 4)), Color.WHITE)
    draw_rect(Rect2(pos + Vector2(4, -4), Vector2(4, 4)), Color.WHITE)

func _draw_ring(pos: Vector2) -> void:
    draw_arc(pos, 10, 0, TAU, 24, Color("#ffd84d"), 4)
    draw_arc(pos, 5, 0, TAU, 24, Color("#fff1a6"), 2)

func _draw_button(rect: Rect2, label: String) -> void:
    draw_rect(rect, Color("#173c67"))
    draw_rect(rect, Color("#63b7ff"), false, 3)
    _center_text_at(label, rect.get_center() + Vector2(0, 7), 24, Color.WHITE)

func _draw_overlay(title: String, subtitle: String) -> void:
    draw_rect(Rect2(0, 0, 960, 540), Color(0, 0, 0, 0.72))
    _center_text(title, 205, 42, Color("#f3d56b"))
    _center_text(subtitle, 248, 18, Color("#dce6f5"))

func _text(value: String, pos: Vector2, size: int, color: Color) -> void:
    draw_string(font, pos, value, HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)

func _center_text(value: String, y: float, size: int, color: Color) -> void:
    _center_text_at(value, Vector2(480, y), size, color)

func _center_text_at(value: String, center: Vector2, size: int, color: Color) -> void:
    var width := font.get_string_size(value, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x
    draw_string(font, Vector2(center.x - width / 2.0, center.y), value, HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)
