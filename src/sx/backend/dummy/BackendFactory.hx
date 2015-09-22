package sx.backend.dummy;

import sx.backend.Backend;
import sx.backend.interfaces.IBackendFactory;
import sx.backend.TextRenderer;
import sx.widgets.Text;
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
    public function widgetBackend (widget:Widget) : Backend
    {
        return new Backend(widget);
    }


    /**
     * Create native text renderer for text field
     */
    public function textRenderer (textField:Text) : TextRenderer
    {
        return new TextRenderer(textField);
    }


}//class BackendFactory