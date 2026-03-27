package arm.scenes;

import arm.autoload.GameEvents;
import armory.trait.internal.KouiCanvas;
import iron.system.Input;
import kha.System;
import koui.elements.Button;
using armory.trait.internal.KouiCanvas.ElementExt;

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
				playButton.onHover(function() {
					GameEvents.buttonSelected.emit();
				});
				playButton.onFocus(function() {
					GameEvents.buttonSelected.emit();
				});
				playButton.onPressed(function() {
					disableButtons();
					loadScene(firstLevel);
					GameEvents.gameStarted.emit();
				});

				infoButton = canvas.getElementFromSceneAs(Button, "MainMenu", "menu_buttons/info_button");
				infoButton.onHover(function() {
					GameEvents.buttonSelected.emit();
				});
				infoButton.onFocus(function() {
					GameEvents.buttonSelected.emit();
				});
				infoButton.onPressed(function() {
					canvas.setScene("Info");
					backButton.grabFocus();
					GameEvents.buttonPressed.emit();
				});

				quitButton = canvas.getElementFromSceneAs(Button, "MainMenu", "menu_buttons/quit_button");
				#if (kha_krom || hl)
				quitButton.onHover(function() {
					GameEvents.buttonSelected.emit();
				});
				quitButton.onFocus(function() {
					GameEvents.buttonSelected.emit();
				});
				quitButton.onPressed(function() {
					System.stop();
				});
				#else
				quitButton.visible = false;
				quitButton.disabled = true;

				playButton.focusUp = infoButton;
				infoButton.focusDown = playButton;
				#end

				backButton = canvas.getElementFromSceneAs(Button, "Info", "back_button");
				backButton.onHover(function() {
					GameEvents.buttonSelected.emit();
				});
				backButton.onFocus(function() {
					GameEvents.buttonSelected.emit();
				});
				backButton.onPressed(function() {
					canvas.setScene("MainMenu");
					infoButton.grabFocus();
					GameEvents.buttonPressed.emit();
				});

				playButton.grabFocus();

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
