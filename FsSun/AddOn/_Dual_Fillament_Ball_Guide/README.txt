                   .:                     :,                                          
,:::::::: ::`      :::                   :::                                          
,:::::::: ::`      :::                   :::                                          
.,,:::,,, ::`.:,   ... .. .:,     .:. ..`... ..`   ..   .:,    .. ::  .::,     .:,`   
   ,::    :::::::  ::, :::::::  `:::::::.,:: :::  ::: .::::::  ::::: ::::::  .::::::  
   ,::    :::::::: ::, :::::::: ::::::::.,:: :::  ::: :::,:::, ::::: ::::::, :::::::: 
   ,::    :::  ::: ::, :::  :::`::.  :::.,::  ::,`::`:::   ::: :::  `::,`   :::   ::: 
   ,::    ::.  ::: ::, ::`  :::.::    ::.,::  :::::: ::::::::: ::`   :::::: ::::::::: 
   ,::    ::.  ::: ::, ::`  :::.::    ::.,::  .::::: ::::::::: ::`    ::::::::::::::: 
   ,::    ::.  ::: ::, ::`  ::: ::: `:::.,::   ::::  :::`  ,,, ::`  .::  :::.::.  ,,, 
   ,::    ::.  ::: ::, ::`  ::: ::::::::.,::   ::::   :::::::` ::`   ::::::: :::::::. 
   ,::    ::.  ::: ::, ::`  :::  :::::::`,::    ::.    :::::`  ::`   ::::::   :::::.  
                                ::,  ,::                               ``             
                                ::::::::                                              
                                 ::::::                                               
                                  `,,`


http://www.thingiverse.com/thing:1780376
 Dual Fillament Ball Guide Geeetech Prusa I3 pro C by JD_Printing is licensed under the Creative Commons - Attribution license.
http://creativecommons.org/licenses/by/3.0/

# Summary

While technically not a remix, I did like 'Geeetech Prusa I3 X Ball filament guide by Rafaello, published  Apr 29, 2016' ball filament guide. But I needed to have two spheres to guide the filament for my dual extruders.  Special thanks for the inspiration! 

If you print this, please post a picture on the 'I've made one'.  Thanks!

I was thinking about coping their files but found that it contained too many continuously changing curves, not easy for a quick copy.  So... I decided to create my own from scratch.  It gave me more practice using Freecad which I can always use.

At first I made this as a single color print.  Then I thought, "This is for dual filament extruders!  What would be more fun than to print it with the dual extruders?"  Having not used both extruders except to see that the second one worked (I'm still a newbie at this).  I didn't know what I was getting into.  But as it turned out - not too hard.  And Yes, I would design two color prints again.
 
So now I had to learn how to create the two extruder files, have the extruder files align, and then print them.   Remember this is after only printing someone else's file for dual extruder.  The good news is I tried a few things and it worked!  Let me know if you need some instructions on how I did it in Freecad.

Then on to the first print.  Oh no, I found that my extruders were not calibrated close enough so the spheres became part of the base - they wouldn't move.  

To get the first working print (which I am using now) I decreased the ball diameter to 8 mm.  This allowed it to rotate freely.  The only problem was it 'looks' loose.  As the ball drops about 1 1/2 mm just sitting in the socket. But It works great and better than I hoped!  Keeps the filament coming in 'straight' to the extruders.

So I designed a couple of calibration cubes (8mm, 8.4mm and 8.7mm balls) to test my setup.  I found that I could go a little bigger on the spheres.  Check out my Thingiverse posting for the test box with internal spheres.

I am now calibrating the extruders to see if it will print any better.  I'm using 'Dual Extrusion Calibration using Slic3r by doctek, published  Jul 28, 2013 '  Check it out if you need to calibrate the extruder offsets.

I didn't get the calibration perfect yet, but I was able to print out the dual filament holder with the 8.4 mm spheres.  They broke free very easily and are working perfectly.


# Print Settings

Printer: Geeetech i3 pro c
Rafts: No
Supports: No
Resolution: .2
Infill: 30%

# Post-Printing

Every time I learn something new.....  something else is not quite right.

And so it is with printing with dual extruders.  I'm getting an oozing problem that imbeds the two colors on the edges of each other.  Setting the retracting higher has helped, but I would like it better.  If someone knows how to do a 'wipe' tower in Slic3r let me know.  

# How I Designed This

Using Freecad.  This item is fully parametric.


# Custom Section

To print in one color just load both (Slic3r) and join as the same group, naming the same extruder. Other slicing programs probably have similar features.

If anyone is having trouble joining these as a single color file, let me know and I can generate it for you. (probably the 8.4 mm sphere would be best). But why would you do that if you have dual extruders?  Also, if you want the freecad files I can also upload them.

The first picture is with the 8.4 mm spheres.  The last (darker picture) is with the 8 mm spheres.  Both have worked great for me.