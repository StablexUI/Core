package sx.properties;

import sx.properties.abstracts.ASize;
import sx.properties.metric.Size;


/**
 * Border description (mainly for skins)
 *
 */
class Border
{
    /** Border width. By default: 0dip (no border) */
    public var width (get,set) : ASize;
    private var __width : Size;
    /** Border color */
    public var color : Int = 0;
    /** Border opacity */
    public var alpha : Float = 1;

    /** Callback which provides `Size` instance for percentage calculations of border width */
    public var pctSource (get,set) : Null<Void->Size>;


    /**
     * Constructor
     */
    public function new () : Void
    {
        __width = new Size();
    }


    /** Getters */
    private function get_width ()       return __width;
    private function get_pctSource ()   return __width.pctSource;

    /** Setters */
    private function set_width (v)      return __width.copyValueFrom(v);
    private function set_pctSource (v)  return __width.pctSource = v;

}//class Border