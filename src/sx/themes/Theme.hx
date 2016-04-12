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
     * Applies `styleName` to `widget`.
     *
     * If `styleClass` is provided required style will be looked among styles declared for `styleClass`.
     * Otherwise `widget.getStyleClass()` will be used.
     * If `styleName` is provided, specified style will be applied despite the value of `widget.style` property (`widget.style` will remain unaffected).
     * Otherwise `widget.style` will be used.
     */
    public function apply (widget:Widget, styleClass:Class<Widget> = null, styleName:String = null) : Void
    {
        if (styleName == null) {
            styleName = widget.style;
            if (widget.style == null) {
                return;
            }
        }
        if (styleClass == null) {
            styleClass = widget.getStyleClass();
            if (styleClass == null) {
                return;
            }
        }

        var fn = styles(styleClass).get(styleName);
        if (fn == null) {
            return;
        }

        fn(widget);
    }


}//class Theme

