package arm;

import armory.system.Tween;
import aura.Aura;
import kha.Assets;
import kha.Sound;

@:n64Autoload
class Music {
    public static var volume(default, set): Float = 0.5;

    static var menuMusic: Sound;
    static var menuMusicHandle: BaseChannelHandle;
    static var levelMusic: Sound;
    static var levelMusicHandle: BaseChannelHandle;
    static var currentHandle: BaseChannelHandle;

    static var tween: Tween = new Tween();

    static function set_volume(value: Float): Float {
        Aura.mixChannels["music"].setVolume(value);
        return volume = value;
    }

    public static function init() {
        Aura.mixChannels["music"].setVolume(volume);

        menuMusic = Assets.sounds.heavy_heist;
        menuMusicHandle = Aura.createCompBufferChannel(menuMusic, true, Aura.mixChannels["music"]);

        levelMusic = Assets.sounds.i_do_know;
        levelMusicHandle = Aura.createCompBufferChannel(levelMusic, true, Aura.mixChannels["music"]);

        GameEvents.sceneLoaded.connect(onSceneLoaded);
        GameEvents.sceneChangeStarted.connect(onSceneChangeStarted);
    }

    static function play(handle: BaseChannelHandle) {
        if (handle == currentHandle) return;
        currentHandle = handle;

        if (handle.finished) {
            handle.setVolume(volume);
            handle.play();
        }
    }

    static function stop(handle: BaseChannelHandle) {
        tween.float(volume, 0.0, 0.25, onTweenUpdate, onTweenDone);
        tween.start();
    }

    static function onSceneLoaded(sceneName: String) {
        if (sceneName == "Test1") {
            play(menuMusicHandle);
        } else if (sceneName == "Test2") {
            play(levelMusicHandle);
        }
    }

    static function onSceneChangeStarted() {
        stop(currentHandle);
    }

    static function onTweenUpdate(v: Float) {
        currentHandle.setVolume(v);
    }

    static function onTweenDone() {
        if (currentHandle != null) {
            currentHandle.stop();
            currentHandle = null;
        }
    }
}