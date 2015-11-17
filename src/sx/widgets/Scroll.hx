package sx.widgets;

import sx.behavior.ScrollBehavior;
import sx.properties.Orientation;
import sx.properties.Side;
import sx.signals.ScrollSignal;
import sx.widgets.ScrollBar;
import sx.widgets.Slider;

using sx.tools.WidgetTools;



/**
 * Scroll container.
 *
 * Content scrolled by changing children coordinates.
 */
class Scroll extends Widget
{
    /**
     * Indicates if user is currently dragging scrolled content.
     * Assign `false` to stop dragging.
     * Assigning `true` while no real dragging is happening has no effect and `dragging` will stay `false`.
     */
    public var dragging (get,set) : Bool;
    /**
     * Indicates if content is currently dragged or scrolled by inertia.
     * Assign `false` to stop scrolling.
     * Assigning `true` while no real scrolling is happening has no effect and `scrolling` will stay `false`.
     */
    public var scrolling (get,set) : Bool;
    /** Enable/disable horizontal scrolling. Default: `true` */
    public var horizontalScroll (get,set) : Bool;
    /** Enable/disable vertical scrolling. Default: `true` */
    public var verticalScroll (get,set) : Bool;

    /** Scrolled distance along X axis (DIPs) */
    public var scrollX (get,set) : Float;
    /** Scrolled distance along Y axis (DIPs) */
    public var scrollY (get,set) : Float;

    /** Horizontal scroll bar */
    public var horizontalBar (get,set) : ScrollBar;
    private var __horizontalBar : ScrollBar;
    /** Vertical scroll bar */
    public var verticalBar (get,set) : ScrollBar;
    private var __verticalBar : ScrollBar;

    /** Scroll behavior implementation */
    private var __scrollBehavior : ScrollBehavior;

    /** Dispatched when content is scrolled */
    public var onScroll (get,never) : ScrollSignal;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();
        overflow = false;

