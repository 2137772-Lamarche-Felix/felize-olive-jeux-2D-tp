extends Area2D

var _attaque = false
var poele = 0

var _degat = false

var currentAnim = "iddle"

func update_poele(delta):
	poele+=delta
#func _process(delta):
var debug = false


func _ready():
	Engine.set_target_fps(60)

func timer(var temps):
	yield(get_tree().create_timer(temps), "timeout")
