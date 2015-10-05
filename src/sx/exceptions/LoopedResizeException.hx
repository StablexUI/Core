package sx.exceptions;

import haxe.PosInfos;
import sx.exceptions.SxException;



/**
 * Thrown when endless resizing loop is detected
 *
 */
class LoopedResizeException extends SxException
{

    /**
     * Constructor
     */
    public function new (msg:String = 'Possible endless resizing loop detected.', ?pos:PosInfos) : Void
    {
        super(msg, pos);
    }

}//class LoopedResizeException