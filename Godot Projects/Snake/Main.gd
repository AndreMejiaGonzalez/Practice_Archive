extends Node

const snake = 0
const apple = 1
var applePos
var snakeBody = [Vector2(5,10), Vector2(4,10), Vector2(3,10)]
var snakeDirection = Vector2(1,0)
var addSegment = false

func _ready():
	applePos = placeApple()

func _process(delta):
	gameOver()

func placeApple():
	randomize()
	var x = randi() % 20
	var y = randi() % 20
	return Vector2(x,y)

func drawApple():
	$Snake_Apple.set_cell(applePos.x, applePos.y, apple)

func drawSnake():
	for index in snakeBody.size():
		var block = snakeBody[index]
		
		if index == 0:
			var headDir = relation2(snakeBody[0], snakeBody[1])
			if headDir == 'right':
				$Snake_Apple.set_cell(block.x, block.y, snake, true, false, false, Vector2(2,0))
			if headDir == 'left':
				$Snake_Apple.set_cell(block.x, block.y, snake, false, false, false, Vector2(2,0))
			if headDir == 'top':
				$Snake_Apple.set_cell(block.x, block.y, snake, false, false, false, Vector2(3,0))
			if headDir == 'bottom':
				$Snake_Apple.set_cell(block.x, block.y, snake, false, true, false, Vector2(3,0))
		elif index == snakeBody.size() - 1:
			var tailDir = relation2(snakeBody[-1], snakeBody[-2])
			if tailDir == 'right':
				$Snake_Apple.set_cell(block.x, block.y, snake, false, false, false, Vector2(0,0))
			if tailDir == 'left':
				$Snake_Apple.set_cell(block.x, block.y, snake, true, false, false, Vector2(0,0))
			if tailDir == 'top':
				$Snake_Apple.set_cell(block.x, block.y, snake, false, true, false, Vector2(0,1))
			if tailDir == 'bottom':
				$Snake_Apple.set_cell(block.x, block.y, snake, false, false, false, Vector2(0,1))
		
		else:
			var previousBlock = snakeBody[index + 1] - block
			var nextBlock = snakeBody[index - 1] - block
			
			if previousBlock.x == nextBlock.x:
				$Snake_Apple.set_cell(block.x, block.y, snake, false, false, false, Vector2(4,1))
			elif previousBlock.y == nextBlock.y:
				$Snake_Apple.set_cell(block.x, block.y, snake, false, false, false, Vector2(4,0))
			else:
				if previousBlock.x == -1 and nextBlock.y == -1 or nextBlock.x == -1 and previousBlock.y == -1:
					$Snake_Apple.set_cell(block.x, block.y, snake, true, true, false, Vector2(5,0))
				if previousBlock.x == -1 and nextBlock.y == 1 or nextBlock.x == -1 and previousBlock.y == 1:
					$Snake_Apple.set_cell(block.x, block.y, snake, true, false, false, Vector2(5,0))
				if previousBlock.x == 1 and nextBlock.y == -1 or nextBlock.x == 1 and previousBlock.y == -1:
					$Snake_Apple.set_cell(block.x, block.y, snake, false, true, false, Vector2(5,0))
				if previousBlock.x == 1 and nextBlock.y == 1 or nextBlock.x == 1 and previousBlock.y == 1:
					$Snake_Apple.set_cell(block.x, block.y, snake, false, false, false, Vector2(5,0))

func relation2(firstBlock: Vector2, secondBlock: Vector2):
	var relation = secondBlock - firstBlock
	if relation == Vector2(-1,0): return 'left'
	if relation == Vector2(1,0): return 'right'
	if relation == Vector2(0,1): return 'bottom'
	if relation == Vector2(0,-1): return 'top'

func moveSnake():
	if addSegment:
		deleteCells(snake)
		var bodyCopy = snakeBody.slice(0, snakeBody.size() - 1)
		var newHead = bodyCopy[0] + snakeDirection
		bodyCopy.insert(0, newHead)
		snakeBody = bodyCopy
		addSegment = false
	else:
		deleteCells(snake)
		var bodyCopy = snakeBody.slice(0, snakeBody.size() - 2)
		var newHead = bodyCopy[0] + snakeDirection
		bodyCopy.insert(0, newHead)
		snakeBody = bodyCopy

func deleteCells(id: int):
	var cells = $Snake_Apple.get_used_cells_by_id(id)
	for cell in cells:
		$Snake_Apple.set_cell(cell.x, cell.y, -1)

func hasEatenApple():
	if applePos == snakeBody[0]:
		applePos = placeApple()
		addSegment = true
		get_tree().call_group("ScoreGroup", "updateScore", snakeBody.size())
		$AudioStreamPlayer.play()

func gameOver():
	var head = snakeBody[0]
	if head.x > 19 or head.x < 0 or head.y > 19 or head.y < 0:
		reset()
	for block in snakeBody.slice(1, snakeBody.size() - 1):
		if block == head: reset()

func reset():
	snakeBody = [Vector2(5,10), Vector2(4,10), Vector2(3,10)]
	snakeDirection = Vector2(1,0)

func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		if snakeDirection != Vector2(0,1): snakeDirection = Vector2(0,-1)
	if Input.is_action_just_pressed("ui_down"):
		if snakeDirection != Vector2(0,-1): snakeDirection = Vector2(0,1)
	if Input.is_action_just_pressed("ui_left"):
		if snakeDirection != Vector2(1,0): snakeDirection = Vector2(-1,0)
	if Input.is_action_just_pressed("ui_right"):
		if snakeDirection != Vector2(-1,0): snakeDirection = Vector2(1,0)

func _on_Snake_Tick_timeout():
	moveSnake()
	drawApple()
	drawSnake()
	hasEatenApple()
