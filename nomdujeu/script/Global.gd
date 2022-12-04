extends Area2D

var _attaque = false
var poele = 1


var _degat = false

var currentAnim = "iddle"

var nextScene = ""

var bodyEntered = false

func update_poele(delta):
	poele+=delta
#func _process(delta):
var debug = false

var vieJoueur = 3

var positionChevalier = 0
var positionSpawn = 0
func _ready():
	Engine.set_target_fps(60)

func timer(var temps):
	yield(get_tree().create_timer(temps), "timeout")

func update_vie(delta):
	vieJoueur-=delta
	if vieJoueur <= 0:
		get_tree().change_scene("res://scenes/niveaux/Gameover.tscn")
	
