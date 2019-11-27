//+----------------------------------------------------------------------------------------------------------------------------------+
//¦ Call of Duty 4: Modern Warfare                                                                                                   ¦
//¦----------------------------------------------------------------------------------------------------------------------------------¦
//¦ Mod				: Modern Spearhead 2                                                                                 ¦
//¦ Modifications By		: [G13]Gooser13 and [G13]Newfie"                                                                     ¦
//¦ Website			: http://www.clang13.com                                                                             ¦
//¦                                                                                                                                  ¦
//¦ Main Source Mod		: The OpenWarfare Project... An Open Source Mod for COD4:MW!                                         ¦
//¦ Website  			: http://openwarfaremod.com/                                                                         ¦
//¦                                                                                                                                  ¦
//¦ Secondary Source Mod	: AWE 4, By Wizz and Tally (dedicated to Bell - original creator of AWE)                             ¦
//¦ Website  			: http://www.raidersmerciless.com/                                                                   ¦
//¦                                                                                                                                  ¦
//¦ Third Source Mod		: Freezetag v1.2 from kill3r                                                                         ¦
//¦ Website  			: http://www.kill3rcreations.com/                                                                    ¦
//¦                                                                                                                                  ¦
//¦ Fourth Source Mod		: ExTreme+ X4 Mod                                                                                    ¦
//¦ Website  			: http://www.mycallofduty.com                                                                        ¦
//+----------------------------------------------------------------------------------------------------------------------------------+
//¦ Colour Codes For RGB	Colour Codes For Text                                                                                ¦
//+----------------------------------------------------------------------------------------------------------------------------------+
//¦ Black  0 0 0		^0 = Black                                                                                           ¦
//¦ White  1 1 1 		^7 = White                                                                                           ¦
//¦ Red    1 0 0		^1 = Red                                                                                             ¦
//¦ Green  0 1 0		^2 = Green                                                                                           ¦
//¦ Blue   0 0 1		^4 = Blue                                                                                            ¦
//¦ Yellow 1 1 0		^3 = Yellow                                                                                          ¦
//¦ 				^5 = Cyan                                                                                            ¦
//¦ 				^6 = pink/Magenta                                                                                    ¦
//+----------------------------------------------------------------------------------------------------------------------------------+

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include openwarfare\_utils;

init()
{


	// Get the main module's variable
        level.scr_motd_enable = getdvarx( "scr_motd_enable", "int", 1, 0, 1 );

       	// If module is not enabled there's nothing else to do here
       	if ( !level.scr_motd_enable )
       		return;

	// Set menu items visible
	setdvar( "ui_motd_enable", level.scr_motd_enable );
	makedvarserverinfo( "ui_motd_enable", "" );

      	// Get the main module's dvar
       	level.scr_motd_delay = getdvarx( "scr_motd_delay", "int", 5, 1, 60 );

    	// Set Rotating Messages
   	level thread motdRotate();
}


motdRotate()
{
	level endon( "game_ended" );

   	level.scr_motdmsg = [];

   	count = 1;
   	for(;;)
   	{
      		cvarname = "scr_custom_motd_" + count;
      		msg = getDvar(cvarname);

      		if( !isDefined( msg ) || msg == "" )
			break;

      		level.scr_motdmsg[level.scr_motdmsg.size] = msg;
      		count++;
   	}

    	// Show Rotating Messages
   	level thread motdStartRotation();
}


motdStartRotation()
{
	level endon( "game_ended" );

   	while(1)
   	{
      		for(i = 0; i < level.scr_motdmsg.size; i++)
      		{
         		level.motd = level.scr_motdmsg[i];

			setdvar( "scr_motd", level.motd );
			setdvar( "ui_motd", level.motd );
			makedvarserverinfo( "ui_motd", "" );

         		wait ( level.scr_motd_delay );
      		}
   	}
}