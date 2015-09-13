package sx.exceptions;

import haxe.PosInfos;



/**
 * Provided argument does not fit required bounds.
 *
 */
class OutOfBoundsException extends SxException
{

    /**
     * Constructor
     *
     */
    public function new (msg:String = 'Provided argument does not fit required bounds.', pos:PosInfos = null) : Void
    {
        super(msg, pos);
    }

}//class OutOfBoundsException