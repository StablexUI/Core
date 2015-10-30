package sx.ds;



/**
 * Doubly-linked list
 *
 */
class LinkedList<T>
{
    /** first item */
    public var first (get,never) : Null<T>;
    /** last item */
    public var last (get,never) : Null<T>;
    /** Indicates if list has no items */
    public var empty (get,never) : Bool;
    /** First node in list (holds first item) */
    private var __firstNode : LinkedNode<T>;

    /** for internal usage */
    private var __tmpNode : LinkedNode<T>;


    /**
     * Constructor
     */
    public function new () : Void
    {

    }


    /**
     * Push item to the end of list
     */
    public function push (item:T) : Void
    {
        //first item in list
        if (__firstNode == null) {
            __tmpNode   = new LinkedNode();
            __firstNode = __tmpNode;
            __firstNode.previous = __tmpNode;

        //first item when list already had items
        } else if (__firstNode.item == null){
            __tmpNode = __firstNode;

        //no free nodes available
        } else if (__firstNode.previous.next == null) {
            __tmpNode = new LinkedNode();
            __firstNode.previous.linkNext(__tmpNode);
            __firstNode.previous = __tmpNode;

        //use available node
        } else {
            __tmpNode = __firstNode.previous.next;
            __firstNode.previous = __tmpNode;
        }

        __tmpNode.item = item;
    }


    /**
     * Insert item in the beginning of list
     */
    public function unshift (item:T) : Void
    {
        //first item in list
        if (__firstNode == null) {
            __tmpNode   = new LinkedNode();
            __firstNode = __tmpNode;
            __firstNode.previous = __tmpNode;
        //first item when list already had items
        } else if (__firstNode.item == null){
            __tmpNode = __firstNode;

        //no free nodes available
        } else if (__firstNode.previous.next == null) {
            __tmpNode = new LinkedNode();
            if (__firstNode.previous.item == null) {
                __tmpNode.previous = __tmpNode;
            } else {
                __tmpNode.previous = __firstNode.previous;
            }
            __tmpNode.linkNext(__firstNode);
            __firstNode = __tmpNode;

        //use available node
        } else {
            __tmpNode = __firstNode.previous.next;
            __tmpNode.previous.linkNext(__tmpNode.next);
            __tmpNode.previous = __tmpNode.previous.next;
            __tmpNode.linkNext(__firstNode);
            __firstNode = __tmpNode;
        }

        __tmpNode.item = item;
    }


    /**
     * Remove `item`.
     *
     * Returns `true` if `item` was in list and was removed.
     */
    public function remove (item:T) : Bool
    {
        __tmpNode = __firstNode;
        while (__tmpNode != null && __tmpNode.item != null) {
            if (item == __tmpNode.item) {
                if (__firstNode == __tmpNode) {
                    if (__firstNode.next != null) {
                        __firstNode = __firstNode.next;
                        __tmpNode.linkNext(__tmpNode.previous.next);
                        __tmpNode.linkPrevious(__tmpNode.previous);
                    }
                } else {
                    __tmpNode.previous.linkNext(__tmpNode.next);
                    if (__firstNode.previous != __tmpNode) {
                        __tmpNode.linkNext(__firstNode.previous.next);
                        __tmpNode.linkPrevious(__firstNode.previous);
                    }
                }
                __firstNode.previous = __tmpNode.previous;

                __tmpNode.item = null;

                return true;
            }
            __tmpNode = __tmpNode.next;
        }

        return false;
    }


    /**
     * Remove all items from this list
     */
    public function clear () : Void
    {
        __tmpNode = __firstNode;
        while (__tmpNode != null && __tmpNode.item != null) {
            __tmpNode.item = null;
            __tmpNode = __tmpNode.next;
        }
    }


    /**
     * Remove first item
     *
     */
    public function shift () : Null<T>
    {
        if (__firstNode == null) return null;

        var item = __firstNode.item;

        __firstNode.item = null;
        if (__firstNode.next != null) {
            __tmpNode = __firstNode;
            __firstNode = __firstNode.next;
            __firstNode.previous = __tmpNode.previous;
            __tmpNode.linkNext(__firstNode.previous.next);
            __tmpNode.linkPrevious(__firstNode.previous);
        }

        return item;
    }


    /**
     * Remove last item
     *
     */
    public function pop () : Null<T>
    {
        if (__firstNode == null) return null;

        var item = __firstNode.previous.item;

        __firstNode.previous = __firstNode.previous.previous;

        return item;
    }


    /**
     * Getter `first`
     */
    private function get_first () : Null<T>
    {
        return (__firstNode == null ? null : __firstNode.item);
    }


    /**
     * Getter `last`
     */
    private function get_last () : Null<T>
    {
        return (__firstNode == null ? null : __firstNode.previous.item);
    }

    /**
     * Getter `empty`
     */
    private function get_empty () : Bool
    {
        return (__firstNode == null || __firstNode.item == null);
    }

}//class LinkedList



/**
 * Nodes for `LinkedList`
 *
 */
private class LinkedNode<T>
{

    /** Next node */
    public var next : LinkedNode<T>;
    /** Previous node */
    public var previous : LinkedNode<T>;
    /** Stored item */
    public var item : T;


    /**
     * Constructor
     */
    public function new () : Void
    {

    }


    /**
     * Connect with next node
     */
    public inline function linkNext (node:Null< LinkedNode<T> >) : Void
    {
        next = node;
        if (node != null) node.previous = this;
    }


    /**
     * Connect with previous node
     */
    public inline function linkPrevious (node:Null< LinkedNode<T> >) : Void
    {
        previous = node;
        if (node != null) node.next = this;
    }

}//class LinkedNode
