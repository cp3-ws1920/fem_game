extends Camera2D

# Animate this to increase/decrease/fade the shaking

var rng = RandomNumberGenerator.new()

var is_shaking = false
var shake_timer = 0.0
var shake_frequency = 40.0
var shake_duration = 0.2
var shake_amplitude = 5.0

var shake_samples = []

func _ready():
	rng.randomize()

func shake():
	var sample_count = shake_duration * shake_frequency

	var samples = []
	for i in range(sample_count+1):
		samples.append(Vector2(rng.randf() * 2.0 - 1.0, rng.randf() * 2.0 - 1.0))
	print(samples)
	shake_samples = samples
	is_shaking = true
	shake_timer = 0.0

func amplitude(t):
	if t >= shake_duration:
		is_shaking = false
		return Vector2(0.0, 0.0)

	if not is_shaking:
		return Vector2(0.0, 0.0)

	var s = t * shake_frequency
	var s0 = floor(s)
	var s1 = s0 + 1

	return (shake_samples[s0] + (s - s0)*(shake_samples[s1] - shake_samples[s0])) * shake_amplitude

func _process(delta):
	set_offset(amplitude(shake_timer))
	shake_timer += delta
