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
	if ( !level.teamBased ) {
		level.scr_gameplay_ftag = 0;

		setdvar( "ui_gameplay_ftag", level.scr_gameplay_ftag );
		makeDvarServerInfo( "ui_gameplay_ftag" );
		return;
	}

	if( level.gametype != "ch" && level.gametype != "ctf" && level.gametype != "dom" && level.gametype != "ftag" && level.gametype != "koth" && level.gametype != "sab" && level.gametype != "war" ) {
		level.scr_gameplay_ftag = 0;

		setdvar( "ui_gameplay_ftag", level.scr_gameplay_ftag );
		makeDvarServerInfo( "ui_gameplay_ftag" );
		return;
	}

	if ( !isDefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	level.onTimeLimit = ::onTimeLimit;
	level.onPlayerFrozen = ::onPlayerFrozen;
	level.onStartFtagGame = ::onStartFtagGame;
	level.onSpawnFtagPlayer = ::onSpawnFtagPlayer;
	level.onDeadEvent = ::onDeadEvent;

	if ( level.gametype == "war" || level.gametype == "ftag" )
		level.onSpawnPlayer = ::onSpawnPlayer;

	level.ftagactive = true;
	level.overrideTeamScore = true;
	level.scr_game_spawn_type = getdvarx("scr_game_spawn_type","int",0,0,4);

	// Force some server variables
	setDvar( "scr_" + level.gametype + "_playerrespawndelay", "-1" );
	setDvar( "scr_" + level.gametype + "_waverespawndelay", "0" );
	setDvar( "scr_" + level.gametype + "_numlives", "0" );
	setDvar( "scr_healthsystem_show_healthbar", "1" );

	// Add more detail to the type of game being played
	if ( level.gametype != "ftag" ) {
		gametype = "freezetag;";
		gametype += game["dialog"]["gametype"];
		game["dialog"]["gametype"] = gametype;
	}
}

onPrecacheFtag()
{
	// Initialize an array to keep all the assets we'll be using
	game[level.gameType] = [];
	
	// Allies resources
	game[level.gameType]["prop_iceberg_allies"] = "iceberg";
	game[level.gameType]["hud_frozen_allies"] = "hud_frozen";
	game[level.gameType]["hud_counter_allies"] = ( 0.3, 1, 1 );
	game[level.gameType]["defrost_beam_allies"] = loadFx( "freezetag/defrostbeam" );
	precacheModel( game[level.gameType]["prop_iceberg_allies"] );
	precacheShader( game[level.gameType]["hud_frozen_allies"] );
		
	// Axis resources
	game[level.gameType]["prop_iceberg_axis"] = "icebergred";
	game[level.gameType]["hud_frozen_axis"] = "hud_fznred";
	game[level.gameType]["hud_counter_axis"] = ( 1, 0.22, 0.22 );
	game[level.gameType]["defrost_beam_axis"] = loadFx( "freezetag/defrostbeamred" );
	precacheModel( game[level.gameType]["prop_iceberg_axis"] );
	precacheShader( game[level.gameType]["hud_frozen_axis"] );

	// If show team status is not enabled then precache icons
	if ( level.scr_show_team_status == 0 || !level.teamBased ) {
		precacheStatusIcon("hud_freeze");
		precacheShader("hud_freeze");
	}

	precacheString( &"MS2_FTAG_MELT_DISTANCE" );
	precacheString( &"MS2_FTAG_FROZE" );
	precacheString( &"MS2_FTAG_DEFROSTING" );
	precacheString( &"MS2_FTAG_DEFROSTED" );
	precacheString( &"MS2_FTAG_DEFROSTED_UNKNOWN" );
	precacheString( &"MS2_FTAG_AUTO_DEFROSTED" );
	precacheString( &"MS2_FTAG_HUD_POINTS" );
	precacheString( &"MS2_FTAG_HUD_DEFROSTEDBY" );
	precacheString( &"MS2_FTAG_HUD_AUTO_DEFROSTED" );
	precacheString( &"MS2_FTAG_HUD_FROZENBY" );
	precacheString( &"MS2_FTAG_HUD_YOUFROZE" );
	precacheString( &"MS2_FTAG_HUD_YOUFROZE_SELF" );
	precacheString( &"MS2_FTAG_HUD_FROZE_HIMSELF" );

	game["strings"]["ftag_tie"] = &"MS2_FTAG_MATCH_TIE";

	switch ( game["allies"] )
	{
		case "sas":
			game["strings"]["allies_frozen"] = &"MS2_FTAG_SAS_FROZEN";
			break;
			
		case "marines":
		default:
			game["strings"]["allies_frozen"] = &"MS2_FTAG_MARINES_FROZEN";
			break;
	}
	
	switch ( game["axis"] )
	{
		case "russian":
			game["strings"]["axis_frozen"] = &"MS2_FTAG_SPETSNAZ_FROZEN";
			break;
				
		case "arab":
		case "opfor":
		default:
			game["strings"]["axis_frozen"] = &"MS2_FTAG_OPFOR_FROZEN";
			break;
	}

	// Check if we should use custom content or not
	if ( level.scr_custom_teams_enable == 1 ) {
		game["strings"]["allies_eliminated"] = level.scr_custom_allies_name + " " + level.scr_custom_teams_strings[5];
		game["strings"]["axis_eliminated"] = level.scr_custom_axis_name + " " + level.scr_custom_teams_strings[5];
	}

	level.defrostdist = getdvarx("scr_ftag_defrostmaxrange","int",50,1,1000);
	level.defrosttime = getdvarx("scr_ftag_defrosttime","int",15,5,100) / 100;
	level.defrostmode = getdvarx("scr_ftag_defrostmode","int",0,0,2);

	level.defrostrespawn = getdvarx("scr_ftag_defrostrespawn","int",1,0,1);
	level.autodefrost = getdvarx("scr_ftag_autodefrost","int",0,0,120);

	level.ftag_sd_spec = getdvarx("scr_ftag_sd_spec","int",1,0,1);
	level.ftag_sd_time = getdvarx("scr_ftag_sd_time","int",0,0,600);
	level.scr_ftag_rotate_ann = getdvarx("scr_ftag_rotate_ann","int",1,0,1);
	level.scr_ftag_rotate_angle = getdvarx("scr_ftag_rotate_angle","int",1,1,180);
	level.scr_ftag_unfreeze_button = getdvarx( "scr_ftag_unfreeze_button", "string", "use" );
	level.scr_ftag_showdefrostbeam = getdvarx("scr_ftag_showdefrostbeam","int",0,0,1);
	level.scr_ftag_showcentermessage = getdvarx("scr_ftag_showcentermessage","int",1,0,1);
	level.scr_ftag_showstatusmessage = getdvarx("scr_ftag_showstatusmessage","int",1,0,1);

	level.scr_autodefrost = getdvarx("scr_" + level.gametype + "_autodefrost","int",0,0,60);
	level.scr_suddendeath_show_enemies = getdvarx( "scr_" + level.gametype + "_suddendeath_show_enemies", "int", 1, 0, 1 );
	level.scr_ftag_wintype = getdvarx( "scr_ftag_wintype", "int", 0, 0, 1 );

	// Force win type if playing freezetag
	if ( level.gametype == "war" || level.gametype == "ftag" )
		level.scr_ftag_wintype = 1;

	level.thismap = toLower( getDvar( "mapname" ) );
	level.spawn_type_map = getdvarx("scr_spawn_type_" + level.thismap,"int",0,0,4);

	level.fx_defrostmelt = loadFx("freezetag/defrostmelt");
	level.barwidth = 80;
	level.barheight = 3;
}