        __scrollBehavior = new ScrollBehavior(this);
        __scrollBehavior.onScroll.add(__scrolled);
    }


    /**
     * Scroll by specified amount of DIPs
     */
    public function scrollBy (dX:Float, dY:Float) : Void
    {
        // var minX = 0.0;
        // var maxX = 0.0;
        // var minY = 0.0;
        // var maxY = 0.0;
        // var horizontal = (dX != 0 && horizontalScroll);
        // var vertical   = (dY != 0 && verticalScroll);

        // var child : Widget;
        // var left,top;
        // for (i in 0...numChildren) {
        //     child = getChildAt(i);
        //     if (!child.isArrangeable()) continue;

        //     if (horizontal) {
        //         left = child.left.dip;
        //         if (i == 0 || left < minX) {
        //             minX = left;
        //         }
        //         if (i == 0 || left + child.width.dip > maxX) {
        //             maxX = left + child.width.dip;
        //         }
        //     }
        //     if (vertical) {
        //         top = child.top.dip;
        //         if (i == 0 || top < minY) {
        //             minY = top;
        //         }
        //         if (i == 0 || top + child.height.dip > maxY) {
        //             maxY = top + child.height.dip;
        //         }
        //     }
        // }

        // var contentWidth  = maxX - minX;
        // var contentHeight = maxY - minY;

        // horizontal = (horizontal && contentWidth > width.dip);
        // vertical   = (vertical && contentHeight > height.dip);

        // if (horizontal) {
        //     if (minX + dX > 0) {
        //         dX = -minX;
        //     } else if (maxX + dX < width.dip) {
        //         dX = width.dip - maxX;
        //     }
        //     if (__horizontalBar != null) {
        //         __horizontalBar.min = 0;
        //         __horizontalBar.max = contentWidth;
        //         __horizontalBar.value = -minX;
        //         __horizontalBar.visibleContentSize = width.dip;
        //     }
        // }
        // if (vertical) {
        //     if (minY + dY > 0) {
        //         dY = -minY;
        //     } else if (maxY + dY < height.dip) {
        //         dY = height.dip - maxY;
        //     }
        // }

        var horizontal = (dX != 0 && horizontalScroll);
        var vertical   = (dY != 0 && verticalScroll);

        if (horizontal) {
            dX = __constraintScrollByValue(dX, scrollX, getMaxScrollX());
            if (dX == 0) {
                horizontal = false;
            }
        }
        if (vertical) {
            dY = __constraintScrollByValue(dY, scrollY, getMaxScrollY());
            if (dY == 0) {
                vertical = false;
            }
        }

        var child;
        for (i in 0...numChildren) {
            child = getChildAt(i);
            if (child.isArrangeable()) {
                if (horizontal) child.left.dip -= dX;
                if (vertical) child.top.dip -= dY;
            }
        }
    }


    /**
     * Возвращает максимальное значение `scrollX`
     */
    public function getMaxScrollX () : Float
    {
        return __calculateMaxScrollValue(Horizontal);
    }


    /**
     * Возвращает максимальное значение `scrollY`
     */
    public function getMaxScrollY () : Float
    {
        return __calculateMaxScrollValue(Vertical);
    }


    /**
     * Method to cleanup and release this object for garbage collector.
     */
    override public function dispose (disposeChildren:Bool = true) : Void
    {
        __scrollBehavior.stop();

        super.dispose();
    }


    /**
     * Make sure `by` will not scroll our content out of borders
     */
    private function __constraintScrollByValue (by:Float, value:Float, max:Float) : Float
    {
        if (value + by < 0) {
            if (value <= 0) {
                if (by < 0) {
                    by = 0;
                }
            } else {
                by = -value;
            }
        }
        if (value + by > max) {
            if (value >= max) {
                if (by > 0) {
                    by = 0;
                }
            } else {
                by = max - value;
            }
        }

        return by;
    }


    /**
     * Calculate maximum value for `scrollX` or `scrollY`
     */
    private function __calculateMaxScrollValue (orientation:Orientation) : Float
    {
        var max = 0.0;
        var min = 0.0;

        var side : Side = switch (orientation) {
            case Horizontal : Left;
            case Vertical   : Top;
        }

        var child : Widget;
        var childMin,childMax;
        for (i in 0...numChildren) {
            child = getChildAt(i);
            if (!child.isArrangeable()) continue;

            childMin = child.coordinate(side).dip;
            childMax = childMin + child.size(orientation).dip;
            if (i == 0 || childMin < min) {
                min = childMin;
            }
            if (i == 0 || childMax > max) {
                max = childMax;
            }
        }

        var maxScroll = (max - min - this.size(orientation).dip);
        if (maxScroll < 0) {
            maxScroll = 0;
        }

        return maxScroll;
    }


    /**
     * Calculate current `scrollX` or `scrollY` value.
     */
    private function __calculateScrollValue (orientation:Orientation) : Float
    {
        var min = 0.0;

        var side : Side = switch (orientation) {
            case Horizontal : Left;
            case Vertical   : Top;
        }

        var child : Widget;
        var childValue;
        for (i in 0...numChildren) {
            child = getChildAt(i);
            if (!child.isArrangeable()) continue;

            childValue = child.coordinate(side).dip;
            if (i == 0 || childValue < min) {
                min = childValue;
            }
        }

        return -min;
    }


    /**
     * Called when user wants to scroll
     */
    private function __scrolled (me:Widget, dX:Float, dY:Float) : Void
    {
        scrollBy(dX, dY);
    }


    /**
     * Signal called when user moves horizontal scroll bar
     */
    private function __horizontalBarChanged (bar:Slider) : Void
    {

    }


    /**
     * Getter `scrollX`
     */
    private function get_scrollX () : Float
    {
        return __calculateScrollValue(Horizontal);
    }


    /**
     * Getter `scrollY`
     */
    private function get_scrollY () : Float
    {
        return __calculateScrollValue(Vertical);
    }


    /**
     * Setter `scrollX`
     */
    private function set_scrollX (value:Float) : Float
    {
        scrollBy(value - scrollX, 0);

        return value;
    }


    /**
     * Setter `scrollY`
     */
    private function set_scrollY (value:Float) : Float
    {
        scrollBy(0, value - scrollY);

        return value;
    }


    /**
     * Setter `verticalBar`
     */
    private function set_verticalBar (value:ScrollBar) : ScrollBar
    {
        __verticalBar = value;

        return value;
    }


    /**
     * Setter `horizontalBar`
     */
    private function set_horizontalBar (value:ScrollBar) : ScrollBar
    {
        if (__horizontalBar != null) {
            removeChild(__horizontalBar);
            __horizontalBar.onChange.remove(__horizontalBarChanged);
        }

        __horizontalBar = value;

        if (__horizontalBar != null) {
            addChild(__horizontalBar);
            __horizontalBar.onChange.add(__horizontalBarChanged);
        }

        return value;
    }


    /** Getters */
    private function get_dragging ()            return __scrollBehavior.dragging;
    private function get_scrolling ()           return __scrollBehavior.scrolling;
    private function get_horizontalScroll ()    return __scrollBehavior.horizontalScroll;
    private function get_verticalScroll ()      return __scrollBehavior.verticalScroll;
    private function get_onScroll ()            return __scrollBehavior.onScroll;
    private function get_horizontalBar ()       return __horizontalBar;
    private function get_verticalBar ()         return __verticalBar;

    /** Setters */
    private function set_dragging (v)            return __scrollBehavior.dragging = v;
    private function set_scrolling (v)           return __scrollBehavior.scrolling = v;
    private function set_horizontalScroll (v)    return __scrollBehavior.horizontalScroll = v;
    private function set_verticalScroll (v)      return __scrollBehavior.verticalScroll = v;

}//class Scroll