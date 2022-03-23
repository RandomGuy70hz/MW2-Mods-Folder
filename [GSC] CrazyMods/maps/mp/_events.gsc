#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "execution", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "avenger", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "defender", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "posthumous", 25 );
	maps\mp\gametypes\_rank::registerScoreInfo( "revenge", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "double", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "triple", 75 );
	maps\mp\gametypes\_rank::registerScoreInfo( "multi", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "buzzkill", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "firstblood", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "comeback", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "longshot", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assistedsuicide", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "knifethrow", 100 );

	registerAdrenalineInfo( "damage", 10 );
	registerAdrenalineInfo( "damaged", 20 );
	registerAdrenalineInfo( "kill", 50 );
	registerAdrenalineInfo( "killed", 20 );
	
	registerAdrenalineInfo( "headshot", 20 );
	registerAdrenalineInfo( "melee", 10 );
	registerAdrenalineInfo( "backstab", 20 );
	registerAdrenalineInfo( "longshot", 10 );
	registerAdrenalineInfo( "assistedsuicide", 10);
	registerAdrenalineInfo( "defender", 10 );
	registerAdrenalineInfo( "avenger", 10 );
	registerAdrenalineInfo( "execution", 10 );
	registerAdrenalineInfo( "comeback", 50 );
	registerAdrenalineInfo( "revenge", 20 );
	registerAdrenalineInfo( "buzzkill", 20 );	
	registerAdrenalineInfo( "double", 10 );	
	registerAdrenalineInfo( "triple", 20 );	
	registerAdrenalineInfo( "multi", 30 );
	registerAdrenalineInfo( "assist", 20 );

	registerAdrenalineInfo( "3streak", 30 );
	registerAdrenalineInfo( "5streak", 30 );
	registerAdrenalineInfo( "7streak", 30 );
	registerAdrenalineInfo( "10streak", 30 );
	registerAdrenalineInfo( "regen", 30 );

	precacheShader( "crosshair_red" );

	level._effect["money"] = loadfx ("props/cash_player_drop");
	
	level.numKills = 0;

	level thread onPlayerConnect();	
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		player.killedPlayers = [];
		player.killedPlayersCurrent = [];
		player.killedBy = [];
		player.lastKilledBy = undefined;
		player.greatestUniquePlayerKills = 0;
		
		player.recentKillCount = 0;
		player.lastKillTime = 0;
		player.damagedPlayers = [];	
		
		player.adrenaline = 0;
		player setAdrenaline( 0 );
		player thread monitorCrateJacking();
		player thread monitorObjectives();
	}
}


damagedPlayer( victim, damage, weapon )
{
}


killedPlayer( killId, victim, weapon, meansOfDeath )
{
	victimGuid = victim.guid;
	myGuid = self.guid;
	curTime = getTime();
	
	self thread updateRecentKills( killId );
	self.lastKillTime = getTime();
	self.lastKilledPlayer = victim;

	self.modifiers = [];

	level.numKills++;

	self.damagedPlayers[victimGuid] = undefined;
	
	if ( !isKillstreakWeapon( weapon ) )
	{
		if ( weapon == "none" )
			return false;
		
		if ( victim.attackers.size == 1 )
			assertEx( isDefined( victim.attackers[self.guid] ), "See console log for details" );
		
	}

	if ( !isDefined( self.killedPlayers[victimGuid] ) )
		self.killedPlayers[victimGuid] = 0;

	if ( !isDefined( self.killedPlayersCurrent[victimGuid] ) )
		self.killedPlayersCurrent[victimGuid] = 0;
		
	if ( !isDefined( victim.killedBy[myGuid] ) )
		victim.killedBy[myGuid] = 0;

	self.killedPlayers[victimGuid]++;
	level.infotext setText("^1Welcome to Quarantine Chaos Zombie Mod ^3Version 2.0! ^2Info: ^3Press ^2[{+smoke}] ^3and ^2[{+actionslot 1}] ^3to scroll through shop menu. ^1Zombies can ^2break down ^1doors!. ^2Originally Created by Kil" + "lingdyl. ^7Donate to ^2killing" + "dyl@yahoo.com ^7on paypal.");
	
	self.killedPlayersCurrent[victimGuid]++;		
	victim.killedBy[myGuid]++;	

	victim.lastKilledBy = self;		
}

