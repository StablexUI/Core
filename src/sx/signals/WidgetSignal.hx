package sx.signals;

import sx.signals.Signal;
import sx.widgets.Widget;


/**
 * Used for signals which has the only argument - dispatcher widget.
 *
 * @param   Widget      Object which dispatched signal.
 */
typedef WidgetSignal = Signal<Widget->Void>;