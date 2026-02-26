package arm.player;

import arm.autoload.GameEvents;
import arm.autoload.MainInstances;
import armory.trait.physics.PhysicsWorld;
import armory.trait.physics.RigidBody;
import iron.math.Vec2;
import iron.math.Vec4;
import iron.system.Input;
#if (kha_html5 || kha_debug_html5)
import kha.SystemImpl;
#end

class Player extends iron.Trait {
	@prop var speed: Float = 8.0;
	@prop var maxSpeed: Float = 8.0;

	var physics: PhysicsWorld;
	var rb: RigidBody;
	var keyboard: Keyboard;
	var gamepad: Gamepad;
	#if (kha_html5 || kha_debug_html5)
	var sensor: Sensor;
	#end

	public function new() {
		super();

		notifyOnAdd(function() {
			MainInstances.player = this;
		});

		notifyOnInit(function() {
			physics = PhysicsWorld.active;
			rb = object.getTrait(RigidBody);
			#if (kha_html5 || kha_debug_html5)
			if (SystemImpl.mobile) {
				sensor = new Sensor();
			} else {
			#end
				keyboard = Input.getKeyboard();
				gamepad = Input.getGamepad();
			#if (kha_html5 || kha_debug_html5)
			}
			#end
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
		#if (kha_html5 || kha_debug_html5)
		if (SystemImpl.mobile) {
			if (sensor == null) return;
		} else {
		#end
			if (gamepad == null) return;
		#if (kha_html5 || kha_debug_html5)
		}
		#end

		var direction: Vec2 = new Vec2();
		#if (kha_html5 || kha_debug_html5)
		if (SystemImpl.mobile) {
			direction = new Vec2(sensor.y * 0.25, -sensor.x * 0.25);
		} else {
		#end
			direction = new Vec2(gamepad.leftStick.x, gamepad.leftStick.y);
			if (keyboard.down('w') || keyboard.down('up')) direction.y += 1;
			if (keyboard.down('s') || keyboard.down('down')) direction.y -= 1;
			if (keyboard.down('a') || keyboard.down('left')) direction.x -= 1;
			if (keyboard.down('d') || keyboard.down('right')) direction.x += 1;
		#if (kha_html5 || kha_debug_html5)
		}
		#end
		var inputLen: Float = direction.length();

		if (inputLen > 0.1) {
			var dirX: Float = direction.x / inputLen;
			var dirY: Float = direction.y / inputLen;

			var vel: Vec4 = rb.getLinearVelocity();
			var velInDir: Float = vel.x * dirX + vel.y * dirY;

			var factor: Float = Math.max(0.0, 1.0 - velInDir / maxSpeed);

			rb.applyForce(new Vec4(direction.x, direction.y, 0, 1).mult(speed * factor));
		}
	}

	function onGameEnded() {
		removeFixedUpdate(fixedUpdate);
	}
}