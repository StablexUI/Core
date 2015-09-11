package sx.backend.dom;

import js.Browser;
import js.html.Element;
import sx.backend.dom.Stage;
import sx.backend.IDisplay;
import sx.widgets.Widget;

using sx.backend.dom.tools.ElementTools;


/**
 * Display implementation
 *
 */
@:access(sx.widgets.Widget)
class Display implements IDisplay
{
    /** DOM element for display */
    public var node (default,null) : Element;
    /** Widget which is represented by this display */
    private var widget : Widget;
    /** Current display index */
    private var displayIndex : Int = -1;
    /** Stage which this display is currently rendered on */
    private var stage : Stage;


    /**
     * Constructor
     */
    public function new (widget:Widget, node:Element = null) : Void
    {
        if (node == null) {
            node = Browser.document.createDivElement();
            node.initialize();

            var colors = ['red', 'green', 'blue', 'black'];
            node.style.background = colors[Std.random(colors.length)];
        }

        this.widget = widget;
        this.node   = node;
    }


    /**
     * Update visualization
     */
    public function update (currentStage:IStage, displayIndex:Int) : Void
    {
        if (stage != currentStage) {
            stage = cast currentStage;
            this.displayIndex = -1;
        }

        node.setSize(widget.width.px, widget.height.px);
        node.transform(widget.__matrix);

        if (this.displayIndex != displayIndex) {
            this.displayIndex = displayIndex;
            stage.node.insertBefore(node, stage.node.children.item(displayIndex));
        }
    }


    /**
     * Method to remove all external references to this object and release it for garbage collector.
     */
    public function dispose () : Void
    {
        stage = null;
        node.remove();
    }



}//class Display