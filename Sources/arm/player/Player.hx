package arm.player;

import arm.autoload.GameEvents;
import arm.autoload.MainInstances;
import armory.trait.physics.PhysicsWorld;
import armory.trait.physics.RigidBody;
import iron.math.Vec2;
import iron.math.Vec4;
import iron.system.Input;

class Player extends iron.Trait {
	@prop var speed: Float = 8.0;
	@prop var maxSpeed: Float = 8.0;

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
		var inputLen: Float = direction.length();
		if (inputLen > 0.1) {
			// Unit direction for the dot product, but keep inputLen for force scaling
			var dirX: Float = direction.x / inputLen;
			var dirY: Float = direction.y / inputLen;

			// How fast are we already moving in the input direction?
			var vel: Vec4 = rb.getLinearVelocity();
			var velInDir: Float = vel.x * dirX + vel.y * dirY;

			// Scale force down as we approach maxSpeed in that direction
			var factor: Float = Math.max(0.0, 1.0 - velInDir / maxSpeed);

			rb.applyForce(new Vec4(direction.x, direction.y, 0, 1).mult(speed * factor));
		}
	}

	function onGameEnded() {
		removeFixedUpdate(fixedUpdate);
	}
}