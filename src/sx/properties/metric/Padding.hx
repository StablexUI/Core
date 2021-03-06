package sx.properties.metric;

import sx.properties.abstracts.ASize;
import sx.properties.abstracts.ASizeSetterProxy;
import sx.properties.metric.SizeSetterProxy;
import sx.properties.Orientation;
import sx.properties.Side;
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
    public var left (get,set) : ASize;
    private var __left : Size;
    /** Right border padding */
    public var right (get,set) : ASize;
    private var __right : Size;
    /** Top border padding */
    public var top (get,set) : ASize;
    private var __top : Size;
    /** Bottom border padding */
    public var bottom (get,set) : ASize;
    private var __bottom : Size;

    /** Set both `left` and `right` padding. */
    public var horizontal (get,set) : ASizeSetterProxy;
    private var __horizontal : SizeSetterProxy;
    /** Set both `top` and `bottom` padding. */
    public var vertical (get,set) : ASizeSetterProxy;
    private var __vertical : SizeSetterProxy;

    /** Should provide owner width to specify left/right padding with percentage. */
    public var ownerWidth : Null<Void->Size>;
    /** Should provide owner height to specify top/bottom padding with percentage. */
    public var ownerHeight : Null<Void->Size>;

    /**
     * Callback to invoke when one or more padding components changed.
     *
     * @param   Bool    If horizontal padding changed.
     * @param   Bool    If vertical padding changed.
     */
    public var onComponentsChange (default,null) : Signal<Bool->Bool->Void>;

    /** Indicates if `onChange` should not be called after each component change */
    private var __batchChanges : Bool = false;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        onChange.add(__setAll);

        __left   = new Size(Horizontal);
        __right  = new Size(Horizontal);
        __top    = new Size(Vertical);
        __bottom = new Size(Vertical);

        __left.onChange.add(__sideChanged);
        __right.onChange.add(__sideChanged);
        __top.onChange.add(__sideChanged);
        __bottom.onChange.add(__sideChanged);

        __left.pctSource   = __ownerWidthProvider;
        __right.pctSource  = __ownerWidthProvider;
        __top.pctSource    = __ownerHeightProvider;
        __bottom.pctSource = __ownerHeightProvider;

        onComponentsChange = new Signal();
    }


    /**
     * Called when a padding component changed.
     */
    private function __sideChanged (changed:Size, previousUnits:Units, previousValue:Float) : Void
    {
        if (__batchChanges) return;
        __invokeOnComponentsChange(changed.isHorizontal(), changed.isVertical());
    }


    /**
     * Called when a padding `vertical` or `horizontal` component changed.
     */
    private function __dimensionChanged (changed:Size, units:Units, value:Float) : Void
    {
        __batchChanges = true;

        if (changed.isHorizontal()) {
            __setDimension(left, right, units, value);
        } else {
            __setDimension(top, bottom, units, value);
        }

        __batchChanges = false;
        __invokeOnComponentsChange(changed.isHorizontal(), changed.isVertical());
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
    private inline function __setAll (changed:Size, units:Units, value:Float) : Void
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
        __invokeOnComponentsChange(true, true);
    }


    /**
     * Call `onChange` if it is set
     */
    private inline function __invokeOnComponentsChange (horizontal:Bool, vertical:Bool) : Void
    {
        onComponentsChange.dispatch(horizontal, vertical);
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
     * Make sure current value does not violate `min` and `max` constraints
     */
    override private function __constraintChanged (constraint:Size, previousUnits:Units, previousValue:Float) : Void
    {
        super.__constraintChanged(constraint, previousUnits, previousValue);

        if (constraint == __min) {
            if (__horizontal != null) {
                __horizontal.min = constraint;
            } else {
                left.min  = constraint;
                right.min = constraint;
            }

            if (__vertical != null) {
                __vertical.min = constraint;
            } else {
                top.min    = constraint;
                bottom.min = constraint;
            }

        } else if (constraint == __max) {
            if (__horizontal != null) {
                __horizontal.max = constraint;
            } else {
                left.max  = constraint;
                right.max = constraint;
            }

            if (__vertical != null) {
                __vertical.max = constraint;
            } else {
                top.max    = constraint;
                bottom.max = constraint;
            }
        }
    }


    /**
     * vertical min/max changed
     */
    private function __verticalConstraintChanged (constraint:Size, previousUnits:Units, previousValue:Float) : Void
    {
        if (constraint == __vertical.max) {
            top.max    = constraint;
            bottom.max = constraint;
        } else if (constraint == __vertical.min) {
            top.min    = constraint;
            bottom.min = constraint;
        }
    }


    /**
     * horizontal min/max changed
     */
    private function __horizontalConstraintChanged (constraint:Size, previousUnits:Units, previousValue:Float) : Void
    {
        if (constraint == __horizontal.max) {
            left.max  = constraint;
            right.max = constraint;
        } else if (constraint == __horizontal.min) {
            left.min  = constraint;
            right.min = constraint;
        }
    }


    /**
     * Getter `horizontal`
     */
    private function get_horizontal () : ASizeSetterProxy
    {
        if (__horizontal == null) {
            __horizontal = new SizeSetterProxy(Horizontal);
            __horizontal.onChange.add(__dimensionChanged);
            __horizontal.min.onChange.add(__horizontalConstraintChanged);
            __horizontal.max.onChange.add(__horizontalConstraintChanged);
        }

        return __horizontal;
    }


    /**
     * Getter `vertical`
     */
    private function get_vertical () : ASizeSetterProxy
    {
        if (__vertical == null) {
            __vertical = new SizeSetterProxy(Vertical);
            __vertical.onChange.add(__dimensionChanged);
            __vertical.min.onChange.add(__verticalConstraintChanged);
            __vertical.max.onChange.add(__verticalConstraintChanged);
        }

        return __vertical;
    }


    /**
     * Setter `horizontal`
     */
    private function set_horizontal (value:ASizeSetterProxy) : ASizeSetterProxy
    {
        var proxy : SizeSetterProxy = horizontal;
        proxy.copyValueFrom(value);

        return proxy;
    }


    /**
     * Setter `vertical`
     */
    private function set_vertical (value:ASizeSetterProxy) : ASizeSetterProxy
    {
        var proxy : SizeSetterProxy = vertical;
        proxy.copyValueFrom(value);

        return proxy;
    }


    /**
     * Get string representation
     */
    override public function toString () : String
    {
        return '{ left : $left, top : $top, right : $right, bottom : $bottom }';
    }


    /** Getters */
    private function get_left ()     return __left;
    private function get_right ()    return __right;
    private function get_top ()      return __top;
    private function get_bottom ()   return __bottom;

    /** Setters */
    private function set_left (v)     return __left.copyValueFrom(v);
    private function set_right (v)    return __right.copyValueFrom(v);
    private function set_top (v)      return __top.copyValueFrom(v);
    private function set_bottom (v)   return __bottom.copyValueFrom(v);

}//class Padding