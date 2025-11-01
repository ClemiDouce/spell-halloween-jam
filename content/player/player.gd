class_name Player extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var state_label: Label = %StateLabel
@onready var tool_sprite: Sprite2D = %Tool
@onready var root_tool: Node2D = %RootTool
@onready var tool_area: Area2D = %ToolArea
@onready var dialogue_position: Marker2D = %DialoguePosition
@onready var tool_get_sprite: Sprite2D = %ToolSprite


@export var tool_curve: Curve

@export var walk_speed : float = 100.
var tool_speed := 0.7
var have_axe := false
var have_scythe := false
var have_pickaxe := false

var state := "idle"
var last_direction := Vector2.DOWN
var last_clamped_direction := Vector2.DOWN


var direction_list := [Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.UP]

func get_input():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		last_direction = direction
		if direction in direction_list:
			last_clamped_direction = direction
			root_tool.rotation = direction.angle()
		
		state = "walk"
	else:
		state = "idle"
	
	return direction
	
func update_visuals():
	var animation_name : String = state
	
	match(last_clamped_direction):
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
	if state != "tool":
		if Input.is_action_just_pressed("use_axe") and have_axe:
			swing_tool("axe")
		elif Input.is_action_just_pressed("use_scythe") and have_scythe:
			swing_tool("scythe")
		elif Input.is_action_just_pressed("use_pickaxe") and have_pickaxe:
			swing_tool("pickaxe")
	
func _physics_process(_delta: float) -> void:
	if state == "tool" or DialogueManager.is_dialog_active:
		return
	
	var input = get_input()
	velocity = input * walk_speed
	
	move_and_slide()

func swing_tool(tool_name: String):
	state = "tool"
	match(tool_name):
		"axe":
			tool_sprite.frame = 5
		"scythe":
			tool_sprite.frame = 7
		"pickaxe":
			tool_sprite.frame = 0
	tool_sprite.show()
	var tool_tween = create_tween()
	tool_tween.tween_property(tool_sprite, "rotation_degrees", 90., tool_speed).from(0.)\
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
			elif tool == "pickaxe" and d is Rock:
				d.destroy()

func get_tool(tool_data: ToolData):
	tool_get_sprite.texture = tool_data.icon
	var tool_dialogue = [
		"You've obtained the " + tool_data.tool_name,
		tool_data.target,
		tool_data.input_key
	]
	tool_get_sprite.show()
	DialogueManager.start_dialog(self.dialogue_position.global_position - Vector2(0, 10), tool_dialogue)
	await DialogueManager.dialogue_finished
	tool_get_sprite.hide()
	if !have_scythe:
		have_scythe = true
	elif !have_axe:
		have_axe = true
	elif !have_pickaxe:
		have_pickaxe = true
	else:
		Inventory.show()
