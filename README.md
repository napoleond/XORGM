#XORGM

XORGM (the eXcellent ORGanizational chart Maker) was one of many ambitious summer projects of mine during my time at CFSAS (summer of 2010, I believe). The idea was to provide a user-friendly way for the curriculum developers to create the multitude of org charts necessary for the course in a format that we on the delivery side could a) use directly (the previous process required immediately re-drawing any org charts we were given) and b) re-skin at will.

I created an XML schema that I believed could describe any org chart that would ever appear in the course, and then set about creating a GUI which would save charts in that schema and also export PNGs. (I can not take any credit for the visual design of the GUI, which is all the work of my brilliant colleague [@David_Breen](http://twitter.com/David_Breen).)

The resulting ~3k LOC of ActionScript (we were targetting Adobe AIR) are included here, along with a "help.html" file which I produced as a guide for the curriculum developers. The program works surprisingly well considering that it was the spare-time summer project of a single developer, but sadly that fall came with new priorities at the school and the project was mothballed.

I may pick it up again one day, but in the meantime if anyone else wants to play with it feel free! One caveat is that it was only ever developed and tested on Windows, and I suspect that certain aspects (particularly the menus) might not work properly in other OSes. It is also not documented or commented well, for which I apologize--it's always so strange to look back on my old code and realize the ways I've changed.
