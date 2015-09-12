package sx.backend.flash;

import flash.display.DisplayObjectContainer;
import sx.backend.IStage;
import sx.geom.Unit;
import sx.properties.Size;



/**
 * Stage implementation
 *
 */
class Stage implements IStage
{
    /** Display object for stage */
    public var container (default,null) : DisplayObjectContainer;
    /** Width of this stage */
    public var width (default,null) : Size;
    /** Height of this stage */
    public var height (default,null) : Size;

    /** Indicates if size was changed */
    private var invalidSize : Bool = false;


    /**
     * Constructor
     */
    public function new (container:DisplayObjectContainer = null) : Void
    {
        if (container == null) {
            container = new DisplayObjectContainer();
        }

        this.container = container;

        width  = new Size();
        height = new Size();
        width.onChange = height.onChange = resized;
    }


    /**
     * Get width of this stage
     */
    public function getWidth () : Size
    {
        return width;
    }


    /**
     * Get height of this stage
     */
    public function getHeight () : Size
    {
        return height;
    }


    /**
     * Indicates if stage size was changed since last rendering cycle.
     */
    public function wasResized () : Bool
    {
        return invalidSize;
    }


    /**
     * Return display index at which first widget in stage's display list should be rendered.
     */
    public function getFirstDisplayIndex () : Int
    {
        return 0;
    }


    /**
     * Remove all excess children after last rendered widget.
     *
     * @param freeDisplayIndex    Next display index after last widget rendered on this stage.
     */
    public function finalizeRender (freeDisplayIndex:Int) : Void
    {
        for (i in freeDisplayIndex...container.numChildren) {
            container.removeChildAt(freeDisplayIndex);
        }

        invalidSize = false;
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


    /**
     * Called when `width` or `height` is changed.
     */
    private function resized (changed:Size, previousUnits:Unit, previousValue:Float) : Void
    {
        invalidSize = true;
    }

}//class Stage