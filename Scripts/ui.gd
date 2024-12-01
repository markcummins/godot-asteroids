extends CanvasLayer

const ASSETS_LIVES = preload("res://Assets/Lives.png")
const ASSETS_PLAYER = preload("res://Assets/Player.png")

@onready var lives_container: HBoxContainer = $Timer/MarginContainer/LivesContainer
@onready var lives_manager: LivesManager = $"../LivesManager"

@onready var game_over_timer: Timer = $Timer
@onready var game_over_label: Label = $Timer/MarginContainer/CenterContainer/GameOverLabel

@onready var totalLives: int
@onready var game_over_timer_instance: int = 0

@onready var score_manager: ScoreManager = $"/root/main/ScoreManager"
@onready var points_label: Label = $Timer/MarginContainer/LabelContainer/PointsLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	totalLives = lives_manager.lives
	
	var lives = lives_manager.lives
	draw_lives(lives)
	
	score_manager.score_updated.connect(update_score)
	lives_manager.player_life_lost.connect(life_lost)
	
func update_score(score):
	points_label.text = str(score)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func life_lost(lives_left) -> void:
	draw_lives(lives_left)
	
	if(lives_left == 0):
		game_over_label.visible = true

		game_over_text_cycle()
		game_over_timer.timeout.connect(game_over_text_cycle)
		game_over_timer.start()
	
func game_over_text_cycle():
	game_over_label.text = "Game Over!" if game_over_timer_instance%2==0 else "You Lose!"
	game_over_timer_instance = game_over_timer_instance + 1
	
func draw_lives(lives_left):
	var life_texture_rect: TextureRect = lives_container.get_child(lives_left)
	
	for child in lives_container.get_children():
		child.queue_free()
	
	for i in range(totalLives):
		var life_text_rect = TextureRect.new()
		life_text_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		life_text_rect.stretch_mode = TextureRect.STRETCH_SCALE

		life_text_rect.texture = ASSETS_LIVES if  i < lives_left else ASSETS_PLAYER
		
		life_text_rect.custom_minimum_size = Vector2(32,32)
		
		lives_container.add_child(life_text_rect)
