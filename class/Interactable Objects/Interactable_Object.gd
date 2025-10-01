extends PhysicsBody3D
class_name InteractableObject

@export var indicator: Label3D = null

var user: Entity = null
var used: bool = false
var indicator_orientation: Vector3

var attached_user: bool = false


func _ready() -> void:
	if indicator != null:
		indicator.visible = false
		indicator_orientation = indicator.rotation

func _indicate():
	if indicator != null:
		indicator.visible = true

func _contraindicate():
	if indicator != null:
		indicator.visible = false

func _check_indicator() -> bool:
	if indicator != null:
		if indicator.visible:
			return true
		else:
			if indicator.rotation != indicator_orientation:
				indicator.rotation = indicator_orientation
			return false
	else:
		return false

@warning_ignore("unused_parameter")
func _interacted(by: Entity):
	pass
@warning_ignore("unused_parameter")
func _disassociate(event: InputEvent):
	pass
func _add_user(by: Entity):
	user = by
	used = true

func _remove_user():
	user = null
	used = false
	
func _attach() -> void:
	if user and used:
		attached_user = true
func _disattach() -> void:
	attached_user = false
