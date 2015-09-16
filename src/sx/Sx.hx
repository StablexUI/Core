package sx;

import sx.backend.TBackendFactory;
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
    static public var backendFactory (get,never) : TBackendFactory;
    static private var __backendFactory : TBackendFactory;


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
    static public function setBackendFactory (factory:TBackendFactory) : Void
    {
        if (__backendFactory != null) {
            throw new InvalidBackendException('Backend factory is already set.');
        }

        __backendFactory = factory;
    }


    /**
     * Getter `backendFactory`
     */
    static private function get_backendFactory () : TBackendFactory
    {
        if (__backendFactory == null) {
            __backendFactory = new TBackendFactory();
        }

        return __backendFactory;
    }

    private function new () : Void {}
}//class Sx

