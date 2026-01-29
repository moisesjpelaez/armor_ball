package arm;

import aura.Aura;
import kha.Assets;
import kha.Sound;

@:n64Autoload
class Music {
    public static final inst: Music = new Music();
    public var volume(default, set): Float = 0.5;

    var menuMusic: Sound;
    var menuMusicHandle: BaseChannelHandle;
    var currentHandle: BaseChannelHandle;

    public function new() {

    }

    function set_volume(value: Float): Float {
        Aura.mixChannels["music"].setVolume(value);
        return this.volume = value;
    }

    public function init() {
        Aura.mixChannels["music"].setVolume(volume);

        inst.menuMusic = Assets.sounds.wind_chimes_loop_1;
        inst.menuMusicHandle = Aura.createCompBufferChannel(inst.menuMusic, true, Aura.mixChannels["music"]);

        GameEvents.sceneLoaded.connect(onSceneLoaded);
    }

    function play(handle: BaseChannelHandle) {
        if (handle == currentHandle) return;
        currentHandle = handle;

        if (handle.finished) {
            handle.setVolume(volume);
            handle.play();
        }
    }

    function onSceneLoaded(sceneName: String) {
        play(menuMusicHandle);
    }
}