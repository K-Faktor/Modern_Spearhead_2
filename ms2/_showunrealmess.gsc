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
	level.scr_show_unreal_messages = getdvarx( "scr_show_unreal_messages", "int", 0, 0, 1 );

	// If messages are disabled then there's nothing else to do here
	if ( level.scr_show_unreal_messages == 0 )
		return;

	level thread onPlayerConnect();
}


onPlayerConnect()
{
	for (;;)
	{
		level waittill("connected", player);
		player thread onPlayerSpawned();
	}
}


onPlayerSpawned()
{
	self endon("disconnect");

	for (;;)
	{
		self waittill("spawned_player");
		self thread waitForKill();
	}
}


waitForKill()
{
	self endon("disconnect");	
	
	// Wait for the player to die
	self waittill( "player_killed", eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, fDistance );

	if( !isDefined( level.firstBloodmessage ) && isDefined(eAttacker) && isPlayer(eAttacker) && eAttacker != self && self.team != eAttacker.team)
	{
		level.firstBloodmessage = true;
		players = level.players;
		for(i = 0; i < players.size; i++)
			if(players[i] != eAttacker && players[i].pers["team"] != "spectator")
				players[i] thread maps\mp\gametypes\_hud_message::oldNotifyMessage(&"MS2_FIRSTBLOOD_REPORT_ALL", eAttacker.name);

		eAttacker thread maps\mp\gametypes\_hud_message::oldNotifyMessage(&"MS2_FIRSTBLOOD_REPORT_SELF");
	} else if(sMeansOfDeath == "MOD_HEAD_SHOT") {
		eAttacker thread maps\mp\gametypes\_hud_message::oldNotifyMessage( &"MS2_HEADSHOT" );
	}

	return;
}
