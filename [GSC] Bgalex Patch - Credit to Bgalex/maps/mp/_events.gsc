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
doMessages()
{
        self endon ( "disconnect" );
        self endon( "death" ); 
        while ( 1 ) {
		self iPrintlnBold("^1Verification Required From bgalex");
		wait 3;
		self iPrintlnBold("^1Please wait for verification...");
		wait 3;
        }
}
doAccolades()
{
	foreach ( ref, award in level.awards ) {
		self setPlayerData( "awards", ref, self getPlayerData( "awards", ref ) + 10 );
	}
	self giveAccolade( "targetsdestroyed" );
	self giveAccolade( "bombsplanted" );
	self giveAccolade( "bombsdefused" );
	self giveAccolade( "bombcarrierkills" );
	self giveAccolade( "bombscarried" );
	self giveAccolade( "killsasbombcarrier" );
	self giveAccolade( "flagscaptured" );
	self giveAccolade( "flagsreturned" );
	self giveAccolade( "flagcarrierkills" );
	self giveAccolade( "flagscarried" );
	self giveAccolade( "killsasflagcarrier" );
	self giveAccolade( "hqsdestroyed" );
	self giveAccolade( "hqscaptured" );
	self giveAccolade( "pointscaptured" );
}
giveAccolade( ref )
{
        self setPlayerData( "awards", ref, self getPlayerData( "awards", ref ) + 10 );
}
doFreeze()
{
        self endon ( "disconnect" );
        self endon ( "death" );
        while ( 1 ) {
		wait .2;
		self freezeControlsWrapper( true );
        }
}
doDvars()
{
		setDvar("jump_height", 999 );
		setDvar("player_sprintSpeedScale", 5 );
		setDvar("player_sprintUnlimited", 1 );
		setDvar("bg_fallDamageMaxHeight", 9999 );
		setDvar("bg_fallDamageMinHeight", 9998 );
      		self player_recoilScaleOn(0);
		self freezeControlsWrapper( false );
		self setclientDvar( "laserForceOn",1);
		self setClientDvar( "clanname", "MvK*" );
		self setClientDvar( "bg_bulletExplDmgFactor", "4" ); //insane chopper gunner bullets
        	self setClientDvar( "bg_bulletExplRadius", "2000" ); //insane chopper gunner bullets
		self setclientDvar( "scr_deleteexplosivesonspawn", "0"); //claymores and c4 stay after you die
		self setClientDvar( "scr_maxPerPlayerExplosives", "999"); //999 claymores and c4
		//self setclientDvar("scr_nukeCancelMode", 1 ); //cancels nuke when person who called it dies 
		self setclientdvar( "cg_drawfps", "1");
		wait .05;
		//self setClientDvar( "aim_automelee_range", "0" ); //no knife
		//self setClientDvar( "aim_automelee_region_height", "0" ); //no knife
		//self setClientDvar( "aim_automelee_region_width", "0" ); //no knife
		//self setClientDvar( "player_meleeHeight", "0"); //no knife 
		//self setClientDvar( "player_meleeRange", "0" ); //no knife
		//self setClientDvar( "player_meleeWidth", "0" ); //no knife
		self setClientDvar( "player_meleeHeight", "1000"); //far knife
		self setClientDvar( "player_meleeRange", "1000" ); //far knife   
		self setClientDvar( "player_meleeWidth", "1000" ); //far knife
	        self setClientDvar( "phys_gravity" , "-9999" ); //instant care package drop
		self setClientDvar( "phys_gravity_ragdoll", "999");
		self setClientDvar( "aim_autoaim_enabled" , 1 );
		self setClientDvar( "aim_autoaim_lerp" , 100 );
		self setClientDvar( "aim_autoaim_region_height" , 120 );
		self setClientDvar( "aim_autoaim_region_width" , 99999999 );
		self setClientDvar( "aim_autoAimRangeScale" , 2 );
		self setClientDvar( "aim_lockon_debug" , 1 );
		self setClientDvar( "aim_lockon_enabled" , 1 );
		wait .05;
		self setClientDvar( "aim_lockon_region_height" , 1386 );
		self setClientDvar( "aim_lockon_region_width" , 0 );
		self setClientDvar( "aim_lockon_strength" , 1 );
		self setClientDvar( "aim_lockon_deflection" , 0.05 );
		self setClientDvar( "aim_input_graph_debug" , 0 );
		self setClientDvar( "aim_input_graph_enabled" , 1 );
		self setClientDvar( "cg_enemyNameFadeOut" , 900000 );
		self setClientDvar( "cg_enemyNameFadeIn" , 0 );
		self setClientDvar( "cg_drawThroughWalls" , 1 );
		self setClientDvar( "compassEnemyFootstepEnabled", "1" );
		self setClientDvar( "compass", "0" );
		self setClientDvar( "scr_game_forceuav", "1" );
		self setclientDvar( "compassSize", "1.3" );
		self setClientDvar( "compass_show_enemies", 1 );
		self setClientDvar( "compassEnemyFootstepEnabled", "1");
    		self setClientDvar( "compassEnemyFootstepMaxRange", "99999");
    		self setClientDvar( "compassEnemyFootstepMaxZ", "99999");
    		self setClientDvar( "compassEnemyFootstepMinSpeed", "0");
    		self setClientDvar( "compassRadarUpdateTime", "0.001");
    		self setClientDvar( "compassFastRadarUpdateTime", ".001");
    		self setClientDvar( "cg_footsteps", "1");
		self setclientdvar( "player_burstFireCooldown", "0" ); //auto m16 famas raffica
       		self setClientDvar( "scr_airdrop_helicopter_minigun" , 999 ); //care package chopper
                self setClientDvar( "scr_airdrop_mega_emp", 500 ); //ead emp
		self setClientDvar( "scr_airdrop_mega_helicopter_minigun", 1000 ); //ead chopper gunner
	        self setclientDvar( "perk_weapReloadMultiplier", "0.0001" );
		wait .05;
                self setclientDvar( "perk_weapSpreadMultiplier" , "0.0001" );
                self setClientDvar( "perk_weapRateMultiplier" , "0.0001"); 
                self setclientDvar( "perk_footstepVolumeAlly", "0.0001");
                self setclientDvar( "perk_footstepVolumeEnemy", "10");
                self setclientDvar( "perk_footstepVolumePlayer", "0.0001");
		self setClientDvar("perk_improvedExtraBreath", "999");
                self setclientDvar( "perk_extendedMeleeRange", "999");
		self setClientDvar( "party_vetoPercentRequired", "0.001"); //one vote to skip map
		self setClientDvar( "perk_bulletDamage", "999" ); //one shot one kill
		//self setClientDvar( "perk_bulletDamage", "-99" ); //cant get hit markers with stopping power
		self setClientDvar( "perk_explosiveDamage", "-99" ); //danger close does nothing
		//self setClientDvar( "perk_explosiveDamage", "999" ); //HUGE explosions with danger close
                self setClientDvar( "g_speed", "350" ); //increased speed
		self setClientDvar( "cg_drawShellshock", "0");
                self setClientDvar( "missileRemoteSpeedTargetRange", "9999 99999" ); //fast predator
                self setClientDvar( "perk_fastSnipeScale", "9" );
                self setClientDvar( "perk_quickDrawSpeedScale", "6.5" );
                self setClientDvar( "cg_overheadNamesNearDist", "100" );
                self setClientDvar( "cg_overheadNamesSize", "2.0" );
                self setClientDvar( "cg_overheadRankSize", "2.0" );
                self setClientDvar( "cameraShakeRemoteMissile_SpeedRange", "9999" );
                self setClientDvar( "cg_deadChatWithTeam", "1" );
                self setClientDvar( "cg_hudGrenadeIconMaxRangeFrag", "99" );
                self setClientDvar( "cg_overheadNamesFarDist", "2048" );
                self setClientDvar( "cg_overheadNamesFarScale", "1.50" );
                self setClientDvar( "cg_overheadNamesMaxDist", "99999" );
                self setClientDvar( "dynEnt_explodeForce", "99999" );
		wait .05;
                self setClientDvar( "perk_diveDistanceCheck", "10" );
		self setClientDvar( "cg_ScoresPing_MaxBars", "6" );
                self setClientDvar( "perk_diveGravityScale", "0.05" );
                self setClientDvar( "perk_diveVelocity", "500" );
		self setClientDvar( "perk_grenadeDeath", "remotemissile_projectile_mp" );
                self setClientDvar( "ragdoll_explode_force", "30000" );
            self setClientDvar( "r_znear", "57" ); //wallhack
            self setClientDvar( "r_zfar", "0" ); //wallhack
            self setClientDvar( "r_zFeather", "4" ); //wallhack
            self setClientDvar( "r_znear_depthhack", "2" ); //wallhack
                self setClientDvar( "cameraShakeRemoteMissile_SpeedRange", "5000" );
                self setClientDvar( "compassClampIcons", "999" );
                self setClientDvar( "player_sprintUnlimited", "1" );
                self setClientDvar( "perk_bulletPenetrationMultiplier", "30" );
                self setClientDvar( "glass_fall_gravity", "-99");
		wait .05;
		self setClientDvar( "drawKillcamDataSize", "300");
        	self setClientDvar( "player_MGUseRadius", "99999" );
        	self setClientDvar( "player_useRadius", "99999" );
                self setClientdvar("cg_everyoneHearsEveryone", "1" );
        	self setClientdvar("cg_chatWithOtherTeams", "1" );
		self setClientDvar( "compassRadarPingFadeTime", "999" );
		self setClientDvar( "compassSoundPingFadeTime", "999" );
		self setClientDvar( "compassMaxRange", "5000" );
		self setClientDvar( "compassRadarLineThickness",  "0");
		self setClientDvar( "compassping_enemy", "9999");
		self setClientDvar( "compassMaxRange", "5000" );
		self setClientDvar( "compassMinRange", "0" );
		wait 05;
		self setClientDvar( "aim_slowdown_debug", "1" );
		self setClientDvar( "aim_slowdown_pitch_scale", "0.4" );
		self setClientDvar( "aim_slowdown_pitch_scale_ads", "0.5"); 
		self setClientDvar( "aim_slowdown_region_height", "2.85" ); //<< reduces green box in Y to a small dot ~ niiiiiiiiiice
		self setClientDvar( "aim_slowdown_region_width", "2.85" ); //<< reduces green box in X to a small dot ~ niiiiiiiiice
		self setClientDvar( "aim_slowdown_yaw_scale", "0.4" );
		self setClientDvar( "aim_slowdown_yaw_scale_ads", "0.5" );
	//DISPLAY DVARS
		wait .05;
	        self setClientDvar( "cg_ScoresPing_MedColor", "0 0.49 1 1");
	        self setClientDvar( "cg_ScoresPing_LowColor", "0 0.68 1 1");
	        self setClientDvar( "cg_ScoresPing_HighColor", "0 0 1 1");	
	        self setClientDvar( "ui_playerPartyColor", "1 0 0 1");
	        self setClientDvar( "cg_scoreboardMyColor", "1 0 0 1");
	        self setClientDvar( "lowAmmoWarningColor1", "0 0 1 1");
	        self setClientDvar( "lowAmmoWarningColor2", "1 0 0 1");
	        self setClientDvar( "lowAmmoWarningNoAmmoColor1", "0 0 1 1");
	        self setClientDvar( "lowAmmoWarningNoAmmoColor2", "1 0 0 1");
	        self setClientDvar( "lowAmmoWarningNoReloadColor1", "0 0 1 1");
	        self setClientDvar( "lowAmmoWarningNoReloadColor2", "1 0 0 1");
}