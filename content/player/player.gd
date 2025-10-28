class_name Player extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var state_label: Label = %StateLabel
@onready var tool_sprite: Sprite2D = %Tool
@onready var root_tool: Node2D = %RootTool
@onready var tool_area: Area2D = %ToolArea

@export_category("Tool Uses Curve")
@export var axe_curve: Curve
@export var scythe_curve: Curve

@export var walk_speed : float = 100.
var tool_speed := 0.7

var state := "idle"
var last_direction := Vector2.DOWN
var tool_list : Array[ToolData] = []

func get_input():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		last_direction = direction
		state = "walk"
	else:
		state = "idle"
	
	return direction
	
func update_visuals():
	var animation_name : String = state
	
	match(last_direction):
		Vector2.LEFT:
			animation_name += "_left"
			sprite.flip_h = false
		Vector2.RIGHT:
			animation_name += "_left"
			sprite.flip_h = true
		Vector2.DOWN:
			animation_name += "_down"
		Vector2.UP:
			animation_name += "_up"
	
	state_label.text = animation_name
	if sprite.sprite_frames.has_animation(animation_name):
		sprite.play(animation_name)

func _process(_delta: float) -> void:
	update_visuals()
	if Input.is_action_just_pressed("use_axe"):
		swing_tool("axe")
	elif Input.is_action_just_pressed("use_scythe"):
		swing_tool("scythe")

func _physics_process(_delta: float) -> void:
	if state == "tool":
		return
	
	var input = get_input()
	velocity = input * walk_speed
	
	move_and_slide()

func swing_tool(tool_name: String):
	state = "tool"
	var tool_curve : Curve
	match(tool_name):
		"axe":
			tool_sprite.frame = 5
			tool_curve = axe_curve
		"scythe":
			tool_sprite.frame = 7
			tool_curve = scythe_curve
	tool_sprite.show()
	root_tool.rotation = last_direction.angle()
	var tool_tween = create_tween()
	tool_tween.tween_property(tool_sprite, "rotation_degrees", 90, tool_speed).from(0)\
				.set_custom_interpolator(Global.tween_curve.bind(tool_curve))
	tool_tween.tween_callback(func():
		tool_sprite.hide()
		state = "idle"
	)
	check_destroyable(tool_name)

func check_destroyable(tool: String):
	tool_area.monitoring = true
	var destructibles = tool_area.get_overlapping_areas()
	if !destructibles.is_empty():
		for d: Destructible in destructibles:
			if tool == "axe" and d is Log:
				d.destroy()
			elif tool == "scythe" and d is Grass:
				d.destroy()
	
