package sx.widgets;

import sx.backend.IDisplay;
import sx.backend.IStage;
import sx.exceptions.NotChildException;
import sx.exceptions.OutOfBoundsException;
import sx.geom.Matrix;
import sx.geom.Unit;
import sx.properties.Coordinate;
import sx.properties.Size;
import sx.signals.MoveSignal;
import sx.signals.ResizeSignal;



/**
 * Base class for widgets
 *
 */
class Widget
{
    /** Parent widget */
    public var parent (get,never) : Null<Widget>;
    private var __parent : Widget;
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

    /** Widget's width */
    public var width (get,never) : Size;
    private var __width : Size;
    /** Widget's height */
    public var height (get,never) : Size;
    private var __height : Size;

    /** Visual representation of this widget */
    public var display (get,never) : IDisplay;
    private var __display : IDisplay;
    /** Stage instance this widget is rendered to */
    public var stage (get,never) : Null<IStage>;
    private var __stage : IStage;
    /** If was removed from stage or added to stage */
    private var __stageChanged : Bool = false;

    /** Signal dispatched when widget width or height is changed */
    public var onResize (default,null) : ResizeSignal;
    /** Signal dispatched when widget position is changed */
    public var onMove (default,null) : MoveSignal;

    /** Display list of this widget */
    private var __children : Array<Widget>;

    /** Global transformation matrix */
    private var __matrix : Matrix;
    /** If matrix should be recalculated */
    private var __invalidMatrix : Bool = true;




    /**
     * Cosntructor
     */
    public function new () : Void
    {
        __children = [];

        __width = new Size();
        __width.pctSource = __widthPctSourceProvider;
        __width.onChange  = __resized;

        __height = new Size();
        __height.pctSource = __heightPctSourceProvider;
        __height.onChange  = __resized;

        __left = new Coordinate();
        __left.pctSource = __widthPctSourceProvider;
        __left.onChange  = __moved;

        __right = new Coordinate();
        __right.pctSource = __widthPctSourceProvider;
        __right.onChange  = __moved;

        __top = new Coordinate();
        __top.pctSource = __heightPctSourceProvider;
        __top.onChange  = __moved;

        __bottom = new Coordinate();
        __bottom.pctSource = __heightPctSourceProvider;
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

        __matrix = new Matrix();
    }


    /**
     * Add `child` to display list of this widget.
     *
     * Returns added child.
     */
    public function addChild (child:Widget) : Widget
    {
        if (child.parent != null) child.parent.removeChild(child);

        __children.push(child);
        child.__parent = this;

        return child;
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
        if (child.parent != null) child.parent.removeChild(child);

        __children.insert(index, child);
        child.__parent = this;

        return child;
    }


    /**
     * Remove `child` from display list of this widget.
     *
     * Returns removed child.
     * Returns `null` if this widget is not a parent for this `child`.
     */
    public function removeChild (child:Widget) : Null<Widget>
    {
        if (__children.remove(child)) {
            child.__parent = null;

            return child;
        }

        return null;
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
        if (index < 0) index = __children.length + index;

        if (index < 0 || index >= __children.length) {
            return null;
        }

        var removed = __children.splice(index, 1)[0];
        removed.__parent = null;

        return removed;
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
        if (beginIndex < 0) beginIndex = __children.length + beginIndex;
        if (beginIndex < 0) beginIndex = 0;
        if (endIndex < 0) endIndex = __children.length + endIndex;

        if (beginIndex >= __children.length || endIndex < beginIndex) return 0;

        var removed = __children.splice(beginIndex, endIndex - beginIndex + 1);
        for (widget in removed) {
            widget.__parent = null;
        }

        return removed.length;
    }


