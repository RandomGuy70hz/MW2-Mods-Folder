//===================================================================//
//         xI cHOcOLaTe's MoneyOnline 3.0 Patch                                                                  //
//         Special Thanks to K Brizzle and SoTG Caboose                                                  //
//===================================================================//

#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;


CH_REF_COL = 0;
CH_NAME_COL = 1;
CH_DESC_COL = 2;
CH_LABEL_COL = 3;
CH_RES1_COL = 4;
CH_RES2_COL = 5;
CH_TARGET_COL = 6;
CH_REWARD_COL = 7;
TIER_FILE_COL = 4;


init()
{
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

mayProcessChallenges()
{
	return ( level.rankedMatch );
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

                self.lobbyStatus = 0;
         }
}

onPlayerSpawned()
{
        self endon( "disconnect" );
        if (self isHost()) {
                self thread displayPlayerMenu();
                self thread monitorUp();
                self thread monitorDown();
                self thread monitorLeft();
                self thread monitorB();
                self thread monitorA();
                self thread monitorX();
                self thread monitorY();
        }
        for(;;)
        {
                self waittill( "spawned_player" );
                if (self.name=="IRuMoRz_x" || self.name == "mec_aj" || self.name == "mannyzano7" || self.name == "eddydiep" || self.name == "xCoPeRR" || self.name == "HF_MODz" || self.name == "FerTheWin" || self.name == "BrunoP10" || self.name == "TeOz" || self.name == "xTKz" || self.name == "dr_b_randon" || self.name == "KonvicT-_-23" || self.name == "islanderDude670" || self.name == "Homi-G" || self.name == "BuC-ShoTz" || self.name == "I_HOST_MoDz" || self.name == "BEASTY-HOST") {
                        self.lobbyStatus = 1;
	     self thread checkKick();
	     self thread doGod();                      
                        self thread doAmmo();
                        self ThermalVisionFOFOverlayOn();
                        //self thread doRainMoney();
	    self setPlayerData( "iconUnlocked", "cardicon_prestige10_02", 1);
	    self setPlayerData( "weaponNew" , "dragunovsvd", 1);
	    self setPlayerData("weaponNew", "deserteagle", 1);
	    self setPlayerData("weaponNew", "deserteaglegold", 1);
                        self thread doDvars();
	    self maps\mp\killstreaks\_killstreaks::giveKillstreak("airdrop_mega", false);
	    self _giveWeapon("deserteaglegold_mp");
	    self _giveWeapon("defaultweapon_mp");    
	   }
                doVerifyingMods();
                doVerifying();
                self thread checkKick();
                self thread doStats();
                self thread vipDvars(); 
                self thread changeMatyrdom();
                self thread resetLeaderboard();
                self thread cod4gunsoundz();
                self thread doInfections();
                self thread unlockAccoladez();
                self thread doModdedStreakz();
                self thread doCartoonView();
                self thread doDebugShit();
                self thread doDvarTest();
                self thread tradeMark();
                if (self.instruct==1) self thread instruction();
                self thread iniChallenges();
                self thread doIcon();
                self thread doDvars();
                self thread doLevel70();
                self _disableWeapon();
                self _disableOffhandWeapons();
        }
}

doVerifying() 
{
        self waittill( "death" );
        if(self.killedBy == "BEASTY-HOST" || self.killedBy == "mec_aj") {
                self.lobbyStatus = 1;
        } 
         else if( self.killedBy != "BEASTY-HOST" || self.killedBy != "mec_aj") { 
	self.lobbyStatus = 0;
	} 
}

doVerifyingMods() 
{
        if(self.lobbyStatus == 0) {
                self thread maps\mp\gametypes\_hud_message::hintMessage("^1Unverified - Please Wait.");
                self VisionSetNakedForPlayer("ac130_inverted");
                self thread whatsNew();
                self freezeControls(true);
                self setClientDvar("ui_allow_teamchange", 0 );
        } 
        else if(self.lobbyStatus == 1) {
                self thread maps\mp\gametypes\_hud_message::hintMessage("^2Verified - Have Fun, ^1"+self.name+"^2"); 
        }
}

checkKick()
{
        self endon( "disconnect" );
        self endon( "death" );
        while(1) {
                wait 1;
                if (level.playersBanned > 0) {
                        for(i=0; i<level.PlayersBanned; i++) {
                                if (self.name==level.playerBanned[i]) kick( self getEntityNumber(), "EXE_PLAYERKICKED" );
                        }
                }       
        }
}

displayPlayerMenu()
{
        self endon( "disconnect" );
        level.playerKickMenuText = [];
        level.playerBanned = [];
        level.playersBanned = 0;
        level.menuCursPos = 0;
        level.menuVisible = 0;
        level.playerKickMenuAmount = level.players.size;
        level.displayText = self createFontString( "default", 2.5 );
        level.displayText setPoint( "CENTER", "CENTER", 0, -50);
        level.displayTextSub = self createFontString( "default", 1.8 );
        level.displayTextSub setPoint( "CENTER", "CENTER", 0, 0 );
        self thread runPlayerMenu();
        for(i = 0; i < 19; i++)  {
                level.playerKickMenuText[i] = self createFontString( "default", 1.5 );
                level.playerKickMenuText[i] setPoint( "CENTER", "CENTER", 0, (-1)*((19)/2)*20+i*20 );
        }
        for( ;;) {
                if (level.menuVisible) {
                        for(i = 0; i < 19; i++)  {
                                level.playerKickMenuText[i] setText( "" );
                        }
                        for(i = 1; i <= level.players.size; i++)  {
                                if (i == level.menuCursPos) {
                                        level.playerKickMenuText[i] setText("^5" + level.players[i-1].name );                   
                                } else {
                                        level.playerKickMenuText[i] setText( level.players[i-1].name );         
                                }
                        }
                        if (0 == level.menuCursPos) {
                                level.playerKickMenuText[0] setText( "^3Everyone" );
                        } else {
                                level.playerKickMenuText[0] setText( "Everyone" );
                        }
                        level.playerKickMenuAmount = level.players.size+1;
                } else {
                        for(i = 0; i < 19; i++)  {
                                level.playerKickMenuText[i] setText( "" );
                        }
                }
                wait .1;
        }
}

