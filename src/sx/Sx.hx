package sx;

import sx.backend.BackendFactory;
import sx.exceptions.InvalidBackendException;
import sx.skins.Skin;
import sx.widgets.Widget;



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
    static public var backendFactory (get,never) : BackendFactory;
    static private var __backendFactory : BackendFactory;
    /** Registered skin factories */
    static private var __skins : Map<String,Void->Skin> = new Map();


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
     * Set backend factory
     *
     */
    static public function setBackendFactory (factory:BackendFactory) : Void
    {
        if (__backendFactory != null) {
            throw new InvalidBackendException('Backend factory is already set.');
        }

        __backendFactory = factory;
    }


    /**
     * Register skin factory, so that skins can be instantiated with `Sx.skin(name)`
     */
    static public function registerSkin (name:String, factory:Void->Skin) : Void
    {
        __skins.set(name, factory);
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
     * Getter `backendFactory`
     */
    static private function get_backendFactory () : BackendFactory
    {
        if (__backendFactory == null) {
            __backendFactory = new BackendFactory();
        }

        return __backendFactory;
    }

    private function new () : Void {}
}//class Sx

