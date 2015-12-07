package sx.widgets.base;

import sx.input.Pointer;
import sx.properties.Orientation;
import sx.signals.PopupSignal;
import sx.signals.Signal;
import sx.Sx;
import sx.tween.Actuator;
import sx.widgets.base.Box;



/**
 * Base class for floating widgets rendered on top of all other UI.
 *
 */
class Floating extends Box
{
    /** Indicates if widget is currently shown. */
    public var shown (default,null) : Bool = false;
    /**
     * Overlay to use for blocking all objects behind widget from receiving user input.
     * Assigning new widget to this property will automatically change assigned widget size to 100% of parent size and `arrangeable` to `false`
     */
    public var overlay (get,set) : Widget;
    private var __overlay : Widget = null;
    /** Should this widget be closed if user pressed mouse button or started touch event outside of this widget? */
    public var closeOnPointerDownOutside : Bool = true;

    /**
     * If currently animating popup reveal or dissapearance, this property will contain actuator returned from `showEffect` or `hideEffect`
     */
    private var __appearanceActuator : Actuator;


    /**
     * Constructor.
     *
     * By default `visible` and `arrangeable` are set to `false`
     */
    public function new () : Void
    {
        super();
        visible = false;
        arrangeable = false;
    }


    /**
     * Override in descendants to animate widget appearance
     */
    private function __showEffect () : Null<Actuator>
    {
        return null;
    }


    /**
     * Override in descendants to animate widget disappearance
     */
    private function __closeEffect () : Null<Actuator>
    {
        return null;
    }


    /**
     * Override in descendants to dispatch `onShow` signals
     */
    private function __shown () : Void
    {

    }


    /**
     * Override in descendants to dispatch `onClose` signals
     */
    private function __closed () : Void
    {

    }


    /**
     * Override in descendants to handle situations when floating widget wants to close itself. E.g. user pressed pointer
     * outside of this widget.
     */
    private function __needClose () : Void
    {
        __close();
    }


    /**
     * Reveal this floating widget popup.
     *
     * If widget does not have a parent, then `visible` will be set to `true` and widget will be added to `Sx.root` display list.
     * If widget has a parent, then this method just switches `visible` to `true` and moves widget to the top of parents display list.
     */
    private function __show () : Void
    {
        if (shown) return;
        shown = true;

        __stopAppearanceAnimation();

        if (parent == null) {
            Sx.root.addChild(this);
        } else {
            parent.setChildIndex(this, -1);
        }
        visible = true;
        __showOverlay();

        __appearanceActuator = __showEffect();
        if (__appearanceActuator != null) {
            __appearanceActuator.onComplete(__finalizeShow);
        } else {
            __finalizeShow();
        }
    }


    /**
     * Close widget.
     *
     * If widget is attached to `Sx.root` then `Sx.root.removeChild(widget)` is called and `visible` changed to `false`.
     * If widget is attached to another widget (except `Sx.root`) then this method just switches `visible` to `false`.
     */
    private function __close () : Void
    {
        if (!shown) return;
        shown = false;

        __stopAppearanceAnimation();
        Pointer.onPress.remove(__pointerGlobalPressed);

        __appearanceActuator = __closeEffect();
        if (__appearanceActuator != null) {
            __appearanceActuator.onComplete(__finalizeClose);
        } else {
            __finalizeClose();
        }
    }


    /**
     * Method to cleanup and release this object for garbage collector.
     */
    override public function dispose (disposeChildren:Bool = true) : Void
    {
        __stopAppearanceAnimation();

        super.dispose(disposeChildren);

        if (__overlay != null) {
            __overlay.dispose();
        }
    }


    /**
     * Process global pointer press signals to deal with `closeOnPointerPressOutside`
     */
    private function __pointerGlobalPressed (dispatcher:Null<Widget>, touchId:Int) : Void
    {
        if (closeOnPointerDownOutside) {
            if (!contains(dispatcher)) {
                __needClose();
            }
        }
    }


    /**
     * Called after popup is shown or appearance animation is finished.
     */
    private function __finalizeShow () : Void
    {
        Pointer.onPress.add(__pointerGlobalPressed);
        __appearanceActuator = null;
        __shown();
    }


    /**
     * Called after popup is closed or disappearance animation is finished.
     */
    private function __finalizeClose () : Void
    {
        if (parent == Sx.root) {
            Sx.root.removeChild(this);
        }
        visible = false;

        __appearanceActuator = null;
        __hideOverlay();
        __closed();
    }


    /**
     * Stop appearance/disappearance animation if it is currently active
     */
    private function __stopAppearanceAnimation () : Void
    {
        if (__appearanceActuator != null) {
            __appearanceActuator.stop();
            __appearanceActuator = null;
        }
    }


    /**
     * Show overlay behind this popup
     */
    private function __showOverlay () : Void
    {
        if (overlay == null || parent == null) return;

        var index = parent.getChildIndex(this);
        if (overlay.parent == parent) {
            if (index > 0) index--;
            parent.setChildIndex(overlay, index);
        } else {
            parent.addChildAt(overlay, index);
        }

        overlay.visible = true;
    }


    /**
     * Hide overlay
     */
    private function __hideOverlay () : Void
    {
        if (overlay == null) return;

        overlay.visible = false;
        if ((parent == null && overlay.parent != null) || parent != overlay.parent) {
            overlay.parent.removeChild(overlay);
        }
    }


    /**
     * Setter for `overlay`
     */
    private function set_overlay (value:Widget) : Widget
    {
        if (__overlay != null) {
            if (__overlay.parent != null) {
                __overlay.parent.removeChild(__overlay);
            }
        }

        __overlay = value;

        if (shown) {
            __showOverlay();
        } else {
            __hideOverlay();
        }

        return value;
    }


    /**
     * Getter `overlay`
     */
    private function get_overlay () : Widget
    {
        if (__overlay == null) {
            __overlay = new Widget();
            __overlay.arrangeable = false;
            __overlay.width.pct   = 100;
            __overlay.height.pct  = 100;
        }

        return __overlay;
    }


    /** Getters */
    private function get_visible ()       return (parent != null && visible == true);


}//class Popup