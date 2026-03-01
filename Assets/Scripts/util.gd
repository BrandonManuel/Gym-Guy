extends Node

const HAND_OFFSETS = {
	"walk": [Vector2(4, 6), Vector2(-1, 4), Vector2(5, 6), Vector2(4, 3)],
	"walk (back)": [Vector2(-4, 6), Vector2(1, 4), Vector2(-4, 6), Vector2(0, 4)],
	"idle": [Vector2(4, 6), Vector2(4, 5), Vector2(4, 5), Vector2(4, 6)],
	"idle (back)": [Vector2(-4, 6), Vector2(-4, 5), Vector2(-4, 5), Vector2(-4, 6)],
}

const HAND_OFFSETS_REFLECTIONS = {
	"walk (reflection)": [Vector2(-4, 6), Vector2(1, 4), Vector2(-5, 6), Vector2(-4, 3)],
	"walk (back reflection)": [Vector2(4, 6), Vector2(-1, 4), Vector2(4, 6), Vector2(0, 4)],
	"idle": [Vector2(4, 6), Vector2(4, 5), Vector2(4, 5), Vector2(4, 6)],
	"idle (back)": [Vector2(-4, 6), Vector2(-4, 5), Vector2(-4, 5), Vector2(-4, 6)],
}

const HAND_ROTATIONS = {
	"walk": [0, 45, 0, 45],
	"walk (back)": [0, 90, 0, 45],
	"idle": [0, 0, 0, 0],
	"idle (back)": [0, 0, 0, 0],
}

const HAND_POS = Vector2(4, 6)
