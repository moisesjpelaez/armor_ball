package arm;

import armory.trait.internal.KouiCanvas;
import iron.Scene;
import iron.system.Input;
import koui.elements.Label;

class TestLevel extends iron.Trait {
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
				notifyOnUpdate(update);
				GameEvents.sceneLoaded.emit(Scene.active.raw.name);
			});
		});
	}

	function update() {
		if (gamepad.started('x')) {
			Scene.setActive(nextLevel);
		}

		if (gamepad.started('a')) {
			score += 1;
			scoreLabel.text = "Score: " + score;
		}
	}
}
