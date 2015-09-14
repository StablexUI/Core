package sx.backend;

import sx.widgets.Widget;
import sx.backend.TBackend;




typedef TBackendFactory = IBackendFactory;



/**
 * Backend factory interface
 *
 */
interface IBackendFactory
{

    /**
     * Create backend for simple widget
     */
    public function forWidget (widget:Widget) : TBackend ;

}//interface IBackendFactory