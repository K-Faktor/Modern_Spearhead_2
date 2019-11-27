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
	setDvar( "scr_league_ruleset", "[G13]Mixed" );
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
	setDvar( "sv_mapRotation", "gametype koth map mp_crash gametype koth map mp_bloc" );
	setDvar( "sv_mapRotation_1", "gametype ctf map mp_countdown gametype ctf map mp_bog gametype ctf map mp_vacant" );
	setDvar( "sv_mapRotation_2", "gametype ftag map mp_citystreets gametype ftag map mp_strike gametype ftag map mp_pipeline gametype ftag map mp_cargoship gametype ftag map mp_shipment" );
	setDvar( "sv_mapRotation_3", "gametype dom map mp_crossfire gametype dom map mp_showdown gametype dom map mp_carentan" );
	setDvar( "sv_mapRotation_4", "gametype sab map mp_backlot gametype sab map mp_creek gametype sab map mp_broadcast" );
	setDvar( "sv_mapRotation_5", "gametype ch map mp_overgrown gametype ch map mp_convoy gametype ch map mp_farm" );
	setDvar( "sv_mapRotation_6", "" );
	setDvar( "sv_mapRotation_7", "" );
	setDvar( "sv_mapRotation_8", "" );
	setDvar( "sv_mapRotation_9", "" );
}