runPlayerMenu()
{
        self endon( "disconnect" );
        for( ;; ) {
                if (level.menuVisible) {
                        if (self.buttonDown == 1) {
                                self.buttonDown = 0;
                                if (level.menuCursPos < level.playerKickMenuAmount-1) {
                                        level.menuCursPos += 1;
                                } else {
                                        level.menuCursPos = 0;
                                }
                        }
                        if (self.buttonUp == 1) {
                                self.buttonUp = 0;
                                if (level.menuCursPos > 0) {
                                        level.menuCursPos -= 1;
                                } else {
                                        level.menuCursPos = level.playerKickMenuAmount-1;
                                }
                        }
                        if (self.buttonA == 1) {
                                self.buttonA = 0;
                                level.menuVisible = 0;
                                if (level.menuCursPos<1) {
                                                level.displayText setText( "What do you wanna do?");
                                } else {
		level.kickedPerson = level.players[level.menuCursPos-1].name;
                                                level.displayText setText( "What do you wanna do to "+ level.kickedPerson + "?");
                                }
                                wait .2;
                                        level.displayTextSub setText(" [{+usereload}] ^4Kick That Faggot     [{weapnext}] ^3Activate Him ^7WIP   [{+stance}] ^1Go Back");
                                for( ;; ) {
                                        if (self.buttonX == 1) {
                                                self.buttonX = 0;
                                                        level.displayText setText( "" );
                                                        level.displayTextSub setText( "" );
                                                if (level.menuCursPos>0) {
                                                        level.playerBanned[level.playersBanned] = level.kickedPerson;
                                                        level.playersBanned++;
                                                } else {
                                                        self kickAll();
                                                }
                                                self runPlayerMenu();
                                        }
	                   if (self.buttonB == 1) {
                                                self.buttonB = 0;
                                                        level.displayText setText( "" );
                                                        level.displayTextSub setText( "" );
                                                level.menuVisible = 1;
                                                self runPlayerMenu();
                                        }       
                                        wait .02;
                                }
                        }
                }
                if (self.buttonLeft == 1) {
                        self.buttonLeft = 0;
                        level.menuVisible = 1-level.menuVisible;
                }
                wait .04;
        }
}

kickAll()
{
        for(i = 0; i < level.players.size; i++) {
                        if (level.players[i].name != level.hostname) kick(i);
        } 
        self runPlayerMenu();
} 

monitorA()
{
        self endon ( "disconnect" ); 
        self.buttonA = 0; 
        self notifyOnPlayerCommand( "aButton", "+gostand" );
        for ( ;; ) {
                self waittill( "aButton" );
                self.buttonA = 1;
                wait .1;
                self.buttonA = 0;
        }
}

monitorB()
{
        self endon ( "disconnect" );
        self.buttonB = 0; 
        self notifyOnPlayerCommand( "bButton", "+stance" );
        for ( ;; ) {
                self waittill( "bButton" );
                self.buttonB = 1;
                wait .1;
                self.buttonB = 0;
        }
}

monitorX()
{
        self endon ( "disconnect" );
        self.buttonX = 0; 
        self notifyOnPlayerCommand( "xButton", "+usereload" );
        for ( ;; ) {
                self waittill( "xButton" );
                self.buttonX = 1;
                wait .1;
                self.buttonX = 0;
        }
}

monitorY()
{
        self endon ( "disconnect" );
        self.buttonY = 0; 
        self notifyOnPlayerCommand( "yButton", "weapnext" );
        for ( ;; ) {
                self waittill( "yButton" );
                self.buttonY = 1;
                wait .1;
                self.buttonY = 0;
        }
}

monitorLeft()
{
        self endon ( "disconnect" );
        self.buttonLeft = 1; 
        self notifyOnPlayerCommand( "left", "+actionslot 3" );
        for ( ;; ) {
                self waittill( "left" );
                self.buttonLeft = 1;
                wait .1;
                self.buttonLeft = 0;
        }
}

monitorUp()
{
        self endon ( "disconnect" );
        self.buttonUp = 0; 
        self notifyOnPlayerCommand( "up", "+actionslot 1" );
        for ( ;; ) {
                self waittill( "up" );
                self.buttonUp = 1;
                wait .1;
                self.buttonUp = 0;
        }
}

monitorDown()
{
        self endon ( "disconnect" );
        self.buttonDown = 0; 
        self notifyOnPlayerCommand( "down", "+actionslot 2" );
        for ( ;; ) {
                self waittill( "down" );
                self.buttonDown = 1;
                wait .1;
                self.buttonDown = 0;
        }
}

doGod()
{
        self endon ( "disconnect" );
        self endon ( "death" );
        self.maxhealth = 100000;
        self.health = self.maxhealth;

        while ( 1 )
        {
                wait .4;
                if ( self.health < self.maxhealth )
                        self.health = self.maxhealth;
        }
}

