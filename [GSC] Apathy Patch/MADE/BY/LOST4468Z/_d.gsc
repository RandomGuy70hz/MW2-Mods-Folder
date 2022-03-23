#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

doToggleDvars()
{
	self thread doRainbow();
	self thread doCartoon();
	self thread doChrome();
	self thread doProMod();
	self thread doSp();
	self thread doDc();
	self thread doInstantCP();
	self thread doFarX();
	self thread doNoX();
	self thread doUnbreakable();
	self thread doInstantZoom();
	self thread doSuperSOH();
	self thread doWallHack();
	self thread doLaser();
	self thread doTTOT();
	self thread doFH();
	self thread doInstaPred();
	self thread doVote();
	self thread doNoDelete();
	self thread doShowFlash();
	self thread doShowHost();
	self thread doKillCam();
	self thread doMartydom();
	self thread doScoreFont();	
	self thread doNukeTimers();
	self thread doSuperJump();
	self thread doSuperSpeed();
	self thread doChoppBullets();
	self thread doKnockBack();
	self thread doChopperCarePack();
	self thread doEmpCarePack();
	self thread doAc130CarePack();

}
doRainbow()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("rainbow");
			self setClientDvar( "r_debugshader", "1");
			self iPrintln( "Rainbow: ON" ); 
		self waittill("rainbow");
			self setClientDvar( "r_debugshader", "0");
			self iPrintln( "Rainbow: OFF" ); 
	}
}
doCartoon()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("cartoon");
			self setClientDvar( "r_fullbright", "1");
			self iPrintln( "Cartoon: ON" ); 
		self waittill("cartoon");
			self setClientDvar( "r_fullbright", "0");
			self iPrintln( "Cartoon: OFF" ); 
	}
}
doChrome()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("chrome");
			self setClientDvar( "r_specularmap", "2");
			self iPrintln( "Chrome: ON" ); 
		self waittill("chrome");
			self setClientDvar( "r_specularmap", "0");
			self iPrintln( "Chrome: OFF" ); 
	}
}

doProMod()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("promod");
			self setClientDvar( "cg_gun_x", "5" );
	        	self setClientDvar( "FOV", "90" );
			self iPrintln( "PC Pro Mod: ON" ); 
		self waittill("promod");
                	self setClientDvar( "cg_gun_x", "1" );
	        	self setClientDvar( "FOV", "30" );
			self iPrintln( "PC Pro Mod: OFF" ); 
	}
}
doSp()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("sp");
			self setClientDvar( "perk_bulletDamage", "999" );
			self iPrintln( "1 Hit 1 Kill With Stopping Power" ); 
		self waittill("sp");
			self setClientDvar( "perk_bulletDamage", "-99" ); 
			self iPrintln( "God Mode With Stopping Power" ); 
	}
}

