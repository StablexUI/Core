package sx.signals;

import hunit.TestCase;



/**
 * sx.signals.Signal
 *
 */
class SignalTest extends TestCase
{

    @test
    public function unique_listenerNotAttachedYet_attachesListener () : Void
    {
        var listener = function() {};
        var signal   = new Signal<Void->Void>();

        signal.unique(listener);

        assert.equal(1, signal.listenersCount);
    }


    @test
    public function unique_listenerAlreadyAttached_doesNotAttachListener () : Void
    {
        var listener = function() {};
        var signal   = new Signal<Void->Void>();
        signal.unique(listener);

        signal.unique(listener);

        assert.equal(1, signal.listenersCount);
    }


    @test
    public function on_listenerIsNotAttachedYet_attachesListener () : Void
    {
        var listener = function() {};
        var signal   = new Signal<Void->Void>();

        signal.on(listener);

        assert.equal(1, signal.listenersCount);
    }


    @test
    public function on_listenerIsAlreadyAttached_attachesAgain () : Void
    {
        var listener = function() {};
        var signal   = new Signal<Void->Void>();
        signal.on(listener);

        signal.on(listener);

        assert.equal(2, signal.listenersCount);
    }


    @test
    public function off_listenerIsNotAttached_doesNotRemoveAnything () : Void
    {
        var listener = function() {};
        var signal   = new Signal<Void->Void>();
        signal.on(function() {});

        signal.off(listener);

        assert.equal(1, signal.listenersCount);
    }


    @test
    public function off_listenerIsAttached_removesListener () : Void
    {
        var listener = function() {};
        var signal   = new Signal<Void->Void>();
        signal.on(listener);

        signal.off(listener);

        assert.equal(0, signal.listenersCount);
    }


    @test
    public function has_listenerIsAttached_returnsTrue () : Void
    {
        var listener = function() {};
        var signal   = new Signal<Void->Void>();
        signal.on(listener);

        var has = signal.has(listener);

        assert.isTrue(has);
    }


    @test
    public function has_listenerIsNotAttached_returnsFalse () : Void
    {
        var listener = function() {};
        var signal   = new Signal<Void->Void>();

        var has = signal.has(listener);

        assert.isFalse(has);
    }


    @test
    public function dispatch_noListenersRemovalDuringDispatch_allListenersCalled () : Void
    {
        var signal = new Signal<Void->Void>();
        var listenersCalled = 0;
        for (i in 0...10) {
            signal.on(function() listenersCalled++);
        }

        signal.dispatch();

        assert.equal(10, listenersCalled);
    }


    @test
    public function dispatch_someListenersRemovedDuringDispatch_allListenersCalled () : Void
    {
        var signal = new Signal<Void->Void>();
        var listenersCalled = 0;
        var listeners = [];

        for (i in 0...10) {
            listeners.push(
                function() {
                    listenersCalled++;
                    if (listenersCalled % 2 == 0) {
                        signal.off(listeners[listeners.length - listenersCalled]);
                    }
                }
            );
            signal.on(listeners[i]);
        }

        signal.dispatch();

        assert.equal(10, listenersCalled);
    }

}//class SignalTest