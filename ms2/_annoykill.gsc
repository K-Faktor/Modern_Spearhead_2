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
	level.scr_ftag_annoy_warn = getdvarx("scr_ftag_annoy_warn","int",1,0,1);

	// Check if dvar is enabled, if not exit sub
	if ( !isdefined(level.scr_ftag_annoy_warn) || !level.scr_ftag_annoy_warn )
		return;

	// Check if playing freezetag, if not exit sub
	if ( !isdefined(level.scr_gameplay_ftag) || !level.scr_gameplay_ftag )
		return;

	// Get other dvars
	level.scr_ftag_annoy_safezone = getdvarx("scr_ftag_annoy_safezone","int",4,1,60);
	level.ftag_annoy_knife = getdvarx("scr_ftag_annoy_knife","int",2,0,1000);
	level.ftag_annoy_dist = getdvarx("scr_ftag_annoy_dist","int",200,1,1000);
	level.ftag_annoy_shots = getdvarx("scr_ftag_annoy_shots","int",15,0,1000);

	if ( level.ftag_annoy_knife == 0 && level.ftag_annoy_shots == 0 )
		return;

	// Precache strings
	precacheString( &"MS2_PLAYER_ANNOYING_PLAYER" );
	precacheString( &"MS2_ENEMY_ALREADY_FROZEN" );
	precacheString( &"MS2_FRIENDLY_ALREADY_FROZEN" );
	precacheString( &"MS2_ANNOY_GIVE_POINTS" );
	precacheString( &"MS2_ANNOY_RECEIVE_POINTS" );
	precacheString( &"MS2_ANNOY_FREEZE_PLAYER" );

	// Monitor player
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	self endon("disconnect");

	for(;;)
	{
		level waittill("connected", player);

		player thread onKilledPlayer();
		player thread onPlayerDamaged();
	}
}

onKilledPlayer()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("player_killed");	
		self.killtime = gettime();
	}
}

onPlayerDamaged()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill( "player_struck", eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );

		if ( !isDefined(eAttacker) || !isPlayer(eAttacker) )
			continue;

		if ( self.team != eAttacker.team && ( !isdefined(self.frozen) || !self.frozen ) )
			continue;

		if ( isdefined(self.killtime) && ( ( gettime() - self.killtime ) < ( level.scr_ftag_annoy_safezone * 1000 ) ) )
			continue;

		if ( !isdefined(eAttacker.knifekilltime) )
			eAttacker.knifekilltime = 0;
		if ( !isdefined(eAttacker.numberofknife) )
			eAttacker.numberofknife = 0;
		if ( !isdefined(eAttacker.numberofshots) )
			eAttacker.numberofshots = 0;

		if ( sMeansOfDeath == "MOD_MELEE" && level.ftag_annoy_knife ) {
			if ( ( gettime() - eAttacker.knifekilltime ) <= ( level.scr_ftag_annoy_safezone * 1000 ) || eAttacker.knifekilltime == 0 )
				eAttacker.numberofknife ++;
			else
				eAttacker.numberofknife = 0;

			eAttacker.knifekilltime = gettime();
			if ( eAttacker.numberofknife >= level.ftag_annoy_knife )
				self thread onPlayerAnnoy( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, eAttacker.team );
		} else if ( level.ftag_annoy_shots ) {
			if( distance( eAttacker.origin, self.origin ) <= level.ftag_annoy_dist )
				eAttacker.numberofshots ++;
			else
				eAttacker.numberofshots = 0;

			if ( eAttacker.numberofshots >= level.ftag_annoy_shots )
				self thread onPlayerAnnoy( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, eAttacker.team );
		}
	}
}

onPlayerAnnoy( eInflictor, eAnnoyingPlayer, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, team )
{
	if (isdefined(self.isBeingAnnoyed) && self.isBeingAnnoyed)
		return;

	self.isBeingAnnoyed = true;

	// Display messages accross players screen if enabled
	if ( level.scr_ftag_showcentermessage ) {
		if( self.team != eAnnoyingPlayer.team )
			eAnnoyingPlayer iPrintlnBold(&"MS2_ENEMY_ALREADY_FROZEN", self.name);
		else
			eAnnoyingPlayer iPrintlnBold(&"MS2_FRIENDLY_ALREADY_FROZEN", self.name);

		eAnnoyingPlayer iPrintlnBold(&"MS2_ANNOY_GIVE_POINTS", self.name);
		self iPrintlnBold(&"MS2_ANNOY_RECEIVE_POINTS", eAnnoyingPlayer.name);
		self iPrintlnBold(&"MS2_ANNOY_FREEZE_PLAYER");
	}

	eAnnoyingPlayer.pers["obituarymsg"] = true;
	eAnnoyingPlayer thread RemoveAnnoyPoints( eInflictor, self, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, team );
}

RemoveAnnoyPoints( eInflictor, eAnnoyedPlayer, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, team )
{
	// Set the point loss value for annoying players if not set previous
	if( !isDefined( level.annoypointloss ) || !level.annoypointloss )
		level.annoypointloss = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );

	// Remove points from the annoying player's score
	NewPlayerScore = maps\mp\gametypes\_globallogic::_getPlayerScore( self );
	NewPlayerScore -= level.annoypointloss;
	if( NewPlayerScore >= 0 )
		maps\mp\gametypes\_globallogic::_setPlayerScore( self, NewPlayerScore );

	// Remove 1 kill from the annoying player
	NewPlayerKills = self maps\mp\gametypes\_globallogic::getPersStat( "kills" );
	NewPlayerKills--;
	if ( NewPlayerKills >= 0 )
		self maps\mp\gametypes\_globallogic::incPersStat( "kills", -1 );
	self.kills = self maps\mp\gametypes\_globallogic::getPersStat( "kills" );
	self maps\mp\gametypes\_globallogic::updatePersRatio( "kdratio", "kills", "deaths" );

	// Kill annoying player and add 1 death, 1 kill, & 1 score to annoyed player
	if( self.team != eAnnoyedPlayer.team ) {
		self thread maps\mp\gametypes\_globallogic::Callback_Playerkilled(eInflictor, eAnnoyedPlayer, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, 1916);
	} else {
		// Kill annoying player and add 1 death
		self suicide();

		// Give annoyed player 1 kill
		eAnnoyedPlayer maps\mp\gametypes\_globallogic::incPersStat( "kills", 1 );
		eAnnoyedPlayer.kills = self maps\mp\gametypes\_globallogic::getPersStat( "kills" );
		eAnnoyedPlayer maps\mp\gametypes\_globallogic::updatePersRatio( "kdratio", "kills", "deaths" );

		// Give annoyed player a kill score
		NewPlayerScore = maps\mp\gametypes\_globallogic::_getPlayerScore( eAnnoyedPlayer );
		NewPlayerScore += level.annoypointloss;
		maps\mp\gametypes\_globallogic::_setPlayerScore( eAnnoyedPlayer, NewPlayerScore );
	}

	self playLocalSound( "hahaha" );
	self.numberofshots = 0;
	self.numberofknife = 0;

	// Display message to players involved about the annoy kill
	if ( level.scr_ftag_showstatusmessage ) {
		self iPrintln(&"MS2_PLAYER_ANNOYING_PLAYER" , self.name , eAnnoyedPlayer.name);
		eAnnoyedPlayer iPrintln(&"MS2_PLAYER_ANNOYING_PLAYER" , self.name , eAnnoyedPlayer.name);
	}

	eAnnoyedPlayer.isBeingAnnoyed = false;
}