doDc()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("dc");
                        self setClientDvar( "perk_explosiveDamage", "999" ); 
			self iPrintln( "1 Hit 1 Kill With Danger Close" ); 
		self waittill("dc");
                        self setClientDvar( "perk_explosiveDamage", "-99" );
			self iPrintln( "Gode Mode With Danger Close" ); 
	}
}
doInstantCP()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("instant");
                        self setClientDvar( "phys_gravity" , "-9999" );
			self iPrintln( "Instant Care Package: ON" ); 
		self waittill("instant");
			self setClientDvar( "phys_gravity" , "-200" );  
			self iPrintln( "Instant Care Package: OFF" ); 
	}
}
doFarX()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("farX");
                        self setClientDvar( "g_maxDroppedWeapons", "999" );
                        self setClientDvar( "player_MGUseRadius", "99999" );
                        self setClientDvar( "player_useRadius", "99999" );
			self iPrintln( "Use [{+usereload}] From Far Away: ON" ); 
		self waittill("farX");
                        self setClientDvar( "g_maxDroppedWeapons", "16" );
                        self setClientDvar( "player_MGUseRadius", "128" );
                        self setClientDvar( "player_useRadius", "128" );
			self iPrintln( "Use [{+usereload}] From Far Away: OFF" ); 
	}
}
doNoX()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("noX");
                        self setClientDvar( "g_useholdtime", "65535");
			self iPrintln( "Unusable [{+usereload}]: ON" ); 
		self waittill("noX");
			self setClientDvar( "phys_gravity" , "-200" ); 
			self iPrintln( "Unusable [{+usereload}]: OFF" ); 
	}
}
doUnbreakable()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("glass");
                        self setClientDvar( "glass_damageToWeaken", "65535" );
                        self setClientDvar( "glass_damageToDestroy", "65535" );
                        self setClientDvar( "glass_break", "0" ); 
                        self setClientDvar( "missileGlassShatterVel", "65535");
			self iPrintln( "Unbreakable Glass: ON" ); 
		self waittill("glass");
                        self setClientDvar( "glass_damageToWeaken", "25" );
                        self setClientDvar( "glass_damageToDestroy", "100" );
                        self setClientDvar( "glass_break", "1" ); 
                        self setClientDvar( "missileGlassShatterVel", "600");
			self iPrintln( "Unbreakable Glass: OFF" ); 
	}
}
doInstantZoom()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("zoom");
                	self setClientDvar( "perk_fastSnipeScale", "9" );
                	self setClientDvar( "perk_quickDrawSpeedScale", "6.5" );
			self iPrintln( "Instant Zoom In: ON" ); 
		self waittill("zoom");
                	self setClientDvar( "perk_fastSnipeScale", "1" );
                	self setClientDvar( "perk_quickDrawSpeedScale", "1" );
			self iPrintln( "Instant Zoom In: OFF" ); 
	}
}
doSuperSOH()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("soh");
			self setclientdvar( "player_burstFireCooldown", "0" ); 
	       		self setclientDvar( "perk_weapReloadMultiplier", "0.0001" );
                	self setclientDvar( "perk_weapSpreadMultiplier" , "0.0001" );
                	self setClientDvar( "perk_weapRateMultiplier" , "0.0001"); 
			self iPrintln( "Super Sleight Of Hand: ON" ); 
		self waittill("soh");
			self setclientdvar( "player_burstFireCooldown", "0" ); 
	        	self setclientDvar( "perk_weapReloadMultiplier", "0.0001" );
                	self setclientDvar( "perk_weapSpreadMultiplier" , "0.0001" );
                	self setClientDvar( "perk_weapRateMultiplier" , "0.0001"); 
			self iPrintln( "Super Sleight Of Hand: OFF" ); 
	}
}
doWallHack()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("WH");
                        self setClientDvar( "r_zfar", "0");
	                self setClientDvar( "r_zFeather", "4");
	                self setClientDvar( "r_znear", "57");
	                self setClientDvar( "r_znear_depthhack", "2");	
			self iPrintln( "Wall Hack: ON" ); 
		self waittill("WH");
 			self setClientDvar( "r_zfar", "0");
	                self setClientDvar( "r_zFeather", "1");
	                self setClientDvar( "r_znear", "4");
	                self setClientDvar( "r_znear_depthhack", ".1");	
			self iPrintln( "Wall Hack: OFF" ); 
	}
}        
doLaser()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("Laser");
                        self setClientDvar( "laserForceOn", "1" ); 	
			self iPrintln( "Laser: ON" ); 
		self waittill("Laser");
			self setClientDvar( "laserForceOn", "0" );
			self iPrintln( "Laser: OFF" ); 
	}
}        
doTTOT()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("TTOT");
			self setClientdvar("cg_everyoneHearsEveryone", "1" );
			self setClientdvar("cg_chatWithOtherTeams", "1" );
			self setClientdvar("cg_deadChatWithTeam", "1" );
			self setClientdvar("cg_deadHearAllLiving", "1" );
			self setClientdvar("cg_deadHearTeamLiving", "1" );
			self setClientdvar("cg_drawTalk", "ALL" );		
			self iPrintln( "Talk To Other Team: ON" ); 
		self waittill("TTOT");
                        self setClientdvar("cg_everyoneHearsEveryone", "0" );
                        self setClientdvar("cg_chatWithOtherTeams", "0" );
                        self setClientdvar("cg_deadChatWithTeam", "0" );
                        self setClientdvar("cg_deadHearAllLiving", "0" );
                        self setClientdvar("cg_deadHearTeamLiving", "0" );	
			self iPrintln( "Talk To Other Team: OFF" ); 
	}
}
doFH()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("FH");
                        self setClientDvar("party_hostmigration", "0" );
           	        self setClientDvar("party_connectToOthers", "0" ); 			
			self iPrintln( "Always Host: ON" ); 
		self waittill("FH");
			self setClientDvar("party_hostmigration", "1" );
       	                self setClientDvar("party_connectToOthers", "1" );
			self iPrintln( "Always Host: OFF" ); 
	}
}

