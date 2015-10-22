package sx.backend.dummy;

import sx.backend.BitmapData;
import sx.backend.interfaces.IBitmapRenderer;
import sx.widgets.Bmp;



/**
 * Dummy bitmap renderer
 *
 */
class BitmapRenderer implements IBitmapRenderer
{
    /** Renderer owner */
    private var __bmp : Bmp;
    /** Bitmap data to render */
    private var __bitmapData : BitmapData;
    /** callback to invoke when content resized */
    private var __onResize : Float->Float->Void;


    /**
     * Constructor
     */
    public function new (bmp:Bmp) : Void
    {
        __bmp = bmp;
    }


    /**
     * Set bitmap data to render
     */
    public function setBitmapData (bitmapData:BitmapData) : Void
    {
        __bitmapData = bitmapData;
    }


    /**
     * Returns original bitmap data width (pixels)
     */
    public inline function getBitmapDataWidth () : Float
    {
        if (__bitmapData == null || __bitmapData.width == null) {
            return 0;
        } else {
            return __bitmapData.width;
        }
    }


    /**
     * Returns original bitmap data height (pixels)
     */
    public inline function getBitmapDataHeight () : Float
    {
        if (__bitmapData == null || __bitmapData.height == null) {
            return 0;
        } else {
            return __bitmapData.height;
        }
    }


    /**
     * Change bitmap scaling
     */
    public function setBitmapScale (scaleX:Float, scaleY:Float) : Void
    {

    }


    /**
     * Change bitmap smoothing
     */
    public function setBitmapSmoothing (smooth:Bool) : Void
    {

    }


    /**
     * Returns content width in pixels.
     */
    public function getWidth () : Float
    {
        return getBitmapDataWidth();
    }


    /**
     * Returns content height in pixels.
     */
    public function getHeight () : Float
    {
        return getBitmapDataHeight();
    }


    /**
     * Set/remove callback to invoke when content resized.
     *
     * Callback should receive content width and height (pixels) as arguments.
     */
    public function onResize (callback:Null<Float->Float->Void>) : Void
    {
        __onResize = callback;
    }


    /**
     * Notify renderer about changing width area available for content (pixels).
     */
    public function setAvailableAreaWidth (width:Float) : Void
    {
        if (__bitmapData != null) {
            __bitmapData.width = width;
        }
    }


    /**
     * Notify renderer about changing height area available for content (pixels).
     */
    public function setAvailableAreaHeight (height:Float) : Void
    {
        if (__bitmapData != null) {
            __bitmapData.height = height;
        }
    }


    /**
     * Method to cleanup and release this object for garbage collector.
     */
    public function dispose () : Void
    {
        __bmp        = null;
        __onResize   = null;
        __bitmapData = null;
    }

}//class BitmapRenderer