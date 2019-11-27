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
	level.scr_sticky_nades = getdvarx( "scr_sticky_nades", "int", 0, 0, 1 );
	level.scr_sticky_nades_waittime = getdvarx( "scr_sticky_nades_waittime", "int", 3, 1, 60 );
	level.scr_show_sticky_message = getdvarx( "scr_show_sticky_message", "int", 0, 0, 1 );

	// If the welcome screen is not enabled then there's nothing else to do here
	if ( level.scr_sticky_nades == 0 )
		return;

	level.nade_fx["nade"]["explode"] = loadfx ("explosions/grenadeexp_default"); 
	level.playerExpSound = "grenade_explode_default";

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	self endon("disconnect");

	for(;;)
	{
		level waittill("connected", player);

		self.damageOwner = undefined; 
		player thread onPlayerDamaged();
	}
}

onPlayerDamaged()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill( "damage_taken", eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
		self.hasstickynade = false;

		if( !isDefined( eInflictor ))
			sWeapon = "frag_grenade_mp";

		isFrag = isSubStr( sWeapon, "frag_" ); //Lets make sure this is a frag nade 
       
		if (isFrag && sMeansOfDeath == "MOD_IMPACT")
		{ 
			self.damageOwner = eAttacker;

			if ( level.scr_show_sticky_message == 1 )
				Iprintln(&"MS2_HAS_STUCK", eAttacker.name, self.name);

			eInflictor.origin = eInflictor.origin + (0, 0, -100000); // Throw the original nade away so it wont cause a 2nd explostion 

			self.hasstickynade = true;
			self thread playergoboom(); 
		}
	}
}

playergoboom()
{
	if ( level.scr_show_sticky_message == 1 )
		self iPrintlnBold(&"MS2_STICK_NADES");

	wait(level.scr_sticky_nades_waittime);

	self playsound (level.playerExpSound); // play nade FX 
	playfx (level.nade_fx["nade"]["explode"], self.origin); // play nade sound 
    
	phyExpMagnitude = 2; 

	// Modify these values if you have changed your nade properties. 
	minDamage = 75; // keep the min damage the same as a real nade. 
	maxDamage = 300; // keep the max damage the same as a real nade. 
	blastRadius = 256; // keep the radius the same as a real nade. 
    
	// do not pass damage owner if they have disconnected before the nade explodes 
	if ( !isdefined( self.damageOwner ) ) 
		radiusDamage(self.origin + (0,0,30), blastRadius, maxDamage, minDamage); 
	else 
		radiusDamage(self.origin + (0,0,30), blastRadius, maxDamage, minDamage, self.damageOwner); 
       
	physicsExplosionSphere( self.origin + (0,0,30), blastRadius, blastRadius/2, phyExpMagnitude ); 
    
	self maps\mp\gametypes\_shellshock::grenade_earthQuake(); // do a nade earthquake 
}
