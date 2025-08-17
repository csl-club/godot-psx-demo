extends Node

const app_id : int = 1400787005637525504

enum State {PLAYING, WIN, GAME_OVER}

const MAX_SHEETS : int = 4

signal update_sheet_count()
signal game_over()

var sheet_count : int = 0
var current_state : State = State.PLAYING

func current_state_name():
	return State.keys()[current_state].replace("_", " ")

func _ready() -> void:
	update_discord()

func update_discord():
	DiscordRPC.app_id = app_id
	DiscordRPC.details = "Godot PSX-Style by CSL-UTEC!"
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	DiscordRPC.state = current_state_name()
	
	#DiscordRPC.large_image = ""
	#DiscordRPC.large_image_text = ":D"
	#DiscordRPC.small_image_text = "Yep"
	DiscordRPC.refresh()

func do_game_over():
	Game.current_state = Game.State.GAME_OVER
	emit_signal("game_over")
	update_discord()
	
	var timer = Timer.new()
	timer.wait_time = 5
	timer.one_shot = true
	timer.timeout.connect(reset);
	add_child(timer)
	timer.start()

func reset():
	get_tree().reload_current_scene()
	sheet_count = 0
	current_state = State.PLAYING
	update_discord()

func do_update_count():
	sheet_count += 1
	if Game.sheet_count >= Game.MAX_SHEETS:
		current_state = State.WIN;
		update_discord()
	emit_signal("update_sheet_count")
