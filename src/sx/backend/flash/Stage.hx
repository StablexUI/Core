package sx.backend.flash;

import flash.display.DisplayObjectContainer;
import sx.backend.IStage;



/**
 * Stage implementation
 *
 */
class Stage implements IStage
{
    /** Display object for stage */
    public var container (default,null) : DisplayObjectContainer;


    /**
     * Constructor
     */
    public function new (container:DisplayObjectContainer = null) : Void
    {
        if (container == null) {
            container = new DisplayObjectContainer();
        }

        this.container = container;
    }


    /**
     * Method to remove all external references to this object and release it for garbage collector.
     */
    public function dispose () : Void
    {
        if (container.parent != null) {
            container.parent.removeChild(container);
        }

        container = null;
    }


}//class Stage