extends KinematicBody2D

#gere la force de la gravité
var gravity = 2000
#vitesse de marche du joueur
var speed = 200
#variable qui sert à savoir si le joueur bouge ou pas pour déclancher le iddling
var moving = false
#force de jump du joueur
var jump = 600
var jumping = false

#variable que si elle est pas là ça chie dans pelle
#ça sert juste à savoir comment faire bouger le joueur selon sa position initial
var move = Vector2()

#fonction qui prend les données de move et de delta pour ensuite faire bouger
#le joueur comme il l'a demandé
func _process(delta):
		move = move_and_slide(move,Vector2.UP)

#fonction principal du mouvement du joueur
func _physics_process(delta):
	
	#par défaut la var moving doit être false
	moving = false
	
	#code qui gere la touche de fleche de droite (movement + animations)	
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.speed_scale = 2.5
		moving = true
		move.x = speed
	#code qui gere la touche de fleche de gauche (movement + animations)
	elif Input.is_action_pressed("ui_left"):
		move.x = -speed
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.animation = "run"
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
		jumping = true
		$AnimatedSprite.animation = "jump"
	
	if !is_on_floor() and jumping == false:
		$AnimatedSprite.animation = "fall"
	
	#code qui sert juste à jouer l'animation
	if moving == false:
		$AnimatedSprite.animation = "iddle"
		$AnimatedSprite.speed_scale = 1.25
	if jumping == true:
		$AnimatedSprite.animation = "jump"
		yield(get_tree().create_timer(0.2), "timeout")
		jumping = false
		