onStartFtagGame()
{
	if ( level.gametype == "war" || level.gametype == "ftag" ) {
		level.spawnMins = ( 0, 0, 0 );
		level.spawnMaxs = ( 0, 0, 0 );

		level.spawn_axis = getentarray("mp_sab_spawn_axis", "classname");
		level.spawn_allies = getentarray("mp_sab_spawn_allies", "classname");
		level.spawn_axis_start = getentarray("mp_sab_spawn_axis_start", "classname");
		level.spawn_allies_start = getentarray("mp_sab_spawn_allies_start", "classname");

		if ( !level.spawn_axis.size || !level.spawn_allies.size || !level.spawn_axis_start.size || !level.spawn_allies_start.size )
		{
			level.spawn_axis = getentarray("mp_tdm_spawn_axis", "classname");
			level.spawn_allies = getentarray("mp_tdm_spawn_allies", "classname");
			level.spawn_axis_start = getentarray("mp_tdm_spawn_axis_start", "classname");
			level.spawn_allies_start = getentarray("mp_tdm_spawn_allies_start", "classname");

			maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_allies_start" );
			maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_axis_start" );
			maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
			maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
		} else {
			maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_sab_spawn_allies_start" );
			maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_sab_spawn_axis_start" );
			maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_sab_spawn_allies" );
			maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_sab_spawn_axis" );
		}

		level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
		setMapCenter( level.mapCenter );
	}

	level.defrostpoint = maps\mp\gametypes\_rank::getScoreInfoValue( "defrost" );
	level.displayRoundEndText = true;
	level.inOvertime = false;

	level thread onPrecacheFtag();
	level thread onPlayerConnect();
	level thread monitorFrozenPlayerScore();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);

		// Set some varibles
		player.frozen = false;
		player.isMelting = false;

		player thread onPlayerDisconnect();
		player thread onPlayerSpectate();
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		if ( isdefined(self.frozen) && self.frozen && self.pers["team"] != "spectator" )
			self.statusicon = "hud_freeze";
	}
}

onPlayerSpectate()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_spectators");

		if(isDefined(self.frozen) && self.frozen)
			self thread RemoveIceItems( self getEntityNumber() );
	}
}

onPlayerDisconnect()
{
	myEntityNumber = self getEntityNumber();
	self waittill("disconnect");

	if(isDefined(self.frozen) && self.frozen)
		self thread RemoveIceItems( myEntityNumber );
}

onSpawnPlayer()
{
	self endon("disconnect");

	// Check which spawn points should be used
	if ( game["switchedsides"] ) {
		spawnTeam = level.otherTeam[ self.pers["team"] ];
	} else {
		spawnTeam =  self.pers["team"];
	}
	
	self.usingObj = undefined;
	self.isTouchingObject = undefined;

	if ( level.spawn_type_map <= 4 && level.spawn_type_map != 0 )
		level.scr_game_spawn_type = level.spawn_type_map;

	// Set Spawn Points From DVar, 0 = Disabled(default), 1 = Team End, 2 = Near Team, 3 = Scattered, 4 = Random
	if ( level.scr_game_spawn_type == 2 ) {
		if (spawnteam == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_axis);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_allies);
	} else if ( level.scr_game_spawn_type == 3 ) {
		numb = randomInt(2);
		if (numb == 1)
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies);
	} else if ( level.scr_game_spawn_type == 4 ) {
		num = randomInt(3);
		if (num == 2) {
			numb = randomInt(2);
			if (numb == 1)
				spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis);
			else
				spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies);
		} else if (num == 1) {
			if (spawnteam == "axis")
				spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_axis);
			else
				spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_allies);
		} else {
			if (spawnteam == "axis")
				spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis_start);
			else
				spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies_start);
		}
	} else if ( level.useStartSpawns || level.scr_game_spawn_type == 1 ) {
		if (spawnteam == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis_start);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies_start);
	} else {
		if (spawnteam == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_axis);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_allies);
	}

	assert( isDefined(spawnpoint) );
	self spawn(spawnPoint.origin, spawnPoint.angles);
}