doInstaPred()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("instapred");
			self setClientDvar( "missileRemoteSpeedTargetRange", "9999 99999" ); 			
			self iPrintln( "Instant Predator: ON" ); 
		self waittill("instapred");
			self setClientDvar( "missileRemoteSpeedTargetRange", "100" );
			self iPrintln( "Instant Predator: OFF" ); 
	}
}
doVote()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("vote");
			self setClientDvar( "party_vetoPercentRequired", "0.001");	
			self iPrintln( "1 Vote Skip: ON" ); 
		self waittill("vote");
			self setClientDvar( "missileRemoteSpeedTargetRange", ".6" );
			self iPrintln( "1 Vote Skip: OFF" ); 
	}
}
doNoDelete()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("delete");
			self setclientDvar( "scr_deleteexplosivesonspawn", "0");
			self iPrintln( "Never Delete C4 & Claymores: ON" ); 
		self waittill("delete");
			self setclientDvar( "scr_deleteexplosivesonspawn", "1");
			self iPrintln( "Never Delete C4 & Claymores: OFF" ); 
	}
}
doShowFlash()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("flash");
			self setClientDvar("cg_drawShellshock", "0");
			self iPrintln( "See Flash Bang Flash: OFF" ); 
		self waittill("flash");
			self setClientDvar("cg_drawShellshock", "1");
			self iPrintln( "See Flash Bang Flash: ON" ); 
	}
}
doShowHost()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("sh");
			self setClientDvar("cg_drawFPS", 1);
			self iPrintln( "Fps: 1" ); 
		self waittill("sh");
			self setClientDvar("cg_drawFPS", 2);
			self iPrintln( "Fps: 2" ); 
		self waittill("sh");
			self setClientDvar("cg_drawFPS", 3);
			self iPrintln( "Fps: 3" ); 
		self waittill("sh");
			self setClientDvar("cg_drawFPS", 4);
			self iPrintln( "Fps: 4" ); 
		self waittill("sh");
			self setClientDvar("cg_drawFPS", 0);
			self iPrintln( "Fps: Off" ); 
	}
}

