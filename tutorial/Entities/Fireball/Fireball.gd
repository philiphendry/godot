extends Area2D

var tilemap
var speed = 80
var direction : Vector2
var attack_damage

func _ready():
	print("Fireball - ready")
	tilemap = get_tree().root.get_node("Root/TileMap")

func _process(delta):
	position = position + speed * delta * direction

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "explode":
		get_tree().queue_delete(self)

func _on_Timer_timeout():
	$AnimatedSprite.play("explode")

func _on_Fireball_body_entered(body):
	print("Fireball - _on_Fireball_body_entered")
	# Ignore collision with Player and Water
	if body.name == "Player":
		print("Firebal - player")
		return
	
	if body.name == "TileMap":
		print("Firebal - TilkeMap")
		var cell_coord = tilemap.world_to_map(position)
		var cell_type_id = tilemap.get_cellv(cell_coord)
		if cell_type_id == tilemap.tile_set.find_tile_by_name("Water"):
			print("Firebal - water")
			return
	
	# If the fireball hit a Skeleton, call the hit() function
	if body.name.find("Skeleton") >= 0:
		print("Firebal - skeleton")
		body.hit(attack_damage)
	
	print("Firebal - explode")
	# Stop the movement and explode
	direction = Vector2.ZERO
	$AnimatedSprite.play("explode")
