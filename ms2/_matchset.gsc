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
#include openwarfare\_utils;

init()
{
	level.scr_match_scrim_clock = getdvarx( "scr_match_scrim_clock", "int", 10, 1, 60 );

	if ( !isDefined( level.scr_timeouts_perteam ) || !level.scr_timeouts_perteam )	
		precacheShader("hudstopwatch");
}

SwitchTeams()
{
	tempscores = game["teamScores"]["allies"];
	game["teamScores"]["allies"] = game["teamScores"]["axis"];
	game["teamScores"]["axis"] = tempscores;
	level.mytitle = &"MS2_TEAM_SWITCH";

	for( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];

		if ( !isDefined( player.pers["team"] ) || player.pers["team"] == "spectator" )
			continue;

		if( player.pers["team"] == "allies" )
			player [[level.axis]]();
		else if( player.pers["team"] == "axis" )
			player [[level.allies]]();

		player.freezeorigin = undefined;
		player.freezeangles = undefined;
		player.frozen = false;
		player thread ms2\_ftagplay::RemoveIceItems();
		
		player thread maps\mp\gametypes\_hud_message::oldNotifyMessage( undefined, level.mytitle );
		player maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "side_switch" );
	}
	return;
}

SetClanAsAllies()
{
	level.mytitle = &"MS2_TEAM_SWITCH_ALLIES";

	for( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];

		if ( !isDefined( player.pers["team"] ) || player.pers["team"] == "spectator" )
			continue;

		// Check if this player is a clan member
		if ( isDefined( level.scr_clan_vs_all_tags ) && player isPlayerClanMember( level.scr_clan_vs_all_tags ) )
		{
			newTeam = "allies";
			player setClientDvars( "ui_force_allies", 1,
				                   "ui_force_axis", 0 );
		} else {
			newTeam = "axis";
			player setClientDvars( "ui_force_allies", 0,
				                   "ui_force_axis", 1 );
		}

		if( newTeam == "allies" )
			player [[level.allies]]();
		else if( newTeam == "axis" )
			player [[level.axis]]();

		player.freezeorigin = undefined;
		player.freezeangles = undefined;
		player.frozen = false;
		player thread ms2\_ftagplay::RemoveIceItems();
		
		player thread maps\mp\gametypes\_hud_message::oldNotifyMessage( undefined, level.mytitle );
		player maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "side_switch" );
	}
	return;
}

SetClanAsAxis()
{
	level.mytitle = &"MS2_TEAM_SWITCH_AXIS";

	for( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];

		if ( !isDefined( player.pers["team"] ) || player.pers["team"] == "spectator" )
			continue;

		// Check if this player is a clan member
		if ( isDefined( level.scr_clan_vs_all_tags ) && player isPlayerClanMember( level.scr_clan_vs_all_tags ) )
		{
			newTeam = "axis";
			player setClientDvars( "ui_force_allies", 0,
				                   "ui_force_axis", 1 );
		} else {
			newTeam = "allies";
			player setClientDvars( "ui_force_allies", 1,
				                   "ui_force_axis", 0 );
		}

		if( newTeam == "allies" )
			player [[level.allies]]();
		else if( newTeam == "axis" )
			player [[level.axis]]();

		player.freezeorigin = undefined;
		player.freezeangles = undefined;
		player.frozen = false;
		player thread ms2\_ftagplay::RemoveIceItems();
		
		player thread maps\mp\gametypes\_hud_message::oldNotifyMessage( undefined, level.mytitle );
		player maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "side_switch" );
	}
	return;
}

