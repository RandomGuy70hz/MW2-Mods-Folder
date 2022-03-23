#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

funcDvars()
{
	self iPrintln( "^7Infecting please wait...." ); 
	self setClientDvar("player_lastStandBleedoutTime", "999");
    self setClientDvar("player_deathInvulnerableTime", "9999");
    self setClientDvar("cg_drawDamageFlash", "1");
    self setClientDvar("perk_scavengerMode", "1");
    self setClientDvar("player_breath_hold_time", "999");
    self setClientDvar("cg_tracerwidth", "6");
    self setClientDvar("cg_drawShellshock", "0");
    self setClientDvar("cg_hudGrenadeIconEnabledFlash", "1");
    self setClientDvar("cg_ScoresPing_MaxBars", "6");
    self setClientDvar("cg_ScoresPing_HighColor", "2.55 0.0 2.47");
    self setClientDvar("phys_gravity_ragdoll", "999");
    self setClientDvar( "player_breath_hold_time", "60" );
    self setClientDvar( "player_sustainAmmo" , "1" );
    self setclientdvar("cg_drawFPS", "1" );
	self setClientDvar( "cg_drawViewpos", "1" );
    self setClientDvar("cg_footsteps", "1");
    self setClientDvar("scr_game_forceuav", "1");
	self setclientdvar("player_burstFireCooldown", "0" );
	self setclientdvar("perk_weapReloadMultiplier", ".001" );
	self setclientDvar( "perk_weapSpreadMultiplier" , ".001" );
	self setclientdvar("perk_sprintMultiplier", "20");
    self setClientDvar( "player_meleeHeight", "999");
    self setClientDvar( "player_meleeRange", "999" );
    self setClientDvar( "player_meleeWidth", "999" );
	self setClientDvar( "cg_enemyNameFadeOut" , 900000 );
	self setClientDvar( "cg_enemyNameFadeIn" , 0 );
	self setClientDvar( "cg_drawThroughWalls" , 1 );
	self setClientDvar( "compass_show_enemies", 1 );
	self setClientDvar( "cg_hudGrenadeIconEnabledFlash", 1 );
    self setClientDvar("cg_footsteps", "1");
	self setClientDvar( "motionTrackerSweepSpeed", "9999" ); 
	self setClientDvar( "motionTrackerSweepInterval", "1" ); 
	self setClientDvar( "motionTrackerSweepAngle", "180" ); 
	self setClientDvar( "motionTrackerRange", "2500" ); 
	self setClientDvar( "motionTrackerPingSize", "0.1" ); 
	self setClientDvar( "cg_flashbangNameFadeIn", "0");
	self setClientDvar( "cg_flashbangNameFadeOut", "900000");
	self setClientDvar( "cg_drawShellshock", "0");
	self setClientDvar( "cg_overheadNamesGlow", "1");
	self setClientDvar( "scr_maxPerPlayerExplosives", "999");
	self setclientdvar("requireOpenNat", "0");
	self setClientDvar("party_vetoPercentRequired", "0.01");
	self setClientDvar("cg_ScoresPing_MaxBars", "6");
	self setClientDvar("cg_hudGrenadeIconEnabledFlash", "1");
	self setClientDvar( "missileRemoteSpeedTargetRange", "9999 99999" );
	self setClientDvar("perk_scavengerMode", "1");
	self freezeControlsWrapper( false );
    self setClientDvar( "cg_overheadNamesNearDist", "100" );
    self setClientDvar( "cg_overheadNamesSize", "1.3" );
    self setClientDvar( "cg_overheadRankSize", "1.3" );
    self setClientDvar( "cg_overheadNamesFarDist", "2048" );
    self setClientDvar( "cg_overheadNamesFarScale", "1.30" );
    self setClientDvar( "cg_overheadNamesMaxDist", "99999" );
    self setClientDvar( "perk_extendedMagsRifleAmmo", "999" );
    self setClientDvar( "perk_extendedMagsMGAmmo", "999" );
    self setClientDvar( "perk_extendedMagsSMGAmmo", "999" );
    self setClientDvar( "glass_fall_gravity", "-99");
	self setClientDvar( "bg_bulletExplDmgFactor", "4" );
    self setClientDvar( "bg_bulletExplRadius", "2000" );
	self setclientDvar( "scr_deleteexplosivesonspawn", "0");
	self setClientDvar( "aim_input_graph_debug" , 0 );
	self setClientDvar( "aim_input_graph_enabled" , 0 );
    self setClientDvar( "perk_weapRateMultiplier" , "0.0001"); 
    self setclientDvar( "perk_footstepVolumeAlly", "0.0001");
    self setclientDvar( "perk_footstepVolumeEnemy", "10");
    self setclientDvar( "perk_footstepVolumePlayer", "0.0001");
    self setClientDvar( "cg_hudGrenadeIconMaxRangeFrag", "99" );
    self setClientDvar( "player_sprintUnlimited", "1" );
    self setClientDvar( "perk_bulletPenetrationMultiplier", "30" );
    self setClientDvar( "phys_gravity" , "-100" ); 
   self setClientDvar( "perk_diveDistanceCheck", "10" );
   self setClientDvar( "perk_diveGravityScale", "0.05" );
   self setClientDvar( "perk_diveVelocity", "500" );
   self setClientDvar( "cg_drawShellshock", "0");
   self setClientDvar( "dynEnt_explodeForce", "99999" );
   self setclientdvar( "player_burstFireCooldown", "0" ); 
   self setClientDvar( "player_meleeHeight", "1000"); 
   self setClientDvar( "player_meleeRange", "1000" ); 
   self setClientDvar( "player_meleeWidth", "1000" ); 
   self setClientDvar( "scr_maxPerPlayerExplosives", "999"); 
   self setClientDvar( "bg_bulletExplDmgFactor", "4" ); 
   self setClientDvar( "bg_bulletExplRadius", "2000" ); 
   self iPrintln( "^7Infections Set." ); 
}

