package sx.widgets;

using sx.tools.WidgetTools;


/**
 * Simple scroll bar
 *
 */
class ScrollBar extends Slider
{

    /** Thumb size depends on this value. */
    public var visibleContentSize (default,set) : Float = 0;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        arrangeable = false;
    }


    /**
     * Change thumb size according to `max`, `min` and `visibleContentSize`
     */
    private function __updateThumbSize (min:Float, max:Float, visibleSize:Float) : Void
    {
        var part = (max == min ? 1 : visibleSize / (max - min));
        if (part <= 0 || part > 1) {
            part = 1;
        }


        thumb.size(orientation).dip = part * this.size(orientation).dip;
    }


    /**
     * Setter `contentSize`
     */
    private function set_visibleContentSize (value:Float) : Float
    {
        visibleContentSize = value;
        __updateThumbSize(min, max, value);

        return value;
    }


    /**
     * Setter `max`
     */
    override private function set_max (value:Float) : Float
    {
        if (max != value) {
            __updateThumbSize(min, value, visibleContentSize);
        }

        return super.set_max(value);
    }


    /**
     * Setter `min`
     */
    override private function set_min (value:Float) : Float
    {
        if (min != value) {
            __updateThumbSize(value, max, visibleContentSize);
        }

        return super.set_min(value);
    }

}//class ScrollBar