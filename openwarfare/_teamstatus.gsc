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

#include maps\mp\_utility;
#include common_scripts\utility;
#include openwarfare\_utils;
#include maps\mp\gametypes\_hud_util;


init()
{
	// Get the main module's dvar
	level.scr_show_team_status = getdvarx( "scr_show_team_status", "int", 0, 0, 2 );

	// If show team status is not enabled then there's nothing else to do here
	if ( level.scr_show_team_status == 0 || !level.teamBased )
		return;

	// Precache independent resources for MS2 Freezetag Feature
	precacheStatusIcon("hud_freeze");
	precacheShader("hud_freeze");

	level thread onPrematchOver();
	level thread onGameEnded();
}


onPrematchOver()
{
	self waittill( "prematch_over" );
	createHudElements();
	self startTeamStatusRefresh();
}

onGameEnded()
{
	self waittill("game_ended");
	wait (2.0);
	destroyHudElements();
}

destroyHudElements()
{
	// Destroy all the HUD elements for freezetag feature
	if ( isdefined(level.scr_gameplay_ftag) && level.scr_gameplay_ftag )
		destroyHudElementsFreezetag();

	// Destroy all the HUD elements
	game["teamStatusIconAllies"] destroy();
	game["teamStatusTextAlliesAlive"] destroy();
	game["teamStatusIconAxis"] destroy();
	game["teamStatusTextAxisAlive"] destroy();

	if ( level.scr_show_team_status == 2 ) {
		game["teamStatusIconAlliesForAxis"] destroy();
		game["teamStatusTextAlliesAliveForAxis"] destroy();
		game["teamStatusIconAxisForAllies"] destroy();
		game["teamStatusTextAxisAliveForAllies"] destroy();
	}

	return;
}