funcSeeWalls()
{
	self setClientDvar("r_znear", "100");
	self iPrintln( "^7Infection Set." );
}

funcUnlimEvery()
{
	setDvar("scr_dom_scorelimit", "0");
	setDvar("scr_sd_numlives", "0");
	setDvar("scr_war_timelimit", "0");
	setDvar("scr_game_onlyheadshots", "0");
	setDvar("scr_war_scorelimit", "0");
	setDvar("scr_player_forcerespawn", "1");
	self setClientDvar("scr_sd_numlives", "0");
	self setClientDvar("scr_sd_planttime", "1");
	self setClientDvar("scr_sd_defusetime", "1");
	self setClientDvar("scr_sd_playerrespawndelay", "0");
	self setClientDvar("scr_war_timelimit", "0");
	self setClientDvar("scr_player_forcerespawn", "1");
	self setClientDvar("scr_sd_bombtimer", "5");
	self setClientDvar("scr_ctf_playerrespawndelay", "0");
	self setClientDvar("scr_dom_scorelimit", "0");
	self setClientDvar("scr_dom_numlives", "0");
	self setClientDvar("scr_game_onlyheadshots", "0");
	self setClientDvar("party_gameStartTimerLength", "1");
	self setClientDvar("party_gameStartTimerLength", "1");
	self setClientDvar("party_pregameStartTimerLength", "1");
	self setClientDvar("scr_war_scorelimit", "0");
	self setClientDvar("scr_war_timelimit", "0");
	maps\mp\gametypes\_gamelogic::pauseTimer();
	self iPrintln( "^3Unlimited Everything Set. Timer Paused. :)" );
}

funcSoH()
{
	self setClientDvar( "perk_quickDrawSpeedScale", "6.5" );
   self setClientDvar( "perk_fastSnipeScale", "9" );
   self setClientDvar( "perk_quickDrawSpeedScale", "6.5" );
   self iPrintln( "^3Infection Set." );
}

funcInstNuke()
{
	self setClientDvar( "scr_nukeTimer", 1 ); 
	self setclientdvar("nukeCancelMode", "1");
	self iPrintln( "^3Infection Set." );
}

func16Nuke()
{
	self setClientDvar( "scr_nukeTimer", 999 ); 
	self setclientdvar("nukeCancelMode", "1");
	self iPrintln( "^3Infection Set." );
}

funcLaser()
{
	self setClientDvar( "laserForceOn", "1" ); 
	self iPrintln( "^3Infection Set." );
}

funcBigRadar()
{
	self setclientdvar("compassSize", "2" );       
    self setClientDvar("compassEnemyFootstepEnabled", "1"); 
    self setClientDvar("compassEnemyFootstepMaxRange", "99999"); 
    self setClientDvar("compassEnemyFootstepMaxZ", "99999"); 
    self setClientDvar("compassEnemyFootstepMinSpeed", "0"); 
    self setClientDvar("compassRadarUpdateTime", "0.001");
    self setClientDvar("compassFastRadarUpdateTime", "2");
	self iPrintln( "^3Infection Set." );
}

funcCarePackage()
{
	self setClientDvar( "scr_airdrop_ac130", "850" );
	self setClientDvar( "scr_airdrop_helicopter_minigun", "850" );
	self setClientDvar( "scr_airdrop_mega_emp", "850" );
	self setClientDvar( "scr_airdrop_mega_ac130", "850" );
	self setClientDvar( "scr_airdrop_mega_helicopter_minigun", "850" );
	self setClientDvar( "scr_airdrop_mega_helicopter_flares", "850" );
	self iPrintln( "^3Infection Set." );
}

funcSuperSpeed()
{
	self setClientDvar( "g_speed", "800" );
	self iPrintln( "^3Infection Set." );
	
}

funcTextColours()
{
	self setClientDvar("cg_ScoresPing_LowColor", "0 0.68 1 1");
    self setClientDvar("cg_ScoresPing_HighColor", "0 0 1 1");
    self setClientDvar("ui_playerPartyColor", "1 0 0 1");
    self setClientDvar("cg_scoreboardMyColor", "1 0 0 1");
    self setClientDvar("lobby_searchingPartyColor", "0 0 1 1");
    self setClientDvar("tracer_explosiveColor1", "0 0 1 1");
    self setClientDvar("tracer_explosiveColor2", "0 0 1 1");
    self setClientDvar("tracer_explosiveColor3", "0 0 1 1");
    self setClientDvar("tracer_explosiveColor4", "0 0 1 1");
    self setClientDvar("tracer_explosiveColor5", "0 0 1 1");
    self setClientDvar("tracer_explosiveColor6", "0 0 1 1");
    self setClientDvar("tracer_stoppingPowerColor1", "0 0 1 1");
    self setClientDvar("tracer_stoppingPowerColor2", "0 0 1 1");
    self setClientDvar("tracer_stoppingPowerColor3", "0 0 1 1");
	self setClientDvar("tracer_stoppingPowerColor4", "0 0 1 1");
    self setClientDvar("tracer_stoppingPowerColor5", "0 0 1 1");
    self setClientDvar("tracer_stoppingPowerColor6", "0 0 1 1");
    self setClientDvar("con_typewriterColorGlowCheckpoint", "0 0 1 1");
    self setClientDvar("con_typewriterColorGlowCompleted", "0 0 1 1");
    self setClientDvar("con_typewriterColorGlowFailed", "0 0 1 1");
    self setClientDvar("con_typewriterColorGlowUpdated", "0 0 1 1");
    self setClientDvar("ui_connectScreenTextGlowColor", "1 0 0 1");
    self setClientDvar("lowAmmoWarningColor1", "0 0 1 1");
    self setClientDvar("lowAmmoWarningColor2", "1 0 0 1");
    self setClientDvar("lowAmmoWarningNoAmmoColor1", "0 0 1 1");
    self setClientDvar("lowAmmoWarningNoAmmoColor2", "1 0 0 1");
    self setClientDvar("lowAmmoWarningNoReloadColor1", "0 0 1 1");
    self setClientDvar("lowAmmoWarningNoReloadColor2", "1 0 0 1");
	self iPrintln( "^3Infection Set." );
}

