package arm.test;

import iron.object.Animation;
import iron.system.Input;

class PlayerAnim extends iron.Trait {
    var anim: Animation;
    var gamepad: Gamepad;

	public function new() {
		super();

		notifyOnInit(function() {
			#if arm_target_n64
			anim = object.animation;
			#else
			anim = object.getTraitFromChildren(Animation);
			#end
			anim.play("Idle");
            gamepad = Input.getGamepad();
		});

		notifyOnUpdate(function() {
			#if arm_target_n64
			if (gamepad.started("a")) anim.play("Run");
			else if (gamepad.started("b")) anim.play("Jump");
			else if (gamepad.started("x")) anim.play("Idle");
			#else
			if (gamepad.started("a")) anim.play("Run_player_world_map.blend");
			else if (gamepad.started("b")) anim.play("Jump_player_world_map.blend");
			else if (gamepad.started("x")) anim.play("Idle_player_world_map.blend");
			#end
			else if (gamepad.started("r2")) anim.pause();
			else if (gamepad.started("l2")) anim.resume();
		});
	}
}