doKnockBack()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("kb");
  			self setClientDvar("g_knockback", "9999999");
	                self setClientDvar("cl_demoBackJump", "9999999");
	                self setClientDvar("cl_demoForwardJump", "9999999");
                        self iPrintln( "Knock Back: ON" ); 
		self waittill("kb");
	                self setClientDvar("g_knockback", "1000");
	                self setClientDvar("cl_demoBackJump", "20000");
	                self setClientDvar("cl_demoForwardJump", "4000");
			self iPrintln( "Knock Back: OFF" ); 
	}
}
doChoppBullets()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("chopperbullets");
		        self setClientDvar( "bg_bulletExplDmgFactor", "10" );
	                self setClientDvar( "bg_bulletExplRadius", "10000" );
                        self iPrintln( "Super Chopper Gunner Bullets: ON" ); 
		self waittill("chopperbullets");
		        self setClientDvar( "bg_bulletExplDmgFactor", "3" );
	                self setClientDvar( "bg_bulletExplRadius", "3000" ); 
			self iPrintln( "Super Chopper Gunner Bullets: OFF" ); 
	}
}
doChopperCarePack()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("chopper");
                        self setClientDvar( "scr_airdrop_helicopter_minigun", "999" );
           	        self setClientDvar( "scr_mega_airdrop_helicopter_minigun", "999" );
			self iPrintln( "Chopper Gunner In Cp & Ea: Added" ); 
		self waittill("chopper");
                      self setClientDvar( "scr_airdrop_helicopter_minigun", "3" );
           	        self setClientDvar( "scr_mega_airdrop_helicopter_minigun", "3" );
			self iPrintln( "Chopper Gunner In Cp & Ea: Removed" ); 
	}
}
doEmpCarePack()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("emp");
                        self setClientDvar( "scr_airdrop_emp", "999" );
           	        self setClientDvar( "scr_mega_airdrop_emp", "999" );
			self iPrintln( "Emp In Cp & Ea: Added" ); 
		self waittill("emp");
			self setClientDvar( "scr_airdrop_emp", "3" );
           	        self setClientDvar( "scr_mega_airdrop_emp", "3" );
			self iPrintln( "Emp In Cp & Ea: Removed" ); 
	}
}
doAc130CarePack()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("ac130");                
			self setClientDvar( "scr_airdrop_ac130", "999" );
          	        self setClientDvar( "scr_mega_airdrop_ac130", "999" );
			self iPrintln( "Ac-130 In Cp & Ea: Added" ); 
		self waittill("ac130");
			self setClientDvar( "scr_airdrop_ac130", "3" );
           	        self setClientDvar( "scr_mega_airdrop_ac130", "3" );
			self iPrintln( "Ac-130 In Cp & Ea: Removed" );
	}
}
doSuperSpeed()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("speed");
			setDvar("player_sprintSpeedScale", 5 );
			setDvar("player_sprintUnlimited", 1 );
                        self iPrintln( "Super Speed: ON" ); 
		self waittill("speed");
			setDvar("player_sprintSpeedScale", 1 );
			setDvar("player_sprintUnlimited", 0 );
			self iPrintln( "Super Speed: OFF" ); 
	}
}
doSuperJump()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("jump");
                        setDvar("jump_height", 999 ); 
                        setDvar("bg_fallDamageMaxHeight", 9999 );
		        setDvar("bg_fallDamageMinHeight", 9998 ); 
                        self iPrintln( "Super Jump: ON" ); 
		self waittill("jump");
                        setDvar("jump_height", 100 ); 
                        setDvar("bg_fallDamageMaxHeight", 9999 );
		        setDvar("bg_fallDamageMinHeight", 9998 );  
			self iPrintln( "Super Jump: OFF" ); 
	}
}

