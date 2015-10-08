package sx.signals;

import sx.signals.Signal;
import sx.widgets.Widget;


/**
 * Dispatched on pointer interactions with widget.
 *
 * @param   Widget  Widget which is currently processing signal.
 * @param   Widget  Widget which initiated this signal.
 * @param   Int     A unique identifier assigned to the touch point (for touch events).
 *                  For mouse events these identifiers are negative if not provided by current backend.
 */
typedef PointerSignal = Signal<Widget->Widget->Int->Void>;