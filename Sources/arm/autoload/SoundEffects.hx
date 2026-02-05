package arm.autoload;

import arm.autoload.GameEvents;
import armory.system.Tween;
import aura.Aura;
import kha.Assets;
import kha.Sound;

@:n64Autoload
class SoundEffects {
    public static var volume(default, set): Float = 1.0;
    static var channels: Map<String, Array<BaseChannelHandle>> = new Map();

    static var winSound: Sound;
    static var winSoundHandle: BaseChannelHandle;

    static function set_volume(value: Float): Float {
        Aura.mixChannels["fx"].setVolume(value);
        return volume = value;
    }

    public static function init() {
        Aura.mixChannels["fx"].setVolume(volume);

        setChannels("gem_collect", Assets.sounds.collect_coin);
        winSound = Assets.sounds.win;
        winSoundHandle = Aura.createCompBufferChannel(winSound, false, Aura.mixChannels["fx"]);

        GameEvents.gemCollected.connect(function () {
            playChannel("gem_collect");
        });

        GameEvents.levelWon.connect(function () {
            winSoundHandle.play();
        });
    }

    static function setChannels(key: String, sound: Sound, ?channelsCount: Int = 4) {
        var handles: Array<BaseChannelHandle> = [];
        for (i in 0...channelsCount) {
            handles.push(Aura.createCompBufferChannel(sound, false, Aura.mixChannels["fx"]));
        }
        channels.set(key, handles);
    }

    static function playChannel(key: String) {
        for (i in 0...channels[key].length) {
            var channel: BaseChannelHandle = channels[key][i];
            if (channel.finished) {
                channel.play();
                break;
            }
        }
    }
}