createHudElements()
{
	// Create the elements to show freezetag feature
	if ( isdefined(level.scr_gameplay_ftag) && level.scr_gameplay_ftag && ( !isDefined( level.inOvertime ) || !level.inOvertime ) )
		createHudElementsFreezetag();

	// Create the elements to show the allies team status
	game["teamStatusIconAllies"] = createServerIcon( game["icons"]["allies"], 32, 32, "allies" );
	game["teamStatusIconAllies"].archived = true;
	game["teamStatusIconAllies"].hideWhenInMenu = true;
	game["teamStatusIconAllies"].alignX = "center";
	game["teamStatusIconAllies"].alignY = "top";
	game["teamStatusIconAllies"].sort = -3;
	game["teamStatusIconAllies"].alpha = 0.9;

	game["teamStatusTextAlliesAlive"] = createServerFontString( "objective", 1.5, "allies" );
	game["teamStatusTextAlliesAlive"].archived = true;
	game["teamStatusTextAlliesAlive"].hideWhenInMenu = true;
	game["teamStatusTextAlliesAlive"].alignX = "left";
	game["teamStatusTextAlliesAlive"].alignY = "top";
	game["teamStatusTextAlliesAlive"].sort = -1;
	game["teamStatusTextAlliesAlive"] maps\mp\gametypes\_hud::fontPulseInit();

	// Create the elements to show the allies team status
	game["teamStatusIconAxis"] = createServerIcon( game["icons"]["axis"], 32, 32, "axis" );
	game["teamStatusIconAxis"].archived = true;
	game["teamStatusIconAxis"].hideWhenInMenu = true;
	game["teamStatusIconAxis"].alignX = "center";
	game["teamStatusIconAxis"].alignY = "top";
	game["teamStatusIconAxis"].sort = -3;
	game["teamStatusIconAxis"].alpha = 0.9;

	game["teamStatusTextAxisAlive"] = createServerFontString( "objective", 1.5, "axis" );
	game["teamStatusTextAxisAlive"].archived = true;
	game["teamStatusTextAxisAlive"].hideWhenInMenu = true;
	game["teamStatusTextAxisAlive"].alignX = "left";
	game["teamStatusTextAxisAlive"].alignY = "top";
	game["teamStatusTextAxisAlive"].sort = -1;
	game["teamStatusTextAxisAlive"] maps\mp\gametypes\_hud::fontPulseInit();

	if ( !level.hardcoreMode || level.scr_hud_hardcore_show_minimap ) {
		game["teamStatusIconAllies"].horzAlign = "left";
		game["teamStatusIconAllies"].vertAlign = "top";
		game["teamStatusIconAllies"].alignX = "left";
		game["teamStatusIconAllies"].x = 116;
		game["teamStatusIconAllies"].y = 22;
		game["teamStatusTextAlliesAlive"].horzAlign = "left";
		game["teamStatusTextAlliesAlive"].vertAlign = "top";
		game["teamStatusTextAlliesAlive"].x = 118;
		game["teamStatusTextAlliesAlive"].y = 37;

		game["teamStatusIconAxis"].horzAlign = "left";
		game["teamStatusIconAxis"].vertAlign = "top";
		game["teamStatusIconAxis"].alignX = "left";
		game["teamStatusIconAxis"].x = 116;
		game["teamStatusIconAxis"].y = 22;
		game["teamStatusTextAxisAlive"].horzAlign = "left";
		game["teamStatusTextAxisAlive"].vertAlign = "top";
		game["teamStatusTextAxisAlive"].x = 118;
		game["teamStatusTextAxisAlive"].y = 37;

	} else {
		game["teamStatusIconAllies"].horzAlign = "right";
		game["teamStatusIconAllies"].vertAlign = "bottom";
		game["teamStatusIconAllies"].x = -58;
		game["teamStatusIconAllies"].y = -85;
		game["teamStatusTextAlliesAlive"].horzAlign = "right";
		game["teamStatusTextAlliesAlive"].vertAlign = "bottom";
		game["teamStatusTextAlliesAlive"].x = -72;
		game["teamStatusTextAlliesAlive"].y = -70;

		game["teamStatusIconAxis"].horzAlign = "right";
		game["teamStatusIconAxis"].vertAlign = "bottom";
		game["teamStatusIconAxis"].x = -58;
		game["teamStatusIconAxis"].y = -85;
		game["teamStatusTextAxisAlive"].horzAlign = "right";
		game["teamStatusTextAxisAlive"].vertAlign = "bottom";
		game["teamStatusTextAxisAlive"].x = -72;
		game["teamStatusTextAxisAlive"].y = -70;

		if ( level.scr_show_team_status == 1) {
			game["teamStatusIconAllies"].x = -28;
			game["teamStatusIconAllies"].y = -85;
			game["teamStatusTextAlliesAlive"].x = -42;
			game["teamStatusTextAlliesAlive"].y = -70;

			game["teamStatusIconAxis"].x = -28;
			game["teamStatusIconAxis"].y = -85;
			game["teamStatusTextAxisAlive"].x = -42;
			game["teamStatusTextAxisAlive"].y = -70;
		}
	}

	if ( level.scr_show_team_status == 2) {
		// Create the elements to show the allies team status
		game["teamStatusIconAlliesForAxis"] = createServerIcon( game["icons"]["allies"], 32, 32, "axis" );
		game["teamStatusIconAlliesForAxis"].archived = true;
		game["teamStatusIconAlliesForAxis"].hideWhenInMenu = true;
		game["teamStatusIconAlliesForAxis"].alignX = "center";
		game["teamStatusIconAlliesForAxis"].alignY = "top";
		game["teamStatusIconAlliesForAxis"].sort = -3;
		game["teamStatusIconAlliesForAxis"].alpha = 0.9;

		game["teamStatusTextAlliesAliveForAxis"] = createServerFontString( "objective", 1.5, "axis" );
		game["teamStatusTextAlliesAliveForAxis"].archived = true;
		game["teamStatusTextAlliesAliveForAxis"].hideWhenInMenu = true;
		game["teamStatusTextAlliesAliveForAxis"].alignX = "left";
		game["teamStatusTextAlliesAliveForAxis"].alignY = "top";
		game["teamStatusTextAlliesAliveForAxis"].sort = -1;
		game["teamStatusTextAlliesAliveForAxis"] maps\mp\gametypes\_hud::fontPulseInit();

		// Create the elements to show the allies team status
		game["teamStatusIconAxisForAllies"] = createServerIcon( game["icons"]["axis"], 32, 32, "allies" );
		game["teamStatusIconAxisForAllies"].archived = true;
		game["teamStatusIconAxisForAllies"].hideWhenInMenu = true;
		game["teamStatusIconAxisForAllies"].alignX = "center";
		game["teamStatusIconAxisForAllies"].alignY = "top";
		game["teamStatusIconAxisForAllies"].sort = -3;
		game["teamStatusIconAxisForAllies"].alpha = 0.9;

		game["teamStatusTextAxisAliveForAllies"] = createServerFontString( "objective", 1.5, "allies" );
		game["teamStatusTextAxisAliveForAllies"].archived = true;
		game["teamStatusTextAxisAliveForAllies"].hideWhenInMenu = true;
		game["teamStatusTextAxisAliveForAllies"].alignX = "left";
		game["teamStatusTextAxisAliveForAllies"].alignY = "top";
		game["teamStatusTextAxisAliveForAllies"].sort = -1;
		game["teamStatusTextAxisAliveForAllies"] maps\mp\gametypes\_hud::fontPulseInit();

		if ( !level.hardcoreMode || level.scr_hud_hardcore_show_minimap ) {
			game["teamStatusIconAlliesForAxis"].horzAlign = "left";
			game["teamStatusIconAlliesForAxis"].vertAlign = "top";
			game["teamStatusIconAlliesForAxis"].alignX = "left";
			game["teamStatusIconAlliesForAxis"].x = 116;
			game["teamStatusIconAlliesForAxis"].y = 58;
			game["teamStatusTextAlliesAliveForAxis"].horzAlign = "left";
			game["teamStatusTextAlliesAliveForAxis"].vertAlign = "top";
			game["teamStatusTextAlliesAliveForAxis"].x = 118;
			game["teamStatusTextAlliesAliveForAxis"].y = 73;

			game["teamStatusIconAxisForAllies"].horzAlign = "left";
			game["teamStatusIconAxisForAllies"].vertAlign = "top";
			game["teamStatusIconAxisForAllies"].alignX = "left";
			game["teamStatusIconAxisForAllies"].x = 116;
			game["teamStatusIconAxisForAllies"].y = 58;
			game["teamStatusTextAxisAliveForAllies"].horzAlign = "left";
			game["teamStatusTextAxisAliveForAllies"].vertAlign = "top";
			game["teamStatusTextAxisAliveForAllies"].x = 118;
			game["teamStatusTextAxisAliveForAllies"].y = 73;
		} else {
			game["teamStatusIconAlliesForAxis"].horzAlign = "right";
			game["teamStatusIconAlliesForAxis"].vertAlign = "bottom";
			game["teamStatusIconAlliesForAxis"].x = -28;
			game["teamStatusIconAlliesForAxis"].y = -85;
			game["teamStatusTextAlliesAliveForAxis"].horzAlign = "right";
			game["teamStatusTextAlliesAliveForAxis"].vertAlign = "bottom";
			game["teamStatusTextAlliesAliveForAxis"].x = -42;
			game["teamStatusTextAlliesAliveForAxis"].y = -70;

			game["teamStatusIconAxisForAllies"].horzAlign = "right";
			game["teamStatusIconAxisForAllies"].vertAlign = "bottom";
			game["teamStatusIconAxisForAllies"].x = -28;
			game["teamStatusIconAxisForAllies"].y = -85;
			game["teamStatusTextAxisAliveForAllies"].horzAlign = "right";
			game["teamStatusTextAxisAliveForAllies"].vertAlign = "bottom";
			game["teamStatusTextAxisAliveForAllies"].x = -42;
			game["teamStatusTextAxisAliveForAllies"].y = -70;
		}
	}

	return;
}


