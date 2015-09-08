package sx.signals;

import sx.signals.Signal;
import sx.widgets.Widget;
import sx.properties.Size;
import sx.geom.Unit;


/**
 * Dispatched when widget position is changed.
 *
 * @param   Widget      Object which was resized.
 * @param   Size        Property which was changed.
 * @param   Unit        Units used before the change.
 * @param   Float       Value of changed property before the change.
 */
typedef MoveSignal = Signal<Widget->Size->Unit->Float->Void>;