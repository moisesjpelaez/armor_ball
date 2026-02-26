package arm.scenes;

import arm.autoload.GameEvents;
import armory.trait.internal.KouiCanvas;
import iron.system.Input;
#if (kha_html5 || kha_debug_html5)
import kha.SystemImpl;
import kha.input.Surface;
import koui.elements.Label;
#end

class Win extends GameScene {
	@prop var mainMenu: String = "MainMenu";
	var keyboard: Keyboard;
	var gamepad: Gamepad;
	var canvas: KouiCanvas;
	#if (kha_html5 || kha_debug_html5)
	var buttonLabel: Label;
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
					buttonLabel = canvas.getElementAs(Label, "button_label");
					buttonLabel.text = "tap for main menu";
				}
				#end
				init();
			});
		});
	}

	function update() {
		if (keyboard.down('space') || gamepad.started('a')) {
			removeUpdate(update);
			loadScene(mainMenu);
			GameEvents.buttonPressed.emit();
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
		loadScene(mainMenu);
		GameEvents.buttonPressed.emit();
		Surface.get().remove(onTouchStart);
	}
	#end
}
