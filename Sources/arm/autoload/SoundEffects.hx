package arm.autoload;

import arm.autoload.GameEvents;
import aura.Aura;
import kha.Assets;
import kha.Sound;
#if (kha_html5 || kha_debug_html5)
import kha.SystemImpl;
#end

@:n64Autoload
class SoundEffects {
    public static var volume(default, set): Float = 0.75;
    static var channels: Map<String, Array<BaseChannelHandle>> = new Map();

    static var gameStartSound: Sound;
    static var gameStartSoundHandle: BaseChannelHandle;
    static var pausedSound: Sound;
    static var pausedSoundHandle: BaseChannelHandle;

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

        pausedSound = Assets.sounds.pause;
        pausedSoundHandle = Aura.createCompBufferChannel(pausedSound, false, Aura.mixChannels["fx"]);

        looseSound = Assets.sounds.loose;
        looseSoundHandle = Aura.createCompBufferChannel(looseSound, false, Aura.mixChannels["fx"]);

        winSound = Assets.sounds.win;
        winSoundHandle = Aura.createCompBufferChannel(winSound, false, Aura.mixChannels["fx"]);

        setChannels("button_press", Assets.sounds.button_pressed);
        #if (kha_html5 || kha_debug_html5)
        if (!SystemImpl.mobile) {
        #end
            setChannels("button_select", Assets.sounds.button_select);
        #if (kha_html5 || kha_debug_html5)
        }
        #end

        GameEvents.gameStarted.connect(function () {
            gameStartSoundHandle.play();
        });

        GameEvents.gamePaused.connect(function (paused: Bool) {
            if (paused) {
                pausedSoundHandle.play();
            }
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
            playChannel("button_press");
        });

        GameEvents.buttonSelected.connect(function () {
            #if (kha_html5 || kha_debug_html5)
            if (!SystemImpl.mobile) {
            #end
                playChannel("button_select");
            #if (kha_html5 || kha_debug_html5)
            }
            #end
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