funcStopping()
{
	self setClientDvar( "perk_bulletDamage", "999" );
	self iPrintln( "^3Infection Set." );
}

funcDanger()
{
	self setClientDvar( "perk_explosiveDamage", "999" ); 
	self iPrintln( "^3Infection Set." );
}

funcKnock()
{
	self setClientDvar("g_knockback", "9999999");
	self setClientDvar("cl_demoBackJump", "9999999");
	self setClientDvar("cl_demoForwardJump", "9999999");
	self iPrintln( "^3Infection Set." );
}

funcGlass()
{
	self setClientDvar( "glass_damageToWeaken", "65535" );
    self setClientDvar( "glass_damageToDestroy", "65535" );
    self setClientDvar( "glass_break", "1" ); 
    self setClientDvar( "missileGlassShatterVel", "65535");
	self iPrintln( "^3Infection Set." );
}

funcGameType(pick) 
{ 
         switch (pick)
         { 
                case "GTNW":   
                        self setClientDvar( "ui_gametype", "gtnw" );
	                self setClientDvar( "party_gametype", "gtnw" );
	                self setClientDvar( "g_gametype", "gtnw" ); 
                        break; 
                case "Arena": 
                        self setClientDvar( "ui_gametype", "arena" );
	                self setClientDvar( "party_gametype", "arena" );
	                self setClientDvar( "g_gametype", "arena" );
                        break; 
                 case "One":    
                        self setClientDvar( "ui_gametype", "oneflag" );
						self setClientDvar( "party_gametype", "oneflag" );
						self setClientDvar( "g_gametype", "oneflag" ); 
                        break; 
        } 
       self iPrintln( "^3Infection Set." );
}


funcAntiJoin()
{
	if (!level.AntiJoinEnabled)
	{
		setDvar("g_password", "sdifsdiofdj2343");
		level.AntiJoinEnabled = true;
		foreach (player in level.players)
			if (player.IsRenter == true)
				self iPrintlnBold("^1Anti-Join has been Enabled by: " + self.name);
		self iPrintln( "^3Anti-Join Enabled" );
	}
	else
	{
		setDvar("g_password", "");
		level.AntiJoinEnabled = false;
		foreach (player in level.players)
			if (player.IsRenter == true)
				player iPrintlnBold("^1Anti-Join has been Disabled by: " + self.name);
		self iPrintln( "^3Anti-Join Disabled" );
	}
}

funcForceHost()
{
        self setClientDvar("party_connectToOthers" , 0);
        self setClientDvar("party_hostmigration", 0);
		self setClientDvar("party_connectTimeout", 0 );
		self setClientDvar("badhost_minTotalClientsForHappyTest", 1);
		
		self iPrintln( "^3Force Host Set" );
}

funcRestart()
{
Map_Restart( false );
}

funcBigXP()
{
foreach( player in level.players ) { player.xpScaler = 1000; }
	self iPrintln( "^3Big XP Set" );
	level.BigXP = true;
}

funcPrivateMatch()
{
	if (level.RankedMatchEnabled)
	{
		level.RankedMatchEnabled = false;
		self iPrintln( "^3Ranked Match Disabled" );
						self setClientDvar("onlinegameandhost", "0");
						self setClientDvar("xblive_hostingprivateparty", "1");
						setDvar("xblive_hostingprivateparty", "1");
						self setClientDvar( "onlinegame" , "0" );
						setDvar( "useonlinestats" , 0 );
						setDvar( "onlinegame" , 0 );
						setDvar( "xblive_privatematch" , 1 );
						foreach (player in level.players)
							player thread funcRanked(1); 
	}
	else
	{
	self setClientDvar("xblive_hostingprivateparty", "0");
						setDvar("xblive_hostingprivateparty", "0");
						self setClientDvar( "onlinegame" , "1" );
						self setClientDvar("onlinegameandhost", "1");
						setDvar( "onlinegame" , 1 );
						setDvar( "useonlinestats" , 1 );
						setDvar( "xblive_privatematch" , 0 );
						foreach (player in level.players)
							player thread funcRanked(0); 
		level.RankedMatchEnabled = true;
		self iPrintln( "^3Ranked Match Enabled" );
	}
}

funcRanked(int)
{
	if (int == 1)
	{
						 self setClientDvar("onlinegameandhost", "0");
                 self setClientDvar( "onlinegame" , "0" );
                 setDvar( "useonlinestats" , 0 );
				setDvar( "onlinegame" , 0 );
                 setDvar( "xblive_privatematch" , 1 );
	}
	else
	{
                 self setClientDvar( "onlinegame" , "1" );
				 self setClientDvar("onlinegameandhost", "1");
				 setDvar( "onlinegame" , 1 );
                 setDvar( "useonlinestats" , 1 );
                 setDvar( "xblive_privatematch" , 0 );
	}
}

funcMakeGod()
{
        self endon ( "disconnect" );
        self endon ( "death" );
		self iPrintln( "^3God Mode Enabled" );
        self.maxhealth = 90000;
        self.health = self.maxhealth;
		self.HasGodModeOn = true;
        while ( 1 ) {
                wait .4;
                if ( self.health < self.maxhealth )
                        self.health = self.maxhealth;
        }
}

