package sx.tools;

import sx.properties.Side;
import sx.properties.Orientation;
import sx.properties.metric.Coordinate;
import sx.properties.metric.Size;
import sx.widgets.Widget;
import sx.properties.metric.Units;


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


    /**
     * Check if widget position is defined by `bottom` or `right`
     */
    static public inline function positionDependsOnSize (widget:Widget) : Bool
    {
        return widget.bottom.selected || widget.right.selected;
    }


    /**
     * Get `widget` coordinate for specified `side`
     */
    static public function coordinate (widget:Widget, side:Side) : Coordinate
    {
        return switch (side) {
            case Left   : widget.left;
            case Right  : widget.right;
            case Top    : widget.top;
            case Bottom : widget.bottom;
        }
    }


    /**
     * Get `widget` `width` or `height`
     */
    static public function size (widget:Widget, orientation:Orientation) : Size
    {
        return switch (orientation) {
            case Horizontal : widget.width;
            case Vertical   : widget.height;
        }
    }

}//class WidgetTools