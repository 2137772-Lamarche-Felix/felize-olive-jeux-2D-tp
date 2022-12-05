extends KinematicBody2D

export(PackedScene) var Boite: PackedScene = preload("res://scenes/armes/boite_projectile.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var iddle = false

var peutLancer = false

export var gravity = 2000

var move = Vector2()

var current = false

var hit = false


func _process(delta):
	if iddle == true:
		$AnimatedSprite.animation = "iddleBox"
		
	move.y += delta * gravity
	move = move_and_slide(move,Vector2.UP)
	
	if Global._attaque == true and current == true:
		iddle = false
		hit = true
		yield(get_tree().create_timer(0.01), "timeout")
		Global._attaque = false
		current = false
	if hit == true:
		$AnimatedSprite.animation = "hit"
		yield(get_tree().create_timer(0.2), "timeout")
		$CollisionShape2D.disabled = true
		yield(get_tree().create_timer(0.3), "timeout")
		$AnimatedSprite.animation = "dead"
	
	
	
	
func lancer_boite(boite_direction: bool):
	if Boite and peutLancer == true:
		iddle = false
		$AnimatedSprite.animation  = "throwing"
		var boite = Boite.instance()
		get_tree().current_scene.add_child(boite)
		#if boite_direction and Global.droite == true:
		if Global.droite == true:
			boite.global_position = $PositionDroite.global_position
			boite.direction = Vector2.RIGHT.rotated(rotation)
			
		elif Global.droite == false:
			boite.global_position = $PositionGauche.global_position
			boite.direction = Vector2.LEFT.rotated(rotation)
		#iddle = true

	


func _on_detectGauche_body_entered(body):
	if body.is_in_group("chevalier"):
		peutLancer = true
		lancer()
		Global.droite = false
		#current = true


func _on_detectDroite_body_entered(body):
	if body.is_in_group("chevalier"):
		peutLancer = true
		lancer()
		Global.droite = true
		#current = true

func lancer():
		iddle = false
		$AnimatedSprite.animation  = "throwing"
		$cooldown.start(1)
	
func _on_cooldown_timeout():
	lancer_boite($AnimatedSprite.flip_h)




func _on_detectGauche_body_exited(body):
	peutLancer = false
	iddle = true


func _on_detectDroite_body_exited(body):
	peutLancer = false
	iddle = true
