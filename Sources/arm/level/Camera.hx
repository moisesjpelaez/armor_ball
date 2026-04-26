package arm.level;

import arm.autoload.MainInstances;
import iron.math.Vec4;
#if !arm_target_n64
import iron.object.CameraObject;
#end
import iron.object.Object;

class Camera extends iron.Trait {
    var target: Object;
    var offset: Vec4;

    public function new() {
        super();

        notifyOnInit(function() {
            #if !arm_target_n64
            var camera: CameraObject = cast(object, CameraObject);
            camera.data.raw.near_plane = 0.01;
            camera.data.raw.far_plane = 500.0;
            camera.buildProjection();
            #end
            target = MainInstances.player.object;
            offset = new Vec4(object.transform.worldx() - target.transform.worldx(), object.transform.worldy() - target.transform.worldy(), object.transform.worldz() - target.transform.worldz(), 1);

            notifyOnLateUpdate(function() {
                object.transform.loc.set(target.transform.worldx() + offset.x, target.transform.worldy() + offset.y, target.transform.worldz() + offset.z);
            });
        });

    }
}