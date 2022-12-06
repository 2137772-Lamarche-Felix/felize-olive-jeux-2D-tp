extends Area2D



func _on_Area2DEpe_body_entered(body):
			if body.is_in_group("ennemie"):
				Global._attaque = true
			Global.currentEnnemie = str(body)


func _on_Area2DEpeGauche_body_entered(body):
			if body.is_in_group("ennemie"):
				Global._attaque = true
				Global.currentEnnemie = str(body)
