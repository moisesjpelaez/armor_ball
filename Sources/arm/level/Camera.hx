package arm.level;

import arm.autoload.MainInstances;
import iron.math.Vec4;
import iron.object.Object;

class Camera extends iron.Trait {
    var target: Object;
    var offset: Vec4;

    public function new() {
        super();

        notifyOnInit(function() {
            target = MainInstances.player.object;
            offset = new Vec4(object.transform.worldx() - target.transform.worldx(),
                              object.transform.worldy() - target.transform.worldy(),
                              object.transform.worldz() - target.transform.worldz(), 1);

            notifyOnLateUpdate(function() {
                object.transform.loc.set(target.transform.worldx() + offset.x, target.transform.worldy() + offset.y, target.transform.worldz() + offset.z);
            });
        });

    }
}