package sx.properties.abstracts;

import sx.ds.ObjectPool;
import sx.properties.metric.SizeSetterProxy;
import sx.properties.metric.Units;


/**
 * Abstract to be able to write numbers directly to `SizeSetterProxy` instances.
 *
 */
@:forward(min,max,onChange,orientation)
abstract ASizeSetterProxy (SizeSetterProxy) from SizeSetterProxy to SizeSetterProxy
{
    /** Object pool */
    static private var __pool : ObjectPool<WeakSizeSetterProxy> = new ObjectPool();


    /**
     * Create from numbers
     */
    @:access(sx.properties.metric.Size.weak)
    @:from static private function fromFloat (v:Float) : ASizeSetterProxy
    {
        var weakSizeSetterProxy = __pool.pop();
        if (weakSizeSetterProxy == null) weakSizeSetterProxy = new WeakSizeSetterProxy();
        weakSizeSetterProxy.weak = true;
        weakSizeSetterProxy.dip = v;

        return weakSizeSetterProxy;
    }


    /** DIPs */
    public var dip (never,set) : Float;
    /** Pixels */
    public var px (never,set) : Float;
    /** Percent */
    public var pct (never,set) : Float;


    /** Setters */
    private inline function set_dip (v)  return this.dip = v;
    private inline function set_px (v)   return this.px = v;
    private inline function set_pct (v)  return this.pct = v;

}//abstract ASizeSetterProxy



/**
 * For temporary instances used just to pass values to other instances
 *
 */
@:access(sx.properties.abstracts.ASizeSetterProxy.__pool)
private class WeakSizeSetterProxy extends SizeSetterProxy
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
        ASizeSetterProxy.__pool.push(this);
        //to prevent adding to pool multiple times
        weak = false;
    }


    /**
     * Do not dispatch any signals.
     */
    override private function __invokeOnChange (units:Units, value:Float) : Void
    {

    }

}//class WeakSizeSetterProxy