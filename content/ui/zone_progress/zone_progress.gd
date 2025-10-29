class_name ZoneProgress extends Control

@onready var progress_bar: ProgressBar = %ZoneProgressBar
@onready var name_label: Label = %ZoneNameLabel
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var actual_zone : Zone = null
var showed := false

func _ready() -> void:
	Events.player_entered_zone.connect(on_player_entered_zone)
	Events.zone_progress_changed.connect(on_zone_progress_changed)
	
func on_player_entered_zone(zone: Zone):
	change_zone_display(zone)

func change_zone_display(zone: Zone):
	if showed == true:
		animation_player.play("go_out")
		await animation_player.animation_finished
	
	name_label.text = zone.zone_name
	progress_bar.max_value = zone.total_destructibles
	progress_bar.value = zone.destructible_progress
	actual_zone = zone
	
	animation_player.play("go_in")
	showed = true
	
func on_zone_progress_changed():
	if actual_zone == null:
		return
		
	#progress_bar.value = actual_zone.destructible_progress
	var progress_tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	progress_tween.tween_property(progress_bar, "value", actual_zone.destructible_progress, 0.5)
