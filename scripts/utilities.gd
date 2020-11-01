# Utilities 
# Global Singleton
# Contains miscellaneous helper functions.

extends Node

# Returns the shortest angle difference to get from b to a in 
# radians. 
# Code based on: https://stackoverflow.com/a/28037434
static func get_angle_diff(angle_a: float, angle_b: float) -> float:
	var angle_diff := fmod((angle_b - angle_a + PI), 2 * PI) - PI;
	if angle_diff < -PI:
		angle_diff += 2 * PI
	return angle_diff as float
