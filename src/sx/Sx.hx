package sx;

import sx.backend.IBackend;
import sx.backend.IStage;
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
    /**
     * "Global" stage used by default.
     * This is an alias for `IBackend.getGlobalStage()`
     */
    static public var stage (get,never) : IStage;
    /** Backend factory */
    static public var backend (get,never) : IBackend;
    static private var __backend : IBackend;

    /** Root widgets to render on stages */
    static private var __renderList : Map<IStage,Array<Widget>> = new Map();

    /** Values to pass to widgets being rendered */
    static private var __renderData : RenderData = new RenderData();


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
    static public function setBackend (backend:IBackend) : Void
    {
        if (__backend != null) {
            throw new InvalidBackendException('Backend is already set.');
        }

        __backend = backend;
    }


    /**
     * Start rendering display list of `widget` on `stage`.
     *
     * If `stage` is `null` then `Sx.stage` will be used.
     *
     * `widget` will be removed from any parent before adding to rendering.
     */
    static public function attach (widget:Widget, stage:IStage = null) : Void
    {
        if (widget.parent != null) widget.parent.removeChild(widget);
        if (stage == null) stage = Sx.stage;

        var list = __renderList.get(stage);
        if (list == null) {
            list = [];
            __renderList.set(stage, list);
        }

        widget.__stage = stage;

        if (list.indexOf(widget) < 0) {
            list.push(widget);
        }
    }


    /**
     * Render current state of all widgets attached to stages
     */
    static public function render () : Void
    {
        for (stage in __renderList.keys()) {
            __renderData.stage = stage;
            __renderData.displayIndex = stage.getFirstDisplayIndex();

            for (root in __renderList.get(stage)) {
                root.__render(__renderData);
            }

            stage.finalizeRender(__renderData.displayIndex);

            __renderData.reset();
        }
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


    private function new () : Void {}
}//class Sx



/**
 * Contains values which should be passed to rendered widgets
 *
 */
@:allow(sx)
class RenderData
{
    /** Stage to render widgets on */
    public var stage (default,null) : IStage;
    /** At which index next widget should be rendered on stage */
    public var displayIndex (default,null) : Int = 0;
    /** Cumulative transparency for next rendered widget */
    public var globalAlpha (default,null) : Float = 1;


    /**
     * Constructor
     */
    public function new () : Void
    {

    }


    /**
     * Reset values
     */
    private inline function reset () : Void
    {
        stage = null;
        displayIndex = 0;
        globalAlpha  = 1;
    }

}//class RenderData