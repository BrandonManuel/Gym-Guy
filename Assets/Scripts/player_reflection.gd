extends AnimatedSprite2D

@onready var tile_map_layer: TileMapLayer = $"../Reflection"
@onready var player: CharacterBody2D = $"../../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mirror_grid_pos = Vector2i(0, -4)
	var mirror_world_pos = tile_map_layer.map_to_local(mirror_grid_pos).y - 10
	
	var distance_from_mirror = player.position.y - mirror_world_pos

	global_position.x = player.global_position.x
	global_position.y = mirror_world_pos - distance_from_mirror
	
	flip_h = player.get_node("AnimatedSprite2D").flip_h

func _on_player_is_walking(is_walking) -> void:
	if is_walking:
		play('walk')
	else:
		play('idle')
