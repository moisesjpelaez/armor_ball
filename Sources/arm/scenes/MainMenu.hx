package arm.scenes;

import arm.autoload.GameEvents;
import armory.trait.internal.KouiCanvas;
import iron.system.Input;

class MainMenu extends GameScene {
	@prop var firstLevel: String = "Level01";
	var gamepad: Gamepad;
	var canvas: KouiCanvas;

	public function new() {
		super();

		notifyOnAdd(function() {
			Gamepad.buttons = Gamepad.buttonsXBOX;
		});

		notifyOnInit(function() {
			gamepad = Input.getGamepad();
			canvas = object.getTrait(KouiCanvas);
			canvas.notifyOnReady(function() {
				init();
			});
		});
	}

	function update() {
		if (gamepad.started('options')) {
			removeUpdate(update);
			loadScene(firstLevel);
		}
	}

	public override function onTransitionFinished() {
		notifyOnUpdate(update);
	}
}
