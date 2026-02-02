package arm.scenes;

import arm.autoloads.Music;
import arm.autoloads.SoundEffects;
import aura.Aura;
import iron.Scene;
import kha.Assets;

class Init extends iron.Trait {
    @prop var initialScene: String = "Test1";

    public function new() {
        super();
        Aura.init({channelSize: 32});
        Assets.loadEverything(function () {
            var loadConfig: AuraLoadConfig = {
                compressed: Assets.sounds.names
            };

            if (loadConfig != null && loadConfig.compressed != null && loadConfig.compressed.length > 0) {
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
        Music.init();
        SoundEffects.init();
        Scene.setActive(initialScene);
    }
}