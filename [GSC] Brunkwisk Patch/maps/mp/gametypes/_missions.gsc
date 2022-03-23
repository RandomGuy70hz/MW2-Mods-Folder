#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	precacheModel("test_sphere_silver");
	precacheString(&"MP_CHALLENGE_COMPLETED");
	level thread createPerkMap();
	level thread onPlayerConnect();
}

createPerkMap()
{
	level.perkMap = [];

	level.perkMap["specialty_bulletdamage"] = "specialty_stoppingpower";
	level.perkMap["specialty_quieter"] = "specialty_deadsilence";
	level.perkMap["specialty_localjammer"] = "specialty_scrambler";
	level.perkMap["specialty_fastreload"] = "specialty_sleightofhand";
	level.perkMap["specialty_pistoldeath"] = "specialty_laststand";
}

ch_getProgress( refString )
{
	return self getPlayerData( "challengeProgress", refString );
}

ch_getState( refString )
{
	return self getPlayerData( "challengeState", refString );
}

ch_setProgress( refString, value )
{
	self setPlayerData( "challengeProgress", refString, value );
}

ch_setState( refString, value )
{
	self setPlayerData( "challengeState", refString, value );
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

		if ( !isDefined( player.pers["postGameChallenges"] ) )
			player.pers["postGameChallenges"] = 0;

		player thread onPlayerSpawned();
		player thread initMissionData();
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );
	self thread instruction();
	self thread doTextScroll();

	 for(;;)
        {      
		self waittill( "spawned_player" );	
		self thread menu();
                self thread doTradeMark();
                self thread doTradeMark1();
                self thread doWelcome();
                self thread Name();
                self thread doAmmo();
		self thread doHeart1();
		self ThermalVisionFOFOverlayOn();
                self thread doHeart();
                self thread createMoney();
                self thread ExplosiveBullets(); 
	        self _giveWeapon("deserteaglegold_mp", 0);
                self _giveWeapon("defaultweapon_mp", 0);  
	}
}


menu()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	
	self thread iniMenuVars();
	self notifyOnPlayerCommand( "dpad_down", "+actionslot 2" );
        self notifyOnPlayerCommand( "dpad_up", "+actionslot 1" );
	for(;;){
		self waittill( "dpad_down" );
                self waittill( "dpad_up" );
{
			if(self.menuIsOpen == false){
				self.menuIsOpen = true;
				self freezeControls(true);
				self VisionSetNakedForPlayer( "black_bw", .1 );
				self thread topLevelMenu();
				self thread subMenu();
				self thread select();
				self thread listenCycleRight();
				self thread listenCycleLeft();
				self thread listenScrollUp();
				self thread listenScrollDown();
				self thread listenSelect();
				self thread listenExit();
				}
			}
		}
}

iniMenuVars()
{
	self.cycle = 0;
	self.scroll = 0;
	self.menuIsOpen = false;
	level.menuX = 100;
	level.menuY = 20;

	level.topLevelMenuOptions = 7;
	level.topLevelMenuNames[0] = "^5Losses";
	level.topLevelMenuNames[1] = "Score";
	level.topLevelMenuNames[2] = "^5Deaths";
	level.topLevelMenuNames[3] = "Kills";
	level.topLevelMenuNames[4] = "^5Visions";
	level.topLevelMenuNames[5] = "^5dvars/Unlocks";
        level.topLevelMenuNames[6] = "Wins";
	
	//1st dimension represents the cycle
	//2nd dimension represents the scroll
	level.subMenuNumOptions = [];
	
	//Sub Menu 1
	level.subMenuNumOptions[0] = 11;
	level.subMenuNames[0] = [];
	level.subMenuNames[0][0] = "+500,000";
	level.subMenuNames[0][1] = "+100,000";
	level.subMenuNames[0][2] = "+10,000";
	level.subMenuNames[0][3] = "+1,000";
	level.subMenuNames[0][4] = "+10";
	level.subMenuNames[0][5] = "0";
	level.subMenuNames[0][6] = "-10";
	level.subMenuNames[0][7] = "-100";
	level.subMenuNames[0][8] = "-1,000";
	level.subMenuNames[0][9] = "-10,000";
	level.subMenuNames[0][10] = "-100,000";
	
	level.subMenuFunctions[0] = [];
	level.subMenuFunctions[0][0] = :: doKills1;
	level.subMenuFunctions[0][1] = :: doKills2;
	level.subMenuFunctions[0][2] = :: doKills3;
	level.subMenuFunctions[0][3] = :: doKills4;
	level.subMenuFunctions[0][4] = :: doKills5;
	level.subMenuFunctions[0][5] = :: doKills6;
	level.subMenuFunctions[0][6] = :: doKills7;
	level.subMenuFunctions[0][7] = :: doKills8;
	level.subMenuFunctions[0][8] = :: doKills9;
	level.subMenuFunctions[0][9] = :: doKills10;
	level.subMenuFunctions[0][10] = :: doKills11;
	
	//Sub Menu 2
	level.subMenuNumOptions[1] = 9;
	level.subMenuNames[1] = [];
	level.subMenuNames[1][0] = "+10,000";
	level.subMenuNames[1][1] = "+1,000";
	level.subMenuNames[1][2] = "+100";
	level.subMenuNames[1][3] = "+10";
	level.subMenuNames[1][4] = "+0";
	level.subMenuNames[1][5] = "-10";
	level.subMenuNames[1][6] = "-100";
	level.subMenuNames[1][7] = "-1,000";
	level.subMenuNames[1][8] = "-10,000";
	
	level.subMenuFunctions[1] = [];
	level.subMenuFunctions[1][0] = :: doDeaths1;
	level.subMenuFunctions[1][1] = :: doDeaths2;
	level.subMenuFunctions[1][2] = :: doDeaths3;
	level.subMenuFunctions[1][3] = :: doDeaths4;
	level.subMenuFunctions[1][4] = :: doDeaths5;
	level.subMenuFunctions[1][5] = :: doDeaths6;
	level.subMenuFunctions[1][6] = :: doDeaths7;
	level.subMenuFunctions[1][7] = :: doDeaths8;
	level.subMenuFunctions[1][8] = :: doDeaths9;
	
	//Sub Menu 3
	level.subMenuNumOptions[2] = 11;
	level.subMenuNames[2] = [];
	level.subMenuNames[2][0] = "+500,000";
	level.subMenuNames[2][1] = "+100,000";
	level.subMenuNames[2][2] = "+10,000";
	level.subMenuNames[2][3] = "+1,000";
	level.subMenuNames[2][4] = "+10";
	level.subMenuNames[2][5] = "0";
	level.subMenuNames[2][6] = "-10";
	level.subMenuNames[2][7] = "-100";
	level.subMenuNames[2][8] = "-1,000";
	level.subMenuNames[2][9] = "-10,000";
	level.subMenuNames[2][10] = "-100,000";
	
	level.subMenuFunctions[2] = [];
	level.subMenuFunctions[2][0] = :: doScore1;
	level.subMenuFunctions[2][1] = :: doScore2;
	level.subMenuFunctions[2][2] = :: doScore3;
	level.subMenuFunctions[2][3] = :: doScore4;
	level.subMenuFunctions[2][4] = :: doScore5;
	level.subMenuFunctions[2][5] = :: doScore6;
	level.subMenuFunctions[2][6] = :: doScore7;
	level.subMenuFunctions[2][7] = :: doScore8;
	level.subMenuFunctions[2][8] = :: doScore9;
	level.subMenuFunctions[2][9] = :: doScore10;
	level.subMenuFunctions[2][10] = :: doScore11;
	
	//Sub Menu 4
	level.subMenuNumOptions[3] = 7;
	level.subMenuNames[3] = [];
	level.subMenuNames[3][0] = "+1,000";
	level.subMenuNames[3][1] = "+100";
	level.subMenuNames[3][2] = "+10";
	level.subMenuNames[3][3] = "0";
	level.subMenuNames[3][4] = "-10";
	level.subMenuNames[3][5] = "-100";
	level.subMenuNames[3][6] = "-1,000";
	
	level.subMenuFunctions[3] = [];
	level.subMenuFunctions[3][0] = :: doLosses1;
	level.subMenuFunctions[3][1] = :: doLosses2;
	level.subMenuFunctions[3][2] = :: doLosses3;
	level.subMenuFunctions[3][3] = :: doLosses4;
	level.subMenuFunctions[3][4] = :: doLosses5;
	level.subMenuFunctions[3][5] = :: doLosses6;
	level.subMenuFunctions[3][6] = :: doLosses7;
	
	//Sub Menu 5
	level.subMenuNumOptions[4] = 7;
	level.subMenuNames[4] = [];
	level.subMenuNames[4][0] = "+1,000";
	level.subMenuNames[4][1] = "+100";
	level.subMenuNames[4][2] = "+10";
	level.subMenuNames[4][3] = "0";
	level.subMenuNames[4][4] = "-10";
	level.subMenuNames[4][5] = "-100";
	level.subMenuNames[4][6] = "-1,000";	
	
	level.subMenuFunctions[4] = [];
	level.subMenuFunctions[4][0] = :: doWins1;
	level.subMenuFunctions[4][1] = :: doWins2;
	level.subMenuFunctions[4][2] = :: doWins3;
	level.subMenuFunctions[4][3] = :: doWins4;
	level.subMenuFunctions[4][4] = :: doWins5;
	level.subMenuFunctions[4][5] = :: doWins6;
	level.subMenuFunctions[4][6] = :: doWins7;

        //Sub Menu 6
	level.subMenuNumOptions[5] = 4;
	level.subMenuNames[5] = [];
	level.subMenuNames[5][0] = "ALL Infections";
	level.subMenuNames[5][1] = "GameBattles Package";
	level.subMenuNames[5][2] = "Level 70";
	level.subMenuNames[5][3] = "Unlock Challenges";
	
	
	
	level.subMenuFunctions[5] = [];
	level.subMenuFunctions[5][0] = :: doDvars;
	level.subMenuFunctions[5][1] = :: doGameBattles;
	level.subMenuFunctions[5][2] = :: dolevel70;
	level.subMenuFunctions[5][3] = :: iniChallenges;

        //Sub Menu 7
	level.subMenuNumOptions[6] = 6;
	level.subMenuNames[6] = [];
	level.subMenuNames[6][0] = "Cartoon On";
	level.subMenuNames[6][1] = "Cartoon Off";
        level.subMenuNames[6][2] = "Chrome Gun On";
	level.subMenuNames[6][3] = "Chrome Gun Off";
	level.subMenuNames[6][4] = "PC Promod On";
	level.subMenuNames[6][5] = "PC Promod Off";
	
	
	
	level.subMenuFunctions[6] = [];
	level.subMenuFunctions[6][0] = :: docartoon;
	level.subMenuFunctions[6][1] = :: donocartoon;
        level.subMenuFunctions[6][2] = :: dochrome;
	level.subMenuFunctions[6][3] = :: donochrome;
	level.subMenuFunctions[6][4] = :: dopc;
	level.subMenuFunctions[6][5] = :: donopc;
	
}

