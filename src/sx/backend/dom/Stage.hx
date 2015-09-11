package sx.backend.dom;

import js.Browser;
import js.html.Element;
import sx.backend.IStage;



/**
 * Stage implementation
 *
 */
class Stage implements IStage
{
    /** DOM element for stage */
    public var node (default,null) : Element;


    /**
     * Constructor
     */
    public function new (node:Element = null) : Void
    {
        if (node == null) {
            node = Browser.document.createDivElement();
        }

        this.node = node;
    }


    /**
     * Method to remove all external references to this object and release it for garbage collector.
     */
    public function dispose () : Void
    {
        node.remove();
    }


}//class Stage