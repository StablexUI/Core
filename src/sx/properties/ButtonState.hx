package sx.properties;

import sx.signals.Signal;
import sx.widgets.Text;
import sx.widgets.Widget;



/**
 * Describes properties which will be applied to button when button state switched.
 *
 * By default all properties are `null`.
 * Once accessed property will be initialized with some default instance.
 */
class ButtonState
{
    /** Icon. If you want to remove existing icon, assign `null` */
    public var ico (get,set) : Widget;
    private var __ico : Widget;
    /** Text in button. If you want to remove existing text, assign `null`  */
    public var text (get,set) : String;
    private var __text : String = null;
    /** Label. If you want to remove existing label, assign `null` */
    public var label (get,set) : Text;
    private var __label : Text;

    /**
     * Dispatched when new label instance assigned to this state.
     *
     * @param   ButtonState     This instance.
     * @param   Null<Text>      New label instance.
     */
    public var onNewLabel (default,null) : Signal< ButtonState -> Null<Text> -> Void >;
    /**
     * Dispatched when new icon instance assigned to this state.
     *
     * @param   ButtonState     This instance.
     * @param   Null<Widget>    New icon instance.
     */
    public var onNewIco (default,null) : Signal< ButtonState -> Null<Widget> -> Void >;
    /**
     * Dispatched when text changed.
     *
     * @param   ButtonState     This instance.
     * @param   Null<String>    New text.
     */
    public var onNewText (default,null) : Signal< ButtonState -> Null<String> -> Void >;


    /**
     * Constructor
     */
    public function new () : Void
    {
        onNewLabel = new Signal();
        onNewIco   = new Signal();
        onNewText  = new Signal();
    }


    /**
     * Indicates if this state defines an icon
     */
    public function hasIco () : Bool
    {
        return __ico != null;
    }


    /**
     * Indicates if this state defines a label
     */
    public function hasLabel () : Bool
    {
        return __label != null;
    }


    /**
     * Indicates if this state defines a text
     */
    public function hasText () : Bool
    {
        return __text != null;
    }


    /**
     * Set new `ico`
     */
    private inline function __setIco (ico:Null<Widget>) : Void
    {
        __ico = ico;
        onNewIco.dispatch(this, ico);
    }


    /**
     * Set new `label`
     */
    private inline function __setLabel (label:Null<Text>) : Void
    {
        __label = label;
        onNewLabel.dispatch(this, label);
    }


    /**
     * Set new `text`
     */
    private inline function __setText (text:Null<String>) : Void
    {
        __text = text;
        onNewText.dispatch(this, text);
    }


    /**
     * Getter `ico`
     */
    private function get_ico () : Widget
    {
        if (__ico == null) __setIco(new Widget());

        return __ico;
    }


    /**
     * Getter `label`
     */
    private function get_label () : Text
    {
        if (__label == null) __setLabel(new Text());

        return __label;
    }


    /**
     * Getter `text`
     */
    private function get_text () : String
    {
        if (__text == null) __setText('');

        return __text;
    }


    /**
     * Setter `ico`
     */
    private function set_ico (value:Widget) : Widget
    {
        __setIco(value);

        return value;
    }


    /**
     * Setter `label`
     */
    private function set_label (value:Text) : Text
    {
        __setLabel(value);

        return value;
    }


    /**
     * Setter `text`
     */
    private function set_text (value:String) : String
    {
        __setText(value);

        return value;
    }


}//class ButtonState