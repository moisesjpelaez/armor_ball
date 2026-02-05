package arm.autoload;

import arm.autoload.GameEvents;
import armory.system.Tween;
import aura.Aura;
import kha.Assets;
import kha.Sound;

@:n64Autoload
class SoundEffects {
    public static var volume(default, set): Float = 1.0;

    static var coinSound: Sound;
    static var coinSoundHandle: BaseChannelHandle;
    static var winSound: Sound;
    static var winSoundHandle: BaseChannelHandle;

    static function set_volume(value: Float): Float {
        Aura.mixChannels["fx"].setVolume(value);
        return volume = value;
    }

    public static function init() {
        Aura.mixChannels["fx"].setVolume(volume);

        coinSound = Assets.sounds.collect_coin;
        coinSoundHandle = Aura.createCompBufferChannel(coinSound, false, Aura.mixChannels["fx"]);
        coinSoundHandle.setVolume(volume);

        winSound = Assets.sounds.win;
        winSoundHandle = Aura.createCompBufferChannel(winSound, false, Aura.mixChannels["fx"]);
        winSoundHandle.setVolume(volume);

        GameEvents.gemCollected.connect(function () {
            coinSoundHandle.play();
        });

        GameEvents.levelWon.connect(function () {
            winSoundHandle.play();
        });
    }
}