onSpawnFtagPlayer()
{
	self endon("disconnect");

	if( isDefined( self.frozen ) && self.frozen && ( !isDefined( self.isMelting ) || !self.isMelting ) ) {
		if ( isdefined( self.freezeorigin ) && isdefined( self.freezeangles ) ) {
			// If player frozen and is in the way of an object or flag, lets move them
			if( isDefined( self.isTouchingObject ) && self.isTouchingObject ) {
				self.freezeorigin += ( RandomIntRange( 30, 50 ), RandomIntRange( 30, 50 ), 0 );
			}
			self spawn(self.freezeorigin, self.freezeangles);	
		}
		self thread freezeme();
	} else if ( !level.defrostrespawn && isdefined( self.freezeorigin ) && isdefined( self.freezeangles ) ) {
		self spawn(self.freezeorigin, self.freezeangles);
		self.frozen = false;
		self.isMelting = false;
		self.health = self.maxhealth;
		self.freezeangles = undefined;
		self.freezeorigin = undefined;
		self.isTouchingObject = undefined;
	} else {
		self.frozen = false;
		self.isMelting = false;
		self.health = self.maxhealth;
		self.freezeangles = undefined;
		self.freezeorigin = undefined;
		self.isTouchingObject = undefined;
	}

	self.defrostmsgx = 25;
	self.defrostmsgy = 425;
	self.isbeingdefrosted = false;
	self.healthgiven = [];
	self.beam = false;

	wait(0.05);

	if ( level.inOvertime )
		self thread SetOvertimeSpec();
}

monitorFrozenPlayerScore()
{
	level endon("game_ended");
	while(1)
	{
		wait 1;
		
		playerCounts = CountPlayersFrozen();
		if( playerCounts["alliesTotal"] < 1 || playerCounts["axisTotal"] < 1)
			continue;

		if( playerCounts["axisTotal"] == playerCounts["axisFrozen"] && playerCounts["alliesTotal"] == playerCounts["alliesFrozen"] )
			[[level.onDeadEvent]]( "all" );
		else if( playerCounts["axisTotal"] == playerCounts["axisFrozen"] )
			[[level.onDeadEvent]]( "axis" );
		else if( playerCounts["alliesTotal"] == playerCounts["alliesFrozen"] )
			[[level.onDeadEvent]]( "allies" );
		else if( ( playerCounts["axisTotal"] - 1 ) == playerCounts["axisFrozen"] )
			[[level.onOneLeftEvent]]( "axis" );
		else if( ( playerCounts["alliesTotal"] -1 ) == playerCounts["alliesFrozen"] )
			[[level.onOneLeftEvent]]( "allies" );
		wait 0.5;
	}
}

onDeadEvent( team )
{
	if ( level.gametype == "sab" && level.bombExploded )
		return;

	// Option to autodefrost for gametypes
	if ( level.scr_autodefrost && !level.inOvertime ) 
	{
		for ( index = 0; index < level.players.size; index++ )
		{
			player = level.players[index];

			if ( player.team == team ) {
				if ( level.scr_ftag_showcentermessage )
					player iprintlnbold( &"MS2_YOU_WILL_DEFROST", level.scr_autodefrost );

				player thread defrostaftertime( level.scr_autodefrost );
			}
		}
	} 
	else if ( team == "all" )
	{
		if ( level.gametype == "sab" && level.bombExploded )
		{
			[[level._setTeamScore]]( level.bombPlantedBy, [[level._getTeamScore]]( level.bombPlantedBy ) + 1 );
			thread maps\mp\gametypes\_globallogic::endGame( level.bombPlantedBy, game["strings"][level.bombPlantedBy+"_mission_accomplished"] );
		}
		else
		{
			// We can't determine a winner if everyone died so we declare a tie
			thread maps\mp\gametypes\_globallogic::endGame( "tie", game["strings"]["round_draw"] );
		}
	}
	else if ( level.gametype == "sab" && level.bombExploded )
	{
		if ( team == level.bombPlantedBy )
		{
			level.plantingTeamDead = true;
			return;
		}

		[[level._setTeamScore]]( level.bombPlantedBy, [[level._getTeamScore]]( level.bombPlantedBy ) + 1 );
		thread maps\mp\gametypes\_globallogic::endGame( level.bombPlantedBy, game["strings"][level.otherTeam[level.bombPlantedBy]+"_eliminated"] );
	}
	else
	{
		[[level._setTeamScore]]( getOtherTeam(team), [[level._getTeamScore]]( getOtherTeam(team) ) + 1 );
		thread maps\mp\gametypes\_globallogic::endGame( getOtherTeam(team), game["strings"][team + "_frozen"] );
	}
}

onPlayerFrozen( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( isDefined( self.frozen ) && self.frozen )
		return;

	self.frozen = true;

	// Make sure the player didn't die by falling or we will freeze him in a hole!
	if ( sMeansOfDeath != "MOD_FALLING" && sMeansOfDeath != "MOD_TRIGGER_HURT" ) {
		self.freezeangles = self.angles;
		self.freezeorigin = self.origin;
	} else {
		self.freezeangles = undefined;
		self.freezeorigin = undefined;
	}

	if( isDefined( self.isPlanting ) && self.isPlanting || isDefined( self.isDefusing ) && self.isDefusing || isDefined( self.isBombCarrier ) && self.isBombCarrier || isDefined( self.isFlagCarrier ) && self.isFlagCarrier || isDefined( self.isTouchingTrigger ) && self.isTouchingTrigger )
		self.isTouchingObject = true;

	if( isDefined( attacker ) && isPlayer( attacker ) && attacker != self ) {
		if ( level.scr_ftag_showcentermessage ) {
			attacker iprintlnbold(&"MS2_FTAG_HUD_YOUFROZE" , self.name);
			// Only show message if OW's extended obituary is off
			if ( level.scr_show_ext_obituaries == 0 ) {
				self iprintlnbold(&"MS2_FTAG_HUD_FROZENBY" , attacker.name);
			}
		}
		// Only show message if OW's extended obituary is off
		if ( level.scr_ftag_showstatusmessage && level.scr_show_ext_obituaries == 0 )
			iPrintln(&"MS2_FTAG_FROZE" , attacker.name , self.name);
	} else {
		if ( level.scr_ftag_showcentermessage )
			self iprintlnbold(&"MS2_FTAG_HUD_YOUFROZE_SELF");
		if ( level.scr_ftag_showstatusmessage && level.scr_show_ext_obituaries == 0 )
			iPrintln(&"MS2_FTAG_HUD_FROZE_HIMSELF" , self.name);
	}
}

