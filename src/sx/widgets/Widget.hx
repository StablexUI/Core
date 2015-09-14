package sx.widgets;

import sx.backend.TBackend;
import sx.exceptions.NotChildException;
import sx.exceptions.OutOfBoundsException;
import sx.geom.Matrix;
import sx.geom.Unit;
import sx.properties.Coordinate;
import sx.properties.displaylist.ArrayDisplayList;
import sx.properties.Origin;
import sx.properties.Size;
import sx.properties.Validation;
import sx.signals.MoveSignal;
import sx.signals.ResizeSignal;
import sx.Sx;


/**
 * Base class for widgets
 *
 */
class Widget
{
    /** Parent widget */
    public var parent (get,never) : Null<Widget>;
    /** Get amount of children */
    public var numChildren (get,never): Int;

    /** Position along X-axis measured from parent widget's left border */
    public var left (get,never) : Coordinate;
    private var __left : Coordinate;
    /** Position along X-axis measured from parent widget's right border */
    public var right (get,never) : Coordinate;
    private var __right : Coordinate;
    /** Position along Y-axis measured from parent widget's top border */
    public var top (get,never) : Coordinate;
    private var __top : Coordinate;
    /** Position along Y-axis measured from parent widget's bottom border */
    public var bottom (get,never) : Coordinate;
    private var __bottom : Coordinate;

    /** Origin point. By default it's top left corner. */
    public var origin (get,never) : Origin;
    private var __origin : Origin;

    /** Widget's width */
    public var width (get,never) : Size;
    private var __width : Size;
    /** Widget's height */
    public var height (get,never) : Size;
    private var __height : Size;

    /** Scale along X axis */
    public var scaleX (default,set) : Float = 1;
    /** Scale along Y axis */
    public var scaleY (default,set) : Float = 1;

    /** Clockwise rotation (degrees) */
    public var rotation (default,set) : Float = 0;

    /**
     * Transparency.
     * `0` - fully transparent.
     * `1` - fully opaque.
     */
    public var alpha (default,set) : Float = 1;
    /** Whether or not the display object is visible. */
    public var visible (default,set) : Bool = true;

    /** "Native" backend */
    public var backend (default,null) : TBackend;

    /** Signal dispatched when widget width or height is changed */
    public var onResize (default,null) : ResizeSignal;
    /** Signal dispatched when widget position is changed */
    public var onMove (default,null) : MoveSignal;


    /**
     * Cosntructor
     */
    public function new () : Void
    {
        __createBackend();

        __width = new Size();
        __width.pctSource = __parentWidthProvider;
        __width.onChange  = __resized;

        __height = new Size();
        __height.pctSource = __parentHeightProvider;
        __height.onChange  = __resized;

        __left = new Coordinate();
        __left.pctSource = __parentWidthProvider;
        __left.onChange  = __moved;

        __right = new Coordinate();
        __right.pctSource = __parentWidthProvider;
        __right.onChange  = __moved;

        __top = new Coordinate();
        __top.pctSource = __parentHeightProvider;
        __top.onChange  = __moved;

        __bottom = new Coordinate();
        __bottom.pctSource = __parentHeightProvider;
        __bottom.onChange  = __moved;

        __left.pair      = get_right;
        __right.pair     = get_left;
        __top.pair       = get_bottom;
        __bottom.pair    = get_top;
        __left.ownerSize = __right.ownerSize = get_width;
        __top.ownerSize  = __bottom.ownerSize = get_height;

        __left.select();
        __top.select();

        onResize = new ResizeSignal();
        onMove   = new MoveSignal();
    }


    /**
     * Add `child` to display list of this widget.
     *
     * Returns added child.
     */
    public function addChild (child:Widget) : Widget
    {
        return backend.addWidget(child);
    }


    /**
     * Insert `child` at specified `index` of display list of this widget..
     *
     * If `index` is negative, calculate required index from the end of display list (`numChildren` + index).
     * If `index` is out of bounds, `child` will be added to the end (positive `index`) or to the beginning
     * (negative `index`) of display list.
     *
     * Returns added `child`.
     */
    public function addChildAt (child:Widget, index:Int) : Widget
    {
        return backend.addWidgetAt(child, index);
    }


    /**
     * Remove `child` from display list of this widget.
     *
     * Returns removed child.
     * Returns `null` if this widget is not a parent for this `child`.
     */
    public function removeChild (child:Widget) : Null<Widget>
    {
        return backend.removeWidget(child);
    }


    /**
     * Remove child at `index` of display list of this widget.
     *
     * If `index` is negative, calculate required index from the end of display list (`numChildren` + index).
     *
     * Returns removed child or `null` if `index` is out of bounds.
     */
    public function removeChildAt (index:Int) : Null<Widget>
    {
        return backend.removeWidgetAt(index);
    }


    /**
     * Remove all children from child with `beginIndex` position to child with `endIndex` (including).
     *
     * If index is negative, find required child from the end of display list.
     *
     * Returns amount of children removed.
     */
    public function removeChildren (beginIndex:Int = 0, endIndex:Int = -1) : Int
    {
        return backend.removeWidgets(beginIndex, endIndex);
    }


