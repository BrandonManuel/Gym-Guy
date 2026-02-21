extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 60.0
enum facing { UP, DOWN }

signal is_walking

var direction = facing.DOWN


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
			animated_sprite_2d.flip_h = input_direction.x > 0
	else:
		velocity.x = 0
		velocity.y = 0
		animation = ""
		if direction == facing.UP:
			animation = "idle (back)"
		else:
			animation = "idle"
	
	animated_sprite_2d.play(animation)
	is_walking.emit(animation)
	move_and_slide()
