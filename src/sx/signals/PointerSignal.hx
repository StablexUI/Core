package sx.signals;

import sx.signals.Signal;
import sx.widgets.Widget;


/**
 * Dispatched on pointer interactions with widget.
 *
 * @param   Widget  Widget which is currently processing signal.
 * @param   widget  Widget which initiated this signal.
 */
typedef PointerSignal = Signal<Widget->Widget->Void>;