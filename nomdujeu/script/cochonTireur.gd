extends KinematicBody2D

export(PackedScene) var Boite: PackedScene = preload("res://scenes/armes/boite_projectile.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Timer.start(2)
	
	
	
	
func lancer_boite(boite_direction: bool):
	if Boite:
		var boite = Boite.instance()
		get_tree().current_scene.add_child(boite)
		if boite_direction:
			boite.global_position = $PositionDroite.global_position
			boite.direction = Vector2.RIGHT.rotated(rotation)
			
		else:
			boite.global_position = $PositionGauche.global_position
			boite.direction = Vector2.LEFT.rotated(rotation)


func _on_Timer_timeout():
	lancer_boite($AnimatedSprite.flip_h)
