package sx.widgets;

import sx.backend.TextFormat;
import sx.backend.TextInputRenderer;
import sx.signals.Signal;
import sx.widgets.base.RendererHolder;



/**
 * Text input field.
 *
 * Text input ignores `autoSize` property inherited from `sx.widgets.base.RendererHolder`
 */
class TextInput extends RendererHolder
{

    /** Text field content */
    public var text (get,set) : String;
    private var __text : String = '';
    // /** Text displayed when no characters inserted by user */
    // public var invitation (get,set) : String;
    // private var __invitation : String = '';
    /** Native text renderer */
    public var renderer (default,null) : TextInputRenderer;

    /** Dispatched when content of input field changed */
    public var onChange (get,never) : Signal<TextInput->Void>;
    private var __onChange : Signal<TextInput->Void>;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();
        width.dip = 100;
        __disableRendererResizeListener();
        renderer.onTextChange(__rendererTextChanged);
    }


    /**
     * Get text formatting settings.
     */
    public function getTextFormat () : TextFormat
    {
        return renderer.getFormat();
    }


    /**
     * Set text formatting settings.
     */
    public function setTextFormat (format:TextFormat) : Void
    {
        return renderer.setFormat(format);
    }


    /**
     * Creates native text renderer
     */
    override private function __createRenderer () : Void
    {
        renderer = Sx.backendManager.textInputRenderer(this);
    }


    /**
     * Setter `text`
     */
    private function set_text (value:String) : String
    {
        __text = value;
        // if (__text.length > 0) {
            renderer.setText(__text);
        // } else {
        //     __updateInvitationDisplay();
        // }
        __onChange.dispatch(this);

        return value;
    }


    /**
     * Called when user changes content of input field
     */
    private function __rendererTextChanged (newText:String) : Void
    {
        __text = newText;
        __onChange.dispatch(this);
    }


    // /**
    //  * Show invitation if no text inserted
    //  */
    // private inline function __updateInvitationDisplay () : Void
    // {

    // }


    // *
    //  * Setter `invitation`

    // private function set_invitation (value:String) : String
    // {
    //     __invitation = value;
    //     __updateInvitationDisplay();

    //     return value;
    // }


    /** Getters */
    // private function get_invitation ()              return __invitation;
    private function get_text ()                    return __text;
    override private function get___renderer ()     return renderer;
    private function get_onChange ()                return (__onChange == null ? __onChange = new Signal() : __onChange);

}//class Text