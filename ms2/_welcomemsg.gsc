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
	// Get the main module's dvar
	level.svr_welcome_msg_delay = getdvarx( "svr_welcome_msg_delay", "int", 1, 1, 60 );
	level.svr_welcome_msg = getdvarx( "svr_welcome_msg", "string", undefined, undefined, undefined);
	level.scr_welcome_at_start = getdvarx( "scr_welcome_at_start", "int", 0, 0, 2 );
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);
		player thread SetMyRules();

		if ( level.scr_welcome_at_start )
			player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		if ( game["state"] != "postgame" )
			self thread displaywelcomeMsg();
	}
}

displaywelcomeMsg()
{
	if (level.svr_welcome_msg_delay && !isDefined(self.pers["welcomeMsgDone"]))
	{
		wait level.svr_welcome_msg_delay;
		self thread welcomeMsg();
		while (!isDefined(self.pers["welcomeMsgDone"]))
			wait .50;
	}
}

welcomeMsg()
{
	wait .50;
	if (level.svr_welcome_msg != "")
		self iprintlnbold(level.svr_welcome_msg + ", " + self.name);
	self.pers["welcomeMsgDone"] = true;
}

SetMyRules()
{
	self endon("disconnect");

	//+------------------------------------------------------------------------------------------------------------------------------+
	//¦ Set custom server rules                                                                                                      ¦
	//+------------------------------------------------------------------------------------------------------------------------------+

	if ( level.gametype == "ch" ) {
		setDvar( "scr_server_rule_all_1", "Players on both teams need to capture the flag and hold it to score points." );
		setDvar( "scr_server_rule_all_2", "Players will score one point after holding the flag for a certain amount of time." );
		setDvar( "scr_server_rule_all_3", "Once the team scores the point the round will end." );
	} else if ( level.gametype == "ctf" ) {
		setDvar( "scr_server_rule_all_1", "Players on both teams need to steal the other team's flag and return it to their base." );
		setDvar( "scr_server_rule_all_2", "Each team will also need to protect their flag before being able to score points." );
		setDvar( "scr_server_rule_all_3", "Players will be able to return their flag when the enemy drops it by touching it." );
	} else if ( level.gametype == "dom" ) {
		setDvar( "scr_server_rule_all_1", "Players on both teams need to capture the flags around the map to gain points." );
		setDvar( "scr_server_rule_all_2", "If one team controls all the flags they will received extra bonus points." );
		setDvar( "scr_server_rule_all_3", "Team with the most points after the time limit wins" );
	} else if ( level.gametype == "koth" ) {
		setDvar( "scr_server_rule_all_1", "In Headquarters players on both teams need to capture the objective." );
		setDvar( "scr_server_rule_all_2", "The team must then defend it for certain amount of time to gain points." );
		setDvar( "scr_server_rule_all_3", "Once the objective is captured it will respawn in another location." );
	} else if ( level.gametype == "sab" ) {
		setDvar( "scr_server_rule_all_1", "In Sabotage a bomb is located in the middle of the map." );
		setDvar( "scr_server_rule_all_2", "both teams need to recover this bomb and destroy the other team's base." );
		setDvar( "scr_server_rule_all_3", "Once the other teams base is destroyed the round is over." );
	} else {
		setDvar( "scr_server_rule_all_1", "In Freeze Tag two teams fight each other to completely freeze the other team." );
		setDvar( "scr_server_rule_all_2", "Once a player has been frozen, their team must unfreeze them to respawn." );
		setDvar( "scr_server_rule_all_3", "Often it's better to unfreeze your team than try to fight the enemy alone." );
	}

	if ( level.scr_gameplay_ftag ) {
		setDvar( "scr_server_rule_all_4", "Players can also freeze all the enemy players to win." );
		setDvar( "scr_server_rule_all_5", "To ^5Unfreeze ^7your team, stand next to them or press and hold your ^3use ^7key, (Default F)!" );
	} else {
		setDvar( "scr_server_rule_all_4", "" );
		setDvar( "scr_server_rule_all_5", "Freezetag feature is disabled." );
	}

	self setClientDvars( "ui_server_rule_all_1", getdvar( "scr_server_rule_all_1" ) );
	self setClientDvars( "ui_server_rule_all_2", getdvar( "scr_server_rule_all_2" ) );
	self setClientDvars( "ui_server_rule_all_3", getdvar( "scr_server_rule_all_3" ) );
	self setClientDvars( "ui_server_rule_all_4", getdvar( "scr_server_rule_all_4" ) );
	self setClientDvars( "ui_server_rule_all_5", getdvar( "scr_server_rule_all_5" ) );
}