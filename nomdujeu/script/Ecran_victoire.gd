extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer.grab_focus()


func _on_Quit_pressed():
	$AudioStreamPlayer.play()
	get_tree().quit()



func _on_Restart_pressed():
	$AudioStreamPlayer.play()
	get_tree().change_scene("res://scenes/niveaux/niveau_1/MainNiveau1.tscn")
