package sx.backend;

import sx.backend.INativeObject;
import sx.properties.Size;



/**
 * Native objects which can be used to attach displays of widget to.
 *
 */
interface IStage extends INativeObject
{

    /**
     * Get width of this stage
     */
    public function getWidth () : Size ;

    /**
     * Get height of this stage
     */
    public function getHeight () : Size ;

    /**
     * Indicates if stage size was changed since last rendering cycle.
     */
    public function wasResized () : Bool ;

    /**
     * Return display index at which first widget in stage's display list should be rendered.
     */
    public function getFirstDisplayIndex () : Int ;

    /**
     * Perform some actions after rendering cycle if required.
     *
     * @param freeDisplayIndex    Next display index after last widget rendered on this stage.
     */
    public function finalizeRender (freeDisplayIndex:Int) : Void ;

    /**
     * Method to remove all external references to this object and release it for garbage collector.
     */
    public function dispose () : Void ;

}//interface IStage