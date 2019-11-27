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
	ui_clan_load_mess = getdvar( "scr_clan_load_mess" );
	setdvar( "ui_clan_load_mess", ui_clan_load_mess );
	makeDvarServerInfo( "ui_clan_load_mess" );

	ui_clan_welcome_mess = getdvar( "scr_clan_welcome_mess" );
	setdvar( "ui_clan_welcome_mess", ui_clan_welcome_mess );
	makeDvarServerInfo( "ui_clan_welcome_mess" );

	// Modern Spearhead 2 Quickmessages
	level.scr_enable_spearhead_quickmessages = getdvarx("scr_enable_spearhead_quickmessages","int",0,0,1);
	setdvar( "ui_enable_spearhead_quickmessages", level.scr_enable_spearhead_quickmessages );
	makeDvarServerInfo( "ui_enable_spearhead_quickmessages" );

	// Misc Variables
	level.scr_OneLeftSoundEvent = getdvarx( "scr_OneLeftSoundEvent", "int", 1, 0, 1 );
	level.scr_disable_match_join = getdvarx( "scr_disable_match_join", "int", 0, 0, 1 );

	//+------------------------------------------------------------------------------------------------------------------------------+
	//¦ Freezetag feature call                                                                                                       ¦
	//+------------------------------------------------------------------------------------------------------------------------------+
	// Freezetag Variable
	level.scr_gameplay_ftag = getdvarx( "scr_gameplay_ftag", "int", 0, 0, 1 );
	tempvalue = getdvarx( "ui_gameplay_ftag", "int", 2, 0, 2 );

	if( tempvalue == 2 ) {
		ui_gameplay_ftag = level.scr_gameplay_ftag;
		setdvar( "ui_gameplay_ftag", ui_gameplay_ftag );
		makeDvarServerInfo( "ui_gameplay_ftag" );
	} else {
		level.scr_gameplay_ftag = tempvalue;
	}

	//+------------------------------------------------------------------------------------------------------------------------------+
	//¦ Set custom server name                                                                                                       ¦
	//+------------------------------------------------------------------------------------------------------------------------------+
	openwarfare\_globalinit::initGametypesAndMaps();

	// Fetch the server clan tags for server name.
	level.scr_server_clan_tags = getdvarx( "scr_server_clan_tags", "string", "" );

	if ( level.scr_gameplay_ftag && level.gametype != "ftag" && level.gametype != "war" ) {
		if( level.scr_server_clan_tags != "" )
			clanServerName = "^3" + level.scr_server_clan_tags + "^5Freezetag ^2(" + level.gametype + ")";
		else
			clanServerName = "^3MS2 ^5Freezetag ^2(" + level.gametype + ")";
	} else if ( level.scr_gameplay_ftag ) {
		if( level.scr_server_clan_tags != "" )
			clanServerName = "^3" + level.scr_server_clan_tags + "^5Freezetag";
		else
			clanServerName = "^3MS2 ^5Freezetag";
	} else if ( isDefined ( level.supportedGametypes ) && isDefined ( level.supportedGametypes[level.gametype] ) ) {
		if( level.scr_server_clan_tags != "" )
			clanServerName = "^3" + level.scr_server_clan_tags + "^5" + level.supportedGametypes[level.gametype];
		else
			clanServerName = "^3MS2 ^5" + level.supportedGametypes[level.gametype];
	} else {
		if( level.scr_server_clan_tags != "" )
			clanServerName = "^3" + level.scr_server_clan_tags + "^5Clan ^2(" + level.gametype + ")";
		else
			clanServerName = "^3MS2 ^5Clan ^2(" + level.gametype + ")";
	}

	setDvar( "sv_hostname", clanServerName );
	return;
}
