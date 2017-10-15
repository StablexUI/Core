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
    /** Indicates if actuator should also ease backward after reaching the final point */
    private var __reverse:Bool = false;
    /** Indicates if tweener is moving backwards */
    private var __reversed:Bool = false;
    /** Callback to invoke when tweener reached final values and reversed to move to initial values */
    private var __onReverse : Void->Void;
    /** Amount of times to repeat this tweening */
    private var __repeat : Int = 0;
    /** Callback to invoke when tween is about to repeat */
    private var __onRepeat : Void->Void;


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

    public function reverse() : Actuator {
        __reverse = true;

        return this;
    }

    public function repeat(times:Int) : Actuator {
        __repeat = times;

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
     * Set tweened things to the end values and call `onComplete` if defined.
     */
    public function complete () : Void
    {
        __setEndValuesFn();
        done = true;
        if (__onComplete != null) {
            __onComplete();
        }
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
     * Callback to invoke when tweener is changing direction
     */
    public function onReverse (fn:Void->Void) : Actuator
    {
        __onReverse = fn;

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

        __setValues(currentTime);

        if (__onUpdate != null) __onUpdate();
        if (done && __onComplete != null) __onComplete();
    }


    function __setValues(currentTime:Float) {
        var time = currentTime - startTime;

        inline function update() {
            var value = __ease(time / __duration);
            __setValuesFn(value);
        }

        inline function finish() {
            if(__repeat != 0) {
                --__repeat;
                if(__onRepeat != null) __onRepeat();
                startTime += __duration;
                if(__reversed) {
                    startTime += __duration;
                    __reversed = false;
                }
                time = currentTime - startTime;
                update();
            } else {
                done = true;
                if(__reversed) {
                    __setValuesFn(0);
                } else {
                    __setEndValuesFn();
                }
            }
        }

        if (time >= __duration) {
            if(__reverse) {
                if(!__reversed) {
                    __reversed = true;
                    if(__onReverse != null) __onReverse();
                }
                if(time >= 2 * __duration) {
                    finish();
                } else {
                    time = __duration - (time - __duration);
                    update();
                }
            } else {
                finish();
            }
        } else {
            if(__reversed) {
                __reversed = false;
                if(__onReverse != null) __onReverse();
            }
            update();
        }
    }


    /**
     * Easing function. By default: linear
     */
    private dynamic function __ease (t:Float) : Float
    {
        return t;
    }

}//class Actuator