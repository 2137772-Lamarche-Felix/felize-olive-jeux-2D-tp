extends KinematicBody2D

export(PackedScene) var Poele: PackedScene = preload("res://scenes/armes/poele_projectile.tscn")
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
#le joueur attaque ou non
var attaque = false
#le joueur regare vers le droite ou non
var regardeDroite = true

#sert juste pour la boucle while qui gère la hitbox de l'épé.
#sans le while et la variable temps, les hitbox se désactiveraient
#avant même que l'animation d'attaque à l'épé se termine 
var temps = 0

#variable que si elle est pas là ça chie dans pelle
#ça sert juste à savoir comment faire bouger le joueur selon sa position initial
var move = Vector2()

var hang = false

var slide = false

var walljump = false

var roofBodyEntered = false

func _on_Area2D_body_entered(body):
	roofBodyEntered = true
	
func _on_Area2D_body_exited(body):
	roofBodyEntered = false
	

	
#func _on_Area2DEpe_body_entered(body):
	#if body.is_in_group("ennemie"):
		#Global._attaque = true

#fonction qui prend les données de move et de delta pour ensuite faire bouger
#le joueur comme il l'a demandé
func _process(delta):
	
	move.y += delta*gravity
			
	
	move = move_and_slide(move,Vector2.UP)
	
	if (Global.vieJoueur == 2 or Global.vieJoueur == 1)and Global._degat == true:
		$AnimatedSprite.animation="death"
		$AnimatedSprite.speed_scale = 2
		remove_from_group("chevalier")
		#Global.vieJoueur += -1
		yield(get_tree().create_timer(1), "timeout")
		$AnimatedSprite.animation="iddleDeath"
		add_to_group("chevalier")	
		Global._degat = false
		set_global_position(Vector2(Global.positionSpawn))
	#sert à determiner si le joueur doit être accroupis ou non
	if Input.is_action_just_pressed("ui_down") and Global._degat == false:
		if crouch == false:
			crouch = true
			$CollisionShape2D2.disabled = true
			$Area2DPlafond/CollisionShape2D.disabled = false
			speed = 100
			$AnimatedSprite.animation="WalkToCrouch"
			Global.currentAnim = "walkToCrouch"
		elif roofBodyEntered == false and crouch == true:
			crouch = false
			speed = 200
			$Area2DPlafond/CollisionShape2D.disabled = true
			$CollisionShape2D2.disabled = false
			$AnimatedSprite.animation="CrouchToWalk"
			Global.currentAnim = "crouchToWalk"
	
	#si le joueur tombe dans dans le vide, l'animation de chute va jouer
	#jusqu'à ce que le joueur touche un sol		
	if jumping == false and attaque == false and Global._degat == false and slide == false:
		yield(get_tree().create_timer(0.02), "timeout")
		if !is_on_floor():
			$AnimatedSprite.animation = "fall"
			Global.currentAnim = "fall"
		
	#gère la touche espace(attaque+animation)	
	if Input.is_action_just_pressed("ui_space") and Global._degat == false:
		if attaque == false:
			$AnimatedSprite.animation = "attaque"
			Global.currentAnim = "attaque"
			$AnimatedSprite.speed_scale = 2
			attaque = true
			
			#a surment un moyen plus simple pour le faire mais sert à 
			#mettre la hitbox de l'épé là où le joueur regarde même
			#si l'animation a déjà été commencé (gere vraiment juste la hitbox, pas l'animation)
			temps = 1
			while temps <= 15:
				if regardeDroite == true:
					$Area2DEpeDroite/EpeCollisionDroite.disabled = false
					$Area2DEpeGauche/EpeCollisionGauche.disabled = true
				elif regardeDroite == false:
					$Area2DEpeGauche/EpeCollisionGauche.disabled = false
					$Area2DEpeDroite/EpeCollisionDroite.disabled = true
				temps+=1
				yield(get_tree().create_timer(0.02), "timeout")
				
			$Area2DEpeDroite/EpeCollisionDroite.disabled = true
			$Area2DEpeGauche/EpeCollisionGauche.disabled = true
			attaque = false
			

