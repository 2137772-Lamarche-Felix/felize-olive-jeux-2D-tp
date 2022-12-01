extends Area2D





func _on_pic_body_entered(body):
	if body.is_in_group("chevalier"):
		Global._degat = true
		Global.vieJoueur -= 1
