package sx.backend.interfaces;

import sx.backend.Backend;
import sx.backend.TextRenderer;
import sx.widgets.Text;
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
    public function widgetBackend (widget:Widget) : Backend ;

    /**
     * Create native text renderer for text field
     */
    public function textRenderer (textField:Text) : TextRenderer ;

}//interface IBackendFactory