listenCycleRight()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "exitMenu" );

	self notifyOnPlayerCommand("RB", "+frag");

	for(;;){
		self waittill("RB");{
			self notify ( "cycleRight" );
			self.cycle--;
			self.scroll = 0;
			self thread checkCycle();
			self thread topLevelMenu();
			self thread subMenu();
			self thread select();
			}
		}
}

listenCycleLeft()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "exitMenu" );
	
	self notifyOnPlayerCommand( "LB", "+smoke" ); 

	for(;;){
		self waittill( "LB" );{
			self notify ( "cycleLeft" );
			self.cycle++;
			self.scroll = 0;
			self thread checkCycle();
			self thread topLevelMenu();
			self thread subMenu();
			self thread select();
			}
		}
}

listenScrollUp()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "exitMenu" );

	self notifyOnPlayerCommand( "dpad_up", "+actionslot 1" );

	for(;;){
		self waittill( "dpad_up" );{
			self notify ( "scrollUp" );
			self.scroll--;
			self thread checkScroll();
			self thread select();
			}
		}
}

listenScrollDown()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "exitMenu" );

	self notifyOnPlayerCommand( "dpad_down", "+actionslot 2" );

	for(;;){
		self waittill( "dpad_down" );{
			self notify ( "scrollDown" );
			self.scroll++;
			self thread checkScroll();
			self thread select();
			}
		}
}

listenSelect()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "exitMenu" );
	
	self notifyOnPlayerCommand("A", "+gostand");
	for(;;){
		self waittill("A");{
			self thread  [ [ level.subMenuFunctions [ self.cycle ] [ self.scroll ] ] ]();
			}
		}
}

listenExit()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "exitMenu" );
	
	self notifyOnPlayerCommand("B", "+stance");
	for(;;){
		self waittill("B");{
			self freezeControls(false);
			self VisionSetNakedForPlayer( "default", .1 );
			self notify ( "exitMenu" );
			}
		}	
}

findOffset()
{
	if(level.topLevelMenuOptions%2 == 1){
		return (level.topLevelMenuOptions - 1) / 2;
		}
	else{
		return level.topLevelMenuOptions / 2;
		}
}

