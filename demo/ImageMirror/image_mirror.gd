extends Control

var net = GDNetwork.new()

var inputs : Array = [ ]
var targets : Array = [ ]

var uv_inputs : Array = []
var uv_targets : Array = []

@export var pixel_grid : GridContainer
@export var training_texture: AnimatedSprite2D

var training_image : Image

func _ready() -> void:
	init_network()
	#init_pixels(pixel_grid, training_texture)
	training_image = training_texture.sprite_frames.get_frame_texture("default", training_texture.frame).get_image()
	init_pixels(pixel_grid, training_image)
#	set_training_data(pixel_grid, training_image)
	
func init_pixels(_grid:GridContainer, _image: Image)->void:
	var image_rows : int = _image.get_size().y
	var image_cols : int = _image.get_size().x
	var grid_rows = 128
	var grid_cols = 128
	_grid.columns = grid_cols
	for y in grid_rows:
		for x in grid_cols:
			var p := Pixel.new()
			p.x = x
			p.y = y
			p.width = grid_cols
			p.height = grid_rows
			p.custom_minimum_size = Vector2(4,4)
			#p.l = (x/float(cols)) * (y/float(rows))
			#var c :Color = _image.get_pixel(x,y)
			var c :Color = _image.get_pixel(
				floori(x/float(grid_cols)*image_cols),
				floori(y/float(grid_rows)*image_rows))
			p.color = Color(0,0,0,0)
			#p.color = Color(p.l,p.l,p.l,1.0)
			_grid.add_child(p)
			inputs.append([p.x/float(grid_cols), p.y/float(grid_rows)])
			targets.append([c.r,c.g,c.b,c.a])
			uv_inputs.append( [p.x/float(grid_cols), p.y/float(grid_rows)] )
			uv_targets.append( [p.l] )
	

func init_network()->void:
	net.add_layer(3)
	net.add_layer(40)
	net.add_layer(4)
	net.init()
	
	net.set_wlr(.2)
	net.set_blr(.1)
	
func set_training_data(_grid:GridContainer, _image: Image)->void:
	#inputs = []
	#targets = []
	var rows : int = _image.get_size().y
	var cols : int = _image.get_size().x

	var idx = 0
	for y in rows:
		for x in cols:
			var p : Pixel = _grid.get_child(idx)
			var c :Color = _image.get_pixel(x,y)
			#net.init()
			#net.randomize_biases()
			#net.randomize_weights()
			#p.color = Color(0,0,0,0)
			
			#inputs[idx]= [p.x/float(cols), p.y/float(rows)]
			targets[idx]= [c.r,c.g,c.b,c.a]
			idx += 1
	

func _process(delta: float) -> void:
	
	#Mirror UV, switch to one output
	#for i in pixel_grid.get_child_count():
		#var out : Array = net.train( guess_inputs[i], guess_targets[i] )
		#var p = pixel_grid.get_child(i)
		#p.l = out[0]
		#p.color = Color(p.l,p.l,p.l,1.0)
	
	#Mirror Training Texture
	#for i in pixel_grid.get_child_count():
	for n in 2000:
		var i := randi_range(0, inputs.size()-1)
		var input :Array  = inputs[i].duplicate()
		input.append(training_texture.get_frame()/float(training_texture.sprite_frames.get_frame_count("default")))
		var out : Array = net.train( input, targets[i] )
		var p = pixel_grid.get_child(i)
		p.color = Color(out[0],out[1],out[2],out[3])
		#p.l = out[0]
		#p.color = Color(p.l,p.l,p.l,1.0)
	


func _on_animated_frame_changed() -> void:
	training_image = training_texture.sprite_frames.get_frame_texture("default", training_texture.frame).get_image()
	set_training_data(pixel_grid, training_image)
	
