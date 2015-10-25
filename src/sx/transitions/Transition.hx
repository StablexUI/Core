package sx.transitions;

import sx.tween.easing.EasingFunction;
import sx.tween.easing.Linear;
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
        toHide.visible = false;
        toShow.visible = true;

        if (onComplete != null) {
            onComplete();
        }
    }


    /**
     * This method must hide `toHide` object and make visible `toShow` object, but play transition animation reversed.
     *
     * @param viewStack
     * @param toHide
     * @param toShow
     * @param onComplete    Callback to invoke when transition animation finished
     */
    public function reverse (toHide:Widget, toShow:Widget, onComplete:Void->Void = null) : Void
    {
        toHide.visible = false;
        toShow.visible = true;

        if (onComplete != null) {
            onComplete();
        }
    }
}