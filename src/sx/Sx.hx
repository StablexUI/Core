package sx;

import sx.backend.IBackend;
import sx.backend.IStage;
import sx.exceptions.InvalidBackendException;
import sx.widgets.Widget;



/**
 * Core class of StablexUI
 *
 */
class Sx
{
    /** Device independent pixels to physical pixels factor */
    static public var dipFactor : Float = 1;
    /**
     * "Global" stage used by default.
     * This is an alias for `IBackend.getGlobalStage()`
     */
    static public var stage (get,never) : IStage;
    /** Backend factory */
    static public var backend (get,never) : IBackend;
    static private var __backend : IBackend;


    /**
    * Convert pixels to dips
    *
    */
    static public inline function toDip (px:Float) : Float {
        return px / dipFactor;
    }//function toDip()


    /**
    * Convert dips to pixels
    *
    */
    static public inline function toPx (dip:Float) : Float {
        return dip * dipFactor;
    }//function toPx()


    /**
     * Set backend factory
     *
     */
    static public function setBackend (backend:IBackend) : Void
    {
        if (__backend != null) {
            throw new InvalidBackendException('Backend is already set.');
        }

        __backend = backend;
    }//function setBackend()


    /**
     * Start rendering display list of `widget` on `stage`.
     *
     * If `stage` is `null` then `Sx.stage` will be used.
     *
     * `widget` will be removed from any parent before adding to rendering.
     */
    @:access(sx.widgets.Widget)
    static public function render (widget:Widget, stage:IStage = null) : Void
    {
        if (widget.parent != null) widget.parent.removeChild(widget);
        if (stage == null) stage = Sx.stage;

        widget.__stage = stage;
    }


    /**
     * Cosntructor
     *
     */
    private function new () : Void
    {

    }


    /**
     * Getter `stage`
     */
    static private inline function get_stage () : IStage
    {
        if (__backend == null) throw new InvalidBackendException('Backend is not set.');

        return __backend.getGlobalStage();
    }


    /**
     * Getter `backend`
     */
    static private inline function get_backend () : IBackend
    {
        if (__backend == null) throw new InvalidBackendException('Backend is not set.');

        return __backend;
    }


}//class Sx