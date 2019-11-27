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
	setDvar( "scr_league_ruleset", "[G13]Freezetag Stock Maps" );
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
	setDvar( "sv_mapRotation", "map mp_backlot map mp_crash map mp_citystreets map mp_crossfire map mp_bog map mp_strike map mp_overgrown map mp_showdown map mp_creek" );
	setDvar( "sv_mapRotation_1", "map mp_pipeline map mp_vacant map mp_broadcast map mp_cargoship map mp_convoy map mp_bloc map mp_citi_farm map mp_shipment" );
	setDvar( "sv_mapRotation_2", "" );
	setDvar( "sv_mapRotation_3", "" );
	setDvar( "sv_mapRotation_4", "" );
	setDvar( "sv_mapRotation_5", "" );
	setDvar( "sv_mapRotation_6", "" );
	setDvar( "sv_mapRotation_7", "" );
	setDvar( "sv_mapRotation_8", "" );
	setDvar( "sv_mapRotation_9", "" );
}
