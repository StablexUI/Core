package sx.input;

import sx.widgets.Widget;



/**
 * Manages pointers events (like mouse and touch)
 *
 */
class PointerManager
{
    /** Flag used to stop signal bubbling */
    static private var __currentSignalStopped : Bool = false;
    /** Widgets currently pressed */
    static private var __pressedWidgets : Array<Widget> = [];
    /** Widgets which were under the pointer at the moment of last pointer event */
    static private var __hoveredWidgets : Array<Widget> = [];


    /**
     * Should be called by backend when user pressed mouse button or started touch interaction.
     */
    static public function pressed (widget:Null<Widget>) : Void
    {
        __currentSignalStopped = false;
        if (widget == null) return;

        var processor = widget;
        while (processor != null && !__currentSignalStopped) {
            processor.onPointerPress.dispatch(processor, widget);

            if (__pressedWidgets.indexOf(processor) < 0) {
                __pressedWidgets.push(processor);
            }

            processor = processor.parent;
        }
    }


    /**
     * Should be called by backend when user released mouse button or ended touch.
     */
    static public function released (widget:Null<Widget>) : Void
    {
        //dispatch `onPointerRelease` signal
        __currentSignalStopped = false;
        var processor = widget;
        while (processor != null && !__currentSignalStopped) {
            processor.onPointerRelease.dispatch(processor, widget);
            processor = processor.parent;
        }

        //dispatch `onPointerTap` signal
        if (__pressedWidgets.length > 0) {
            __currentSignalStopped = false;
            processor = widget;
            while (processor != null && !__currentSignalStopped) {
                if (__pressedWidgets.indexOf(processor) >= 0) {
                    processor.onPointerTap.dispatch(processor, widget);
                }
                processor = processor.parent;
            }

            __pressedWidgets = [];
        }
    }


    /**
     * Should be called by backend when user moved pointer.
     */
    static public function moved (widget:Null<Widget>) : Void
    {
        //collect list of widgets currently under pointer
        var newHovered : Array<Widget> = [];
        var processor = widget;
        while (processor != null) {
            newHovered.push(processor);
            processor = widget.parent;
        }

        //dispatch `onPointerOut`
        if (__hoveredWidgets.length > 0) {
            for (w in __hoveredWidgets) {
                if (newHovered.indexOf(w) < 0) {
                    w.onPointerOut.dispatch(w, w);
                }
            }
        }

        //dispatch `onPointerOver`
        if (newHovered.length > 0) {
            for (w in newHovered) {
                if (__hoveredWidgets.indexOf(w) < 0) {
                    w.onPointerOver.dispatch(w, w);
                }
            }
        }

        //dispatch `onPointerMove`
        __currentSignalStopped = false;
        processor = widget;
        while (processor != null && !__currentSignalStopped) {
            processor.onPointerMove.dispatch(processor, widget);
            processor = processor.parent;
        }

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
     * Constructor
     */
    private function new () : Void
    {

    }

}//class PointerManager