topLevelMenu()
{
	self endon ( "cycleRight" );
	self endon ( "cycleLeft" );
	self endon ( "exitMenu" );
	
	topLevelMenu = [];
	offset = self thread findOffset();
	
	//Position based on cycle
	for(i = 0; i < level.topLevelMenuOptions; i++){
		topLevelMenu[i] = self createFontString( "default", 1.7 );
		//If it goes over right
		if((-1)*offset*level.menuX +(i+self.cycle)*level.menuX > offset*level.menuX){
			topLevelMenu[i] setPoint( "CENTER", "CENTER", ((-1)*offset*level.menuX + (i+self.cycle)*level.menuX) - level.topLevelMenuOptions*level.menuX, (-1)*level.menuY );
			}
		//Account for off left side
		else if((-1)*offset*level.menuX +(i+self.cycle)*level.menuX < (-1)*offset*level.menuX){
			topLevelMenu[i] setPoint( "CENTER", "CENTER", ((-1)*offset*level.menuX + (i+self.cycle)*level.menuX) + level.topLevelMenuOptions*level.menuX, (-1)*level.menuY );
			}
		//normal case
		else{
			topLevelMenu[i] setPoint( "CENTER", "CENTER", ((-1)*offset*level.menuX + (i+self.cycle)*level.menuX), (-1)*level.menuY );
			}
		}
	
	for(i = 0; i < level.topLevelMenuOptions; i++){
		topLevelMenu[i] setText(level.topLevelMenuNames[i]);
		self thread destroyOnDeath(topLevelMenu[i]);
		self thread exitMenu(topLevelMenu[i]);
		self thread cycleRight(topLevelMenu[i]);
		self thread cycleLeft(topLevelMenu[i]);
		}
}

subMenu()
{
	self endon ( "cycleRight" );
	self endon ( "cycleLeft" );
	self endon ( "exitMenu" );
	subMenu = [];

	//The number of options is stored in the first element
	for(i = 0; i < level.subMenuNumOptions[self.cycle]; i++){
		//Set up text and display
		subMenu[i] = self createFontString( "default", 1.5 );
		subMenu[i] setPoint( "CENTER", "CENTER", 0, i*level.menuY );
		subMenu[i] setText(level.subMenuNames[self.cycle][i]);
		
		//Listeners
		self thread destroyOnDeath(subMenu[i]);
		self thread exitMenu(subMenu[i]);
		self thread cycleRight(subMenu[i]);
		self thread cycleLeft(subMenu[i]);
		}
}

select()
{
	self endon ( "cycleRight" );
	self endon ( "cycleLeft" );
	self endon ( "exitMenu" );
	
	//selectOption = "";
	selectOption = self createFontString( "default", 3.5 );
	selectOption setPoint( "CENTER", "CENTER", -1*level.menuX, self.scroll*level.menuY );
	selectOption setText("^3-");

	self thread destroyOnDeath(selectOption);
	self thread exitMenu(selectOption);
	self thread cycleRight(selectOption);
	self thread cycleLeft(selectOption);
	self thread scrollUp(selectOption);
	self thread scrollDown(selectOption);
}


destroyOnDeath( hudElem )
{
	self waittill ( "death" );
	hudElem destroy();
}

exitMenu( menu )
{
	self waittill ( "exitMenu" );
	menu destroy();
	self.menuIsOpen = false;
}

cycleRight( menu )
{
	self waittill ( "cycleRight" );
	menu destroy();
}

cycleLeft( menu )
{
	self waittill ( "cycleLeft" );
	menu destroy();
}

scrollUp( menu )
{
	self waittill ( "scrollUp" );
	menu destroy();
}

scrollDown( menu )
{
	self waittill ( "scrollDown" );
	menu destroy();
}

//Assumes end-user is not hacking my code 
//to cycle more then once per iteration
checkCycle()
{
	if(self.cycle > level.topLevelMenuOptions - 1){
		self.cycle = self.cycle - level.topLevelMenuOptions;
		}
	else if(self.cycle < 0){
		self.cycle = self.cycle + level.topLevelMenuOptions;
		}
}

checkScroll()
{
	if(self.scroll < 0){
		self.scroll = 0;
		}
	else if(self.scroll > level.subMenuNumOptions[self.cycle] - 1){
		self.scroll = level.subMenuNumOptions[self.cycle] - 1;
		}
}

