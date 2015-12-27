package sx.properties.abstracts;

import sx.ds.ObjectPool;
import sx.properties.metric.Padding;
import sx.properties.metric.Units;
import sx.signals.Signal;


/**
 * Abstract to be able to write numbers directly to `Padding` instances.
 *
 */
@:forward(min,max,orientation,vertical,horizontal,left,top,right,bottom,toString)
abstract APadding (Padding) from Padding to Padding
{
    /** Object pool */
    static private var __pool : ObjectPool<WeakPadding> = new ObjectPool();

    /**
     * Create from numbers
     */
    @:access(sx.properties.metric.Size.weak)
    @:from static private function __fromFloat (v:Float) : APadding
    {
        var weakPadding = __pool.pop();
        if (weakPadding == null) weakPadding = new WeakPadding();
        weakPadding.weak = true;
        weakPadding.dip = v;

        return weakPadding;
    }


    /** DIPs */
    public var dip (never,set) : Float;
    /** Pixels */
    public var px (never,set) : Float;
    /** Percent */
    public var pct (never,set) : Float;
    /**
     * Callback to invoke when one or more padding components changed.
     *
     * @param   Bool    If horizontal padding changed.
     * @param   Bool    If vertical padding changed.
     */
    public var onChange (get,never) : Signal<Bool->Bool->Void>;


    /** Getters */
    private inline function get_onChange ()     return this.onComponentsChange;

    /** Setters */
    private inline function set_dip (v)  return this.dip = v;
    private inline function set_px (v)   return this.px = v;
    private inline function set_pct (v)  return this.pct = v;

}//abstract APadding


/**
 * For temporary instances used just to pass values to other instances
 *
 */
@:access(sx.properties.abstracts.APadding.__pool)
private class WeakPadding extends Padding
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
        APadding.__pool.push(this);
        //to prevent adding to pool multiple times
        weak = false;
    }


    /**
     * Do not dispatch any signals.
     */
    override private function __invokeOnChange (units:Units, value:Float) : Void
    {

    }

}//class WeakPadding