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
	setDvar( "scr_league_ruleset", "[G13]Freezetag Custom Maps" );
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
	setDvar( "sv_mapRotation_2", "map mp_slaughterhouse map mp_burg map mp_scrap map mp_sharqi_b1 map mp_bacalao map mp_insurgency map mp_cc map mp_pic map mp_apesgorod map mp_forlorn" );
	setDvar( "sv_mapRotation_3", "map mp_ksfact map mp_simpsons map mp_argel map mp_cod4malta map mp_bridge map mp_v2 map mp_mohaa_dv map mp_moh_sfrance_b1" );
	setDvar( "sv_mapRotation_4", "map mp_mtl_the_rock map mp_shipment2 map mp_city map mp_subway map mp_vertical map mp_village_s map mp_roof map mp_wolfsquare map mp_metro map mp_dam" );
	setDvar( "sv_mapRotation_5", "map mp_highrise map mp_aerodrome map mp_dust2_classic map mp_jor1 map mp_outpost map mp_aquadukt map mp_blackrock map mp_lut_gholein map mp_kamakura" );
	setDvar( "sv_mapRotation_6", "map mp_aosta_valley map mp_docks map mp_pass map mp_ravine map mp_steamlab map mp_winters_brecourt map mp_communique map mp_lgc_attic" );
	setDvar( "sv_mapRotation_7", "map mp_warehouse map mp_toybox4 map mp_isla_beta1 map mp_inferno map mp_stadtrand3 map mp_killhouse map mp_pacmaze map mp_eerier map mp_fubar map mp_doneck" );
	setDvar( "sv_mapRotation_8", "map mp_matroska map mp_ruins map mp_arbor_storm map mp_cuf_gutter map mp_ava_asylum map mp_usl_sgc map mp_remagen map mp_equestriana" );
	setDvar( "sv_mapRotation_9", "map mp_stalingrad2 map mp_chicago map mp_ctan map mp_i2 map mp_ic_cod map mp_oldtown map mp_spbase map mp_tchernobyl map mp_meanstreet2" );
}
