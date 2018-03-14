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


https://www.thingiverse.com/thing:2515632
ANET A8 Filament Sensor Switch/Guide (out of filament, filament jam) by kingbubbatruck is licensed under the Creative Commons - Attribution license.
http://creativecommons.org/licenses/by/3.0/

# Summary

UPDATED: I've modified this to now be able to sense filament spool jams. Everything else, code wise, works the same. The new versions are named 'filament_jam_sensor.  There is a switch body and a sensor arm.  You will need a small machine screw to hold the arm to the switch body.

I had a collection of springs around and found one about 18mm long by 10.5mm diameter that worked pretty well for this.

The sketchup file has another version in it where you can use rubber bands, if you can't find a spring.
-----------------------------------------------------------------------------------
I was tired of dealing with dribs and drabs of filament left on my spools so I thought I would put something together.  I had seen a number of other projects with optical and mechanical switches, but none matched this batch of microswitches I had on hand, so off to skecthup to design something.

This is designed to be both a filament guide and a sensor.  On my machine it's a perfect friction fit on the acrylic crossbar of the printer.  The cover for the switchbox is also a friction fit.  On my print, it fit's quite tight and does not require glue to stay on.

I'm using the octoprint plugin octoprint filament reloaded
https://github.com/kontakt/Octoprint-Filament-Reloaded

The switch is an SV-166-1c25.  It seems pretty widely available, just google it and you'll find a supplier.

So, It's pretty basic.  What this does is when your filament runs out, it will pause the print, let you put in a new spool, and then resume printing, assuming you are using octoprint.

I had a little trouble getting this to run due to 2 misunderstandings on my part.
1) This uses the 'board' number on the raspberry pi, not the 'bcm' number.  The board number is the physical pin number. The bcm number is the GPIONN number.

2) I had been testing this initially on a pretty large model.  I 'think' that this will only pause between levels on the print.  So I wasn't being patient enough and kept going back and forth wondering why it wasn't working.

Once I stuck with the board number and used a smaller model for testing, I was able to verify that every thing was working the way it should.  I also started watching the .octoprint/logs/octoprint.log file for the messages indicating it was working.

Pin Connections.
I already had a dual relay connected to the gpio pins on my Pi to be able to turn the printer on/off and turn some led lights I have mounted on/off.  
The connections for the relay used pings 04,06, 12, and 16.

for the switch I ended up connecting it to pins 18(gpio24) and 20(gnd)

In the settings for the Filament Sensor Reloaded plugin, I have it set for :
Pin 18
Switch Type Normally Closed
Board Pin Mode - Board

For the Out Of Filament Gcode, I have it set to change the display on the printer to show 'Out of Filament'

I have it set to pause when out of filament.  This is cool because it will run the pause and resume scripts from the Ocotprint Control panel.

I have the pause and resume settings setup to move the print head out of the way so I can change the filament, and then it will go back and resume printing where it left off.  I did not create these commands, I just found them out on the internet.  They seem to do what I want, so I haven't messed with them much.

All in all, This seems like a pretty slick setup and I want to commend the folks that put together octoprint and the filament sensor reloaded plugin, and the folks I stole the rest of this design and scripts from, for a job well done.





Pause Settings
    ; relative XYZE
    G91
    M83
    ; retract filament, move Z slightly upwards
    G1 Z+5 E-5 F4500 
    ; absolute XYZE
    M82
    G90
    ; move to a safe rest position, adjust as necessary
    G1 X0 Y0  


Resume Settings
; relative extruder
M83
; prime nozzle
G1 E-5 F4500
G1 E5 F4500
G1 E5 F4500
; absolute E
M82
; absolute XYZ
G90
; reset E
G92 E{{ pause_position.e }}
; move back to pause position XYZ
G1 X{{ pause_position.x }} Y{{ pause_position.y }} Z{{ pause_position.z }} F4500
; reset to feed rate before pause
G1 {{ pause_position.f }}