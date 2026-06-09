package arm.scenes;

import arm.autoload.GameEvents;
import armory.system.Tween;
import iron.Scene;
import kha.Color;
import kha.graphics2.Graphics;

// Base class for smooth scene transitions and initialization. All scenes should extend this class.
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

    // Fades in the scene, then calls the onTransitionFinished callback when done.
    // Can be called manually to trigger the fade-in effect at any time. Best being called after the scene's canvas is ready.
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

    // Callback for when the fade-out transition finishes and the new scene is loaded. Can be overridden by subclasses to perform actions at that moment, such as starting music or playing a cutscene.
    public function onTransitionFinished() {

    }
}