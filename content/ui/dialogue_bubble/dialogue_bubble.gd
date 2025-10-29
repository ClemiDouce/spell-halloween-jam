class_name DialogBubble extends MarginContainer

@onready var dialogue_label: Label = %DialogueLabel
@onready var character_timer: Timer = %CharacterTimer

signal finished

@export var MAX_WIDTH = 150
var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.1

var text := ""
var letter_index = 0

func display_text(text_to_display: String):
	text = text_to_display
	dialogue_label.text = text_to_display
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
	
	global_position.y -= size.y
	
	dialogue_label.text = ""
	_display_letters()
	
func _display_letters():
	dialogue_label.text += text[letter_index]
	letter_index += 1
	if letter_index >= text.length():
		finished.emit()
		return
		
	match(text[letter_index]):
		"!", ".", "?", ",":
			character_timer.start(punctuation_time)
		" ":
			character_timer.start(space_time)
		_:
			character_timer.start(letter_time)
	
func on_display_text_finished():
	finished.emit()


func _on_character_timer_timeout() -> void:
	_display_letters()
