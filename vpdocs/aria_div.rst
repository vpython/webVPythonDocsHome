
aria_div
========

``aria_div`` creates a container whose content is announced by screen readers when it changes. Widgets placed inside an ``aria_div`` (by setting their ``pos`` to the ``aria_div`` object) become part of a live region.

This is useful when multiple widgets together form a logical group that should be announced as a unit — for example, a slider and a ``wtext`` displaying its current value.

..  py:function:: myregion = aria_div( aria_live='polite' )

    :param aria_live: Controls when screen readers announce changes to the region's content. ``'polite'`` (the default) waits until the user is idle; ``'assertive'`` interrupts immediately. Modifiable.
    :type aria_live: string
    :param pos: Location of the container. Default is ``scene.caption_anchor``. Not modifiable after creation.
    :type pos: attribute of canvas

Example — a slider and its value readout grouped into one live region::

    region = aria_div(aria_live='polite')

    speed_text = wtext(text="Speed: 5", pos=region.pos)

    def setspeed(evt):
        speed_text.text = f"Speed: {evt.value:.1f}"

    myslider = slider(bind=setspeed, min=0, max=10, value=5,
                      aria_label="Speed", pos=region.pos)

When the slider is moved, the screen reader will announce the updated ``wtext`` content as part of the same live region.

.. note::
   ``aria_div`` is intended for accessibility. For simply placing widgets side by side, use the ``pos`` attribute of the canvas (``scene.caption_anchor`` or ``scene.title_anchor``) directly.