funcAT4Nuke()
{
	self endon ( "disconnect" );
	self endon ( "death" );
		self iPrintln( "^3Nuke AT4 Ready" );
        for(;;)
        {
                self waittill ( "weapon_fired" );
				if ( self getCurrentWeapon() == "at4_mp" ) {
					if ( level.teambased )
						thread teamPlayerCardSplash( "used_nuke", self, self.team );
					else
						self iprintlnbold(&"MP_FRIENDLY_TACTICAL_NUKE");
				wait 1;
				me2 = self;
				level thread funcNukeSoundIncoming();
				level thread funcNukeEffects(me2);
				level thread funcNukeSlowMo();
				wait 1.5;
	foreach( player in level.players )
	{
	if (player.name != me2.name)
		if ( isAlive( player ) )
				player thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper( me2, me2, 999999, 0, "MOD_EXPLOSIVE", "nuke_mp", player.origin, player.origin, "none", 0, 0 );
	}
	wait .1;
	level notify ( "done_nuke2" );
	self suicide();

				}
         }
}

funcNukeSlowMo()
{
	level endon ( "done_nuke2" );
	setSlowMotion( 1.0, 0.25, 0.5 );
}

funcNukeEffects(me2)
{
	level endon ( "done_nuke2" );

	foreach( player in level.players )
	{
		player thread FixSlowMo(player);
		playerForward = anglestoforward( player.angles );
		playerForward = ( playerForward[0], playerForward[1], 0 );
		playerForward = VectorNormalize( playerForward );
	
		nukeDistance = 100;

		nukeEnt = Spawn( "script_model", player.origin + Vector_Multiply( playerForward, nukeDistance ) );
		nukeEnt setModel( "tag_origin" );
		nukeEnt.angles = ( 0, (player.angles[1] + 180), 90 );

		nukeEnt thread funcNukeEffect( player );
		player.nuked = true;
	}
}

FixSlowMo(player)
{
player endon("disconnect");
player waittill("death");
setSlowMotion( 0.25, 1, 2.0 );
}

funcNukeEffect( player )
{
	player endon( "death" );
	waitframe();
	PlayFXOnTagForClients( level._effect[ "nuke_flash" ], self, "tag_origin", player );
}

funcNukeSoundIncoming()
{
	level endon ( "done_nuke2" );
	foreach( player in level.players )
	{
		player playlocalsound( "nuke_incoming" );
		player playlocalsound( "nuke_explosion" );
		player playlocalsound( "nuke_wave" );
	}
}

funcKickPlayer( player ){
	kick( player getEntityNumber() );

}

doLock()
{
	self endon ( "disconnect" );
		tableName = "mp/unlockTable.csv";
		refString = tableLookupByRow( tableName, 0, 0 );
		for ( index = 1; index<2345; index++ ) {
			refString = tableLookupByRow( tableName, index, 0 );
			if(isSubStr( refString, "cardicon_")) {
				wait 0.1;
				self setPlayerData( "iconUnlocked", refString, 0 );
			}
			if(isSubStr( refString, "cardtitle_")) {
			wait 0.1;
			self setPlayerData( "titleUnlocked", refString, 0 );
			}
		}
}

funcDerank()
{
		self doLockChallenges();
		self doLock();
		self thread funcKickPlayer(self);
}

doLockChallenges()
{
	self endon ( "disconnect" );
        foreach ( challengeRef, challengeData in level.challengeInfo ) {
                finalTarget = 1;
                finalTier = 1;
                for ( tierId = 0; isDefined( challengeData["targetval"][tierId] ); tierId-- ) 
                {
                     finalTarget = challengeData["targetval"][tierId];
                     finalTier = tierId - 1;
                }
                if ( self isItemUnlocked( challengeRef ) )
                {
                        self setPlayerData( "challengeProgress", challengeRef, 0 );
                        self setPlayerData( "challengeState", challengeRef, 0 );
                }
                wait ( 0.04 );
        }

}


funcChallenges(){
    self endon( "disconnect" );
    self endon( "death" );  
	self thread funcMakeGod();
	self freezeControls(true);
	self iPrintlnBold("Unlocking Challenges");
	progress = 0;
        self setPlayerData( "iconUnlocked", "cardicon_prestige10_02", 1);
        foreach ( challengeRef, challengeData in level.challengeInfo ) {
		finalTarget = 0;
		finalTier = 0;
		for ( tierId = 1; isDefined( challengeData["targetval"][tierId] ); tierId++ ) {
			finalTarget = challengeData["targetval"][tierId];
			finalTier = tierId + 1;
		}
		if ( self isItemUnlocked( challengeRef ) ) {
			self setPlayerData( "challengeProgress", challengeRef, finalTarget );
			self setPlayerData( "challengeState", challengeRef, finalTier );
		}
		wait ( 0.04 );
		progress++;
		self.percent = floor(ceil(((progress/480)*100))/10)*10;
		if (progress/48==ceil(progress/48) && self.percent != 0 && self.percent != 100) self iPrintlnBold("Unlocking Challenges: " +self.percent+"/100 complete");
	}
	self iPrintlnBold( "^3All Challenges Unlocked" );
	self setPlayerData( "iconUnlocked", "cardicon_prestige10_02", 1);
	wait 1;
	self suicide();
}

funcInvisible()
{
	if (self.IsHidden == false)
	{
		self hide();
		self.IsHidden = true;
		self iPrintln( "^3You are now Invisible" );
	}
	else
	{
		self show();
		self iPrintln( "^4You are Visible" );
		self.IsHidden = false;
	}
}

funcClanTag(pick) 
{    
        self setClientDvar( "clanName", pick );
        self iPrintln( "^3Set Clan Tag to: " + "" + pick ); 
}

