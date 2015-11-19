package sx.backend.dummy;

import sx.backend.interfaces.ITextInputRenderer;
import sx.backend.TextFormat;
import sx.widgets.TextInput;



/**
 * Dummy text input renderer
 *
 */
class TextInputRenderer implements ITextInputRenderer
{
    /** Owner */
    private var __textInput : TextInput;
    /** Content */
    public var text (get,set) : String;
    private var __text : String = '';
    /** Callback to invoke when content resized */
    private var __onTextChange : String->Void;
    /** Formatting settings */
    private var __format : TextFormat;
    /** Width (pixels) */
    private var __width : Float = 0;
    /** Height (pixels) */
    private var __height : Float = 0;


    /**
     * Constructor
     */
    public function new (textInput:TextInput) : Void
    {
        __textInput = textInput;
    }


    /**
     * Set/remove callback which will be called when user changes content of text field
     */
    public function onTextChange (onTextChange:Null<String->Void>) : Void
    {
        __onTextChange = onTextChange;
    }


    /**
     * Set/remove callback which will be called when user places cursor in this input.
     */
    public function onReceiveCursor (callback:Null<Void->Void>) : Void
    {

    }


    /**
     * Set/remove callback which will be called when user removes cursor from this input.
     */
    public function onLoseCursor (callback:Null<Void->Void>) : Void
    {

    }


    /**
     * Get curren content
     */
    public function getText () : String
    {
        return __text;
    }


    /**
     * Set content.
     * Should not call `onTextChange` callback.
     */
    public function setText (text:String) : Void
    {
        __text = text;
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
        //no need to handle resizing for text input
    }


    /**
     * Returns width of rendered text
     */
    public function getWidth () : Float
    {
        return __width;
    }


    /**
     * Returns height of rendered text
     */
    public function getHeight () : Float
    {
        return __height;
    }


    /**
     * Notify renderer about changing width area available for content.
     */
    public function setAvailableAreaWidth (width:Float) : Void
    {
        __width = width;
    }


    /**
     * Notify renderer about changing height area available for content.
     */
    public function setAvailableAreaHeight (height:Float) : Void
    {
        __height = height;
    }


    /**
     * Method to cleanup and release this object for garbage collector.
     */
    public function dispose () : Void
    {
        __textInput = null;
    }


    /**
     * Setter `text`
     */
    private function set_text (value:String) : String
    {
        __text = value;
        if (__onTextChange != null) __onTextChange(value);

        return value;
    }


    /** Getters */
    private function get_text ()        return __text;

}//class TextInputRenderer