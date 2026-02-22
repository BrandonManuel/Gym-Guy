extends CanvasGroup
@onready var gym: Node2D = $".."
@onready var gym_floor: TileMapLayer = $"../Gym Floor"
@onready var player: CharacterBody2D = $"../Player"

# Mirror location
var mirror_grid_pos = Vector2i(0, -4)
var mirror_world_pos: Vector2i = Vector2i(0, 0)

var player_reflection: AnimatedSprite2D = null
var current_animation = ''

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mirror_world_pos = gym_floor.map_to_local(mirror_grid_pos) - Vector2(0, 8)
	
	for object in gym.get_children():
		print(object)
		if object.name != 'Player' and 'reflections' in object.get_groups():
			if object is Node2D:
				var reflection = object.duplicate()
				reflection.global_position.x = object.global_position.x
				reflection.global_position.y = object.global_position.y - (2 * abs(object.global_position.y - mirror_world_pos.y))
				reflection.z_index = -1 * object.z_index
				add_child(reflection)
		elif object.name == 'Player':
			var reflection = object.get_node('AnimatedSprite2D').duplicate()
			add_child(reflection)
			reflection.global_position.x = player.global_position.x
			reflection.global_position.y = player.global_position.y - (2 * abs(player.global_position.y - mirror_world_pos.y))
			player_reflection = reflection

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_reflection is AnimatedSprite2D:
		var distance_from_mirror = player.position.y - mirror_world_pos.y
		player_reflection.global_position.x = player.global_position.x
		player_reflection.global_position.y = mirror_world_pos.y - distance_from_mirror - 14
		
		player_reflection.flip_h = player.get_node('AnimatedSprite2D').flip_h


func _on_player_is_walking(walking_animation) -> void:
	if current_animation != walking_animation:
		if walking_animation is String:
			var animation = walking_animation.split(' ')
			if animation.size() > 1:
				player_reflection.play(animation[0])
			else:
				player_reflection.play(animation[0] + ' (back)')
		current_animation = walking_animation
