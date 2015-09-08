package sx.properties;

import hunit.TestCase;
import sx.geom.Unit;
import sx.properties.Size;



/**
 * sx.properties.Size
 *
 */
class SizeTest extends TestCase
{

    @test
    public function onChange_anySetter_alwaysInvokesOnChange () : Void
    {
        var size = new Size();
        var callCounter = 0;
        size.onChange = function(s) callCounter++;

        size.px  = 1;
        size.dip = 1;
        size.pct = 1;

        assert.equal(3, callCounter);
    }


    @test
    public function px_unitsArePixels_returnsStoredValue () : Void
    {
        var size = new Size();
        size.px  = 10;

        assert.equal(10., size.px);
    }


    @test
    public function px_unitsAreDips_convertsCorrectly () : Void
    {
        Sx.dipFactor = 2;

        var size = new Size();
        size.dip = 10;

        assert.equal(20., size.px);
    }


    @test
    public function px_unitsArePercents_convertsCorrectly () : Void
    {
        var pctSource = new Size();
        pctSource.px  = 10;

        var size = new Size();
        size.pctSource = function() return pctSource;
        size.pct = 30;

        assert.equal(3., size.px);
    }


    @test
    public function dip_unitsArePixels_convertsCorrectly () : Void
    {
        Sx.dipFactor = 2;

        var size = new Size();
        size.px  = 10;

        assert.equal(5., size.dip);
    }


    @test
    public function dip_unitsAreDips_returnsStoredValue () : Void
    {
        var size = new Size();
        size.dip = 10;

        assert.equal(10., size.dip);
    }


    @test
    public function dip_unitsArePercents_convertsCorrectly () : Void
    {
        var pctSource = new Size();
        pctSource.dip  = 10;

        var size = new Size();
        size.pctSource = function() return pctSource;
        size.pct = 30;

        assert.equal(3., size.dip);
    }


    @test
    public function pct_unitsArePixels_convertsCorrectly () : Void
    {
        var pctSource = new Size();
        pctSource.px  = 10;

        var size = new Size();
        size.pctSource = function() return pctSource;
        size.px = 3;

        assert.equal(30., size.pct);
    }


    @test
    public function pct_unitsAreDips_convertsCorrectly () : Void
    {
        var pctSource = new Size();
        pctSource.dip  = 10;

        var size = new Size();
        size.pctSource = function() return pctSource;
        size.dip = 3;

        assert.equal(30., size.pct);
    }


    @test
    public function pct_unitsArePercents_returnsStoredValue () : Void
    {
        var size = new Size();
        size.pct = 30;

        assert.equal(30., size.pct);
    }

}//class SizeTest