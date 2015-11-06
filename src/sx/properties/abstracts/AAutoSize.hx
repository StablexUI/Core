package sx.properties.abstracts;

import sx.ds.ObjectPool;
import sx.properties.AutoSize;


/**
 * Abstract to be able to write boleans directly to `AutoSize` instances.
 *
 */
@:forward(width,height,set,onChange,either,neither,both)
abstract AAutoSize (AutoSize) from AutoSize to AutoSize
{
    /** Object pool */
    static private var __pool : ObjectPool<WeakAutoSize> = new ObjectPool();


    /**
     * Create from boolean
     */
    @:access(sx.properties.AutoSize.weak)
    @:from static private function fromBool (v:Bool) : AAutoSize
    {
        var weakAutoSize = __pool.pop();
        if (weakAutoSize == null) weakAutoSize = new WeakAutoSize();
        weakAutoSize.weak = true;
        weakAutoSize.width  = v;
        weakAutoSize.height = v;

        return weakAutoSize;
    }


}//abstract AAutoSize



/**
 * For temporary instances used just to pass values to other instances
 *
 */
@:access(sx.properties.abstracts.AAutoSize.__pool)
private class WeakAutoSize extends AutoSize
{

    /**
     * Constructor
     */
    public function new () : Void
    {
        super();
        onChange = null;
    }


    /**
     * Return to object pool
     */
    override public function dispose () : Void
    {
        AAutoSize.__pool.push(this);
        //to prevent adding to pool multiple times
        weak = false;
    }

}//class WeakAutoSize