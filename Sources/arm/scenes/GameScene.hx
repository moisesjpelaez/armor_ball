package arm.scenes;

import arm.autoloads.GameEvents;
import armory.system.Tween;
import iron.Scene;
import kha.Color;
import kha.graphics2.Graphics;

class GameScene extends iron.Trait {
	var tween: Tween = new Tween();

	var bgColor: Color = Color.Black;
	var bgAlpha: Float = 1.0;

    public function new() {
        super();

        notifyOnInit(function () {
            notifyOnRender2D(render2D);
            GameEvents.sceneLoaded.emit(Scene.active.raw.name);
        });

        notifyOnRemove(function () {
            GameEvents.sceneUnloaded.emit();
        });
    }

    function init() {
		tween.float(bgAlpha, 0.0, 0.5, function(value: Float) {
			bgAlpha = value;
			bgColor = Color.fromFloats(0.0, 0.0, 0.0, value);
		}, function() {
			bgAlpha = 0.0;
			bgColor = Color.fromFloats(0.0, 0.0, 0.0, 0);
			onTransitionFinished();
			GameEvents.sceneStarted.emit();
		}).start();
	}

    function render2D(g2: Graphics) {
		g2.end();
		g2.imageScaleQuality = armory.ui.Canvas.imageScaleQuality;
		g2.color = bgColor;
		g2.fillRect(0, 0, kha.Window.get(0).width, kha.Window.get(0).height);
		g2.begin(false);
	}

    public function loadScene(scene: String) {
        GameEvents.sceneChangeStarted.emit(scene);
        tween.float(bgAlpha, 1.0, 0.5, function(value: Float) {
            bgAlpha = value;
            bgColor = Color.fromFloats(0.0, 0.0, 0.0, value);
        }, function() {
            removeRender2D(render2D);
            Scene.setActive(scene);
        }).start();
    }

    public function onTransitionFinished() {

    }
}