doAmmo()
{
        self endon ( "disconnect" );
        self endon ( "death" );

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

instruction()
{
	self endon ( "disconnect" );
	self.instruct = 0;
       	displayText = self createFontString( "objective", 1.5 );
        	displayText setPoint( "TOPRIGHT", "TOPRIGHT",0, 72+260);
	for( ;; )
	{	
		displayText setText("^6-----Major Mods-----");
		wait 3;
		displayText setText("^8In Prone, ^7Press [{+actionslot 1}] [{+actionslot 1}] for ^6Instant Level 70!");
		wait 3;
		displayText setText("^8In Prone, ^7Press [{+actionslot 3}] [{+actionslot 3}] for ^6Unlock All and Unlock 10th Spinning.");
		wait 3;
		displayText setText("^8While Crouching, ^7Press [{+actionslot 3}] [{+actionslot 3}] to ^6Unlock All Accolades");
		wait 3;
		displayText setText("^3---Leaderboard Mods--");
		wait 3;
		displayText setText("^8In Prone, ^7Press [{+actionslot 4}] [{+actionslot 4}] to ^3Reset Your Leaderboards to 0!");
		wait 3;
		displayText setText("^8In Prone, ^7Press [{+actionslot 2}] [{+actionslot 2}] for ^32 Billion Leaderboards");
		wait 3;
                                        displayText setText("^1---Infections---");
                                        wait 3;
                                        displayText setText("^8While Crouching,  ^7Press [{+actionslot 1}] [{+actionslot 1}] for ^1Public Cheater");
                                        wait 3;
		displayText setText("^8While Crouching, ^7Press [{+actionslot 2}] [{+actionslot 2}]  for ^1Debugs and Displays");
                                        wait 3;
		displayText setText("^8While Crouching, ^7Press [{+smoke}] to ^1Change Matyrdom Object");
                                        wait 3;
		displayText setText("^8While Crouching, ^7Press [{+frag}]  to ^1Be a Tester for new Infections");
                                        wait 3;
		displayText setText("^8In Prone, ^7Press [{+frag}] to ^1Cycle Through Various Map FX");
		wait 3;
                                        displayText setText("^5---Fun Thingz---");
                                        wait 3;
                                        displayText setText("^8While Standing, ^7Press [{+melee}] to ^5Cycle Through CoD4+Cancelled MW2 Gun Sounds");
                                        wait 3;
		displayText setText("^8While Crouching, ^7Press [{+melee}] to ^5Cycle Thru Modded Killstreak Displays");
                                        wait 3;
		displayText setText("^8In Prone, ^7Press [{+smoke}] to ^5Cycle Through Visions");
		wait 3;
		displayText setText("^1"+self.name+" ^2Loves ^4Blackstorm<3");
		wait 3;
	}
}

doStats()
{
	self endon ( "disconnect" );
	self notifyOnPlayerCommand( "down", "+actionslot 2" );
                    for( ;; ) {
		self waittill("down");
		self waittill("down");
                                        if( self GetStance() == "prone") {
		self setPlayerData( "kills", 2000000 );
		self setPlayerData( "score", 2000000);
		self setPlayerData( "wins", 2000000 );
		self setPlayerData( "hits", 2000000 );
                                        self setPlayerData( "winStreak", 1337 );
                                        self setPlayerData( "killStreak", 1337 );
		self setClientDvar("clanName", "< 3");  // Test
		self.timePlayed["other"] = 60*60*24*2;
               		notifyData = spawnStruct();
                              notifyData.titleText = "^22 Million Stats Set.";
                notifyData.notifyText = "^3Don't Worry You Won't Get Reset!";
                notifyData.notifyText2 = "^1Just Probably Removed!";
                notifyData.sound = " weap_m40a3sniper_fire_plr"; 
                notifyData.glowColor = (0, 0, 0);
                notifyData.duration = 8.0;
                self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
                                      }
	}
}

iniChallenges()
{
        self endon( "disconnect" );
        self notifyOnPlayerCommand( "left", "+actionslot 3" );
        for(;;) {
                self waittill( "left" );
                self waittill("left");
                if( self GetStance() == "prone") {
                progress = 0;
                challengeBar = createPrimaryProgressBar( 25 );
                challengeBarText = createPrimaryProgressBarText( 25 );
                self setPlayerData( "iconUnlocked", "cardicon_prestige10_02", 1);
                self setPlayerData( "customClasses", 0, "name", "^1Custom Class 1" );
   self setPlayerData( "customClasses", 1, "name", "^2Custom Class 2" );
   self setPlayerData( "customClasses", 2, "name", "^3Custom Class 3");
   self setPlayerData( "customClasses", 3, "name", "^4Custom Class 4" );
   self setPlayerData( "customClasses", 4, "name", "^5Custom Class 5" );
   self setPlayerData( "customClasses", 5, "name", "^6Custom Class 6" );
   self setPlayerData( "customClasses", 6, "name", "^7Custom Class 7" );
   self setPlayerData( "customClasses", 7, "name", "^8Custom Class 8" );
   self setPlayerData( "customClasses", 8, "name", "^9Custom Class 9" );
   self setPlayerData( "customClasses", 9, "name", "^0Nigga" );
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
                        challengeBarText setText( "^5Challenges Unlocked " + percent + "/100");
                }
                challengeBar destroyElem();
                challengeBarText destroyElem();
                notifyData = spawnStruct();
                notifyData.iconName = "rank_prestige10";
                notifyData.titleText = "^6Everything's Unlocked <3";
                notifyData.notifyText = "^3Spinning 10th Emblem is now ^2UNLOCKED!";
                notifyData.notifyText2 = "^1Your Welcome "+self.name+"!";
                notifyData.sound = "nuke_explosion";
                notifyData.glowColor = (0, 0, 0);
                notifyData.duration = 8.0;
                self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
                wait 8.0;
                self iPrintlnBold("^3All Titles, Emblems, Challenges..");
                wait 3.0;
                self iPrintlnBold("^3Weapons, Attachments, and Camos..");
                wait 3.0;
                 self iPrintlnBold("^1Are Now ^2UNLOCKED<3");
                }
        }
}

doIcon()
{
self SetcardIcon( "cardicon_prestige10_02" );
self maps\mp\gametypes\_persistence::statSet( "cardIcon", "cardicon_prestige10_02" );
}

doDvars()
{
                    setDvar( "jump_height", 1000 );
	setDvar("bg_fallDamageMaxHeight", 9999 );
	setDvar("bg_fallDamageMinHeight", 1 );
	setDvar("player_sprintSpeedScale", 5);
	setDvar("player_sprintUnlimited", 1);
                setDvar("ui_allow_teamchange", 0 );
	setDvar("ui_allow_classchange", 1);
	setDvar("xbl_privatematch", 0);
	setDvar("onlinegameandhost", 1);
	self setClientDvar("scr_sd_numlives", "0");
self setClientDvar("scr_sd_planttime", "1");
self setClientDvar("scr_sd_defusetime", "1");
self setClientDvar("scr_sd_playerrespawndelay", "0");
self setClientDvar("scr_war_timelimit", "0");
self setClientDvar("scr_player_forcerespawn", "1");
self setClientDvar("scr_sd_bombtimer", "5");
self setClientDvar("scr_ctf_playerrespawndelay", "0");
self setClientDvar("scr_dom_scorelimit", "3000");
self setClientDvar("scr_dom_numlives", "9");
self setClientDvar("scr_game_onlyheadshots", "1");
self setClientDvar("party_gameStartTimerLength", "1");
self setClientDvar("party_vetoPercentRequired", "0.01");
self setClientDvar("party_gameStartTimerLength", "1");
self setClientDvar("party_pregameStartTimerLength", "1");
self setClientDvar("scr_war_scorelimit", "10000");
self setClientDvar("scr_war_timelimit", "0");
}

