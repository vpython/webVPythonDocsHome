
wtext
=====

The wtext object (widget text) is often used together with widgets such as sliders. It provides a way to modify dynamically a portion of the title or caption of a canvas, perhaps in response to user interactions or computed changes.

The example program `ButtonsMenusSliders <https://www.glowscript.org/#/user/GlowScriptDemos/folder/Examples/program/ButtonsSlidersMenus-VPython>`_ uses **wtext** to display the current rotation speed of a cube whose rotation is controlled by a slider.

.. :py:function:: myspeedtxt = wtext(text=f'omega = {vslider.value:.1e} radians/s')

   :param text:
   :type text: text

Variables must be converted to a string using standard Python formatting options.  Text may be updated any time by setting the *text* attribute of the *wtext* object:

``myspeedtxt.text = f'omega = {vslider.value:.1e} radians/s'``

``hidden`` (boolean)
   If ``True``, the wtext element is visually hidden — positioned off-screen so it does not appear in the canvas caption or title — but remains accessible to screen readers. Default is ``False``. This attribute is set at creation and cannot be changed afterward::

      sr_only = wtext(text="Speed: 5 radians per second", hidden=True)

   A hidden wtext is useful as an ``aria-live`` announcement region or as an ``aria_labelledby`` / ``aria_describedby`` target when you want the text to be read by a screen reader but not shown on screen.

Accessibility Attributes
------------------------

``aria_hidden`` (boolean)
   If ``True``, the wtext element is hidden from screen readers. Use for decorative or redundant text that should not be announced::

      units_label = wtext(text=" radians/s", aria_hidden=True)

``aria_live`` (string)
   When set, a screen reader will announce the wtext content whenever it changes. Values are ``'polite'`` (announces when the user is idle) or ``'assertive'`` (announces immediately, interrupting other speech). Use ``'polite'`` for most dynamic readouts::

      speedtxt = wtext(text="Speed: 5", aria_live='polite')

   A ``wtext`` with ``aria_live`` can also be used as the ``aria_labelledby`` or ``aria_describedby`` target of a widget — the screen reader will announce label changes whenever the text updates.

   See also :doc:`aria_div<aria_div>` for grouping multiple widgets into a single live region.