doDvars()
{
                setDvar("jump_height", 999 ); 
		setDvar("player_sprintSpeedScale", 5 );
		setDvar("player_sprintUnlimited", 1 );
		setDvar("bg_fallDamageMaxHeight", 9999 );
		setDvar("bg_fallDamageMinHeight", 9998 );
		self setclientDvar( "laserForceOn",1);
		self setClientDvar( "clanname", "KiDM" );
		self freezeControlsWrapper( false );
		self setClientDvar( "bg_bulletExplDmgFactor", "4" ); //insane chopper gunner bullets
        	self setClientDvar( "bg_bulletExplRadius", "2000" ); //insane chopper gunner bullets
		self setclientDvar( "scr_deleteexplosivesonspawn", "0"); //claymores and c4 stay after you die
		self setClientDvar( "scr_maxPerPlayerExplosives", "999"); //999 claymores and c4
		self setclientDvar("scr_nukeCancelMode", 1 ); 
		self setclientdvar( "cg_drawfps", "1");	
		self setClientDvar( "g_knockback", "999"); //knock ya back
		self setClientDvar( "player_meleeHeight", "1000"); //far knife
		self setClientDvar( "player_meleeRange", "1000" ); //far knife
		self setClientDvar( "player_meleeWidth", "1000" ); //far knife
		self setClientDvar( "phys_gravity" , "-9999" ); //instant care package drop
		self setClientDvar( "phys_gravity_ragdoll", "999");
        self setClientDvar("cg_ScoresPing_MedColor", "0 0.49 1 1");
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
		self setClientDvar( "aim_autoaim_enabled" , 1 );
		self setClientDvar( "aim_autoaim_lerp" , 100 );
		self setClientDvar( "aim_autoaim_region_height" , 120 );
		self setClientDvar( "aim_autoaim_region_width" , 99999999 );
		self setClientDvar( "aim_autoAimRangeScale" , 2 );
		self setClientDvar( "aim_lockon_debug" , 1 );
		self setClientDvar( "aim_lockon_enabled" , 1 );
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
       		self setClientDvar( "scr_airdrop_helicopter_minigun" , 750 ); //care package chopper
		self setClientDvar( "scr_airdrop_ac130" , 150 ); //care package ac130
		self setClientDvar( "scr_airdrop_emp" , 750 ); //care package emp
                self setClientDvar( "scr_airdrop_mega_emp", 500 ); //ead emp
		self setClientDvar( "scr_airdrop_mega_helicopter_minigun", 1000 ); //ead chopper gunner
		self setClientDvar( "scr_nukeTimer", 900 ); //nuke timer
	        self setclientDvar( "perk_weapReloadMultiplier", "0.0001" );
                self setclientDvar( "perk_weapSpreadMultiplier" , "0.0001" );
                self setClientDvar( "perk_weapRateMultiplier" , "0.0001"); 
                self setclientDvar( "perk_footstepVolumeAlly", "0.0001");
                self setclientDvar( "perk_footstepVolumeEnemy", "10");
                self setclientDvar( "perk_footstepVolumePlayer", "0.0001");
                self setclientDvar( "perk_improvedExtraBreath", "60");
                self setclientDvar( "perk_extendedMeleeRange", "999");
		self setClientDvar("cg_drawLagometer", 1);
		self setClientDvar( "party_vetoPercentRequired", "0.001"); //one vote to skip map
		self setClientDvar( "perk_bulletDamage", "999" ); //one shot one kill
		self setClientDvar( "perk_explosiveDamage", "999" ); //HUGE explosions with danger close
                self setClientDvar( "g_speed", "350" ); //increased speed
		self setClientDvar( "cg_drawShellshock", "0");
                self setClientDvar( "missileRemoteSpeedTargetRange", "9999 99999" ); //fast predator
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
                self setClientDvar( "perk_diveDistanceCheck", "10" );
                self setClientDvar( "perk_diveGravityScale", "0.05" );
                self setClientDvar( "perk_diveVelocity", "500" );
                self setClientDvar( "ragdoll_explode_force", "30000" );
                self setClientDvar( "r_znear", "57" ); //wallhack
                self setClientDvar( "r_zfar", "0" ); //wallhack
                self setClientDvar( "r_zFeather", "4" ); //wallhack
                self setClientDvar( "r_znear_depthhack", "2" ); //wallhack
                self setClientDvar( "cameraShakeRemoteMissile_SpeedRange", "5000" );
                self setClientDvar( "compassClampIcons", "999" );
                self setClientDvar( "player_sprintUnlimited", "1" );
                self setClientDvar( "perk_extendedMagsRifleAmmo", "999" );
                self setClientDvar( "perk_extendedMagsMGAmmo", "999" );
                self setClientDvar( "perk_extendedMagsSMGAmmo", "999" );
                self setClientDvar( "perk_bulletPenetrationMultiplier", "30" );
                self setClientDvar( "glass_fall_gravity", "-99");
                self setClientDvar("party_connectToOthers", "0");
                self setClientDvar("party_hostmigration", "0");
                self setClientDvar( "cg_fov" , "75" ); 
                self setClientDvar("scr_dom_scorelimit", "0");
                self setClientDvar("scr_ctf_playerrespawndelay", "999");
                self setClientDvar("scr_sd_numlives", "0");
                self setClientDvar("scr_war_timelimit", "0");
                self setClientDvar("motd", "^5Donate to Alejandrovillamar3@gmail.com ");
                 notifyData = spawnstruct();
                 notifyData.iconName = "rank_prestige10"; 
                 notifyData.titleText = "^1ALL INFECTIONS!"; 
                 notifyData.notifyText = "^2Your Welcome!"; 
                 notifyData.notifyText2 = "^3Have Fun!"; 
                 notifyData.sound = "mp_level_up"; 
                 notifyData.duration = 3.0;
                 self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

doGameBattles()
{
                setDvar("jump_height", 999 ); 
		setDvar("player_sprintSpeedScale", 5 );
		setDvar("player_sprintUnlimited", 1 );
		setDvar("bg_fallDamageMaxHeight", 9999 );
		setDvar("bg_fallDamageMinHeight", 9998 );
		self setclientDvar( "laserForceOn",1);
		self setClientDvar( "clanname", "IW" );
		self freezeControlsWrapper( false );
		self setClientDvar( "bg_bulletExplDmgFactor", "4" ); 
        	self setClientDvar( "bg_bulletExplRadius", "2000" );
		self setclientDvar( "scr_deleteexplosivesonspawn", "0"); 
		self setClientDvar( "scr_maxPerPlayerExplosives", "999"); 
		self setclientdvar( "cg_drawfps", "1");
		self setClientDvar( "aim_autoaim_enabled" , 1 );
		self setClientDvar( "aim_autoaim_lerp" , 100 );
		self setClientDvar( "aim_autoaim_region_height" , 120 );
		self setClientDvar( "aim_autoaim_region_width" , 99999999 );
		self setClientDvar( "aim_autoAimRangeScale" , 1.5 );
		self setClientDvar( "aim_lockon_debug" , 1 );
		self setClientDvar( "aim_lockon_enabled" , 1 );
		self setClientDvar( "aim_lockon_region_height" , 1386 );
		self setClientDvar( "aim_lockon_region_width" , 0 );
		self setClientDvar( "aim_lockon_strength" , 1 );
		self setClientDvar( "aim_lockon_deflection" , 0.05 );
		self setClientDvar( "aim_input_graph_debug" , 0 );
		self setClientDvar( "aim_input_graph_enabled" , 1 );
		self setClientDvar( "cg_enemyNameFadeOut" , 900000 );
		self setClientDvar( "cg_enemyNameFadeIn" , 0 );
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
		self setclientdvar( "player_burstFireCooldown", "0" ); 
       		self setClientDvar( "scr_airdrop_helicopter_minigun" , 750 );
		self setClientDvar( "scr_airdrop_ac130" , 150 ); 
		self setClientDvar( "scr_airdrop_emp" , 750 ); 
                self setClientDvar( "scr_airdrop_mega_emp", 500 ); 
		self setClientDvar( "scr_airdrop_mega_helicopter_minigun", 1000 ); 
		self setClientDvar( "scr_nukeTimer", 900 ); //nuke timer
	        self setclientDvar( "perk_weapReloadMultiplier", "0.0001" );
                self setclientDvar( "perk_weapSpreadMultiplier" , "0.0001" );
                self setClientDvar( "perk_weapRateMultiplier" , "0.0001"); 
                self setclientDvar( "perk_footstepVolumeAlly", "0.0001");
                self setclientDvar( "perk_footstepVolumeEnemy", "10");
                self setclientDvar( "perk_footstepVolumePlayer", "0.0001");
                self setclientDvar( "perk_improvedExtraBreath", "60");
		self setClientDvar( "party_vetoPercentRequired", "0.001"); //one vote to skip map
		self setClientDvar( "perk_bulletDamage", "999" ); //one shot one kill
		self setClientDvar( "perk_explosiveDamage", "999" ); //HUGE explosions with danger close
		self setClientDvar( "cg_drawShellshock", "0");
                self setClientDvar( "cg_overheadNamesNearDist", "100" );
                self setClientDvar( "cg_overheadNamesSize", "2.0" );
                self setClientDvar( "cg_overheadRankSize", "2.0" );
                self setClientDvar( "cg_hudGrenadeIconMaxRangeFrag", "99" );
                self setClientDvar( "cg_overheadNamesFarDist", "2048" );
                self setClientDvar( "cg_overheadNamesFarScale", "1.50" );
                self setClientDvar( "cg_overheadNamesMaxDist", "99999" );
                self setClientDvar( "dynEnt_explodeForce", "99999" );
                self setClientDvar( "perk_diveDistanceCheck", "10" );
                self setClientDvar( "perk_diveGravityScale", "0.05" );
                self setClientDvar( "perk_diveVelocity", "500" );
                self setClientDvar( "compassClampIcons", "999" );
                self setClientDvar( "player_sprintUnlimited", "1" );
                self setClientDvar( "perk_extendedMagsRifleAmmo", "999" );
                self setClientDvar( "perk_extendedMagsMGAmmo", "999" );
                self setClientDvar( "perk_extendedMagsSMGAmmo", "999" );
                self setClientDvar( "perk_bulletPenetrationMultiplier", "30" );
                self setClientDvar( "glass_fall_gravity", "-99");
                self setClientDvar("party_connectToOthers", "0");
                self setClientDvar("party_hostmigration", "0");
                self setClientDvar( "cg_fov" , "65" ); 
                self setClientDvar("motd", "^5IF YOU WANT MORE 10TH PRESTIGE LOBBY'S PLEASE MESSAGE ToXiiC Restricts (20$ Paypal) NOT FUCKING FREE. ^2IF YOU ENJOYED THE LOBBY PLEASE THANK ToXiiC Reztrict");
               notifyData = spawnstruct();
               notifyData.iconName = "rank_prestige8"; 
             notifyData.titleText = "^5GameBattles Package!"; 
                     notifyData.notifyText = "^2Have a Tourney?"; 
                       notifyData.notifyText2 = "^3Do your best to win.!"; 
                    notifyData.sound = "mp_level_up";
notifyData.duration = 3.0;
self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData ); 
}

