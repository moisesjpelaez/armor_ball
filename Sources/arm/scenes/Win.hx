package arm.scenes;

import arm.autoload.GameEvents;
import armory.trait.internal.KouiCanvas;
import iron.system.Input;
import koui.elements.Button;
using armory.trait.internal.KouiCanvas.ElementExt;

class Win extends GameScene {
	@prop var mainMenu: String = "MainMenu";
	var keyboard: Keyboard;
	var gamepad: Gamepad;
	var canvas: KouiCanvas;
	var menuButton: Button;

	public function new() {
		super();

		notifyOnInit(function() {
			keyboard = Input.getKeyboard();
			gamepad = Input.getGamepad();
			canvas = object.getTrait(KouiCanvas);
			canvas.notifyOnReady(function() {
				menuButton = canvas.getElementAs(Button, "menu_button");
				menuButton.onHover(function() {
					GameEvents.buttonSelected.emit();
				});
				menuButton.onFocus(function() {
					GameEvents.buttonSelected.emit();
				});
				menuButton.onPressed(function() {
					loadScene(mainMenu);
					menuButton.disabled = true;
					GameEvents.buttonPressed.emit();
				});
				menuButton.grabFocus();

				init();
			});
		});
	}
}
