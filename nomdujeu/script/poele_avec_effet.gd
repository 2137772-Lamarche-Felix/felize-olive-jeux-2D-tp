extends Area2D
onready var explosion = get_parent().get_child(0)






func _on_Poele_effet_body_entered(body):
	if body.is_in_group("chevalier"):
		Global.update_poele(1)
		explosion.shot()
		queue_free()
