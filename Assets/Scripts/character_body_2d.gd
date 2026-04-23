extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $Visual/AnimationPlayer
@onready var inventory: Node = $Inventory
@onready var sprite: Sprite2D = $Visual/Sprite2D
@onready var hand: Marker2D = $Visual/Sprite2D/Hand
@onready var arrow: AnimatedSprite2D = $"../Gym Floor/WorkoutZone/AnimatedSprite2D"
@onready var arrow_collision: CollisionShape2D = $"../Gym Floor/WorkoutZone/CollisionShape2D"
@onready var workout_zone: CollisionShape2D = $"../Gym Floor/WorkoutZone/CollisionShape2D"

const SPEED = 60.0

enum facing { UP, DOWN }

signal is_walking
signal is_lifting
signal picked_up_item
signal dropped_item
signal held_item_z_changed(z: int)

var direction = facing.DOWN

var nearby_item: Node2D = null
var held_item: Node2D = null
var animation: String
var frozen: bool = false

func _process(delta: float) -> void:
	if nearby_item != null and Input.is_action_just_pressed("interact"):
		inventory.add_nearby_item(nearby_item)
		var item = nearby_item
		nearby_item = null
		picked_up_item.emit(item)
		item.get_parent().remove_child(item)
		hand.add_child(item)
		item.transform = Transform2D.IDENTITY
		held_item = item
		arrow_collision.disabled = false
		arrow.visible = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.dw
	
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
	if !frozen:
		animation = "idle"
	
	if !frozen and input_direction != Vector2.ZERO:
		velocity = input_direction * SPEED
		if input_direction.y > 0:
			animation = "walk"
			direction = facing.DOWN
		elif input_direction.y < 0:
			animation = "walk (back)"
			direction = facing.UP
		else:
			if direction == facing.UP:
				animation = "walk (back)"
			else:
				animation = "walk"
			
		if input_direction.x != 0:
			sprite.flip_h = input_direction.x > 0

	elif !frozen:
		velocity.x = 0
		velocity.y = 0
		animation = ""
		if direction == facing.UP:
			animation = "idle (back)"
		else:
			animation = "idle"
		
			
	if frozen:
		sprite.flip_h = false
	
	if animation != 'curling':
		if animation_player.current_animation != animation:
			animation_player.play(animation)
			is_walking.emit(animation)

	if held_item:
		var frame = sprite.frame % 4
		var offsets = Util.HAND_OFFSETS.get(animation, [Util.HAND_POS])
		var rotations = Util.HAND_ROTATIONS.get(animation, [0])
		if animation.contains('(back)'):
			if animation.contains('walk') and frame == 3:
				held_item.z_index = 1
				held_item_z_changed.emit(1)
			else:
				held_item.z_index = -1
				held_item_z_changed.emit(-1)
			held_item.z_as_relative = true
		elif animation.contains('curling'):
			held_item.z_index = -1
			held_item_z_changed.emit(-1)
			held_item.z_as_relative = true
		else:
			if animation == 'walk' and frame == 3:
				held_item.z_index = -1
				held_item_z_changed.emit(-1)
			else:
				held_item.z_index = 1
				held_item_z_changed.emit(1)
			held_item.z_as_relative = true
		var pos = offsets[min(frame, offsets.size() - 1)]
		var rotation = rotations[min(frame, offsets.size() - 1)]
		if sprite.flip_h:
			hand.position.x = -pos.x + 1
		else:
			hand.position.x = pos.x
		hand.position.y = pos.y
		hand.rotation_degrees = rotation

	move_and_slide()

func disable_collision():
	arrow_collision.disabled = true

func _on_workout_zone_body_entered(body: Node2D) -> void:
	call_deferred('disable_collision')
	arrow.visible = false
	global_position = workout_zone.global_position
	frozen = true
	direction = facing.UP
	velocity.x = 0
	velocity.y = 0
	
#	TODO remove these calls to lift() and start working on actual minigame logic for these calls (also remove await which was just here for testing)
	lift()
	await get_tree().create_timer(2.0).timeout
	lift()
	
func lift():
	animation = 'curling'
	print('setting animation to curling')
	animation_player.play('curling')
	is_lifting.emit('curling')


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'curling':
		animation = 'idle (back)'
