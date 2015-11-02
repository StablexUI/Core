package sx.backend.dummy;

import sx.backend.Backend;
import sx.backend.BitmapRenderer;
import sx.backend.interfaces.IBackendManager;
import sx.backend.Point;
import sx.backend.TextInputRenderer;
import sx.backend.TextRenderer;
import sx.widgets.Bmp;
import sx.widgets.Text;
import sx.widgets.TextInput;
import sx.widgets.Widget;



/**
 * Backend factory implementation
 *
 */
class BackendManager implements IBackendManager
{
    /** widget for `sx.Sx.root` */
    private var __root : Widget;


    /**
     * Constructor
     */
    public function new () : Void
    {

    }


    /**
     * Map mouse/touch events to StablexUI signals
     */
    public function setupPointerDevices () : Void
    {

    }


    /**
     * Start calling `Sx.frame()` on each frame.
     */
    public function setupFrames () : Void
    {

    }


    /**
     * Get pointer global position (mouse cursor or touch with specified `touchId`).
     *
     * If `touchId` is less or equal to `0` it should return mouse position or first touch position.
     */
    public function getPointerPosition (touchId:Int = 0) : Point
    {
        return new Point();
    }


    /**
     * Return widget which will be used for `sx.Sx.root`
     */
    public function getRoot () : Widget
    {
        if (__root == null) {
            __root = new Widget();
        }

        return __root;
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
     * Create native input text renderer
     */
    public function textInputRenderer (textInput:TextInput) : TextInputRenderer
    {
        return new TextInputRenderer(textInput);
    }


    /**
     * Create native bitmap renderer for Bmp widget
     */
    public function bitmapRenderer (bmp:Bmp) : BitmapRenderer
    {
        return new BitmapRenderer(bmp);
    }

}//class BackendManager