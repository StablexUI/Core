package sx;

import sx.backend.BackendFactory;
import sx.exceptions.InvalidBackendException;
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