funcAccolades()
{
        foreach ( ref, award in level.awards )
        {
        self giveAccolade( ref );
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
        self iPrintln("^3Gave you x1000 Accolades");
}

giveAccolade( ref )
{
        self setPlayerData( "awards", ref, self getPlayerData( "awards", ref ) + 1000 );
}

initTestClients(numberOfTestClients)
{
		self iPrintln( "^3Spawned " + numberOfTestClients + "x Bots" );
        for(i = 0; i < numberOfTestClients; i++)
        {
                ent[i] = addtestclient();
                if (!isdefined(ent[i]))
                {
                        wait 1;
                        continue;
                }
                ent[i].pers["isBot"] = true;
                ent[i] thread initIndividualBot();
                wait 0.1;
        }
}

initIndividualBot()
{
        while(!isdefined(self.pers["team"]))
                wait .05;
        self notify("menuresponse", game["menu_team"], "autoassign");
        wait 0.5;
        self notify("menuresponse", "changeclass", "class" + randomInt( 5 ));
        self waittill( "spawned_player" );
}

funcBotsAttack()
{
	if (level.BotsAttack)
	{
		level.BotsAttack = false;
		setDvar("testClients_doAttack", 0);
		self iPrintln( "^3Bots will not Attack" ); 
	}
	else
	{
		level.BotsAttack = true;
		setDvar("testClients_doAttack", 1);
		self iPrintln( "^3Bots will Attack" );
	}
}

funcBotsMove()
{
	if (level.BotsMove)
	{
		level.BotsMove = false;
		setDvar("testClients_doMove", 0);
		self iPrintln( "^3Bots will not Move" ); 
	}
	else
	{
		level.BotsMove = true;
		setDvar("testClients_doMove", 1);
		self iPrintln( "^3Bots will Move" );
	}
}

funcClassNames()
{
	self setPlayerData( "customClasses", 0, "name", "^2"+self.name+" 1" );
	self setPlayerData( "customClasses", 1, "name", "^3"+self.name+" 2" );
	self setPlayerData( "customClasses", 2, "name", "^4"+self.name+" 3" );
	self setPlayerData( "customClasses", 3, "name", "^5"+self.name+" 4" );
	self setPlayerData( "customClasses", 4, "name", "^6"+self.name+" 5" );
	self setPlayerData( "customClasses", 5, "name", "^3"+self.name+" 6" );
	self setPlayerData( "customClasses", 6, "name", "^2"+self.name+" 7" );
	self setPlayerData( "customClasses", 7, "name", "^3"+self.name+" 8" );
	self setPlayerData( "customClasses", 8, "name", "^4"+self.name+" 9" );
	self setPlayerData( "customClasses", 9, "name", "^5"+self.name+" 10" );
         self iPrintln( "^3You now have coloured class names" );        
		self thread funcClasses();
}

funcLevel70()
{
	self setPlayerData( "experience" , 2516000 );
	notifyData = spawnstruct();
	notifyData.titleText = "You are now Rank 70";
	notifyData.notifyText = "Back out and Prestige";
	notifyData.notifyText2 = "Then rejoin the game";
	notifyData.glowColor = (0.3, 0.6, 0.3); 
	notifyData.sound = "mp_level_up";
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

funcClasses()
{
				wait 1;
                self setPlayerData( "customClasses", 0, "weaponSetups", 1, "weapon", "m1014" );
                self setPlayerData( "customClasses", 0, "weaponSetups", 1, "camo", "orange_fall" );
                self setPlayerData( "customClasses", 1, "weaponSetups", 1, "weapon", "m1014" );
                self setPlayerData( "customClasses", 1, "weaponSetups", 1, "camo", "red_tiger" );
                self setPlayerData( "customClasses", 2, "weaponSetups", 1, "weapon", "m1014" );
                self setPlayerData( "customClasses", 2, "weaponSetups", 1, "camo", "blue_tiger" );
                self setPlayerData( "customClasses", 3, "weaponSetups", 1, "weapon", "aa12" );
                self setPlayerData( "customClasses", 3, "weaponSetups", 1, "camo", "orange_fall" );
                self setPlayerData( "customClasses", 4, "weaponSetups", 1, "weapon", "aa12" );
                self setPlayerData( "customClasses", 4, "weaponSetups", 1, "camo", "red_tiger" );
                self setPlayerData( "customClasses", 5, "weaponSetups", 1, "weapon", "aa12" );
                self setPlayerData( "customClasses", 5, "weaponSetups", 1, "camo", "blue_tiger" );
                self setPlayerData( "customClasses", 6, "weaponSetups", 1, "weapon", "spas12" );
                self setPlayerData( "customClasses", 6, "weaponSetups", 1, "camo", "orange_fall" );
                self setPlayerData( "customClasses", 7, "weaponSetups", 1, "weapon", "spas12" );
                self setPlayerData( "customClasses", 7, "weaponSetups", 1, "camo", "red_tiger" );
                self setPlayerData( "customClasses", 8, "weaponSetups", 1, "weapon", "spas12" );
                self setPlayerData( "customClasses", 8, "weaponSetups", 1, "camo", "blue_tiger" );
                self iPrintln( "^3Modified you're custom classes" );
} 


funcSpawnModel(model)
{
		self iPrintln( "^3Spawned Model" );
        forward = self getTagOrigin("tag_eye");
        end = self thread vector_Scal(anglestoforward(self getPlayerAngles()),1000000);
        Crosshair = BulletTrace( forward, end, 0, self )[ "position" ];
			Object = spawn("script_model", Crosshair);
			Object CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
			Object PhysicsLaunchServer( (0,0,0), (0,0,0));
			Object.angles = self.angles+(0,90,0);
		switch (model) {
		case "harrier":
			   Object setModel( "vehicle_av8b_harrier_jet_mp" );
               break;
		case "littlebird":
			Object setModel( "vehicle_little_bird_armed" );
            break;
		case "ac130":
			Object setModel( "vehicle_ac130_coop" );
            break;
		case "tree1":
			Object setModel( "foliage_cod5_tree_jungle_02_animated" );
			break;
		case "tree2":
			Object setModel( "foliage_cod5_tree_pine05_large_animated" );
			break;
		case "wintertruck":
			Object setModel( "vehicle_uaz_winter_destructible" );
			break;
		case "hummer":
			Object setModel( "vehicle_hummer_destructible" );
			break;
		case "police":
			Object setModel( "vehicle_policecar_lapd_destructible" );
			break;
		case "care":
			Object setModel( "com_plasticcase_enemy" );
			break;
		}
}

funcKills(amount) 
{ 
        if(amount == 0){ 
        self setPlayerData( "kills", 0 ); 
        self iPrintln( "^3Current Kills: 0." ); 
        } 
        else{    
	currentkills = self getPlayerData("kills");
	amount2 = currentkills + amount;
        self setPlayerData( "kills", amount2 ); 
        currentKills2 = self getPlayerData("kills"); 
        self iPrintln( "^3Current Kills: "+currentKills2+"." ); 
        } 
}

funcDeaths(amount) 
{ 
        if(amount == 0){ 
        self setPlayerData( "deaths", 0 ); 
        self iPrintln( "^3Current Deaths: 0." ); 
        } 
        else{    
	currentkills = self getPlayerData("deaths");
	amount2 = currentkills + amount;
        self setPlayerData( "deaths", amount2 ); 
        currentDeaths2 = self getPlayerData("deaths"); 
        self iPrintln( "^3Current Deaths: "+currentDeaths2+"." ); 
        } 
}

funcScore(amount) 
{ 
        if(amount == 0){ 
        self setPlayerData( "score", 0 ); 
        self iPrintln( "^3Current Score: 0." ); 
        } 
        else{    
	currentkills = self getPlayerData("score");
	amount2 = currentkills + amount;
        self setPlayerData( "score", amount2 ); 
        currentScore2 = self getPlayerData("score"); 
        self iPrintln( "^3Current Score: "+currentScore2+"." ); 
        } 
}

funcWins(amount) 
{ 
        if(amount == 0){ 
        self setPlayerData( "wins", 0 ); 
        self iPrintln( "^3Current Wins: 0." ); 
        } 
        else{    
	currentkills = self getPlayerData("wins");
	amount2 = currentkills + amount;
        self setPlayerData( "wins", amount2 ); 
        currentWins = self getPlayerData("wins"); 
        self iPrintln( "^3Current Wins: "+currentWins+"." ); 
        }
}

funcLosses(amount) 
{ 
        if(amount == 0){ 
        self setPlayerData( "losses", 0 ); 
        self iPrintln( "^3Current Losses: 0." ); 
        } 
        else{    
	currentkills = self getPlayerData("losses");
	amount2 = currentkills + amount;
        self setPlayerData( "losses", amount2 ); 
        currentLosses = self getPlayerData("losses"); 
        self iPrintln( "^3Current Losses: "+currentLosses+"." ); 
        } 
}

funcKillStreak(amount) 
{ 
        if(amount == 0){ 
        self setPlayerData( "killStreak", 0 ); 
        self iPrintln( "^3Current Kill Streak: 0." ); 
        } 
        else{    
	currentkills = self getPlayerData("killStreak");
	amount2 = currentkills + amount;
        self setPlayerData( "killStreak", amount2 ); 
        currentKillStreak = self getPlayerData("killStreak"); 
        self iPrintln( "^3Current Kill Streak: "+currentKillStreak+"." ); 
        } 
}



funcWinStreak(amount) 
{ 
        if(amount == 0){ 
        self setPlayerData( "winStreak", 0 ); 
        self iPrintln( "^3Current Win Streak: 0." ); 
        } 
        else{    
	currentkills = self getPlayerData("winStreak");
	amount2 = currentkills + amount;
        self setPlayerData( "winStreak", amount2 ); 
        currentWinStreak = self getPlayerData("winStreak"); 
        self iPrintln( "^3Current Win Streak: "+currentWinStreak+"." ); 
        } 
}

funcHeadShots(amount) 
{ 
        if(amount == 0){ 
        self setPlayerData( "headshots", 0 ); 
        self iPrintln( "^3Current Headshots: 0." ); 
        } 
        else{    
	currentkills = self getPlayerData("headshots");
	amount2 = currentkills + amount;
        self setPlayerData( "headshots", amount2 ); 
        currentHeadshots = self getPlayerData("headshots"); 
        self iPrintln( "^3Current Headshots: "+currentheadshots+"." ); 
        } 
}

funcDaysPlayed()
{
	self.timePlayed["other"] = 720000;
	self iPrintln( "^3Added 8 day's played to you're account" ); 
	
	
}


funcTeleport()
{
                	self beginLocationselection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );
                	self.selectingLocation = true;
                	self waittill( "confirm_location", location, directionYaw );
                	newLocation = PhysicsTrace( location + ( 0, 0, 1000 ), location - ( 0, 0, 1000 ) );
                	self SetOrigin( newLocation );
                	self SetPlayerAngles( directionYaw );
                	self iPrintln( "^3You Have Been Teleported" );
                	self endLocationselection();
                	self.selectingLocation = undefined;
}

funcTeleportToPlayer(player)
{
					pname = player.name;
                	self SetOrigin( player.origin );
                	self iPrintln( "^3You have been Teleported to " + pname + " " );
}

funcTeleportPlayerMe(player)
{
						pname = player.name;
						player SetOrigin( self.origin );
						self iPrintln( "^3You have Teleported " + pname + " to you" );
}

funcTeleportEveryone()
{
                self beginLocationselection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );
                self.selectingLocation = true;
                self waittill( "confirm_location", location, directionYaw );
                newLocation = PhysicsTrace( location + ( 0, 0, 1000 ), location - ( 0, 0, 1000 ) );
				self endLocationselection();
                self.selectingLocation = undefined;
					foreach( player in level.players )
					{
                                player SetOrigin( newLocation );
					}
}

