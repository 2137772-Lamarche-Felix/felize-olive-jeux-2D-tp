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

var canJump = false
var canwallJump = false
var wallJumpY = 600
var moveX = false
var rejumpGauche = false
var rejumpDroite = false
var sliding = false

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
	
	if nextTowall() == false:
		sliding = false
		canwallJump = true
	if nextTowall() and !is_on_floor() and jumping == false:
		sliding = true
		if regardeDroite == true:
			$AnimatedSprite.animation = "wallSlide"
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.position.x = -1
		elif regardeDroite == false:
			$AnimatedSprite.animation = "wallSlide"
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.position.x = 1
	
	if sliding == true:
		if move.y >= 40:
			move.y = 40
	
	Global.debug = str(crouch)
	#sauter()
	#if $wallUp1.is_colliding() and $wallDown2.is_colliding() and !is_on_floor():
	#	slide = true
	#	if !Input.is_action_just_pressed("ui_up"):
	#		move.y -= wallJumpY
	#		slide =false
	#	if Input.is_action_just_pressed("ui_up"):
	#		move.y -= wallJumpY
	#		slide = false
	#	$AnimatedSprite.animation = "wallSlide"
	#	if move.y > 10 and slide == true:
	#		move.y = 10
	#	if regardeDroite == false:
	#		$AnimatedSprite.flip_h = false
	#	if regardeDroite == true:
	#		$AnimatedSprite.flip_h = true
	#else:
	#	slide = false
	
	
	#if (Global.vieJoueur == 2 or Global.vieJoueur == 1)and 
	if Global._degat == true:
		
		$AnimatedSprite.animation="death"
		$AnimatedSprite.speed_scale = 2
		remove_from_group("chevalier")
		yield(get_tree().create_timer(1), "timeout")
		$AnimatedSprite.animation="iddleDeath"
		add_to_group("chevalier")	
		Global._degat = false
		$bruitDegats.play()
		yield(get_tree().create_timer(0.15), "timeout")
		get_tree().reload_current_scene()
		
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
			#$AnimatedSprite.animation="CrouchToWalk"
			Global.currentAnim = "crouchToWalk"

	
	#si le joueur tombe dans dans le vide, l'animation de chute va jouer
	#jusqu'à ce que le joueur touche un sol		
	if jumping == false and attaque == false and Global._degat == false and sliding == false:
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
			$bruitAttaque.play()
			
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
	
	#if moveX == true:
	#	$walljumpTimer.start(0.1)
	#	move.x = 200
	
	move.y += delta*gravity
			
	
	move = move_and_slide(move,Vector2.UP)
	
	#par défaut la var moving doit être false
	moving = false
	
	#code qui gere la touche de fleche de droite (movement + animations)	
	if (Input.is_action_pressed("ui_right") and Global._degat == false):
			Global.droite = true
			$AnimatedSprite.flip_h = false
			$wallUp1.rotation_degrees = 180
			$wallDown2.rotation_degrees = 90
			if regardeDroite == false:
				$AnimatedSprite.position.x =+ 5
			#if slide == true:
			#	$AnimatedSprite.position.x =+ 0.25
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
			Global.droite = false
			$AnimatedSprite.flip_h = true
			$wallUp1.rotation_degrees = 0
			$wallDown2.rotation_degrees = 270
			if regardeDroite == false:
				$AnimatedSprite.position.x =+ -5
			#if slide == true:
			#	$AnimatedSprite.position.x =+ -0.25
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
	sauter()





	if Input.is_action_just_pressed("action_lancer") and Global.poele > 0:
		lancer_poele($AnimatedSprite.flip_h)
		Global.poele = Global.poele - 1
	
	#code qui sert juste à jouer l'animation de iddle si aucune autre
	#animation plus importante joue actuellement
	if moving == false and attaque == false and Global._degat == false:
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




func sauter():
	if Input.is_action_just_pressed("ui_up") and Global._degat == false and Global.bodyEnteredPorte == false and roofBodyEntered == false:
		var animJump = false
		crouch = false
		speed = 200
		if roofBodyEntered == false and is_on_floor():
			canJump = true
			animJump = true
			canwallJump = true
			jumping = true
		else:
			canJump = false
			jumping = false
		

		if !is_on_floor() and nextToRightwall() and canwallJump == true:
			move.y = -wallJumpY
			$bruitSaut.play()
			moveX = true
			canwallJump = false
			jumping = true
	
		if !is_on_floor() and nextToLeftwall() and canwallJump == true:
			move.y = -wallJumpY
			$bruitSaut.play()
			moveX = true
			canwallJump = false
			jumping = true
			
			
		if canJump == true:
			move.y -= jump
			canJump = false
			$bruitSaut.play()
			
		if attaque == false and animJump == true:
			jumping = true
			$AnimatedSprite.animation = "jump"
			Global.currentAnim = "jump"
			$CollisionShape2D2.disabled = false
			$Area2DPlafond/CollisionShape2D.disabled = true
			
	#Global.debug = move.y

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
			
	
func nextTowall():
	return nextToRightwall() or nextToLeftwall()
	
func nextToRightwall():
	return $wallDown2.is_colliding()
	
func nextToLeftwall():	
	return $wallDown2.is_colliding()


func _on_walljumpTimer_timeout():
	moveX = false
