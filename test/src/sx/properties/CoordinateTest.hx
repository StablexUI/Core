package sx.properties;

import hunit.TestCase;



/**
 * sx.properties.Coordinate
 *
 */
class CoordinateTest extends TestCase
{
    /** Objects under test */
    private var left      : Coordinate;
    private var right     : Coordinate;
    private var width     : Size;
    private var pctSource : Size;


    /**
     * Setup test
     */
    override public function setup () : Void
    {
        left      = new Coordinate();
        right     = new Coordinate();
        width     = new Size();
        pctSource = new Size();

        left.pair      = function() return right;
        right.pair     = function() return left;
        left.pctSource = right.pctSource = function(i) return pctSource;
        left.ownerSize = right.ownerSize = function () return width;

        left.select();

        if (!left.selected || right.selected) throw new Exception('Failed to setup test.');
    }


    /**
     * Clear environment after test
     */
    override public function tearDown () : Void
    {
        left      = null;
        right     = null;
        width     = null;
        pctSource = null;
    }


    @test
    public function px_set_deselectsPairedProperty () : Void
    {
        right.px = 10;

        assert.isFalse(left.selected);
    }


    @test
    public function px_set_selectsSelf () : Void
    {
        right.px = 10;

        assert.isTrue(right.selected);
    }


    @test
    public function px_getSelected_returnsOwnValue () : Void
    {
        left.px = 20;

        assert.equal(20., left.px);
    }


    @test
    public function px_getNotSelected_calculatesCorrectValue () : Void
    {
        right.px     = 20;
        width.px     = 30;
        pctSource.px = 100;

        left.px = 10;

        assert.equal(60., right.px);
    }


    @test
    public function dip_set_deselectsPairedProperty () : Void
    {
        right.dip = 10;

        assert.isFalse(left.selected);
    }


    @test
    public function dip_set_selectsSelf () : Void
    {
        right.dip = 10;

        assert.isTrue(right.selected);
    }


    @test
    public function dip_getSelected_returnsOwnValue () : Void
    {
        left.dip = 20;

        assert.equal(20., left.dip);
    }


    @test
    public function dip_getNotSelected_calculatesCorrectValue () : Void
    {
        right.dip     = 20;
        width.dip     = 30;
        pctSource.dip = 100;

        left.dip = 10;

        assert.equal(60., right.dip);
    }


    @test
    public function pct_set_deselectsPairedProperty () : Void
    {
        right.pct = 10;

        assert.isFalse(left.selected);
    }


    @test
    public function pct_set_selectsSelf () : Void
    {
        right.pct = 10;

        assert.isTrue(right.selected);
    }


    @test
    public function pct_getSelected_returnsOwnValue () : Void
    {
        left.pct = 20;

        assert.equal(20., left.pct);
    }


    @test
    public function pct_getNotSelected_calculatesCorrectValue () : Void
    {
        right.pct     = 20;
        width.pct     = 30;
        pctSource.dip = 50;

        left.pct = 10;

        assert.equal(60., right.pct);
    }


}//class CoordinateTest