freezeme(attacker)
{
	self endon("disconnect");

	self.frozen = true;
	self.isMelting = false;

	// Save the body in case the player disconnects
	myBody = self.body;

	self waittill("spawned_player");					
	self thread disablemyweapons();
	self thread RemoveIceItems( self getEntityNumber() );

	if ( isDefined( myBody ) )
		myBody delete();	

	self.health = 1;

	// Check if we need to update the status icon on the scoreboard
	if ( level.scr_show_player_status == 1 ) {
		self.statusicon = "hud_freeze";
	}

	// Check if we are in overtime and need to disable spawn
	if ( level.inOvertime )
	{ 
		self thread SetOvertimeSpec();
		return;
	}

	while(self isMantling())
		wait 0.05;

	self.freezeangles = self.angles;
	self.freezeorigin = self.origin;

	self.sticker = spawn("script_origin", self.origin);
	self linkto(self.sticker);

	// Create icon in compass
	if ( level.scr_hud_show_2dicons == 1 ) {
		self.objnum = maps\mp\gametypes\_gameobjects::getNextObjID();
		if ( self.objnum != -1 ) {
			objective_add( self.objnum, "active", self.origin );
			objective_icon( self.objnum, "hud_freeze" );
			objective_team( self.objnum, self.pers["team"] );
		} else {
			self.objnum = undefined;
		}
	} else {
		self.objnum = undefined;
	}

	// Create 3D world icon
	if ( level.scr_hud_show_3dicons == 1 ) {
		self.objWorld = newTeamHudElem( self.pers["team"] );		
		origin = self.origin + (0,0,75);
		self.objWorld.name = "frozen_" + self getEntityNumber();
		self.objWorld.x = origin[0];
		self.objWorld.y = origin[1];
		self.objWorld.z = origin[2];
		self.objWorld.baseAlpha = 1.0;
		self.objWorld.isFlashing = false;
		self.objWorld.isShown = true;
		self.objWorld setShader( "hud_freeze", level.objPointSize, level.objPointSize );
		self.objWorld setWayPoint( true, "hud_freeze" );
	} else {
		self.objWorld = undefined;
	}

	// Spawn the iceberg model
	self.ice = spawn("script_model", self.origin + (0,0,-90));
	self.ice setModel( game[level.gameType]["prop_iceberg_" + self.pers["team"] ] );
	self.ice.angles = self.angles + (0,0,180);
	self.ice movez(120,1,0.5,0.5);
	self.ice playSound("frozen");
	self.ice playLoopSound( "icecrack" );

	// Create the HUD element with the frozen effect
	self.hud_freeze = newClientHudElem(self);
	self.hud_freeze.horzAlign = "fullscreen";
	self.hud_freeze.vertAlign = "fullscreen";
	self.hud_freeze.x = 0;
	self.hud_freeze.y = 0;
	self.hud_freeze.sort = 5;
	self.hud_freeze.alpha = 0;
	self.hud_freeze setShader( game[level.gameType]["hud_frozen_" + self.pers["team"] ], 640, 480 );
	self.hud_freeze fadeovertime(2);
	self.hud_freeze.alpha = 0.6;

	wait(1.0);
	self.ice.origin = self.origin + (0,0,30);
	self.ice.alpha = 1;

	// Auto defrost if not enough players
	playerCounts = CountPlayersFrozen();
	if( playerCounts["alliesTotal"] < 1 || playerCounts["axisTotal"] < 1 || level.autodefrost || getdvar( "net_ip" ) == "localhost" && self getEntityNumber() == 0 )
		self thread defrostaftertime( level.autodefrost );

	// Monitor unfreeze attempts by aiming if not mode1
	if( level.defrostmode != 1 )
		self thread waitfordefrostbyaim();

	// Monitor unfreeze attempts by standing if not mode0
	if( level.defrostmode != 0 )
		self thread waitfordefrostbytouch();
}

waitfordefrostbytouch()
{
	self endon("disconnect");
	self endon("death");
	self endon("defrosted");
	inrange = false;

	while(1)
	{
		//while ( self.isbeingdefrosted )
		//	wait (0.05);

		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			player = players[i];

			// Check if the player can defrost
			if ( !isDefined( player ) || !isDefined( player.pers ) || !isPlayer( player ) || player.sessionstate != "playing" )
				continue;

			// Make sure player is on our team and not self or frozen
			if ( player.team != self.team  || player == self || isDefined( player.frozen ) && player.frozen || distance( self.origin, player.origin ) > level.defrostdist )
				continue;

			// Make sure this player is not already defrosting me
			if ( isDefined( player.defrostmsg ) && isDefined( player.defrostmsg[self getEntityNumber()] ) )
				continue;

			self thread defrostme( player, false );
		}
		wait 0.05;
	}
}

waitfordefrostbyaim()
{
	self endon("disconnect");
	self endon("death");
	self endon("defrosted");

	while(1)
	{
		//while ( self.isbeingdefrosted )
		//	wait (0.05);

		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			player = players[i];

			// Check if the player can defrost
			if ( !isDefined( player ) || !isDefined( player.pers ) || !isPlayer( player ) || player.sessionstate != "playing" )
				continue;

			// Make sure player is on our team and not self or frozen
			if ( player.team != self.team  || player == self || isDefined( player.frozen ) && player.frozen )
				continue;

			if( !player ftagButtonPressed() || !player islookingatftag(self) )
				continue;

			// Make sure this player is not already defrosting me
			if ( isDefined( player.defrostmsg ) && isDefined( player.defrostmsg[self getEntityNumber()] ) )
				continue;

			self thread defrostme( player, true );
		}
		wait 0.05;
	}
}

