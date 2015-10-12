package sx.backend.interfaces;

import sx.backend.TextFormat;



/**
 * Native text renderer interface
 *
 */
interface ITextInputRenderer extends IRenderer
{

    /**
     * Set/remove callback which will be called when user changes content of text field
     */
    public function onTextChange (callback:String->Void) : Void ;

    /**
     * Returns current content
     */
    public function getText () : String ;

    /**
     * Set content.
     * Should not call `onTextChange` callback.
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

}//interface ITextInputRenderer