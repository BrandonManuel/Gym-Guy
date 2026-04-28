extends CanvasGroup
@onready var gym: Node2D = $".."
@onready var gym_floor: TileMapLayer = $"../Gym Floor"
@onready var player: CharacterBody2D = $"../Player"
@onready var player_sprite: Sprite2D = $"../Player/Visual/Sprite2D"
@onready var arrow: AnimatedSprite2D = $"../Gym Floor/WorkoutZone/AnimatedSprite2D"

# Mirror location
var mirror_grid_pos = Vector2i(0, -4)

var mirror_world_pos: Vector2 = Vector2.ZERO

var player_reflection: Sprite2D = null
var player_animation_player: AnimationPlayer = null

var current_animation = ''

var reflections: Dictionary[Node, Node] = {}

var arrow_reflection: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tile_size = gym_floor.tile_set.tile_size.y
	mirror_world_pos = gym_floor.map_to_local(mirror_grid_pos) - Vector2(0, tile_size - 0.5)
	
	for object in get_tree().get_nodes_in_group("reflections"):
		reflect(object)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:		
	if arrow.visible and arrow_reflection == null:
		arrow_reflection = reflect(arrow)
	elif !arrow.visible and arrow_reflection != null:
		reflections[arrow].queue_free()
		arrow_reflection = null
	
	if player_reflection is Sprite2D:
		update_reflection_pos(player_sprite, player_reflection)
		player_reflection.flip_h = player_sprite.flip_h
		
		var reflection_hand: Marker2D = player_reflection.get_node("Hand")
		if reflection_hand and reflection_hand.get_child_count() > 0:
			var frame = player_sprite.frame % 4
						
			var anim = player_animation_player.current_animation
			var offsets = Util.HAND_OFFSETS_REFLECTIONS.get(anim, [Util.HAND_POS])
			var rotations = Util.HAND_ROTATIONS_REFLECTIONS.get(anim, [0])
			var pos = offsets[min(frame, offsets.size() - 1)]
			
			if player_reflection.flip_h:
				reflection_hand.position.x = pos.x
			else:
				reflection_hand.position.x = -pos.x +  1
			reflection_hand.position.y = pos.y
			
			if player_sprite.flip_h:
				reflection_hand.position.x = -pos.x + 1
			else:
				reflection_hand.position.x = pos.x
			reflection_hand.position.y = pos.y
			var rotation = rotations[min(frame, offsets.size() - 1)]

			reflection_hand.rotation_degrees = rotation
			
			var hand: Marker2D = player_sprite.get_node("Hand")
			reflection_hand.z_index = hand.z_index * -1
			reflection_hand.z_as_relative = true
			
	if arrow_reflection != null:
		arrow_reflection.pause()
		arrow_reflection.set_frame_and_progress(arrow.frame, arrow.frame_progress)
		
func reflect(object: Node) -> Node:
	var reflection: Node
	if object.name != 'Player' and 'reflections' in object.get_groups():
		if object is Node2D:
			reflection = object.duplicate()
			add_child(reflection)
			update_reflection_pos(object, reflection)
			reflections[object] = reflection
			reflection.set_meta("source", object)
	elif object.name == 'Player':		
		var visual: Node2D = object.get_node('Visual')
		reflection = visual.duplicate()
		
		var sprite: Sprite2D = reflection.get_node('Sprite2D')
		player_animation_player = reflection.get_node('AnimationPlayer')
		
		add_child(reflection)
		player_reflection = sprite
		player_reflection.self_modulate = Color(.8, .9, .9, 1)
		update_reflection_pos(player_sprite, player_reflection)
		reflections[object] = reflection
		reflection.set_meta("source", object)
	
	return reflection

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
	if reflection != reflections.get(player):
		reflection.z_index = int(dist)
		reflection.z_as_relative = false

func _on_player_is_walking(walking_animation: String) -> void:
	print('is walking')
	if player_animation_player == null:
		return
	
	if current_animation != walking_animation and walking_animation is String:
		var animation = walking_animation.split(' ')
		if animation.size() > 1:
			if animation.has('idle'):
				player_animation_player.play(animation[0])
			else:
				player_animation_player.play(animation[0] + ' (reflection)')
		else:
			if animation.has('idle'):
				player_animation_player.play(animation[0] + ' (back)')
			else:
				player_animation_player.play(animation[0] + ' (back reflection)')
		current_animation = walking_animation

func _on_player_is_lifting(curling_animation: String) -> void:
	if player_animation_player == null:
		return
	
	if current_animation != curling_animation and curling_animation is String:
		var animation = curling_animation.split(' ')
		player_animation_player.play(animation[0] + ' (reflection)')
		current_animation = curling_animation

func _on_player_picked_up_item(item: Node) -> void:
	var item_reflection = reflections.get(item)
	if item_reflection != null:
		item_reflection.get_parent().remove_child(item_reflection)
		reflections.erase(item)
		
		var reflection_hand = player_reflection.get_node("Hand")
		reflection_hand.add_child(item_reflection)
		item_reflection.transform = Transform2D.IDENTITY
				
func _on_player_held_item_z_changed(z: int) -> void:
	var reflection_hand = player_reflection.get_node("Hand")
	if reflection_hand and reflection_hand.get_child_count() > 0:
		reflection_hand.get_child(0).z_index = -z
		reflection_hand.get_child(0).z_as_relative = true
	
