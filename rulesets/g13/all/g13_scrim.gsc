//******************************************************************************
//  _____                  _    _             __
// |  _  |                | |  | |           / _|
// | | | |_ __   ___ _ __ | |  | | __ _ _ __| |_ __ _ _ __ ___
// | | | | '_ \ / _ \ '_ \| |/\| |/ _` | '__|  _/ _` | '__/ _ \
// \ \_/ / |_) |  __/ | | \  /\  / (_| | |  | || (_| | | |  __/
//  \___/| .__/ \___|_| |_|\/  \/ \__,_|_|  |_| \__,_|_|  \___|
//       | |               We don't make the game you play.
//       |_|                 We make the game you play BETTER.
//
//            Website: http://openwarfaremod.com/
//******************************************************************************

#include openwarfare\_utils;


setRuleset()
{
	setDvar( "scr_league_ruleset", "[G13]Scrim in progress" );
	setDvar( "sv_hostname", "^3[G13]^2Scrim" );
	setDvar( "g_password", "g13ftag" );

	// Freezetag
	setDvar( "scr_showscore_spectator", "1" );
	setDvar( "scr_matchstatus_spectator", "1" );
	setDvar( "scr_disable_match_join", "1" );

	// Match settings
	setDvar( "scr_force_autoassign", "0" );
	setDvar( "scr_teambalance", "0" );
	setDvar( "scr_" + level.gametype + "_teambalanceendofround", "0" );

	// Timers
	setDvar( "scr_match_readyup_period", "0" );
	setDvar( "scr_match_strategy_time", "0" );
	setDvar( "scr_game_playerwaittime", "0" );
	setDvar( "scr_game_matchstarttime", "0" );

	// Map Rotations
	setDvar( "g_gametype", "ftag" );
	setDvar( "sv_mapRotation", "map mp_remagen map mp_argel map mp_cod4malta" );
	setDvar( "sv_mapRotation_1", "" );
	setDvar( "sv_mapRotation_2", "" );
	setDvar( "sv_mapRotation_3", "" );
	setDvar( "sv_mapRotation_4", "" );
	setDvar( "sv_mapRotation_5", "" );
	setDvar( "sv_mapRotation_6", "" );
	setDvar( "sv_mapRotation_7", "" );
	setDvar( "sv_mapRotation_8", "" );
	setDvar( "sv_mapRotation_9", "" );
}
