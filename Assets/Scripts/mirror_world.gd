extends CanvasGroup
@onready var gym: Node2D = $".."
@onready var gym_floor: TileMapLayer = $"../Gym Floor"
@onready var player: CharacterBody2D = $"../Player"
@onready var player_sprite: Sprite2D = $"../Player/Visual/Sprite2D"

# Mirror location
var mirror_grid_pos = Vector2i(0, -4)

var mirror_world_pos: Vector2 = Vector2.ZERO

var player_reflection: Sprite2D = null
var player_animation_player: AnimationPlayer = null

var current_animation = ''

var reflections: Dictionary[Node, Node] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tile_size = gym_floor.tile_set.tile_size.y
	mirror_world_pos = gym_floor.map_to_local(mirror_grid_pos) - Vector2(0, tile_size - 0.5)
	
	for object in get_tree().get_nodes_in_group("reflections"):
		reflect(object)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_reflection is Sprite2D:
		update_reflection_pos(player_sprite, player_reflection)
		player_reflection.flip_h = player_sprite.flip_h
		
func reflect(object: Node):
	if object.name != 'Player' and 'reflections' in object.get_groups():
		if object is Node2D:
			var reflection = object.duplicate()
			add_child(reflection)
			update_reflection_pos(object, reflection)
			reflections[object] = reflection
			reflection.set_meta("source", object)
	elif object.name == 'Player':		
		var visual: Node2D = object.get_node('Visual')
		var reflection = visual.duplicate()
		
		var sprite: Sprite2D = reflection.get_node('Sprite2D')
		player_animation_player = reflection.get_node('AnimationPlayer')
		
		add_child(reflection)
		player_reflection = sprite
		player_reflection.self_modulate = Color(.8, .9, .9, 1)
		update_reflection_pos(player_sprite, player_reflection)
		reflections[object] = reflection
		reflection.set_meta("source", object)

func update_reflection_pos(source: Node2D, reflection: Node2D):
	var source_y = source.global_position.y
	if source == player_sprite:
		source_y += player_sprite.offset.y
	elif source is Sprite2D and source.centered:
		source_y -= source.texture.get_size().y # use top edge instead of center
	var dist = source_y - mirror_world_pos.y
	reflection.global_position.x = source.global_position.x
	reflection.global_position.y = mirror_world_pos.y - dist

	# closer to mirror = higher dist = should render on top in reflection
	reflection.z_index = int(dist)
	reflection.z_as_relative = false

func _on_player_is_walking(walking_animation) -> void:
	if player_animation_player == null:
		return
	
	if current_animation != walking_animation:
		if walking_animation is String:
			var animation = walking_animation.split(' ')
			if animation.size() > 1:
				player_animation_player.play(animation[0])
			else:
				player_animation_player.play(animation[0] + ' (back)')
		current_animation = walking_animation


func _on_player_picked_up_item(item: Node) -> void:
	if reflections[item] != null:
		remove_child(reflections[item])
		reflections.erase(item)
