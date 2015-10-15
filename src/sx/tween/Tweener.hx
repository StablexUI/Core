package sx.tween;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
#else
import sx.tween.Actuator;
#end





/**
 * Minimal tweening implementation for StablexUI
 *
 */
class Tweener
{

#if !macro
    /** Current time. Updated on each `Tweener.update()` */
    static private var __time : Float = 0;
    /** Active tweeners */
    static private var __tweeners : Array<Tweener> = [];
    /** If global pause is in effect */
    static private var __pausedAll : Bool = false;
    /** Time when global pause turned on */
    static private var __pausedAllTime : Float = 0;
    /** Total time spent in paused state */
    static private var __totalPausedTime : Float = 0;

    /** Indicates if tweener has at least one active tween */
    public var active (default,null) : Bool = false;

    /** Active actuators */
    private var __actuators : Array<Actuator>;


    /**
     * Get current time
     */
    static public dynamic function getTime () : Float
    {
        return haxe.Timer.stamp();
    }


    /**
     * Pause all tweens.
     */
    static public function pauseAll () : Void
    {
        if (__pausedAll) return;
        __pausedAll = true;

        __updateTime();
        __pausedAllTime = __time;
    }


    /**
     * Resume tweens
     */
    static public function resumeAll () : Void
    {
        if (!__pausedAll) return;
        __pausedAll = false;

        __updateTime();

        __totalPausedTime += __time - __pausedAllTime;
        __updateTime();
    }


    /**
     * Stop all tweens
     */
    static public function stopAll () : Void
    {
        for (tweener in __tweeners) {
            tweener.stop();
        }
    }


    /**
     * Update active tweens
     */
    static public function update () : Void
    {
        if (__pausedAll || __tweeners.length == 0) return;

        __updateTime();

        var needRemoval = false;
        for (tweener in __tweeners) {
            tweener.__update(__time);
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
     * Stops all tweens created by this tweener
     */
    public function stop () : Void
    {
        active = false;
        for (actuator in __actuators) {
            actuator.stop();
        }
    }


    /**
     * Update active actuators
     */
    @:access(sx.tween.Actuator.__update)
    private inline function __update (currentTime:Float) : Void
    {
        var needRemoval = false;
        for (actuator in __actuators) {
            if (actuator.startTime < currentTime) {
                actuator.__update(currentTime);
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


    /**
     * Create actuator and start tweening
     */
    private function __createActuator (duration:Float, setValuesFn:Float->Void, setEndValuesFn) : Actuator
    {
        var actuator = new Actuator(__time, duration, setValuesFn, setEndValuesFn);

        __actuators.push(actuator);

        if (!active) {
            active = true;
            __tweeners.push(this);
        }

        return actuator;
    }


    /**
     * Will be called by `sx.Sx.init()` after `Sx.backendManager.setupTweener()`
     */
    static private inline function __initialize () : Void
    {
        __updateTime();
    }


    /**
     * Update `__time` value
     */
    static private inline function __updateTime () : Void
    {
        __time = getTime() - __totalPausedTime;
    }


#else

    /**
     * Generate expression which builds actuator
     */
    static private function __macroTween (eThis:Expr, eDuration:Expr, eInit:Array<Expr>) : Expr
    {
        var initBlock = __initializationBlock(eInit);

        var expr = macro @:privateAccess {
            var __setValuesFn__    : Float->Void = null;
            var __setEndValuesFn__ : Void->Void = null;
            $initBlock;
            $eThis.__createActuator($eDuration, __setValuesFn__, __setEndValuesFn__);
        }

        return expr;
    }


    /**
     * Generate expression which builds actuator and setups easing function
     */
    static private function __macroTweenWithEasing (eThis:Expr, eDuration:Expr, easing:Expr, eInit:Array<Expr>) : Expr
    {
        var eActuator = __macroTween(eThis, eDuration, eInit);
        var expr = macro {
            var __actuator__ : sx.tween.Actuator = $eActuator;
            __actuator__.ease($easing);
            __actuator__;
        }

        return expr;
    }


    /**
     * Build block of required variables initialization
     */
    static private function __initializationBlock (exprs:Array<Expr>) : Expr
    {
        var inits : Array<Expr> = [];
        var setValues : Array<Expr> = [];
        var setEndValues : Array<Expr> = [];
        var cnt = 0;
        for (e in exprs) {
            cnt ++;

            var property : Expr = null;
            var endValue : Expr = null;
            switch (e) {
                case macro $p = $v:
                    property = p;
                    endValue = v;
                case _: Context.error('Only assignment expressions allowed for tweening configuration.', Context.currentPos());
            }

            //variable name for `endValue - startValue`
            var iChange     = '__change' + cnt;
            var iStartValue = '__startValue' + cnt;
            var iEndValue   = '__endValue' + cnt;
            inits.push(macro var $iStartValue : Float = $property);
            inits.push(macro var $iEndValue = $endValue);
            inits.push(macro var $iChange : Float = $i{iEndValue} - $i{iStartValue});

            var setValue : Expr = null;
            var valueExpr = macro $i{iChange} * t + $i{iStartValue};
            if (__isInt(property)) {
                setValue = macro $property = Std.int($valueExpr);
            } else {
                setValue = macro $property = $valueExpr;
            }
            setValues.push(setValue);

            setEndValues.push(macro $property = $i{iEndValue});
        }
        inits.push(macro __setValuesFn__ = function (t:Float) $b{setValues});
        inits.push(macro __setEndValuesFn__ = function () $b{setEndValues});

        var block = macro @:mergeBlock $b{inits};

        return block;
    }


    /**
     * Check if specified expression is of `Int` type
     */
    static private function __isInt (expr:Expr) : Bool
    {
        return switch (Context.typeExpr(expr).t) {
            case TAbstract(_.toString() => 'Int', _): true;
            case _: false;
        }
    }

#end


    /**
     * Create tweening
     */
    macro public function tween (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTween(eThis, duration, destinationExpressions);
    }

    /**
     * Create tweening with backIn easing by default
     */
    macro public function backIn (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Back.easeIn, destinationExpressions);
    }

    /**
     * Create tweening with backOut easing by default
     */
    macro public function backOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Back.easeOut, destinationExpressions);
    }

    /**
     * Create tweening with backInOut easing by default
     */
    macro public function backInOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Back.easeInOut, destinationExpressions);
    }

