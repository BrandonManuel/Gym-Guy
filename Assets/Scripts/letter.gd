extends Control

@onready var polygon_2d: Polygon2D = $Polygon2D

func enable_current(enabled: bool) -> void:
	polygon_2d.color = Color(1, 1, 1, 1)

func enable_correct(enabled: bool) -> void:
	polygon_2d.color = Color(0, 1, 0, 1)
