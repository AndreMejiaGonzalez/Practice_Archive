extends Node

onready var screenSize = get_viewport().size

func _ready():
	$Apple.position = Vector2(screenSize.x - 60, screenSize.y - 40)
	$Score.rect_position = Vector2(screenSize.x - 40, screenSize.y - 55)

func updateScore(length: int):
	$Score.text = str(length - 2)
