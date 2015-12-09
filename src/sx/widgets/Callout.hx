package sx.widgets;

import sx.properties.abstracts.ASize;
import sx.properties.metric.Size;
import sx.properties.metric.Units;
import sx.properties.Side;
import sx.signals.Signal;
import sx.signals.CalloutSignal;
import sx.Sx;
import sx.widgets.base.Floating;
import sx.tween.Actuator;
import sx.widgets.Widget;
import sx.backend.Point;


/**
 * Callout is a tooltip-like widget and usually appears somewhere near a widget, which user is currently interacting with.
 *
 */
class Callout extends Floating
{
    /**
     * List of sides where to show callout relative to target widget. Ordered by priority from the highest to the lowest.
     * By default: `[Top, Left, Bottom, Right]`.
     *
     * This means that by default callout will be shown on top of target widget. But if there is not enough space between
     * target widget and top stage border, then callout will be placed to the left of the target. And so on for `Right`
     * and `Bottom` sides. If there is no side where callout can fit between target widget and stage border, then callout
     * be shown on the side with highest priority, which is `Top` in this case.
     */
    public var sidePriority : Array<Side>;
    /**
     * Function which is called by callout to obtain an arrow widget which will be used to point at the target when
     * callout is shown at specified `Side` relative to target.
     * Returned arrows will be cached for each side. So `arrowFactory` will not be called twice for the same `Side`
     */
    public var arrowFactory : Null<Callout->Side->Null<Widget>>;
    private var __arrows : Map<Side, Widget>;
    /** Currently used arrow */
    public var arrow (default,null) : Null<Widget>;
    /** Widget which triggered this callout */
    public var currentTarget (default,null) : Null<Widget>;
    /**
     * Distance between callout and target widget.
     * Please note, that arrow size is not taken into account and `targetGap` describes distance between own
     * callout border and a border of target widget.
     */
    public var targetGap (get,set) : ASize;
    private var __targetGap : Size;
    /** Which side relative to target widget callout is shown at. This property is meaningless if callout is hidden. */
    public var currentSide (default,null) : Side = Top;
    /**
     * Callback which implements callout reveal animation when callout is shown.
     * If this property is set, then `onShow` signal will be dispatched after appearance animation is finished.
     * E.g. fade in effect may look like this:
     * ```
     * callout.showEffect = function (c) {
     *      c.alpha = 0;
     *      var actuator = p.tween.linear(1, c.alpha = 1);
     *      return actuator;
     * }
     * ```
     */
    public var showEffect : Null<Callout->Actuator>;
    /**
     * Callback which implements callout dissapeearance animation when callout is closed.
     * If this property is set, then `onClose` signal will be dispatched after disappearance animation is finished.
     */
    public var closeEffect : Null<Callout->Actuator>;
    /** Dispatched when callout is shown */
    public var onShow (get,never) : CalloutSignal;
    private var __onShow : CalloutSignal = null;
    /** Dispatched when callout is closed */
    public var onClose (get,never) : CalloutSignal;
    private var __onClose : CalloutSignal = null;