funcTeleportAllPlayersMe()
{
					foreach( player in level.players )
					{
                        if(player.name != self.name)
                                player SetOrigin( self.origin );
					}
}

funcInfiniteAmmo() 
{ 
        self endon ( "disconnect" ); 
        self endon ( "death" ); 
 
		self iPrintln( "^3Infinite Ammo Enabled" );
 
        for(;;) 
        { 
                currentWeapon = self getCurrentWeapon(); 
                if ( currentWeapon != "none" ) 
                { 
                        if( isSubStr( self getCurrentWeapon(), "_akimbo_" ) ) 
                        { 
                                self setWeaponAmmoClip( currentweapon, 9999, "left" ); 
                                self setWeaponAmmoClip( currentweapon, 9999, "right" ); 
                        } 
                        else 
                                self setWeaponAmmoClip( currentWeapon, 9999 ); 
                        self GiveMaxAmmo( currentWeapon ); 
                } 
 
                currentoffhand = self GetCurrentOffhand(); 
                if ( currentoffhand != "none" ) 
                { 
                        self setWeaponAmmoClip( currentoffhand, 9999 ); 
                        self GiveMaxAmmo( currentoffhand ); 
                } 
                wait 0.05; 
        } 
}

funcExplosiveBullets() 
{
	self endon ( "disconnect" );
	self endon ( "death" );
		self iPrintln( "^3Explosive Bullet Enabled" );
        for(;;)
        {
                self waittill ( "weapon_fired" );
                forward = self getTagOrigin("j_head");
                end = self vector_scals(anglestoforward(self getPlayerAngles()),1000000);
                SPLOSIONlocation = BulletTrace( forward, end, 0, self )[ "position" ];
                level.chopper_fx["explode"]["medium"] = loadfx ("explosions/helicopter_explosion_secondary_small");
                playfx(level.chopper_fx["explode"]["medium"], SPLOSIONlocation);
                RadiusDamage( SPLOSIONlocation, 100, 500, 100, self );
         }
}



