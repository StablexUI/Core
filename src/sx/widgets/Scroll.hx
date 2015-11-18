package sx.widgets;

import sx.behavior.DragScrollBehavior;
import sx.properties.metric.Size;
import sx.properties.metric.Units;
import sx.properties.Orientation;
import sx.properties.Side;
import sx.signals.Signal;
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
    /** Enables/disables scrolling by dragging */
    public var dragScroll (get,set) : Bool;
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
    /** Flag to prevent recursive scroll bar updates */
    private var __updatingHorizontalBar : Bool = false;
    /** Flag to prevent recursive scroll bar updates */
    private var __updatingVerticalBar : Bool = false;

    /** Scroll behavior implementation */
    private var __dragScrollBehavior : DragScrollBehavior;

    /**
     * Dispatched when content is scrolled
     *
     * @param   Scroll      Scroll container.
     * @param   Float       Scroll distance alonge X axis (DIPs)
     * @param   Float       Scroll distance alonge Y axis (DIPs)
     */
    public var onScroll (get,never) : Signal<Scroll->Float->Float->Void>;
    private var __onScroll : Signal<Scroll->Float->Float->Void>;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();
        overflow = false;

        __dragScrollBehavior = new DragScrollBehavior(this);
        __dragScrollBehavior.onScroll.add(__scrolled);

        onChildAdded.add(__childAdded);
        onChildRemoved.add(__childRemoved);

        horizontalBar = new ScrollBar();
        verticalBar   = new ScrollBar();
    }


    /**
     * Scroll by specified amount of DIPs
     */
    public function scrollBy (dX:Float, dY:Float) : Void
    {
        var horizontal = (dX != 0 && horizontalScroll);
        var vertical   = (dY != 0 && verticalScroll);

        var scrollX    = 0.0;
        var scrollY    = 0.0;
        var maxScrollX = 0.0;
        var maxScrollY = 0.0;

        if (horizontal) {
            scrollX    = this.scrollX;
            maxScrollX = getMaxScrollX();
            dX = __constraintScrollByValue(dX, scrollX, maxScrollX);
            if (dX == 0) horizontal = false;
        }
        if (vertical) {
            scrollY    = this.scrollY;
            maxScrollY = getMaxScrollY();
            dY = __constraintScrollByValue(dY, scrollY, maxScrollY);
            if (dY == 0) vertical = false;
        }

        if (horizontal || vertical) {
            var child;
            for (i in 0...numChildren) {
                child = getChildAt(i);
                if (child.isArrangeable()) {
                    if (horizontal) child.left.dip -= dX;
                    if (vertical) child.top.dip -= dY;
                }
            }
            if (horizontal && __horizontalBar != null) {
                __updateBar(__horizontalBar, maxScrollX, scrollX);
            }
            if (vertical && __verticalBar != null) {
                __updateBar(__verticalBar, maxScrollY, scrollY);
            }

            __onScroll.dispatch(this, dX, dY);
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
        __dragScrollBehavior.stop();
        if (__horizontalBar != null) {
            __horizontalBar.onChange.remove(__horizontalBarChanged);
        }
        if (__verticalBar != null) {
            __verticalBar.onChange.remove(__verticalBarChanged);
        }

        super.dispose();
    }


    /**
     * Update scroll bars on initialization
     */
    override private function __initializeSelf () : Void
    {
        super.__initializeSelf();
        __updateBothBars();
    }


    /**
     * Make sure `by` will not scroll our content out of scroll container borders
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
        if (__updatingHorizontalBar) return;
        __updatingHorizontalBar = true;

        if (horizontalScroll) {
            scrollX = bar.value;
            __updatingHorizontalBar = false;

        } else {
            __updatingHorizontalBar = false;
            __updateBar(__horizontalBar, getMaxScrollX(), scrollX);
        }
    }


    /**
     * Signal called when user moves vertical scroll bar
     */
    private function __verticalBarChanged (bar:Slider) : Void
    {
        if (__updatingVerticalBar) return;
        __updatingVerticalBar = true;

        if (verticalScroll) {
            scrollY = bar.value;
            __updatingVerticalBar = false;

        } else {
            __updatingVerticalBar = false;
            __updateBar(__verticalBar, getMaxScrollY(), scrollY);
        }

    }


    /**
     * Update state of specified scroll `bar`
     */
    private function __updateBar (bar:ScrollBar, max:Float, value:Float) : Void
    {
        if (bar == __horizontalBar) {
            if (__updatingHorizontalBar) return;
            __updatingHorizontalBar = true;
        }
        if (bar == __verticalBar) {
            if (__updatingVerticalBar) return;
            __updatingVerticalBar = true;
        }

        bar.min = 0;
        bar.max = max;
        bar.ignoreNextEasing = true;
        bar.value = value;

        if (bar == __horizontalBar) {
            __updatingHorizontalBar = false;
        }
        if (bar == __verticalBar) {
            __updatingVerticalBar = false;
        }
    }


    /**
     * Update horizontal & vertical scroll bars
     */
    private inline function __updateBothBars () : Void
    {
        if (initialized && !disposed) {
            if (__horizontalBar != null) {
                __updateBar(__horizontalBar, getMaxScrollX(), scrollX);
            }
            if (__verticalBar != null) {
                __updateBar(__verticalBar, getMaxScrollY(), scrollY);
            }
        }
    }


    /**
     * Handle new children
     */
    private function __childAdded (me:Widget, child:Widget, index:Int) : Void
    {
        child.onMove.add(__childMoved);
        child.onResize.add(__childResized);

        __makeSureChildBehindScrollBars(child, index);
        if (child.isArrangeable()) {
            __updateBothBars();
        }
    }


    /**
     * Handle child removal
     */
    private function __childRemoved (me:Widget, child:Widget, index:Int) : Void
    {
        child.onMove.remove(__childMoved);
        child.onResize.remove(__childResized);

        if (child.isArrangeable()) {
            __updateBothBars();
        }
    }


    /**
     * Update scroll bars when some child moves
     */
    private function __childMoved (child:Widget, coordinate:Size, previousUnits:Units, previousValue:Float) : Void
    {
        if (!scrolling && child.isArrangeable()) {
            __updateBothBars();
        }
    }


    /**
     * Update scroll bars when some child resized
     */
    private function __childResized (child:Widget, size:Size, previousUnits:Units, previousValue:Float) : Void
    {
        if (child.isArrangeable()) {
            __updateBothBars();
        }
    }


    /**
     * if `childIndex` is above scroll bars, then `child` will be moved behind scroll bars
     */
    private function __makeSureChildBehindScrollBars (child:Widget, childIndex:Int) : Void
    {
        if (child == __horizontalBar || child == __verticalBar) return;

        var maxChildIndex = numChildren - 1;
        if (__horizontalBar != null) {
            maxChildIndex--;
        }
        if (__verticalBar != null) {
            maxChildIndex--;
        }

        if (childIndex > maxChildIndex) {
            childIndex = maxChildIndex;
        }
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
        if (scrolling) {
            __dragScrollBehavior.stop();
        }
        scrollBy(value - scrollX, 0);

        return value;
    }


    /**
     * Setter `scrollY`
     */
    private function set_scrollY (value:Float) : Float
    {
        if (scrolling) {
            __dragScrollBehavior.stop();
        }
        scrollBy(0, value - scrollY);

        return value;
    }


    /**
     * Setter `verticalBar`
     */
    private function set_verticalBar (value:ScrollBar) : ScrollBar
    {
        if (__verticalBar != null) {
            removeChild(__verticalBar);
            __verticalBar.onChange.remove(__verticalBarChanged);
        }

        __verticalBar = value;

        if (__verticalBar != null) {
            addChild(__verticalBar);
            __verticalBar.onChange.add(__verticalBarChanged);
            __updateBar(__verticalBar, getMaxScrollY(), scrollY);
        }

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
            __updateBar(__horizontalBar, getMaxScrollX(), scrollX);
        }

        return value;
    }


    /**
     * Setter for `horizontalScroll`
     */
    private function set_horizontalScroll (value:Bool) : Bool
    {
        __dragScrollBehavior.horizontalScroll = value;
        if (__horizontalBar != null) {
            __horizontalBar.enabled = value;
        }

        return value;
    }


    /**
     * Setter for `verticalScroll`
     */
    private function set_verticalScroll (value:Bool) : Bool
    {
        __dragScrollBehavior.verticalScroll = value;
        if (__verticalBar != null) {
            __verticalBar.enabled = value;
        }

        return value;
    }


    /** Getters */
    private function get_dragging ()            return __dragScrollBehavior.dragging;
    private function get_scrolling ()           return __dragScrollBehavior.scrolling;
    private function get_horizontalScroll ()    return __dragScrollBehavior.horizontalScroll;
    private function get_verticalScroll ()      return __dragScrollBehavior.verticalScroll;
    private function get_horizontalBar ()       return __horizontalBar;
    private function get_verticalBar ()         return __verticalBar;
    private function get_dragScroll ()          return __dragScrollBehavior.enabled;

    /** Setters */
    private function set_dragging (v)            return __dragScrollBehavior.dragging = v;
    private function set_scrolling (v)           return __dragScrollBehavior.scrolling = v;
    private function set_dragScroll (v)          return __dragScrollBehavior.enabled = v;

    /** Signal getters */
    private function get_onScroll ()        return (__onScroll == null ? __onScroll = new Signal() : __onScroll);

}//class Scroll