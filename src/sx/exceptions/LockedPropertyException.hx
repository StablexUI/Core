package sx.exceptions;

import haxe.PosInfos;



/**
 * Thrown when user tries to change property which is locked and cannot be changed.
 *
 */
class LockedPropertyException extends Exception
{

    /**
     * Constructor
     */
    public function new (msg:String = 'Unable to change disposable property.', pos:PosInfos = null) : Void
    {
        super(msg, pos);
    }

}//class LockedPropertyException