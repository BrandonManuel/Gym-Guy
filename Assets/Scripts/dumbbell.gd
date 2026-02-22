extends Sprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	enable_outline(true)
	
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	enable_outline(false)
	
func enable_outline(enabled: bool) -> void:
	material.set_shader_parameter("outline_enabled", enabled)
