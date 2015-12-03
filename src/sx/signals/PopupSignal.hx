package sx.signals;

import sx.widgets.Popup;


/**
 * Dispatched when popup is shown or closed.
 *
 * @param   Popup
 */
typedef PopupSignal = Signal<Popup->Void>;