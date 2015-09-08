package sx.backend;

import sx.backend.INativeObject;



/**
 * Native objects used to visually represent widgets.
 *
 */
interface IDisplay extends INativeObject
{
    /**
     * Update visualization
     */
    public function update (displayIndex:Int) : Void ;

    /**
     * Method to remove all external references to this object and release it for garbage collector.
     */
    public function dispose () : Void ;

}//interface IDisplay