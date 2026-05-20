package arm.test;

import arm.autoload.MainInstances;
import iron.Scene;
import iron.data.SceneFormat;
import iron.math.Quat;
import iron.math.Vec4;
import iron.object.Object;
import armory.trait.physics.RigidBody;

class Bomb extends iron.Trait {
	var rb: RigidBody;
	var exploded: Bool = false;
	var spawnScene: TSceneFormat;

	public function new() {
		super();

		notifyOnInit(function() {
			spawnScene = MainInstances.spawnScene;
			rb = object.getTrait(RigidBody);
			rb.notifyOnContact(function (body: RigidBody) {
				if (!exploded) {
					exploded = true;
					Scene.active.spawnObject("Explosion", null, function (o: Object) {
						object.transform.buildMatrix();

						var rb: RigidBody = o.getTrait(RigidBody);

						var loc: Vec4 = new Vec4();
						var rot: Quat = new Quat();
						var scale: Vec4 = new Vec4();
						object.transform.world.decompose(loc, rot, scale);

						o.transform.loc.setFrom(loc);
						o.transform.rot.setFrom(rot);
						o.transform.buildMatrix();

						rb.transform.world.setLoc(loc);
						rb.syncTransform();
					}, true, spawnScene);
					object.remove();
				}
			});
		});
	}
}
