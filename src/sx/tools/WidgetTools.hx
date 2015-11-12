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
     * Get `widget` coordinate which defines `widget` position in specified `orientation`
     */
    static public function selectedCoordinate (widget:Widget, orientation:Orientation) : Coordinate
    {
        return switch (orientation) {
            case Horizontal : (widget.left.selected ? widget.left : widget.right);
            case Vertical   : (widget.top.selected ? widget.top : widget.bottom);
        }
    }


    /**
     * Get `widget` side which defines `widget` position in specified `orientation`
     */
    static public function selectedSide (widget:Widget, orientation:Orientation) : Side
    {
        return switch (orientation) {
            case Horizontal : (widget.left.selected ? Left : Right);
            case Vertical   : (widget.top.selected ? Top : Bottom);
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


    /**
     * Find first enabled widget starting from `widget` up to the top of display list.
     */
    static public function findEnabled (widget:Widget) : Null<Widget>
    {
        var current = widget;
        var useNextEnabled = false;

        while (current != null) {
            if (useNextEnabled) {
                if (current.enabled) {
                    widget = current;
                    useNextEnabled = false;
                    break;
                }
            } else {
                if (!current.enabled) {
                    useNextEnabled = true;
                }
            }

            current = current.parent;
        }
        //reached last widget and it was disabled
        if (useNextEnabled) {
            widget = null;
        }

        return widget;
    }


    /**
     * Check if origin point of `widget` was set
     */
    @:access(sx.widgets.Widget.__origin)
    static public inline function hasOrigin (widget:Widget) : Bool
    {
        return widget.__origin != null;
    }


    /**
     * Check if offset point of `widget` was set
     */
    @:access(sx.widgets.Widget.__offset)
    static public inline function hasOffset (widget:Widget) : Bool
    {
        return widget.__offset != null;
    }


    /**
     * Check if `widget` should be taken into account when arranging children according to layout settings.
     */
    static public inline function isArrangeable (widget:Widget) : Bool
    {
        return (widget.arrangeable && widget.visible);
    }

}//class WidgetTools