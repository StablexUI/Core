package sx.widgets;

import sx.input.Pointer;
import sx.properties.Orientation;
import sx.signals.PopupSignal;
import sx.signals.Signal;
import sx.Sx;
import sx.tween.Actuator;
import sx.widgets.base.Box;



/**
 * Base class for widgets rendered on top of all other UI.
 *
 */
class Popup extends Box
{

    /**
     * Callback which implements popup reveal animation when popup is shown.
     * If this property is set, then `onShow` signal will be dispatched after appearance animation is finished.
     * E.g. fade in effect may look like this:
     * ```
     * popup.showEffect = function (p) {
     *      p.alpha = 0;
     *      var actuator = p.tween.linear(1, p.alpha = 1);
     *      return actuator;
     * }
     * ```
     */
    public var showEffect : Null<Popup->Actuator>;
    /**
     * Callback which implements popup dissapeearance animation when popup is closed.
     * If this property is set, then `onClose` signal will be dispatched after disappearance animation is finished.
     */
    public var closeEffect : Null<Popup->Actuator>;
    /** Indicates if popup is currently shown. */
    public var shown (default,null) : Bool = false;
    /** Dispatched when popup is shown */
    public var onShow (get,never) : PopupSignal;
    private var __onShow : PopupSignal = null;
    /** Dispatched when popup is closed */
    public var onClose (get,never) : PopupSignal;
    private var __onClose : PopupSignal = null;
    /** Overlay to use for blocking all objects behind popup from receiving user input. */
    public var overlay (get,set) : Widget;
    private var __overlay : Widget = null;
    /** Should this popup be closed if user pressed mouse button or started touch event outside of this popup? */
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

        __overlay = new Widget();
        __overlay.style       = null;
        __overlay.arrangeable = false;
        __overlay.width.pct   = 100;
        __overlay.height.pct  = 100;
    }


    /**
     * Show popup.
     *
     * If popup does not have a parent, then `visible` will be set to `true` and popup will be added to `Sx.root` display list.
     * If popup has a parent, then this method just switches `visible` to `true` and moves popup to the top of parents display list.
     */
    public function show () : Void
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

        if (showEffect != null) {
            __appearanceActuator = showEffect(this);
            __appearanceActuator.onComplete(__finalizeShow);
        } else {
            __finalizeShow();
        }
    }


    /**
     * Close popup.
     *
     * If popup is attached to `Sx.root` then popup is `Sx.root.removeChild(popup)` is called and `visible` changed to `false`.
     * If popup is attached to another widget (except `Sx.root`) then this method just switches `visible` to `false`.
     */
    public function close () : Void
    {
        if (!shown) return;
        shown = false;

        __stopAppearanceAnimation();
        Pointer.onPress.remove(__pointerGlobalPressed);

        if (closeEffect != null) {
            __appearanceActuator = closeEffect(this);
            __appearanceActuator.onComplete(__finalizeClose);
        } else {
            __finalizeClose();
        }
    }


    /**
     * Calls `show()` if popup is hidden or `close()` if popup is shown.
     */
    public function toggle () : Void
    {
        if (shown) {
            close();
        } else {
            show();
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
                close();
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
        __onShow.dispatch(this);
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
        __onClose.dispatch(this);
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


    /** Getters */
    private function get_visible ()       return (parent != null && visible == true);
    private function get_overlay ()       return __overlay;


    /** Typical signal getters */
    private function get_onShow ()        return (__onShow == null ? __onShow = new Signal() : __onShow);
    private function get_onClose ()       return (__onClose == null ? __onClose = new Signal() : __onClose);

}//class Popup