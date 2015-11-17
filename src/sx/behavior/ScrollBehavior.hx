package sx.behavior;

import sx.signals.Signal;
import sx.tween.Actuator;
import sx.tween.Tweener;
import sx.widgets.Widget;
import sx.input.Pointer;
import sx.backend.Point;
import sx.Sx;

using sx.Sx;


/**
 * Scrolling implementation.
 *
 */
class ScrollBehavior
{
    /** If pointer moved by this amount of DIPs after user started interaction, then we treat this interaction as scrolling */
    public var dipsToScroll = 4;
    /**
     * Indicates if user is currently dragging scrolled content.
     * Assign `false` to stop dragging.
     * Assigning `true` while no real dragging is happening has no effect and `dragging` will stay `false`.
     */
    public var dragging (get,set) : Bool;
    private var __dragging : Bool = false;
    /**
     * Indicates if content is currently dragged or scrolled by inertia.
     * Assign `false` to stop scrolling.
     * Assigning `true` while no real scrolling is happening has no effect and `scrolling` will stay `false`.
     */
    public var scrolling (get,set) : Bool;
    private var __scrolling : Bool = false;
    /** Enable/disable vertical scrolling */
    public var verticalScroll : Bool = true;
    /** Enable/disable horizontal scrolling */
    public var horizontalScroll : Bool = true;

    /** Widget used as scrolling container */
    private var __widget : Widget;

    /** Last registered coordinates of contact with pointer */
    private var __lastContact : Point;
    /** Time of `__lastContact` */
    private var __lastTime : Float = 0;
    /** Previous registered coordinates of contact with pointer */
    private var __previousContact : Point;
    /** Time of `__previousContact` */
    private var __previousTime : Float = 0;
    /** Description */
    private var __velocitiesX : Array<Float>;
    private var __velocitiesY : Array<Float>;
    /** Id of a touch event which started dragging content */
    private var __dragTouchId : Int = 0;
    /** Last scroll actuator */
    private var __scrollActuator : Actuator;

    /** If user started interaction, but are still not sure whether he wants to scroll or not. */
    private var __waitingForScroll : Bool = false;

    /**
     * Dispatched when scrolling should occur
     *
     * @param   Widget      Scroll container.
     * @param   Float       Scroll distance alonge X axis (DIPs)
     * @param   Float       Scroll distance alonge Y axis (DIPs)
     */
    public var onScroll (default,null) : Signal<Widget->Float->Float->Void>;


    /**
     * Constructor
     *
     * @param owner     Widget which we will use as scrolling container.
     */
    public function new (owner:Widget) : Void
    {
        __widget = owner;
        onScroll = new Signal();

        __widget.onPointerPress.add(__onInteractionStarted);
    }


    /**
     * Stop any actions currently performed
     */
    public function stop () : Void
    {
        if (__waitingForScroll) {
            __stopWaitingForScroll(null, __dragTouchId);
        }
        if (__scrolling) {
            __stopScrolling();
        }
    }


    /**
     * Waits for user interaction
     */
    private function __onInteractionStarted (me:Widget, dispatcher:Widget, touchId:Int) : Void
    {
        if (__waitingForScroll || __dragging) return;

        Pointer.stopCurrentSignal();
        __waitingForScroll = true;

        if (__scrolling) {
            __stopScrolling();
        }

        __dragTouchId = touchId;
        __lastContact = __widget.globalToLocal(Pointer.getPosition(touchId));
        __lastTime = Tweener.getTime();

        Pointer.onMove.add(__waitForScrollMove);
        Pointer.onNextRelease.add(__stopWaitingForScroll);
    }


    /**
     * Called on every frame till user starts or cancels scrolling
     */
    private function __waitForScrollMove (dispatcher:Null<Widget>, touchId:Int) : Void
    {
        if (__dragTouchId != touchId) return;

        Pointer.stopCurrentSignal();

        var pos = __widget.globalToLocal(Pointer.getPosition(touchId));

        var dX = pos.x - __lastContact.x;
        var dY = pos.y - __lastContact.y;

        //start scrolling ?
        if (
            (horizontalScroll && Math.abs(dX) >= dipsToScroll)
            ||
            (verticalScroll && Math.abs(dY) >= dipsToScroll)
        ) {
            __stopWaitingForScroll(null, __dragTouchId);
            Pointer.forcePointerOut(__dragTouchId);
            Pointer.released(null, __dragTouchId);
            __startDrag();
        }
    }


