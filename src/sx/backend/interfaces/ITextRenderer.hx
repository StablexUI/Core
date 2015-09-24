package sx.backend.interfaces;

import sx.backend.TextFormat;



/**
 * Native text renderer interface
 *
 */
interface ITextRenderer extends IRenderer
{

    /**
     * Set content
     */
    public function setText (text:String) : Void ;

    /**
     * Get text formatting settings.
     */
    public function getFormat () : TextFormat ;

    /**
     * Set text formatting settings.
     */
    public function setFormat (format:TextFormat) : Void ;


}//interface ITextRenderer extends IRenderer