    /**
     * Determines if `child` is this widget itself or if `child` is in display list of this widget at any depth.
     */
    public function contains (child:Widget) : Bool
    {
        if (child == this) return true;

        for (widget in __children) {
            if (widget.contains(child)) return true;
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
        var index = __children.indexOf(child);
        if (index < 0) throw new NotChildException();

        return index;
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
        var currentIndex = __children.indexOf(child);
        if (currentIndex < 0) throw new NotChildException();

        if (index < 0) index = __children.length + index;
        if (index < 0) {
            index = 0;
        } else if (index >= __children.length) {
            index = __children.length - 1;
        }

        if (index == currentIndex) return currentIndex;

        __children.remove(child);
        __children.insert(index, child);

        return index;
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
        if (index < 0) index = __children.length + index;

        if (index < 0 || index >= __children.length) {
            return null;
        }

        return __children[index];
    }


    /**
     * Swap two specified child widgets in display list.
     *
     * @throws sx.exceptions.NotChildException() If eighter `child1` or `child2` are not a child of this widget.
     */
    public function swapChildren (child1:Widget, child2:Widget) : Void
    {
        var index1 = __children.indexOf(child1);
        var index2 = __children.indexOf(child2);

        if (index1 < 0 || index2 < 0) throw new NotChildException();

        __children[index1] = child2;
        __children[index2] = child1;
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
        if (index1 < 0) index1 = __children.length + index1;
        if (index2 < 0) index2 = __children.length + index2;

        if (index1 < 0 || index1 >= __children.length || index2 < 0 || index2 > __children.length) {
            throw new OutOfBoundsException('Provided index does not exist in display list of this widget.');
        }

        var child = __children[index1];
        __children[index1] = __children[index2];
        __children[index2] = child;
    }


    /**
     * Force this widget to be updated during next rendering step.
     */
    public function invalidate () : Void
    {
        // if (!__renderUpdateRequired) {
        //     __renderUpdateRequired = true;
        //     var current = parent;

        //     while (current != null && !current.__renderUpdateRequired) {
        //         current.__renderUpdateRequired = true;
        //         current = current.parent;
        //     }
        // }
    }


    /**
     * Method to remove all external references to this object and release it for garbage collector.
     */
    public function dispose () : Void
    {
        if (__display != null) __display.dispose();
    }


    /**
     * Called when `width` or `height` is changed.
     */
    private function __resized (changed:Size, previousUnits:Unit, previousValue:Float) : Void
    {
        onResize.dispatch(this, changed, previousUnits, previousValue);
    }


    /**
     * Called when `left`, `right`, `bottom` or `top` are changed.
     */
    private function __moved (changed:Size, previousUnits:Unit, previousValue:Float) : Void
    {
        onMove.dispatch(this, changed, previousUnits, previousValue);
    }


    /**
     * Render this widget on `stage` at specified `displayIndex`.
     *
     * Returns display index for next widget to render.
     */
    private function __render (stage:IStage, displayIndex:Int) : Int
    {
        if (__invalidMatrix) {
            __updateMatrix();
        }

        if (__display != null) {
            __display.update(displayIndex);
            displayIndex++;
        }

        return displayIndex;
    }


    /**
     * Calculate global transformation matrix
     */
    private function __updateMatrix () : Void
    {
        __matrix.identity();
        // __matrix.scale(scaleX, scaleY);
        // __matrix.rotate(-rotation * Math.PI / 180);
        __matrix.translate(left.px, top.px);
        if (parent != null) {
            __matrix.concat(parent.__matrix);
        }
    }


    /**
     * Getter `display`.
     */
    private function get_display () : IDisplay
    {
        if (__display == null) {
            __display = Sx.backend.createDisplay(this);
        }

        return __display;
    }


    /**
     * Getter for `stage`
     */
    private function get_stage () : Null<IStage>
    {
        if (__stage != null) return __stage;

        var current = parent;
        while (current != null) {
            if (current.__stage != null) return current.__stage;
            current = current.parent;
        }

        return null;
    }


    /** Provides values for percentage calculations of `Size` instances */
    private function __widthPctSourceProvider () return (parent == null ? null : parent.width);
    private function __heightPctSourceProvider () return (parent == null ? null : parent.height);

    /** Getters */
    private function get_parent ()          return __parent;
    private function get_numChildren ()     return __children.length;
    private function get_width ()           return __width;
    private function get_height ()          return __height;
    private function get_left ()            return __left;
    private function get_right ()           return __right;
    private function get_top ()             return __top;
    private function get_bottom ()          return __bottom;


}//class Widget