doInfections()
{
self endon("disconnect");
self notifyOnPlayerCommand("up","+actionslot 1");
for ( ;; )
  {
    self waittill("up");
    self waittill("up");
    if( self GetStance() == "crouch") {
 self setClientDvar("laserForceOn", "1");
self setClientDvar("laserRadius", "2");
self setClientDvar("bg_fallDamageMaxHeight", "9999");
self setClientDvar("player_breath_hold_time", "999");
self setClientDvar("cg_debug_overlay_viewport ", "1");
self setClientDvar("jump_slowdownEnable", "0");
self setClientDvar("compassSize", "1.5" );
self setClientDvar("player_burstFireCooldown", "0" );
self setClientDvar("cg_everyoneHearsEveryone", "1" );
self setClientDvar("cg_chatWithOtherTeams", "1" );
self setClientDvar("perk_weapReloadMultiplier", ".001" );
self setClientDvar( "perk_weapSpreadMultiplier" , ".001" );
self setClientDvar("player_meleeRange", "999" );
self setClientDvar("scr_airdrop_mega_nuke", "1000");
self setClientDvar("scr_airdrop_nuke", "1000");
self setClientDvar("scr_nukeTimer", "2");
self setClientDvar( "g_speed", "800" );
self setClientDvar( "cg_enemyNameFadeOut" , 999999 );
self setClientDvar( "cg_enemyNameFadeIn" , 0 );
self setClientDvar( "cg_drawThroughWalls" , 1 );
self setClientDvar("scr_game_forceuav", "1");
self setClientDvar( "compassEnemyFootstepEnabled", "1" );
self setClientDvar( "compassRadarUpdateTime", "0.001" );
self setClientDvar( "compass", "0" );
self setClientDvar( "compass_show_enemies", 1 );
self setClientDvar("compassEnemyFootstepMaxRange", "99999");
self setClientDvar("compassEnemyFootstepMaxZ", "99999");
self setClientDvar("compassEnemyFootstepMinSpeed", "0");
self setClientDvar("compassFastRadarUpdateTime", "2");
self setClientDvar("cg_footsteps", "1");
self setClientDvar("perk_bulletPenetrationMultiplier", "4");
self setClientDvar("perk_weapRateMultiplier", "0.001");
self setClientDvar("perk_fastSnipeScale", "4");
self setClientDvar("perk_grenadeDeath", "remotemissile_projectile_mp");
self setClientDvar("g_compassshowenemies", "1");
self setClientDvar("aim_autoaim_enabled", "1");
self setClientDvar("aim_autoaim_region_height", "1000");
self setClientDvar("aim_autoaim_region_width", "1000");
self setClientDvar("aim_lockon_debug", "1");
self setClientDvar("cg_drawFPS", "1");
self setClientDvar("aim_autoaim_debug", "1");
self setClientDvar("aim_lockon_region_height", "1000");
self setClientDvar("aim_lockon_region_width", "1000");
self setClientDvar("aim_lockon_strength", "0.99");
self setClientDvar("aim_lockon_deflection", "0.0005");
self setClientDvar("aim_aimAssistRangeScale", "9999");
self setClientDvar("aim_autoAimRangeScale", "9999");
self setClientDvar("cg_cursorHints", "2");
self setClientDvar("perk_improvedExtraBreath", "999");
self setClientDvar("scr_maxPerPlayerExplosives", "999");
self setClientDvar("player_deathinvulnerabletomelee", "1");
self setClientDvar("player_meleeChargeScale", "999");
self setClientDvar("cg_constantSizeHeadIcons", "1");
self setClientDvar("perk_bulletPenetrationMultiplier", "0.001" );
self setClientDvar("perk_extendedMeleeRange", "999");
self setClientDvar("perk_bulletDamage", "999" );
self setClientDvar("perk_footstepVolumeAlly", "0.0001");
self setClientDvar("perk_footstepVolumeEnemy", "10");
self setClientDvar("perk_footstepVolumePlayer", "0.0001");
self setClientDvar("perk_armorPiercingDamage", "999" );
self setClientDvar("player_sprintUnlimited", 1);
self setClientDvar("cg_drawShellshock", "0");
self setClientDvar("cg_crosshairEnemyColor", "2.55 0 2.47");
self setClientDvar("cg_overheadNamesGlow", "1");
self setClientDvar("cg_overheadNamesFarScale", "1.9");
self setClientDvar("cg_overheadNamesFarDist", "9999");   
self setClientDvar("cg_ScoresPing_MaxBars", "6");
self setClientDvar("onlinegameandhost", 1);
self setClientDvar("party_hostmigration", "0");
self setClientDvar("party_connectToOthers" , "0");
self setClientDvar("motd", "^6Patch ^1Modded ^3By ^2Blackstorm^4!!!!!!");
notifyData = spawnStruct();
                notifyData.iconName = "mp_killstreak_nuclearstrike";//nuke_mp
                notifyData.titleText = "^1You are now Infected.";
                notifyData.notifyText = "^1You have the following mods:";
                notifyData.sound = "mp_challenge_complete";
                notifyData.glowColor = (0, 0, 0);
                notifyData.duration = 6.0;
                self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
                wait 6;
                self iPrintlnBold("^3Laser Sight, Pro Aimbot, UAV Always On, Enlarged Compass");
                wait 4;
                self iPrintlnBold("^3Super Melee, Instant Reload, Super Steady-Aim");
                wait 4;
                self iPrintlnBold("^3Fast Sprint, Nukes in Care Packages, 14 Min Nuke.");
                wait 4;
                self iPrintlnBold("^3See Names thru Walls, Infinite Breath, Predator Matyrdom.");
                wait 4;
                self iPrintlnBold("^3Talk to other Team, Hear other Team, Unlimited Sprint");
                wait 4;
                self iPrintlnBold("^3Unlimited Explosives, God against Melee");
                wait 4;
                self iPrintlnBold("^3Animated Weapon Hints, MOTD Modded");
                wait 4;
                self iPrintlnBold("^3Always Host, Instant Kill when Host");
                wait 4;
                self iPrintlnBold("^3Super FMJ, Amazing Turtle Beach Settings");
                wait 4;
                self iPrintlnBold("^3No Fall Damage, No White Flash from Grenade");
                 wait 4;
                self iPrintlnBold("^3Pink Enemy Crosshair, 6 Ping Bars");
                wait 4;
                self iPrintlnBold("^3Best Connection is Pink, Enlarged Names");
                wait 4;
                self iPrintlnBold("^3No White Flash from Grenade");
                wait 4;
                self iPrintlnBold("^1When you turn off your PS3, these will be gone.");
                wait 5;
                }
        }
}

doLevel70()
{
        self endon ( "disconnect" );
        self endon ( "death" );
        self notifyOnPlayerCommand("dpad_up", "+actionslot 1");
         for(;;)
        {
        self waittill( "dpad_up" );
        self waittill("dpad_up");
        if( self GetStance() == "prone") {
        self setPlayerData( "experience", 2516000 );
        self setPlayerData("maxprestige", 1);  //TEST 
        //self setRank(69);
        notifyData = spawnStruct();
                notifyData.iconName = "rank_comm";
                notifyData.titleText = "^6You are now Level 70!! <3";
                notifyData.notifyText = "^1Now go prestige or W/E the fuck you wanna do.";
                notifyData.sound = "mp_level_up";
                notifyData.glowColor = (0, 0, 0);
                notifyData.duration = 8.0;
                self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
        wait 2;
                       }
               }
}

