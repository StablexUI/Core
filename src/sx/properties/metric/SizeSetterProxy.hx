package sx.properties.metric;

import sx.exceptions.NoReadException;
import sx.properties.metric.Size;
import sx.properties.Orientation;
import sx.properties.metric.Units;
import sx.signals.Signal;


/**
 * Mimics `Size` interface but only allows to write values.
 *
 * Reading is prohibited.
 * Also `onChange` provides current values instead of previous ones
 */
class SizeSetterProxy extends Size
{

    /**
     * Invokes `onChange()` if `onChange` is not null
     */
    override private function __invokeOnChange (previousUnits:Units, previousValue:Float) : Void
    {
        onChange.dispatch(this, units, __value);
    }


    /** Getters */
    override private function get_dip () : Float    throw new NoReadException();
    override private function get_px () : Float     throw new NoReadException();
    override private function get_pct () : Float    throw new NoReadException();


}//class SizeSetterProxy