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
class Button extends Widget
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
    public var text (get,set) : Null<String>;

    /** Current state */
    private var __state : ButtonState;
    /** Current icon */
    private var __ico : Widget;
    /** Current label */
    private var __label : Text;
    /** Current text */
    private var __text : String;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        __up = __createState();
        __state = __up;

        onParentChanged.add(__lazyLayoutInitialization);
    }


    /**
     * Set current button state
     */
    public function setState (state:ButtonState) : Void
    {
        if (__state == state) return;

        __releaseState(__state);
        __state = state;
        __hookState(__state);

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
     * Get currently active state.
     */
    public function getState () : ButtonState
    {
        return __state;
    }


    /**
     * Method to cleanup and release this object for garbage collector.
     */
    override public function dispose (disposeChildren:Bool = true) : Void
    {
        super.dispose();

        __releaseState(__state);
    }


    /**
     * Create new ButtonState instance
     */
    private inline function __createState () : ButtonState
    {
        var state = new ButtonState();
        __hookState(state);

        return state;
    }


    /**
     * Attach signal listeners to `state`.
     * Listeners won't be added if `state` belongs to this button.
     */
    private inline function __hookState (state:ButtonState) : Void
    {
        var own = __isOwnState(state);
        if (!own) {
            state.onNewIco.add(__stateNewIco);
            state.onNewLabel.add(__stateNewLabel);
            state.onNewText.add(__stateNewText);
        }
    }


    /**
     * Remove signal listeners from `state`.
     * Listeners won't be removed if `state` belongs to this button.
     */
    private inline function __releaseState (state:ButtonState) : Void
    {
        var own = __isOwnState(state);
        if (!own) {
            state.onNewIco.remove(__stateNewIco);
            state.onNewLabel.remove(__stateNewLabel);
            state.onNewText.remove(__stateNewText);
        }
    }


    /**
     * Check if `state` belongs to this button
     */
    private inline function __isOwnState (state:ButtonState) : Bool
    {
        return (state == __up || state == __down || __state == __hover);
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
    private inline function __setText (text:Null<String>) : Void
    {
        if (__text != text) {
            __text = text;
            if (__text != null) {
                if (__label == null) {
                    up.label.text = text;
                } else {
                    __label.text = text;
                }
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
     * New icon assigned to `state`
     */
    private function __stateNewIco (state:ButtonState, ico:Null<Widget>) : Void
    {
        if (state != __state) {
            //setting default icon while current state already has icon
            if (state == __up && __state.hasIco()) return;
        }

        __setIco(ico);
    }


    /**
     * New label assigned to `state`
     */
    private function __stateNewLabel (state:ButtonState, label:Null<Text>) : Void
    {
        if (state != __state) {
            //setting default label while current state already has label
            if (state == __up && __state.hasLabel()) return;
        }
        __setLabel(label);
    }


    /**
     * New text assigned to `state`
     */
    private function __stateNewText (state:ButtonState, text:Null<String>) : Void
    {
        if (state != __state) {
            //setting default text while current state already has text
            if (state == __up && __state.hasText()) return;
        }
        __setText(text);
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
            __down = __createState();
        }

        return __down;
    }


    /**
     * Getter for `hover`
     */
    private function get_hover () : ButtonState
    {
        if (__hover == null) {
            __hover = __createState();
        }

        return __hover;
    }


    /** Getters */
    private function get_up ()      return __up;
    private function get_ico ()     return up.ico;
    private function get_label ()   return up.label;
    private function get_text ()    return up.text;

    /** Setters */
    private function set_text (v)   return up.text = text;
    private function set_label (v)  return up.label = label;
    private function set_ico (v)    return up.ico = ico;

}//class Button