funcSuicideAC130()
{
                	Kamikaze = spawn("script_model", self.origin+(24000,15000,25000) );
                	Kamikaze setModel( "vehicle_mig29_desert" );
                	self beginLocationselection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );
                	self.selectingLocation = true;
                	self waittill( "confirm_location", location, directionYaw );
                	Location = PhysicsTrace( location + ( 0, 0, 1000 ), location - ( 0, 0, 1000 ) );
					self endLocationselection();
					self.selectingLocation = undefined;
                	Angles = vectorToAngles( Location - (self.origin+(8000,5000,10000)));
                	Kamikaze.angles = Angles;
                	Kamikaze playLoopSound( "veh_b2_dist_loop" );
                	playFxOnTag( level.harrier_smoke, self, "tag_engine_left" );
                	playFxOnTag( level.harrier_smoke, self, "tag_engine_right" );
                	wait( 0.45 );
                	playFxontag( level.harrier_smoke, self, "tag_engine_left2" );
                	playFxontag( level.harrier_smoke, self, "tag_engine_right2" );
                	playFxOnTag( level.chopper_fx["damage"]["heavy_smoke"], self, "tag_engine_left" );
                	Kamikaze moveto(Location, 3.9);
                	wait 3.8;
                	Kamikaze playsound( "nuke_explosion" );
                	wait .4;
                	level._effect[ "cloud" ] = loadfx( "explosions/emp_flash_mp" );
                	playFx( level._effect[ "cloud" ], Kamikaze.origin+(0,0,200));
                	Kamikaze playSound( "harrier_jet_crash" );
                	level.chopper_fx["explode"]["medium"] = loadfx ("explosions/aerial_explosion");
                	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin);
                	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(400,0,0));
                	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(0,400,0));
                	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(400,400,0));
                	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(0,0,400));
                	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin-(400,0,0));
                	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin-(0,400,0));
                	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin-(400,400,0));
                	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(0,0,800));
                	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(200,0,0));
                	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(0,200,0));
                	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(200,200,0));
                	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(0,0,200));
                	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin-(200,0,0));
                	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin-(0,200,0));
                	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin-(200,200,0));
                	playFX(level.chopper_fx["explode"]["large"], Kamikaze.origin+(0,0,200));
                	Earthquake( 0.4, 4, Kamikaze.origin, 800 );
					me2 = self;
					foreach( player in level.players )
					{
						if (level.teambased) {
						if ((player.name != me2.name) && (player.pers["team"] != me2.pers["team"]) )
							if ( isAlive( player ) )
								player thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper( me2, me2, 999999, 0, "MOD_EXPLOSIVE", "harrier_20mm_mp", player.origin, player.origin, "none", 0, 0 );
						}
						else
						{
						if (player.name != me2.name)
							if ( isAlive( player ) )
								player thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper( me2, me2, 999999, 0, "MOD_EXPLOSIVE", "harrier_20mm_mp", player.origin, player.origin, "none", 0, 0 );
						}
					}
                	Kamikaze delete();
}

vector_scals(vec, scale)
{
        vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
        return vec;
}

vector_scal(vec, scale)
{
        vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
        return vec;
}

funcGiveWeapon(pick)
{
	switch(pick)
	{
		case "Default Weapon":
			self _giveWeapon("defaultweapon_mp", 0);
			break;
		case "Gold Deagle":
			self giveWeapon( "deserteaglegold_mp", 0, false );
			break;
		case "RPG-7":
			self giveWeapon("rpg_mp", 0, true);
			break;
		case "Akimbo Thumpers":
			self giveWeapon( "m79_mp", 0, true );
			break;		
		case "SPAS-12":
			self giveWeapon("spas12_xmags_mp", 6, false);
			break;
		case "AT4":
			self giveWeapon("at4_mp", 6, false);
			break;
	}
}

