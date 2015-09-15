package sx.skins.base;

import sx.widgets.Widget;



/**
 * Base class for skins
 *
 */
class SkinBase
{

    // /** Widget this skin is applied to */
    // private var widget : Widget;

    /** Callback to invoke when skin changes */
    public var onChange : Null<Skin->Void>;


    // /**
    //  * called when skin is set for specified `widget`
    //  */
    // @:allow(sx.widgets.Widget)
    // private inline function usedBy (widget:Widget) : Void
    // {
    //     this.widget = widget;
    // }


    // /**
    //  * If this skin is no longer in use by current widget
    //  */
    // private inline function removed () : Void
    // {
    //     widget = null;
    // }


    /**
     * Invoke `onChange` callback if provided.
     */
    private inline function invokeOnChange () : Void
    {
        if (onChange != null) onChange(this);
    }

}//class SkinBase