extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 225
var direction = Vector2.RIGHT.rotated(rotation)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	global_position += speed * direction * delta
func _destroy():
	queue_free()



func _on_Area2D_body_entered(body):
	if !body.is_in_group("chevalier") and !body.is_in_group("projectile"):
		_destroy() 
	if body.is_in_group("ennemie"):
		Global._attaque = true
		Global.poele = Global.poele + 1
		_destroy()
	


func cotePoele(cote : bool):
	if cote:
		$sprite_poele.flip_h=true
	else:
		$sprite_poele.flip_h=false
