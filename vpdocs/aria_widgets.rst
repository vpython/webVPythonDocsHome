
Accessibility Attributes
------------------------

These attributes support `ARIA <https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA>`_ (Accessible Rich Internet Applications), making widgets usable with screen readers and other assistive technology.

``aria_label`` (string)
   A text label announced by screen readers when the widget receives focus. Use when there is no visible text that already identifies the widget::

      myslider = slider(bind=setspeed, min=0, max=10, aria_label="Speed")

``aria_labelledby`` (wtext)
   A :doc:`wtext<wtext>` object whose text serves as the accessible label for this widget. Use when a visible ``wtext`` already describes the widget::

      speedlabel = wtext(text="Speed: ")
      myslider = slider(bind=setspeed, min=0, max=10, aria_labelledby=speedlabel)

``aria_describedby`` (wtext)
   A :doc:`wtext<wtext>` object that provides a longer accessible description of the widget, supplementing ``aria_label`` or ``aria_labelledby``::

      hint = wtext(text="Drag left or right to set playback speed from 0 to 10")
      myslider = slider(bind=setspeed, min=0, max=10, aria_label="Speed", aria_describedby=hint)
