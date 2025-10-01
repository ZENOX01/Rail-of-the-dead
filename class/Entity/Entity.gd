extends CharacterBody3D
class_name Entity

@warning_ignore("unused_signal")
signal input_send(event: InputEvent)

@export var is_player: bool = true
@export var speed: float = 2
@export var jump_velocity: float = 5
@export var raycast: RayCast3D = null
@export var can_move: bool = true
@export var camera: Camera3D = null

var store_jump_velocity: float
var object_interaction: InteractableObject = null

var move_input: Vector3
var allow_rotation: bool = true

func _ready() -> void:
	pass
func _process(delta: float) -> void:
	_update_input()
	_update_camera(delta)
	if raycast != null:
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider is InteractableObject:
				object_interaction = collider
				if is_player and !object_interaction._check_indicator():
					object_interaction._indicate()
		else:
			if object_interaction != null:
				if is_player and object_interaction._check_indicator():
					object_interaction._contraindicate()
				object_interaction = null
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	_move_input(move_input)
	move_and_slide()
func _move_input(move: Vector3):
	velocity.x = move.x * speed
	velocity.z = move.z * speed
func _update_input() -> void:
	pass
@warning_ignore("unused_parameter")
func _update_camera(delta: float) -> void:
	pass
func _jump() -> void:
	if is_on_floor():
		velocity.y = jump_velocity
func _interact() -> void:
	object_interaction._interacted(self)
func _object_interact_replace(object: InteractableObject) -> void:
	object_interaction = object
func _object_interact_remove() -> void:
	object_interaction = null
func _active_move():
	can_move = true
	jump_velocity = store_jump_velocity
	allow_rotation = true
func _inactive_move():
	can_move = false
	store_jump_velocity = jump_velocity
	jump_velocity = 0.0
	allow_rotation = false
