package arm.scenes;

import arm.autoload.GameEvents;
import armory.trait.internal.KouiCanvas;
import iron.system.Input;
import kha.System;
import koui.elements.Button;
using armory.trait.internal.KouiCanvas.ButtonExt;

class MainMenu extends GameScene {
	@prop var firstLevel: String = "Level01";

	var keyboard: Keyboard;
	var gamepad: Gamepad;
	var canvas: KouiCanvas;

	var playButton: Button;
	var infoButton: Button;
	var quitButton: Button;
	var backButton: Button;

	public function new() {
		super();

		notifyOnInit(function() {
			keyboard = Input.getKeyboard();
			gamepad = Input.getGamepad();
			canvas = object.getTrait(KouiCanvas);
			canvas.notifyOnReady(function() {
				playButton = canvas.getElementFromSceneAs(Button, "MainMenu", "menu_buttons/play_button");
				infoButton = canvas.getElementFromSceneAs(Button, "MainMenu", "menu_buttons/info_button");
				quitButton = canvas.getElementFromSceneAs(Button, "MainMenu", "menu_buttons/quit_button");
				backButton = canvas.getElementFromSceneAs(Button, "Info", "back_button");

				playButton.onHover(function() {
					GameEvents.buttonSelected.emit();
				});
				infoButton.onHover(function() {
					GameEvents.buttonSelected.emit();
				});
				quitButton.onHover(function() {
					GameEvents.buttonSelected.emit();
				});
				backButton.onHover(function() {
					GameEvents.buttonSelected.emit();
				});

				playButton.onFocus(function() {
					GameEvents.buttonSelected.emit();
				});
				infoButton.onFocus(function() {
					GameEvents.buttonSelected.emit();
				});
				quitButton.onFocus(function() {
					GameEvents.buttonSelected.emit();
				});
				backButton.onFocus(function() {
					GameEvents.buttonSelected.emit();
				});

				playButton.onPressed(function() {
					disableButtons();
					loadScene(firstLevel);
					GameEvents.gameStarted.emit();
				});
				infoButton.onPressed(function() {
					canvas.setScene("Info");
					GameEvents.buttonPressed.emit();
				});
				quitButton.onPressed(function() {
					System.stop();
				});
				backButton.onPressed(function() {
					canvas.setScene("MainMenu");
					GameEvents.buttonPressed.emit();
				});

				init();
			});
		});
	}

	function disableButtons() {
		playButton.disabled = true;
		infoButton.disabled = true;
		quitButton.disabled = true;
	}
}
