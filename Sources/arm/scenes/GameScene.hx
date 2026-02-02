package arm.scenes;

import arm.autoloads.GameEvents;
import armory.system.Tween;
import iron.Scene;
import kha.Color;
import kha.graphics2.Graphics;

class GameScene extends iron.Trait {
	public var tween: Tween = new Tween();
	var bgColor: Color = Color.Black;

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
        fadeOut(function() {
            onTransitionFinished();
            GameEvents.sceneStarted.emit();
        });
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
        fadeIn(function() {
            Scene.setActive(scene);
        });
    }

    public function fadeIn(finishedCallback: Void->Void) {
        tween.float(0.0, 1.0, 0.5, function(value: Float) {
            bgColor = Color.fromFloats(0.0, 0.0, 0.0, value);
        }, function() {
            bgColor = Color.fromFloats(0.0, 0.0, 0.0, 1.0);
            finishedCallback();
        }).start();
    }

    public function fadeOut(finishedCallback: Void->Void) {
        tween.float(1.0, 0.0, 0.5, function(value: Float) {
            bgColor = Color.fromFloats(0.0, 0.0, 0.0, value);
        }, function() {
            bgColor = Color.fromFloats(0.0, 0.0, 0.0, 0.0);
            finishedCallback();
        }).start();
    }

    public function onTransitionFinished() {

    }
}