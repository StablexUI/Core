package sx.backend.interfaces;




/**
 * Renders some native content
 *
 */
interface IRenderer
{

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
     * Method to cleanup and release this object for garbage collector.
     */
    public function dispose () : Void ;

}//interface IRenderer