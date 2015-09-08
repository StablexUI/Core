package sx.geom;

import hunit.TestCase;
import sx.geom.Point;



/**
 * sx.geom.Point
 *
 */
class PointTest extends TestCase
{

    @test
    public function clone_copiedCorrectly () : Void
    {
        var src = new Point();
        src.x = 1;
        src.y = 2;

        var copy = src.clone();

        assert.equal(src.x, copy.x);
        assert.equal(src.y, copy.y);
    }

}//class PointTest