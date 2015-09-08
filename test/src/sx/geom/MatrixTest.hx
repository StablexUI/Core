package sx.geom;

import hunit.TestCase;
import sx.geom.Matrix;


/**
 * sx.geom.Matrix
 *
 */
class MatrixTest extends TestCase
{

    @test
    public function translate_noOtherTransformations_calculatedCorrectly () : Void
    {
        var mx = new Matrix();

        assert.equal(0.0, mx.tx);
        assert.equal(0.0, mx.ty);

        mx.translate(10, -2);
        assert.equal(10.0, mx.tx);
        assert.equal(-2.0, mx.ty);

        mx.translate(-5, 8);
        assert.equal(5.0, mx.tx);
        assert.equal(6.0, mx.ty);
    }


    @test
    public function scale_withTranslate_calculatedCorrectly () : Void
    {
        var mx1 = new Matrix();

        mx1.scale(0.5, 1.5);
        assert.equal(0.5, mx1.a);
        assert.equal(1.5, mx1.d);
        assert.equal(0.0, mx1.tx);
        assert.equal(0.0, mx1.ty);

        mx1.translate(10, 100);
        mx1.scale(4, 2);
        assert.equal(2.0, mx1.a);
        assert.equal(3.0, mx1.d);
        assert.equal(40.0, mx1.tx);
        assert.equal(200.0, mx1.ty);
    }


    @test
    public function concat_calculatedCorrectly () : Void
    {
        var mx1 = new Matrix();
        mx1.a  = 32;
        mx1.b  = 44;
        mx1.c  = 6;
        mx1.d  = 8;
        mx1.tx = 10;
        mx1.ty = 12;

        var mx2 = new Matrix();
        mx2.a  = 9;
        mx2.b  = 8;
        mx2.c  = 6;
        mx2.d  = 1;
        mx2.tx = 93;
        mx2.ty = 51;

        mx1.concat(mx2);

        assert.equal(552.0, mx1.a);
        assert.equal(300.0, mx1.b);
        assert.equal(102.0, mx1.c);
        assert.equal(56.0, mx1.d);
        assert.equal(255.0, mx1.tx);
        assert.equal(143.0, mx1.ty);
    }


    @test
    public function invert_calculatedCorrectly () : Void
    {
        var mx = new Matrix();
        mx.a  = 32;
        mx.b  = 44;
        mx.c  = 6;
        mx.d  = 8;
        mx.tx = 10;
        mx.ty = 12;

        mx.invert();

        assert.equal(-1.0, mx.a);
        assert.equal(5.5, mx.b);
        assert.equal(0.75, mx.c);
        assert.equal(-4.0, mx.d);
        assert.equal(1.0, mx.tx);
        assert.equal(-7.0, mx.ty);
    }


    @test
    public function clone_copiedCorrectly () : Void
    {
        var src = new Matrix();
        src.a = 1;
        src.b = 2;
        src.c = 3;
        src.d = 4;
        src.tx = 5;
        src.ty = 6;

        var copy = src.clone();

        assert.equal(src.a, copy.a);
        assert.equal(src.b, copy.b);
        assert.equal(src.c, copy.c);
        assert.equal(src.d, copy.d);
        assert.equal(src.tx, copy.tx);
        assert.equal(src.ty, copy.ty);
    }

}//class MatrixTest