createprogressdisplays( player, myIDnumber )
{
	if ( isDefined( self.defrostingmsg ) )
		self.defrostingmsg destroy();

	self.defrostingmsg = self createFontString( "default", 1.4 );
	self.defrostingmsg.archived = false;
	self.defrostingmsg.hideWhenInMenu = true;
	self.defrostingmsg setPoint( "BOTTOMLEFT", undefined, self.defrostmsgx, -35 );
	self.defrostingmsg.alpha = 1;
	self.defrostingmsg.sort = 1;
	self.defrostingmsg.color = (1,1,1);
	self.defrostingmsg setText(&"MS2_FTAG_DEFROSTING");

	if( isDefined( player.defrostmsg ) ) {
		if( isDefined( player.defrostmsg[myIDnumber] ) )
			player.defrostmsg[myIDnumber] destroy();
	} else {
		player.defrostmsg = [];
	}

	player.defrostmsg[myIDnumber] = newClientHudElem(player);
	player.defrostmsg[myIDnumber].alignX = "left";
	player.defrostmsg[myIDnumber].alignY = "middle";
	player.defrostmsg[myIDnumber].horzAlign = "fullscreen";
	player.defrostmsg[myIDnumber].vertAlign = "fullscreen";
	player.defrostmsg[myIDnumber].x = player.defrostmsgx;
	player.defrostmsg[myIDnumber].y = player.defrostmsgy;
	player.defrostmsg[myIDnumber].alpha = 1;
	player.defrostmsg[myIDnumber].sort = 1;
	player.defrostmsg[myIDnumber].fontscale = 1.4;
	player.defrostmsg[myIDnumber] setText( "^5Now Defrosting ^3" + self.name );

	if( isDefined( player.progressbackground ) ) {
		if( isDefined( player.progressbackground[myIDnumber] ) )
			player.progressbackground[myIDnumber] destroy();
	} else {
		player.progressbackground = [];
	}

	player.progressbackground[myIDnumber] = newClientHudElem(player);
	player.progressbackground[myIDnumber].alignX = "left";
	player.progressbackground[myIDnumber].alignY = "middle";
	player.progressbackground[myIDnumber].horzAlign = "fullscreen";
	player.progressbackground[myIDnumber].vertAlign = "fullscreen";
	player.progressbackground[myIDnumber].x = player.defrostmsgx;
	player.progressbackground[myIDnumber].y = player.defrostmsgy + 15;
	player.progressbackground[myIDnumber].alpha = 0.5;
	player.progressbackground[myIDnumber].sort = 1;
	player.progressbackground[myIDnumber] setShader("black", (level.barwidth + 2), (level.barheight + 2) );

	if( isDefined( player.progressbar ) ) {
		if( isDefined( player.progressbar[myIDnumber] ) )
			player.progressbar[myIDnumber] destroy();
	} else {
		player.progressbar = [];
	}

	player.progressbar[myIDnumber] = newClientHudElem(player);
	player.progressbar[myIDnumber].alignX = "left";
	player.progressbar[myIDnumber].alignY = "middle";
	player.progressbar[myIDnumber].horzAlign = "fullscreen";
	player.progressbar[myIDnumber].vertAlign = "fullscreen";
	player.progressbar[myIDnumber].x = player.defrostmsgx + 1;
	player.progressbar[myIDnumber].y = player.defrostmsgy + 15;
	player.progressbar[myIDnumber].sort = 2;
	player.progressbar[myIDnumber].color = (0.3,1,1);
	player.progressbar[myIDnumber] setShader("white", 1, level.barheight);

	player.defrostmsgx = player.defrostmsgx + 100;
	//player.defrostmsgy = player.defrostmsgy - 30;
	return;
}

defrostme( player, beam )
{
	if ( level.inOvertime )
		return;

	defroststicker = undefined;
	self.isbeingdefrosted = true;

	self thread createprogressdisplays( player, self getEntityNumber() );

	if(!beam && level.defrostmode != 2 )
	{
		player playsound("MP_bomb_plant");
		defroststicker = spawn("script_origin", player.origin);
		player linkto(defroststicker);
		player disableWeapons();
	}

	if( !isDefined(self.defrostprogresstime) )
		self.defrostprogresstime = 0;

	self.cubeisrotating = false;
	self.rotang = 0;

	self thread playloopfx(level.fx_defrostmelt,self.origin,0.5,"stop_defrost_fx");

	while( isPlayer(self) && self.sessionstate == "playing" && (self.health < self.maxhealth) && game["state"] != "postgame" && isDefined( self.frozen ) && self.frozen )
	{
		if( !isPlayer(player) || player.sessionstate != "playing" || isDefined( player.frozen ) && player.frozen )
			break;

		if( beam && ( !player ftagButtonPressed() || !player islookingatftag(self) ) )
			break;

		if( !beam && distance( self.origin, player.origin ) >= level.defrostdist )
			break;

		if( beam )
			self thread dobeam(player);

		meltedpercentage = self.health / self.maxhealth;
		meltedpercentage = int(level.barwidth * meltedpercentage);

		if ( isDefined( player.progressbar[self getEntityNumber()] ) ) {
			player.progressbar[self getEntityNumber()] setShader("white", meltedpercentage, level.barheight);
			player.progressbar[self getEntityNumber()] scaleOverTime(self.maxhealth, level.barwidth, level.barheight);
		}

		if ( level.scr_ftag_rotate_ann )
			self.ice.origin = self.ice.origin - (0,0, ( 60 / self.maxhealth ) );
		if ( level.scr_ftag_rotate_ann && isDefined( self.cubeisrotating ) && self.cubeisrotating == false)
			self thread rotatemycube(player);

		if ( isDefined( player.instantmelt ) && player.instantmelt ) {
			player.healthgiven[self getEntityNumber()] = self.maxhealth;
			self.health = self.maxhealth;
		}

		self.health++;

		if ( isDefined( player.healthgiven ) && isDefined( player.healthgiven[self getEntityNumber()] ) )
			player.healthgiven[self getEntityNumber()]++;
		else
			player.healthgiven[self getEntityNumber()] = 1;

		wait level.defrosttime / 100 ;
	}

	player.defrostmsgx = player.defrostmsgx - 100;
	//player.defrostmsgy = player.defrostmsgy + 30;

	if ( isDefined( self.defrostingmsg ) )
		self.defrostingmsg destroy();

	if ( isDefined( player.defrostmsg ) && isDefined( player.defrostmsg[self getEntityNumber()] ) )
		player.defrostmsg[self getEntityNumber()] destroy();

	if ( isDefined( player.progressbackground ) && isDefined( player.progressbackground[self getEntityNumber()] ) )
		player.progressbackground[self getEntityNumber()] destroy();

	if ( isDefined( player.progressbar ) && isDefined( player.progressbar[self getEntityNumber()] ) )
		player.progressbar[self getEntityNumber()] destroy();

	if( self.health + 1 >= self.maxhealth ) {
		self thread defrosted( player, beam, defroststicker );
	} else if( !player.frozen && !beam && level.defrostmode != 2 ) {
		player unlink();
		player enableWeapons();
		defroststicker delete();
	} else if( !beam && level.defrostmode != 2 ) {
		defroststicker delete();
	}

	self.isbeingdefrosted = false;
	self notify("stop_defrost_fx");
}

