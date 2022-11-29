extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		$W.animation = "pressed"
	else:
		$W.animation = "unpressed"
	
	if Input.is_action_pressed("ui_down"):
		$S.animation = "pressed"
	else:
		$S.animation = "unpressed"
		
	if Input.is_action_pressed("ui_left"):
		$A.animation = "pressed"
	else:
		$A.animation = "unpressed"
		
	if Input.is_action_pressed("ui_right"):
		$D.animation = "pressed"
	else:
		$D.animation = "unpressed"
		
	if Input.is_action_pressed("ui_space"):
		$SPACE.animation = "pressed"
	else:
		$SPACE.animation = "unpressed"
