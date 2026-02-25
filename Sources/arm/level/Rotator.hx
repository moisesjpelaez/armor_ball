package arm.level;

import iron.math.Vec4;
import iron.system.Time;

class Rotator extends iron.Trait {
	@prop var rotationSpeed: Float = 1.0;

	public function new() {
		super();

		notifyOnUpdate(function() {
			object.transform.rotate(new Vec4(0, 0, 1, 1), rotationSpeed * Time.delta);
		});
	}
}
