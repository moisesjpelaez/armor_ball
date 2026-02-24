package arm.scenes;

import arm.autoload.GameEvents;
import armory.trait.internal.KouiCanvas;
import iron.system.Input;

class Win extends GameScene {
	@prop var mainMenu: String = "MainMenu";
	var gamepad: Gamepad;
	var canvas: KouiCanvas;

	public function new() {
		super();

		notifyOnInit(function() {
			gamepad = Input.getGamepad();
			canvas = object.getTrait(KouiCanvas);
			canvas.notifyOnReady(function() {
				init();
			});
		});
	}

	function update() {
		if (gamepad.started('a')) {
			removeUpdate(update);
			loadScene(mainMenu);
			GameEvents.buttonPressed.emit();
		}
	}

	public override function onTransitionFinished() {
		notifyOnUpdate(update);
	}
}
