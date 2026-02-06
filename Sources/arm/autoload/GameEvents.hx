package arm.autoload;

import armory.system.Signal;

@:n64Autoload
class GameEvents {
    public static var sceneLoaded: Signal = new Signal(); // (sceneName: String)
    public static var sceneUnloaded: Signal = new Signal();
    public static var sceneChangeStarted: Signal = new Signal(); // (sceneName: String)
    public static var sceneStarted: Signal = new Signal();

    public static var gemCollected: Signal = new Signal();
    public static var levelWon: Signal = new Signal();
    public static var playerDied: Signal = new Signal();
}