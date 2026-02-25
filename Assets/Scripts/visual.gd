extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for anim_name in animation_player.get_animation_list():
		var anim = animation_player.get_animation(anim_name)
		for i in anim.get_track_count():
			anim.track_set_interpolation_type(i, Animation.INTERPOLATION_NEAREST)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
