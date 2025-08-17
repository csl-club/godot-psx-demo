class_name Enemy
extends CharacterBody3D

var speed : float = 2
@onready var nav_agent = $Agent

func _ready():
	Game.update_sheet_count.connect(_on_update_count);

func _process(delta: float) -> void:
	if not visible:
		return
	
	var next : Vector3 = nav_agent.get_next_path_position();
	var curr : Vector3 = position
	var vel = (next - curr).normalized() * speed
	
	velocity = velocity.move_toward(vel, 0.25)
	move_and_slide();

func _on_update_count():
	if Game.sheet_count >= Game.MAX_SHEETS:
		queue_free()
	elif Game.sheet_count == Game.MAX_SHEETS / 2:
		visible = true
	elif Game.sheet_count == Game.MAX_SHEETS - 1:
		speed = 3
	pass




func _on_body_detect(body: Node3D) -> void:
	if body is Player:
		Game.do_game_over()
