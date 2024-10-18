extends Control

@export var input_texture : TextureRect
@export_global_dir var training_path: String

var net = GDNetwork.new()

var zero_files : PackedStringArray = []
var one_files : PackedStringArray = []
var two_files : PackedStringArray = []
var three_files : PackedStringArray = []
var four_files : PackedStringArray = []
var five_files : PackedStringArray = []
var six_files : PackedStringArray = []
var seven_files : PackedStringArray = []
var eight_files: PackedStringArray = []
var nine_files: PackedStringArray = []
var all_files : Array = []

var training_images : Array = []
var inputs : PackedFloat32Array = []
var target_array : PackedFloat32Array =[]
var target_num : float
var current_image : Image 
var batch_size : int = 10

var guesses : int = 0
var batches_trained : int = 0
var empty_target : PackedFloat32Array = [0,0,0,0,0,0,0,0,0,0]

func _ready() -> void:
	init_network()
	get_file_names()
	training_images = load_new_frames()
	
	#var test_image = training_images[randi_range(0,9)][randi_range(0,batch_size)]
	#get_single_image_inputs_targets(randi_range(0,9), training_images)
	#print(current_image)
	#print(inputs)
	train_batch()
	predict_and_verify()

func get_single_image_inputs_targets(_num: int, _array: Array):
	var num_array : Array = _array[_num]
	num_array.shuffle()
	current_image = num_array[0]
	inputs = get_inputs(current_image)
	target_array = empty_target.duplicate()
	target_array[_num] = 1.0
	target_num = _num
	input_texture.texture = ImageTexture.create_from_image(current_image)
	
func get_file_names()->void:
	var dir_name := training_path
	var dir := DirAccess.open(dir_name+"/zero")
	zero_files = dir.get_files()
	dir = DirAccess.open(dir_name+"/one")
	one_files = dir.get_files()
	dir = DirAccess.open(dir_name+"/two")
	two_files = dir.get_files()
	dir = DirAccess.open(dir_name+"/three")
	three_files = dir.get_files()
	dir = DirAccess.open(dir_name+"/four")
	four_files = dir.get_files()
	dir = DirAccess.open(dir_name+"/five")
	five_files = dir.get_files()
	dir = DirAccess.open(dir_name+"/six")
	six_files = dir.get_files()
	dir = DirAccess.open(dir_name+"/seven")
	seven_files = dir.get_files()
	dir = DirAccess.open(dir_name+"/eight")
	eight_files = dir.get_files()
	dir = DirAccess.open(dir_name+"/nine")
	nine_files = dir.get_files()
	all_files = [
		zero_files,
		one_files,
		two_files,
		three_files,
		four_files,
		five_files,
		six_files,
		seven_files,
		eight_files,
		nine_files
	]
	
func get_images(_files: Array, _subfolder: String,  _count:int)->Array:
	var new_array :Array = []
	for i in _count:
		var n : int = randi_range(0, _files.size()-1)
		var image := Image.load_from_file(training_path+"/"+_subfolder+"/"+_files[n])
		new_array.append(image)
		var path : String = training_path+"/"+_subfolder+"/"+_files[n]
	return new_array
	
func load_new_frames()->Array:
	var array : Array = []
	array.append(get_images(zero_files,"zero", batch_size) )
	array.append(get_images(one_files,"one", batch_size))
	array.append(get_images(two_files,"two", batch_size))
	array.append(get_images(three_files, "three" , batch_size))
	array.append(get_images(four_files,"four", batch_size))
	array.append(get_images(five_files,"five", batch_size))
	array.append(get_images(six_files,"six", batch_size))
	array.append(get_images(seven_files,"seven", batch_size))
	array.append(get_images(eight_files,"eight", batch_size))
	array.append(get_images(nine_files,"nine", batch_size))
	return array
	
func init_network()->void:

	
	net.add_layer(784)
	net.add_layer(16)
	net.add_layer(16)
	net.add_layer(10)
	net.init()
	

	net.set_wlr(.2)
	net.set_blr(.1)

func train_batch()->void:
	for i in 10:
		var num_array : Array = training_images
		for j in num_array.size():
			current_image = num_array[i][j]
		
			inputs = get_inputs(current_image)
			target_array = empty_target.duplicate()
			target_array[i] = 1.0
			target_num = i
			#print(current_image)
			#print(target)

			#print(target)
			net.train(inputs, target_array)
	batches_trained += 1
	
		
	##every folder has at least 3800 files
	#var dir = DirAccess.open(training_path)
	#if dir:
		#dir.list_dir_begin()
		#var file_name = dir.get_next()
		#while file_name != "":
			#if dir.current_is_dir():
				#print("Found directory: " + file_name)
			#else:
				#print("Found file: " + file_name)
			#file_name = dir.get_next()
			#dir.get_files()
	#else:
		#print("An error occurred when trying to access the path.")

func get_inputs(_image: Image)-> Array:
	var a : Array = []
	for y in _image.get_size().y:
		for x in _image.get_size().x:
			a.append(_image.get_pixel(x,y).r)
	return a
	
func predict_and_verify()->bool:
	training_images = load_new_frames()
	get_single_image_inputs_targets(randi_range(0,9), training_images)
	var out : Array = net.feedforward(inputs)
	#var out_max : float = out.max()
	#var out_max_idx : float = out.rfind(max)
	#print(out, "   Out Array")
	#print(target_array, "  Target Array")
	var out_guess := 0.0
	var out_max: = 0.0
	for i in out.size():
		if out[i] >out_max:
			out_max = out[i]
			out_guess = float(i)
	print(out_guess, ":", target_num, "   guessed:target")
	if target_num == out_guess:
		return true
	else:
		return false
	
	#print("Guess# ", guesses, "  Out: ", out[0], " Target: ", target[0], "  Batches trained: ", batches_trained)
	
func _process(delta: float) -> void:
	#
	#if guesses == 11:
		#return
	#elif guesses == 10:
		#print("10 correct guesses in a row!")
		#guesses += 1
	#elif guesses<10:
	var correct : bool = predict_and_verify()
	if correct:
		guesses += 1
		print(guesses, " correct guesses in a row!")
	else:
		guesses = 0
		training_images = load_new_frames()
		train_batch()
