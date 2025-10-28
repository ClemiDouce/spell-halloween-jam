class_name TweenCurve
extends Tween

var _curve : Curve

func _init(c: Curve) -> void:
	_curve = c

func tween_property_curve(object: Object, property: NodePath, final_val: Variant, duration: float) -> PropertyTweener:
	return tween_property(object, property, final_val, duration).set_custom_interpolator(_sample_curve)

func _sample_curve(v: float) -> float:
	return _curve.sample_baked(v)
