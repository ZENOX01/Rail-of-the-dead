extends Entity
class_name User

@export var mouse_sensitivity: float = 0.5
@export var TILT_DOWN_LIMIT: float = deg_to_rad(-90.0)
@export var TILT_UP_LIMIT: float = deg_to_rad(90.0)

var move: Vector3

var _user_rotation: Vector3 
var _camera_rotation: Vector3 
var _mouse_rotation: Vector3 
var _mouse_input: bool = false
var _rotation_input: float
var _tilt_input: float


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _update_input() -> void:
	move = Vector3.ZERO
	if can_move:
		move.x = Input.get_axis("a","d")
		move.z = Input.get_axis("w","s")
	move = move.normalized()
	move_input = global_transform.basis * move
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()
	if event.is_action_pressed("jump"):
		_jump()
	if event.is_action_pressed("interact") and object_interaction != null:
		_interact()
	emit_signal("input_send", event)
func _update_camera(delta):
	if allow_rotation:
		_mouse_rotation.x += _tilt_input * delta
		_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_DOWN_LIMIT,TILT_UP_LIMIT)
		_mouse_rotation.y += _rotation_input * delta
		
		_user_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
		_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)
		
		camera.transform.basis = Basis.from_euler(_camera_rotation)
		camera.rotation.z = 0.0
		
		global_transform.basis = Basis.from_euler(_user_rotation)
		
		_rotation_input = 0.0
		_tilt_input = 0.0
func _unhandled_input(event: InputEvent) -> void:
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * mouse_sensitivity
		_tilt_input = -event.relative.y * mouse_sensitivity
