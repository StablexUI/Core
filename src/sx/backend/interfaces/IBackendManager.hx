package sx.backend.interfaces;

import sx.backend.Backend;
import sx.backend.BitmapRenderer;
import sx.backend.Point;
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
     * Map mouse/touch events to StablexUI signals
     */
    public function setupPointerDevices () : Void ;

    /**
     * Start calling `Sx.frame()` on each frame.
     */
    public function setupFrames () : Void ;

    /**
     * Return widget which will be used for `sx.Sx.root`.
     */
    public function getRoot () : Widget ;

    /**
     * Get pointer global position (mouse cursor or touch with specified `touchId`).
     *
     * If `touchId` is less or equal to `0` it should return mouse position or first touch position.
     */
    public function getPointerPosition (touchId:Int = 0) : Point ;

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