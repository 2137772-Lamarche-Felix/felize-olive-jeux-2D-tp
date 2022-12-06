extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Restart_pressed():
	Global.vieJoueur = 3
	Global.poele = 0
	$AudioStreamPlayer.play()
	get_tree().change_scene("res://scenes/niveaux/niveau_1/MainNiveau1.tscn")





func _on_Quitter_pressed():
	$AudioStreamPlayer.play()
	get_tree().quit()
