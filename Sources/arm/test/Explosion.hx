package arm.test;

import armory.system.Timer;
import armory.system.Tween;
import armory.trait.physics.RigidBody;
import iron.math.Vec4;
import iron.object.Object;

class Explosion extends iron.Trait {
	@prop var expandTime: Float = 0.35;
	@prop var lifeTime: Float = 0.8;

	var rb: RigidBody;
	var radius: Float = 100.0;
	var tween: Tween = new Tween();

	public function new() {
		super();

		// notifyOnInit(function() {
		// 	rb = object.getTrait(RigidBody);
		// 	tween.vec4(object.transform.scale, new Vec4(radius, radius, radius, 1), expandTime, function(vec: Vec4) {
		// 		object.transform.scale.setFrom(vec);
		// 		object.transform.buildMatrix();
		// 		rb.syncTransform();
		// 	}, function() {
		// 		tween.delay(lifeTime, function() {
		// 			object.remove();
		// 		}).start();
		// 	}).start();
		// });
	}
}
