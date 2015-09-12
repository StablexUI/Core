package sx.properties;

import hunit.TestCase;
import sx.properties.Size;
import sx.Sx;



/**
 * sx.properties.Origin
 *
 */
class OriginTest extends TestCase
{
    /**
     * Provides `Size` instances for tests
     */
    static private function dummySize (px:Float) : Size
    {
        var dummy = new Size() ;
        dummy.px = px;

        return dummy;
    }


    @test
    public function set_valuesBetween0And1_treatedAsPercent () : Void
    {
        var origin = new Origin(
            function() return dummySize(100),
            function() return dummySize(30)
        );

        origin.set(0.5, 0.5);

        assert.equal(50., origin.left.px);
        assert.equal(15., origin.top.px);
    }


    @test
    public function set_valuesLessThan0OrGreaterThan1_treatedAsDips () : Void
    {
        Sx.dipFactor = 2;
        var origin = new Origin(
            function() return dummySize(0),
            function() return dummySize(0)
        );

        origin.set(-20, 10);

        assert.equal(-40., origin.left.px);
        assert.equal(20., origin.top.px);
    }

}//class OriginTest