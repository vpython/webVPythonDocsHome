
group
=====

..	image:: /images/group-car.png

..	Note::

	This is a beta release of *group*.  Points, curves, helix and label do not currently work with *group*.  The *size* attribute of *group* exists but is meaningless. Currently it is possible to have only one group object. *group* is currently available only in Web Vpython.

A group is a collection of objects. Moving or rotating a group affects all objects in the group.  However, objects belonging to a group retain their identities and can be rotated, resized, colored etc. individually.  (In contrast, objects used to create a :doc:`compound <compound>` lose their individual identities once compounded. Compound is less expensive computationally than group.)  

For example, using a group you can create a car whose wheels turn as the entire group moves, as in this `example program <https://www.glowscript.org/#/user/GlowScriptDemos/folder/Examples/program/Car>`_ .

To create a group:

#. First create the group
#. Then add objects to the group by specifying the name of the group as the *group* attribute of each object. **Positions of objects in a group are relative to the pos of the group.**

..	py:function:: mygroup = group(pos=vec(1,-1,3) )

   :param pos: Position of group. Default <0,0,0>. This is not necessarily the center of the collection of objects, nor is it necessarily at one end.
   :type pos: vector
   :param axis: Default <1,0,0>. Modifying axis changes the orientation of all objects in the group.
   :type axis: vector
   :param color: Modifying the color of a group changes the color of every object belonging to the group; the original color of a constituent object is lost. Initially the color of a group is set to white although the constituent objects retain their own colors. Assigning any value to *color* permanently changes the color of all objects in the group.
   :type color: vector
   :param visible: If False, object is not displayed.  Default: True
   :type visible: boolean
   :param canvas:  Default is *scene*.
   :type canvas: object
   :param make_trail: If True, object leaves a trail when moved. 
   :type make_trail: boolean
   :param up: A vector perpendicular to the axis.
   :type up: vector

..	code-block::

	mygroup = group(pos=vec(0,0,0))
	p1 = pyramid(group=mygroup, pos=vec(1,0,0), color=color.red)
	p2 = pyramid(group=mygroup, pos=vec(1,2,0), color=color.yellow)
	scene.pause()
	mygroup.pos=vec(-3,0,0)
	scene.pause()
	mygroup.rotate(angle=pi/2, axis=vec(0,0,1))


Methods of group
----------------

..	py:method:: mygroup.group_to_world(myvec) 
	:noindex:

Converts a location relative to the group position to a position in world coordinates.

..	py:method:: mygroup.world_to_group(myvec)
	:noindex:

Converts a location in world coordinates to a position relative to the pos of a group.

..	py:method:: mygroup.rotate(axis=vec(0,0,1), angle=pi/2)

Same as rotation for 3D objects. 

..	seealso:: 

	:doc:`rotate<rotation>`; :doc:`compound<compound>`


  