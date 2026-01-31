package arm;

import armory.system.Tween;
import armory.trait.internal.KouiCanvas;
import iron.Scene;
import iron.system.Input;
import kha.Color;
import kha.graphics2.Graphics;
import koui.elements.Label;

class TestLevel extends iron.Trait {
	@prop var nextLevel: String;
	var score: Int = 0;

	var gamepad: Gamepad;

	var canvas: KouiCanvas;
	var scoreLabel: Label;

	var tween: Tween = new Tween();

	var bgColor: Color = Color.Black;
	var bgAlpha: Float = 1.0;

	public function new() {
		super();

		notifyOnAdd(function() {
			Gamepad.buttons = Gamepad.buttonsXBOX;
		});

		notifyOnInit(function() {
			notifyOnRender2D(render2D);
			gamepad = Input.getGamepad();
			canvas = object.getTrait(KouiCanvas);
			canvas.notifyOnReady(function() {
				scoreLabel = canvas.getElementAs(Label, "score_label");
				init();
			});
		});
	}

	function init() {
		tween.float(bgAlpha, 0.0, 0.5, function(value: Float) {
			bgAlpha = value;
			bgColor = Color.fromFloats(0.0, 0.0, 0.0, value);
		}, function() {
			bgAlpha = 0.0;
			bgColor = Color.fromFloats(0.0, 0.0, 0.0, 0);
			notifyOnUpdate(update);
			GameEvents.sceneLoaded.emit(Scene.active.raw.name);
		}).start();
	}

	function render2D(g2: Graphics) {
		g2.end();
		g2.imageScaleQuality = armory.ui.Canvas.imageScaleQuality;
		g2.color = bgColor;
		g2.fillRect(0, 0, kha.Window.get(0).width, kha.Window.get(0).height);
		g2.begin(false);
	}

	function update() {
		if (gamepad.started('x')) {
			removeUpdate(update);
			GameEvents.sceneChangeStarted.emit();
			tween.float(bgAlpha, 1.0, 0.5, function(value: Float) {
				bgAlpha = value;
				bgColor = Color.fromFloats(0.0, 0.0, 0.0, value);
			}, function() {
				removeRender2D(render2D);
				Scene.setActive(nextLevel);
			}).start();
		}

		if (gamepad.started('a')) {
			score += 1;
			scoreLabel.text = "Score: " + score;
		}
	}
}
