package sx.widgets;

import sx.exceptions.NotChildException;



/**
 * Base class for widgets
 *
 */
class Widget
{
    /** Parent widget */
    public var parent (get,set) : Null<Widget>;
    private var zz_parent : Widget;
    /** Get amount of children */
    public var numChildren (get,never): Int;

    /** Display list of this widget */
    private var zz_children : Array<Widget>;



    /**
     * Cosntructor
     *
     */
    public function new () : Void
    {
        zz_children = [];
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
        child.parent = this;

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
        child.parent = this;

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
            child.parent = null;

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
        removed.parent = null;

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
            removed[i].parent = null;
        }

        return removed.length;
    }


    /**
     * Determines if `child` is this widget itself or if `child` is in display list of this widget at any depth.
     *
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


    /** Getters */
    private function get_parent ()          return zz_parent;
    private function get_numChildren ()     return zz_children.length;

    /** Setters */
    private function set_parent (v)         return zz_parent = v;

}//class Widget