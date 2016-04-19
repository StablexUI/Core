package sx;

import sx.backend.Assets;
import sx.backend.BackendManager;
import sx.exceptions.InvalidBackendException;
import sx.properties.abstracts.ASizeGetterProxy;
import sx.signals.Signal;
import sx.skins.Skin;
import sx.themes.Theme;
import sx.tween.Tweener;
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
    /** Snap rendered objects to nearest pixel where possible. */
    static public var pixelSnapping : Bool = false;
    /** Backend factory */
    static public var backendManager (get,never) : BackendManager;
    static private var __backendManager : BackendManager;

    /** Currently used theme */
    static public var theme : Null<Theme>;

    /**
     * Root widget which can be used to add popups, tooltips etc.
     *
     * Will use default root created by backend manager unless you assign any other widget to `sx.Sx.root` directly.
     * If you are using custom root and want to return to default one, assign `null` to `sx.Sx.root`.
     */
    static public var root (get,set) : Widget;
    static private var __root : Widget;

    /** Signal dispatched once per each frame */
    static public var onFrame (get,never) : Signal<Void->Void>;
    static private var __onFrame : Signal<Void->Void>;

    /** Stage width */
    static public var stageWidth (get,never) : ASizeGetterProxy;
    /** Stage height */
    static public var stageHeight (get,never) : ASizeGetterProxy;

    /** Assets manager */
    static public var assets (get,never) : Assets;

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
     * Returns `value` as-is, if `Sx.pixelSnapping` is `false`.
     * Returns nearest integer for `value`, if `Sx.pixelSnapping` is `true`.
     */
    static public inline function snap (value:Float) : Float
    {
        if (Sx.pixelSnapping) value = Math.round(value);

        return value;
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
            var tasks = __initTasks.copy();
            for (task in tasks) {
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
     * Should be called by BackendManager once per each frame.
     */
    static public function frame () : Void
    {
        __onFrame.dispatch();

        Tweener.update();
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
    @:access(sx.tween.Tweener.initialize)
    static private inline function __initializationFinished () : Void
    {
        Tweener.initialize();
        __backendManager.setupPointerDevices();
        __backendManager.setupFrames();

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


    /**
     * Getter `root`
     */
    static private function get_root () : Widget
    {
        return (__root == null ? backendManager.getRoot() : __root);
    }


    /**
     * Setter `root`
     */
    static private function set_root (value:Widget) : Widget
    {
        return __root = value;
    }


    /** Getters */
    static private function get_stageWidth ()      return backendManager.getRoot().width;
    static private function get_stageHeight ()     return backendManager.getRoot().height;
    static private function get_assets ()          return backendManager.getAssets();

    /** Typical signal getters */
    static private function get_onFrame ()            return (__onFrame == null ? __onFrame = new Signal() : __onFrame);

    private function new () : Void {}
}//class Sx

