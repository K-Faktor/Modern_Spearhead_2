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
	level.scr_ftag_enable_streaks = getdvarx("scr_ftag_enable_streaks","int",1,0,1);

	// Check if dvar is enabled, if not exit sub
	if ( !level.scr_ftag_enable_streaks )
		return;

	// Check if playing freezetag, if not exit sub
	if ( !isdefined(level.scr_gameplay_ftag) || !level.scr_gameplay_ftag )
		return;

	// Get other dvars
	level.scr_ftag_streak_duration = getdvarx("scr_ftag_streak_duration","int",30,1,300);
	level.scr_disable_power_streaks = getdvarx("scr_disable_power_streaks","int",1,0,1);
	tempStreaks = getdvarlistx( "scr_ftag_streak_", "string", "" );

	// Get streak type and amount of kills needed
	level.scr_ftag_streak = [];
	for ( iLine=0; iLine < tempStreaks.size; iLine++ ) {
		thisLine = strtok( tempStreaks[iLine], ";" );
		level.scr_ftag_streak[iLine]["type"] = thisLine[0];
		level.scr_ftag_streak[iLine]["amount"] = int( thisLine[1] );
	}

	// Precache strings
	precacheString( &"MS2_STREAK_SPEED_YOU" );
	precacheString( &"MS2_STREAK_SPEED_ALL" );
	precacheString( &"MS2_STREAK_UAV_YOU" );
	precacheString( &"MS2_STREAK_UAV_ALL" );
	precacheString( &"MS2_STREAK_HIDE_YOU" );
	precacheString( &"MS2_STREAK_HIDE_ALL" );
	precacheString( &"MS2_STREAK_INVINCIBLE_YOU" );
	precacheString( &"MS2_STREAK_INVINCIBLE_ALL" );
	precacheString( &"MS2_STREAK_OVER_YOU" );
	precacheString( &"MS2_STREAK_OVER_ALL" );

	// Monitor player
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	self endon("disconnect");

	for(;;)
	{
		level waittill("connected", player);

		player.cur_freeze_streak = 0;
		player.cur_melt_streak = 0;
		player.freeze_streak = player maps\mp\gametypes\_persistence::statGet( "freeze_streak" );
		player.melt_streak = player maps\mp\gametypes\_persistence::statGet( "melt_streak" );

		player thread onPlayerSpawned();
		player thread onPlayerMelted();
		player thread onPlayerKilled();
		player thread watchStreaks();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		self ResetStreaks();
	}
}

onPlayerKilled()
{
	self endon("disconnect");
	
	for(;;)
	{
		// Wait for the player to die
		self waittill( "player_killed", eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, fDistance );

		if( !eAttacker.hasSpecialPowers || !level.scr_disable_power_streaks ) {
			eAttacker.cur_freeze_streak += 1;

			if ( eAttacker.cur_freeze_streak > eAttacker.freeze_streak )
			{
				eAttacker maps\mp\gametypes\_persistence::statSet( "freeze_streak", eAttacker.cur_freeze_streak );
				eAttacker.freeze_streak = eAttacker.cur_freeze_streak;
			}
		}

		self ResetStreaks();
		self.cur_freeze_streak = 0;
		self.cur_melt_streak = 0;

		eAttacker notify( "streak_given", "freeze", eAttacker.cur_freeze_streak );
	}
}

onPlayerMelted()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("give_melt");

		if ( !self.hasSpecialPowers || !level.scr_disable_power_streaks )
			self.cur_melt_streak += 1;

		self notify( "streak_given", "melt", self.cur_melt_streak );
	}
}

ResetStreaks()
{
	self.hasSpecialPowers = false;
	self setMoveSpeedScale( 1 );
	self setClientDvar( "ui_uav_client", 0 );
	self setClientDvar( "g_compassShowEnemies", 0 );
	self.invincible = undefined;
	self.instantmelt = undefined;
	self.hasRadar = false;
	self Show();

	return;
}