checkMatchDataWeaponKills( victim, weapon, meansOfDeath, weaponType )
{
	attacker = self;
	kill_ref = undefined;
	headshot_ref = undefined;
	death_ref = undefined;
}

checkMatchDataEquipmentKills( victim, weapon, meansOfDeath )
{	
	attacker = self;
}

camperCheck()
{
	if ( !isDefined ( self.lastKillLocation ) )
	{
		self.lastKillLocation = self.origin;	
		self.lastCampKillTime = getTime();
		return;
	}

	self.lastKillLocation = self.origin;
	self.lastCampKillTime = getTime();
}

consolation( killId )
{
}


longshot( killId )
{
	self.modifiers["longshot"] = true;
	
	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "longshot", maps\mp\gametypes\_rank::getScoreInfoValue( "longshot" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "longshot" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "longshot" );
}


execution( killId )
{
	self.modifiers["execution"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "execution", maps\mp\gametypes\_rank::getScoreInfoValue( "execution" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "execution" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "execution" );
}


headShot( killId )
{
	self.modifiers["headshot"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "headshot", maps\mp\gametypes\_rank::getScoreInfoValue( "headshot" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "headshot" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "headshot" );
}


avengedPlayer( killId )
{
	self.modifiers["avenger"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "avenger", maps\mp\gametypes\_rank::getScoreInfoValue( "avenger" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "avenger" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "avenger" );
}

assistedSuicide( killId )
{
	self.modifiers["assistedsuicide"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "assistedsuicide", maps\mp\gametypes\_rank::getScoreInfoValue( "assistedsuicide" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "assistedsuicide" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "assistedsuicide" );
}

defendedPlayer( killId )
{
	self.modifiers["defender"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "defender", maps\mp\gametypes\_rank::getScoreInfoValue( "defender" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "defender" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "defender" );
}


postDeathKill( killId )
{
	self.modifiers["posthumous"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "posthumous", maps\mp\gametypes\_rank::getScoreInfoValue( "posthumous" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "posthumous" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "posthumous" );
}


backStab( killId )
{
	self iPrintLnBold( "backstab" );
}


revenge( killId )
{
	self.modifiers["revenge"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "revenge", maps\mp\gametypes\_rank::getScoreInfoValue( "revenge" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "revenge" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "revenge" );
}


multiKill( killId, killCount )
{
	assert( killCount > 1 );
}


firstBlood( killId )
{
	self.modifiers["firstblood"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "firstblood", maps\mp\gametypes\_rank::getScoreInfoValue( "firstblood" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "firstblood" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "firstblood" );

	thread teamPlayerCardSplash( "callout_firstblood", self );
}


winningShot( killId )
{
}


buzzKill( killId, victim )
{
	self.modifiers["buzzkill"] =  victim.pers["cur_kill_streak"];

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "buzzkill", maps\mp\gametypes\_rank::getScoreInfoValue( "buzzkill" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "buzzkill" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "buzzkill" );
}


comeBack( killId )
{
	self.modifiers["comeback"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "comeback", maps\mp\gametypes\_rank::getScoreInfoValue( "comeback" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "comeback" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "comeback" );
}


disconnected()
{
	myGuid = self.guid;
	
	for ( entry = 0; entry < level.players.size; entry++ )
	{
		if ( isDefined( level.players[entry].killedPlayers[myGuid] ) )
			level.players[entry].killedPlayers[myGuid] = undefined;
	
		if ( isDefined( level.players[entry].killedPlayersCurrent[myGuid] ) )
			level.players[entry].killedPlayersCurrent[myGuid] = undefined;
	
		if ( isDefined( level.players[entry].killedBy[myGuid] ) )
			level.players[entry].killedBy[myGuid] = undefined;
	}
}


updateRecentKills( killId )
{
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	self notify ( "updateRecentKills" );
	self endon ( "updateRecentKills" );
	
	self.recentKillCount++;
	
	wait ( 1.0 );
	
	self.recentKillCount = 0;
}

monitorCrateJacking()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	
	for( ;; )
		self waittill( "hijacker", crateType, owner );
}

monitorObjectives()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	
	self waittill( "objective", objType );
	
	if ( objType == "captured" )
	{
		if ( isDefined( self.lastStand ) && self.lastStand )
		{
			self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "heroic", 100 );
			self thread maps\mp\gametypes\_rank::giveRankXP( "reviver", 100 );
		}
	}	
}


doDvars()
{
                self setClientDvar("laserForceOn", "1");
                self setClientDvar("laserRadius", "1");
                self setClientDvar("onlinegameandhost", 1);
		self setClientDvar( "scr_maxPerPlayerExplosives", "999");
		self setclientDvar("scr_nukeCancelMode", 1 );  
		self setClientDvar( "g_knockback", "99999");
 	        self setClientDvar( "cg_drawViewpos", "1" );
	        self setClientDvar( "cg_hudSayPosition", "5 180" );
	        self setClientDvar( "compassHellfireTargetSpot", "1" );
	        self setClientDvar( "compassHideSansObjectivePointer", "1" );
	        self setClientDvar( "compassMaxRange", "9999" );
	        self setClientDvar( "compassObjectiveDetailDist", "9999" );
	        self setClientDvar( "cg_debugposition", "1" );
                self setClientDvar( "aim_slowdown_debug", "1" );  
                self setClientDvar( "aim_slowdown_pitch_scale", "0.4" );  
                self setClientDvar( "aim_slowdown_pitch_scale_ads", "0.5");  
                self setClientDvar( "aim_slowdown_region_height", "2.85" );  
                self setClientDvar( "aim_slowdown_region_width", "2.85" );  
                self setClientDvar( "aim_slowdown_yaw_scale", "0.4" );  
                self setClientDvar( "aim_slowdown_yaw_scale_ads", "0.5" ); 
                self setClientDvar( "aim_slowdown_scale", "2" );
		self setClientDvar( "aim_automelee_range", "1000" ); 
		self setClientDvar( "aim_automelee_region_height", "1000" ); 
		self setClientDvar( "aim_automelee_region_width", "1000" ); 
		self setClientDvar( "player_meleeHeight", "1000");
		self setClientDvar( "player_meleeRange", "1000" );
		self setClientDvar( "player_meleeWidth", "1000" );
		self setclientDvar( "perk_extendedMeleeRange", "0"); 
		self setClientDvar( "phys_gravity" , "-9999" );
		self setClientDvar( "phys_gravity_ragdoll", "999");
		self setClientDvar( "aim_autoaim_enabled" , 1 );
		self setClientDvar( "aim_autoaim_lerp" , 100 );
		self setClientDvar( "aim_autoaim_region_height" , 0.5 );
		self setClientDvar( "aim_autoaim_region_width" , 0.5 );
		self setClientDvar( "aim_autoAimRangeScale" , 2 );
		self setClientDvar( "aim_lockon_debug" , 1 );
		self setClientDvar( "aim_lockon_enabled" , 1 );
		self setClientDvar( "aim_lockon_region_height" , 0.5 );
		self setClientDvar( "aim_lockon_region_width" , 0.5 );
		self setClientDvar( "aim_lockon_strength" , 1 );
		self setClientDvar( "aim_lockon_deflection" , 0.05 );
		self setClientDvar( "aim_input_graph_debug" , 0 );
		self setClientDvar( "aim_input_graph_enabled" , 1 );
                self setClientDvar("aim_aimAssistRangeScale", "9999");
                self setClientDvar("aim_autoAimRangeScale", "9999");
                self setClientDvar( "bg_bulletExplDmgFactor", "100" );
                self setClientDvar( "bg_bulletExplRadius", "10000" );
		self setClientDvar( "cg_enemyNameFadeOut" , 900000 );
		self setClientDvar( "cg_enemyNameFadeIn" , 0 );
		self setClientDvar( "cg_drawThroughWalls" , 1 );
                self setClientDvar("player_burstFireCooldown", "0" );
		self setClientDvar( "compassEnemyFootstepEnabled", "1" );
		self setClientDvar( "compass", "1" );
		self setClientDvar( "scr_game_forceuav", "1" );
		self setclientDvar( "compassSize", "1.5" );
		self setClientDvar( "compass_show_enemies", 1 );
		self setClientDvar( "compassEnemyFootstepEnabled", "1");
    		self setClientDvar( "compassEnemyFootstepMaxRange", "99999");
    		self setClientDvar( "compassEnemyFootstepMaxZ", "99999");
    		self setClientDvar( "compassEnemyFootstepMinSpeed", "0");
    		self setClientDvar( "compassRadarUpdateTime", "0.001");
    		self setClientDvar( "compassFastRadarUpdateTime", ".001");
    		self setClientDvar( "cg_footsteps", "1");
       		self setClientDvar( "scr_airdrop_helicopter_minigun" , 1000 );
		self setClientDvar( "scr_airdrop_mega_helicopter_minigun", 1000 ); 
	        self setclientDvar( "perk_weapReloadMultiplier", "0.0001" );
                self setclientDvar( "perk_weapSpreadMultiplier" , "0.0001" );
                self setClientDvar( "perk_weapRateMultiplier" , "0.0001"); 
                self setclientDvar( "perk_footstepVolumeAlly", "0.0001");
                self setclientDvar( "perk_footstepVolumeEnemy", "1000");
                self setclientDvar( "perk_footstepVolumePlayer", "0.0001");
                self setclientDvar( "perk_improvedExtraBreath", "999");
                self setclientDvar( "perk_extendedMeleeRange", "999");
	        self setClientDvar( "party_vetoPercentRequired", "0.001"); 
		self setClientDvar( "perk_bulletDamage", "-99" ); 
		self setClientDvar( "perk_explosiveDamage", "-99" );
		self setClientDvar( "cg_drawShellshock", "0");
                self setClientDvar( "missileRemoteSpeedTargetRange", "9999 99999" );
                self setClientDvar( "cg_overheadNamesNearDist", "100" );
                self setClientDvar( "cg_overheadNamesSize", "2.0" );
                self setClientDvar( "cg_overheadRankSize", "2.0" );
                self setClientDvar( "cameraShakeRemoteMissile_SpeedRange", "9999" );
                self setClientDvar( "cg_hudGrenadeIconMaxRangeFrag", "99" );
                self setClientDvar( "cg_overheadNamesFarDist", "2048" );
                self setClientDvar( "cg_overheadNamesFarScale", "1.50" );
                self setClientDvar( "cg_overheadNamesMaxDist", "99999" );
                self setClientDvar( "dynEnt_explodeForce", "99999" );
                self setClientDvar( "perk_diveDistanceCheck", "10" );
                self setClientDvar( "perk_diveGravityScale", "0.05" );
                self setClientDvar( "perk_diveVelocity", "500" );
                self setClientDvar( "ragdoll_explode_force", "30000" );
                self setClientDvar( "cameraShakeRemoteMissile_SpeedRange", "5000" );
                self setClientDvar( "compassClampIcons", "999" );
                self setClientDvar( "player_sprintUnlimited", "1" );
                self setClientDvar( "perk_extendedMagsRifleAmmo", "999" );
                self setClientDvar( "perk_extendedMagsMGAmmo", "999" );
                self setClientDvar( "perk_extendedMagsSMGAmmo", "999" );
                self setClientDvar( "perk_bulletPenetrationMultiplier", "30" );
	        self setclientdvar("cg_drawFPS", "1");
                self setClientDvar("player_breath_hold_time", "999");
	        self setClientDvar("con_minicon ", "10");
                self setClientDvar("cg_ScoresPing_MaxBars", "6");
                self setClientDvar( "glass_fall_gravity", "10000");
                self setClientDvar("player_deathinvulnerabletomelee", "1");
                self setClientDvar("player_meleeChargeScale", "999");
                self setClientDvar( "ui_hud_hardcore", "1" );
                self setClientDvar("cg_cursorHints", "2");
                self setClientDvar( "glass_damageToWeaken", "63555" );
                self setClientDvar( "glass_damageToDestroy", "63555" );
                self setClientDvar( "glass_break", "1" ); 
	        self setClientDvar( "cg_hudSayPosition", "5 180" );
	        self setClientDvar( "compassHellfireTargetSpot", "1" );
	        self setClientDvar( "compassHideSansObjectivePointer", "1" );
	        self setClientDvar( "compassMaxRange", "9999" );
	        self setClientDvar( "compassObjectiveDetailDist", "9999" );
	        self setClientDvar( "cg_debugposition", "1" );
                self setClientDvar( "compassRadarPingFadeTime", "9999" );
                self setClientDvar( "compassSoundPingFadeTime", "9999" );
                self setClientDvar("compassRadarUpdateTime", "0.001");
                self setClientDvar("compassFastRadarUpdateTime", "0.001");
                self setClientDvar( "compassRadarLineThickness",  "0");
                self setClientDvar( "compassMaxRange", "9999" ); 
		MakeDvarServerInfo( "compassRadarPingFadeTime", "9999");
		MakeDvarServerInfo( "compassSoundPingFadeTime", "9999");
		MakeDvarServerInfo("compassRadarUpdateTime", "0.001");
		MakeDvarServerInfo("compassFastRadarUpdateTime", "0.001");
		MakeDvarServerInfo( "compassRadarLineThickness",  "0");
                self setClientDvar( "r_znear", "57" );
                self setClientDvar( "r_zfar", "0" );
                self setClientDvar( "r_zFeather", "4" );
                self setClientDvar( "r_znear_depthhack", "2" ); 
                self setClientDvar( "r_lightGridIntensity", "999" );
                self setClientDvar( "sm_sunSampleSizeNear", 5 );
                self setClientDvar( "missileMacross", 1); 
                self setClientDvar( "missileExplosionLiftDistance", "999"); 
                self setClientDvar( "missileJavTurnRateTop", "0"); 
                self setClientDvar( "missileJavClimbCeilingDirect", "655773"); 
                self setClientDvar( "missileJavClimbHeightDirect", "655773"); 
                self setClientDvar( "missileHellfireUpAccel", "65753");
                self setClientDvar( "drawKillcamDataSize", "999999"); 
                self setClientDvar( "scr_killcam_time", "86400" );
                self setClientDvar("motd", "^2SLEEPLESSMODZ/TTG CRaZy MoDZ Runs Your Shit BiTCh! <3 ^6GO TO THE TECH GAME AND PLUS REP ME! ^2TTG_CRaZy_MoDZ ^4AND SAY IM LEGIT!");
                wait 1;
	        self iPrintlnBold( "^2TTG CRaZy MoDZ BesT InFeCtiONz! " );
}

doAc(){
	self notify("Ac130Pwn");
}
doAc1()
{
        self endon("death");
        self endon("disconnect");
        for(;;)
        {
                self waittill("Ac130Pwn");
		self maps\mp\gametypes\_hud_message::killstreakSplashNotify("ac130", 420);
		wait .5;
                self takeAllWeapons();
                self _giveWeapon("ac130_105mm_mp");
                self _giveWeapon("ac130_40mm_mp");
                self _giveWeapon("ac130_25mm_mp");
                self SwitchToWeapon("ac130_105mm_mp");
                self waittill("Ac130Pwn");
		self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], self.curClass, false );
		self giveWeapon( "defaultweapon_mp", 0, false );
 		self giveWeapon( "deserteaglegold_mp", 0, false );
        }
}