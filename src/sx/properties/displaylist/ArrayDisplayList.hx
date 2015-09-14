package sx.properties.displaylist;


import sx.exceptions.NotChildException;
import sx.exceptions.OutOfBoundsException;
import sx.widgets.Widget;


/**
 * Array based display list
 *
 */
class ArrayDisplayList
{
    /** Owner of this node */
    public var widget (default,null) : Widget;
    /** Parent node for this one */
    public var parent (default,null) : ArrayDisplayList;
    /** Amount of children */
    public var numChildren (get,never) : Int;

    /** Children of this node */
    public var children (default,null) : Array<ArrayDisplayList>;


    /**
     * Constructor
     */
    public function new (widget:Widget) : Void
    {
        this.widget = widget;
        children = [];
    }


    /**
     * Add `child` to this display list.
     *
     * Returns added child.
     */
    public inline function addChild (child:ArrayDisplayList) : ArrayDisplayList
    {
        if (child.parent != null) child.parent.removeChild(child);

        children.push(child);
        child.parent = this;

        return child;
    }


    /**
     * Insert `child` at specified `index` of this display list.
     *
     * If `index` is negative, calculate required index from the end of display list (`numChildren` + index).
     * If `index` is out of bounds, `child` will be added to the end (positive `index`) or to the beginning
     * (negative `index`) of display list.
     *
     * Returns added `child`.
     */
    public inline function addChildAt (child:ArrayDisplayList, index:Int) : ArrayDisplayList
    {
        if (child.parent != null) child.parent.removeChild(child);

        children.insert(index, child);
        child.parent = this;

        return child;
    }


    /**
     * Remove `child` from this display list.
     *
     * Returns removed child.
     * Returns `null` if this node is not a parent for `child`.
     */
    public inline function removeChild (child:ArrayDisplayList) : Null<ArrayDisplayList>
    {
        if (child.parent == this) {
            children.remove(child);
            child.parent = null;

            return child;
        } else {
            return null;
        }
    }


    /**
     * Remove child at `index` of this display list.
     *
     * If `index` is negative, calculate required index from the end of display list (`numChildren` + index).
     *
     * Returns removed child or `null` if `index` is out of bounds.
     */
    public inline function removeChildAt (index:Int) : Null<ArrayDisplayList>
    {
        if (index < 0) index = children.length + index;

        if (index < 0 || index >= children.length) {

            return null;

        } else {
            var removed = children.splice(index, 1)[0];
            removed.parent = null;

            return removed;
        }
    }


    /**
     * Remove all children starting from child with `beginIndex` position to child with `endIndex` (including).
     *
     * If index is negative, find required child from the end of display list.
     *
     * Returns amount of removed children.
     */
    public inline function removeChildren (beginIndex:Int = 0, endIndex:Int = -1) : Int
    {
        if (beginIndex < 0) beginIndex = children.length + beginIndex;
        if (beginIndex < 0) beginIndex = 0;
        if (endIndex < 0) endIndex = children.length + endIndex;

        if (beginIndex >= children.length || endIndex < beginIndex) return 0;

        var removed = children.splice(beginIndex, endIndex - beginIndex + 1);
        for (node in removed) {
            node.parent = null;
        }

        return removed.length;
    }


    /**
     * Determines if `child` is this node itself or if `child` is in display list of this node at any depth.
     */
    public inline function contains (child:ArrayDisplayList) : Bool
    {
        var found = false;

        while (child != null) {
            if (child == this) {
                found = true;
                break;
            }
            child = child.parent;
        }

        return found;
    }


    /**
     * Get index of a `child` in a list of children of this node.
     *
     * @throws sx.exceptions.NotChildException If `child` is not direct child of this node.
     */
    public inline function getChildIndex (child:ArrayDisplayList) : Int
    {
        var index = children.indexOf(child);
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
    public inline function setChildIndex (child:ArrayDisplayList, index:Int) : Int
    {
        var currentIndex = children.indexOf(child);
        if (currentIndex < 0) throw new NotChildException();

        if (index < 0) index = children.length + index;
        if (index < 0) {
            index = 0;
        } else if (index >= children.length) {
            index = children.length - 1;
        }

        if (index != currentIndex) {
            children.remove(child);
            children.insert(index, child);

            return index;
        } else {
            return currentIndex;
        }
    }


    /**
     * Get child at specified `index`.
     *
     * If `index` is negative, required child is calculated from the end of display list.
     *
     * Returns child located at `index`, or returns `null` if `index` is out of bounds.
     */
    public inline function getChildAt (index:Int) : Null<ArrayDisplayList>
    {
        if (index < 0) index = children.length + index;

        if (index < 0 || index >= children.length) {
            return null;
        } else {
            return children[index];
        }
    }


    /**
     * Swap two specified child widgets in display list.
     *
     * @throws sx.exceptions.NotChildException() If eighter `child1` or `child2` are not a child of this widget.
     */
    public inline function swapChildren (child1:ArrayDisplayList, child2:ArrayDisplayList) : Void
    {
        var index1 = children.indexOf(child1);
        var index2 = children.indexOf(child2);

        if (index1 < 0 || index2 < 0) throw new NotChildException();

        children[index1] = child2;
        children[index2] = child1;
    }


    /**
     * Swap children at specified indexes.
     *
     * If indices are negative, required children are calculated from the end of display list.
     *
     * @throws sx.exceptions.OutOfBoundsException
     */
    public inline function swapChildrenAt (index1:Int, index2:Int) : Void
    {
        if (index1 < 0) index1 = children.length + index1;
        if (index2 < 0) index2 = children.length + index2;

        if (index1 < 0 || index1 >= children.length || index2 < 0 || index2 > children.length) {
            throw new OutOfBoundsException('Provided index does not exist in display list of this widget.');
        }

        var child = children[index1];
        children[index1] = children[index2];
        children[index2] = child;
    }


    /** Getters */
    private inline function get_numChildren () return children.length;

}//class ArrayDisplayList