    /**
     * Description
     */
    private function __stopWaitingForScroll (dispatcher:Null<Widget>, touchId:Int) : Void
    {
        if (__dragTouchId != touchId) return;

        __waitingForScroll = false;

        Pointer.onMove.remove(__waitForScrollMove);
    }


    /**
     * Start scrolling on press
     */
    private function __startDrag () : Void
    {
        __scrolling = true;
        __dragging  = true;

        __velocitiesX     = [];
        __velocitiesY     = [];
        __lastContact     = null;
        __previousContact = null;
        __updateDrag();

        Sx.onFrame.add(__updateDrag);
        Pointer.onMove.add(__stopPointerMoveSignalWhileDragging);
        Pointer.onNextRelease.add(__pointerReleasedWhileDragging);
    }


    /**
     * Description
     */
    private function __stopPointerMoveSignalWhileDragging (dispatcher:Null<Widget>, touchId:Int) : Void
    {
        if (touchId != __dragTouchId) return;
        Pointer.stopCurrentSignal();
    }


    /**
     * Collect dragging info on each frame
     */
    private function __updateDrag () : Void
    {
        if (Tweener.pausedAll) return;

        Pointer.stopCurrentSignal();

        __previousTime    = __lastTime;
        __lastTime        = Tweener.getTime();
        __previousContact = __lastContact;
        __lastContact = __widget.globalToLocal(Pointer.getPosition(__dragTouchId));

        if (__previousContact != null) {
            var dX = __lastContact.x - __previousContact.x;
            var dY = __lastContact.y - __previousContact.y;
            dX = (horizontalScroll ? dX.toDip() : 0);
            dY = (verticalScroll ? dY.toDip() : 0);
            onScroll.dispatch(__widget, -dX, -dY);

            var dTime = __lastTime - __previousTime;
            if (dTime != 0) {
                var vX = (__lastContact.x - __previousContact.x) / dTime;
                var vY = (__lastContact.y - __previousContact.y) / dTime;
                __velocitiesX.push(vX);
                __velocitiesY.push(vY);
                if (__velocitiesX.length > 3) __velocitiesX.shift();
                if (__velocitiesY.length > 3) __velocitiesY.shift();
            }
        }
    }


    /**
     * User stopped dragging scrolled content
     */
    private function __pointerReleasedWhileDragging (dispatcher:Null<Widget>, touchId:Int) : Void
    {
        if (__dragTouchId != touchId || !__dragging) return;

        Pointer.stopCurrentSignal();

        __stopDragging();
    }


    /**
     * Stop dragging scrolled content
     */
    private function __stopDragging () : Void
    {
        __dragging = false;
        Sx.onFrame.remove(__updateDrag);
        Pointer.onMove.remove(__stopPointerMoveSignalWhileDragging);

        if (__velocitiesX.length == 0 || __velocitiesY.length == 0) {
            return;
        }

        var vX = __averageVelocity(__velocitiesX);
        var vY = __averageVelocity(__velocitiesY);

        var time = Tweener.getTime();
        __scrollActuator = __widget.tween.expoOut(2, vX = 0, vY = 0).onComplete(__stopScrolling).onUpdate(function() {
            var dTime = Tweener.getTime() - time;
            var dX = vX * dTime;
            var dY = vY * dTime;
            time += dTime;
            dX = (horizontalScroll ? dX.toDip() : 0);
            dY = (verticalScroll ? dY.toDip() : 0);
            onScroll.dispatch(__widget, -dX, -dY);
        });
    }


    /**
     * Scrolling finished or should be stopped
     */
    private function __stopScrolling () : Void
    {
        if (__dragging) {
            __stopDragging();
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
            __stopDragging();
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


    /**
     * Calculate average velocity
     */
    static private function __averageVelocity (velocities:Array<Float>) : Float
    {
        var v = velocities[0];
        for (i in 1...velocities.length) {
            v += velocities[i];
        }
        v /= velocities.length;

        return v;
    }


}//class ScrollBehavior