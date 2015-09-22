package sx.widgets;

import sx.backend.TextRenderer;
import sx.properties.TextFormat;
import sx.widgets.RendererHolder;



/**
 * Text field
 *
 */
class Text extends RendererHolder
{

    /** Text field content */
    public var text (get,set) : String;
    private var __text : String = '';
    /** Formatting settings */
    public var format (default,null) : TextFormat;
    /** Native text renderer */
    public var renderer (default,null) : TextRenderer;


    /**
     * Creates native text renderer
     */
    override private function __createRenderer () : Void
    {
        renderer = Sx.backendFactory.textRenderer(this);
    }


    /**
     * Setter `text`
     */
    private function set_text (value:String) : String
    {
        __text = value;
        renderer.setText(__text);

        return value;
    }


    /** Getters */
    private function get_text () return __text;
    override private function get___renderer () return renderer;

}//class Text