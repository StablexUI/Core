package sx.tween;

import sx.tween.Actuator;



/**
 * Minimal tweening implementation for StablexUI
 *
 */
class Tweener
{
    /** Active tweeners */
    static private var __tweeners : Array<Tweener> = [];

    /** Indicates if tweener has at least one active tween */
    public var active (default,null) : Bool = false;

    /** Active actuators */
    private var __actuators : Array<Actuator>;


    /**
     * Update active tweens
     */
    static public inline function update () : Void
    {
        if (__tweeners.length == 0) {trace('no tweeners');return;}

        var time = haxe.Timer.stamp();

        var needRemoval = false;
        for (tweener in __tweeners) {
            tweener.__update(time);
            if (!tweener.active) {
                needRemoval = true;
            }
        }

        //remove deactivated tweeners
        if (needRemoval) {
            var i = 0;
            while (i < __tweeners.length) {
                if (!__tweeners[i].active) {
                    __tweeners.splice(i, 1);
                } else {
                    i++;
                }
            }
        }
    }


    /**
     * Constructor
     */
    public function new () : Void
    {
        __actuators = [];
    }


    /**
     * Description
     */
    public function tween (target:Dynamic, property:String, destination:Float, duration:Float) : Void
    {
        var startValue : Float = Reflect.getProperty(target, property);
        var startTime : Float = haxe.Timer.stamp();
        var actuator = new Actuator(startValue, destination, startTime, duration);
        actuator.target = target;
        actuator.property = property;

        __actuators.push(actuator);

        if (!active) {
            active = true;
            __tweeners.push(this);
        }
    }


    /**
     * Update active actuators
     */
    private inline function __update (currentTime:Float) : Void
    {
        var needRemoval = false;
        for (actuator in __actuators) {
            if (actuator.startTime <= currentTime) {
                actuator.update(currentTime);
                if (actuator.done) {
                    needRemoval = true;
                }
            }
        }

        //remove finished actuators
        if (needRemoval) {
            var i = 0;
            while (i < __actuators.length) {
                if (__actuators[i].done) {
                    __actuators.splice(i, 1);
                } else {
                    i++;
                }
            }
            //deactivate tweener if no active actuators left
            active = (__actuators.length > 0);
        }
    }


}//class Tweener