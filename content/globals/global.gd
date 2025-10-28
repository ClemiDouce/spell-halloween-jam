extends Node

func tween_curve(v: float, curve: Curve, ):
	return curve.sample_baked(v)