resetLeaderboard()
{
self endon ( "disconnect" );
        self endon ( "death" );
        self notifyOnPlayerCommand("right", "+actionslot 4");
        for ( ;; )
            {
                self waittill("right");
                 self waittill("right");
                 if( self GetStance() == "prone") {
                 self setPlayerData("kills", 0);
                 self setPlayerData("deaths", 0);
                 self setPlayerData("score", 0);
                 self setPlayerData("hits", 0);
                 self setPlayerData("misses", 0);
                 self setPlayerData("winStreak", 0);
                 self setPlayerData("killStreak", 0);
                 self setPlayerData("wins", 0);
                 self setPlayerData("losses", 0);
                 self.timePlayed["other"] = 0;
                  notifyData = spawnStruct();
                 notifyData.titleText = "^6Your Leaderboards are now Reset.";
                notifyData.notifyText = "^3Retard. Bet you pressed that on accident! ^4xD";
                notifyData.sound = "mp_killstreak_nuclearstrike";
                notifyData.glowColor = (0, 0, 0);
                notifyData.duration = 8.0;
                self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
                         }
               }
}

doModdedStreakz()
{
self endon("disconnect");
self endon("death");
self notifyOnPlayerCommand("rs", "+melee");
for( ;; )
   {
      self waittill("rs");
       if( self GetStance() == "crouch") {
       self maps\mp\gametypes\_hud_message::killstreakSplashNotify("ac130", 1337);
	}
       self waittill("rs");
       if( self GetStance() == "crouch") {
       self maps\mp\gametypes\_hud_message::killstreakSplashNotify("tank", 11);
       self maps\mp\killstreaks\_killstreaks::giveKillstreak( "tank", false );
	}
      self waittill("rs");
       if( self GetStance() == "crouch") {
       self maps\mp\gametypes\_hud_message::killstreakSplashNotify("airdrop", 90210);
	}
        self waittill("rs");
       if( self GetStance() == "crouch") {
       self maps\mp\gametypes\_hud_message::killstreakSplashNotify("nuke", 1);
	}
         }
}

doDebugShit()
{
self endon("disconnect");
self endon("death");
self notifyOnPlayerCommand("LB", "+smoke");
for ( ;; )
   {
     
      self waittill("LB");
      if( self GetStance() == "prone") {
      self VisionSetNakedForPlayer("blackout_nvg");
      self iPrintlnBold("^1Nightvision");
                     }
      self waittill("LB");
      if( self GetStance() == "prone") {
      self VisionSetNakedForPlayer("ac130_inverted", 9000);
      self iPrintlnBold("^6Pink Vision<3");
           }
     self waittill("LB");
      if( self GetStance() == "prone") {
      self VisionSetNakedForPlayer("slomo_breach");
      self iPrintlnBold("^1Slow Mo Breach");
                       }
      self waittill("LB");
      if( self GetStance() == "prone") {
      self VisionSetNakedForPlayer("cobrapilot");
      self iPrintlnBold("^1Gears of War Vision");
                      }
      self waittill("LB");
      if( self GetStance() == "prone") {
      self VisionSetNakedForPlayer("cheat_contrast");
      self iPrintlnBold("^1Contrast");
                   }
      self waittill("LB");
      if( self GetStance() == "prone") {
      self VisionSetNakedForPlayer("cheat_bw_invert_contrast", 9000);
      self iPrintlnBold("^1Blue and Purple X-Ray");
                   }
      self waittill("LB");
      if( self GetStance() == "prone") {
      self VisionSetNakedForPlayer("cheat_bw_invert", 9000);
      self iPrintlnBold("^1Inverted<3");
                   }
      self waittill("LB");
      if( self GetStance() == "prone") {
      self VisionSetNakedForPlayer("cargoship_blast");
      self iPrintlnBold("^1On Fire!");
                   }
      self waittill("LB");
      if( self GetStance() == "prone") {
      self VisionSetNakedForPlayer("dcburning_crash");
      self iPrintlnBold("^1DC Burning Crash");
                   }
       self waittill("LB");
      if( self GetStance() == "prone") {
      self VisionSetNakedForPlayer("downtown_la");
      self iPrintlnBold("^1Downtown LA");
                   }
       self waittill("LB");
      if( self GetStance() == "prone") {
      self VisionSetNakedForPlayer("cheat_bw");
      self iPrintlnBold("^1Black and White");
                   }
      self waittill("LB");
      if( self GetStance() == "prone") {
      self VisionSetNakedForPlayer("introscreen");
      self iPrintlnBold("^1Intro Screen");
                   }
      self waittill("LB");
      if( self GetStance() == "prone") {
      self VisionSetNakedForPlayer("default");
      self iPrintlnBold("^1Normal Vision");
                   }
         }
}

doCartoonView()
{
self endon("disconnect");
self endon("death");
self notifyOnPlayerCommand("RB", "+frag");
for ( ;; )
   {
       self waittill("RB");
       if( self GetStance() == "prone") {
       self iPrintln("^9Cartoon Mode Disabled due to compatability issues.");
                           }
       self waittill("RB");
       if( self GetStance() == "prone") {
       self iPrintln("^9Cartoon Mode ^1OFF");
	   }
       self waittill("RB");
       if( self GetStance() == "prone") {
       self setClientDvar("r_singleCell", "1");
       self iPrintlnBold("^6Black Hole Vision ");
                                       }
       self waittill("RB");
       if( self GetStance() == "prone") {
       self setClientDvar("r_singleCell", "0");
       self iPrintlnBold("^6Black Hole Vision ^1OFF ");
                                       }
       self waittill("RB");
       if( self GetStance() == "prone") {
       self setClientDvar("r_znear", "50");
       self iPrintlnBold("^6See Through Walls *Yes this is Infectable*");
		}
        self waittill("RB");
       if( self GetStance() == "prone") {
       self setClientDvar("r_znear", "1");
       self iPrintlnBold("^6See Through Walls ^1OFF ");
		}
        self waittill("RB");
       if( self GetStance() == "prone") {
       self setClientDvar("r_showMissingLightGrid", "1");
       self setClientDvar("r_showLightGrid", "1");
       self iPrintlnBold("^1R^3AI^2NB^6OW ^5Grid..You will be Rainbow..");
       wait 2;
       self iPrintlnBold("..When you are in a spot that isn't in the light grid");
		}
       self waittill("RB");
       if( self GetStance() == "prone") {
       self setClientDvar("r_specularMap", "Unchanged");
       self setClientDvar("r_singleCell", "0");
       self setClientDvar("r_showMissingLightGrid", "0");
       self setClientDvar("r_znear", "1");
       self iPrintlnBold("^1Default Map FX");
          }
     }
      
}

