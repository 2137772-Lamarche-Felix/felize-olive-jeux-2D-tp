extends Area2D



func _on_Area2DEpe_body_entered(body):
		for _body in get_overlapping_bodies():
			if _body.is_in_group("ennemie"):
				Global._attaque = true
