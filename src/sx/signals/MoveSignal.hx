package sx.signals;

import sx.signals.Signal;
import sx.widgets.Widget;


/**
 * Dispatched when widget position is changed.
 *
 * @param   Widget      Object which was moved.
 */
typedef MoveSignal = Signal<Widget->Void>;