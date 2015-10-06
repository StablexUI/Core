package sx.widgets;

import sx.properties.ButtonState;
import sx.layout.Layout;
import sx.layout.LineLayout;
import sx.properties.Align;
import sx.properties.Orientation;
import sx.widgets.Text;
import sx.widgets.Widget;



/**
 * Button widget
 *
 */
class SButton extends Widget
{
    /** Up state (not pressed, not hovered). This is also a default state. */
    public var up (get,never) : ButtonState;
    private var __up : ButtonState;
    /** Down state (button pressed) */
    public var down (get,never) : ButtonState;
    private var __down : ButtonState;
    /** Hover state (mouse pointer is above a button) */
    public var hover (get,never) : ButtonState;
    private var __hover : ButtonState;

    /** Alias for `up.ico` */
    public var ico (get,set) : Null<Widget>;
    /** Alias for `up.label` */
    public var label (get,set) : Text;
    /** Alias for `up.text` */
    public var text (get,set) : String;

    /** Current state */
    private var __state : ButtonState;
    /** Current icon */
    private var __ico : Widget;
    /** Current label */
    private var __label : Text
    /** Current text */
    private var __text : String;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        __up = new ButtonState();
        onParentChanged.add(__lazyLayoutInitialization);
    }


    /**
     * Set current button state
     */
    public function setState (state:ButtonState) : Void
    {
        if (state.hasIco()) {
            __setIco(state.ico);
        } else if (up.hasIco()) {
            __setIco(up.ico);
        } else {
            __setIco(null);
        }

        if (state.hasLabel()) {
            __setLabel(state.label);
        } else if (up.hasLabel()) {
            __setLabel(up.label);
        } else {
            __setLabel(null);
        }

        if (state.hasText()) {
            __setText(state.text);
        } else if (up.hasText()) {
            __setText(up.text);
        } else {
            __setText(null);
        }
    }


    /**
     * Use new icon for this button
     */
    private inline function __setIco (ico:Null<Widget>) : Void
    {
        if (__ico != ico) {
            if (__ico != null) {
                removeChild(__ico);
            }
            __ico = ico;
            if (ico != null) {
                addChild(ico);
            }
        }
    }


    /**
     * Use new label for this button
     */
    private inline function __setLabel (label:Null<Text>) : Void
    {
        if (__label != label) {
            if (__label != null) {
                removeChild(__label);
            }
            __label = label;
            if (label != null) {
                addChild(label);
            }
        }
    }


    /**
     * Use new text for this button
     */
    private inline function __setText (text:Null<Text>) : Void
    {
        if (__text != text) {
            __text = text;
            if (__label == null) {
                up.label.text = text;
            } else {
                __label.text = text;
            }
        }
    }


    /**
     * Create default layout if at the moment of adding to display list this button still has no layout
     */
    private function __lazyLayoutInitialization (newParent:Null<Widget>, me:Widget, index:Int) : Void
    {
        if (newParent != null && __layout == null) {
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
     * Getter for `layout`
     */
    override private function get_layout () : Layout
    {
        if (__layout == null) {
            __createDefaultLayout();
        }

        return super.get_layout();
    }


    /**
     * Getter for `down`
     */
    private function get_down () : ButtonState
    {
        if (__down == null) {
            __down = new ButtonState();
        }

        return __down;
    }


    /**
     * Getter for `hover`
     */
    private function get_hover () : ButtonState
    {
        if (__hover == null) {
            __hover = new ButtonState();
        }

        return __hover;
    }


    /** Getters */
    private function get_up ()      return __up;
    private function get_ico ()     return up.ico;
    private function get_label ()   return up.label;
    private function get_text ()    return up.text;

}//class SButton