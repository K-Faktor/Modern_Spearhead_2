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

#include maps\mp\gametypes\_hud_util;
#include openwarfare\_utils;

init()
{
	// Get the main module's dvar
	level.scr_showscore_spectator = getdvarx( "scr_showscore_spectator", "int", 0, 0, 1 );
	level.scr_matchstatus_spectator = getdvarx( "scr_matchstatus_spectator", "int", 0, 0, 1 );

	// If spectator score is not enabled then there's nothing else to do here
	if ( level.scr_showscore_spectator == 0 && level.scr_matchstatus_spectator == 0 )
		return;

	level thread onPlayerConnect();
}

onJoinedSpectators()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("never_joined_team");
		self RemoveSpectateScore();

		if ( level.scr_showscore_spectator )
			self setSpectateScore();
		if ( level.scr_matchstatus_spectator )
			self setSpectateMatch();
	}
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		self RemoveSpectateScore();
	}
}

onJoinedTeam()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_team");
		self RemoveSpectateScore();
	}
}

setSpectateScore()
{
	self endon ( "disconnect" );
	
	self.leftIcon = createIcon( game["icons"]["allies"], 30, 30 );
	self.leftIcon setPoint( "CENTER", "TOP", -30, 55 );
	self.leftIcon.hideWhenInMenu = true;
	self.leftIcon.archived = false;
	self.leftIcon.alpha = 1;

	self.rightIcon = createIcon( game["icons"]["axis"], 30, 30 );
	self.rightIcon setPoint( "CENTER", "TOP", 30, 55 );
	self.rightIcon.hideWhenInMenu = true;
	self.rightIcon.archived = false;
	self.rightIcon.alpha = 1;

	self.leftScore = createFontString( "objective", 2.0 );
	self.leftScore setParent( self.leftIcon );
	self.leftScore setPoint( "RIGHT", "CENTER", -20, 0 );
	self.leftScore.glowColor = game["colors"]["allies"];
	self.leftScore.glowAlpha = 1;
	self.leftScore setValue( getTeamScore( "allies" ) );
	self.leftScore.hideWhenInMenu = true;
	self.leftScore.archived = false;

	self.rightScore = createFontString( "objective", 2.0 );
	self.rightScore setParent( self.rightIcon );
	self.rightScore setPoint( "LEFT", "CENTER", 20, 0 );
	self.rightScore.glowColor = game["colors"]["axis"];
	self.rightScore.glowAlpha = 1;
	self.rightScore setValue( getTeamScore( "axis" ) );
	self.rightScore.hideWhenInMenu = true;
	self.rightScore.archived = false;
}

setSpectateMatch()
{
	self.matchstatus = createFontString( "objective", 1.4 );
	self.matchstatus setPoint( "CENTER", "TOP", 0, 90 );
	self.matchstatus.glowColor = game["colors"]["allies"];
	self.matchstatus.glowAlpha = 1;
	self.matchstatus setText( game["scrim"]["status"] );
	self.matchstatus.hideWhenInMenu = true;
	self.matchstatus.archived = false;
}

RemoveSpectateScore()
{
	if ( isDefined( self.leftIcon ) )
		self.leftIcon destroyElem();
	if ( isDefined( self.rightIcon ) )
		self.rightIcon destroyElem();
	if ( isDefined( self.leftScore ) )
		self.leftScore destroyElem();
	if ( isDefined( self.rightScore ) )
		self.rightScore destroyElem();
	if ( isDefined( self.matchstatus ) )
		self.matchstatus destroyElem();
}