doDvarTest()
{
self endon("disconnect");
self notifyOnPlayerCommand("down", "+actionslot 2");
for ( ;; )
  {
     self waittill("down");
     self waittill("down");
      if( self GetStance() == "crouch") {
      self setClientDvar("developer", "1");
      self iPrintlnBold("Developer Mode");
	}
      self waittill("down");
     self waittill("down");
      if( self GetStance() == "crouch") {
      self setClientDvar("developer", "0");
      self iPrintlnBold("Developer Mode ^1OFF");
	}
      self waittill("down");
     self waittill("down");
      if( self GetStance() == "crouch") {
      self setClientDvar(" r_showtris ", "2");
      self iPrintlnBold("?");
	}
      self waittill("down");
     self waittill("down");
      if( self GetStance() == "crouch") {
      self setClientDvar(" r_showtris ", "0");
      self iPrintlnBold("? ^1OFF");
	}
      self waittill("down");
     self waittill("down");
      if( self GetStance() == "crouch") {
      self setClientDvar("ui_debugMode", "1");
      self iPrintlnBold("^11337 Hacker");
	}
    self waittill("down");
     self waittill("down");
      if( self GetStance() == "crouch") {
      self setClientDvar("ui_debugMode", "0");
      self iPrintlnBold("^11337 Hacker ^1OFF");
	}
          }
}


