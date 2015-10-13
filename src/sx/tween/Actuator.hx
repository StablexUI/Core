package sx.tween;



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

    /** Start value */
    private var b : Float;
    /** Difference between the start and end values of tweened property */
    private var c : Float;
    /** Duration (seconds) */
    private var d : Float;

    /** Affected object */
    public var target : Dynamic;
    /** Tweened property */
    public var property : String;


    /**
     * Constructor
     */
    public function new (startValue:Float, endValue:Float, startTime:Float, duration:Float) : Void
    {
        b = startValue;
        c = endValue - startValue;
        d = duration;

        this.startTime = startTime;
    }


    /**
     * Update
     */
    public function update (currentTime:Float) : Void
    {
        var time = currentTime - startTime;
        if (time < 0) return;
        if (time > d) {
            time = d;
            done = true;
        }

        var value = ease(time);
        Reflect.setProperty(target, property, value);
    }


    /**
     * Description
     */
    public function ease (t:Float) : Float
    {
        t = t / d;
        return c * t * t * t * t * t * t + b;
    }

}//class Actuator