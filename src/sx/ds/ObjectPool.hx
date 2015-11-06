package sx.ds;



/**
 * Object pool container
 *
 */
class ObjectPool<T>
{
    /** Amount of objects currently stored in this pool */
    public var length (default,null) : Int = 0;
    /** Stored objects */
    private var __pool : Array<T>;


    /**
     * Constructor
     */
    public function new () : Void
    {
        __pool = [];
    }


    /**
     * Push object to this pool
     */
    public inline function push (obj:T) : Void
    {
        __pool[length] = obj;
        length++;
    }


    /**
     * Get object from this pool
     */
    public inline function pop () : Null<T>
    {
        if (length > 0) {
            length--;
            return __pool[length];
        } else {
            return null;
        }
    }


    /**
     * Remove all objects from this pool
     */
    public inline function clear () : Void
    {
        for (i in 0...length) {
            __pool[i] = null;
        }
        length = 0;
    }

}//class ObjectPool