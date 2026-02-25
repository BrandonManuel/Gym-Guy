extends Sprite2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == 'Player Shadow' and area.get_parent().held_item != self:
		enable_outline(true)
		area.get_parent().nearby_item = self
		
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == 'Player Shadow':
		enable_outline(false)
		area.get_parent().nearby_item = null
	
func enable_outline(enabled: bool) -> void:
	material.set_shader_parameter("outline_enabled", enabled)