    /** If we need to update callout position */
    private var __positionUpdateRequired : Bool = false;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        __arrows = new Map();
        sidePriority = [Top, Left, Bottom, Right];
        __targetGap = new Size();
    }


    /**
     * Show callout near specified `target`.
     *
     * If callout does not have a parent, then `visible` will be set to `true` and callout will be added to `Sx.root` display list.
     * If callout has a parent, then this method just switches `visible` to `true` and moves callout to the top of parents display list.
     */
    public function show (target:Widget) : Void
    {
        if (shown && currentTarget == target) {
            return;
        }

        currentTarget = target;
        initialize();
        __selectPosition();
        __setArrow();
        __adjustArrow();

        __show();
    }


    /**
     * Close callout.
     *
     * If callout is attached to `Sx.root` then callout is `Sx.root.removeChild(callout)` is called and `visible` changed to `false`.
     * If callout is attached to another widget (except `Sx.root`) then this method just switches `visible` to `false`.
     */
    public function close () : Void
    {
        __close();
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
        currentTarget = null;
        __onClose.dispatch(this);
    }


    /**
     * Process global pointer press signals to deal with `closeOnPointerPressOutside`
     */
    override private function __pointerGlobalPressed (dispatcher:Null<Widget>, touchId:Int) : Void
    {
        if (currentTarget != null && currentTarget.contains(dispatcher)) {
            return;
        }

        super.__pointerGlobalPressed(dispatcher, touchId);
    }


    /**
     * Find at which side callout should be shown and set appropriate coordinates for callout.
     */
    private function __selectPosition () : Void
    {
        //find bounds of target widget
        var container   = __getShowContainer();
        var leftTop     = container.globalToLocal(currentTarget.localToGlobal(new Point(0, 0)));
        var rightBottom = container.globalToLocal(currentTarget.localToGlobal(new Point(currentTarget.width.px, currentTarget.height.px)));

        var success = false;
        var force = false;
        do {
            for (side in sidePriority) {
                success = switch (side) {
                    case Top    : __tryTopSide(leftTop, rightBottom, force);
                    case Bottom : __tryBottomSide(leftTop, rightBottom, force);
                    case Left   : __tryLeftSide(leftTop, rightBottom, force);
                    case Right  : __tryRightSide(leftTop, rightBottom, force);
                }
                if (success) break;
            }
            force = !success;
        } while (!success);
    }


    /**
     * Try to place callout on top of target widget
     */
    private function __tryTopSide (targetLeftTop:Point, targetRightBottom:Point, force:Bool) : Bool
    {
        var container    = __getShowContainer();
        var targetWidth  = targetRightBottom.x - targetLeftTop.x;
        var targetHeight = targetRightBottom.y - targetLeftTop.y;
        var x = targetLeftTop.x + (targetWidth - width.px) * 0.5;
        var y = targetLeftTop.y - height.px - targetGap.px;

        var calloutStageLeftTop = container.localToGlobal(new Point(x, y));
        var calloutStageRightBottom = container.localToGlobal(new Point(x + width.px, y + height.px));

        if (!force && calloutStageLeftTop.y < 0) {
            return false;
        }

        if (calloutStageLeftTop.x < 0) {
            calloutStageLeftTop.x = 0;
        } else if (calloutStageRightBottom.x > Sx.stageWidth.px) {
            calloutStageLeftTop.x -= (calloutStageRightBottom.x - Sx.stageWidth.px);
        }

        var calloutLeftTop = container.globalToLocal(calloutStageLeftTop);

        left.px = calloutLeftTop.x;
        top.px  = calloutLeftTop.y;

        currentSide = Top;

        return true;
    }


    /**
     * Try to place callout to the bottom of target widget
     */
    private function __tryBottomSide (targetLeftTop:Point, targetRightBottom:Point, force:Bool) : Bool
    {
        var container    = __getShowContainer();
        var targetWidth  = targetRightBottom.x - targetLeftTop.x;
        var targetHeight = targetRightBottom.y - targetLeftTop.y;
        var x = targetLeftTop.x + (targetWidth - width.px) * 0.5;
        var y = targetRightBottom.y + targetGap.px;

        var calloutStageLeftTop = container.localToGlobal(new Point(x, y));
        var calloutStageRightBottom = container.localToGlobal(new Point(x + width.px, y + height.px));

        if (!force && calloutStageRightBottom.y > Sx.stageHeight.px) {
            return false;
        }

        if (calloutStageLeftTop.x < 0) {
            calloutStageLeftTop.x = 0;
        } else if (calloutStageRightBottom.x > Sx.stageWidth.px) {
            calloutStageLeftTop.x -= (calloutStageRightBottom.x - Sx.stageWidth.px);
        }

        var calloutLeftTop = container.globalToLocal(calloutStageLeftTop);
        left.px = calloutLeftTop.x;
        top.px  = calloutLeftTop.y;

        currentSide = Bottom;

        return true;
    }


    /**
     * Try to place callout to the left of target widget
     */
    private function __tryLeftSide (targetLeftTop:Point, targetRightBottom:Point, force:Bool) : Bool
    {
        var container    = __getShowContainer();
        var targetWidth  = targetRightBottom.x - targetLeftTop.x;
        var targetHeight = targetRightBottom.y - targetLeftTop.y;
        var x = targetLeftTop.x - targetGap.px - width.px;
        var y = targetLeftTop.y + (targetHeight - height.px) * 0.5;

        var calloutStageLeftTop = container.localToGlobal(new Point(x, y));
        var calloutStageRightBottom = container.localToGlobal(new Point(x + width.px, y + height.px));

        if (!force && calloutStageLeftTop.x < 0) {
            return false;
        }

        if (calloutStageLeftTop.y < 0) {
            calloutStageLeftTop.y = 0;
        } else if (calloutStageRightBottom.y > Sx.stageHeight.px) {
            calloutStageLeftTop.y -= (calloutStageRightBottom.y - Sx.stageHeight.px);
        }

        var calloutLeftTop = container.globalToLocal(calloutStageLeftTop);
        left.px = calloutLeftTop.x;
        top.px  = calloutLeftTop.y;

        currentSide = Left;

        return true;
    }


    /**
     * Try to place callout to the right of target widget
     */
    private function __tryRightSide (targetLeftTop:Point, targetRightBottom:Point, force:Bool) : Bool
    {
        var container    = __getShowContainer();
        var targetWidth  = targetRightBottom.x - targetLeftTop.x;
        var targetHeight = targetRightBottom.y - targetLeftTop.y;
        var x = targetRightBottom.x + targetGap.px;
        var y = targetLeftTop.y + (targetHeight - height.px) * 0.5;

        var calloutStageLeftTop = container.localToGlobal(new Point(x, y));
        var calloutStageRightBottom = container.localToGlobal(new Point(x + width.px, y + height.px));

        if (!force && calloutStageRightBottom.x > Sx.stageWidth.px) {
            return false;
        }

        if (calloutStageLeftTop.y < 0) {
            calloutStageLeftTop.y = 0;
        } else if (calloutStageRightBottom.y > Sx.stageHeight.px) {
            calloutStageLeftTop.y -= (calloutStageRightBottom.y - Sx.stageHeight.px);
        }

        var calloutLeftTop = container.globalToLocal(calloutStageLeftTop);
        left.px = calloutLeftTop.x;
        top.px  = calloutLeftTop.y;

        currentSide = Right;

        return true;
    }


    /**
     * Set correct arrow depending on current side
     */
    private function __setArrow () : Void
    {
        arrow = __arrows.get(currentSide);
        if (arrow != null) return;

        if (arrowFactory != null) {
            arrow = arrowFactory(this, currentSide);
            if (arrow != null) {
                __arrows.set(currentSide, arrow);
            }
        }
    }


    /**
     * Move arrow to correct position
     */
    private function __adjustArrow () : Void
    {
        if (arrow == null) return;

        switch (currentSide) {
            case Top:
                arrow.offset.set(-0.5, 1);
                arrow.left.pct = 50;
                arrow.bottom.dip = 0;
            case Bottom:
                arrow.offset.set(-0.5, -1);
                arrow.left.pct = 50;
                arrow.top.dip = 0;
            case Left:
                arrow.offset.set(1, -0.5);
                arrow.top.pct = 50;
                arrow.right.dip = 0;
            case Right:
                arrow.offset.set(-1, -0.5);
                arrow.top.pct = 50;
                arrow.left.dip = 0;
        }

        arrow.arrangeable = false;
        addChild(arrow);
    }


    /**
     * Which widget will become callout parent when `show()` will be called.
     */
    private function __getShowContainer () : Widget
    {
        return (parent == null ? Sx.root : parent);
    }


    /** Getters */
    private function get_targetGap ()       return __targetGap;

    /** Setters */
    private function set_targetGap (v)       return __targetGap.copyValueFrom(v);

    /** Typical signal getters */
    private function get_onShow ()        return (__onShow == null ? __onShow = new Signal() : __onShow);
    private function get_onClose ()       return (__onClose == null ? __onClose = new Signal() : __onClose);

}//class Callout