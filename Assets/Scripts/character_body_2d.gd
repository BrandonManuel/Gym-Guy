extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 60.0


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
	if input_direction != Vector2.ZERO:
		velocity= input_direction * SPEED
		animated_sprite_2d.play("walk")
		if input_direction.x != 0:
			animated_sprite_2d.flip_h = input_direction.x > 0
		animated_sprite_2d.play("walk")
	else:
		velocity.x = 0
		velocity.y = 0
		animated_sprite_2d.stop()
	print("Input: ", input_direction, " | Velocity: ", velocity)
	move_and_slide()