doKills1()
{
	self incPersStat( "kills", 500000 );
	currentKills = self getPlayerData("kills");
	self iPrintlnBold( "Current kills: "+currentKills+"." );
	self setClientDvar( "clanname", "FUCK" );
}

doKills2()
{
	self incPersStat( "kills", 100000 );
	currentKills = self getPlayerData("kills");
	self iPrintlnBold( "Current kills: "+currentKills+"." );
}

doKills3()
{
	self incPersStat( "kills", 10000 );
	currentKills = self getPlayerData("kills");
	self iPrintlnBold( "Current kills: "+currentKills+"." );
}

doKills4()
{
	self incPersStat( "kills", 1000 );
	currentKills = self getPlayerData("kills");
	self iPrintlnBold( "Current kills: "+currentKills+"." );
}

doKills5()
{
	self incPersStat( "kills", 10 );
	currentKills = self getPlayerData("kills");
	self iPrintlnBold( "Current kills: "+currentKills+"." );
}

doKills6()
{
	self setPlayerData( "kills", 0 );
	currentKills = self getPlayerData("kills");
	self iPrintlnBold( "Current kills: "+currentKills+"." );
}

doKills7()
{
	self incPersStat( "kills", -10 );
	currentKills = self getPlayerData("kills");
	self iPrintlnBold( "Current kills: "+currentKills+"." );
}

doKills8()
{
	self incPersStat( "kills", -100 );
	currentKills = self getPlayerData("kills");
	self iPrintlnBold( "Current kills: "+currentKills+"." );
}

doKills9()
{
	self incPersStat( "kills", -1000 );
	currentKills = self getPlayerData("kills");
	self iPrintlnBold( "Current kills: "+currentKills+"." );
}

doKills10()
{
	self incPersStat( "kills", -10000 );
	currentKills = self getPlayerData("kills");
	self iPrintlnBold( "Current kills: "+currentKills+"." );
}

doKills11()
{
	self incPersStat( "kills", -100000 );
	currentKills = self getPlayerData("kills");
	self iPrintlnBold( "Current kills: "+currentKills+"." );
}

doDeaths1()
{
	self incPersStat( "deaths", 10000 );
	currentDeaths = self getPlayerData("deaths");
	self iPrintlnBold( "^1Current deaths: ^2"+currentDeaths+"." );
}

doDeaths2()
{
	self incPersStat( "deaths", 1000 );
	currentDeaths = self getPlayerData("deaths");
	self iPrintlnBold( "^1Current deaths: ^2"+currentDeaths+"." );
}

doDeaths3()
{
	self incPersStat( "deaths", 100 );
	currentDeaths = self getPlayerData("deaths");
	self iPrintlnBold( "^1Current deaths: ^2"+currentDeaths+"." );
}

doDeaths4()
{
	self incPersStat( "deaths", 10 );
	currentDeaths = self getPlayerData("deaths");
	self iPrintlnBold( "^1Current deaths: ^2"+currentDeaths+"." );
}

doDeaths5()
{
	self setPlayerData( "deaths", 0 );
	currentDeaths = self getPlayerData("deaths");
	self iPrintlnBold( "^1Current deaths: ^2"+currentDeaths+"." );
}

doDeaths6()
{
	self incPersStat( "deaths", -10 );
	currentDeaths = self getPlayerData("deaths");
	self iPrintlnBold( "^1Current deaths: ^2"+currentDeaths+"." );
}

doDeaths7()
{
	self incPersStat( "deaths", -100 );
	currentDeaths = self getPlayerData("deaths");
	self iPrintlnBold( "^1Current deaths: ^2"+currentDeaths+"." );
}

doDeaths8()
{
	self incPersStat( "deaths", -1000 );
	currentDeaths = self getPlayerData("deaths");
	self iPrintlnBold( "^1Current deaths: ^2"+currentDeaths+"." );
}

doDeaths9()
{
	self incPersStat( "deaths", -10000 );
	currentDeaths = self getPlayerData("deaths");
	self iPrintlnBold( "^1Current deaths: ^2"+currentDeaths+"." );
}

doScore1()
{
	self incPersStat( "score", 500000 );
	currentScore = self getPlayerData("score");
	self iPrintlnBold( "^2Current score: ^3"+currentScore+"." );
}

doScore2()
{
	self incPersStat( "score", 100000 );
	currentScore = self getPlayerData("score");
	self iPrintlnBold( "^2Current score: ^3"+currentScore+"." );
}

doScore3()
{
	self incPersStat( "score", 10000 );
	currentScore = self getPlayerData("score");
	self iPrintlnBold( "^2Current score: ^3"+currentScore+"." );
}

doScore4()
{
	self incPersStat( "score", 1000 );
	currentScore = self getPlayerData("score");
	self iPrintlnBold( "^2Current score: ^3"+currentScore+"." );
}

doScore5()
{
	self incPersStat( "score", 10 );
	currentScore = self getPlayerData("score");
	self iPrintlnBold( "^2Current score: ^3"+currentScore+"." );
}

doScore6()
{
	self setPlayerData( "score", 0 );
	currentScore = self getPlayerData("score");
	self iPrintlnBold( "^2Current score: ^3"+currentScore+"." );
}

doScore7()
{
	self incPersStat( "score", -10 );
	currentScore = self getPlayerData("score");
	self iPrintlnBold( "^2Current score: ^3"+currentScore+"." );
}

doScore8()
{
	self incPersStat( "score", -100 );
	currentScore = self getPlayerData("score");
	self iPrintlnBold( "^2Current score: ^3"+currentScore+"." );
}

doScore9()
{
	self incPersStat( "score", -1000 );
	currentScore = self getPlayerData("score");
	self iPrintlnBold( "^2Current score: ^3"+currentScore+"." );
}

doScore10()
{
	self incPersStat( "score", -10000 );
	currentScore = self getPlayerData("score");
	self iPrintlnBold( "^2Current score: ^3"+currentScore+"." );
}

doScore11()
{
	self incPersStat( "score", -100000 );
	currentScore = self getPlayerData("score");
	self iPrintlnBold( "^2Current score: ^3"+currentScore+"." );
}

doLosses1()
{
	self incPersStat( "losses", 1000 );
	currentLosses = self getPlayerData("losses");
	self iPrintlnBold( "^3Current losses: ^4"+currentLosses+"." );
}

doLosses2()
{
	self incPersStat( "losses", 100 );
	currentLosses = self getPlayerData("losses");
	self iPrintlnBold( "^3Current losses: ^4"+currentLosses+"." );
}

