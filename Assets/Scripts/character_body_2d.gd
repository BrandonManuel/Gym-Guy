extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $Visual/AnimationPlayer
@onready var inventory: Node = $Inventory
@onready var sprite: Sprite2D = $Visual/Sprite2D

const SPEED = 60.0
enum facing { UP, DOWN }

signal is_walking
signal picked_up_item

var direction = facing.DOWN

var nearby_item: Node2D = null

func _process(delta: float) -> void:
	if nearby_item != null and Input.is_action_just_pressed("interact"):
		inventory.add_nearby_item(nearby_item)
		picked_up_item.emit(nearby_item)
		nearby_item.queue_free()
		nearby_item = null


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var animation = "idle"
	
	if input_direction != Vector2.ZERO:
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
	else:
		velocity.x = 0
		velocity.y = 0
		animation = ""
		if direction == facing.UP:
			animation = "idle (back)"
		else:
			animation = "idle"
	
	animation_player.play(animation)
	is_walking.emit(animation)
	move_and_slide()
