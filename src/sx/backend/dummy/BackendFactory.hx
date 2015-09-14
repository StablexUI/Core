package sx.backend.dummy;

import sx.backend.IBackend;
import sx.backend.IBackendFactory;
import sx.backend.dummy.Backend;
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
    public function forWidget (widget:Widget) : IBackend
    {
        return new Backend(widget);
    }

}//class BackendFactory