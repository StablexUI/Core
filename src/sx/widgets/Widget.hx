package sx.widgets;

import sx.backend.IDisplay;
import sx.backend.IStage;
import sx.exceptions.NotChildException;
import sx.exceptions.OutOfBoundsException;
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
    private var zz_parent (default,set) : Widget;
    /** Get amount of children */
    public var numChildren (get,never): Int;

    /** Position along X-axis measured from parent widget's left border */
    public var left (get,never) : Coordinate;
    private var zz_left : Coordinate;
    /** Position along X-axis measured from parent widget's right border */
    public var right (get,never) : Coordinate;
    private var zz_right : Coordinate;
    /** Position along Y-axis measured from parent widget's top border */
    public var top (get,never) : Coordinate;
    private var zz_top : Coordinate;
    /** Position along Y-axis measured from parent widget's bottom border */
    public var bottom (get,never) : Coordinate;
    private var zz_bottom : Coordinate;

    /** Widget's width */
    public var width (get,never) : Size;
    private var zz_width : Size;
    /** Widget's height */
    public var height (get,never) : Size;
    private var zz_height : Size;

    /** Visual representation of this widget */
    public var display (get,never) : IDisplay;
    private var zz_display : IDisplay;
    /** Stage instance this widget is rendered to */
    public var stage (get,never) : Null<IStage>;
    private var zz_stage (default,set) : IStage;
    /** If was removed from stage or added to stage */
    private var zz_stageChanged : Bool = false;

    /** Signal dispatched when widget width or height is changed */
    public var onResize (default,null) : ResizeSignal;
    /** Signal dispatched when widget position is changed */
    public var onMove (default,null) : MoveSignal;

    /** Display list of this widget */
    private var zz_children : Array<Widget>;

    /** Indicates that this widget requires update during next rendering step */
    private var zz_renderUpdateRequired : Bool = false;


    /**
     * Cosntructor
     */
    public function new () : Void
    {
        zz_children = [];

        zz_width = new Size();
        zz_width.pctSource = widthPctSourceProvider;
        zz_width.onChange  = resized;

        zz_height = new Size();
        zz_height.pctSource = heightPctSourceProvider;
        zz_height.onChange  = resized;

        zz_left = new Coordinate();
        zz_left.pctSource = widthPctSourceProvider;
        zz_left.onChange  = moved;

        zz_right = new Coordinate();
        zz_right.pctSource = widthPctSourceProvider;
        zz_right.onChange  = moved;

        zz_top = new Coordinate();
        zz_top.pctSource = heightPctSourceProvider;
        zz_top.onChange  = moved;

        zz_bottom = new Coordinate();
        zz_bottom.pctSource = heightPctSourceProvider;
        zz_bottom.onChange  = moved;

        zz_left.pair      = get_right;
        zz_right.pair     = get_left;
        zz_top.pair       = get_bottom;
        zz_bottom.pair    = get_top;
        zz_left.ownerSize = zz_right.ownerSize = get_width;
        zz_top.ownerSize  = zz_bottom.ownerSize = get_height;

        zz_left.select();
        zz_top.select();

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
        if (child.parent != null) child.parent.removeChild(child);

        zz_children.push(child);
        child.zz_parent = this;

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

        zz_children.insert(index, child);
        child.zz_parent = this;

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
        if (zz_children.remove(child)) {
            child.zz_parent = null;

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
        if (index < 0) index = zz_children.length + index;

        if (index < 0 || index >= zz_children.length) {
            return null;
        }

        var removed = zz_children.splice(index, 1)[0];
        removed.zz_parent = null;

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
        if (beginIndex < 0) beginIndex = zz_children.length + beginIndex;
        if (beginIndex < 0) beginIndex = 0;
        if (endIndex < 0) endIndex = zz_children.length + endIndex;

        if (beginIndex >= zz_children.length || endIndex < beginIndex) return 0;

        var removed = zz_children.splice(beginIndex, endIndex - beginIndex + 1);
        for (i in 0...removed.length) {
            removed[i].zz_parent = null;
        }

        return removed.length;
    }


    /**
     * Determines if `child` is this widget itself or if `child` is in display list of this widget at any depth.
     */
    public function contains (child:Widget) : Bool
    {
        if (child == this) return true;

        for (i in 0...zz_children.length) {
            if (zz_children[i].contains(child)) return true;
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
        var index = zz_children.indexOf(child);
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
        var currentIndex = zz_children.indexOf(child);
        if (currentIndex < 0) throw new NotChildException();

        if (index < 0) index = zz_children.length + index;
        if (index < 0) {
            index = 0;
        } else if (index >= zz_children.length) {
            index = zz_children.length - 1;
        }

        if (index == currentIndex) return currentIndex;

        zz_children.remove(child);
        zz_children.insert(index, child);

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
        if (index < 0) index = zz_children.length + index;

        if (index < 0 || index >= zz_children.length) {
            return null;
        }

        return zz_children[index];
    }


    /**
     * Swap two specified child widgets in display list.
     *
     * @throws sx.exceptions.NotChildException() If eighter `child1` or `child2` are not a child of this widget.
     */
    public function swapChildren (child1:Widget, child2:Widget) : Void
    {
        var index1 = zz_children.indexOf(child1);
        var index2 = zz_children.indexOf(child2);

        if (index1 < 0 || index2 < 0) throw new NotChildException();

        zz_children[index1] = child2;
        zz_children[index2] = child1;
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
        if (index1 < 0) index1 = zz_children.length + index1;
        if (index2 < 0) index2 = zz_children.length + index2;

        if (index1 < 0 || index1 >= zz_children.length || index2 < 0 || index2 > zz_children.length) {
            throw new OutOfBoundsException('Provided index does not exist in display list of this widget.');
        }

        var child = zz_children[index1];
        zz_children[index1] = zz_children[index2];
        zz_children[index2] = child;
    }


    /**
     * Indicates whether this widget is attached directly to stage.
     */
    public inline function isRoot () : Bool
    {
        return (parent == null && stage != null);
    }


    /**
     * Force this widget to be updated during next rendering step.
     */
    public function invalidate () : Void
    {
        // if (!zz_renderUpdateRequired) {
        //     zz_renderUpdateRequired = true;
        //     var current = parent;

        //     while (current != null && !current.zz_renderUpdateRequired) {
        //         current.zz_renderUpdateRequired = true;
        //         current = current.parent;
        //     }
        // }
    }


    /**
     * Method to remove all external references to this object and release it for garbage collector.
     */
    public function dispose () : Void
    {
        if (zz_display != null) zz_display.dispose();
    }


    /**
     * Called when `width` or `height` is changed.
     */
    private function resized (changed:Size, previousUnits:Unit, previousValue:Float) : Void
    {
        onResize.dispatch(this, changed, previousUnits, previousValue);
    }


    /**
     * Called when `left`, `right`, `bottom` or `top` are changed.
     */
    private function moved (changed:Size, previousUnits:Unit, previousValue:Float) : Void
    {
        onMove.dispatch(this, changed, previousUnits, previousValue);
    }


    /**
     * Getter `display`.
     */
    private function get_display () : IDisplay
    {
        if (zz_display == null) {
            zz_display = Sx.backend.createDisplay(this);
        }

        return zz_display;
    }


    /**
     * Setter `zz_stage`.
     */
    private function set_zz_stage (value:IStage) : IStage
    {
        zz_stageChanged = true;
        zz_stage = value;

        for (i in 0...zz_children.length) {
            zz_children[i].zz_stage = value;
        }

        return value;
    }


    /**
     * Setter `zz_parent`
     */
    private function set_zz_parent (value:Widget) : Widget
    {
        return zz_parent = value;
    }


    /** Provides values for percentage calculations of `Size` instances */
    private function widthPctSourceProvider () return (parent == null ? null : parent.width);
    private function heightPctSourceProvider () return (parent == null ? null : parent.height);

    /** Getters */
    private function get_parent ()          return zz_parent;
    private function get_numChildren ()     return zz_children.length;
    private function get_width ()           return zz_width;
    private function get_height ()          return zz_height;
    private function get_left ()            return zz_left;
    private function get_right ()           return zz_right;
    private function get_top ()             return zz_top;
    private function get_bottom ()          return zz_bottom;
    private function get_stage ()           return zz_stage;


}//class Widget