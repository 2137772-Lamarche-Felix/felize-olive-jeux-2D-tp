extends Control




func _on_Restart_pressed():
	Global.vieJoueur = 3
	Global.poele = 0
	get_tree().change_scene("res://scenes/niveaux/niveau_1/MainNiveau1.tscn")


func _on_Quit_pressed():
	get_tree().quit()
