package sx.skins.base;

import sx.widgets.Widget;



/**
 * Base class for skins.
 * Skin rendering should be implemented by backend.
 */
class SkinBase
{
    /** Widget this skin is currently applied to */
    private var __widget : Widget;
    /** Callback to invoke when skin changes */
    public var onChange : Null<Void->Void>;


    /**
     * Constructor
     */
    public function new () : Void
    {

    }


    /**
     * Called when skin is set for a `widget`.
     * Don't perform any actions (like drawing) with `widget` here. Just store a reference to `widget` if required.
     */
    public function usedBy (widget:Widget) : Void
    {
        if (__widget != null) __widget.skin = null;

        __widget = widget;
    }


    /**
     * If this skin is no longer in use by current widget
     */
    public function removed () : Void
    {
        __widget = null;
    }


    /**
     * Used internally to call `onChange` if it is set when some property of this skin is changed.
     */
    private function __invokeOnChange () : Void
    {
        if (onChange != null) onChange();
    }

}//class SkinBase