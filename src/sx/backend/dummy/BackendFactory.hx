package sx.backend.dummy;

import sx.backend.interfaces.IBackendFactory;
import sx.widgets.Widget;



/**
 * Backend factory implementation
 *
 */
class BackendFactory implements IBackendFactory
{

    /**
     * Constructor
     */
    public function new () : Void
    {

    }


    /**
     * Create backend for simple widget
     */
    public function forWidget (widget:Widget) : TBackend
    {
        return new TBackend(widget);
    }

}//class BackendFactory