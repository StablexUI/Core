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
        finishCurrentTransition();
        happening = true;

        var parent = toShow.parent;
        var showIndex = parent.getChildIndex(toShow);
        var hideIndex = parent.getChildIndex(toHide);
        var swap = (showIndex > hideIndex);

        if (swap) {
            parent.swapChildrenAt(showIndex, hideIndex);
        }

        toShow.alpha   = 1;
        toShow.visible = true;

        __currentActuator = toHide.tween.tween(duration, toHide.alpha = 0);
        __currentActuator.ease(easing).onComplete(__complete.bind(swap, toHide, toShow, onComplete));
    }


    /**
     * This method must hide `toHide` object and make visible `toShow` object, but play transition animation reversed.
     *
     * @param viewStack
     * @param toHide
     * @param toShow
     * @param onComplete    Callback to invoke when transition animation finished
     */
    override public function reverse (toHide:Widget, toShow:Widget, onComplete:Void->Void = null) : Void
    {
        finishCurrentTransition();
        happening = true;

        var parent = toShow.parent;
        var showIndex = parent.getChildIndex(toShow);
        var hideIndex = parent.getChildIndex(toHide);
        var swap = (showIndex < hideIndex);

        if (swap) {
            parent.swapChildrenAt(showIndex, hideIndex);
        }

        toShow.alpha   = 0;
        toShow.visible = true;

        __currentActuator = toShow.tween.tween(duration, toShow.alpha = 1);
        __currentActuator.ease(easing).onComplete(__complete.bind(swap, toHide, toShow, onComplete));
    }


    /**
     * Finalize transition
     */
    private function __complete (swap:Bool, toHide:Widget, toShow:Widget, onComplete:Void->Void = null) : Void
    {
        toHide.visible = false;
        toHide.alpha   = 1;

        if (swap) {
            toShow.parent.swapChildren(toHide, toShow);
        }

        happening = false;

        if (onComplete != null) {
            onComplete();
        }
    }


}//class FadeTransition