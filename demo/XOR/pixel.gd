extends ColorRect
class_name Pixel

var x : int 
var y : int
var width : int
var height : int
var l : float

func _process(delta: float) -> void:
	color.a -= delta
