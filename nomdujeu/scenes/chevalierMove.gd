extends KinematicBody2D

var gravity = 3000
var speed = 80
var moving = false
var jump = 1200

func _physics_process(delta):
	
	moving = false
	
	var move = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.speed_scale = 2.5
		moving = true
		move = Vector2.RIGHT * speed
	if Input.is_action_pressed("ui_left"):
		move = Vector2.LEFT * speed
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.speed_scale = 2.5
		moving = true
	if Input.is_action_pressed("ui_up") and is_on_floor():
		move.y += -jump
	
	#move.y += delta * gravity
	
	move = move_and_slide(move,Vector2.UP)
	
	position += move * delta
	
	if moving == false:
		$AnimatedSprite.animation = "iddle"
		$AnimatedSprite.speed_scale = 1.25
