package sx.backend.dom;

import js.Browser;
import js.html.Element;
import sx.backend.dom.Stage;
import sx.backend.IDisplay;
import sx.widgets.Widget;



/**
 * Display implementation
 *
 */
class Display implements IDisplay
{
    /** Widget which is represented by this display */
    private var widget : Widget;
    /** DOM element for display */
    private var node : Element;
    /** Current display index */
    private var displayIndex : Int = -1;
    /** Stage this display is attached to */
    private var stage : Stage;


    /**
     * Constructor
     */
    public function new (widget:Widget, node:Element = null) : Void
    {
        if (node == null) {
            node = Browser.document.createDivElement();
        }

        this.widget = widget;
        this.node   = node;
    }


    /**
     * Update visualization
     */
    public function update (displayIndex:Int) : Void
    {
        if (displayIndex != displayIndex) {

        }
    }


    /**
     * Method to remove all external references to this object and release it for garbage collector.
     */
    public function dispose () : Void
    {
        node.remove();
    }


}//class Display