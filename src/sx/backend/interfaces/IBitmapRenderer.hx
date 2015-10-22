package sx.backend.interfaces;

import sx.backend.BitmapData;
import sx.backend.interfaces.IRenderer;




/**
 * Bitmap renderer interface
 *
 */
interface IBitmapRenderer extends IRenderer
{

    /**
     * Set bitmap data to render
     */
    public function setBitmapData (bitmapData:BitmapData) : Void ;

    /**
     * Returns original bitmap data width (pixels)
     */
    public function getBitmapDataWidth () : Float ;

    /**
     * Returns original bitmap data height (pixels)
     */
    public function getBitmapDataHeight () : Float ;

    /**
     * Change bitmap scaling
     */
    public function setBitmapScale (scaleX:Float, scaleY:Float) : Void ;

    /**
     * Change bitmap smoothing
     */
    public function setBitmapSmoothing (smoothing:Bool) : Void ;

}//interface IBitmapRenderer