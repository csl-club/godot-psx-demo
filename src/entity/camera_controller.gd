extends Node3D

@onready var sensibility : float = 0.008

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var yaw = -event.relative.x * sensibility;
		var pitch = -event.relative.y * sensibility;
		# Do rotate with unit vectors instead of rotate_x and y
		rotate(Vector3.UP, yaw)
		rotate_object_local(Vector3.RIGHT, pitch)
		rotation.x = clamp(rotation.x, -1.2, 1.2)
		pass
