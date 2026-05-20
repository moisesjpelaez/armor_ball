package arm.autoload;

import arm.player.Player;
import iron.Scene;
import iron.data.Data;
import iron.data.SceneFormat;

@:n64Autoload
class MainInstances {
    public static var player: Player;
    public static var spawnScene: TSceneFormat;

    public static function init(done: Void->Void) {
        Data.getSceneRaw("SpawnObjects", function(raw: TSceneFormat) {
            spawnScene = raw;
            Scene.active.addScene("SpawnObjects", null, function(o) {
                o.remove();
                done();
            });
        });
    }
}