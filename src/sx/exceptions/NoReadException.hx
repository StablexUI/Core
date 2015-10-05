package sx.exceptions;

import haxe.PosInfos;
import sx.exceptions.SxException;



/**
 * If some user is trying to read something which is not allowed
 *
 */
class NoReadException extends SxException
{

    /**
     * Constructor
     */
    public function new (msg:String = 'Accessing this property for reading is not allowed.', ?pos:PosInfos) : Void
    {
        super(msg, pos);
    }

}//class NoReadException