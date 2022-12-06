extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 125
var rotation2 = 15
var direction = Vector2.RIGHT.rotated(rotation2)
# Called when the node enters the scene tree for the first time.




func _process(delta):
	global_position += speed * direction * delta
func _destroy():
	queue_free()



func _on_Area2D_body_entered(body):
	if body.is_in_group("chevalier"):
		Global._degat = true
		Global.update_vie(1)
		_destroy()
	if !body.is_in_group("ennemie") and !body.is_in_group("projectile"):
		_destroy() 

	