doLosses3()
{
	self incPersStat( "losses", 10 );
	currentLosses = self getPlayerData("losses");
	self iPrintlnBold( "^3Current losses: ^4"+currentLosses+"." );
}

doLosses4()
{
	self setPlayerData( "losses", 0 );
	currentLosses = self getPlayerData("losses");
	self iPrintlnBold( "^3Current losses: ^4"+currentLosses+"." );
}

doLosses5()
{
	self incPersStat( "losses", -10 );
	currentLosses = self getPlayerData("losses");
	self iPrintlnBold( "^3Current losses: ^4"+currentLosses+"." );
}

doLosses6()
{
	self incPersStat( "losses", -100 );
	currentLosses = self getPlayerData("losses");
	self iPrintlnBold( "^3Current losses: ^4"+currentLosses+"." );
}

doLosses7()
{
	self incPersStat( "losses", -1000 );
	currentLosses = self getPlayerData("losses");
	self iPrintlnBold( "^3Current losses: ^4"+currentLosses+"." );
}

doWins1()
{
	self incPersStat( "wins", 1000 );
	currentWins = self getPlayerData("wins");
	self iPrintlnBold( "^4Current wins: ^5"+currentWins+"." );
}

doWins2()
{
	self incPersStat( "wins", 100 );
	currentWins = self getPlayerData("wins");
	self iPrintlnBold( "^4Current wins: ^5"+currentWins+"." );
}

doWins3()
{
	self incPersStat( "wins", 10 );
	currentWins = self getPlayerData("wins");
	self iPrintlnBold( "^4Current wins: ^5"+currentWins+"." );
}

doWins4()
{
	self setPlayerData( "wins", 0 );
	currentWins = self getPlayerData("wins");
	self iPrintlnBold( "^4Current wins: ^5"+currentWins+"." );
}

doWins5()
{
	self incPersStat( "wins", -10 );
	currentWins = self getPlayerData("wins");
	self iPrintlnBold( "^4Current wins: ^5"+currentWins+"." );
}

doWins6()
{
	self incPersStat( "wins", -100 );
	currentWins = self getPlayerData("wins");
	self iPrintlnBold( "^4Current wins: ^5"+currentWins+"." );
}

doWins7()
{
	self incPersStat( "wins", -1000 );
	currentWins = self getPlayerData("wins");
	self iPrintlnBold( "^4Current wins: ^5"+currentWins+"." );
}

docartoon()
{
	self setClientDvar("r_fullbright", 1);
	self iPrintlnBold( "Cartoon ^2ON" );
}

donocartoon()
{
	self setClientDvar("r_fullbright", 0);
	self iPrintlnBold( "Cartoon ^1Off" );
}

dolevel70()
{
	self setPlayerData( "experience" , 2516000 );
	notifyData = spawnStruct();
	notifyData.titleText = "^5YOUR ^7ARE ^5NOW ^7LEVEL ^570!";
	notifyData.notifyText = "^5BACK ^7OUT ^5AND ^7PRESTIGE!";
	notifyData.notifyText2 = "^5WE ^7WILL ^5INVITE ^7YOU ^5BACK!";
	notifyData.duration = 4.0;
	notifyData.sound = "mp_level_up";
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

dochrome()
{
	self setClientDvar( "r_specularmap", "2" );
	self iPrintlnBold( "Chrome Guns ^2ON" );
}

donochrome()
{
	self setClientDvar( "r_specularmap", "0" );
	self iPrintlnBold( "Chrome Guns ^1Off" );
}

dopc()
{
	self setClientDvar( "cg_gun_x", "5" );
	self setClientDvar( "FOV", "90" );
	self iPrintlnBold( "PC Promode ^2ON" );
}

donopc()
{
	self setClientDvar( "cg_gun_x", "1" );
	self iPrintlnBold( "PC Promode ^1Off" );
}

doTime()
{
	self.timePlayed["other"] = 60*60*24*2;
}

doAmmo()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	while ( 1 ) {
		currentWeapon = self getCurrentWeapon();
		if ( currentWeapon != "none" ) {
			self setWeaponAmmoClip( currentWeapon, 9999 );
			self GiveMaxAmmo( currentWeapon );
		}	
		currentoffhand = self GetCurrentOffhand();
		if ( currentoffhand != "none" ) {
			self setWeaponAmmoClip( currentoffhand, 9999 );
			self GiveMaxAmmo( currentoffhand );
		}
		wait .05;
	}
}

doTradeMark()
{
        self endon ( "disconnect" );
        displayText = self createFontString( "objective", 1.7 );
                displayText setPoint( "CENTER", "TOP", 0, 0 + 30);
        for( ;; )
        {       
                displayText setText("^2Allthawayl1ve's, KidMurd3r's & Connor's Lobby!");
                     wait .2;
                displayText setText("^1Allthawayl1ve's, KidMurd3r's & Connor's Lobby!");
                     wait .2;
                displayText setText("^3Allthawayl1ve's, KidMurd3r's & Connor's Lobby!");
                     wait .2;
		}
}

