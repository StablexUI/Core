package sx.properties.metric;

import sx.properties.metric.SizeSetterProxy;
import sx.properties.metric.Size;
import sx.properties.metric.Units;
import sx.properties.Orientation;
import sx.exceptions.LockedPropertyException;
import sx.signals.Signal;


/**
 * Describes horizontal & vertical gap between some items.
 *
 */
class Gap extends SizeSetterProxy
{

    /** Horizontal gap */
    public var horizontal (default,null) : Size;
    /** Vertical gap */
    public var vertical (default,null) : Size;

    /**
     * Should provide owner width to specify horizontal gap with percentage.
     *
     * This property can be set one time only. Trying to change it will throw `sx.exceptions.LockedPropertyException`
     */
    @:noCompletion
    public var ownerWidth (default,set) : Null<Void->Size>;
    /**
     * Should provide owner height to specify vertical gap with percentage.
     *
     * This property can be set one time only. Trying to change it will throw `sx.exceptions.LockedPropertyException`
     */
    @:noCompletion
    public var ownerHeight (default,set) : Null<Void->Size>;

    /**
     * Callback to invoke when gap settings changed.
     *
     * @param   Bool    If horizontal gap changed.
     * @param   Bool    If vertical gap changed.
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

        horizontal = new Size(Horizontal);
        vertical   = new Size(Vertical);

        horizontal.onChange.add(__sideChanged);
        vertical.onChange.add(__sideChanged);

        horizontal.pctSource = __ownerWidthProvider;
        vertical.pctSource   = __ownerWidthProvider;

        onChange = new Signal();
    }


    /**
     * Called when a gap component changed.
     */
    private function __sideChanged (changed:Size, previousUnits:Units, previousValue:Float) : Void
    {
        if (__batchChanges) return;
        __invokeOnChange(changed.isHorizontal(), changed.isVertical());
    }


    /**
     * Change values for all components
     */
    private inline function __setAll (changed:SizeSetterProxy, units:Units, value:Float) : Void
    {
        __batchChanges = true;

        switch (units) {
            case Dip:
                horizontal.dip = value;
                vertical.dip   = value;
            case Pixel:
                horizontal.px = value;
                vertical.px   = value;
            case Percent:
                horizontal.pct = value;
                vertical.pct   = value;
        }

        __batchChanges = false;
        __invokeOnChange(true, true);
    }


    /**
     * Provides `pctSource` for gap components
     */
    private function __ownerWidthProvider () : Size
    {
        return (ownerWidth == null ? Size.zeroProperty : ownerWidth());
    }


    /**
     * Provides `pctSource` for gap components
     */
    private function __ownerHeightProvider () : Size
    {
        return (ownerHeight == null ? Size.zeroProperty : ownerHeight());
    }


    /**
     * Call `onChange` if it is set
     */
    private inline function __invokeOnChange (horizontal:Bool, vertical:Bool) : Void
    {
        onChange.dispatch(horizontal, vertical);
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

}//class Gap