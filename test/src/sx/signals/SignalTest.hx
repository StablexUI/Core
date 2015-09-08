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
    public function invoke_listenerIsNotAttachedYet_attachesListener () : Void
    {
        var listener = function() {};
        var signal   = new Signal<Void->Void>();

        signal.invoke(listener);

        assert.equal(1, signal.listenersCount);
    }


    @test
    public function invoke_listenerIsAlreadyAttached_attachesAgain () : Void
    {
        var listener = function() {};
        var signal   = new Signal<Void->Void>();
        signal.invoke(listener);

        signal.invoke(listener);

        assert.equal(2, signal.listenersCount);
    }


    @test
    public function dontinvoke_listenerIsNotAttached_doesNotRemoveAnything () : Void
    {
        var listener = function() {};
        var signal   = new Signal<Void->Void>();
        signal.invoke(function() {});

        signal.dontInvoke(listener);

        assert.equal(1, signal.listenersCount);
    }


    @test
    public function dontinvoke_listenerIsAttached_removesListener () : Void
    {
        var listener = function() {};
        var signal   = new Signal<Void->Void>();
        signal.invoke(listener);

        signal.dontInvoke(listener);

        assert.equal(0, signal.listenersCount);
    }


    @test
    public function willInvoke_listenerIsAttached_returnsTrue () : Void
    {
        var listener = function() {};
        var signal   = new Signal<Void->Void>();
        signal.invoke(listener);

        var willInvoke = signal.willInvoke(listener);

        assert.isTrue(willInvoke);
    }


    @test
    public function willInvoke_listenerIsNotAttached_returnsFalse () : Void
    {
        var listener = function() {};
        var signal   = new Signal<Void->Void>();

        var willInvoke = signal.willInvoke(listener);

        assert.isFalse(willInvoke);
    }


    @test
    public function dispatch_noListenersRemovalDuringDispatch_allListenersCalled () : Void
    {
        var signal = new Signal<Void->Void>();
        var listenersCalled = 0;
        for (i in 0...10) {
            signal.invoke(function() listenersCalled++);
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
                        signal.dontInvoke(listeners[listeners.length - listenersCalled]);
                    }
                }
            );
            signal.invoke(listeners[i]);
        }

        signal.dispatch();

        assert.equal(10, listenersCalled);
    }

}//class SignalTest