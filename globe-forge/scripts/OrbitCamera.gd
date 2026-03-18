extends Camera3D

@export var target: Node3D          # Drag your Globe node here later
@export var distance: float = 20.0
@export var min_distance: float = 8.0
@export var max_distance: float = 60.0
@export var sensitivity: float = 0.003
@export var zoom_speed: float = 5.0

var yaw: float = 0.0
var pitch: float = 0.0

func _ready():
	if not target:
		target = get_parent()       # auto-target parent if not set
	update_camera()

func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			yaw -= event.relative.x * sensitivity
			pitch -= event.relative.y * sensitivity
			pitch = clamp(pitch, -PI/2 + 0.05, PI/2 - 0.05)  # prevent flip
			update_camera()
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			distance -= zoom_speed
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			distance += zoom_speed
		distance = clamp(distance, min_distance, max_distance)
		update_camera()

func update_camera():
	var dir = Vector3(
		sin(yaw) * cos(pitch),
		sin(pitch),
		cos(yaw) * cos(pitch)
	).normalized()
	global_position = target.global_position + dir * distance
	look_at(target.global_position, Vector3.UP)
