package sx.widgets;

import sx.layout.Layout;
import sx.layout.LineLayout;
import sx.properties.Align;
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
    public var ico (get,set) : Null<Widget>;
    private var __ico : Widget;

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

        onParentChanged.add(__lazyLayoutInitialization);
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
        __removeLabel();

        if (textField != null) {
            addChild(textField);
            __label = textField;
        }
    }


    /**
     * Remove current `ico` from this button
     */
    private inline function __removeIco () : Void
    {
        if (__ico != null) {
            removeChild(__ico);
            __ico = null;
        }
    }


    /**
     * Use `textField` object for `ico`
     */
    private inline function __setIco (ico:Null<Widget>) : Void
    {
        __removeIco();

        if (ico != null) {
            addChild(ico);
            __ico = ico;
        }
    }


    /**
     * Create default layout if at the moment of adding to display list this button still has no layout
     */
    private function __lazyLayoutInitialization (newParent:Null<Widget>, me:Widget, index:Int) : Void
    {
        if (newParent != null) {
            __createDefaultLayout();
        }
    }


    /**
     * Creates default layout
     */
    private inline function __createDefaultLayout () : Void
    {
        onParentChanged.remove(__lazyLayoutInitialization);

        var layout = new LineLayout();
        layout.orientation = Horizontal;
        layout.autoSize.set(true, true);
        layout.align.set(Center, Middle);
        layout.padding.dip = 2;
        layout.gap.dip     = 5;

        this.layout = layout;
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


    /**
     * Setter for `ico`
     */
    private function set_ico (ico:Widget) : Widget
    {
        __setIco(ico);

        return ico;
    }


    /**
     * Getter for `layout`
     */
    override private function get_layout () : Layout
    {
        if (__layout == null) {
            __createDefaultLayout();
        }

        return super.get_layout();
    }


    /** Setters */
    private function set_text (value)   return label.text = value;

    /** Getters */
    private function get_text ()    return label.text;
    private function get_ico ()     return __ico;

}//class Button