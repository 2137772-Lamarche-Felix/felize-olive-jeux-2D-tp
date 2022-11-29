extends Area2D

var _attaque = false

var _degat = false

var currentAnim = "iddle"

var debug = false


func timer(var temps):
	yield(get_tree().create_timer(temps), "timeout")