    /**
     * Determines if `child` is this widget itself or if `child` is in display list of this widget at any depth.
     */
    public function contains (child:Widget) : Bool
    {
        while (child != null) {
            if (child == this) return true;
            child = child.parent;
        }

        return false;
    }


    /**
     * Get index of a `child` in a list of children of this widget.
     *
     * @throws sx.exceptions.NotChildException If `child` is not direct child of this widget.
     */
    public function getChildIndex (child:Widget) : Int
    {
        return backend.getWidgetIndex(child);
    }


    /**
     * Move `child` to specified `index` in display list.
     *
     * If `index` is greater then amount of children, `child` will be added to the end of display list.
     * If `index` is negative, required position will be calculated from the end of display list.
     * If `index` is negative and calculated position is less than zero, `child` will be added at the beginning of display list.
     *
     * Returns new position of a `child` in display list.
     *
     * @throws sx.exceptions.NotChildException If `child` is not direct child of this widget.
     */
    public function setChildIndex (child:Widget, index:Int) : Int
    {
        return backend.setWidgetIndex(child, index);
    }


    /**
     * Get child at specified `index`.
     *
     * If `index` is negative, required child is calculated from the end of display list.
     *
     * Returns child located at `index`, or returns `null` if `index` is out of bounds.
     */
    public function getChildAt (index:Int) : Null<Widget>
    {
        return backend.getWidgetAt(index);
    }


    /**
     * Swap two specified child widgets in display list.
     *
     * @throws sx.exceptions.NotChildException() If eighter `child1` or `child2` are not a child of this widget.
     */
    public function swapChildren (child1:Widget, child2:Widget) : Void
    {
        backend.swapWidgets(child1, child2);
    }


    /**
     * Swap children at specified indexes.
     *
     * If indices are negative, required children are calculated from the end of display list.
     *
     * @throws sx.exceptions.OutOfBoundsException
     */
    public function swapChildrenAt (index1:Int, index2:Int) : Void
    {
        backend.swapWidgetsAt(index1, index2);
    }


    /**
     * Method to cleanup and release this object for garbage collector.
     */
    public function dispose (disposeChildren:Bool = true) : Void
    {
        if (parent != null) {
            parent.removeChild(this);
        }

        if (disposeChildren) {
            while (numChildren > 0) getChildAt(0).dispose(true);
        } else {
            removeChildren();
        }

        backend.dispose();
    }


    /**
     * Set backend instance
     */
    private function __createBackend () : Void
    {
        backend = Sx.backendFactory.forWidget(this);
    }


    /**
     * Called when `width` or `height` is changed.
     */
    private function __resized (changed:Size, previousUnits:Unit, previousValue:Float) : Void
    {
        backend.resized();
        onResize.dispatch(this, changed, previousUnits, previousValue);
    }


    /**
     * Called when `left`, `right`, `bottom` or `top` are changed.
     */
    private function __moved (changed:Size, previousUnits:Unit, previousValue:Float) : Void
    {
        backend.moved();
        onMove.dispatch(this, changed, previousUnits, previousValue);
    }


    /**
     * Called when `origin` is changed.
     */
    private function __originChanged () : Void
    {
        backend.originChanged();
    }


    /**
     * Provides values for percentage calculations of width, left and right properties
     */
    private function __parentWidthProvider () : Null<Size>
    {
        return (parent == null ? null : parent.width);
    }


    /**
     * Provides values for percentage calculations of height, top and bottom properties
     */
    private function __parentHeightProvider () : Null<Size>
    {
        return (parent == null ? null : parent.height);
    }


    /**
     * Setter for `rotation`
     */
    private function set_rotation (rotation:Float) : Float
    {
        this.rotation = rotation;
        backend.rotated();

        return rotation;
    }


    /**
     * Setter for `scaleX`
     */
    private function set_scaleX (scaleX:Float) : Float
    {
        this.scaleX = scaleX;
        backend.scaledX();

        return scaleX;
    }


    /**
     * Setter for `scaleY`
     */
    private function set_scaleY (scaleY:Float) : Float
    {
        this.scaleY = scaleY;
        backend.scaledY();

        return scaleY;
    }


    /**
     * Setter for `alpha`
     */
    private function set_alpha (alpha:Float) : Float
    {
        this.alpha = alpha;
        backend.alphaChanged();

        return alpha;
    }


    /**
     * Setter `visible`
     */
    private function set_visible (visible:Bool) : Bool
    {
        this.visible = visible;
        backend.visibilityChanged();

        return visible;
    }


    /**
     * Getter for `origin`
     */
    private function get_origin () : Origin
    {
        if (__origin == null) {
            __origin = new Origin(get_width, get_height);
            __origin.onChange = __originChanged;
        }

        return __origin;
    }


    /** Getters */
    private function get_numChildren ()     return backend.getNumChildren();
    private function get_parent ()          return backend.getParent();
    private function get_width ()           return __width;
    private function get_height ()          return __height;
    private function get_left ()            return __left;
    private function get_right ()           return __right;
    private function get_top ()             return __top;
    private function get_bottom ()          return __bottom;


}//class Widget