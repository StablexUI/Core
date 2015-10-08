package sx.input;

import sx.widgets.Widget;

using sx.tools.WidgetTools;


/**
 * :TODO:
 * Replace Array with linked list to avoid garbage collection.
 */
typedef OrderedList<T> = Array<T>;


/**
 * Manages pointers events (like mouse and touch)
 *
 */
@:access(sx.widgets.Widget)
class PointerManager
{
    /** Flag used to stop signal bubbling */
    static private var __currentSignalStopped : Bool = false;
    /** Widgets currently pressed */
    static private var __pressedWidgets : OrderedList<Widget> = new OrderedList();
    /** Widgets which were under the pointer at the moment of last pointer event */
    static private var __hoveredWidgets : OrderedList<Widget> = new OrderedList();
    /** Current touchId for mouse */
    static private var __mouseTouchId : Int = 0;
    /** Counter used to generate touchId for mouse events */
    static private var __touchIdCounter : Int = -1;


    /**
     * Should be called by backend when user pressed mouse button or started touch interaction.
     */
    static public function pressed (widget:Null<Widget>, touchId:Int = 0) : Void
    {
        if (widget == null) return;

        widget = widget.findEnabled();
        if (widget == null) return;

        //no touchId? Generate one
        if (touchId == 0) {
            __mouseTouchId = __touchIdCounter--;
            touchId = __mouseTouchId;
        }

        __currentSignalStopped = false;
        var processor = widget;
        while (processor != null && !__currentSignalStopped) {
            processor.__onPointerPress.dispatch(processor, widget, touchId);

            if (__pressedWidgets.indexOf(processor) < 0) {
                __pressedWidgets.push(processor);
            }

            processor = processor.parent;
        }
    }


    /**
     * Should be called by backend when user released mouse button or ended touch.
     */
    static public function released (widget:Null<Widget>, touchId:Int = 0) : Void
    {
        if (widget != null) {
            widget = widget.findEnabled();
        }

        //no touchId? Use generate one
        if (touchId == 0) {
            touchId = __mouseTouchId;
            __mouseTouchId = 0;
        }

        //dispatch `onPointerRelease` signal
        __currentSignalStopped = false;
        var processor = widget;
        while (processor != null && !__currentSignalStopped) {
            processor.__onPointerRelease.dispatch(processor, widget, touchId);
            processor = processor.parent;
        }

        //dispatch `onPointerTap` signal
        if (__pressedWidgets.length > 0) {
            __currentSignalStopped = false;
            processor = widget;
            while (processor != null && !__currentSignalStopped) {
                if (__pressedWidgets.indexOf(processor) >= 0) {
                    processor.__onPointerTap.dispatch(processor, widget, touchId);
                }
                processor = processor.parent;
            }

            __pressedWidgets = new OrderedList();
        }
    }


    /**
     * Should be called by backend when user moved pointer.
     */
    static public function moved (widget:Null<Widget>, touchId:Int = 0) : Void
    {
        if (widget != null) {
            widget = widget.findEnabled();
        }

        //no touchId? Use generate one
        if (touchId == 0) {
            touchId = __mouseTouchId;
        }

        var newHovered = __collectHoveredWidgets(widget);

        __dispatchOnPointerOut(__hoveredWidgets, newHovered, touchId);
        __dispatchOnPointerOver(__hoveredWidgets, newHovered, touchId);
        __dispatchOnPointerMove(widget, touchId);

        //store list of currently hovered widgets
        __hoveredWidgets = newHovered;
    }


    /**
     * Stop bubbling current signal
     */
    static public function stopCurrentSignal () : Void
    {
        __currentSignalStopped = true;
    }


    /**
     * Collect list of widgets currently under pointer
     */
    static private inline function __collectHoveredWidgets (start:Widget) : OrderedList<Widget>
    {
        var hovered = new OrderedList<Widget>();

        var processor = start;
        while (processor != null) {
            hovered.push(processor);
            processor = processor.parent;
        }

        return hovered;
    }


    /**
     * Dispatch `onPointerOut`
     */
    static private inline function __dispatchOnPointerOut (wasHovered:OrderedList<Widget>, nowHovered:OrderedList<Widget>, touchId:Int) : Void
    {
        if (wasHovered.length > 0) {
            __currentSignalStopped = false;
            for (w in wasHovered) {
                if (nowHovered.indexOf(w) < 0 && w.enabled) {
                    w.__onPointerOut.dispatch(w, w, touchId);
                    if (__currentSignalStopped) break;
                }
            }
        }
    }


    /**
     * Dispatch `onPointerOver`
     */
    static private inline function __dispatchOnPointerOver (oldHovered:OrderedList<Widget>, nowHovered:OrderedList<Widget>, touchId:Int) : Void
    {
        if (nowHovered.length > 0) {
            __currentSignalStopped = false;
            for (w in nowHovered) {
                if (oldHovered.indexOf(w) < 0) {
                    w.__onPointerOver.dispatch(w, w, touchId);
                    if (__currentSignalStopped) break;
                }
            }
        }
    }


    /**
     * Dispatch `onPointerMove`
     */
    static private inline function __dispatchOnPointerMove (dispatcher:Widget, touchId:Int) : Void
    {
        __currentSignalStopped = false;
        var processor = dispatcher;
        while (processor != null && !__currentSignalStopped) {
            processor.__onPointerMove.dispatch(processor, dispatcher, touchId);
            processor = processor.parent;
        }
    }


    /**
     * Constructor
     */
    private function new () : Void
    {

    }

}//class PointerManager