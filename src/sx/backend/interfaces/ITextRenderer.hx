package sx.backend.interfaces;



/**
 * Native text renderer interface
 *
 */
interface ITextRenderer extends IRenderer
{

    /**
     * Set content
     */
    public inline function setText (text:String) : Void ;

}//interface ITextRenderer extends IRenderer