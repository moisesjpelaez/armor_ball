package arm.player;

import arm.autoload.GameEvents;
import arm.autoload.MainInstances;
import armory.trait.physics.PhysicsWorld;
import armory.trait.physics.RigidBody;
import iron.math.Vec2;
import iron.math.Vec4;
import iron.system.Input;

class Player extends iron.Trait {
	@prop var speed: Float = 10.0;

	var physics: PhysicsWorld;
	var rb: RigidBody;
	var gamepad: Gamepad;

	public function new() {
		super();

		notifyOnAdd(function() {
			MainInstances.player = this;
		});

		notifyOnInit(function() {
			physics = PhysicsWorld.active;
			rb = object.getTrait(RigidBody);
			gamepad = Input.getGamepad();
			notifyOnFixedUpdate(fixedUpdate);
			GameEvents.levelWon.connect(onGameEnded);
			GameEvents.playerDied.connect(onGameEnded);
		});

		notifyOnRemove(function() {
			GameEvents.levelWon.disconnect(onGameEnded);
			GameEvents.playerDied.disconnect(onGameEnded);
		});
	}

	public function fixedUpdate() {
		if (gamepad == null) return;
		var direction: Vec2 = new Vec2(gamepad.leftStick.x, gamepad.leftStick.y);
		if (direction.length() > 0.1) {
			rb.applyForce(new Vec4(direction.x, direction.y, 0, 1).mult(speed));
		}
	}

	function onGameEnded() {
		removeFixedUpdate(fixedUpdate);
	}
}