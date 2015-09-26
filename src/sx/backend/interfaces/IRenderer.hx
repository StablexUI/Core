package sx.backend.interfaces;




/**
 * Renders some native content
 *
 */
interface IRenderer
{
    /**
     * Change top-left corner position (pixels) of rendered content inside an owner widget.
     */
    public function setPosition (x:Float, y:Float) : Void ;

    /**
     * Returns content width in pixels.
     */
    public function getWidth () : Float ;

    /**
     * Returns content height in pixels.
     */
    public function getHeight () : Float ;

    /**
     * Set/remove callback to invoke when content resized.
     *
     * Callback should receive content width and height (pixels) as arguments.
     */
    public function onResize (callback:Null<Float->Float->Void>) : Void ;

    /**
     * Notify renderer about changing width area available for content (pixels).
     */
    public function setAvailableAreaWidth (width:Float) : Void ;

    /**
     * Notify renderer about changing height area available for content (pixels).
     */
    public function setAvailableAreaHeight (height:Float) : Void ;

    /**
     * Method to cleanup and release this object for garbage collector.
     */
    public function dispose () : Void ;

}//interface IRenderer