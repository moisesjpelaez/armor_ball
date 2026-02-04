package arm.scenes;

import arm.autoloads.GameEvents;
import armory.trait.internal.KouiCanvas;
import iron.Scene;
import iron.system.Input;
import koui.elements.Label;
import koui.elements.layouts.AnchorPane;
import koui.elements.layouts.RowLayout;

class Level extends GameScene {
	@prop var nextLevel: String;
	@prop var gemsGroup: String = "Gems";

	var totalScore: Int = 0;
	var score: Int = 0;

	var gamepad: Gamepad;

	var canvas: KouiCanvas;
	var scoreLabel: Label;
	var winContainer: RowLayout;
	var levelContainer: AnchorPane;

	public function new() {
		super();

		notifyOnAdd(function() {
			Gamepad.buttons = Gamepad.buttonsXBOX;
		});

		notifyOnInit(function() {
			totalScore = Scene.active.getGroup(gemsGroup).length;
			gamepad = Input.getGamepad();
			canvas = object.getTrait(KouiCanvas);
			canvas.notifyOnReady(function() {
				scoreLabel = canvas.getElementAs(Label, "level_container/score_label");
				winContainer = canvas.getElementAs(RowLayout, "win_container");
				levelContainer = canvas.getElementAs(AnchorPane, "level_container");
				scoreLabel.text = "Score: " + score + Std.string("/" + totalScore);
				init();
				GameEvents.gemCollected.connect(onGemCollected);
			});
		});

		notifyOnRemove(function() {
			GameEvents.gemCollected.disconnect(onGemCollected);
		});
	}

	function update() {
		if (gamepad.started('b')) {
			removeUpdate(update);
			loadScene(Scene.active.raw.name);
		}
	}

	function winUpdate() {
		if (gamepad.started('a')) {
			removeUpdate(winUpdate);
			loadScene(nextLevel);
		}
	}

	public override function onTransitionFinished() {
		notifyOnUpdate(update);
	}

	function onGemCollected() {
		score += 1;
		scoreLabel.text = "Score: " + score + Std.string("/" + totalScore);

		if (score >= totalScore) {
			removeUpdate(update);
			levelContainer.visible = false;
			winContainer.visible = true;
			notifyOnUpdate(winUpdate);
		}
	}
}
