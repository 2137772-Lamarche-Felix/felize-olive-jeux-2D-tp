extends Area2D

var _attaque = false
var poele = 1

var droite = false

var _degat = false

var currentEnnemie = ""

var currentAnim = "iddle"

var nextScene = ""

var bodyEnteredPorte = false

func update_poele(delta):
	poele+=delta
#func _process(delta):
var debug = false

var vieJoueur = 3

var positionChevalier = 0

var positionSpawn = 0
#var spawn = ""
func _ready():
	Engine.set_target_fps(60)

func timer(var temps):
	yield(get_tree().create_timer(temps), "timeout")

func update_vie(vie):
	vieJoueur-=vie
	if vieJoueur <= 0:
		yield(get_tree().create_timer(1), "timeout")
		get_tree().change_scene("res://scenes/niveaux/Gameover.tscn")
	
