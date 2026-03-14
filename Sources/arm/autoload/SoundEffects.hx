package arm.autoload;

import arm.autoload.GameEvents;
import aura.Aura;
import kha.Assets;
import kha.Sound;

@:n64Autoload
class SoundEffects {
    public static var volume(default, set): Float = 0.75;
    static var channels: Map<String, Array<BaseChannelHandle>> = new Map();

    static var gameStartSound: Sound;
    static var gameStartSoundHandle: BaseChannelHandle;

    static var looseSound: Sound;
    static var looseSoundHandle: BaseChannelHandle;

    static var winSound: Sound;
    static var winSoundHandle: BaseChannelHandle;

    static var buttonPressSound: Sound;
    static var buttonPressSoundHandle: BaseChannelHandle;

    static var buttonSelectSound: Sound;
    static var buttonSelectSoundHandle: BaseChannelHandle;

    static function set_volume(value: Float): Float {
        Aura.mixChannels["fx"].setVolume(value);
        return volume = value;
    }

    public static function init() {
        Aura.mixChannels["fx"].setVolume(volume);

        setChannels("gem_collect", Assets.sounds.collect_coin);

        gameStartSound = Assets.sounds.game_start;
        gameStartSoundHandle = Aura.createCompBufferChannel(gameStartSound, false, Aura.mixChannels["fx"]);

        looseSound = Assets.sounds.loose;
        looseSoundHandle = Aura.createCompBufferChannel(looseSound, false, Aura.mixChannels["fx"]);

        winSound = Assets.sounds.win;
        winSoundHandle = Aura.createCompBufferChannel(winSound, false, Aura.mixChannels["fx"]);

        buttonPressSound = Assets.sounds.button_pressed;
        buttonPressSoundHandle = Aura.createCompBufferChannel(buttonPressSound, false, Aura.mixChannels["fx"]);

        setChannels("button_select", Assets.sounds.button_select);

        GameEvents.gameStarted.connect(function () {
            gameStartSoundHandle.play();
        });

        GameEvents.gemCollected.connect(function () {
            playChannel("gem_collect");
        });

        GameEvents.levelWon.connect(function () {
            winSoundHandle.play();
        });

        GameEvents.playerDied.connect(function () {
            looseSoundHandle.play();
        });

        GameEvents.buttonPressed.connect(function () {
            buttonPressSoundHandle.play();
        });

        GameEvents.buttonSelected.connect(function () {
            playChannel("button_select");
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