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
	// Get the main module's dvars
	level.scr_ms2sniperzoom_enable = getdvarx( "scr_ms2sniperzoom_enable", "int", 0, 0, 1 );
	level.scr_sniperzoom_enable = getdvarx( "scr_sniperzoom_enable", "int", 0, 0, 1 );

	// If disabled then there's nothing to do here
	if ( level.scr_ms2sniperzoom_enable == 0 || level.scr_sniperzoom_enable == 1 )
		return;

	level thread onPlayerConnect();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread onPlayerSpawned();
	}
}


onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		self thread WaitForZoom();
	}
}

WaitForZoom() 
{ 
   self endon("disconnect"); 
   self endon("death"); 
   self endon("joined_spectators"); 

   zoom = 9; 

   while( isAlive(self) ) 
   { 
      wait .05; 

      if( isSniper(self getCurrentWeapon()) && self playerADS() ) 
      { 
         if(!zoom) 
         { 
            zoom = 9; 
            setZoom(zoom); 
         } 

         if( !isdefined(self.hud_zoom) ) 
         { 
            self.hud_zoom = newClientHudElem(self); 
            self.hud_zoom.x = 320; 
            self.hud_zoom.y = 450; 
            self.hud_zoom.alignx = "center"; 
            self.hud_zoom.aligny = "middle"; 
            self.hud_zoom.horzAlign = "fullscreen"; 
            self.hud_zoom.vertAlign = "fullscreen"; 
            self.hud_zoom.alpha = .9; 
            self.hud_zoom.fontScale = 1.5; 
         } 

         self.hud_zoom.label = &"ZOOM LEVEL "; 
         self.hud_zoom setvalue(zoom); 
         
         if( self meleeButtonPressed()) 
         { 
            zoom++; 
            self playlocalsound("zoomauto"); 
            setZoom(zoom); 
            if(zoom > 9)
            { 
	            zoom = 1; 
	            setZoom(zoom); 
            }
            wait .2; 
         } 

//         if( self fragButtonPressed() && zoom > 1) 
//         { 
//            zoom--; 
//            self playlocalsound("mouse_click");  
//            setZoom(zoom); 
//            wait .2; 
//         } 
      } 
      else if( isDefined(self.hud_zoom) ) self.hud_zoom destroy(); 
   } 
} 

setZoom(zoom) 
{ 
   self endon("disconnect"); 
   self endon("death"); 

   zoomvalue = 100 - (zoom * 10); 
   self setclientDvar("cg_fovmin", zoomvalue); 
   if(isDefined(self.hud_zoom)) self.hud_zoom setvalue(zoom); 
} 

//isSniper(weapon) 
//{ 
//   switch(weapon) 
//   { 
//      case "m21_mp": 
//      case "m40a3_mp": 
//      case "barrett_mp": 
//      case "dragunov_mp": 
//      case "remington700_mp": return true; 
//      default: return false; 
//   } 
//} 

isSniper(weapon) 
{ 
   switch(weapon) 
   { 
      case "m21_mp": 
      case "m21_acog_mp": 
      case "m40a3_mp": 
      case "m40a3_acog_mp": 
      case "barrett_mp": 
      case "barrett_acog_mp": 
      case "dragunov_mp": 
      case "dragunov_acog_mp": 
      case "remington700_mp": 
      case "remington700_acog_mp": return true; 
      default: return false; 
   } 
} 