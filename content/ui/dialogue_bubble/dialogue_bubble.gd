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
	var screen_size = get_viewport_rect().size
	var final_position : Vector2 = self.global_position
	text = text_to_display
	dialogue_label.text = text_to_display
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
	
	var right_x = ceil(global_position.x / screen_size.x) * screen_size.x
	var left_x = floor(global_position.x / screen_size.x) * screen_size.x
	var half_size_x = size.x / 2
	final_position.y -= size.y + 16
	final_position.x -= half_size_x # Remise au milieu
	var offset := 0.
	var middle_position = final_position.x + half_size_x
	var off_right = abs(right_x - middle_position) < half_size_x + offset
	var off_left = abs(left_x - middle_position) < half_size_x + offset
	if off_right:
		final_position.x -= half_size_x + offset
	elif off_left:
		final_position.x += half_size_x + offset
	self.global_position = final_position
	
	dialogue_label.text = ""
	dialogue_label.visible_ratio = 0.
	_display_letters_tween()

func _display_letters_tween():
	dialogue_label.text = text
	var dialogue_tween = create_tween()
	dialogue_tween.tween_property(dialogue_label, "visible_ratio", 1., text.length() * letter_time)
	dialogue_tween.tween_callback(finished.emit)

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
