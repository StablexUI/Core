package sx.signals;

import sx.signals.Signal;
import sx.widgets.Widget;


/**
 * Dispatched when widget is going to be disposed.
 *
 * @param   Widget      Object which will be disposed.
 */
typedef DisposeSignal = Signal<Widget->Void>;