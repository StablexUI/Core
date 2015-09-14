package sx.widgets;

import hunit.TestCase;
import sx.exceptions.NotChildException;
import sx.exceptions.OutOfBoundsException;
import sx.widgets.Widget;



/**
 * Tests for `sx.widgets.Widget`
 *
 */
class WidgetTest extends DummyBackendCase
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
    public function addChild_childHasAnotherParent_parentChangedToCorrectWidget () : Void
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
    public function addChild_always_addsToTheEndOfChildrenList () : Void
    {
        var parent = new Widget();
        parent.addChild(new Widget());

        var lastChild = parent.addChild(new Widget());

        var expected = parent.numChildren - 1;
        var actual   = parent.getChildIndex(lastChild);
        assert.equal(expected, actual);
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


    @test
    public function getChildIndex_widgetIsNotAChild_throwsNotChildException () : Void
    {
        var parent = new Widget();
        var w = new Widget();

        expectException(match.type(NotChildException));

        parent.getChildIndex(w);
    }


    @test
    public function getChildIndex_widgetIsChild_returnsCorrectIndex () : Void
    {
        var parent = new Widget();
        parent.addChild(new Widget());
        var secondChild = parent.addChild(new Widget());
        parent.addChild(new Widget());

        var index = parent.getChildIndex(secondChild);

        assert.equal(1, index);
    }


    @test
    public function addChildAt_indexIsInBounds_addsAtCorrectIndex () : Void
    {
        var parent = new Widget();
        parent.addChild(new Widget());
        parent.addChild(new Widget());
        parent.addChild(new Widget());
        var child = new Widget();

        parent.addChildAt(child, 2);

        var actual = parent.getChildIndex(child);
        assert.equal(2, actual);
    }


    @test
    public function addChildAt_indexExceedsNumChildren_addsToTheEndOfChildrenList () : Void
    {
        var parent = new Widget();
        parent.addChild(new Widget());
        parent.addChild(new Widget());
        parent.addChild(new Widget());
        var child = new Widget();

        parent.addChildAt(child, parent.numChildren + 1);

        var expected = parent.numChildren - 1;
        var actual   = parent.getChildIndex(child);
        assert.equal(expected, actual);
    }


    @test
    public function addChildAt_indexIsNegative_addsAtCorrectPosition () : Void
    {
        var parent = new Widget();
        parent.addChild(new Widget());
        parent.addChild(new Widget());
        parent.addChild(new Widget());
        var child = new Widget();

        parent.addChildAt(child, -2);

        var actual = parent.getChildIndex(child);
        assert.equal(1, actual);
    }


    @test
    public function addChildAt_childHasAnotherParent_parentChangedToCorrectWidget () : Void
    {
        var oldParent = new Widget();
        var child = oldParent.addChild(new Widget());
        var newParent = new Widget();

        newParent.addChildAt(child, 0);

        assert.equal(newParent, child.parent);
    }


    @test
    public function addChildAt_childIsInAnotherDisplayList_childRemovedFromAnotherDisplayList () : Void
    {
        var oldParent = new Widget();
        var child = oldParent.addChild(new Widget());
        var newParent = new Widget();

        newParent.addChildAt(child, 0);

        assert.isFalse(oldParent.contains(child));
    }


    @test
    public function addChildAt_childIsInAnotherDisplayList_childAddedToNewDisplayList () : Void
    {
        var oldParent = new Widget();
        var child = oldParent.addChild(new Widget());
        var newParent = new Widget();

        newParent.addChildAt(child, 0);

        assert.isTrue(newParent.contains(child));
    }


    @test
    public function removeChildAt_indexOutOfBounds_returnsNull () : Void
    {
        var parent = new Widget();

        var removed = parent.removeChildAt(1);

        assert.isNull(removed);
    }


    @test
    public function removeChildAt_removed_childIsNotInDisplayListAnymore () : Void
    {
        var parent = new Widget();
        var child = parent.addChild(new Widget());

        parent.removeChildAt(0);

        assert.isFalse(parent.contains(child));
    }


    @test
    public function removeChildAt_removed_childsParentPropertyIsNull () : Void
    {
        var parent = new Widget();
        var child = parent.addChild(new Widget());

        parent.removeChildAt(0);

        assert.isNull(child.parent);
    }


    @test
    public function removeChildAt_theOnlyChild_numChildrenIsZero () : Void
    {
        var parent = new Widget();
        var child = parent.addChild(new Widget());

        parent.removeChildAt(0);

        assert.equal(0, parent.numChildren);
    }


    @test
    public function removeChildAt_hasMultipleChildren_removesCorrectChild () : Void
    {
        var parent = new Widget();
        parent.addChild(new Widget());
        var child = parent.addChild(new Widget());
        parent.addChild(new Widget());

        var removed = parent.removeChildAt(1);

        assert.equal(child, removed);
    }


    @test
    public function removeChildAt_negativeIndex_removesCorrectChild () : Void
    {
        var parent = new Widget();
        parent.addChild(new Widget());
        var child = parent.addChild(new Widget());
        parent.addChild(new Widget());

        var removed = parent.removeChildAt(-2);

        assert.equal(child, removed);
    }


    @test
    public function removeChildren_indexesInBounds_removesExactAmountOfChildren () : Void
    {
        var parent = new Widget();
        for (i in 0...4) parent.addChild(new Widget());

        var amount = parent.removeChildren(1, 2);

        assert.equal(2, amount);
    }


    @test
    public function removeChildren_endIndexOutOfBounds_removesFromBeginIndexToTheEndOfDisplayList () : Void
    {
        var parent = new Widget();
        for (i in 0...4) parent.addChild(new Widget());

        var amount = parent.removeChildren(1, 10);

        assert.equal(3, amount);
    }


    @test
    public function removeChildren_beginIndexOutOfBounds_removesFromTheFirstChildUptoEndIndex () : Void
    {
        var parent = new Widget();
        for (i in 0...4) parent.addChild(new Widget());

        var amount = parent.removeChildren(-100, 2);

        assert.equal(3, amount);
    }


    @test
    public function removeChildren_negativeIndexes_removesCorrectAmountOfChildren () : Void
    {
        var parent = new Widget();
        for (i in 0...4) parent.addChild(new Widget());

        var amount = parent.removeChildren(-3, -2);

        assert.equal(2, amount);
    }


    @test
    public function removeChildren_removed_removedCorrectChildren () : Void
    {
        var parent = new Widget();
        var child0 = parent.addChild(new Widget());
        var child1 = parent.addChild(new Widget());
        var child2 = parent.addChild(new Widget());
        var child3 = parent.addChild(new Widget());

        parent.removeChildren(1, 2);

        var correct = (parent.contains(child0) && !parent.contains(child1) && !parent.contains(child2) && parent.contains(child3));
        assert.isTrue(correct);
    }


    @test
    public function removeChildren_removed_removedChildrenAreNotInDisplayListAnymore () : Void
    {
        var parent = new Widget();
        var child0 = parent.addChild(new Widget());
        var child1 = parent.addChild(new Widget());

        parent.removeChildren(0, 1);

        var notInDisplayList = (!parent.contains(child0) && !parent.contains(child1));
        assert.isTrue(notInDisplayList);
    }


    @test
    public function removeChildren_removed_removedChildrenHaveNullParent () : Void
    {
        var parent = new Widget();
        var child0 = parent.addChild(new Widget());
        var child1 = parent.addChild(new Widget());

        parent.removeChildren(0, 1);

        var nullParent = (child0.parent == null && child1.parent == null);
        assert.isTrue(nullParent);
    }


    @test
    public function removeChildren_defaultIndexes_removesAllChildren () : Void
    {
        var parent = new Widget();
        for (i in 0...4) parent.addChild(new Widget());

        parent.removeChildren();

        assert.equal(0, parent.numChildren);
    }


    @test
    public function setChildIndex_positiveIndexInBounds_childMovedToCorrectIndex () : Void
    {
        var parent = new Widget();
        var child  = parent.addChild(new Widget());
        parent.addChild(new Widget());
        parent.addChild(new Widget());

        var index = parent.setChildIndex(child, 2);

        var actual = parent.getChildIndex(child);
        assert.equal(2, actual);
        assert.equal(2, index);
    }


    @test
    public function setChildIndex_positiveOutOfBounds_childMovedToTheEndOfDisplayList () : Void
    {
        var parent = new Widget();
        var child = parent.addChild(new Widget());
        parent.addChild(new Widget());

        var index = parent.setChildIndex(child, 100);

        var actual = parent.getChildIndex(child);
        assert.equal(1, actual);
        assert.equal(1, index);
    }


    @test
    public function setChildIndex_negativeIndexInBounds_childMovedToCorrectIndex () : Void
    {
        var parent = new Widget();
        var child  = parent.addChild(new Widget());
        parent.addChild(new Widget());
        parent.addChild(new Widget());

        var index = parent.setChildIndex(child, -2);

        var actual = parent.getChildIndex(child);
        assert.equal(1, actual);
        assert.equal(1, index);
    }


    @test
    public function setChildIndex_negativeIndexOutOfBounds_childMovedToBeginningOfDisplayList () : Void
    {
        var parent = new Widget();
        parent.addChild(new Widget());
        parent.addChild(new Widget());
        var child = parent.addChild(new Widget());

        var index = parent.setChildIndex(child, -100);

        var actual = parent.getChildIndex(child);
        assert.equal(0, actual);
        assert.equal(0, index);
    }


    @test
    public function setChildIndex_widgetIsNotChild_throwsNotChildException () : Void
    {
        var parent = new Widget();
        var w = new Widget();

        expectException(match.type(NotChildException));

        parent.setChildIndex(w, 0);
    }


    @test
    public function getChildAt_positiveIndexInBounds_returnsCorrectChild () : Void
    {
        var parent = new Widget();
        parent.addChild(new Widget());
        var expected = parent.addChild(new Widget());
        parent.addChild(new Widget());

        var actual = parent.getChildAt(1);

        assert.equal(expected, actual);
    }


    @test
    public function getChildAt_negativeIndexInBounds_returnsCorrectChild () : Void
    {
        var parent = new Widget();
        parent.addChild(new Widget());
        var expected = parent.addChild(new Widget());
        parent.addChild(new Widget());

        var actual = parent.getChildAt(-2);

        assert.equal(expected, actual);
    }


    @test
    public function getChildAt_indexOutOfBounds_returnsNull () : Void
    {
        var parent = new Widget();
        for (i in 0...4) parent.addChild(new Widget());

        var child = parent.getChildAt(100);

        assert.isNull(child);
    }


    @test
    public function swapChildren_atLeastOneWidgetIsNotChild_throwsNotChildException () : Void
    {
        var parent = new Widget();
        var child  = parent.addChild(new Widget());
        var w      = new Widget();

        expectException(match.type(NotChildException));

        parent.swapChildren(w, child);
    }


    @test
    public function swapChildren_bothWidgetsAreChildren_swapsCorrectly () : Void
    {
        var parent = new Widget();
        var child0 = parent.addChild(new Widget());
        var child1 = parent.addChild(new Widget());

        parent.swapChildren(child0, child1);

        assert.equal(0, parent.getChildIndex(child1));
        assert.equal(1, parent.getChildIndex(child0));
    }


    @test
    public function swapChildrenAt_indexOutOfBounds_throwsOutOfBoundsException () : Void
    {
        var parent = new Widget();

        expectException(match.type(OutOfBoundsException));

        parent.swapChildrenAt(0, 1);
    }


    @test
    public function swapChildrenAt_positiveIndicesInBounds_swapsCorrectly () : Void
    {
        var parent = new Widget();
        var child0 = parent.addChild(new Widget());
        var child1 = parent.addChild(new Widget());

        parent.swapChildrenAt(0, 1);

        assert.equal(0, parent.getChildIndex(child1));
        assert.equal(1, parent.getChildIndex(child0));
    }


    @test
    public function swapChildrenAt_negativeIndicesInBounds_swapsCorrectly () : Void
    {
        var parent = new Widget();
        var child0 = parent.addChild(new Widget());
        var child1 = parent.addChild(new Widget());

        parent.swapChildrenAt(-2, -1);

        assert.equal(0, parent.getChildIndex(child1));
        assert.equal(1, parent.getChildIndex(child0));
    }


    @test
    public function width_percentageUnits_calculatedCorrectly () : Void
    {
        var parent = new Widget();
        var child = parent.addChild(new Widget());
        parent.width.dip = 50;

        child.width.pct = 20;

        assert.equal(10., child.width.dip);
    }


    @test
    public function height_percentageUnits_calculatedCorrectly () : Void
    {
        var parent = new Widget();
        var child = parent.addChild(new Widget());
        parent.height.dip = 50;

        child.height.pct = 20;

        assert.equal(10., child.height.dip);
    }


    @test
    public function width_widthChanged_onResizeInvoked () : Void
    {
        var w = mock(Widget).create();

        expect(w).__resized(w.width).once();

        w.width.dip = 100;
    }


    @test
    public function height_heightChanged_onResizeInvoked () : Void
    {
        var w = mock(Widget).create();

        expect(w).__resized(w.height).once();

        w.height.dip = 100;
    }


    @test
    public function coordinates_widgetCreation_coordinatesInitializedCorrectly () : Void
    {
        var parent = new Widget();
        var w = mock(Widget).create();
        parent.addChild(w);

        assert.equal(w.right, w.left.pair());
        assert.equal(w.width, w.left.ownerSize());
        assert.equal(parent.width, w.left.pctSource());
        assert.isTrue(w.left.selected);

        assert.equal(w.left, w.right.pair());
        assert.equal(w.width, w.right.ownerSize());
        assert.equal(parent.width, w.right.pctSource());
        assert.isFalse(w.right.selected);

        assert.equal(w.bottom, w.top.pair());
        assert.equal(w.height, w.top.ownerSize());
        assert.equal(parent.height, w.top.pctSource());
        assert.isTrue(w.top.selected);

        assert.equal(w.top, w.bottom.pair());
        assert.equal(w.height, w.bottom.ownerSize());
        assert.equal(parent.height, w.bottom.pctSource());
        assert.isFalse(w.bottom.selected);

        expect(w).__moved().exactly(4);

        w.left.dip   = 1;
        w.right.dip  = 1;
        w.top.dip    = 1;
        w.bottom.dip = 1;
    }


    @test
    public function size_widgetCreation_sizeInitializedCorrectly () : Void
    {
        var parent = new Widget();
        var w = mock(Widget).create();
        parent.addChild(w);

        assert.equal(parent.width, w.left.pctSource());
        assert.equal(parent.height, w.height.pctSource());

        expect(w).__resized().exactly(2);

        w.width.dip  = 1;
        w.height.dip = 1;
    }


    @test
    public function width_changed_invokesOnResize () : Void
    {
        var w = mock(Widget).create();

        expect(w).__resized().once();

        w.width.dip = 10;
    }


    @test
    public function height_changed_invokesOnResize () : Void
    {
        var w = mock(Widget).create();

        expect(w).__resized().once();

        w.height.dip = 10;
    }


    @test
    public function left_changed_invokesOnMove () : Void
    {
        var w = mock(Widget).create();

        expect(w).__moved().once();

        w.left.dip = 10;
    }


    @test
    public function right_changed_invokesOnMove () : Void
    {
        var w = mock(Widget).create();

        expect(w).__moved().once();

        w.right.dip = 10;
    }


    @test
    public function top_changed_invokesOnMove () : Void
    {
        var w = mock(Widget).create();

        expect(w).__moved().once();

        w.top.dip = 10;
    }


    @test
    public function bottom_changed_invokesOnMove () : Void
    {
        var w = mock(Widget).create();

        expect(w).__moved().once();

        w.bottom.dip = 10;
    }


    @test
    public function dispose_dontDisposeChildren_childrenRemovedButNotDisposed () : Void
    {
        var parent = new Widget();
        var child = mock(Widget).create();
        parent.addChild(child);

        expect(child).dispose().never();

        parent.dispose(false);
    }


    @test
    public function dispose_disposeChildrenAsWell_childrenDisposed () : Void
    {
        var parent = new Widget();
        var child = mock(Widget).create();
        parent.addChild(child);

        expect(child).dispose().once();

        parent.dispose();
    }


}//class WidgetTest