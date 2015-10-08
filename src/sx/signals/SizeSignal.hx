package sx.signals;

import sx.properties.metric.Units;
import sx.properties.metric.Size;
import sx.signals.Signal;
import sx.widgets.Widget;


/**
 * Dispatched when some `Size` owned by a widget is changed.
 *
 * @param   Widget      Widget which owns changed instance.
 * @param   Size        Changed instance.
 * @param   Unit        Units used before this change.
 * @param   Float       Value before this change.
 */
typedef SizeSignal = Signal<Widget->Size->Units->Float->Void>;