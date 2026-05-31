package arm.test;

// import arm.autoload.MainInstances;
// import armory.trait.physics.RigidBody;
// import iron.Scene;
// import iron.data.SceneFormat.TSceneFormat;
import iron.object.Animation;
// import iron.object.Object;
import iron.system.Input;

class PlayerAnim extends iron.Trait {
    var anim: Animation;
    var gamepad: Gamepad;
	var keyboard: Keyboard;
	// var spawnObjects: TSceneFormat;

	public function new() {
		super();

		notifyOnInit(function() {
			// spawnObjects = MainInstances.spawnScene;
			anim = object.getAnimation();
			anim.play("Idle");
            gamepad = Input.getGamepad();
			keyboard = Input.getKeyboard();
		});

		notifyOnUpdate(function() {
			if (gamepad.started("a") || keyboard.started("space")) {
				anim.play("Run");
				// Scene.active.spawnObject("Bomb", null, function(o: Object) {
				// 	var rb: RigidBody = o.getTrait(RigidBody);
				// 	o.transform.loc.z = 2.0;
				// 	o.transform.buildMatrix();
				// 	rb.transform.loc.z = 2.0;
				// 	rb.syncTransform();
				// }, true, spawnObjects);
			}
			else if (gamepad.started("b")) anim.play("Jump");
			else if (gamepad.started("x")) anim.play("Idle");
			else if (gamepad.started("r2")) anim.pause();
			else if (gamepad.started("l2")) anim.resume();
		});
	}
}