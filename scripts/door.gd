extends Area2D
@onready var door: Area2D = $"."
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var player_in_range = false
var stored_body: Node2D = null

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and stored_body and event.is_action_pressed("down"):
		player_in_range = false
		animated_sprite_2d.play("opening")
		await animated_sprite_2d.animation_finished
		animated_sprite_2d.pause()
		
		var real_player_sprite = stored_body.get_node_or_null("PlayerAnimatedSprite2D") as AnimatedSprite2D
		if real_player_sprite:
			print(real_player_sprite.animation)
			real_player_sprite.play("doorIn")
			stored_body.set_physics_process(false)
			print(real_player_sprite.animation)
			await real_player_sprite.animation_finished
			stored_body.visible = false
		
		animated_sprite_2d.play("closing")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = true
		stored_body = body

func _on_body_exited(body: Node2D) -> void:
	if body == stored_body:
		player_in_range = false
		stored_body = null
