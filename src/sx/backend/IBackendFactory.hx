package sx.backend;

import sx.backend.IBackend;
import sx.widgets.Widget;


/**
 * Backend factory interface.
 *
 * Constructor should take no arguments.
 */
interface IBackendFactory
{

    /**
     * Create backend for simple widget
     */
    public function forWidget (widget:Widget) : IBackend ;

}//interface IBackendFactory