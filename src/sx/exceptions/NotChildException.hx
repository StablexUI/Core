package sx.exceptions;

import haxe.PosInfos;



/**
 * Thrown if subject widget is not child of current widget.
 *
 */
class NotChildException extends SxException
{

    /**
     * Constructor
     *
     */
    public function new (msg:String = 'Provided widget is not a child of this one.', pos:PosInfos = null) : Void
    {
        super(msg, pos);
    }

}//class NotChildException