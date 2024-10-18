extends Control

var net = GDNetwork.new()

var input = [ [1,1], [1,0], [0,1], [0,0] ]
var target = [ [0], [1], [1], [0] ]

var guess_inputs : Array = []
var guess_targets : Array = []

@export var pixel_grid : GridContainer

func _ready() -> void:
	init_network()
	init_pixels(pixel_grid)
	
func init_pixels(_grid:GridContainer)->void:
	var rows : int = _grid.columns
	var cols : int = rows
	for y in rows:
		for x in cols:
			var p := Pixel.new()
			p.x = x
			p.y = y
			p.width = cols
			p.height = cols
			p.custom_minimum_size = Vector2(1,1)
			p.l = (x/float(cols)) * (y/float(rows))
			p.color = Color(1.0,1.0,1.0,1.0)
			p.color = Color(p.l,p.l,p.l,1.0)
			_grid.add_child(p)
			
			guess_inputs.append( [p.x, p.y] )
			guess_targets.append( [p.l] )
	

func init_network()->void:
	net.add_layer(2)
	net.add_layer(20)
	net.add_layer(1)
	net.init()
	
	net.set_wlr(0.4)
	net.set_blr(0.8)
	

func _process(delta: float) -> void:
	pass
	for f in 200:
		#var error : float = 0
		#for i in range(0,4):
		var i : int = randi_range(0, 3)
		var out : Array = net.train( input[i], target[i] )
		#error += abs(target[i][0]-out[0])

	for i in pixel_grid.get_child_count():
		var p = pixel_grid.get_child(i)
		var out = net.feedforward( [p.x/float(p.width), p.y/float(p.height)])
		p.l = out[0]
		p.color = Color(p.l,p.l,p.l,1.0)