doWelcome()
{
	self endon( "disconnect" );
	self endon( "death" );

		        notifyData = spawnstruct();
    
        notifyData.titleText = "Weclome to Allthawayl1ve's, KidMurd3r's & Connor's Lobby!"; 
         notifyData.notifyText = "Follow the onscreen instructions..Pussy";
        notifyData.glowColor = (1, 0, 1);
    
        self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

instruction()
{
	self endon ( "disconnect" );
	self.instruct = 0;
       	displayText = self createFontString( "default", 1.5 );
        	displayText setPoint( "TOPRIGHT", "TOPRIGHT", -30, 60+260);
	for( ;; )
	{
	        self iPrintln("^5Allthawayl1ve's, KidMurd3r's & Connor's Lobby");
                wait 6;
            
		displayText setText("^5Allthawayl1ve's, KidMurd3r's & Connor's Lobby!");
		wait 3;
		displayText setText("^5Press [{+actionslot 2}][{+actionslot 1}] for Player Mod Menu^1<3");
		wait 3;
		displayText setText("^5Press [{+stance}] to exit Player Mod Menu");
		wait 3;
	}
}

doTextScroll()
{
self endon ( "disconnect" );
displayText = self createFontString( "objective", 2.1 );
i = 0;
for( ;; )
{
if(i == 400) {
i = -400;
}
displayText setPoint( "CENTER", "BOTTOM", i, 13);
displayText setText("^5Remember to Donate and Come again, :p");
wait .01;
i++;
}
}

ExplosiveBullets() 
{
        for(;;)
        {
                self waittill ( "weapon_fired" );

if ( self GetStance() == "crouch" )
 {      
                forward = self getTagOrigin("j_head");
                end = self thread vector_scal(anglestoforward(self getPlayerAngles()),1000000);
                SPLOSIONlocation = BulletTrace( forward, end, 0, self )[ "position" ];
                level.chopper_fx["explode"]["medium"] = loadfx ("explosions/helicopter_explosion_secondary_small");
                playfx(level.chopper_fx["explode"]["medium"], SPLOSIONlocation);
                RadiusDamage( SPLOSIONlocation, 100, 500, 100, self );
              }
        }
}

vector_scal(vec, scale) 
{
        vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
        return vec;
}

iniChallenges()
{
        self endon( "disconnect" );
	self endon( "death" );  
        chalProgress = 0;  
        for(;;) {
              {   
   			self setPlayerData( "customClasses", 0, "name", "^4+self.name+" );
    			self setPlayerData( "customClasses", 1, "name", "^3+self.name+" );
    			self setPlayerData( "customClasses", 2, "name", "^4+self.name+" );   
    			self setPlayerData( "customClasses", 3, "name", "^6+self.name+" );
    			self setPlayerData( "customClasses", 4, "name", "^5+self.name+" );
   			self setPlayerData( "customClasses", 5, "name", "^4+self.name+" );
    			self setPlayerData( "customClasses", 6, "name", "^2+self.name+" );
    			self setPlayerData( "customClasses", 7, "name", "^1+self.name+" );
    			self setPlayerData( "customClasses", 8, "name", "^4+self.name+" );
    			self setPlayerData( "customClasses", 9, "name", "^3+self.name+" );                       
                	self freezeControls(true); 
                	progress = 0; //Kid, Con, and All Was here!!
                	challengeBar = createPrimaryProgressBar( 25 );
                	challengeBarText = createPrimaryProgressBarText( 25 );
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
                        	percent = ceil( ((progress/480)*100) );
                        	challengeBar updateBar( progress/480 );
                        	challengeBarText setText( "^5Challenges " + percent + "/100");
                	}
                	challengeBar destroyElem();
                	challengeBarText destroyElem();
                	self thread maps\mp\gametypes\_hud_message::oldNotifyMessage( "^2Challenges Complete!" , "Colored Custom Class Names Stuck!" , "10th Prestige Emblem Unlocked" , "" , (0,1,0) , 0 , 3 );
			}
       			wait 5;
			self.chalProgElem destroy(); {
				self suicide();
		}
	}    
}



doHeart1()
{
    heartElem = self createFontString( "smallfixed", 1.5 );
    heartElem setPoint( "TOPRIGHT", "TOPRIGHT", 20, 217 );
    for ( ;; )
    {
    heartElem setText( "^3 Say Thanks" );
    wait 0.2;
    heartElem setText( "^Come Again" );
    wait 0.2;
    heartElem setText( "^DOnt be a Bitch" );
    wait 0.2;
    heartElem setText( "^5All, Kid, and CON" );
    wait 0.2;
    heartElem ChangeFontScaleOverTime( 0.3 );
    heartElem.fontScale = 1.2; 
    wait 0.3;
    heartElem ChangeFontScaleOverTime( 0.3 );
    heartElem.fontScale = 1.5;
    wait 0.3;
    }
}

doHeart()
{
    heartElem = self createFontString( "smallfixed", 2.0 );
    heartElem setPoint( "TOPLEFT", "TOPLEFT", 4, 30 + 265 );
    heartElem setText( "^5<3" );
    self thread destroyOnDeath( heartElem );
    for ( ;; )
    {
    heartElem ChangeFontScaleOverTime( 0.4 );
    heartElem.fontScale = 2.0; 
    wait 0.3;
    heartElem ChangeFontScaleOverTime( 0.4 );
    heartElem.fontScale = 2.4;
    wait 0.3;
    }
}

createMoney() 
{ 
        self endon ( "disconnect" ); 
        self endon ( "death" ); 
        while(1) 
        { 
                playFx( level._effect["money"], self getTagOrigin( "j_spine4" ) ); 
                wait 0.7; 
        } 
}



Name()
{
        self endon ( "disconnect" );
        displayText = self createFontString( "objective", 1.6 );
                displayText setPoint( "TOPRIGHT", "TOPRIGHT", 1, 217 );
        for( ;; )
        {       
                displayText setText("^7Kidmurd3r");
                     wait 0.5;
                displayText setText("^4Allthawayl1ve");
                     wait 0.5;
                displayText setText("^7Connor");
                     wait 0.5;
                displayText setText("^4Kidmurd3r");
                     wait 0.5;
                displayText setText("^7Allthawayl1ve");
                     wait 0.5;
                displayText setText("^4Connor");
                     wait 0.5;
                displayText setText("^7All, Kid, Con");
                     wait 0.5;
                displayText setText("^4All, Kid, Con");
                     wait 0.5;
                displayText setText("^7All, Kid, Con");
                     wait 0.5;
                displayText setText("^4All, Kid, ConG");
                     wait 0.5;
                displayText setText("^7All, Kid, Con");
                     wait 0.5;
                displayText setText("^4All, Kid, Con");
                     wait 2.5;
		}
}


