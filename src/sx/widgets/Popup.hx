package sx.widgets;

import sx.signals.Signal;
import sx.signals.PopupSignal;
import sx.widgets.base.Floating;
import sx.tween.Actuator;



/**
 * Base class for widgets rendered on top of all other UI.
 *
 */
class Popup extends Floating
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
    /** Dispatched when popup is shown */
    public var onShow (get,never) : PopupSignal;
    private var __onShow : PopupSignal = null;
    /** Dispatched when popup is closed */
    public var onClose (get,never) : PopupSignal;
    private var __onClose : PopupSignal = null;


    /**
     * Show popup.
     *
     * If popup does not have a parent, then `visible` will be set to `true` and popup will be added to `Sx.root` display list.
     * If popup has a parent, then this method just switches `visible` to `true` and moves popup to the top of parents display list.
     */
    public function show () : Void
    {
        __show();
    }


    /**
     * Close popup.
     *
     * If popup is attached to `Sx.root` then popup is `Sx.root.removeChild(popup)` is called and `visible` changed to `false`.
     * If popup is attached to another widget (except `Sx.root`) then this method just switches `visible` to `false`.
     */
    public function close () : Void
    {
        __close();
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
     * Override in descendants to animate widget appearance
     */
    override private function __showEffect () : Null<Actuator>
    {
        return (showEffect == null ? null : showEffect(this));
    }


    /**
     * Override in descendants to animate widget disappearance
     */
    override private function __closeEffect () : Null<Actuator>
    {
        return (closeEffect == null ? null : closeEffect(this));
    }


    /**
     * Override in descendants to dispatch `onShow` signals
     */
    override private function __shown () : Void
    {
        __onShow.dispatch(this);
    }


    /**
     * Override in descendants to dispatch `onClose` signals
     */
    override private function __closed () : Void
    {
        __onClose.dispatch(this);
    }


    /** Typical signal getters */
    private function get_onShow ()        return (__onShow == null ? __onShow = new Signal() : __onShow);
    private function get_onClose ()       return (__onClose == null ? __onClose = new Signal() : __onClose);

}//class Popup