package sx.tools;

import sx.widgets.Widget;
import sx.geom.Unit;


/**
 * Various utility methods
 *
 */
class WidgetTools
{

    /**
     * Check if `width` or `height` as `Percent` units
     */
    static public inline function sizeDependsOnParent (widget:Widget) : Bool
    {
        return (widget.width.units == Percent || widget.height.units == Percent);
    }


    /**
     * Check if widget's position is determined by parent's size.
     */
    static public function positionDependsOnParent (widget:Widget) : Bool
    {
        var left = widget.left;
        if (left.selected && left.units == Percent) return true;
        if (widget.right.selected) return true;

        var top = widget.top;
        if (top.selected && top.units == Percent) return true;
        if (widget.bottom.selected) return true;

        return false;
    }

}//class WidgetTools