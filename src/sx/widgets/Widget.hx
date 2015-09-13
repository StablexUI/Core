package sx.widgets;

import sx.backend.IDisplay;
import sx.backend.IStage;
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
    public var visible : Bool = true;

    /** Visual representation of this widget */
    public var display (get,never) : IDisplay;
    private var __display : IDisplay;
    /** Stage instance this widget is rendered to */
    public var stage (get,never) : Null<IStage>;
    private var __stage : IStage;

    /** Signal dispatched when widget width or height is changed */
    public var onResize (default,null) : ResizeSignal;
    /** Signal dispatched when widget position is changed */
    public var onMove (default,null) : MoveSignal;

    /** Validation flags. Indicates changed widget parameters which affect rendering. */
    public var validation (default,null) : Validation;

    /** Display list of this widget */
    private var __displayList : ArrayDisplayList;

    /** Global transformation matrix */
    private var __matrix : Matrix;


    /**
     * Cosntructor
     */
    public function new () : Void
    {
        validation = new Validation();

        __displayList = new ArrayDisplayList(this);

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

        __matrix = new Matrix();
    }


    /**
     * Add `child` to display list of this widget.
     *
     * Returns added child.
     */
    public function addChild (child:Widget) : Widget
    {
        __displayList.addChild(child.__displayList);

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
        __displayList.addChildAt(child.__displayList, index);

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
        var removed = __displayList.removeChild(child.__displayList);

        return (removed == null ? null : removed.widget);
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
        var removed = __displayList.removeChildAt(index);

        return (removed == null ? null : removed.widget);
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
        return __displayList.removeChildren(beginIndex, endIndex);
    }


    /**
     * Determines if `child` is this widget itself or if `child` is in display list of this widget at any depth.
     */
    public function contains (child:Widget) : Bool
    {
        return __displayList.contains(child.__displayList);
    }


    /**
     * Get index of a `child` in a list of children of this widget.
     *
     * @throws sx.exceptions.NotChildException If `child` is not direct child of this widget.
     */
    public function getChildIndex (child:Widget) : Int
    {
        return __displayList.getChildIndex(child.__displayList);
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
        return __displayList.setChildIndex(child.__displayList, index);
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
        var node = __displayList.getChildAt(index);

        return (node == null ? null : node.widget);
    }


    /**
     * Swap two specified child widgets in display list.
     *
     * @throws sx.exceptions.NotChildException() If eighter `child1` or `child2` are not a child of this widget.
     */
    public function swapChildren (child1:Widget, child2:Widget) : Void
    {
        __displayList.swapChildren(child1.__displayList, child2.__displayList);
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
        __displayList.swapChildrenAt(index1, index2);
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
        validation.invalidate(SIZE);
        onResize.dispatch(this, changed, previousUnits, previousValue);
    }


    /**
     * Called when `left`, `right`, `bottom` or `top` are changed.
     */
    private function __moved (changed:Size, previousUnits:Unit, previousValue:Float) : Void
    {
        validation.invalidate(MATRIX);
        onMove.dispatch(this, changed, previousUnits, previousValue);
    }


    /**
     * Called when `origin` is changed.
     */
    private function __originChanged (changed:Origin) : Void
    {
        validation.invalidate(MATRIX);
    }


    /**
     * Provides values for percentage calculations of width, left and right properties
     */
    private function __parentWidthProvider () : Null<Size>
    {
        if (parent != null) return parent.width;
        if (__stage != null) return __stage.getWidth();

        return null;
    }


    /**
     * Provides values for percentage calculations of height, top and bottom properties
     */
    private function __parentHeightProvider () : Null<Size>
    {
        if (parent != null) return parent.height;
        if (__stage != null) return __stage.getHeight();

        return null;
    }


    /**
     * Render this widget and his children on `renderData.stage` at `renderData.displayIndex`.
     *
     */
    private function __render (renderData:RenderData, globalAlpha:Float = 1) : Void
    {
        if (!visible) return;

        if (validation.isDirty()) {
            __renderThis(renderData, globalAlpha);
        }
        if (__displayList.numChildren > 0) {
            __renderChildren(renderData, globalAlpha);
        }

        validation.reset();
    }


    /**
     * Render this widget
     */
    private inline function __renderThis (renderData:RenderData, globalAlpha:Float) : Void
    {
        if (validation.isInvalid(MATRIX)) {
            __updateMatrix();
        }

        if (__display != null) {
            __display.update(renderData, globalAlpha * alpha);
            renderData.displayIndex++;
        }
    }


    /**
     * Render children of this widget
     */
    private inline function __renderChildren (renderData:RenderData, globalAlpha:Float) : Void
    {
        globalAlpha *= alpha;
        for (child in __displayList.children) {
            if (!child.widget.visible) continue;

            if (validation.isDirty()) {
                __invalidateChild(child.widget);
            }

            child.widget.__render(renderData, globalAlpha);
        }
    }


    /**
     * Set parent-dependent validation flags for `child`
     */
    private function __invalidateChild (child:Widget) : Void
    {
        if (validation.isInvalid(MATRIX)) {
            child.validation.invalidate(MATRIX);
        }
        if (validation.isInvalid(SIZE)) {
            if (child.validation.isValid(SIZE) && child.__sizeDependsOnParent()) {
                child.validation.invalidate(SIZE);
            }
            if (child.validation.isValid(MATRIX) && child.__positionDependsOnParent()) {
                child.validation.invalidate(MATRIX);
            }
        }
    }


    /**
     * Calculate global transformation matrix
     */
    private inline function __updateMatrix () : Void
    {
        __matrix.identity();
        if (__origin != null) {
            __matrix.translate(-__origin.left.px, -__origin.top.px);
        }
        if (rotation != 0) {
            __matrix.rotate(rotation * Math.PI / 180);
        }
        if (scaleX != 0 || scaleY != 0) {
            __matrix.scale(scaleX, scaleY);
        }
        __matrix.translate(left.px, top.px);

        if (parent != null) {
            __matrix.concat(parent.__matrix);
        }
    }


    /**
     * Check if `width` or `height` as `Percent` units
     */
    private inline function __sizeDependsOnParent () : Bool
    {
        return (width.units == Percent || height.units == Percent);
    }


    /**
     * Check if widget's position is determined by parent's size.
     */
    private function __positionDependsOnParent () : Bool
    {
        var left = this.left;
        if (left.selected && left.units == Percent) return true;
        if (right.selected) return true;

        var top = this.top;
        if (top.selected && top.units == Percent) return true;
        if (bottom.selected) return true;

        return false;
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


    /**
     * Setter for `rotation`
     */
    private function set_rotation (rotation:Float) : Float
    {
        validation.invalidate(MATRIX);

        return this.rotation = rotation;
    }


    /**
     * Setter for `scaleX`
     */
    private function set_scaleX (scaleX:Float) : Float
    {
        validation.invalidate(MATRIX);

        return this.scaleX = scaleX;
    }


    /**
     * Setter for `scaleY`
     */
    private function set_scaleY (scaleY:Float) : Float
    {
        validation.invalidate(MATRIX);

        return this.scaleY = scaleY;
    }


    /**
     * Setter for `alpha`
     */
    private function set_alpha (alpha:Float) : Float
    {
        validation.invalidate(ALPHA);

        return this.alpha = alpha;
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
    private function get_parent ()          return (__displayList.parent == null ? null : __displayList.parent.widget);
    private function get_numChildren ()     return __displayList.numChildren;
    private function get_width ()           return __width;
    private function get_height ()          return __height;
    private function get_left ()            return __left;
    private function get_right ()           return __right;
    private function get_top ()             return __top;
    private function get_bottom ()          return __bottom;


}//class Widget