extends Label


func _process(delta: float) -> void:
	$".".text="poele: "+str(Global.poele)