startTeamStatusRefresh()
{
	self endon("game_ended");
	
	previousTeamStatus["allies"] = -1;
	previousTeamStatus["axis"] = -1;	

	for (;;)
	{
		wait (0.1);

		// Initialize counters
		teamStatus["allies"]["alive"] = 0;
		teamStatus["allies"]["dead"] = 0;
		teamStatus["axis"]["alive"] = 0;
		teamStatus["axis"]["dead"] = 0;

		// Cycle through all the players
		for ( index = 0; index < level.players.size; index++ )
		{
			player = level.players[index];

			// Update counters depending on player's team and status
			switch ( player.pers["team"] )
			{
				case "allies":
					if ( isAlive( player ) && ( level.gametype != "ftag" || !player.freezeTag["frozen"] ) && ( !isDefined( player.frozen ) || !player.frozen ) ) {
						teamStatus["allies"]["alive"]++;
					} else {
						teamStatus["allies"]["dead"]++;
					}
					break;
				case "axis":
					if ( isAlive( player ) && ( level.gametype != "ftag" || !player.freezeTag["frozen"] ) && ( !isDefined( player.frozen ) || !player.frozen ) ) {
						teamStatus["axis"]["alive"]++;
					} else {
						teamStatus["axis"]["dead"]++;
					}
					break;
			}
		}

		// Update the HUD elements
		if ( previousTeamStatus["allies"] != teamStatus["allies"]["alive"] ) {
			previousTeamStatus["allies"] = teamStatus["allies"]["alive"];
			
			if ( teamStatus["allies"]["alive"] > 0 ) {
				game["teamStatusTextAlliesAlive"].color = ( 0.07, 0.69, 0.26 );
			} else {
				game["teamStatusTextAlliesAlive"].color = ( 0.694, 0.220, 0.114 );
			}
			game["teamStatusTextAlliesAlive"] setValue( teamStatus["allies"]["alive"] );
			game["teamStatusTextAlliesAlive"] thread maps\mp\gametypes\_hud::fontPulse( level );

			// Create the elements to show freezetag feature
			if ( isdefined(level.scr_gameplay_ftag) && level.scr_gameplay_ftag && ( !isDefined( level.inOvertime ) || !level.inOvertime ) ) {
				game["teamStatusTextAlliesAliveFrozen"] setValue( teamStatus["allies"]["dead"] );
				game["teamStatusTextAlliesAliveFrozen"] thread maps\mp\gametypes\_hud::fontPulse( level );
			}

			if ( level.scr_show_team_status == 2 ) {
				if ( teamStatus["allies"]["alive"] > 0 ) {
					game["teamStatusTextAlliesAliveForAxis"].color = ( 0.07, 0.69, 0.26 );
				} else {
					game["teamStatusTextAlliesAliveForAxis"].color = ( 0.694, 0.220, 0.114 );
				}			
				game["teamStatusTextAlliesAliveForAxis"] setValue( teamStatus["allies"]["alive"] );
				game["teamStatusTextAlliesAliveForAxis"] thread maps\mp\gametypes\_hud::fontPulse( level );

				// Create the elements to show freezetag feature
				if ( isdefined(level.scr_gameplay_ftag) && level.scr_gameplay_ftag && ( !isDefined( level.inOvertime ) || !level.inOvertime ) ) {
					game["teamStatusTextAlliesAliveForAxisFrozen"] setValue( teamStatus["allies"]["dead"] );
					game["teamStatusTextAlliesAliveForAxisFrozen"] thread maps\mp\gametypes\_hud::fontPulse( level );
				}
			}			
		}
		
		if ( previousTeamStatus["axis"] != teamStatus["axis"]["alive"] ) {
			previousTeamStatus["axis"] = teamStatus["axis"]["alive"];

			if ( teamStatus["axis"]["alive"] > 0 ) {
				game["teamStatusTextAxisAlive"].color = ( 0.07, 0.69, 0.26 );
			} else {
				game["teamStatusTextAxisAlive"].color = ( 0.694, 0.220, 0.114 );
			}
			game["teamStatusTextAxisAlive"] setValue( teamStatus["axis"]["alive"] );
			game["teamStatusTextAxisAlive"] thread maps\mp\gametypes\_hud::fontPulse( level );

			// Create the elements to show freezetag feature
			if ( isdefined(level.scr_gameplay_ftag) && level.scr_gameplay_ftag && ( !isDefined( level.inOvertime ) || !level.inOvertime ) ) {
				game["teamStatusTextAxisAliveFrozen"] setValue( teamStatus["axis"]["dead"] );
				game["teamStatusTextAxisAliveFrozen"] thread maps\mp\gametypes\_hud::fontPulse( level );
			}
		
			if ( level.scr_show_team_status == 2 ) {
				if ( teamStatus["axis"]["alive"] > 0 ) {
					game["teamStatusTextAxisAliveForAllies"].color = ( 0.07, 0.69, 0.26 );
				} else {
					game["teamStatusTextAxisAliveForAllies"].color = ( 0.694, 0.220, 0.114 );
				}
				game["teamStatusTextAxisAliveForAllies"] setValue( teamStatus["axis"]["alive"] );
				game["teamStatusTextAxisAliveForAllies"] thread maps\mp\gametypes\_hud::fontPulse( level );

				// Create the elements to show freezetag feature
				if ( isdefined(level.scr_gameplay_ftag) && level.scr_gameplay_ftag && ( !isDefined( level.inOvertime ) || !level.inOvertime ) ) {
					game["teamStatusTextAxisAliveForAlliesFrozen"] setValue( teamStatus["axis"]["dead"] );
					game["teamStatusTextAxisAliveForAlliesFrozen"] thread maps\mp\gametypes\_hud::fontPulse( level );
				}
			}
		}
	}
}