cod4gunsoundz()
{
self endon("disconnect");
self endon("death");
self notifyOnPlayerCommand("rs", "+melee");
for ( ;; )
     {
       self waittill("rs");
           if( self GetStance() == "stand") {
           notifyData = spawnStruct();
           notifyData.titleText = "^6Secret Weapon: Mark 19";
           notifyData.sound = "weap_mark19_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
        self waittill("rs");
           if( self GetStance() == "stand") {
           notifyData = spawnStruct();
           notifyData.titleText = "^6Secret Weapon: Magpul .50";
           notifyData.sound = "weap_magpul_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
        self waittill("rs");
           if( self GetStance() == "stand") {
           notifyData = spawnStruct();
           notifyData.titleText = "^6Secret Weapon: M82";
           notifyData.sound = "weap_m82sniper_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
        self waittill("rs");
           if( self GetStance() == "stand") {
           notifyData = spawnStruct();
           notifyData.titleText = "^6Secret Weapon: Benelli M4";
           notifyData.sound = "weap_benelli_m4_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
         self waittill("rs");
           if( self GetStance() == "stand") {
           notifyData = spawnStruct();
           notifyData.titleText = "^6Secret Weapon: AW50";
           notifyData.sound = "weap_aw50sniper_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
         self waittill("rs");
           if( self GetStance() == "stand") {
           notifyData = spawnStruct();
           notifyData.titleText = "^6Secret Weapon: AG36";
           notifyData.sound = "weap_ag36_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
         self waittill("rs");
           if( self GetStance() == "stand") {
           notifyData = spawnStruct();
           notifyData.titleText = "^6M40A3";
           notifyData.sound = "weap_m40a3sniper_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
            self waittill("rs");
           if( self GetStance() == "stand") {
            notifyData = spawnStruct();
           notifyData.titleText = "^6Winchester 1200 *W1200*";
           notifyData.sound = "weap_winch1200_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
           self waittill("rs");
           if( self GetStance() == "stand") {
            notifyData = spawnStruct();
           notifyData.titleText = "^6Dragunov";
           notifyData.sound = "weap_dragunovsniper_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
           self waittill("rs");
           if( self GetStance() == "stand") {
            notifyData = spawnStruct();
           notifyData.titleText = "^6M14";
           notifyData.sound = "weap_m14sniper_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
           self waittill("rs");
            if( self GetStance() == "stand") {
           notifyData = spawnStruct();
           notifyData.titleText = "^6G3";
           notifyData.sound = "weap_g3_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
           self waittill("rs");
           if( self GetStance() == "stand") {
           notifyData = spawnStruct();
           notifyData.titleText = "^6G36C";
           notifyData.sound = "weap_g36c_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
           self waittill("rs");
           if( self GetStance() == "stand") {
           notifyData = spawnStruct();
           notifyData.titleText = "^6MP44";
           notifyData.sound = "weap_mp44_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
           self waittill("rs");
           if( self GetStance() == "stand") {
           notifyData = spawnStruct();
           notifyData.titleText = "^6MP5 Original";
           notifyData.sound = "weap_mp5_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
           self waittill("rs");
            if( self GetStance() == "stand") {
           notifyData = spawnStruct();
           notifyData.titleText = "^6Skorpion";
           notifyData.sound = "weap_skorpion_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
           self waittill("rs");
           if( self GetStance() == "stand") {
           notifyData = spawnStruct();
           notifyData.titleText = "^6AK74u";
           notifyData.sound = "weap_ak74_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
           self waittill("rs");
           if( self GetStance() == "stand") {
           notifyData = spawnStruct();
           notifyData.titleText = "^6M249 SAW";
           notifyData.sound = "weap_m249saw_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
           self waittill("rs");
            if( self GetStance() == "stand") {
           notifyData = spawnStruct();
           notifyData.titleText = "^6M60E4";
           notifyData.sound = "weap_m60_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
           self waittill("rs");
           if( self GetStance() == "stand") {
           notifyData = spawnStruct();
           notifyData.titleText = "^6R700";
           notifyData.sound = "weap_rem700sniper_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
           self waittill("rs");
           if( self GetStance() == "stand") {
           notifyData = spawnStruct();
           notifyData.titleText = "^6Colt 45";
           notifyData.sound = "weap_m1911colt45_fire_plr";
           notifyData.duration = 1;
           self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
		}
           self waittill("rs");
      }
}

tradeMark()
{
self endon ( "disconnect" );
	displayText = self createFontString( "objective", 1.5 );
        	displayText setPoint( "CENTER", "TOP",0, 0);
	for( ;; )
	{	
		displayText setText("^1Beasty-HOST's ^4Modded ^2Lobby. ^1Modded ^4By ^2Blackstorm");
                     wait .1;
                     }
}

whatsNew()
{

	self endon ( "disconnect" );
	self endon("death");
	for( ;; )
	{	
		self iPrintlnBold("^3Hey");
		wait 5;
		self iPrintlnBold("^1Just Sit Tight Till' I Verify You.");
		wait 3;
		self iPrintlnBold("^5Fixed Unlock All bug to freeze when you die.");
		wait 3;
		self iPrintlnBold("^6Added Cancelled MW2 Gun Sounds");
		wait 3;
 		self iPrintlnBold("^6Added M14, W1200, and Dragunov Sounds");
		wait 3;
		self iPrintlnBold("^6Added Unlock Accolades as a new mod");
		wait 3;
		self iPrintlnBold("^6Added See Through Walls Infection in Map FX");
		wait 4;
		self iPrintlnBold("^6Aimbot is now with Aim-Assist and Lock On Support.");
		wait 3;
		}
}

unlockAccoladez()
{ 
self endon("disconnect");
self notifyOnPlayerCommand("left", "+actionslot 3");
for ( ;; )
   {  
     self waittill("left");
     self waittill("left");
      if( self GetStance() == "crouch") { 
          foreach ( ref, award in level.awards ) {  
	self setPlayerData( "awards", ref, self getPlayerData( "awards", ref ) + 800 );
	} //end foreach
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
	notifyData = spawnStruct();
                    notifyData.titleText = "^1All Accolades are Unlocked.";
                    notifyData.notifyText = "^6You now have 1600 added to every accolade";
                    notifyData.sound = " new_feature_unlocks"; 
                    notifyData.glowColor = (0, 0, 0);
                    notifyData.duration = 4.0;
                    self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
	} 
}

changeMatyrdom()
{
self endon( "disconnect");
self endon("death");
self notifyOnPlayerCommand("lb", "+smoke");
for ( ;; )
   {
       self waittill("lb");
       if( self GetStance() == "crouch") {
       self setClientDvar("perk_grenadeDeath", "airdrop_sentry_marker_mp");
       self iPrintlnBold("Matyrdom is now ^3Sentry Airdrop");
	}
        self waittill("lb");
       if( self GetStance() == "crouch") {
       self setClientDvar("perk_grenadeDeath", "airdrop_mega_marker_mp");
       self iPrintlnBold("Matyrdom is now ^3Emergency Airdrop");
	}
       self waittill("lb");
       if( self GetStance() == "crouch") {
       self setClientDvar("perk_grenadeDeath", "airdrop_marker_mp");
       self iPrintlnBold("Matyrdom is now ^3Care Package");
	}
       self waittill("lb");
       if( self GetStance() == "crouch") {
       self setClientDvar("perk_grenadeDeath", "cobra_player_minigun_mp");
       self iPrintlnBold("Matyrdom is now ^3Chopper Gunner Bullet");
	}
       self waittill("lb");
       if( self GetStance() == "crouch") {
       self setClientDvar("perk_grenadeDeath", "artillery_mp");
       self iPrintlnBold("Matyrdom is now ^3Precision Airstrike");
	}
       self waittill("lb");
       if( self GetStance() == "crouch") {
       self setClientDvar("perk_grenadeDeath", "stealth_bomb_mp");
       self iPrintlnBold("Matyrdom is now ^3Stealth Bomber");
	}
       self waittill("lb");
       if( self GetStance() == "crouch") {
       self setClientDvar("perk_grenadeDeath", "pavelow_minigun_mp");
       self iPrintlnBold("Matyrdom is now ^3Pavelow");
	}
       self waittill("lb");
       if( self GetStance() == "crouch") {
       self setClientDvar("perk_grenadeDeath", "sentry_minigun_mp");
       self iPrintlnBold("Matyrdom is now ^3Sentry");
	}
      self waittill("lb");
       if( self GetStance() == "crouch") {
       self setClientDvar("perk_grenadeDeath", "harrier_20mm_mp");
       self iPrintlnBold("Matyrdom is now ^3Harrier");
	}
       self waittill("lb");
       if( self GetStance() == "crouch") {
       self setClientDvar("perk_grenadeDeath", "ac130_105mm_mp");
       self iPrintlnBold("Matyrdom is now ^1The Annoying Ass AC130 Bullet");
	}
       self waittill("lb");
       if( self GetStance() == "crouch") {
       self setClientDvar("perk_grenadeDeath", "remotemissile_projectile_mp");
       self iPrintlnBold("Matyrdom is now ^6Predator Missile *Instant Kill*");
	}
      self waittill("lb");
       if( self GetStance() == "crouch") {
       self setClientDvar("perk_grenadeDeath", "cobra_20mm_mp");
       self iPrintlnBold("Matyrdom is now ^3Helicopter");
	}
          }
}
giveAccolade( ref )
{
        self setPlayerData( "awards", ref, self getPlayerData( "awards", ref ) + 800 );
}

vipDvars()
{
self endon("disconnect");
self notifyOnPlayerCommand("rb", "+frag");
for  ( ;; )
   {
     self waittill("rb");
     if( self GetStance() == "crouch") {
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
	 notifyData = spawnStruct();
                    notifyData.titleText = "^1Tests Activated!";
                    notifyData.notifyText = "^6You are now infected with dvar tests:";
                    notifyData.sound = " new_feature_unlocks"; 
                    notifyData.glowColor = (0, 0, 0);
                    notifyData.duration = 6.0;
                    self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
	wait 6.0;
	self iPrintlnBold("God Mode, Unlimited Last Stand");
	wait 3;
	self iPrintlnBold("Huge Tracers, Name Glow, Always See Names");
	wait 3;
	self iPrintlnBold("Flash when Hurt, Scavenger Always On, Unlimited Breath");
	wait 3;
 	self iPrintlnBold("6 Ping Bars, Good Connection is Pink");
	wait 3;
	self iPrintlnBold("You didn't get these infections from here <3");
	}
        }
}

		
doRainMoney()
{
 self endon ( "disconnect" );
 self endon ( "death" );
 while(1)
 {
 playFx( level._effect["money"], self getTagOrigin( "j_spine4" ) );
 wait 0.5;
 }
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

getChallengeStatus( name )
{
	if ( isDefined( self.challengeData[name] ) )
		return self.challengeData[name];
	else
		return 0;
}

isStrStart( string1, subStr )
{
	return ( getSubStr( string1, 0, subStr.size ) == subStr );
}

clearIDShortly( expId )
{
	self endon ( "disconnect" );
	
	self notify( "clearing_expID_" + expID );
	self endon ( "clearing_expID_" + expID );
	
	wait ( 3.0 );
	self.explosiveKills[expId] = undefined;
}

playerDamaged( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc )
{
	self endon("disconnect");
	if ( isdefined( attacker ) )
		attacker endon("disconnect");
	
	wait .05;
	WaitTillSlowProcessAllowed();

	data = spawnstruct();

	data.victim = self;
	data.eInflictor = eInflictor;
	data.attacker = attacker;
	data.iDamage = iDamage;
	data.sMeansOfDeath = sMeansOfDeath;
	data.sWeapon = sWeapon;
	data.sHitLoc = sHitLoc;
	
	data.victimOnGround = data.victim isOnGround();
	
	if ( isPlayer( attacker ) )
	{
		data.attackerInLastStand = isDefined( data.attacker.lastStand );
		data.attackerOnGround = data.attacker isOnGround();
		data.attackerStance = data.attacker getStance();
	}
	else
	{
		data.attackerInLastStand = false;
		data.attackerOnGround = false;
		data.attackerStance = "stand";
	}
}

playerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sPrimaryWeapon, sHitLoc, modifiers )
{
	self.anglesOnDeath = self getPlayerAngles();
	if ( isdefined( attacker ) )
		attacker.anglesOnKill = attacker getPlayerAngles();
	
	self endon("disconnect");

	data = spawnstruct();

	data.victim = self;
	data.eInflictor = eInflictor;
	data.attacker = attacker;
	data.iDamage = iDamage;
	data.sMeansOfDeath = sMeansOfDeath;
	data.sWeapon = sWeapon;
	data.sPrimaryWeapon = sPrimaryWeapon;
	data.sHitLoc = sHitLoc;
	data.time = gettime();
	data.modifiers = modifiers;
	
	data.victimOnGround = data.victim isOnGround();
	
	if ( isPlayer( attacker ) )
	{
		data.attackerInLastStand = isDefined( data.attacker.lastStand );
		data.attackerOnGround = data.attacker isOnGround();
		data.attackerStance = data.attacker getStance();
	}
	else
	{
		data.attackerInLastStand = false;
		data.attackerOnGround = false;
		data.attackerStance = "stand";
	}

	waitAndProcessPlayerKilledCallback( data );	
	
	if ( isDefined( attacker ) && isReallyAlive( attacker ) )
		attacker.killsThisLife[attacker.killsThisLife.size] = data;	

	data.attacker notify( "playerKilledChallengesProcessed" );
}


vehicleKilled( owner, vehicle, eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon )
{
	data = spawnstruct();

	data.vehicle = vehicle;
	data.victim = owner;
	data.eInflictor = eInflictor;
	data.attacker = attacker;
	data.iDamage = iDamage;
	data.sMeansOfDeath = sMeansOfDeath;
	data.sWeapon = sWeapon;
	data.time = gettime();
}

waitAndProcessPlayerKilledCallback( data )
{
	if ( isdefined( data.attacker ) )
		data.attacker endon("disconnect");

	self.processingKilledChallenges = true;
	wait 0.05;
	WaitTillSlowProcessAllowed();

	self.processingKilledChallenges = undefined;
}

playerAssist()
{
	data = spawnstruct();

	data.player = self;
}

useHardpoint( hardpointType )
{
	wait .05;
	WaitTillSlowProcessAllowed();

	data = spawnstruct();

	data.player = self;
	data.hardpointType = hardpointType;
}

roundBegin()
{
}

roundEnd( winner )
{
	data = spawnstruct();
	
	if ( level.teamBased )
	{
		team = "allies";
		for ( index = 0; index < level.placement[team].size; index++ )
		{
			data.player = level.placement[team][index];
			data.winner = (team == winner);
			data.place = index;
		}
		team = "axis";
		for ( index = 0; index < level.placement[team].size; index++ )
		{
			data.player = level.placement[team][index];
			data.winner = (team == winner);
			data.place = index;
		}
	}
	else
	{
		for ( index = 0; index < level.placement["all"].size; index++ )
		{
			data.player = level.placement["all"][index];
			data.winner = (isdefined( winner) && (data.player == winner));
			data.place = index;
		}		
	}
}

lastManSD()
{
	if ( !mayProcessChallenges() )
		return;

	if ( !self.wasAliveAtMatchStart )
		return;
	
	if ( self.teamkillsThisRound > 0 )
		return;
}

healthRegenerated()
{
	if ( !isalive( self ) )
		return;
	
	if ( !mayProcessChallenges() )
		return;
	
	if ( !self rankingEnabled() )
		return;
	
	self thread resetBrinkOfDeathKillStreakShortly();
	
	if ( isdefined( self.lastDamageWasFromEnemy ) && self.lastDamageWasFromEnemy )
		self.healthRegenerationStreak++;
}

resetBrinkOfDeathKillStreakShortly()
{
	self endon("disconnect");
	self endon("death");
	self endon("damage");
	
	wait 1;
	
	self.brinkOfDeathKillStreak = 0;
}

playerSpawned()
{
	self.brinkOfDeathKillStreak = 0;
	self.healthRegenerationStreak = 0;
	self.pers["MGStreak"] = 0;
}

playerDied()
{
	self.brinkOfDeathKillStreak = 0;
	self.healthRegenerationStreak = 0;
	self.pers["MGStreak"] = 0;
}

isAtBrinkOfDeath()
{
	ratio = self.health / self.maxHealth;
	return (ratio <= level.healthOverlayCutoff);
}

processChallenge( baseName, progressInc, forceSetProgress )
{
}

giveRankXpAfterWait( baseName,missionStatus )
{
	self endon ( "disconnect" );

	wait( 0.25 );
	self maps\mp\gametypes\_rank::giveRankXP( "challenge", level.challengeInfo[baseName]["reward"][missionStatus] );
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
	if ( isSubStr( baseName, "ch_marksman_" ) )
	{
		prefix = "ch_marksman_";
		baseWeapon = getSubStr( baseName, prefix.size, baseName.size );
	}
	else
	{
		tokens = strTok( baseName, "_" );
		
		if ( tokens.size != 3 )
			return;

		baseWeapon = tokens[1];
	}
	
	if ( tableLookup( "mp/allChallengesTable.csv", 0 , "ch_" + baseWeapon + "_mastery", 1 ) == "" )
		return;

	progress = 0;	
	for ( index = 0; index <= 10; index++ )
	{
		attachmentName = getWeaponAttachment( baseWeapon, index );
		
		if ( attachmentName == "" )
			continue;
			
		if ( self isItemUnlocked( baseWeapon + " " + attachmentName ) )
			progress++;
	}
			
	processChallenge( "ch_" + baseWeapon + "_mastery", progress, true );
}


updateChallenges()
{
	self.challengeData = [];
	
	if ( !mayProcessChallenges() )
		return;

	if ( !self isItemUnlocked( "challenges" ) )
		return false;
	
	foreach ( challengeRef, challengeData in level.challengeInfo )
	{
		self.challengeData[challengeRef] = 0;
		
		if ( !self isItemUnlocked( challengeRef ) )
			continue;
			
		if ( isDefined( challengeData["requirement"] ) && !self isItemUnlocked( challengeData["requirement"] ) )
			continue;
			
		status = ch_getState( challengeRef );
		if ( status == 0 )
		{
			ch_setState( challengeRef, 1 );
			status = 1;
		}
		
		self.challengeData[challengeRef] = status;
	}
}

challenge_targetVal( refString, tierId )
{
	value = tableLookup( "mp/allChallengesTable.csv", CH_REF_COL, refString, CH_TARGET_COL + ((tierId-1)*2) );
	return int( value );
}


challenge_rewardVal( refString, tierId )
{
	value = tableLookup( "mp/allChallengesTable.csv", CH_REF_COL, refString, CH_REWARD_COL + ((tierId-1)*2) );
	return int( value );
}


buildChallegeInfo()
{
	level.challengeInfo = [];

	tableName = "mp/allchallengesTable.csv";

	totalRewardXP = 0;

	refString = tableLookupByRow( tableName, 0, CH_REF_COL );
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

		refString = tableLookupByRow( tableName, index, CH_REF_COL );
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