    /**
     * Create tweening with bounceIn easing by default
     */
    macro public function bounceIn (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Bounce.easeIn, destinationExpressions);
    }

    /**
     * Create tweening with BounceOut easing by default
     */
    macro public function bounceOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Bounce.easeOut, destinationExpressions);
    }

    /**
     * Create tweening with bounceInOut easing by default
     */
    macro public function bounceInOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Bounce.easeInOut, destinationExpressions);
    }

    /**
     * Create tweening with cubicIn easing by default
     */
    macro public function cubicIn (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Cubic.easeIn, destinationExpressions);
    }

    /**
     * Create tweening with backOut easing by default
     */
    macro public function cubicOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Cubic.easeOut, destinationExpressions);
    }

    /**
     * Create tweening with cubicInOut easing by default
     */
    macro public function cubicInOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Cubic.easeInOut, destinationExpressions);
    }

    /**
     * Create tweening with elasticIn easing by default
     */
    macro public function elasticIn (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Elastic.easeIn, destinationExpressions);
    }

    /**
     * Create tweening with backOut easing by default
     */
    macro public function elasticOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Elastic.easeOut, destinationExpressions);
    }

    /**
     * Create tweening with elasticInOut easing by default
     */
    macro public function elasticInOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Elastic.easeInOut, destinationExpressions);
    }

    /**
     * Create tweening with expoIn easing by default
     */
    macro public function expoIn (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Expo.easeIn, destinationExpressions);
    }

    /**
     * Create tweening with backOut easing by default
     */
    macro public function expoOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Expo.easeOut, destinationExpressions);
    }

    /**
     * Create tweening with expoInOut easing by default
     */
    macro public function expoInOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Expo.easeInOut, destinationExpressions);
    }

    /**
     * Create tweening with quadIn easing by default
     */
    macro public function quadIn (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Quad.easeIn, destinationExpressions);
    }

    /**
     * Create tweening with backOut easing by default
     */
    macro public function quadOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Quad.easeOut, destinationExpressions);
    }

    /**
     * Create tweening with quadInOut easing by default
     */
    macro public function quadInOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Quad.easeInOut, destinationExpressions);
    }

    /**
     * Create tweening with quartIn easing by default
     */
    macro public function quartIn (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Quart.easeIn, destinationExpressions);
    }

    /**
     * Create tweening with backOut easing by default
     */
    macro public function quartOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Quart.easeOut, destinationExpressions);
    }

    /**
     * Create tweening with quartInOut easing by default
     */
    macro public function quartInOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Quart.easeInOut, destinationExpressions);
    }

    /**
     * Create tweening with quintIn easing by default
     */
    macro public function quintIn (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Quint.easeIn, destinationExpressions);
    }

    /**
     * Create tweening with backOut easing by default
     */
    macro public function quintOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Quint.easeOut, destinationExpressions);
    }

    /**
     * Create tweening with quintInOut easing by default
     */
    macro public function quintInOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Quint.easeInOut, destinationExpressions);
    }

    /**
     * Create tweening with sineIn easing by default
     */
    macro public function sineIn (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Sine.easeIn, destinationExpressions);
    }

    /**
     * Create tweening with backOut easing by default
     */
    macro public function sineOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Sine.easeOut, destinationExpressions);
    }

    /**
     * Create tweening with sineInOut easing by default
     */
    macro public function sineInOut (eThis:Expr, duration:ExprOf<Float>, destinationExpressions:Array<Expr>) : ExprOf<sx.tween.Actuator>
    {
        return __macroTweenWithEasing(eThis, duration, macro sx.tween.easing.Sine.easeInOut, destinationExpressions);
    }

}//class Tweener