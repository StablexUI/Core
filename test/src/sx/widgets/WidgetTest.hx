package sx.widgets;

import hunit.TestCase;
import sx.widgets.Widget;



/**
 * Tests for `sx.widgets.Widget`
 *
 */
class WidgetTest extends TestCase
{
    @test
    public function addChild_childHasNoParent_childAddedToNewParentsDisplayList () : Void
    {
        var parent = new Widget();
        var child  = new Widget();

        parent.addChild(child);

        assert.isTrue(parent.contains(child));
    }


    @test
    public function addChild_childHasNoParent_childsParentPropertyPointsToNewParent () : Void
    {
        var parent = new Widget();
        var child  = new Widget();

        parent.addChild(child);

        assert.equal(parent, child.parent);
    }


    @test
    public function addChild_childAnotherParent_parentChangedToCorrectWidget () : Void
    {
        var oldParent = new Widget();
        var child = oldParent.addChild(new Widget());
        var newParent = new Widget();

        newParent.addChild(child);

        assert.equal(newParent, child.parent);
    }


    @test
    public function addChild_childIsInAnotherDisplayList_childRemovedFromAnotherDisplayList () : Void
    {
        var oldParent = new Widget();
        var child = oldParent.addChild(new Widget());
        var newParent = new Widget();

        newParent.addChild(child);

        assert.isFalse(oldParent.contains(child));
    }


    @test
    public function addChild_childIsInAnotherDisplayList_childAddedToNewDisplayList () : Void
    {
        var oldParent = new Widget();
        var child = oldParent.addChild(new Widget());
        var newParent = new Widget();

        newParent.addChild(child);

        assert.isTrue(newParent.contains(child));
    }


    @test
    public function addChild_firstChild_numChildrenIsOne () : Void
    {
        var w = new Widget();

        w.addChild(new Widget());

        assert.equal(1, w.numChildren);
    }


    @test
    public function removeChild_widgetToRemoveIsNotAChild_returnsNull () : Void
    {
        var parent = new Widget();

        var removed = parent.removeChild(new Widget());

        assert.isNull(removed);
    }


    @test
    public function removeChild_removed_childIsNotInDisplayListAnymore () : Void
    {
        var parent = new Widget();
        var child = parent.addChild(new Widget());

        parent.removeChild(child);

        assert.isFalse(parent.contains(child));
    }


    @test
    public function removeChild_removed_ChildsParentPropertyIsNull () : Void
    {
        var parent = new Widget();
        var child = parent.addChild(new Widget());

        parent.removeChild(child);

        assert.isNull(child.parent);
    }


    @test
    public function removeChild_theOnlyChild_numChildrenIsZero () : Void
    {
        var w = new Widget();
        var child = w.addChild(new Widget());

        w.removeChild(child);

        assert.equal(0, w.numChildren);
    }


    @test
    public function contains_checkWidgetItself_returnsTrue () : Void
    {
        var w = new Widget();

        var contains = w.contains(w);

        assert.isTrue(contains);
    }


    @test
    public function contains_checkedWidgetIsFirstLevelChild_returnsTrue () : Void
    {
        var parent = new Widget();
        var child = parent.addChild(new Widget());

        var contains = parent.contains(child);

        assert.isTrue(contains);
    }


    @test
    public function contains_checkedWidgetIsSecondLevelChild_returnsTrue () : Void
    {
        var parent = new Widget();
        var child = parent.addChild(new Widget()).addChild(new Widget());

        var contains = parent.contains(child);

        assert.isTrue(contains);
    }


    @test
    public function contains_checkedWidgetIsNotContainedByChecker_returnsFalse () : Void
    {
        var parent = new Widget();
        var w = new Widget();

        var contains = parent.contains(w);

        assert.isFalse(contains);
    }

}//class WidgetTest