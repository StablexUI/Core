package sx.signals;

import sx.signals.Signal;
import sx.widgets.Widget;


/**
 * Dispatched on each scrolling iteration.
 *
 * @param   Widget      Scroll container.
 * @param   Float       Scroll distance alonge X axis (DIPs)
 * @param   Float       Scroll distance alonge Y axis (DIPs)
 */
typedef ScrollSignal = Signal<Widget->Float->Float->Void>;