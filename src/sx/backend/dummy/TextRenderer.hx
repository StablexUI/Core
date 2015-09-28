package sx.backend.dummy;

import sx.backend.interfaces.ITextRenderer;
import sx.backend.TextFormat;
import sx.widgets.Text;



/**
 * Dummy text renderer
 *
 */
class TextRenderer implements ITextRenderer
{
    /** Owner */
    private var __textField : Text;
    /** Content */
    private var __text : String = '';
    /** Callback to invoke when content resized */
    private var __onResize : Float->Float->Void;
    /** Formatting settings */
    private var __format : TextFormat;


    /**
     * Constructor
     */
    public function new (textField:Text) : Void
    {
        __textField = textField;
    }


    /**
     * Set content
     */
    public function setText (text:String) : Void
    {
        __text = text;
        if (__onResize != null) __onResize(getWidth(), getHeight());
    }


    /**
     * Get text formatting settings.
     */
    public function getFormat () : TextFormat
    {
        return __format;
    }


    /**
     * Set text formatting settings.
     */
    public function setFormat (format:TextFormat) : Void
    {
        __format = format;
    }


    /**
     * Set callback to invoke when content size changed
     */
    public function onResize (callback:Null<Float->Float->Void>) : Void
    {
        __onResize = callback;
    }


    /**
     * Returns width of rendered text
     */
    public function getWidth () : Float
    {
        //find longest line
        var max     = 0;
        var nlPos   = 0;
        var prevPos = 0;
        do {
            nlPos = __text.indexOf('\n', prevPos);
            if (nlPos > 0 && nlPos - prevPos > max) {
                max = nlPos - prevPos;
            }
            prevPos = nlPos + 1;
        } while (nlPos >= 0);

        return max;
    }


    /**
     * Returns height of rendered text
     */
    public function getHeight () : Float
    {
        var linesCount = 0;
        var pos = __text.indexOf('\n');
        while (pos >= 0) {
            pos = __text.indexOf('\n', pos + 1);
        }

        return linesCount;
    }


    /**
     * Notify renderer about changing width area available for content.
     */
    public function setAvailableAreaWidth (width:Float) : Void
    {

    }


    /**
     * Notify renderer about changing height area available for content.
     */
    public function setAvailableAreaHeight (height:Float) : Void
    {

    }


    /**
     * Method to cleanup and release this object for garbage collector.
     */
    public function dispose () : Void
    {
        __textField = null;
    }

}//class TextRenderer