class_name Player
extends CharacterBody3D


@onready var _mouse_dir = Vector2.ZERO
@onready var speed : float = 5
@onready var gravity : float = 15

@onready var sensibility : float = 0.008

@onready var pivot = $Pivot
@onready var camera = $Pivot/Camera3D


func _ready():
	print("player ready")
	pass

func _input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		if event is InputEventMouseButton and event.is_pressed():
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * sensibility)
		pivot.rotate_x(-event.relative.y * sensibility)
		pivot.rotation.x = clamp(pivot.rotation.x, -1.2, 1.2)
	
	if event is InputEventMouseButton and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and event.is_pressed():
		var size = get_viewport().get_visible_rect().size / 2;
		var from = camera.project_ray_origin(size)
		var to = camera.project_ray_normal(size) * 100
		
		var state = get_world_3d().direct_space_state
		var result = state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to));
		if result and result.collider is Sheet:
			on_sheet_click(result.collider)

func _physics_process(delta: float) -> void:
	# Same thing like the tutorials
	var in_vec = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");
	var dir = (transform.basis * Vector3(in_vec.x, 0, in_vec.y)).normalized();
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	
	if dir:
		velocity.x = dir.x * speed
		velocity.z = dir.z * speed
	else:
		velocity.x = lerp(0., velocity.x, 0.8)
		velocity.z = lerp(0., velocity.z, 0.8)
	
	move_and_slide()

func on_sheet_click(node):
	if Game.current_state != Game.State.PLAYING:
		return
	Game.do_update_count()
	node.queue_free()
	
	print("now count is ", Game.sheet_count)
