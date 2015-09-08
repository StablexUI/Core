package sx.backend;

import sx.backend.INativeObject;



/**
 * Native objects which can be used to attach displays of widget to.
 *
 */
interface IStage extends INativeObject
{

    /**
     * Method to remove all external references to this object and release it for garbage collector.
     */
    public function dispose () : Void ;

}//interface IStage