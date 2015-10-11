package sx;

import sx.backend.BackendManager;
import sx.exceptions.InvalidBackendException;
import sx.signals.Signal;
import sx.skins.Skin;
import sx.themes.Theme;
import sx.widgets.Widget;


typedef InitTask = (Void->Void)->Void;


/**
 * Core class of StablexUI
 *
 */
@:access(sx.widgets.Widget)
class Sx
{
    /** Device independent pixels to physical pixels factor */
    static public var dipFactor : Float = 1;
    /** Backend factory */
    static public var backendManager (get,never) : BackendManager;
    static private var __backendManager : BackendManager;

    /** Currently used theme */
    static public var theme : Null<Theme>;

    /** Registered skin factories */
    static private var __skins : Map<String,Void->Skin> = new Map();
    /** User-defined initialization tasks */
    static private var __initTasks : Array<InitTask> = [];
    /** Callback to invoke after StablexUI initialization process */
    static private var __readyCallback : Void->Void;


    /**
     * Convert pixels to dips
     */
    static public inline function toDip (px:Float) : Float
    {
        return px / dipFactor;
    }


    /**
     * Convert dips to pixels
     */
    static public inline function toPx (dip:Float) : Float
    {
        return dip * dipFactor;
    }


    /**
     * Set backend manager
     *
     */
    static public function setBackendManger (manager:BackendManager) : Void
    {
        if (__backendManager != null) {
            throw new InvalidBackendException('Backend manager is already set.');
        }

        __backendManager = manager;
    }


    /**
     * Register skin factory, so that skins can be instantiated with `Sx.skin(name)`
     */
    static public function registerSkin (name:String, factory:Void->Skin) : Void
    {
        __skins.set(name, factory);
    }


    /**
     * If you need to perform some tasks before StablexUI finishes initialization process, use this method.
     * StablexUI will not call `readyCallback` passed to `Sx.init(readyCallback)` until all tasks finish.
     * Task should accept a callback as the first argument. That callback should be called manually when task is finished.
     */
    static public function addInitTask (task:InitTask) : Void
    {
        __initTasks.push(task);
    }


    /**
     * Initialize StablexUI.
     *
     * @param   readyCallback   Callback to invoke when StablexUI is ready to create widgets.
     */
    static public function init (readyCallback:Void->Void) : Void
    {
        __readyCallback = readyCallback;

        if (__backendManager == null) {
            __backendManager = new BackendManager();
        }

        if (__initTasks.length == 0) {
            __initializationFinished();
        } else {
            for (task in __initTasks.copy()) {
                task(__doneInitTask.bind(task));
            }
        }
    }


    /**
     * Instantiate a skin using previousely registered skin factory.
     *
     * Returns `null` if no skins were rigestered under specified `name`.
     */
    static public function skin (name:String) : Null<Skin>
    {
        var factory = __skins.get(name);

        return (factory == null ? null : factory());
    }


    /**
     * Removes all registered skin factories
     */
    static public function dropSkins () : Void
    {
        __skins = new Map();
    }


    /**
     * Callback to invoke when `task` is finished
     */
    static private function __doneInitTask (task:InitTask) : Void
    {
        for (i in 0...__initTasks.length) {
            if (Reflect.compareMethods(__initTasks[i], task)) {
                __initTasks.splice(i, 1);
                break;
            }
        }

        if (__initTasks.length == 0) {
            __initializationFinished();
        }
    }


    /**
     * Called when StablexUI is ready to invoke `readyCallback()` passed to `Sx.init(readyCallback)`
     */
    static private inline function __initializationFinished () : Void
    {
        __readyCallback();
    }


    /**
     * Getter `backendManager`
     */
    static private function get_backendManager () : BackendManager
    {
        if (__backendManager == null) {
            __backendManager = new BackendManager();
        }

        return __backendManager;
    }

    private function new () : Void {}
}//class Sx

