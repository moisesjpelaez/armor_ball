package arm.scenes;

import armory.trait.internal.KouiCanvas;
import koui.elements.Element;

class Splash extends GameScene {
	@prop var nextScene: String = "MainMenu";

	var canvas: KouiCanvas;
	var elements: Array<Element>;

	var currentLogoIndex: Int = 0;

	public function new() {
		super();

		notifyOnInit(function() {
			canvas = object.getTrait(KouiCanvas);
			canvas.notifyOnReady(function() {
				elements = @:privateAccess canvas.getRoot().elements;
				init();
			});
		});
	}

	function nextLogo() {
		currentLogoIndex += 1;
		if (currentLogoIndex < elements.length) {
			fadeIn(function() {
				elements[currentLogoIndex - 1].visible = false;
				elements[currentLogoIndex].visible = true;
				fadeOut(function() {
					tween.delay(2.0, function() {
						nextLogo();
					}).start();
				});
			});
		} else loadScene(nextScene);
	}

	public override function onTransitionFinished() {
		tween.delay(2.0, function() {
			nextLogo();
		}).start();
	}
}
