package sx.themes.flatui;

import sx.properties.metric.Size;
import sx.properties.metric.Units;
import sx.widgets.Bmp;
import sx.widgets.HBox;
import sx.widgets.Widget;
import sx.properties.Orientation;

using sx.tools.PropertiesTools;


/**
 * Icon with bitmap which will be scaled to icon size
 *
 * Default size: 32x32
 */
class Icon extends HBox
{

    /** Bitmap on icon */
    public var bmp (get,set) : Null<Bmp>;
    private var __bmp : Bmp;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        width.dip = 32;
        height.dip = 32;

        onResize.add(__iconResized);
    }


    /**
     * Set new bitmap
     */
    private function __setBmp (bmp:Bmp) : Void
    {
        if (__bmp != null) removeChild(__bmp);
        __bmp = bmp;

        if (__bmp != null) {
            __bmp.origin.set(0.5, 0.5);

            addChild(__bmp);
            adjustBmp();
        }
    }


    /**
     * Adjust current bitmap scale to icon size
     */
    public function adjustBmp () : Void
    {
        if (__bmp == null) return;

        var width  = width.dip - padding.left.dip - padding.right.dip;
        var height = height.dip - padding.top.dip - padding.bottom.dip;

        var scale = Math.min(width / __bmp.width.dip, height / __bmp.height.dip);
        __bmp.scaleX = scale;
        __bmp.scaleY = scale;
    }


    /**
     * Icon resized, adjust bmp scale
     */
    private function __iconResized (me:Widget, size:Size, prevUnits:Units, prevValue:Float) : Void
    {
        adjustBmp();
    }


    /**
     * Setter `bmp`
     */
    private function set_bmp (value:Bmp) : Bmp
    {
        __setBmp(value);

        return value;
    }


    /** Getters */
    private function get_bmp ()     return __bmp;

}//class Icon