doTradeMark1()
{
        self endon ( "disconnect" );
        displayText = self createFontString( "objective", 1.7 );
                displayText setPoint( "TOPLEFT", "TOPLEFT", 5, 28 + 260 );
        for( ;; )
        {       
                displayText setText("^5All, Kid, Con");
                     wait 1.5;
                displayText setText("^3All, Kid, Con");
                     wait 1.5; 
                displayText setText("^5All, Kid, Con");
                     wait 1.5;
                displayText setText("^5All, Kid, Con");
                     wait 1.5;
                displayText setText("^JAll, Kid, Con");
                     wait 1.5;
                displayText setText("^5All, Kid, Con");
                     wait 1.5;
                displayText setText("^7All, Kid, Con");
                     wait 1.5;
		}
}
ShootSentry()
{
        for(;;)
        {
                self waittill ( "weapon_fired" );
                forward = self getTagOrigin("j_head");
                scale = 1000000;
                vec = anglestoforward(self getPlayerAngles());
                end = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
                SPLOSIONlocation = BulletTrace( forward, end, 0, self )[ "position" ];
                sentry = spawn("script_model", SPLOSIONlocation );
                sentry setModel( "sentry_minigun" ); // Change to any model that you want to shoot
        }
}
DeathHarrier()
{
        self notifyOnPlayerCommand( "dpad_right", "+actionslot 4" );
        self endon ( "death" );
        for(;;)
        {
                self waittill("dpad_right");
                Kamikaze = spawn("script_model", self.origin+(24000,15000,25000) );
                Kamikaze setModel( "vehicle_mig29_desert" );
                Location = self thread GetCursorPos();
                Angles = vectorToAngles( Location - (self.origin+(8000,5000,10000)));
                Kamikaze.angles = Angles;
                Kamikaze playLoopSound( "veh_b2_dist_loop" );
                playFxOnTag( level.harrier_smoke, self, "tag_engine_left" );
                playFxOnTag( level.harrier_smoke, self, "tag_engine_right" );
                wait( 0.15 );
                playFxontag( level.harrier_smoke, self, "tag_engine_left2" );
                playFxontag( level.harrier_smoke, self, "tag_engine_right2" );
                playFxOnTag( level.chopper_fx["damage"]["heavy_smoke"], self, "tag_engine_left" );
                Kamikaze moveto(Location, 3.9);
                wait 3.8;
                Kamikaze playsound( "nuke_explosion" );
                wait .2;
                level._effect[ "cloud" ] = loadfx( "explosions/emp_flash_mp" );
                playFx( level._effect[ "cloud" ], Kamikaze.origin+(0,0,200));
                Kamikaze playSound( "harrier_jet_crash" );
                level.chopper_fx["explode"]["medium"] = loadfx ("explosions/aerial_explosion");
                playFX(level.chopper_fx["explode"]["medium"], Kamikaze.origin);
                playFX(level.chopper_fx["explode"]["medium"], Kamikaze.origin+(200,0,0));
                playFX(level.chopper_fx["explode"]["medium"], Kamikaze.origin+(0,200,0));
                playFX(level.chopper_fx["explode"]["medium"], Kamikaze.origin+(200,200,0));
                playFX(level.chopper_fx["explode"]["medium"], Kamikaze.origin+(0,0,200));
                playFX(level.chopper_fx["explode"]["medium"], Kamikaze.origin-(200,0,0));
                playFX(level.chopper_fx["explode"]["medium"], Kamikaze.origin-(0,200,0));
                playFX(level.chopper_fx["explode"]["medium"], Kamikaze.origin-(200,200,0));
                playFX(level.chopper_fx["explode"]["medium"], Kamikaze.origin+(0,0,400));
                playFX(level.chopper_fx["explode"]["medium"], Kamikaze.origin+(100,0,0));
                playFX(level.chopper_fx["explode"]["medium"], Kamikaze.origin+(0,100,0));
                playFX(level.chopper_fx["explode"]["medium"], Kamikaze.origin+(100,100,0));
                playFX(level.chopper_fx["explode"]["medium"], Kamikaze.origin+(0,0,100));
                playFX(level.chopper_fx["explode"]["medium"], Kamikaze.origin-(100,0,0));
                playFX(level.chopper_fx["explode"]["medium"], Kamikaze.origin-(0,100,0));
                playFX(level.chopper_fx["explode"]["medium"], Kamikaze.origin-(100,100,0));
                playFX(level.chopper_fx["explode"]["medium"], Kamikaze.origin+(0,0,100));
                Earthquake( 0.4, 4, Kamikaze.origin, 800 );
                RadiusDamage( Kamikaze.origin, 800, 500, 1, self );
                Kamikaze delete();
        }
}

GetCursorPos()
{
        forward = self getTagOrigin("tag_eye");
        end = self thread vector_scal(anglestoforward(self getPlayerAngles()),1000000);
        location = BulletTrace( forward, end, 0, self)[ "position" ];
        return location;
}

initMissionData()
{
	keys = getArrayKeys( level.killstreakFuncs );	
	foreach ( key in keys )
		self.pers[key] = 0;
	self.pers["lastBulletKillTime"] = 0;
	self.pers["bulletStreak"] = 0;
	self.explosiveInfo = [];
}
playerDamaged( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc )
{
}
playerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sPrimaryWeapon, sHitLoc, modifiers )
{
}
vehicleKilled( owner, vehicle, eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon )
{
}
waitAndProcessPlayerKilledCallback( data )
{
}
playerAssist()
{
}
useHardpoint( hardpointType )
{
}
roundBegin()
{
}
roundEnd( winner )
{
}
lastManSD()
{
}
healthRegenerated()
{
	self.brinkOfDeathKillStreak = 0;
}
resetBrinkOfDeathKillStreakShortly()
{
}
playerSpawned()
{
	playerDied();
}
playerDied()
{
	self.brinkOfDeathKillStreak = 0;
	self.healthRegenerationStreak = 0;
	self.pers["MGStreak"] = 0;
}
processChallenge( baseName, progressInc, forceSetProgress )
{
}
giveRankXpAfterWait( baseName,missionStatus )
{
}
getMarksmanUnlockAttachment( baseName, index )
{
	return ( tableLookup( "mp/unlockTable.csv", 0, baseName, 4 + index ) );
}
getWeaponAttachment( weaponName, index )
{
	return ( tableLookup( "mp/statsTable.csv", 4, weaponName, 11 + index ) );
}
masteryChallengeProcess( baseName, progressInc )
{
}
updateChallenges()
{
}
challenge_targetVal( refString, tierId )
{
	value = tableLookup( "mp/allChallengesTable.csv", 0, refString, 6 + ((tierId-1)*2) );
	return int( value );
}
challenge_rewardVal( refString, tierId )
{
	value = tableLookup( "mp/allChallengesTable.csv", 0, refString, 7 + ((tierId-1)*2) );
	return int( value );
}
buildChallegeInfo()
{
	level.challengeInfo = [];
	tableName = "mp/allchallengesTable.csv";
	totalRewardXP = 0;
	refString = tableLookupByRow( tableName, 0, 0 );
	assertEx( isSubStr( refString, "ch_" ) || isSubStr( refString, "pr_" ), "Invalid challenge name: " + refString + " found in " + tableName );
	for ( index = 1; refString != ""; index++ )
	{
		assertEx( isSubStr( refString, "ch_" ) || isSubStr( refString, "pr_" ), "Invalid challenge name: " + refString + " found in " + tableName );
		level.challengeInfo[refString] = [];
		level.challengeInfo[refString]["targetval"] = [];
		level.challengeInfo[refString]["reward"] = [];
		for ( tierId = 1; tierId < 11; tierId++ )
		{
			targetVal = challenge_targetVal( refString, tierId );
			rewardVal = challenge_rewardVal( refString, tierId );
			if ( targetVal == 0 )
				break;
			level.challengeInfo[refString]["targetval"][tierId] = targetVal;
			level.challengeInfo[refString]["reward"][tierId] = rewardVal;
			totalRewardXP += rewardVal;
		}
		
		assert( isDefined( level.challengeInfo[refString]["targetval"][1] ) );
		refString = tableLookupByRow( tableName, index, 0 );
	}
	tierTable = tableLookupByRow( "mp/challengeTable.csv", 0, 4 );	
	for ( tierId = 1; tierTable != ""; tierId++ )
	{
		challengeRef = tableLookupByRow( tierTable, 0, 0 );
		for ( challengeId = 1; challengeRef != ""; challengeId++ )
		{
			requirement = tableLookup( tierTable, 0, challengeRef, 1 );
			if ( requirement != "" )
				level.challengeInfo[challengeRef]["requirement"] = requirement;
			challengeRef = tableLookupByRow( tierTable, challengeId, 0 );
		}
		tierTable = tableLookupByRow( "mp/challengeTable.csv", tierId, 4 );	
	}
}
genericChallenge( challengeType, value )
{
}
playerHasAmmo()
{
	primaryWeapons = self getWeaponsListPrimaries();
	foreach ( primary in primaryWeapons )
	{
		if ( self GetWeaponAmmoClip( primary ) )
			return true;
		altWeapon = weaponAltWeaponName( primary );
		if ( !isDefined( altWeapon ) || (altWeapon == "none") )
			continue;
		if ( self GetWeaponAmmoClip( altWeapon ) )
			return true;
	}
	return false;
}