extends Area2D

var useButtonPressed = false

#get_tree().change_scene("res://Assets/Scenes/MainZZtope.tscn")
#$".".text="animation: "+Global.currentAnim

func anim():
	if Global.bodyEntered == true:
		$AnimatedSprite.animation = "iddleOpened"
	else:
		$AnimatedSprite.animation = "iddleClosed"

func _process(delta):
		if Input.is_action_just_pressed("ui_up") and useButtonPressed == true and Global.bodyEntered == true:
			useButtonPressed = false
			Global.bodyEntered = false
			get_tree().change_scene(Global.nextScene)

func _on_Porte_body_entered(body):
	useButtonPressed = true
	if body.is_in_group("chevalier"):
		Global.bodyEntered = true
		$AnimatedSprite.animation = "opening"
		$Timer.start(0.6)
			

func _on_Porte_body_exited(body):
	useButtonPressed = false
	Global.bodyEntered = false
	$AnimatedSprite.animation = "closing"
	$Timer.start(0.5)
	



func _on_Timer_timeout():
	anim()