beginmatch()
{
	// return if already ending via host quit or victory
	if ( game["state"] == "postgame" || level.gameEnded )
		return;

	if ( !level.scr_match_scrim_clock )
		return;

	level.timeremaining = level.scr_match_scrim_clock;

	visionSetNaked( "mpOutro", 2.0 );
		
	game["state"] = "postgame";
	level.gameEndTime = getTime();
	level.gameEnded = true;
	level.inGracePeriod = false;
	level notify ( "game_ended" );
	setGameEndTime( level.scr_match_scrim_clock + 1 ); // stop/hide the timers

	level thread maps\mp\gametypes\_globallogic::updatePlacement();
	setdvar( "g_deadChat", 1 );
	serverHideHUD();

	// freeze players
	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];

		player thread maps\mp\gametypes\_globallogic::freezePlayerForRoundEnd();
		player thread maps\mp\gametypes\_globallogic::roundEndDoF( 4.0 );
		player thread maps\mp\gametypes\_globallogic::freeGameplayHudElems();
		player setClientDvars( "cg_everyoneHearsEveryone", 1 );
		player thread ClearScoresMatch();

		if ( level.teambased )
		{
			[[level._setTeamScore]]("allies", 0 );
			[[level._setTeamScore]]("axis", 0 );
			maps\mp\gametypes\_globallogic::updateTeamScores( "axis", "allies" );
		}
	}

	// Create the HUD elements and wait for the timeout to be over to destroy them
	createHUDelements();

	game["scrim"]["announcelive"] = true;
	game["state"] = "playing";
	level notify ( "restarting" );
	map_restart( true );
	return;
}

createHUDelements()
{
	// Wait for countdown
	level thread maps\mp\gametypes\_globallogic::timeLimitClock_Intermission( level.timeremaining, 1 );
	gameStarts = gettime() + 1000 * level.timeremaining;

	// Create the nice stop watch!
	stopWatch = NewHudElem();
	stopWatch.archived = false;
	stopWatch.hideWhenInMenu = true;
	stopWatch.alignX = "center";
	stopWatch.alignY = "bottom";
	stopWatch.horzAlign = "center";
	stopWatch.vertAlign = "middle";
	stopWatch.sort = 0;
	stopWatch.alpha = 1.0;
	stopWatch.x = 0;
	stopWatch.y = 20;
	stopWatch SetClock( level.timeremaining + 1, 60, "hudStopwatch", 96, 96 );

	//Create The Text For Match Starts In
	MatchTimerInText = createServerFontString( "objective", 2.4 );
	MatchTimerInText setPoint( "CENTER", "TOP", -40, 100 );
	MatchTimerInText setText( game["strings"]["match_starting_in"] );
	MatchTimerInText.color = ( 1, 1, 0 );
	MatchTimerInText.archived = false;
	MatchTimerInText.hideWhenInMenu = true;

	//Create The Text For Countdown
	MatchTimerInTime = createServerFontString( "objective", 2.4 );
	MatchTimerInTime setParent( MatchTimerInText );
	MatchTimerInTime setPoint( "CENTER", "LEFT", 170, 0 );
	MatchTimerInTime setTimer( level.timeremaining );
	MatchTimerInTime.color = ( 1, 1, 0 );
	MatchTimerInTime.archived = false;
	MatchTimerInTime.hideWhenInMenu = true;

	while ( gettime() < gameStarts )
		wait (0.05);

	stopWatch destroy();
	MatchTimerInTime destroyElem();
	MatchTimerInText destroyElem();
	return;
}

ClearScoresMatch()
{
	self closeMenu();
	self closeInGameMenu();

	self.score = resetScoreInfo( "score" );
	self.deaths = resetScoreInfo( "deaths" );
	self.suicides = resetScoreInfo( "suicides" );
	self.kills = resetScoreInfo( "kills" );
	self.headshots = resetScoreInfo( "headshots" );
	self.assists = resetScoreInfo( "assists" );
	self.teamkills = resetScoreInfo( "teamkills" );

	self.killedPlayers = [];
	self.killedPlayersCurrent = [];
	self.killedBy = [];

	self.leaderDialogQueue = [];
	self.leaderDialogActive = false;
	self.leaderDialogGroups = [];
	self.leaderDialogGroup = "";

	self.lastGrenadeSuicideTime = -1;
	self.teamkillsThisRound = 0;
	self.teamKillPunish = false;

	self.pers["lives"] = level.numLives;
	self.deathCount = 0;

	if ( !isDefined( self.pers["team"] ) || self.pers["team"] == "spectator" )
		self [[level.spawnIntermission]]();

	return;
}

resetScoreInfo( dataName )
{
	self.pers[dataName] = 0;
	return 0;
}