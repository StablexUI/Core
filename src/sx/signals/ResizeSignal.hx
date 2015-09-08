package sx.signals;

import sx.geom.Unit;
import sx.signals.Signal;
import sx.widgets.Widget;
import sx.properties.Size;


/**
 * Dispatched when widget width or height is changed.
 *
 * @param   Widget      Object which was resized.
 * @param   Size        Property which was changed.
 * @param   Unit        Units used before the change.
 * @param   Float       Value of changed property before the change.
 */
typedef ResizeSignal = Signal<Widget->Size->Unit->Float->Void>;