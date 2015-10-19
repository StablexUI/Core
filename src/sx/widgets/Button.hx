package sx.widgets;

import sx.input.Pointer;
import sx.properties.ButtonState;
import sx.layout.Layout;
import sx.layout.LineLayout;
import sx.properties.Align;
import sx.properties.metric.Size;
import sx.properties.metric.Units;
import sx.properties.Orientation;
import sx.signals.ButtonSignal;
import sx.signals.Signal;
import sx.skins.Skin;
import sx.themes.Theme;
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

    /** Indicates if button is currently pressed. */
    public var pressed (get,set) : Bool;
    private var __pressed : Bool = false;

    /** Indicates if pointer currently is over this button. */
    public var hovered (get,set) : Bool;
    private var __hovered : Bool = false;

    /** Alias for `up.ico` */
    public var ico (get,set) : Null<Widget>;
    /** Alias for `up.label` */
    public var label (get,set) : Text;
    /** Alias for `up.text` */
    public var text (get,set) : Null<String>;

    /**
     * Dispatched when user clicks or taps this button (button pressed and released)
     *
     * @see sx.signals.ButtonSignal   For understanding the difference between trigger and click signals.
     */
    public var onTrigger (get,never) : ButtonSignal;
    private var __onTrigger : ButtonSignal;
    /** Dispatched when button is pressed. */
    public var onPress (get,never) : ButtonSignal;
    private var __onPress : ButtonSignal;
    /** Dispatched when button is released. */
    public var onRelease (get,never) : ButtonSignal;
    private var __onRelease : ButtonSignal;

    /** Indicates if pressed button should be released if pointer rolls out of a button */
    public var releaseOnPointerOut : Bool = true;

    /** Current state */
    private var __state : ButtonState;
    /** Current icon */
    private var __ico : Widget;
    /** Current label */
    private var __label : Text;
    /** Current text */
    private var __text : String;

    /** Helper flag for `set_skin()` */
    private var __applyingStateSkin : Bool = false;

    /** If default layout will be created, this value will be used for `autoSize.width` */
    private var __initialAutoSizeWidth : Bool = true;
    /** If default layout will be created, this value will be used for `autoSize.height` */
    private var __initialAutoSizeHeight : Bool = true;


    /**
     * Constructor
     */
    public function new () : Void
    {
        super();

        __up = __createState();
        __state = __up;

        onInitialize.add(__initialized);

        onPointerPress.add(__pointerPressed);
        onPointerOver.add(__pointerOver);
        onPointerOut.add(__pointerOut);
        onPointerRelease.add(__pointerReleased);
    }


    /**
     * Set current button state
     */
    public function setState (state:ButtonState) : Void
    {
        if (__state == null) state = __up;
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

        if (state.hasSkin()) {
            __setSkin(state.skin);
        } else if (up.hasSkin()) {
            __setSkin(up.skin);
        } else {
            __setSkin(null);
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
     * Dispatch `onTrigger` signal
     */
    public function trigger () : Void
    {
        if (!enabled) return;

        __onTrigger.dispatch(this);
    }


    /**
     * Set `down` state and dispatch `onPress` signal
     */
    private function __setPressed () : Void
    {
        if (!enabled) return;

        if (__down != null) {
            setState(__down);
        }
        if (!__pressed) {
            __pressed = true;
            __onPress.dispatch(this);
        }
        if (!releaseOnPointerOut) {
            Pointer.onNextRelease.add(__pointerReleasedOutside);
        }
    }


    /**
     * Set hovered state
     */
    private function __setHovered () : Void
    {
        __hovered = true;
        if (!__pressed && __hover != null) {
            setState(__hover);
        }
    }


    /**
     * Drop hovered state
     */
    private function __setHouted () : Void
    {
        setState(__up);
        __hovered = false;
        if (__pressed && releaseOnPointerOut) {
            __pressed = false;
            __setReleased();
        }
    }


    /**
     * Drop pressed state and dispatch `onRelease` signal
     */
    private function __setReleased () : Void
    {
        if (!enabled) return;

        if (__hovered && __hover != null) {
            setState(__hover);
        } else {
            setState(__up);
        }

        if (__pressed){
            __pressed = false;
            __onRelease.dispatch(this);
            trigger();
        }
    }


    /**
     * Handle pressing this button
     */
    private function __pointerPressed (processor:Widget, dispatcher:Widget, touchId:Int) : Void
    {
        __setPressed();
    }


    /**
     * Handle rolling pointer over this button
     */
    private function __pointerOver (processor:Widget, dispatcher:Widget, touchId:Int) : Void
    {
        __setHovered();
    }


    /**
     * Handle rolling pointer out of this button
     */
    private function __pointerOut (processor:Widget, dispatcher:Widget, touchId:Int) : Void
    {
        __setHouted();
    }


    /**
     * Handle releasing pointer over this button
     */
    private function __pointerReleased (processor:Widget, dispatcher:Widget, touchId:Int) : Void
    {
        __setReleased();
    }


    /**
     * Handle releasing pointer outside of this button
     */
    private function __pointerReleasedOutside (dispatcher:Widget, touchId:Int) : Void
    {
        if (__pressed){
            setState(__up);
            __setReleased();
        }
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
            state.onNewSkin.add(__stateNewSkin);
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
            state.onNewSkin.remove(__stateNewSkin);
        }
    }


    /**
     * Check if `state` belongs to this button
     */
    private inline function __isOwnState (state:ButtonState) : Bool
    {
        return (state == __up || state == __down || state == __hover);
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
     * Use new skin for this button
     */
    private inline function __setSkin (skin:Null<Skin>) : Void
    {
        if (this.skin != skin) {
            __applyingStateSkin = true;
            if (skin == null && up.hasSkin()) {
                skin = up.skin;
            }
            this.skin = skin;
            __applyingStateSkin = false;
        }
    }


    /**
     * Create default layout if at the moment of initialization this button still has no layout
     */
    private function __initialized (widget:Widget) : Void
    {
        if (__layout == null) {
            __createDefaultLayout();
        } else {
            onInitialize.remove(__initialized);
        }
    }


    /**
     * Creates default layout
     */
    private inline function __createDefaultLayout () : Void
    {
        onInitialize.remove(__initialized);

        var layout = new LineLayout();
        layout.orientation = Horizontal;
        layout.autoSize.set(__initialAutoSizeWidth, __initialAutoSizeHeight);
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
        __adjustStyle(ico);

        if (state != __state) {
            //setting default icon while current state already has icon
            if (state != __up ||  __state.hasIco()) {
                return;
            }
        }

        __setIco(ico);
    }


    /**
     * New label assigned to `state`
     */
    private function __stateNewLabel (state:ButtonState, label:Null<Text>) : Void
    {
        __adjustStyle(label);

        if (state != __state) {
            //setting default label while current state already has label
            if (state != __up || __state.hasLabel()) {
                return;
            }
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
            if (state != __up || __state.hasText()) {
                return;
            }
        }
        __setText(text);
    }


    /**
     * New skin assigned to `state`
     */
    private function __stateNewSkin (state:ButtonState, skin:Null<Skin>) : Void
    {
        if (state != __state) {
            //setting default skin while current state already has skin
            if (state != __up || __state.hasSkin()) {
                return;
            }
        }
        __setSkin(skin);
    }


    /**
     * Use button styling for new icon/label instead of default style.
     */
    private inline function __adjustStyle (child:Null<Widget>) : Void
    {
        if (!initialized && style != null) {
            if (child != null && child.style == Theme.DEFAULT_STYLE) {
                child.style = null;
            }
        }
    }


    /**
     * Called when `width` or `height` is changed.
     */
    override private function __propertyResized (changed:Size, previousUnits:Units, previousValue:Float) : Void
    {
        //if no layout created yet, set values for initial autoSize values of future default layout
        if (__layout == null) {
            if (changed.isHorizontal()) {
                __initialAutoSizeWidth = false;
            } else {
                __initialAutoSizeHeight = false;
            }
        }

        super.__propertyResized(changed, previousUnits, previousValue);
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


    /**
     * Setter for `skin`
     */
    override private function set_skin (value:Skin) : Skin
    {
        if (!__applyingStateSkin && !__up.hasSkin()) {
            __up.skin = value;
        }

        return super.set_skin(value);
    }


    /**
     * Setter `hovered`
     */
    private function set_hovered (value:Bool) : Bool
    {
        if (__hovered != value) {
            if (value) {
                __setHovered();
            } else {
                __setHouted();
            }
        }

        return value;
    }


    /**
     * Setter `pressed`
     */
    private function set_pressed (value:Bool) : Bool
    {
        if (__pressed != value) {
            if (value) {
                __setPressed();
            } else {
                __setReleased();
            }
        }

        return value;
    }


    /** Getters */
    private function get_up ()      return __up;
    private function get_ico ()     return up.ico;
    private function get_label ()   return up.label;
    private function get_text ()    return up.text;
    private function get_pressed () return __pressed;
    private function get_hovered () return __hovered;


    /** Signal getters */
    private function get_onTrigger ()      return (__onTrigger == null ? __onTrigger = new Signal() : __onTrigger);
    private function get_onPress ()        return (__onPress == null ? __onPress = new Signal() : __onPress);
    private function get_onRelease ()      return (__onRelease == null ? __onRelease = new Signal() : __onRelease);

    /** Setters */
    private function set_text (v)   return up.text = v;
    private function set_label (v)  return up.label = v;
    private function set_ico (v)    return up.ico = v;

}//class Button