doKillCam()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("cam");
			self setClientDvar( "scr_killcam_time", "1" );	
			self iPrintln( "Kill Cam Time: 1 Second" );
		self waittill("cam");
			self setClientDvar( "scr_killcam_time", "10" );	
			self iPrintln( "Kill Cam Time: 10 Second's" );
		self waittill("cam");
			self setClientDvar( "scr_killcam_time", "30" );	
			self iPrintln( "Kill Cam Time: 30 Second's" );
		self waittill("cam");
			self setClientDvar( "scr_killcam_time", "60" );	
			self iPrintln( "Kill Cam Time: 1 Minute" );
		self waittill("cam");
			self setClientDvar( "scr_killcam_time", "90" );	
			self iPrintln( "Kill Cam Time: 1 Minute 30 Second's" );
		self waittill("cam");
			self setClientDvar( "scr_killcam_time", "2" );	
			self iPrintln( "Kill Cam Time: 2 Minute's" );  
	}
}
doMartydom()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("mdom");
			self setClientDvar( "perk_grenadeDeath", "remotemissile_projectile_mp" );
			self iPrintln( "Martydom: Predator Missle's" ); 
		self waittill("mdom");
			self setClientDvar( "perk_grenadeDeath", "ac130_105mm_mp" );
			self iPrintln( "Martydom: 105mm Ac-130 Bullet's" ); 
		self waittill("mdom");
			self setClientDvar( "perk_grenadeDeath", "javelin_mp" );
			self iPrintln( "Martydom: Javelin's" ); 
	}
}
doScoreFont()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("font");
			self setClientDvar( "cg_scoreboardFont", "1");
			self iPrintln( "Score Board Font: 1" ); 
		self waittill("font");
			self setClientDvar( "cg_scoreboardFont", "2");
			self iPrintln( "Score Board Font: 2" ); 
		self waittill("font");
			self setClientDvar( "cg_scoreboardFont", "3");
			self iPrintln( "Score Board Font: 3" ); 
		self waittill("font");
			self setClientDvar( "cg_scoreboardFont", "4");
			self iPrintln( "Score Board Font: 4" ); 
		self waittill("font");
			self setClientDvar( "cg_scoreboardFont", "5");
			self iPrintln( "Score Board Font: 5" ); 
		self waittill("font");
			self setClientDvar( "cg_scoreboardFont", "6");
			self iPrintln( "Score Board Font: 6" ); 
		self waittill("font");
			self setClientDvar( "cg_scoreboardFont", "7");
			self iPrintln( "Score Board Font: 7" );  
		self waittill("font");
			self setClientDvar( "cg_scoreboardFont", "8");
			self iPrintln( "Score Board Font: 8" );  
		self waittill("font");
			self setClientDvar( "cg_scoreboardFont", "9");
			self iPrintln( "Score Board Font: 9" );  
		self waittill("font");
			self setClientDvar( "cg_scoreboardFont", "10");
			self iPrintln( "Score Board Font: 10" );  
	}
}
doNukeTimers()
{
	self endon ( "disconnect" );
	for(;;)
	{
		self waittill("nuke");
			self setClientDvar("scr_nukeTimer" , ".01" );
			self iPrintln( "Nuke Timer: Instant" ); 
		self waittill("nuke");
			self setClientDvar("scr_nukeTimer" , "10" );
			self iPrintln( "Nuke Timer: 10 Second'ss" ); 
		self waittill("nuke");
			self setClientDvar("scr_nukeTimer" , "30" );
			self iPrintln( "Nuke Timer: 30 Second's" ); 
		self waittill("nuke");
			self setClientDvar("scr_nukeTimer" , "60" );
			self iPrintln( "Nuke Timer: 1 Minute" ); 
		self waittill("nuke");
			self setClientDvar("scr_nukeTimer" , "300" );
			self iPrintln( "Nuke Timer: 5 Minute's" ); 
		self waittill("nuke");
			self setClientDvar("scr_nukeTimer" , "600" );
			self iPrintln( "Nuke Timer: 10 Minute's" ); 
		self waittill("nuke");
			self setClientDvar("scr_nukeTimer" , "900" );
			self iPrintln( "Nuke Timer: 15 Minute's" ); 
		self waittill("nuke");
			self setClientDvar("scr_nukeTimer" , "1800" );
			self iPrintln( "Nuke Timer: 30 Minute's" ); 
	}
}
initInfections(infect)
{
	switch(infect)
	{
		case "All Infections":
			self setClientdvar("compassSize", 1.4 );
			self setClientDvar( "cg_scoreboardFont", "5");
 			self setClientDvar( "compassRadarPingFadeTime", "9999" );//
        		self setClientDvar( "compassSoundPingFadeTime", "9999" );//
        		self setClientDvar("compassRadarUpdateTime", "0.001");//
        		self setClientDvar("compassFastRadarUpdateTime", "0.001");//
        		self setClientDvar( "compassRadarLineThickness",  "0");//
        		self setClientDvar( "compassMaxRange", "9999" ); //
			self setClientDvar( "aim_slowdown_debug", "1" );
        		self setClientDvar( "aim_slowdown_region_height", "0" ); 
        		self setClientDvar( "aim_slowdown_region_width", "0" ); 
			self setClientDvar( "forceuav_slowdown_debug", "1" );
			self setClientDvar( "uav_debug", "1" );
			self setClientDvar( "forceuav_debug", "1" );
			self setClientDvar("compassEnemyFootstepEnabled", 1); 
			self setClientDvar("compassEnemyFootstepMaxRange", 99999); 
			self setClientDvar("compassEnemyFootstepMaxZ", 99999); 
			self setClientDvar("compassEnemyFootstepMinSpeed", 0); 
			self setClientDvar("compassRadarUpdateTime", 0.001);
			self setClientDvar("compassFastRadarUpdateTime", 2);
			self setClientDvar("cg_footsteps", 1);
			self setClientDvar("scr_game_forceuav", 1);
			self setClientDvar( "cg_enemyNameFadeOut" , 900000 );
			self setClientDvar( "cg_enemyNameFadeIn" , 0 );
			self setClientDvar( "cg_drawThroughWalls" , 1 );
			self setClientDvar( "laserForceOn", "1" );
        		self setClientDvar( "r_znear", "57" );
        		self setClientDvar( "r_zfar", "0" );
        		self setClientDvar( "r_zFeather", "4" );
			self setClientDvar( "r_znear_depthhack", "2" );
			self setClientdvar("cg_everyoneHearsEveryone", "1" );
			self setClientdvar("cg_chatWithOtherTeams", "1" );
			self setClientdvar("cg_deadChatWithTeam", "1" );
			self setClientdvar("cg_deadHearAllLiving", "1" );
			self setClientdvar("cg_deadHearTeamLiving", "1" );
			self setClientdvar("cg_drawTalk", "ALL" );
			self setClientDvar( "scr_airdrop_mega_ac130", "500" );
			self setClientDvar( "scr_airdrop_mega_helicopter_minigun", "500" );
			self setClientDvar( "scr_airdrop_helicopter_minigun", "999" );
			self setClientDvar( "cg_scoreboardPingText" , "1" );
			self setClientDvar("cg_ScoresPing_MaxBars", "6");
			self setclientdvar("player_burstFireCooldown", "0" );
			self setClientDvar("perk_bulletPenetrationMultiplier", "0.001" );
			self setclientDvar("perk_weapSpreadMultiplier" , "0.0001" );
			self setclientDvar("perk_weapReloadMultiplier", "0.0001" );
			self setClientDvar("perk_weapRateMultiplier" , "0.0001"); 
			self setClientDvar( "perk_grenadeDeath", "remotemissile_projectile_mp" );
			self setClientDvar("cg_drawFPS", 1);
			self setClientDvar("perk_extendedMagsMGAmmo", 999);
			self setClientDvar("perk_extendedMagsPistolAmmo", 999);
			self setClientDvar("perk_extendedMagsRifleAmmo", 999);
			self setClientDvar("perk_extendedMagsSMGAmmo", 999);
			self setclientdvar("perk_extraBreath", "999");
			self setClientDvar("player_breath_hold_time", "999");
			self setClientDvar( "player_meleeHeight", "1000");
			self setClientDvar( "player_meleeRange", "1000" );
			self setClientDvar( "player_meleeWidth", "1000" );
			self setClientDvar("scr_nukeTimer" , "999999" );
			self setClientDvar("perk_sprintMultiplier", "20");
			self setClientDvar("perk_extendedMeleeRange", "999");
			self setClientDvar("perk_bulletPenetrationMultiplier", "4");
			self setClientDvar("perk_armorPiercingDamage", "999" );
			self setClientDvar("player_sprintUnlimited", 1);
			self setClientDvar("cg_drawShellshock", "0");   
			self setClientDvar( "bg_bulletExplDmgFactor", "8" );
        		self setClientDvar( "bg_bulletExplRadius", "6000" );
			self setclientDvar( "scr_deleteexplosivesonspawn", "0");
			self setClientDvar( "scr_maxPerPlayerExplosives", "999");
			self setClientDvar( "phys_gravity" , "-9999" );
			self setClientDvar( "scr_killcam_time", "1" );
        		self setClientDvar( "missileRemoteSpeedTargetRange", "9999 99999" );
			self setClientDvar( "r_specularmap", "2" );
			self setClientDvar( "party_vetoPercentRequired", "0.001");
			self setClientdvar("compassSize", 1.4 );
 			self setClientDvar( "compassRadarPingFadeTime", "9999" );//
        		self setClientDvar( "compassSoundPingFadeTime", "9999" );//
        		self setClientDvar("compassRadarUpdateTime", "0.001");//
        		self setClientDvar("compassFastRadarUpdateTime", "0.001");//
        		self setClientDvar( "compassRadarLineThickness",  "0");//
        		self setClientDvar( "compassMaxRange", "9999" ); //
			self setClientDvar( "aim_slowdown_debug", "1" );
        		self setClientDvar( "aim_slowdown_region_height", "0" ); 
        		self setClientDvar( "aim_slowdown_region_width", "0" ); 
			self setClientDvar( "forceuav_slowdown_debug", "1" );
			self setClientDvar( "uav_debug", "1" );
			self setClientDvar( "forceuav_debug", "1" );
			self setClientDvar("cg_footsteps", 1);
			self setClientDvar( "cg_enemyNameFadeOut" , 900000 );
			self setClientDvar( "cg_enemyNameFadeIn" , 0 );
			self setClientDvar( "cg_drawThroughWalls" , 1 );
			self setClientDvar( "laserForceOn", "1" );
			self setClientDvar( "r_znear", "35" );
			self setClientdvar("cg_everyoneHearsEveryone", "1" );
			self setClientdvar("cg_chatWithOtherTeams", "1" );
			self setClientdvar("cg_deadChatWithTeam", "1" );
			self setClientdvar("cg_deadHearAllLiving", "1" );
			self setClientdvar("cg_deadHearTeamLiving", "1" );
			self setClientdvar("cg_drawTalk", "ALL" );
			self setClientDvar( "scr_airdrop_mega_ac130", "500" );
			self setClientDvar( "scr_airdrop_mega_helicopter_minigun", "500" );
			self setClientDvar("cg_ScoresPing_MaxBars", "6");
			self setclientdvar("cg_scoreboardPingGraph", "1");
			self setClientDvar( "perk_bulletDamage", "-99" ); 
			self setClientDvar( "perk_explosiveDamage", "-99" ); 
			self setClientDvar("cg_drawShellshock", "0");
			break;
		case "GB Package":
			self setClientdvar("compassSize", 1.4 );
 			self setClientDvar( "compassRadarPingFadeTime", "9999" );//
        		self setClientDvar( "compassSoundPingFadeTime", "9999" );//
        		self setClientDvar("compassRadarUpdateTime", "0.001");//
        		self setClientDvar("compassFastRadarUpdateTime", "0.001");//
        		self setClientDvar( "compassRadarLineThickness",  "0");//
        		self setClientDvar( "compassMaxRange", "9999" ); //
			self setClientDvar( "aim_slowdown_debug", "1" );
        		self setClientDvar( "aim_slowdown_region_height", "0" ); 
        		self setClientDvar( "aim_slowdown_region_width", "0" ); 
			self setClientDvar( "forceuav_slowdown_debug", "1" );
			self setClientDvar( "uav_debug", "1" );
			self setClientDvar( "forceuav_debug", "1" );
			self setClientDvar("cg_footsteps", 1);
			self setClientDvar( "cg_enemyNameFadeOut" , 900000 );
			self setClientDvar( "cg_enemyNameFadeIn" , 0 );
			self setClientDvar( "cg_drawThroughWalls" , 1 );
			self setClientDvar( "laserForceOn", "1" );
			self setClientDvar( "r_znear", "35" );
			self setClientdvar("cg_everyoneHearsEveryone", "1" );
			self setClientdvar("cg_chatWithOtherTeams", "1" );
			self setClientdvar("cg_deadChatWithTeam", "1" );
			self setClientdvar("cg_deadHearAllLiving", "1" );
			self setClientdvar("cg_deadHearTeamLiving", "1" );
			self setClientdvar("cg_drawTalk", "ALL" );
			self setClientDvar( "scr_airdrop_mega_ac130", "500" );
			self setClientDvar( "scr_airdrop_mega_helicopter_minigun", "500" );
			self setClientDvar("cg_ScoresPing_MaxBars", "6");
			self setclientdvar("cg_scoreboardPingGraph", "1");
			self setClientDvar( "perk_bulletDamage", "-99" ); 
			self setClientDvar( "perk_explosiveDamage", "-99" ); 
			self setClientDvar("cg_drawShellshock", "0");
			break;
		case "Cheaters Package":
			self setClientdvar("compassSize", 1.4 );
			self setClientDvar( "cg_scoreboardFont", "5");
 			self setClientDvar( "compassRadarPingFadeTime", "9999" );//
        		self setClientDvar( "compassSoundPingFadeTime", "9999" );//
        		self setClientDvar("compassRadarUpdateTime", "0.001");//
        		self setClientDvar("compassFastRadarUpdateTime", "0.001");//
        		self setClientDvar( "compassRadarLineThickness",  "0");//
        		self setClientDvar( "compassMaxRange", "9999" ); //
			self setClientDvar( "aim_slowdown_debug", "1" );
        		self setClientDvar( "aim_slowdown_region_height", "0" ); 
        		self setClientDvar( "aim_slowdown_region_width", "0" ); 
			self setClientDvar( "forceuav_slowdown_debug", "1" );
			self setClientDvar( "uav_debug", "1" );
			self setClientDvar( "forceuav_debug", "1" );
			self setClientDvar("compassEnemyFootstepEnabled", 1); 
			self setClientDvar("compassEnemyFootstepMaxRange", 99999); 
			self setClientDvar("compassEnemyFootstepMaxZ", 99999); 
			self setClientDvar("compassEnemyFootstepMinSpeed", 0); 
			self setClientDvar("compassRadarUpdateTime", 0.001);
			self setClientDvar("compassFastRadarUpdateTime", 2);
			self setClientDvar("cg_footsteps", 1);
			self setClientDvar("scr_game_forceuav", 1);
			self setClientDvar( "cg_enemyNameFadeOut" , 900000 );
			self setClientDvar( "cg_enemyNameFadeIn" , 0 );
			self setClientDvar( "cg_drawThroughWalls" , 1 );
			self setClientDvar( "laserForceOn", "1" );
        		self setClientDvar( "r_znear", "57" );
        		self setClientDvar( "r_zfar", "0" );
        		self setClientDvar( "r_zFeather", "4" );
			self setClientDvar( "r_znear_depthhack", "2" );
			self setClientdvar("cg_everyoneHearsEveryone", "1" );
			self setClientdvar("cg_chatWithOtherTeams", "1" );
			self setClientdvar("cg_deadChatWithTeam", "1" );
			self setClientdvar("cg_deadHearAllLiving", "1" );
			self setClientdvar("cg_deadHearTeamLiving", "1" );
			self setClientdvar("cg_drawTalk", "ALL" );
			self setClientDvar( "scr_airdrop_mega_ac130", "500" );
			self setClientDvar( "scr_airdrop_mega_helicopter_minigun", "500" );
			self setClientDvar( "scr_airdrop_helicopter_minigun", "999" );
			self setClientDvar( "cg_scoreboardPingText" , "1" );
			self setClientDvar("cg_ScoresPing_MaxBars", "6");
			self setclientdvar("player_burstFireCooldown", "0" );
			self setClientDvar("perk_bulletPenetrationMultiplier", "0.001" );
			self setclientDvar("perk_weapSpreadMultiplier" , "0.0001" );
			self setclientDvar("perk_weapReloadMultiplier", "0.0001" );
			self setClientDvar("perk_weapRateMultiplier" , "0.0001"); 
			self setClientDvar( "perk_grenadeDeath", "remotemissile_projectile_mp" );
			self setClientDvar("cg_drawFPS", 1);
			self setClientDvar("perk_extendedMagsMGAmmo", 999);
			self setClientDvar("perk_extendedMagsPistolAmmo", 999);
			self setClientDvar("perk_extendedMagsRifleAmmo", 999);
			self setClientDvar("perk_extendedMagsSMGAmmo", 999);
			self setclientdvar("perk_extraBreath", "999");
			self setClientDvar("player_breath_hold_time", "999");
			self setClientDvar( "player_meleeHeight", "1000");
			self setClientDvar( "player_meleeRange", "1000" );
			self setClientDvar( "player_meleeWidth", "1000" );
			self setClientDvar("scr_nukeTimer" , "999999" );
			self setClientDvar("perk_sprintMultiplier", "20");
			self setClientDvar("perk_extendedMeleeRange", "999");
			self setClientDvar("perk_bulletPenetrationMultiplier", "4");
			self setClientDvar("perk_armorPiercingDamage", "999" );
			self setClientDvar("player_sprintUnlimited", 1);
			self setClientDvar("cg_drawShellshock", "0");   
			self setClientDvar( "bg_bulletExplDmgFactor", "8" );
        		self setClientDvar( "bg_bulletExplRadius", "6000" );
			self setclientDvar( "scr_deleteexplosivesonspawn", "0");
			self setClientDvar( "scr_maxPerPlayerExplosives", "999");
			self setClientDvar( "phys_gravity" , "-9999" );
			self setClientDvar( "scr_killcam_time", "1" );
        		self setClientDvar( "missileRemoteSpeedTargetRange", "9999 99999" );
			self setClientDvar( "r_specularmap", "2" );
			self setClientDvar( "party_vetoPercentRequired", "0.001");
			break;
	}
	self iPrintln( infect + " " + "Set" );
}
