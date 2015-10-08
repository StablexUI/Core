package sx.themes;

import sx.signals.Signal;
import sx.widgets.Widget;

using Type;


/**
 * Base class for themes
 *
 */
class Theme
{
    /** Name for default style */
    static public inline var DEFAULT_STYLE = 'DEFAULT';

    /** Indicates if theme is ready for usage. */
    public var ready (default,null) : Bool = false;
    /** Signal dispatched when theme is ready (e.g. assets loaded and styles defined). */
    public var onReady (default,null) : Signal<Void->Void>;


    /** Description */
    private var __styles : Map<String, Map<String, Widget->Void>>;


    /**
     * Constructor
     */
    public function new () : Void
    {
        __styles  = new Map();
        onReady = new ThemeReadySignal(this);

        initialize();
    }


    /**
     * Override this method and invoke `finalize()` after theme is ready for usage.
     */
    private function initialize () : Void
    {

    }


    /**
     * This method should be invoked after theme becomes ready for usage.
     */
    @:final
    private function finalize () : Void
    {
        ready = true;
        onReady.dispatch();
    }


    /**
     * Get styles for specified widget class.
     *
     * You can modify returned map to change this theme.
     * However it's better to extend theme for that purpose.
     */
    public function styles (cls:Class<Widget>) : Map<String,Widget->Void>
    {
        var className = cls.getClassName();
        var styles    = __styles.get(className);

        if (styles == null) {
            styles = new Map();
            __styles.set(className, styles);
        }

        return styles;
    }


    /**
     * Applies style from `widget.style` to `widget`.
     *
     * Does nothing if `widget.style` is `null` or does not exist.
     */
    public function apply (widget:Widget) : Void
    {
        if (widget.style == null) return;

        var fn = styles(widget.getClass()).get(widget.style);
        if (fn == null) return;

        fn(widget);
    }


}//class Theme



/**
 * Signal to dispatch when theme becomes ready for usage.
 *
 */
private class ThemeReadySignal extends Signal<Void->Void>
{
    /** Owner of this signal */
    private var __theme : Theme;


    /**
     * Constructor
     */
    public function new (theme:Theme) : Void
    {
        super();
        __theme = theme;
    }


    /**
     * Attach signal listener
     */
    override public function add (listener:Void->Void) : Void
    {
        super.add(listener);
        //in case this theme became ready immediately after creation.
        if (__theme.ready) listener();
    }

}//class ThemeReadySignal