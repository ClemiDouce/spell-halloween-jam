extends Node

signal dialogue_finished

@onready var dialogue_bubble = preload("res://content/ui/dialogue_bubble/dialogue_bubble.tscn")
@onready var dialogue_bubble_no_tail = preload("uid://cr7qdg4jh34u2")


var dialog_lines : Array[String] = []
var current_line_index := 0

var text_box : DialogBubble
var text_box_position : Vector2

var is_dialog_active := false
var can_advance_line := false

func start_dialog(position: Vector2, lines: Array[String]):
	if is_dialog_active:
		return
		
	dialog_lines = lines
	text_box_position = position
	
	_show_text_box()
	
	is_dialog_active = true
	
func _show_text_box():
	text_box = dialogue_bubble_no_tail.instantiate() as DialogBubble
	text_box.finished.connect(_on_line_finished)
	get_tree().root.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index])
	can_advance_line = false
	
func _on_line_finished():
	can_advance_line = true
	
func _unhandled_input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("advance_dialog") and 
		is_dialog_active and
		can_advance_line
	):
		text_box.queue_free()
		
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			dialogue_finished.emit()
			return
		
		_show_text_box()
