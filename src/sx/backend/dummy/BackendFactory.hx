package sx.backend.dummy;

import sx.backend.Backend;
import sx.backend.BitmapRenderer;
import sx.backend.interfaces.IBackendFactory;
import sx.backend.TextRenderer;
import sx.widgets.Bmp;
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


    /**
     * Create native bitmap renderer for Bmp widget
     */
    public function bitmapRenderer (bmp:Bmp) : BitmapRenderer
    {
        return new BitmapRenderer(bmp);
    }

}//class BackendFactory