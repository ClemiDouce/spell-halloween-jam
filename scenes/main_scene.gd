extends Node2D

@onready var music : AudioStreamPlaybackInteractive = %MusicPlayer.get_stream_playback()
var current_zone := "Starting Zone"

func _ready() -> void:
	Events.player_entered_zone.connect(on_player_changing_zone)
		
func on_player_changing_zone(zone: Zone):
	if zone.zone_name == "zombie_project_final_v56":
		current_zone = zone.zone_name
		music.switch_to_clip_by_name("crow")
