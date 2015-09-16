package sx.signals;

import sx.signals.Signal;
import sx.widgets.Widget;


/**
 * Dispatched when widget width or height is changed.
 *
 * @param   Widget      Object which was resized.
 */
typedef ResizeSignal = Signal<Widget->Void>;