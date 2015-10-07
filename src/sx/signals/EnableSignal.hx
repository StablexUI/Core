package sx.signals;

import sx.signals.Signal;
import sx.widgets.Widget;


/**
 * Dispatched widget enabled or disabled.
 *
 * @param Widget    Affected widget.
 */
typedef EnableSignal = Signal<Widget->Void>;