defrosted( lastplayer, beam, defroststicker )
{
	self endon("disconnect");
	self endon("death");
	self endon("player_melted");

	if( isDefined( self.isMelting ) && self.isMelting )
		return;

	self.isMelting = true;
	self.bestDefrostPlayer = [];

	if( isDefined( lastplayer ) )
	{
		if(!beam && level.defrostmode != 2)
		{
			lastplayer unlink();
			lastplayer enableWeapons();
			lastplayer playSound("mp_bomb_plant");
			if(isDefined(defroststicker))
				defroststicker delete();
		}
		if( isDefined( lastplayer.defrosticon ) )
			lastplayer.defrosticon destroy();

		self.defrostplayers = undefined;

		for ( index = 0; index < level.players.size; index++ )
		{
			player = level.players[index];

			//Code to find players who defrosted me
			if ( player.team == self.team ) {
				percentageMelted = 0;
				tenpercentscore = 0;
				melt_level_value = 0;
				if ( isDefined( player.healthgiven ) && isDefined( player.healthgiven[self getEntityNumber()] ) && player.healthgiven[self getEntityNumber()] >= 0 ) {
					percentageMelted = int( ( ( ( player.healthgiven[self getEntityNumber()] + 1 ) / level.maxhealth ) * 100 ) );
					tenpercentscore = level.defrostpoint / 10;
				}

				if ( isDefined( percentageMelted ) && isDefined( tenpercentscore ) && percentageMelted >= 1 ) {
					melt_level = int( floor( percentageMelted / 10 ) );
					melt_level_value = int( melt_level * tenpercentscore );
				}

				if( isDefined( melt_level_value ) && melt_level_value >= 1 ) {
					// Give player score and XP
					newScore = int( player.pers["score"] + melt_level_value );
					maps\mp\gametypes\_globallogic::_setPlayerScore( player, newScore );
					player maps\mp\gametypes\_rank::giveRankXP( "assist", melt_level_value );

					if( !isDefined( self.bestDefrostPlayer["player"] ) || !isDefined( self.bestDefrostPlayer["healthgiven"] ) || player.healthgiven[self getEntityNumber()] >= self.bestDefrostPlayer["healthgiven"] ) {
						self.bestDefrostPlayer["player"] = player;
						self.bestDefrostPlayer["healthgiven"] = player.healthgiven[self getEntityNumber()];
					}
					
					// Add player to list of players who helped defrost
					if( !isDefined( self.defrostplayers ) && isDefined( player.name ) )
						self.defrostplayers = player.name;					
					else if( isDefined( self.defrostplayers ) && isDefined( player.name ) )
						self.defrostplayers += ";" + player.name;

					// Show defrosted messages to player
					if( level.scr_ftag_showcentermessage )
						player iprintlnbold(&"MS2_FTAG_HUD_POINTS", melt_level_value, self.name );
					if( level.scr_ftag_showstatusmessage )
						player iPrintln(&"MS2_FTAG_HUD_POINTS", melt_level_value, self.name );
				}

				if ( isDefined( player.healthgiven ) && isDefined( player.healthgiven[self getEntityNumber()] ) )
					player.healthgiven[self getEntityNumber()] = 0;
			}
		}

		// New way to give highest player only a melt
		if( isDefined( self.bestDefrostPlayer["player"] ) ) {
			self.bestDefrostPlayer["player"] notify("give_melt");

			// Add assists for scoreboard info as melts do not register on scoreboard
			self.bestDefrostPlayer["player"] maps\mp\gametypes\_globallogic::incPersStat( "assists", 1 );
			self.bestDefrostPlayer["player"].assists = self.bestDefrostPlayer["player"] maps\mp\gametypes\_globallogic::getPersStat( "assists" );

			defaultvalues = strtok( self.defrostplayers, ";" );
			self.defrostplayers = undefined;

			// Add all player names
			for ( i=0; i < defaultvalues.size; i++ ) {
				if( defaultvalues[i] != self.bestDefrostPlayer["player"].name ) {
					if( !isDefined( self.defrostplayers ) )
						self.defrostplayers = self.bestDefrostPlayer["player"].name + " with the help of " + defaultvalues[i];
					else
						self.defrostplayers += " & " + defaultvalues[i];
				}
			}
		}

		// If not multiplayers defrosted then revert to lastplayer
		if( !isDefined( self.defrostplayers ) ) {
			if( isDefined( lastplayer.name ) )
				self.defrostplayers = lastplayer.name;
			else
				self.defrostplayers = &"MS2_FTAG_DEFROSTED_UNKNOWN";
		}

		// Show defrosted messages to everyone
		if ( level.scr_ftag_showcentermessage && isDefined( self.defrostplayers ) )
			self iprintlnbold( &"MS2_FTAG_HUD_DEFROSTEDBY", self.defrostplayers );

		if ( level.scr_ftag_showstatusmessage && isDefined( self.defrostplayers ) )
			iPrintln(&"MS2_FTAG_DEFROSTED" , self.defrostplayers , self.name);
		
		self.bestDefrostPlayer = [];
	}
	else if( level.autodefrost )
	{
		if ( level.scr_ftag_showcentermessage )
			self iprintlnbold(&"MS2_FTAG_HUD_AUTO_DEFROSTED");
		if ( level.scr_ftag_showstatusmessage )
			iPrintln(&"MS2_FTAG_AUTO_DEFROSTED" , self.name);
	}

	self.health = self.maxhealth;
	self.defrostprogresstime = undefined;
	self.frozen = false;
	self unlink();
	self notify("weaponsenabled");
	self enableWeapons();
	self thread RemoveIceItems( self getEntityNumber() );

	self notify("defrosted");
	level.playedlastoneSound = false;

	self thread maps\mp\gametypes\_globallogic::spawnPlayer();
}

