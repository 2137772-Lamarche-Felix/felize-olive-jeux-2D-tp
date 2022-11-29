extends Label


func _process(delta: float) -> void:
	$".".text="animation: "+Global.currentAnim
