package sx.signals;

import sx.signals.Signal;


/**
 * Dispatched when widget pressed and released.
 *
 * @param   Widget  Widget which is currently processing signal.
 * @param   widget  Widget which initiated this signal.
 */
typedef ClickSignal = Signal<Widget->Widget->Void>;