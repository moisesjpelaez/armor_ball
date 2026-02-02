package arm.scenes;

import armory.trait.internal.KouiCanvas;
import koui.elements.Element;

class Splash extends GameScene {
	@prop var nextScene: String = "Test1";

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
		fadeIn(function() {
			elements[currentLogoIndex].visible = false;
			currentLogoIndex += 1;

			if (currentLogoIndex >= elements.length) {
				loadScene(nextScene);
			} else {
				elements[currentLogoIndex].visible = true;
				fadeOut(function() {
					tween.delay(2.0, function() {
						nextLogo();
					}).start();
				});
			}
		});
	}

	public override function onTransitionFinished() {
		tween.delay(2.0, function() {
			nextLogo();
		}).start();
	}
}
