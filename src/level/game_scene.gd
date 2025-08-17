extends Node3D

@onready var player = $Player3D
@onready var enemy = $Enemy

func _process(delta: float) -> void:
	if Game.current_state == Game.State.PLAYING and enemy.visible:
		enemy.nav_agent.target_position = player.position
