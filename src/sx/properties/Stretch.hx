package sx.properties;

import sx.signals.Signal;


/**
 * Stretching settings (for Bmp widget)
 *
 */
class Stretch
{

    /** Enable/disable stretching */
    public var scale (default,set) : Bool = false;
    /** Keep aspect ratio when scaled */
    public var keepAspect (default,set) : Bool = false;

    /** Signal to dispatch when stretching settings changed */
    public var onChange (default,null) : Signal<Void->Void>;


    /**
     * Constructor
     */
    public function new () : Void
    {
        onChange = new Signal();
    }


    /**
     * Dispatch `onChange` signal
     */
    private inline function __invokeOnChange () : Void
    {
        onChange.dispatch();
    }


    /**
     * Setter `scale`
     */
    private function set_scale (value:Bool) : Bool
    {
        scale = value;
        __invokeOnChange();

        return value;
    }


    /**
     * Setter `keepAspect`
     */
    private function set_keepAspect (value:Bool) : Bool
    {
        keepAspect = value;
        //should not care about aspect ratio if scaling disabled
        if (scale) __invokeOnChange();

        return value;
    }

}//class Stretch