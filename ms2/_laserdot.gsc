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

#include openwarfare\_utils;

init()
{
	level.scr_show_laserdot = getdvarx( "scr_show_laserdot", "int", 0, 0, 3 );
	level.laserdotred = getdvarx( "scr_laserdot_red", "int", 1, 0, 1 );
	level.laserdotgreen = getdvarx( "scr_laserdot_green", "int", 0, 0, 1 );
	level.laserdotblue = getdvarx( "scr_laserdot_blue", "int", 0, 0, 1 );
	level.laserdotsize = getdvarx( "scr_laserdot_size", "int", 2, 1, 10 );

	if ( level.scr_show_laserdot == 0 )
		return;

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		self thread setmylaserdot();
	}
}

setmylaserdot()
{
	self endon("disconnect");
	self endon("death");
	self endon( "game_ended" );
	self endon("joined_spectators");

	if(!isDefined(self.laserdot))
	{
		self.laserdot = newClientHudElem(self);
		self.laserdot.x = 320;
		self.laserdot.y = 240;
		self.laserdot.alignX = "center";
		self.laserdot.alignY = "middle";
		self.laserdot.horzAlign = "fullscreen";
		self.laserdot.vertAlign = "fullscreen";
		self.laserdot.alpha = 0;
		self.laserdot.color = (level.laserdotred, level.laserdotgreen, level.laserdotblue);
		self.laserdot setShader("white", level.laserdotsize, level.laserdotsize );
	}

	if( level.scr_show_laserdot == 1 ) 
		self.laserdot.alpha = 1;
	else 
		self thread laserdotMonitor();
}

laserdotMonitor()
{
	self endon("disconnect");
	self endon("death");
	self endon( "game_ended" );
	self endon("joined_spectators");

	while(isPlayer(self) && self.sessionstate == "playing")
	{
		switch( level.scr_show_laserdot )
		{
			case 2:
				if(self playerads()) self.laserdot.alpha = 1;
					else self.laserdot.alpha = 0;
				break;
			case 3:
				if(self playerads()) self.laserdot.alpha = 0;
					else self.laserdot.alpha = 1;
				break;
		}
		wait 0.5;
	}
}
