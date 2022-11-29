extends KinematicBody2D

#gere la force de la gravité
export var gravity = 2000

var move = Vector2()

var hit = false

var regardeDroite = true

var attaque = false


func _process(delta):
	
	if hit == false and attaque == false:
		$AnimatedSprite.animation = "iddle"
	#création de la gravité
	move.y += delta * gravity
	move = move_and_slide(move,Vector2.UP)
	
	if Global._attaque == true:
		hit = true
		yield(get_tree().create_timer(0.01), "timeout")
		Global._attaque = false
	if hit == true:
		$AnimatedSprite.animation = "hit"
		yield(get_tree().create_timer(0.5), "timeout")
		$AnimatedSprite.animation = "dead"
		$CollisionShape2D.disabled = true
		


func _on_detectGauche_body_entered(body):
	if body.is_in_group("chevalier"):
		$AnimatedSprite.flip_h = false
		regardeDroite = true


func _on_detectDroite_body_entered(body):
	if body.is_in_group("chevalier"):
		$AnimatedSprite.flip_h = true
		regardeDroite = false


func _on_Area_attaque_body_entered(body):
	if body.is_in_group("chevalier"):
		$AnimatedSprite.animation = "attaque"
		attaque = true
		

func _on_Area_attaque_body_exited(body):
	attaque = false
