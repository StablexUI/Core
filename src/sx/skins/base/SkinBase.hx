package sx.skins.base;

import sx.widgets.Widget;



/**
 * Base class for skins.
 * Skin rendering should be implemented by backend.
 */
class SkinBase
{

    /** Callback to invoke when skin changes */
    public var onChange : Null<Skin->Void>;


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
    @:allow(sx.widgets.Widget)
    private function usedBy (widget:Widget) : Void
    {

    }


    /**
     * If this skin is no longer in use by current widget
     */
    @:allow(sx.widgets.Widget)
    private function removed () : Void
    {

    }

}//class SkinBase