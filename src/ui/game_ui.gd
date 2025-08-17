extends Control

@onready var label: RichTextLabel = $SheetLabel
@onready var blackRect: ColorRect = $ColorRect

var originalText: String;

func _ready() -> void:
	originalText = label.text;
	Game.update_sheet_count.connect(_on_update_sheet_count)
	Game.game_over.connect(_on_game_over)

func _on_update_sheet_count():
	if Game.current_state == Game.State.WIN:
		label.text = "WIN"
	elif Game.current_state == Game.State.PLAYING: 
		label.text = originalText + "\n%d" % Game.sheet_count;
	pass

func _on_game_over():
	label.text = "GAME OVER"
	blackRect.visible = true
