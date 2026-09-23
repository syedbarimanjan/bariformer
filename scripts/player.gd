extends CharacterBody2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var player_animated_sprite_2d: AnimatedSprite2D = $PlayerAnimatedSprite2D
@onready var attack_hitbox: Area2D = $PlayerAttackHitbox
@onready var attack_shape: CollisionShape2D = $PlayerAttackHitbox/CollisionShape2D # Adjust path if needed

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var is_attacking = false

func _physics_process(delta: float) -> void:

	if not is_attacking:
		if velocity.x > 1 or velocity.x < -1:
			player_animated_sprite_2d.animation = "running"
		else:
			player_animated_sprite_2d.animation = "idle"
		

		if not is_on_floor():
			velocity += get_gravity() * delta
			player_animated_sprite_2d.animation = "jumping"


	if Input.is_action_just_pressed("up") and is_on_floor() and not is_attacking:
		velocity.y = JUMP_VELOCITY
	

	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack()


	var direction := Input.get_axis("left", "right")
	if direction and not is_attacking:
		velocity.x = direction * SPEED
	elif not is_attacking:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	

	if direction == 1.0:
		player_animated_sprite_2d.flip_h = false
		collision_shape_2d.position.x = 0
		attack_shape.position.x = abs(attack_shape.position.x)
	elif direction == -1.0:
		player_animated_sprite_2d.flip_h = true
		collision_shape_2d.position.x = 16
		attack_shape.position.x = -abs(attack_shape.position.x)

func attack() -> void:
	is_attacking = true
	player_animated_sprite_2d.play("attack")
	
	attack_hitbox.monitorable = true
	attack_hitbox.monitoring = true
	
	await player_animated_sprite_2d.animation_finished
	
	attack_hitbox.monitorable = false
	attack_hitbox.monitoring = false
	
	is_attacking = false
