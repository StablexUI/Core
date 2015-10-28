package sx.transitions;

import sx.transitions.Transition;
import sx.widgets.Widget;


/**
 * Transition which tweens current view to zero opacity.
 *
 */
class FadeTransition extends Transition
{

    /**
     * This method must hide `toHide` object and make visible `toShow` object
     *
     * @param viewStack
     * @param toHide
     * @param toShow
     * @param onComplete    Callback to invoke when transition animation finished
     */
    override public function change (toHide:Widget, toShow:Widget, onComplete:Void->Void = null) : Void
    {
        __start(toHide, toShow, onComplete);
    }


    /**
     * This method must hide `toHide` object and make visible `toShow` object, but play transition animation reversed if possible.
     *
     * @param viewStack
     * @param toHide
     * @param toShow
     * @param onComplete    Callback to invoke when transition animation finished
     */
    override public function reverse (toHide:Widget, toShow:Widget, onComplete:Void->Void = null) : Void
    {
        __start(toHide, toShow, onComplete);
    }


    /**
     * Start transition
     */
    private function __start (toHide:Widget, toShow:Widget, onComplete:Void->Void = null) : Void
    {
        finishCurrentTransition();
        happening = true;

        toShow.visible = true;
        toShow.alpha = 0;


        // var showIndex = parent.getChildIndex(toShow);
        // var hideIndex = parent.getChildIndex(toHide);

        // if (showIndex < hideIndex) {
        //     toShow.alpha = 1;
        //     __currentActuator = toHide.tween.tween(duration, toHide.alpha = 0);
        // } else {
        //     toShow.alpha = 0;
        //     __currentActuator = toShow.tween.tween(duration, toShow.alpha = 1);
        // }

        var parent = toShow.parent;
        __currentActuator = parent.tween.tween(duration, toShow.alpha = 1, toHide.alpha = 0);
        __currentActuator.ease(easing).onComplete(__complete.bind(toHide, toShow, onComplete));
    }


    /**
     * Finalize transition
     */
    private function __complete (toHide:Widget, toShow:Widget, onComplete:Void->Void = null) : Void
    {
        toHide.visible = false;
        toHide.alpha   = 1;

        happening = false;

        if (onComplete != null) {
            onComplete();
        }
    }


}//class FadeTransition