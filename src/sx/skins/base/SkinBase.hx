package sx.skins.base;

import sx.properties.abstracts.APadding;
import sx.properties.metric.Padding;
import sx.properties.metric.Units;
import sx.properties.metric.Size;
import sx.widgets.Widget;



/**
 * Base class for skins.
 * Skin rendering should be implemented by backend.
 */
class SkinBase
{
    /** Padding between widget edges and skin area edges */
    public var padding (get,set) : APadding;
    private var __padding : Padding;

    /** Widget this skin is currently applied to */
    private var __widget : Widget;


    /**
     * Constructor
     */
    public function new () : Void
    {

    }


    /**
     * Called when skin visualization should be updated
     */
    public function refresh () : Void
    {

    }


    /**
     * Checks if skin has padding defined
     */
    public function hasPadding () : Bool
    {
        return __padding != null;
    }


    /**
     * Called when skin is set for a `widget`.
     * Don't perform any actions (like drawing) with `widget` here. Just store a reference to `widget` if required.
     */
    @:allow(sx.widgets.Widget)
    private function usedBy (widget:Widget) : Void
    {
        if (__widget != null) __widget.skin = null;

        __widget = widget;
        __widget.onResize.add(__widgetResized);
        if (__widget.initialized) refresh();
    }


    /**
     * If this skin is no longer in use by current widget
     */
    @:allow(sx.widgets.Widget)
    private function removed () : Void
    {
        if (__widget != null) {
            __widget.onResize.remove(__widgetResized);
            __widget = null;
        }
    }


    /**
     * Called when `width` or `height` is changed.
     */
    private function __widgetResized (widget:Widget, changed:Size, previousUnits:Units, previousValue:Float) : Void
    {
        if (__widget.initialized) refresh();
    }


    /**
     * Use this if you need to pass widget's width somewhere
     */
    private function __widgetWidthProvider () : Size
    {
        return (__widget == null ? Size.zeroProperty : __widget.width);
    }


    /**
     * Use this if you need to pass widget's width somewhere
     */
    private function __widgetHeightProvider () : Size
    {
        return (__widget == null ? Size.zeroProperty : __widget.width);
    }


    /**
     * Getter for `padding`
     */
    private function get_padding () : APadding
    {
        if (__padding == null) {
            __padding = new Padding();
            __padding.ownerWidth = __widgetWidthProvider;
            __padding.ownerWidth = __widgetHeightProvider;
        }

        return __padding;
    }


    /** Setters */
    private function set_padding (v)    return {(padding:Padding).copyValueFrom(v); return padding;}

}//class SkinBase