class_name ToolInteractable
extends Interactable

@export var tool_sprite : Sprite2D
@export var tool_data: ToolData

func _ready() -> void:
	super()
	tool_sprite.texture = tool_data.icon
	interaction = _on_interact
	
func _on_interact(player: Player):
	tool_sprite.hide()
	await player.get_tool(tool_data)
	queue_free()
