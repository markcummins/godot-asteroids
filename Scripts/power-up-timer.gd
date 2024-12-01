extends Timer

class_name PowerUpTimer

@export var min_time = 5
@export var max_time = 15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup_timer():
	var timeout_value = randi_range(min_time, max_time)
	self.wait_time = timeout_value
	self.start()
