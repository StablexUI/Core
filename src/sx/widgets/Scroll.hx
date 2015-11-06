package sx.widgets;

import sx.backend.Point;
import sx.input.Pointer;
import sx.Sx;
import sx.tween.Actuator;
import sx.tween.Tweener;

using sx.Sx;


/**
 * Scroll container.
 * First child of this widget will be used as container for scrolled content.
 *
 */
class Scroll extends Widget
{
    /**
     * Indicates if user is currently dragging scrolled content.
     * Assign `false` to stop dragging.
     * Assigning `true` while no real dragging is happening has no effect and `dragging` will stay `false`.
     */
    public var dragging (get,set) : Bool;
    private var __dragging : Bool = false;
    /**
     * Indicates if content is currently dragged or scrolled by inertia.
     *
     * Assign `false` to stop scrolling.
     */
    public var scrolling (get,set) : Bool;
    private var __scrolling : Bool = false;
    /** Last registered coordinates of contact with pointer */
    private var __lastContact : Point;
    /** Time of `__lastContact` */
    private var __lastTime : Float = 0;
    /** Previous registered coordinates of contact with pointer */
    private var __previousContact : Point;
    /** Time of `__previousContact` */
    private var __previousTime : Float = 0;
    /** Id of a touch event which started dragging content */
    private var __dragTouchId : Int = 0;
    /** Last scroll actuator */
    private var __scrollActuator : Actuator;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();
        overflow = false;

        onPointerPress.add(__startDrag);
    }


    /**
     * Scroll by specified amount of DIPs
     */
    public function scrollBy (dX:Float, dY:Float) : Void
    {
        var child;
        for (i in 0...numChildren) {
            child = getChildAt(i);
            child.left.dip += dX;
            child.top.dip += dY;
        }
    }


    /**
     * Method to cleanup and release this object for garbage collector.
     */
    override public function dispose (disposeChildren:Bool = true) : Void
    {
        scrolling = false;
        super.dispose();
    }


    /**
     * Start scrolling on press
     */
    private function __startDrag (me:Widget, dispatcher:Widget, touchId:Int) : Void
    {
        if (__dragging) return;
        __stopScrolling();

        __scrolling = true;
        __dragging  = true;

        __lastContact     = null;
        __previousContact = null;
        __dragTouchId     = touchId;
        __updateDrag();

        Sx.onFrame.add(__updateDrag);
        Pointer.onNextRelease.add(__stopDragging);
    }


    /**
     * Collect dragging info on each pointer move
     */
    private function __updateDrag () : Void
    {
        if (Tweener.pausedAll) return;

        __previousTime    = __lastTime;
        __lastTime        = Tweener.getTime();
        __previousContact = __lastContact;
        __lastContact = globalToLocal(Pointer.getPosition(__dragTouchId));
    }


    /**
     * User stopped dragging scrolled content
     */
    private function __stopDragging (dispatcher:Null<Widget>, touchId:Int) : Void
    {
        if (__dragTouchId != touchId) return;

        __dragging = false;
        Sx.onFrame.remove(__updateDrag);

        var dTime = __lastTime - __previousTime;
        if (dTime <= 0.001 || __previousContact == null) return;

        var dX = (__lastContact.x - __previousContact.x) / dTime;
        var dY = (__lastContact.y - __previousContact.y) / dTime;

        __scrollActuator = tween.expoOut(2, dX = 0, dY = 0).onComplete(__stopScrolling).onUpdate(function() {
            var dipX = dX.toDip();
            var dipY = dY.toDip();
            scrollBy(dipX, dipY);
        });
    }


    /**
     * Scrolling finished or should be stopped
     */
    private function __stopScrolling () : Void
    {
        if (__dragging) {
            __stopDragging(null, __dragTouchId);
        }

        if (__scrollActuator != null) {
            if (!__scrollActuator.done) {
                __scrollActuator.stop();
            }
            __scrollActuator = null;
        }
        __scrolling = false;
    }


    /**
     * Setter `dragging`
     */
    private function set_dragging (value:Bool) : Bool
    {
        if (__dragging && !value) {
            __stopDragging(null, __dragTouchId);
        }

        return value;
    }


    /**
     * Setter `scrolling`
     */
    private function set_scrolling (value:Bool) : Bool
    {
        if (__scrolling && !value) {
            __stopScrolling();
        }

        return value;
    }


    /** Getters */
    private function get_dragging ()        return __dragging;
    private function get_scrolling ()       return __scrolling;

}//class Scroll