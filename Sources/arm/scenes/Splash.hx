package arm.scenes;

import armory.trait.internal.KouiCanvas;
import koui.elements.Element;
#if arm_target_n64
import koui.elements.layouts.AnchorPane;
import koui.elements.layouts.ColLayout;
#end

class Splash extends GameScene {
	@prop var nextScene: String = "MainMenu";

	var canvas: KouiCanvas;
	var elements: Array<Element>;
	#if arm_target_n64
	var nonConsoleContainer: ColLayout;
	var consoleContainer: AnchorPane;
	#end

	var currentLogoIndex: Int = 0;

	public function new() {
		super();

		notifyOnInit(function() {
			canvas = object.getTrait(KouiCanvas);
			canvas.notifyOnReady(function() {
				elements = @:privateAccess canvas.getRoot().elements;
				#if arm_target_n64
				nonConsoleContainer = canvas.getElementAs(ColLayout, "frameworks/non_console");
				consoleContainer = canvas.getElementAs(AnchorPane, "frameworks/console");
				nonConsoleContainer.visible = false;
				consoleContainer.visible = true;
				#end
				init();
			});
		});
	}

	function nextLogo() {
		currentLogoIndex += 1;
		#if arm_target_n64
		if (currentLogoIndex < elements.length) {
		#else
		if (currentLogoIndex < elements.length - 2) {
		#end
			fadeIn(function() {
				elements[currentLogoIndex - 1].visible = false;
				elements[currentLogoIndex].visible = true;
				fadeOut(function() {
					// FIXME: `Tween.delay` can only accept anonymous functions for n64 exports, investigate the root causes.
					tween.delay(2.0, function() {
						nextLogo();
					}).start();
				});
			});
		} else loadScene(nextScene);
	}

	public override function onTransitionFinished() {
		// FIXME: `Tween.delay` can only accept anonymous functions for n64 exports, investigate the root causes.
		tween.delay(2.0, function() {
			nextLogo();
		}).start();
	}
}
