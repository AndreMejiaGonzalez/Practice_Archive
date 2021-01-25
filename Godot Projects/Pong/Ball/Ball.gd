extends KinematicBody2D

var speed = 500
var velocity = Vector2.ZERO

func _ready():
	randomize()
	velocity.x = [-1,1][randi() % 2]
	velocity.y = [-0.8,0.8][randi() % 2]

func _physics_process(delta):
	var collissionObject = move_and_collide(velocity * speed * delta)
	if collissionObject:
		velocity = velocity.bounce(collissionObject.normal)
		get_parent().find_node("SFX").find_node("Hit Sound").play()

func stopBall():
	speed = 0

func restartBall():
	velocity.x = [-1,1][randi() % 2]
	velocity.y = [-0.8,0.8][randi() % 2]
	speed = 500
