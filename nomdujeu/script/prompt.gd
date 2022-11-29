extends Node2D

func _on_Area_A_D_body_entered(body):
	if body.is_in_group("chevalier"):
		$PROMPTS/A_LEFT.visible = true
		$PROMPTS/D_RIGHT.visible = true
	else:
		$PROMPTS/A_LEFT.visible = false
		$PROMPTS/D_RIGHT.visible = false

func _on_Area_W_body_entered(body):
	if body.is_in_group("chevalier"):
		$PROMPTS/W_UP.visible = true
	else:
		$PROMPTS/W_UP.visible = false



func _on_Area_SPACE_body_entered(body):
	if body.is_in_group("chevalier"):
		$PROMPTS/SPACE.visible = true
	else:
		$PROMPTS/SPACE.visible = false


func _on_Area_S_body_entered(body):
	if body.is_in_group("chevalier"):
		$PROMPTS/S_DOWN.visible = true
	else:
		$PROMPTS/S_DOWN.visible = false
		




func _on_Area_A_D_body_exited(body):
		$PROMPTS/A_LEFT.visible = false
		$PROMPTS/D_RIGHT.visible = false

func _on_Area_W_body_exited(body):
		$PROMPTS/W_UP.visible = false
	
func _on_Area_SPACE_body_exited(body):
		$PROMPTS/SPACE.visible = false
		
func _on_Area_S_body_exited(body):
		$PROMPTS/S_DOWN.visible = false
