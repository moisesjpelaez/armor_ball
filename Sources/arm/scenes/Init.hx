package arm.scenes;

import arm.autoload.Music;
import arm.autoload.SoundEffects;
import aura.Aura;
import iron.Scene;
import iron.system.Input;
import kha.Assets;
#if (kha_html5 || kha_debug_html5)
import arm.autoload.Transitions;
#end

class Init extends iron.Trait {
    @prop var initialScene: String = "Splash";

    public function new() {
        super();
        #if (kha_html5 || kha_debug_html5)
		Transitions.inst.init();
		#end

        Aura.init({channelSize: 32});
        Assets.loadEverything(function () {
            // TODO: add directives for HTML5 compressed audio (armor_64 needs to be updated).
            var loadConfig: AuraLoadConfig = {
                uncompressed: Assets.sounds.names
            };

            if (loadConfig != null && loadConfig.uncompressed != null && loadConfig.uncompressed.length > 0) {
                Aura.loadAssets(loadConfig, function() {
                    notifyOnInit(init);
                }, function () {
                    trace("Could not load audio...");
                }, function (current: Int, total: Int, name: String) {
                    trace(name + " loading: " + Std.string(current) + "/" + Std.string(total) + " loaded.");
                });
            } else {
                notifyOnInit(init);
            }
        });
    }

    function init() {
        Gamepad.buttons = Gamepad.buttonsXBOX;
        Music.init();
        SoundEffects.init();
        Scene.setActive(initialScene);
    }
}