watchStreaks()
{
	self endon("disconnect");
	level endon( "game_ended" );

	for(;;)
	{
		self waittill( "streak_given", streakName, streakAmount );

		playerCounts = ms2\_ftagplay::CountPlayersFrozen();
		if( self.pers["team"] == "allies" && playerCounts["axisTotal"] == playerCounts["axisFrozen"] )
			continue;
		else if( self.pers["team"] == "axis" && playerCounts["alliesTotal"] == playerCounts["alliesFrozen"] )
			continue;

		if( isDefined( self.spawn_protected ) && self.spawn_protected )
			continue;

		// Watch for freezestreaks
		for ( i=0; i < level.scr_ftag_streak.size; i++ ) {
			if( level.scr_ftag_streak[i]["amount"] == 0 )
				continue;
			if( level.scr_ftag_streak[i]["type"] == streakName && streakAmount == level.scr_ftag_streak[i]["amount"] )
				activateStreak( i );
		}
	}
}

activateStreak( streaknumber )
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );

	self.hasSpecialPowers = true;
	self.streakStartTime = gettime();
	self.streakFinishTime = ( self.streakStartTime + ( level.scr_ftag_streak_duration * 1000 ) ) ;

	switch ( streaknumber )
	{
		case 0:
			self setMoveSpeedScale( 1.5 );

			if ( level.scr_ftag_showcentermessage )
				self iprintlnbold(&"MS2_STREAK_SPEED_YOU", level.scr_ftag_streak_duration );
			if ( level.scr_ftag_showstatusmessage )
				iPrintln(&"MS2_STREAK_SPEED_ALL" , self.name, level.scr_ftag_streak_duration );
			break;
		case 1:
			self maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "uav_online" );
			self.hasRadar = true;
			self setClientDvar( "ui_uav_client", 1 );
			self setClientDvar( "g_compassShowEnemies", 1 );

			if ( level.scr_ftag_showcentermessage )
				self iprintlnbold(&"MS2_STREAK_UAV_YOU", level.scr_ftag_streak_duration );
			if ( level.scr_ftag_showstatusmessage )
				iPrintln(&"MS2_STREAK_UAV_ALL" , self.name, level.scr_ftag_streak_duration );
			break;
		case 2:
			self Hide();

			if ( level.scr_ftag_showcentermessage )
				self iprintlnbold(&"MS2_STREAK_HIDE_YOU", level.scr_ftag_streak_duration );
			if ( level.scr_ftag_showstatusmessage )
				iPrintln(&"MS2_STREAK_HIDE_ALL" , self.name, level.scr_ftag_streak_duration );
			break;
		case 3:
			self.invincible = true;

			if ( level.scr_ftag_showcentermessage )
				self iprintlnbold(&"MS2_STREAK_INVINCIBLE_YOU", level.scr_ftag_streak_duration );
			if ( level.scr_ftag_showstatusmessage )
				iPrintln(&"MS2_STREAK_INVINCIBLE_ALL" , self.name, level.scr_ftag_streak_duration );
			break;
		case 4:
			self.instantmelt = true;

			if ( level.scr_ftag_showcentermessage )
				self iprintlnbold(&"MS2_STREAK_MELT_YOU", level.scr_ftag_streak_duration );
			if ( level.scr_ftag_showstatusmessage )
				iPrintln(&"MS2_STREAK_MELT_ALL" , self.name, level.scr_ftag_streak_duration );
			break;
		default:
			break;
	}

	while( gettime() <= self.streakFinishTime )
		wait (0.05);

	self ResetStreaks();

	if ( level.scr_ftag_showcentermessage )
		self iprintlnbold(&"MS2_STREAK_OVER_YOU" );
	if ( level.scr_ftag_showstatusmessage )
		iPrintln(&"MS2_STREAK_OVER_ALL", self.name );
}
