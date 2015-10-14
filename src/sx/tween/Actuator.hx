package sx.tween;

import sx.tween.easing.EasingFunction;



/**
 * Tweening state
 *
 */
class Actuator
{
    /** Start time (seconds) */
    public var startTime (default,null) : Float;
    /** Reached destination value */
    public var done (default,null) : Bool = false;

    /** Duration (seconds) */
    private var __duration : Float;
    /** Callback which will set calculated values to tweened properties */
    private var __setValuesFn : Float->Void;
    /** Callback which will set final values to tweened properties */
    private var __setEndValuesFn : Void->Void;
    /** Callback to invoke on each update */
    private var __onUpdate : Void->Void;
    /** Callback to invoke when tweened properties set to destination value */
    private var __onComplete : Void->Void;


    /**
     * Constructor
     */
    public function new (startTime:Float, duration:Float, setValuesFn:Float->Void, setEndValuesFn:Void->Void) : Void
    {
        __duration = duration;

        this.startTime   = startTime;
        __setValuesFn    = setValuesFn;
        __setEndValuesFn = setEndValuesFn;
    }


    /**
     * Delay tween start by `offset` seconds
     */
    public function delay (offset:Float) : Actuator
    {
        startTime += offset;

        return this;
    }


    /**
     * Set easing function
     */
    public function ease (fn:EasingFunction) : Actuator
    {
        __ease = fn;

        return this;
    }


    /**
     * Stop this actuator.
     *
     * Does not set destination values.
     * Does not call `onComplete()`
     */
    public function stop () : Void
    {
        done = true;
    }


    /**
     * Callback to invoke on each update
     */
    public function onUpdate (fn:Void->Void) : Actuator
    {
        __onUpdate = fn;

        return this;
    }


    /**
     * Callback to invoke when tweened property set to destination value
     */
    public function onComplete (fn:Void->Void) : Actuator
    {
        __onComplete = fn;

        return this;
    }


    /**
     * Update
     */
    private function __update (currentTime:Float) : Void
    {
        if (done) return;

        var time = currentTime - startTime;
        if (time < 0) return;

        if (time > __duration) {
            time = __duration;
            done = true;
            __setEndValuesFn();
        } else {
            var value = __ease(time / __duration);
            __setValuesFn(value);
        }

        if (__onUpdate != null) __onUpdate();
        if (done && __onComplete != null) __onComplete();
    }


    /**
     * Easing function. By default: linear
     */
    private dynamic function __ease (t:Float) : Float
    {
        return t;
    }

}//class Actuator