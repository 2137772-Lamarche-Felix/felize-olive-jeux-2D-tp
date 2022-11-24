extends KinematicBody2D

#gere la force de la gravité
export var gravity = 2000

var move = Vector2()

var hit = false


func _process(delta):
	
	if hit == false:
		$AnimatedSprite.animation = "iddle"
	#création de la gravité
	move.y += delta * gravity
	move = move_and_slide(move,Vector2.UP)
	
	if Global._attaque == true:
		hit = true
		Global._attaque = false
	if hit == true:
		$AnimatedSprite.animation = "hit"
		yield(get_tree().create_timer(0.5), "timeout")
		$AnimatedSprite.animation = "dead"
		$CollisionShape2D.disabled = true
		
