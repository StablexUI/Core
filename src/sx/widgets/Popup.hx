package sx.widgets;

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
     * Called after popup is shown or appearance animation is finished.
     */
    private function __finalizeShow () : Void
    {
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


    /** Getters */
    private function get_visible ()       return (parent != null && visible == true);


    /** Typical signal getters */
    private function get_onShow ()        return (__onShow == null ? __onShow = new Signal() : __onShow);
    private function get_onClose ()       return (__onClose == null ? __onClose = new Signal() : __onClose);

}//class Popup