#fonction principal du mouvement du joueur
func _physics_process(delta):
	
	#par défaut la var moving doit être false
	moving = false
	
	#code qui gere la touche de fleche de droite (movement + animations)	
	if (Input.is_action_pressed("ui_right") and Global._degat == false):
			$AnimatedSprite.flip_h = false
			$wallUp1.rotation_degrees = 180
			$wallDown2.rotation_degrees = 90
			if regardeDroite == false:
				$AnimatedSprite.position.x =+ 5
			if slide == true:
				$AnimatedSprite.position.x =+ 0.25
			regardeDroite = true
			if attaque == false:
				if crouch == false:
					$AnimatedSprite.animation = "run"
					Global.currentAnim = "run"
					$AnimatedSprite.speed_scale = 2.5
				elif crouch ==true:
					$AnimatedSprite.animation = "CrouchWalking"
					Global.currentAnim = "crouchWalking"
					$AnimatedSprite.speed_scale = 2.5
			moving = true
			move.x = speed
	#code qui gere la touche de fleche de gauche (movement + animations)
	elif (Input.is_action_pressed("ui_left") and Global._degat == false):
			$AnimatedSprite.flip_h = true
			$wallUp1.rotation_degrees = 0
			$wallDown2.rotation_degrees = 270
			if regardeDroite == false:
				$AnimatedSprite.position.x =+ -5
			if slide == true:
				$AnimatedSprite.position.x =+ -0.25
			regardeDroite = false
			if attaque == false:
				if crouch == false:
					$AnimatedSprite.animation = "run"
					Global.currentAnim = "run"
					$AnimatedSprite.speed_scale = 2.5
				if crouch == true:
					$AnimatedSprite.animation = "CrouchWalking"
					Global.currentAnim = "crouchWalking"
					$AnimatedSprite.speed_scale = 2.5

			moving = true
			move.x = -speed
	#ça sert à rendre smooth l'arrête d'animation mais finalement sans ça
	#le joueur glisse à l'infini
	else: 
		move.x = lerp(move.x, 0, 1)
		
	#création de la gravité
	#move.y += delta * gravity
	
	#code qui gere la touche fleche de haut (mouvement + animation)
	if Input.is_action_just_pressed("ui_up") and (is_on_floor() or slide == true) and Global._degat == false and Global.bodyEntered == false:
		if roofBodyEntered == false:
			move.y += -jump
			crouch = false
			speed = 200
			if attaque == false:
				jumping = true
				$AnimatedSprite.animation = "jump"
				Global.currentAnim = "jump"
				$CollisionShape2D2.disabled = false
				$Area2DPlafond/CollisionShape2D.disabled = true
	if Input.is_action_just_pressed("action_lancer") and Global.poele > 0:
		lancer_poele($AnimatedSprite.flip_h)
		Global.poele = Global.poele - 1
	
	#code qui sert juste à jouer l'animation de iddle si aucune autre
	#animation plus importante joue actuellement
	if moving == false and attaque == false and Global._degat == false and hang == false:
		if crouch == true:
			$AnimatedSprite.animation = "crouch"
			Global.currentAnim = "crouch"
		else:
			$AnimatedSprite.animation = "iddle"
			Global.currentAnim = "iddle"
			$AnimatedSprite.speed_scale = 1.25
	#code qui sert à jouer l'animation de saut si aucune autre animation plus importante joue
	if jumping == true and attaque == false and Global._degat == false:
		$AnimatedSprite.animation = "jump"
		Global.currentAnim = "jump"
		yield(get_tree().create_timer(0.2), "timeout")
		jumping = false





func lancer_poele(poele_direction: bool):
	if Poele:
		var poele = Poele.instance()
		get_tree().current_scene.add_child(poele)
		if poele_direction:
			poele.global_position = $Positiongauche.global_position
			poele.direction = Vector2.LEFT.rotated(rotation)
			poele.cotePoele(poele_direction)
		else:
			poele.global_position = $Positiondroite.global_position
			poele.direction = Vector2.RIGHT.rotated(rotation)
			poele.cotePoele(poele_direction)
