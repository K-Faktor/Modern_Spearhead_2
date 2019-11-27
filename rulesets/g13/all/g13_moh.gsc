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
	setDvar( "scr_league_ruleset", "[G13]MOHAA" );
	setDvar( "g_password", "" );

	// Freezetag
	setDvar( "scr_showscore_spectator", "0" );
	setDvar( "scr_matchstatus_spectator", "0" );
	setDvar( "scr_disable_match_join", "0" );

	// Match settings
	setDvar( "scr_force_autoassign", "1" );
	setDvar( "scr_teambalance", "1" );
	setDvar( "scr_" + level.gametype + "_teambalanceendofround", "1" );

	// Timers
	setDvar( "scr_match_readyup_period", "0" );
	setDvar( "scr_match_strategy_time", "0" );
	setDvar( "scr_game_playerwaittime", "0" );
	setDvar( "scr_game_matchstarttime", "0" );

	// Map Rotations
	setDvar( "g_gametype", "ftag" );
	setDvar( "sv_mapRotation", "gametype ftag map mp_remagen map mp_thehunt_final map mp_argel map mp_cod4malta map mp_bridge map mp_v2 map mp_moh_sfrance_b1 map mp_mohaa_dv" );
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
