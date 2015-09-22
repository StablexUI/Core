package sx.signals;

import sx.properties.metric.Units;
import sx.properties.metric.Size;
import sx.signals.Signal;
import sx.widgets.Widget;


/**
 * Dispatched when widget width or height is changed.
 *
 * @param   Widget      Object which was resized.
 * @param   Size        Changed instance.
 * @param   Unit        Units used before this change.
 * @param   Float       Value before this change.
 */
typedef ResizeSignal = Signal<Widget->Size->Units->Float->Void>;