extends StaticBody2D

func _on_hurtbox_area_entered(area: Area2D) -> void:
	# Check if the area touching it is the player's sword hitbox
	if area.name == "PlayerAttackHitbox":
		queue_free() # Destroys/removes the box from the game
