package arm.scenes;

import arm.autoload.GameEvents;
import armory.trait.internal.KouiCanvas;
import iron.Scene;
import iron.system.Input;
import koui.elements.Label;
import koui.elements.layouts.AnchorPane;
import koui.elements.layouts.RowLayout;
#if (kha_html5 || kha_debug_html5)
import kha.SystemImpl;
import kha.input.Surface;
#end

class Level extends GameScene {
	@prop var nextLevel: String;
	@prop var gemsGroup: String = "Gems";

	var totalScore: Int = 0;
	var score: Int = 0;

	var keyboard: Keyboard;
	var gamepad: Gamepad;

	var canvas: KouiCanvas;
	var scoreLabel: Label;
	var winContainer: RowLayout;
	var levelContainer: AnchorPane;

	#if (kha_html5 || kha_debug_html5)
	var buttonLabel: Label;
	#end

	public function new() {
		super();

		notifyOnInit(function() {
			totalScore = Scene.active.getGroup(gemsGroup).length;
			keyboard = Input.getKeyboard();
			gamepad = Input.getGamepad();
			canvas = object.getTrait(KouiCanvas);
			canvas.notifyOnReady(function() {
				scoreLabel = canvas.getElementAs(Label, "level_container/score_label");
				winContainer = canvas.getElementAs(RowLayout, "win_container");
				levelContainer = canvas.getElementAs(AnchorPane, "level_container");
				scoreLabel.text = "Score: " + score + Std.string("/" + totalScore);
				#if (kha_html5 || kha_debug_html5)
				if (SystemImpl.mobile) {
					buttonLabel = canvas.getElementAs(Label, "win_container/button_label");
					buttonLabel.text = "tap to continue";
				}
				#end
				init();
				GameEvents.gemCollected.connect(onGemCollected);
				GameEvents.playerDied.connect(onPlayerDied);
			});
		});

		notifyOnRemove(function() {
			GameEvents.gemCollected.disconnect(onGemCollected);
			GameEvents.playerDied.disconnect(onPlayerDied);
		});
	}

	function update() {
		// TODO: replace restarting with simple pause menu
		if (keyboard.down('r') || gamepad.started('x')) {
			removeUpdate(update);
			loadScene("MainMenu");
		}
	}

	function winUpdate() {
		if (keyboard.down('space') || gamepad.started('a')) {
			removeUpdate(winUpdate);
			loadScene(nextLevel);
			GameEvents.buttonPressed.emit();
		}
	}

	public override function onTransitionFinished() {
		#if (kha_html5 || kha_debug_html5)
		if (!SystemImpl.mobile) {
		#end
			notifyOnUpdate(update);
		#if (kha_html5 || kha_debug_html5)
		}
		#end
	}

	function onGemCollected() {
		score += 1;
		scoreLabel.text = "Score: " + score + Std.string("/" + totalScore);

		if (score >= totalScore) {
			levelContainer.visible = false;
			winContainer.visible = true;
			#if (kha_html5 || kha_debug_html5)
			if (SystemImpl.mobile) {
				Surface.get().notify(onTouchStart);
			} else {
			#end
				removeUpdate(update);
				notifyOnUpdate(winUpdate);
			#if (kha_html5 || kha_debug_html5)
			}
			#end
			GameEvents.levelWon.emit();
		}
	}

	function onPlayerDied() {
		#if (kha_html5 || kha_debug_html5)
		if (!SystemImpl.mobile) {
		#end
			removeUpdate(update);
		#if (kha_html5 || kha_debug_html5)
		}
		#end
		loadScene(Scene.active.raw.name);
	}

	#if (kha_html5 || kha_debug_html5)
	function onTouchStart(id:Int, x:Int, y:Int) {
		loadScene(nextLevel);
		GameEvents.buttonPressed.emit();
		Surface.get().remove(onTouchStart);
	}
	#end
}