defrostaftertime( waittime )
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("defrosted");
	self endon("death");

	if ( !waittime )
		waittime = 10;

	wait waittime;

	if(!self.isbeingdefrosted)
		self thread defrosted(undefined, false, undefined);
	else
	{
		while(self.isbeingdefrosted)
			wait 1;
		self thread defrostaftertime();
	}
}

disablemyweapons()
{
	self endon("disconnect");
	self endon("weaponsenabled");
	while(1)
	{
		self disableweapons();
		wait 0.1;
	}
}

playloopfx(fx,origin,waittime,end)
{
	level endon("game_ended");
	self endon(end);
	self endon("disconnect");
	self endon("death");
	self endon("joined_spectators");
	while(1)
	{
		playfx(fx,origin);
		wait waittime;
	}
}

islookingatftag(who)
{
	if( self getStance() == "prone" )
		myeye = self.origin + (0,0,11);
	else if( self getStance() == "crouch" )
		myeye = self.origin + (0,0,40);
	else 
		myeye = self.origin + (0,0,60);
	myangles = self getPlayerAngles();

	origin = myeye + maps\mp\_utility::vector_Scale(anglestoforward(myangles),9999999);
	trace = bulletTrace(myeye, origin, true, self);

	if( trace["fraction"] != 1 )
	{
		if( isDefined( trace["entity"] ) && trace["entity"] == who )
			return true;
		else
			return false;
	}
	else
		return false;
}

dobeam(player)
{
	if(self.beam)
		return;

	speed = 500;
	self.beam = true;
	defrosterfx = spawn("script_origin", player.origin + (0,0,40));

	if ( level.scr_ftag_showdefrostbeam )
		defrosterfx thread playdefrostbeam(game[level.gameType]["defrost_beam_" + self.pers["team"] ],0.1,"stop_defrost_fx");

	defrosterfx moveto(self.origin + (0,0,40),calcspeed(speed, player.origin, self.origin));
	self thread beamwaiter();
	defrosterfx waittill("movedone");
	defrosterfx notify("stop_defrost_fx");
	defrosterfx delete();
}

playdefrostbeam(fx,waittime,end)
{
	self endon(end);
	while(1)
	{
		playfx(fx,self.origin);
		wait waittime;
	}
}

beamwaiter()
{
	self endon("disconnect");
	wait 1;
	self.beam = false;
}

ftagButtonPressed()
{
	ispressed = false;

	switch ( level.scr_ftag_unfreeze_button )
	{
		case "attack":
			ispressed = self attackButtonPressed();
			break;
		case "melee":
			ispressed = self meleeButtonPressed();
			break;
		case "frag":
			ispressed = self fragButtonPressed();
			break;
		case "use":
			ispressed = self useButtonPressed();
			break;
		default:
			ispressed = self buttonPressed(level.scr_ftag_unfreeze_button);
			break;
	}

	return ispressed;
}

rotatemycube(player)
{
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("defrosted");
	self endon("death");

	if (self.cubeisrotating == true)
		return;

	self.cubeisrotating = true;
	self.ice.angles = self.ice.angles + ( 0, self.rotang, 0);
	self.rotang += level.scr_ftag_rotate_angle;
	if (self.rotang >= 360)
		self.rotang = 0;
	wait (0.05);
	self.cubeisrotating = false;
}

CountPlayersFrozen()
{
	players = level.players;
	allies = 0;
	alliesTotal = 0;
	alliesFrozen = 0;
	axis = 0;
	axisTotal = 0;
	axisFrozen = 0;

	for(i = 0; i < players.size; i++)
	{
		if( isdefined( players[i].pers["team"] ) && players[i].pers["team"] == "allies" ) {
			alliesTotal++;
			if( !isDefined( players[i].frozen ) || !players[i].frozen )
				allies++;
			else
				alliesFrozen++;
		} else if( isdefined( players[i].pers["team"] ) && players[i].pers["team"] == "axis" ) {
			axisTotal++;
			if( !isDefined( players[i].frozen ) || !players[i].frozen )
				axis++;
			else
				axisFrozen++;
		}
	}
	players["allies"] = allies;
	players["alliesTotal"] = alliesTotal;
	players["alliesFrozen"] = alliesFrozen;
	players["axis"] = axis;
	players["axisTotal"] = axisTotal;
	players["axisFrozen"] = axisFrozen;

	return players;
}

calcspeed(speed, origin1, moveto)
{
	dist = distance(origin1, moveto);
	time = (dist / speed);
	return time;
}

onTimeLimit()
{
	if ( level.inOvertime )
		return;

	if ( level.ftag_sd_time > 0 )
		thread onOvertime();
	else
		thread CheckWinningTeam();
}

