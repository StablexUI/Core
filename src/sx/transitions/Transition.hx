package sx.transitions;

import sx.tween.easing.EasingFunction;
import sx.tween.easing.Linear;
import sx.tween.Actuator;
import sx.widgets.Widget;



/**
 * Base class for implementing transitions on child changing for `ViewStack` widget.
 *
 */
class Transition {

    /** Duration of transition in seconds */
    public var duration : Float = 0.3;
    /** Easing function to use */
    public var easing : EasingFunction;
    /** Indicates if transition is currently happening */
    public var happening (default,null) : Bool = false;

    /** Actuator, which should be used for transition animation */
    private var __currentActuator : Actuator;


    /**
     * Constructor
     */
    public function new () : Void
    {
        easing = Linear.easeNone;
    }


    /**
     * This method must hide `toHide` object and make visible `toShow` object
     *
     * @param viewStack
     * @param toHide
     * @param toShow
     * @param onComplete    Callback to invoke when transition animation finished
     */
    public function change (toHide:Widget, toShow:Widget, onComplete:Void->Void = null) : Void
    {
        happening = true;

        toHide.visible = false;
        toShow.visible = true;

        happening = false;

        if (onComplete != null) {
            onComplete();
        }
    }


    /**
     * This method must hide `toHide` object and make visible `toShow` object, but play transition animation reversed if possible.
     *
     * @param viewStack
     * @param toHide
     * @param toShow
     * @param onComplete    Callback to invoke when transition animation finished
     */
    public function reverse (toHide:Widget, toShow:Widget, onComplete:Void->Void = null) : Void
    {
        happening = true;

        toHide.visible = false;
        toShow.visible = true;

        happening = false;

        if (onComplete != null) {
            onComplete();
        }
    }


    /**
     * If transition process is currently happening, finish it.
     */
    public function finishCurrentTransition () : Void
    {
        if (__currentActuator != null) {
            __currentActuator.finish();
            __currentActuator = null;
        }
    }
}