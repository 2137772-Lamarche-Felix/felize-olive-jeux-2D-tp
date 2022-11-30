extends KinematicBody2D

#gere la force de la gravité
export var gravity = 2000

var move = Vector2()

var hit = false

var regardeDroite = true

var attaque = false

#var attaqueAnim = false

var current = false

var _range = false


func cochonAttaque():
		$AnimatedSprite.animation = "attaque"
		$AnimatedSprite.speed_scale = 1.5
		yield(get_tree().create_timer(0.4), "timeout")
		if hit == false and _range == true:
		  Global._degat = true
		yield(get_tree().create_timer(0.2), "timeout")
		attaque = false
		$Area_attaque/Collision_attaque.disabled = true
		$cooldownAttaque.start(1)	


func _process(delta):
	
	
	if hit == false and attaque == false:
		$AnimatedSprite.animation = "iddle"
	#création de la gravité
	move.y += delta * gravity
	move = move_and_slide(move,Vector2.UP)
	
	if attaque == true and Global._attaque == false:
		cochonAttaque()
	
	if Global._attaque == true and current == true:
		hit = true
		yield(get_tree().create_timer(0.01), "timeout")
		Global._attaque = false
		current = false
	if hit == true:
		$AnimatedSprite.animation = "hit"
		yield(get_tree().create_timer(0.5), "timeout")
		$AnimatedSprite.animation = "dead"
		$CollisionShape2D.disabled = true
		


func _on_detectGauche_body_entered(body):
	if body.is_in_group("chevalier"):
		$AnimatedSprite.flip_h = false
		regardeDroite = true
		current = true


func _on_detectDroite_body_entered(body):
	if body.is_in_group("chevalier"):
		$AnimatedSprite.flip_h = true
		regardeDroite = false
		current = true


func _on_Area_attaque_body_entered(body):
	if body.is_in_group("chevalier"):
		attaque = true
		_range = true

func _on_Area_attaque_body_exited(body):
	attaque = false
	_range = false
	
func _on_cooldownAttaque_timeout():
	$Area_attaque/CollisionShape2D.disabled = false
