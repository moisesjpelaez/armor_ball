package arm.scenes;

import arm.autoload.GameEvents;
import armory.trait.internal.KouiCanvas;
import iron.App;
import iron.Scene;
import iron.system.Input;
import koui.elements.Button;
import koui.elements.Label;
import koui.utils.SceneManager;
#if (kha_html5 || kha_debug_html5)
import kha.SystemImpl;
#end
using armory.trait.internal.KouiCanvas.ElementExt;

class Level extends GameScene {
	@prop var nextLevel: String;
	var gemsGroup: String = "Gems";

	var totalScore: Int = 0;
	var score: Int = 0;

	var keyboard: Keyboard;
	var gamepad: Gamepad;

	@:isVar var paused(default, set): Bool = false;
	var canvas: KouiCanvas;
	// InGame
	var igScoreLabel: Label;
	#if (kha_html5 || kha_debug_html5)
	var igPauseButton: Button;
	#end
	// Pause
	var pResumeButton: Button;
	var pRestartButton: Button;
	var pMenuButton: Button;
	// Win
	var wMenuButton: Button;
	var wContinueButton: Button;

	public function new() {
		super();

		notifyOnInit(function() {
			totalScore = Scene.active.getGroup(gemsGroup).length;
			keyboard = Input.getKeyboard();
			gamepad = Input.getGamepad();
			canvas = object.getTrait(KouiCanvas);
			canvas.notifyOnReady(function() {
				// InGame
				igScoreLabel = canvas.getElementFromSceneAs(Label, "InGame", "score_label");
				igScoreLabel.text = "Score: " + score + Std.string("/" + totalScore);
				#if (kha_html5 || kha_debug_html5)
				if (SystemImpl.mobile) {
					igPauseButton = canvas.getElementFromSceneAs(Button, "InGame", "pause_button");
					igPauseButton.visible = true;
					igPauseButton.disabled = false;
					igPauseButton.onPressed(function() {
						this.paused = true;
					});
				}
				#end

				// Pause
				pResumeButton = canvas.getElementFromSceneAs(Button, "Paused", "buttons/resume_button");
				pResumeButton.onHover(function() {
					GameEvents.buttonSelected.emit();
				});
				pResumeButton.onFocus(function() {
					GameEvents.buttonSelected.emit();
				});
				pResumeButton.onPressed(function() {
					this.paused = false;
					canvas.setScene("InGame");
					GameEvents.buttonPressed.emit();
				});

				pRestartButton = canvas.getElementFromSceneAs(Button, "Paused", "buttons/restart_button");
				pRestartButton.onHover(function() {
					GameEvents.buttonSelected.emit();
				});
				pRestartButton.onFocus(function() {
					GameEvents.buttonSelected.emit();
				});
				pRestartButton.onPressed(function() {
					this.paused = false;
					loadScene(Scene.active.raw.name);
					GameEvents.buttonPressed.emit();
					SceneManager.clearScenes();
				});

				pMenuButton = canvas.getElementFromSceneAs(Button, "Paused", "buttons/menu_button");
				pMenuButton.onHover(function() {
					GameEvents.buttonSelected.emit();
				});
				pMenuButton.onFocus(function() {
					GameEvents.buttonSelected.emit();
				});
				pMenuButton.onPressed(function() {
					this.paused = false;
					loadScene("MainMenu");
					GameEvents.buttonPressed.emit();
					SceneManager.clearScenes();
				});

				// Win
				wMenuButton = canvas.getElementFromSceneAs(Button, "Win", "buttons/menu_button");
				wMenuButton.onHover(function() {
					GameEvents.buttonSelected.emit();
				});
				wMenuButton.onFocus(function() {
					GameEvents.buttonSelected.emit();
				});
				wMenuButton.onPressed(function() {
					loadScene("MainMenu");
					GameEvents.buttonPressed.emit();
					SceneManager.clearScenes();
				});

				wContinueButton = canvas.getElementFromSceneAs(Button, "Win", "buttons/continue_button");
				wContinueButton.onHover(function() {
					GameEvents.buttonSelected.emit();
				});
				wContinueButton.onFocus(function() {
					GameEvents.buttonSelected.emit();
				});
				wContinueButton.onPressed(function() {
					loadScene(nextLevel);
					GameEvents.buttonPressed.emit();
					SceneManager.clearScenes();
				});

				init();

				GameEvents.gemCollected.connect(onGemCollected);
				GameEvents.playerDied.connect(onPlayerDied);
			});
		});

		notifyOnRemove(function() {
			GameEvents.gemCollected.disconnect(onGemCollected);
			GameEvents.playerDied.disconnect(onPlayerDied);
		});
	}

	function set_paused(value: Bool): Bool {
		App.pauseUpdates = value;
		if (value != this.paused) {
			GameEvents.gamePaused.emit(value);
			if (value) {
				canvas.setScene("Paused");
				pResumeButton.grabFocus();
			} else {
				canvas.setScene("InGame");
			}
		}
		return this.paused = value;
	}

	function update() {
		if (keyboard.down('escape') || gamepad.started('options')) {
			this.paused = true;
		}
	}

	function cleanUpdate() {
		#if (kha_html5 || kha_debug_html5)
		if (!SystemImpl.mobile) {
		#end
			removeUpdate(update);
		#if (kha_html5 || kha_debug_html5)
		}
		#end
	}

	public override function onTransitionFinished() {
		#if (kha_html5 || kha_debug_html5)
		if (!SystemImpl.mobile) {
		#end
			notifyOnUpdate(update);
		#if (kha_html5 || kha_debug_html5)
		}
		#end
	}

	function onGemCollected() {
		score += 1;
		igScoreLabel.text = "Score: " + score + Std.string("/" + totalScore);

		if (score >= totalScore) {
			cleanUpdate();
			canvas.setScene("Win");
			wContinueButton.grabFocus();
			GameEvents.levelWon.emit();
		}
	}

	function onPlayerDied() {
		cleanUpdate();
		loadScene(Scene.active.raw.name);
		SceneManager.clearScenes();
	}
}
