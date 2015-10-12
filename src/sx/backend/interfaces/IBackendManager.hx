package sx.backend.interfaces;

import sx.backend.Backend;
import sx.backend.BitmapRenderer;
import sx.backend.TextRenderer;
import sx.widgets.Bmp;
import sx.widgets.Text;
import sx.widgets.TextInput;
import sx.widgets.Widget;


/**
 * Backend factory interface.
 *
 * Constructor should take no arguments.
 */
interface IBackendManager
{

    /**
     * Create backend for simple widget
     */
    public function widgetBackend (widget:Widget) : Backend ;

    /**
     * Create native text renderer for text field
     */
    public function textRenderer (textField:Text) : TextRenderer ;

    /**
     * Create native input text renderer
     */
    public function textInputRenderer (textInput:TextInput) : TextInputRenderer ;

    /**
     * Create native bitmap renderer for Bmp widget
     */
    public function bitmapRenderer (bmp:Bmp) : BitmapRenderer ;

}//interface IBackendManager