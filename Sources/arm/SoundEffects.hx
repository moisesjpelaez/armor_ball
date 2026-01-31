package arm;

import armory.system.Tween;
import aura.Aura;
import kha.Assets;
import kha.Sound;

@:n64Autoload
class SoundEffects {
    public static var volume(default, set): Float = 1.0;

    static function set_volume(value: Float): Float {
        Aura.mixChannels["fx"].setVolume(value);
        return volume = value;
    }

    public static function init() {

    }
}