onOvertime()
{
	level endon ( "game_ended" );

	level.timeLimitOverride = true;
	level.inOvertime = true;

	level thread openwarfare\_teamstatus::destroyHudElementsFreezetag();

	for ( index = 0; index < level.players.size; index++ )
	{
		level.players[index] notify("force_spawn");
		level.players[index] thread maps\mp\gametypes\_hud_message::oldNotifyMessage( &"MP_SUDDEN_DEATH", &"MP_NO_RESPAWN", undefined, (1, 0, 0), "mp_last_stand" );
		level.players[index] playLocalSound( "US_1mc_overtime" );
		level.players[index] thread SetOvertimeSpec();

		if ( level.scr_suddendeath_show_enemies == 1 ) {
			level.players[index] setClientDvars("cg_deadChatWithDead", 1,
								"cg_deadChatWithTeam", 0,
								"cg_deadHearTeamLiving", 0,
								"cg_deadHearAllLiving", 0,
								"cg_everyoneHearsEveryone", 0,
								"g_compassShowEnemies", 1 );
		}
	}

	waitTime = 0;
	level thread timeLimitClock_Overtime( level.ftag_sd_time );

	while ( waitTime < level.ftag_sd_time ) {
		if ( level.gametype != "sab" || !level.bombPlanted ) {
			waitTime += 1;
			setGameEndTime( getTime() + ( ( level.ftag_sd_time - waitTime ) * 1000 ) );
		}
		wait ( 1.0 );
	}

	self notify("stop_ticking");
	CheckWinningTeam();
}

CheckWinningTeam()
{
	if( isDefined( level.scr_ftag_wintype ) && level.scr_ftag_wintype ) {
		winner = CheckMostAlive();
		if( winner == "tie" )
			winner = CheckHighestScore();
	} else {
		winner = CheckHighestScore();
		if( winner == "tie" )
			winner = CheckMostAlive();
	}

	logString( "time limit, win: " + winner + ", allies: " + game["teamScores"]["allies"] + ", opfor: " + game["teamScores"]["axis"] );
	thread maps\mp\gametypes\_globallogic::endGame( winner, game["strings"]["time_limit_reached"] );
}

CheckHighestScore()
{
	if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
		return "tie";
	else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
		return "axis";
	else
		return "allies";
}

CheckMostAlive()
{
	playerCounts = CountPlayersFrozen();

	if( playerCounts["axis"] == playerCounts["allies"] )
		return "tie";
	else if( playerCounts["allies"] < playerCounts["axis"] )
		return "axis";
	else
		return "allies";
}

timeLimitClock_Overtime( waitTime )
{
	level endon ( "game_ended" );
	level endon("stop_ticking");

	level.playedlastoneSound = false;
	level thread openwarfare\_owbattlechatter::CountdownMonitor();
	level.OTtimeLeft = waitTime - 1;
	setGameEndTime( getTime() + int( waitTime*1000 ) );
	clockObject = spawn( "script_origin", (0,0,0) );
	level notify ( "ow_countdown_start" );

	for ( ;; )
	{
		level.OTtimeLeft--;

		if ( level.OTtimeLeft <= 10 || (level.OTtimeLeft <= 30 && level.OTtimeLeft % 2 == 0) )
		{
			// don't play a tick at exactly 0 seconds, that's when something should be happening!
			if ( level.OTtimeLeft <= 0 )
				break;

			clockObject playSound( "ui_mp_timer_countdown" );
		}
		wait ( 1.0 );
	}
	return;
}

SetOvertimeSpec()
{
	if( level.ftag_sd_spec != 1 || !isAlive(self) || !self.frozen || self.team == "spectator" )
		return;

	self suicide();
	self.deaths--;
	self.pers["deaths"] --;
	self.suicides--;
	self.pers["suicides"] --;	

	if (self.deaths <= 0 )
		self.deaths = 0;
	if (self.pers["deaths"] <= 0 )
		self.pers["deaths"] = 0;
	if (self.suicides <= 0 )
		self.suicides = 0;
	if (self.pers["suicides"] <= 0 )
		self.pers["suicides"] = 0;
	if ( level.teambased )
		self updateScores();

	self allowSpectateTeam( self.team, true );
	self allowSpectateTeam( getOtherTeam( self.team ), false );
	self allowSpectateTeam( "freelook", false );
	self allowSpectateTeam( "none", false );

	self.frozen = true;
	self thread RemoveIceItems( self getEntityNumber() );
	self.statusicon = "hud_freeze";
}

RemoveIceItems( MyGuidId )
{
	if(isDefined(self.ice))
	{
		self.ice playSound("frozen");
		self.ice stoploopSound();
		self.ice delete();
	}

	// Remove icons
	if( isDefined( self.sticker ) )
		self.sticker delete();
	if( isDefined( self.hud_freeze ) )
		self.hud_freeze destroy();
	if ( isDefined( self.objWorld ) )
		self.objWorld destroy();
	if ( isDefined( self.statusicon ) )
		self.statusicon = "";

	// Delete my objective ID
	if( isdefined( self.objnum ) && self.objnum != -1 )
	{
		objective_delete( self.objnum );
		maps\mp\gametypes\_gameobjects::resetObjID( self.objnum );
		self.objnum = undefined;
	}

	// Stop Ice Sounds
	if( isDefined( self ) ) {
		self notify("stop_defrost_fx");
		self notify("stop_ice_fx");
	}

	// Delete Defrost Messages & Bars
	if ( isDefined( self.defrostingmsg ) )
		self.defrostingmsg destroy();

	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];

		if( isDefined( player.defrostmsg ) && isDefined( player.defrostmsg[ MyGuidId ] ) )
			player.defrostmsg[ MyGuidId ] destroy();
		if( isDefined( player.progressbackground ) && isDefined( player.progressbackground[ MyGuidId ] ) )
			player.progressbackground[ MyGuidId ] destroy();
		if( isDefined( player.progressbar ) && isDefined( player.progressbar[ MyGuidId ] ) )
			player.progressbar[ MyGuidId ] destroy();
	}
}
