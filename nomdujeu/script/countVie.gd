extends Label


func _process(delta: float) -> void:
	$".".text="vie: "+str(Global.vieJoueur)
