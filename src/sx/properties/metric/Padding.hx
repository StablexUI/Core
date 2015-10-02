package sx.properties.metric;

import sx.exceptions.LockedPropertyException;
import sx.properties.metric.SizeSetterProxy;
import sx.properties.Orientation;
import sx.properties.metric.Units;
import sx.properties.metric.Size;
import sx.signals.Signal;



/**
 * Describes 4 directinal padding
 *
 */
class Padding extends SizeSetterProxy
{
    /** Left border padding */
    public var left (default,null) : Size;
    /** Right border padding */
    public var right (default,null) : Size;
    /** Top border padding */
    public var top (default,null) : Size;
    /** Bottom border padding */
    public var bottom (default,null) : Size;

    /** Set both `left` and `right` padding. */
    public var horizontal (get,never) : SizeSetterProxy;
    private var __horizontal : SizeSetterProxy;
    /** Set both `top` and `bottom` padding. */
    public var vertical (get,never) : SizeSetterProxy;
    private var __vertical : SizeSetterProxy;

    /**
     * Should provide owner width to specify left/right padding with percentage.
     *
     * This property can be set one time only. Trying to change it will throw `sx.exceptions.LockedPropertyException`
     */
    @:noCompletion
    public var ownerWidth (default,set) : Null<Void->Size>;
    /**
     * Should provide owner height to specify top/bottom padding with percentage.
     *
     * This property can be set one time only. Trying to change it will throw `sx.exceptions.LockedPropertyException`
     */
    @:noCompletion
    public var ownerHeight (default,set) : Null<Void->Size>;

    /**
     * Callback to invoke when padding settings changed.
     *
     * @param   Bool    If horizontal padding changed.
     * @param   Bool    If vertical padding changed.
     */
    public var onChange (default,null) : Signal<Bool->Bool->Void>;

    /** Indicates if `onChange` should not be called after each component change */
    private var __batchChanges : Bool = false;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        onSet.add(__setAll);

        left   = new Size(Horizontal);
        right  = new Size(Horizontal);
        top    = new Size(Vertical);
        bottom = new Size(Vertical);

        left.onChange.add(__sideChanged);
        right.onChange.add(__sideChanged);
        top.onChange.add(__sideChanged);
        bottom.onChange.add(__sideChanged);

        left.pctSource   = __ownerWidthProvider;
        right.pctSource  = __ownerWidthProvider;
        top.pctSource    = __ownerHeightProvider;
        bottom.pctSource = __ownerHeightProvider;

        onChange = new Signal();
    }


    /**
     * Returns `true` if all padding components set to `0`
     */
    @:access(sx.properties.metric.Size)
    public function isZero () : Bool
    {
        var leftZero   = (left.__value == 0);
        var rightZero  = (right.__value == 0);
        var topZero    = (top.__value == 0);
        var bottomZero = (bottom.__value == 0);

        return (leftZero && rightZero && topZero && bottomZero);
    }


    /**
     * Called when a padding component changed.
     */
    private function __sideChanged (changed:Size, previousUnits:Units, previousValue:Float) : Void
    {
        if (__batchChanges) return;
        __invokeOnChange(changed.isHorizontal(), changed.isVertical());
    }


    /**
     * Called when a padding `vertical` or `horizontal` component changed.
     */
    private function __dimensionChanged (changed:SizeSetterProxy, units:Units, value:Float) : Void
    {
        __batchChanges = true;

        if (changed.isHorizontal()) {
            __setDimension(left, right, units, value);
        } else {
            __setDimension(top, bottom, units, value);
        }

        __batchChanges = false;
        __invokeOnChange(changed.isHorizontal(), changed.isVertical());
    }


    /**
     * Change values for `first` and `second`
     */
    private inline function __setDimension (first:Size, second:Size, units:Units, value:Float) : Void
    {
        switch (units) {
            case Dip:
                first.dip  = value;
                second.dip = value;
            case Pixel:
                first.px  = value;
                second.px = value;
            case Percent:
                first.pct  = value;
                second.pct = value;
        }
    }



    /**
     * Change values for all components
     */
    private inline function __setAll (changed:SizeSetterProxy, units:Units, value:Float) : Void
    {
        __batchChanges = true;

        switch (units) {
            case Dip:
                left.dip   = value;
                right.dip  = value;
                top.dip    = value;
                bottom.dip = value;
            case Pixel:
                left.px   = value;
                right.px  = value;
                top.px    = value;
                bottom.px = value;
            case Percent:
                left.pct   = value;
                right.pct  = value;
                top.pct    = value;
                bottom.pct = value;
        }

        __batchChanges = false;
        __invokeOnChange(true, true);
    }


    /**
     * Call `onChange` if it is set
     */
    private inline function __invokeOnChange (horizontal:Bool, vertical:Bool) : Void
    {
        onChange.dispatch(horizontal, vertical);
    }


    /**
     * Provides `pctSource` for padding components
     */
    private function __ownerWidthProvider () : Size
    {
        return (ownerWidth == null ? Size.zeroProperty : ownerWidth());
    }


    /**
     * Provides `pctSource` for padding components
     */
    private function __ownerHeightProvider () : Size
    {
        return (ownerHeight == null ? Size.zeroProperty : ownerHeight());
    }


    /**
     * Getter `horizontal`
     */
    private function get_horizontal () : SizeSetterProxy
    {
        if (__horizontal == null) {
            __horizontal = new SizeSetterProxy(Horizontal);
            __horizontal.onSet.add(__dimensionChanged);
        }

        return __horizontal;
    }


    /**
     * Getter `vertical`
     */
    private function get_vertical () : SizeSetterProxy
    {
        if (__vertical == null) {
            __vertical = new SizeSetterProxy(Vertical);
            __vertical.onSet.add(__dimensionChanged);
        }

        return __vertical;
    }


    /**
     * Setter `ownerWidth`
     */
    private function set_ownerWidth (value:Void->Size) : Void->Size
    {
        if (ownerWidth != null) {
            throw new LockedPropertyException();
        }

        return ownerWidth = value;
    }


    /**
     * Setter `ownerHeight`
     */
    private function set_ownerHeight (value:Void->Size) : Void->Size
    {
        if (ownerHeight != null) {
            throw new LockedPropertyException();
        }

        return ownerHeight = value;
    }


}//class Padding