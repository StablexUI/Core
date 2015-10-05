package sx.widgets;

import sx.layout.LineLayout;
import sx.properties.Orientation;
import sx.widgets.Text;
import sx.widgets.Widget;



/**
 * Basic button
 *
 */
class Button extends Widget
{

    /**
     * Current icon used by htis button.
     * By default button does not have icon until you access `ico` property.
     */
    public var ico : Widget;
    /** Button text */
    public var text (get,set) : String;
    /**
     * Widget which renders text.
     * By default button does not have label until you access `text` or `label` property.
     */
    public var label (get,set) : Text;
    public var __label : Text;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        var layout = new LineLayout(Horizontal);
    }


    /**
     * Indicates if this button has label.
     *
     * Use this method instead of comparing `button.label` with `null`
     */
    public function hasLabel () : Bool
    {
        return __label != null;
    }


    /**
     * Remove current `label` from this button
     */
    private inline function __removeLabel () : Void
    {
        if (__label != null) {
            removeChild(__label);
            __label = null;
        }
    }


    /**
     * Use `textField` object for `label`
     */
    private inline function __setLabel (textField:Null<Text>) : Void
    {
        removeLabel();

        if (textField != null) {
            addChild(textField);
            __label = textField;
        }
    }


    /**
     * Getter `label`
     */
    private function get_label () : Text
    {
        if (__label == null) {
            __setLabel(new Text());
        }

        return __label;
    }


    /**
     * Setter `label`
     */
    private function set_label (value:Text) : Text
    {
        __setLabel(value);

        return value;
    }


    /** Setters */
    private function set_text (value)   return label.text = value;

    /** Getters */
    private function get_text () return label.text;

}//class Button