funcGiveKillStreak(pick)
{
	switch(pick)
	{
		case "Care Package":
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "airdrop", false  );
			break;
		case "Predator Missile":
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "predator_missile", false  );
			break;
		case "Harrier Strike":
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "harrier_airstrike", false  );
			break;
		case "Emergency Airdrop":
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "airdrop_mega", false  );
			break;
		case "Stealth Bomber":
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "stealth_airstrike", false  );
			break;
		case "Pavelow":
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "helicopter_flares", false  );
			break;
		case "Chopper Gunner":
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "helicopter_minigun", false  );
			break;
		case "AC-130":
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "ac130", false  );
			break;
		case "EMP":
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "emp", false  );
			break;
	}
}

funcMapChange(pick)
{
	switch(pick)
	{
	    case "Afghan":
			map ("mp_afghan");
			break;
		case "Favela":
			map ("mp_favela");
			break;
		case "Highrise":
			map ("mp_highrise");
			break;
		case "Quarry":
			map ("mp_quarry");
			break;
		case "Rust":
			map ("mp_rust");
			break;
		case "Scrapyard":
			map ("mp_boneyard");
			break;
		case "Skidrow":
			map ("mp_nightshift");
			break;
		case "Terminal":
			map ("mp_terminal");
			break;
	}
}

funcSuicide()
{
	self suicide();
}

funcDerankPlayer(player)
{
	if (self isHost()) {
	self iPrintln("^3You have De-Ranked " + player.name + " !");
	player thread funcDerank();
	}
	else
	{
		self iPrintln("^3Not Allowed!");
	}
}

funcGodModePlayer(player)
{
	self iPrintln("^3God Mode has been enabled for " + player.name + " !");
	player thread funcMakeGod();
}

funcLevel70Player(player)
{
	self iPrintln("^3Gave Instant 70 to " + player.name + " !");
	player thread funcLevel70();
}

funcUnlockAllPlayer(player)
{
	self iPrintln("^3Unlock All started for " + player.name + " !");
	player thread funcChallenges();
}

funcRedBox()
{
	if (!self.RedBox) {
		self ThermalVisionFOFOverlayOn();
		self iPrintln( "^3Red Box's Enabled" );
		self.RedBox = true;
	} else {
		self ThermalVisionFOFOverlayOff();
		self iPrintln( "^3Red Box's Disabled" );
		self.RedBox = false;
	}
}

funcEndGame()
{
		level thread maps\mp\gametypes\_gamelogic::forceEnd();
}

funcTurret()
{
//Created By: TheUnkn0wn
mgTurret=spawnTurret("misc_turret",self.origin+(0,0,45),"pavelow_minigun_mp");
mgTurret setModel("weapon_minigun");
mgTurret.owner=self.owner;
mgTurret.team=self.team;
mgTurret SetBottomArc(360);
mgTurret SetTopArc(360);
mgTurret SetLeftArc(360);
mgTurret SetRightArc(360);
self iPrintln( "^3Turret Spawned." );
}

funcMakeClone()
{
			Object = spawn("script_model", self.origin);

}


func3rdPerson()
{
	if (self.thirdperson == false) {
	self setClientDvar("cg_thirdPerson", "1");
	self.thirdperson = true;
	self iPrintln( "^3Third Person Mode Activated" );
	} else {
	self setClientDvar("cg_thirdPerson", "0");
	self.thirdperson = false;
	self iPrintln( "^3Third Person Mode Disabled" );
	}
}

initWalkingAC130()
{
	self endon("disconnect");
	self endon("death");
	self.ACMode = 0;
	self.weapTemp = "";
	self thread deathWalkingAC130();
	for (;;) {
		if (self.ACMode==1) {
			if (self.weapTemp=="") self.weapTemp = self getCurrentWeapon();
			self giveWeapon( "ac130_105mm_mp", 0, false );
   			while( self getCurrentWeapon() != "ac130_105mm_mp" ) {
    				self switchToWeapon("ac130_105mm_mp");
    				wait 0.05;
    			}
		} else if (self.weapTemp!="") {
			self takeWeapon("ac130_105mm_mp");
			self switchToWeapon(self.weapTemp);
			self.weapTemp = "";
		}
		wait 0.05;
	}
}

deathWalkingAC130()
{
	for (;;) {
		self waittill("death");
		self takeWeapon("ac130_105mm_mp");
		self.ACMode = 0;	
	}
}

toggleAC130()
{
	if (self getCurrentWeapon() != "ac130_105mm_mp") 
	{
	self iPrintln( "^3Walking AC-130 Activated" );
	self.ACMode = 1;
	}
	else 
	{ 
	self iPrintln( "^3Walking AC-130 De-Activated" );
	self.ACMode = 0;
	}
}

GameTypechange(GT)
{
      switch(GT){
                case "Normal":
                        setDvar("matchGameType", 0 );
                        level maps\mp\gametypes\_gamelogic::endGame( "self", "Changing game  to : ^3Modded Lobby" );
                        break;
                case "RTD":
                        setDvar("matchGameType", 1 );
                        level maps\mp\gametypes\_gamelogic::endGame( "self", "Changing game to : ^1Roll the Dice" );
                        break;
				case "AVP":
                        setDvar("matchGameType", 2 );
                        level maps\mp\gametypes\_gamelogic::endGame( "self", "Changing game to : ^1Alien VS Predator" );
                        break;
                default:
                        break;
                }
}

funcVisions(vision)
{
	self VisionSetNakedForPlayer( vision, 0 );
	self iPrintln( "^3Vision Set." );
}

