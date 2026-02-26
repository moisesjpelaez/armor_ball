package arm.scenes;

import arm.autoload.GameEvents;
import armory.trait.internal.KouiCanvas;
import iron.system.Input;
#if (kha_html5 || kha_debug_html5)
import kha.SystemImpl;
import kha.input.Surface;
import koui.elements.Label;
#end

class MainMenu extends GameScene {
	@prop var firstLevel: String = "Level01";
	var keyboard: Keyboard;
	var gamepad: Gamepad;
	var canvas: KouiCanvas;
	#if (kha_html5 || kha_debug_html5)
	var playLabel: Label;
	#end

	public function new() {
		super();

		notifyOnInit(function() {
			keyboard = Input.getKeyboard();
			gamepad = Input.getGamepad();
			canvas = object.getTrait(KouiCanvas);
			canvas.notifyOnReady(function() {
				#if (kha_html5 || kha_debug_html5)
				if (SystemImpl.mobile) {
					playLabel = canvas.getElementAs(Label, "play_label");
					playLabel.text = "tap to play";
				}
				#end
				init();
			});
		});
	}

	function update() {
		if (keyboard.down('enter') || gamepad.started('options')) {
			removeUpdate(update);
			loadScene(firstLevel);
			GameEvents.gameStarted.emit();
		}
	}

	public override function onTransitionFinished() {
		#if (kha_html5 || kha_debug_html5)
		if (SystemImpl.mobile) {
			Surface.get().notify(onTouchStart);
		} else {
		#end
			notifyOnUpdate(update);
		#if (kha_html5 || kha_debug_html5)
		}
		#end
	}

	#if (kha_html5 || kha_debug_html5)
	function onTouchStart(id:Int, x:Int, y:Int) {
		loadScene(firstLevel);
		GameEvents.gameStarted.emit();
		Surface.get().remove(onTouchStart);
	}
	#end
}