destroyHudElementsFreezetag()
{
	// If we removed these in OT then nothing to do here
	if( !isDefined( game["teamStatusIconAlliesFrozen"] ) )
		return;

	// Destroy all the HUD elements
	game["teamStatusIconAlliesFrozen"] destroy();
	game["teamStatusTextAlliesAliveFrozen"] destroy();
	game["teamStatusIconAxisFrozen"] destroy();
	game["teamStatusTextAxisAliveFrozen"] destroy();

	if ( level.scr_show_team_status == 2 ) {
		game["teamStatusIconAlliesForAxisFrozen"] destroy();
		game["teamStatusTextAlliesAliveForAxisFrozen"] destroy();
		game["teamStatusIconAxisForAlliesFrozen"] destroy();
		game["teamStatusTextAxisAliveForAlliesFrozen"] destroy();
	}

	return;
}

createHudElementsFreezetag()
{
	// Create the elements to show the allies team status
	game["teamStatusIconAlliesFrozen"] = createServerIcon( "hud_freeze", 32, 32, "allies" );
	game["teamStatusIconAlliesFrozen"].archived = true;
	game["teamStatusIconAlliesFrozen"].hideWhenInMenu = true;
	game["teamStatusIconAlliesFrozen"].alignX = "center";
	game["teamStatusIconAlliesFrozen"].alignY = "top";
	game["teamStatusIconAlliesFrozen"].sort = -3;
	game["teamStatusIconAlliesFrozen"].alpha = 0.9;

	game["teamStatusTextAlliesAliveFrozen"] = createServerFontString( "objective", 1.5, "allies" );
	game["teamStatusTextAlliesAliveFrozen"].archived = true;
	game["teamStatusTextAlliesAliveFrozen"].hideWhenInMenu = true;
	game["teamStatusTextAlliesAliveFrozen"].alignX = "left";
	game["teamStatusTextAlliesAliveFrozen"].alignY = "top";
	game["teamStatusTextAlliesAliveFrozen"].sort = -1;
	game["teamStatusTextAlliesAliveFrozen"] maps\mp\gametypes\_hud::fontPulseInit();

	// Create the elements to show the allies team status
	game["teamStatusIconAxisFrozen"] = createServerIcon( "hud_freeze", 32, 32, "axis" );
	game["teamStatusIconAxisFrozen"].archived = true;
	game["teamStatusIconAxisFrozen"].hideWhenInMenu = true;
	game["teamStatusIconAxisFrozen"].alignX = "center";
	game["teamStatusIconAxisFrozen"].alignY = "top";
	game["teamStatusIconAxisFrozen"].sort = -3;
	game["teamStatusIconAxisFrozen"].alpha = 0.9;

	game["teamStatusTextAxisAliveFrozen"] = createServerFontString( "objective", 1.5, "axis" );
	game["teamStatusTextAxisAliveFrozen"].archived = true;
	game["teamStatusTextAxisAliveFrozen"].hideWhenInMenu = true;
	game["teamStatusTextAxisAliveFrozen"].alignX = "left";
	game["teamStatusTextAxisAliveFrozen"].alignY = "top";
	game["teamStatusTextAxisAliveFrozen"].sort = -1;
	game["teamStatusTextAxisAliveFrozen"] maps\mp\gametypes\_hud::fontPulseInit();

	if ( !level.hardcoreMode || level.scr_hud_hardcore_show_minimap ) {
		game["teamStatusIconAlliesFrozen"].horzAlign = "left";
		game["teamStatusIconAlliesFrozen"].vertAlign = "top";
		game["teamStatusIconAlliesFrozen"].alignX = "left";
		game["teamStatusIconAlliesFrozen"].x = 156;
		game["teamStatusIconAlliesFrozen"].y = 22;
		game["teamStatusTextAlliesAliveFrozen"].horzAlign = "left";
		game["teamStatusTextAlliesAliveFrozen"].vertAlign = "top";
		game["teamStatusTextAlliesAliveFrozen"].x = 158;
		game["teamStatusTextAlliesAliveFrozen"].y = 37;

		game["teamStatusIconAxisFrozen"].horzAlign = "left";
		game["teamStatusIconAxisFrozen"].vertAlign = "top";
		game["teamStatusIconAxisFrozen"].alignX = "left";
		game["teamStatusIconAxisFrozen"].x = 156;
		game["teamStatusIconAxisFrozen"].y = 22;
		game["teamStatusTextAxisAliveFrozen"].horzAlign = "left";
		game["teamStatusTextAxisAliveFrozen"].vertAlign = "top";
		game["teamStatusTextAxisAliveFrozen"].x = 158;
		game["teamStatusTextAxisAliveFrozen"].y = 37;

	} else {
		game["teamStatusIconAlliesFrozen"].horzAlign = "right";
		game["teamStatusIconAlliesFrozen"].vertAlign = "bottom";
		game["teamStatusIconAlliesFrozen"].x = -18;
		game["teamStatusIconAlliesFrozen"].y = -85;
		game["teamStatusTextAlliesAliveFrozen"].horzAlign = "right";
		game["teamStatusTextAlliesAliveFrozen"].vertAlign = "bottom";
		game["teamStatusTextAlliesAliveFrozen"].x = -32;
		game["teamStatusTextAlliesAliveFrozen"].y = -70;

		game["teamStatusIconAxisFrozen"].horzAlign = "right";
		game["teamStatusIconAxisFrozen"].vertAlign = "bottom";
		game["teamStatusIconAxisFrozen"].x = -18;
		game["teamStatusIconAxisFrozen"].y = -85;
		game["teamStatusTextAxisAliveFrozen"].horzAlign = "right";
		game["teamStatusTextAxisAliveFrozen"].vertAlign = "bottom";
		game["teamStatusTextAxisAliveFrozen"].x = -32;
		game["teamStatusTextAxisAliveFrozen"].y = -70;

		if ( level.scr_show_team_status == 1) {
			game["teamStatusIconAlliesFrozen"].x = 12;
			game["teamStatusIconAlliesFrozen"].y = -85;
			game["teamStatusTextAlliesAliveFrozen"].x = -2;
			game["teamStatusTextAlliesAliveFrozen"].y = -70;

			game["teamStatusIconAxisFrozen"].x = 12;
			game["teamStatusIconAxisFrozen"].y = -85;
			game["teamStatusTextAxisAliveFrozen"].x = -2;
			game["teamStatusTextAxisAliveFrozen"].y = -70;
		}
	}

	if ( level.scr_show_team_status == 2) {
		// Create the elements to show the allies team status
		game["teamStatusIconAlliesForAxisFrozen"] = createServerIcon( "hud_freeze", 32, 32, "axis" );
		game["teamStatusIconAlliesForAxisFrozen"].archived = true;
		game["teamStatusIconAlliesForAxisFrozen"].hideWhenInMenu = true;
		game["teamStatusIconAlliesForAxisFrozen"].alignX = "center";
		game["teamStatusIconAlliesForAxisFrozen"].alignY = "top";
		game["teamStatusIconAlliesForAxisFrozen"].sort = -3;
		game["teamStatusIconAlliesForAxisFrozen"].alpha = 0.9;

		game["teamStatusTextAlliesAliveForAxisFrozen"] = createServerFontString( "objective", 1.5, "axis" );
		game["teamStatusTextAlliesAliveForAxisFrozen"].archived = true;
		game["teamStatusTextAlliesAliveForAxisFrozen"].hideWhenInMenu = true;
		game["teamStatusTextAlliesAliveForAxisFrozen"].alignX = "left";
		game["teamStatusTextAlliesAliveForAxisFrozen"].alignY = "top";
		game["teamStatusTextAlliesAliveForAxisFrozen"].sort = -1;
		game["teamStatusTextAlliesAliveForAxisFrozen"] maps\mp\gametypes\_hud::fontPulseInit();

		// Create the elements to show the allies team status
		game["teamStatusIconAxisForAlliesFrozen"] = createServerIcon( "hud_freeze", 32, 32, "allies" );
		game["teamStatusIconAxisForAlliesFrozen"].archived = true;
		game["teamStatusIconAxisForAlliesFrozen"].hideWhenInMenu = true;
		game["teamStatusIconAxisForAlliesFrozen"].alignX = "center";
		game["teamStatusIconAxisForAlliesFrozen"].alignY = "top";
		game["teamStatusIconAxisForAlliesFrozen"].sort = -3;
		game["teamStatusIconAxisForAlliesFrozen"].alpha = 0.9;

		game["teamStatusTextAxisAliveForAlliesFrozen"] = createServerFontString( "objective", 1.5, "allies" );
		game["teamStatusTextAxisAliveForAlliesFrozen"].archived = true;
		game["teamStatusTextAxisAliveForAlliesFrozen"].hideWhenInMenu = true;
		game["teamStatusTextAxisAliveForAlliesFrozen"].alignX = "left";
		game["teamStatusTextAxisAliveForAlliesFrozen"].alignY = "top";
		game["teamStatusTextAxisAliveForAlliesFrozen"].sort = -1;
		game["teamStatusTextAxisAliveForAlliesFrozen"] maps\mp\gametypes\_hud::fontPulseInit();

		if ( !level.hardcoreMode || level.scr_hud_hardcore_show_minimap ) {
			game["teamStatusIconAlliesForAxisFrozen"].horzAlign = "left";
			game["teamStatusIconAlliesForAxisFrozen"].vertAlign = "top";
			game["teamStatusIconAlliesForAxisFrozen"].alignX = "left";
			game["teamStatusIconAlliesForAxisFrozen"].x = 156;
			game["teamStatusIconAlliesForAxisFrozen"].y = 58;
			game["teamStatusTextAlliesAliveForAxisFrozen"].horzAlign = "left";
			game["teamStatusTextAlliesAliveForAxisFrozen"].vertAlign = "top";
			game["teamStatusTextAlliesAliveForAxisFrozen"].x = 158;
			game["teamStatusTextAlliesAliveForAxisFrozen"].y = 73;

			game["teamStatusIconAxisForAlliesFrozen"].horzAlign = "left";
			game["teamStatusIconAxisForAlliesFrozen"].vertAlign = "top";
			game["teamStatusIconAxisForAlliesFrozen"].alignX = "left";
			game["teamStatusIconAxisForAlliesFrozen"].x = 156;
			game["teamStatusIconAxisForAlliesFrozen"].y = 58;
			game["teamStatusTextAxisAliveForAlliesFrozen"].horzAlign = "left";
			game["teamStatusTextAxisAliveForAlliesFrozen"].vertAlign = "top";
			game["teamStatusTextAxisAliveForAlliesFrozen"].x = 158;
			game["teamStatusTextAxisAliveForAlliesFrozen"].y = 73;
		} else {
			game["teamStatusIconAlliesForAxisFrozen"].horzAlign = "right";
			game["teamStatusIconAlliesForAxisFrozen"].vertAlign = "bottom";
			game["teamStatusIconAlliesForAxisFrozen"].x = 12;
			game["teamStatusIconAlliesForAxisFrozen"].y = -85;
			game["teamStatusTextAlliesAliveForAxisFrozen"].horzAlign = "right";
			game["teamStatusTextAlliesAliveForAxisFrozen"].vertAlign = "bottom";
			game["teamStatusTextAlliesAliveForAxisFrozen"].x = -2;
			game["teamStatusTextAlliesAliveForAxisFrozen"].y = -70;

			game["teamStatusIconAxisForAlliesFrozen"].horzAlign = "right";
			game["teamStatusIconAxisForAlliesFrozen"].vertAlign = "bottom";
			game["teamStatusIconAxisForAlliesFrozen"].x = 12;
			game["teamStatusIconAxisForAlliesFrozen"].y = -85;
			game["teamStatusTextAxisAliveForAlliesFrozen"].horzAlign = "right";
			game["teamStatusTextAxisAliveForAlliesFrozen"].vertAlign = "bottom";
			game["teamStatusTextAxisAliveForAlliesFrozen"].x = -2;
			game["teamStatusTextAxisAliveForAlliesFrozen"].y = -70;
		}
	}

	return;
}
