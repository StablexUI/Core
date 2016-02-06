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
    static public inline var DEFAULT_STYLE = '__DEFAULT__';

    /** Styles defined in this theme */
    private var __styles : Map<String, Map<String, Widget->Void>>;


    /**
     * Constructor
     */
    public function new () : Void
    {
        __styles  = new Map();

        initialize();
    }


    /**
     * Override this method to define styles.
     * You should not call this method manually
     */
    private function initialize () : Void
    {

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
     * By default theme looks for styles defined for class of a `widget`, but you can specify another class with `useClass`
     * This option become handy when you extend widgets, but want styles of parent class to be applied to widgets of descendant class.
     */
    public function apply (widget:Widget, useClass:Class<Widget> = null) : Void
    {
        if (widget.style == null) return;
        if (useClass == null) {
            useClass = widget.getClass();
        }

        var fn = styles(useClass).get(widget.style);
        if (fn == null) return;

        fn(widget);
    }


}//class Theme

