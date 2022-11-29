extends Area2D

var _attaque = false
var poele = 0
var currentAnim = "iddle"

func update_poele(delta):
	poele+=delta
#func _process(delta):
