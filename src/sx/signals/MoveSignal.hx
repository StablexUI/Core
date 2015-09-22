package sx.signals;

import sx.signals.Signal;
import sx.widgets.Widget;
import sx.properties.metric.Size;
import sx.properties.metric.Units;


/**
 * Dispatched when widget position is changed.
 *
 * @param   Widget      Object which was moved.
 * @param   Size        Changed instance.
 * @param   Unit        Units used before this change.
 * @param   Float       Value before this change.
 */
typedef MoveSignal = Signal<Widget->Size->Units->Float->Void>;