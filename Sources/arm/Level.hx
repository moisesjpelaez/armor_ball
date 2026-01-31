package arm;

import armory.trait.internal.KouiCanvas;
import iron.system.Input;
import koui.elements.Label;

class Level extends GameScene {
	@prop var nextLevel: String;
	var score: Int = 0;

	var gamepad: Gamepad;

	var canvas: KouiCanvas;
	var scoreLabel: Label;

	public function new() {
		super();

		notifyOnAdd(function() {
			Gamepad.buttons = Gamepad.buttonsXBOX;
		});

		notifyOnInit(function() {
			gamepad = Input.getGamepad();
			canvas = object.getTrait(KouiCanvas);
			canvas.notifyOnReady(function() {
				scoreLabel = canvas.getElementAs(Label, "score_label");
				init();
			});
		});
	}

	function update() {
		if (gamepad.started('x')) {
			removeUpdate(update);
			loadScene(nextLevel);
		}

		if (gamepad.started('a')) {
			score += 1;
			scoreLabel.text = "Score: " + score;
		}
	}

	public override function onTransitionFinished() {
		notifyOnUpdate(update);
	}
}
