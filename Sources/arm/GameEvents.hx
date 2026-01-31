package arm;

import armory.system.Signal;

@:n64Autoload
class GameEvents {
    public static var sceneLoaded: Signal = new Signal();
    public static var sceneChangeStarted: Signal = new Signal();
}