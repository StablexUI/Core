package sx.signals;

import sx.signals.Signal;
import sx.widgets.Widget;


/**
 * Signals dispatched for each pointer interaction with global stage.
 *
 * @param   Null<Widget>    Widget current pointer event happend above (if any).
 * @param   Int             touchId of current event
 */
typedef GlobalPointerSignal = Signal< Null<Widget>->Int->Void >;