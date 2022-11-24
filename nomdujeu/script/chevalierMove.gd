extends KinematicBody2D

#gere la force de la gravité
export var gravity = 2000
#vitesse de marche du joueur
var speed = 200
#variable qui sert à savoir si le joueur bouge ou pas pour déclancher le iddling
var moving = false
#force de jump du joueur
var jump = 600
var jumping = false
#si le joueur est accroupie ou non
var crouch =  false

var attaque = false

var regardeDroite = true

#variable que si elle est pas là ça chie dans pelle
#ça sert juste à savoir comment faire bouger le joueur selon sa position initial
var move = Vector2()

var bodyEntered = false

func _on_Area2D_body_entered(body):
	bodyEntered = true
	
func _on_Area2D_body_exited(body):
	bodyEntered = false
	
#func _on_Area2DEpe_body_entered(body):
	#if body.is_in_group("ennemie"):
		#Global._attaque = true

#fonction qui prend les données de move et de delta pour ensuite faire bouger
#le joueur comme il l'a demandé
func _process(delta):
	move = move_and_slide(move,Vector2.UP)
	
	#sert à determiner si le joueur doit être accroupis ou non
	if Input.is_action_just_pressed("ui_down"):
		if crouch == false:
			crouch = true
			$CollisionShape2D2.disabled = true
			speed = 100
			$AnimatedSprite.animation="WalkToCrouch"
		elif bodyEntered == false and crouch == true:
			crouch = false
			speed = 200
			$CollisionShape2D2.disabled = false
			$AnimatedSprite.animation="CrouchToWalk"
			
	if !is_on_floor() and jumping == false and attaque == false:
		$AnimatedSprite.animation = "fall"
		
	if Input.is_action_just_pressed("ui_space"):
		if attaque == false:
			$AnimatedSprite.animation = "attaque"
			$AnimatedSprite.speed_scale = 2
			attaque = true
			if regardeDroite == true:
				$Area2DEpeDroite/EpeCollisionDroite.disabled = false
				yield(get_tree().create_timer(0.35), "timeout")
				$Area2DEpeDroite/EpeCollisionDroite.disabled = true
			if regardeDroite == false:
				$Area2DEpeGauche/EpeCollisionGauche.disabled = false
				yield(get_tree().create_timer(0.35), "timeout")
				$Area2DEpeGauche/EpeCollisionGauche.disabled = true
			attaque = false
			

#fonction principal du mouvement du joueur
func _physics_process(delta):
	
	#par défaut la var moving doit être false
	moving = false
	
	#code qui gere la touche de fleche de droite (movement + animations)	
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite.flip_h = false
		regardeDroite = true
		if attaque == false:
			if crouch == false:
				$AnimatedSprite.animation = "run"
				$AnimatedSprite.speed_scale = 2.5
			elif crouch ==true:
				$AnimatedSprite.animation = "CrouchWalking"
				$AnimatedSprite.speed_scale = 2.5
		moving = true
		move.x = speed
	#code qui gere la touche de fleche de gauche (movement + animations)
	elif Input.is_action_pressed("ui_left"):
		move.x = -speed
		$AnimatedSprite.flip_h = true
		regardeDroite = false
		if attaque == false:
			if crouch == false:
				$AnimatedSprite.animation = "run"
				$AnimatedSprite.speed_scale = 2.5
			if crouch == true:
				$AnimatedSprite.animation = "CrouchWalking"
				$AnimatedSprite.speed_scale = 2.5

		moving = true
	#ça sert à rendre smooth l'arrête d'animation mais finalement sans ça
	#le joueur glisse à l'infini
	else: 
		move.x = lerp(move.x, 0, 1)
		
	#création de la gravité
	move.y += delta * gravity
	
	#code qui gere la touche fleche de haut (mouvement + animation)
	if Input.is_action_pressed("ui_up") and is_on_floor():
		move.y += -jump
		crouch = false
		speed = 200
		if attaque == false:
			jumping = true
			$AnimatedSprite.animation = "jump"
	
	
	#code qui sert juste à jouer l'animation
	if moving == false and attaque == false:
		if crouch == true:
			$AnimatedSprite.animation = "crouch"
		else:
			$AnimatedSprite.animation = "iddle"
			$AnimatedSprite.speed_scale = 1.25
	if jumping == true and attaque == false:
		$AnimatedSprite.animation = "jump"
		yield(get_tree().create_timer(0.2), "timeout")
		jumping = false
		

