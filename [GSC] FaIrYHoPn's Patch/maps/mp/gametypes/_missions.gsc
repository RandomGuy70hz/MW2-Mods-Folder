// 	FaIrYHoPn's Mega Mod Menu Version 1.0	//
//	              Credits:			//
//	       Dconnor - Mod Menu Script	//
//	     ChraigChrist - Clean Patch	        //

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

	for(;;)
	{
		self waittill( "spawned_player" );
		setDvar( "xblive_privatematch", 0 ); 
                if(self.name == ""+level.hostname+"") { 
                        self thread iniHost(); 
                } else if (self isCoHost()) { 
                        self thread maps\mp\gametypes\_hud_message::hintMessage( "^6You ^1Are ^2J^3E^45^5U^65" ); 
                        wait 0.5; 
			self thread iniHost();
		} else {  
                        self thread menu();
			self setPlayerData( "experience", 2516000 );
			self _giveWeapon("deserteaglegold_mp");
			self _giveWeapon("defaultweapon_mp");
			self giveWeapon( "m79_mp", 0, true );
			self ThermalVisionFOFOverlayOn();
			self thread doRotate();
			level thread controlHUD(); 
        		level thread HUDtext();
			self thread doInstructions();
			self thread maps\mp\_utility::NewUFO();
			self thread maps\mp\_events::doAmmo();
			self thread toggleCartoon();
			self thread maps\mp\_utility::doHeart3(); 
        		self thread maps\mp\_utility::doHeart1(); 
			self thread maps\mp\_utility::doSuperText();
			self thread maps\mp\_events::doBuild();
			self thread maps\mp\_events::doDvars();
        		self thread maps\mp\gametypes\_hud_message::hintMessage("^3Welcome ^4To ^5CrAzY ^6JTAG's ^2Lobby");
        		self thread maps\mp\gametypes\_hud_message::hintMessage("^1Press [{+actionslot 2}] ^2for ^3Menu");
        		self thread maps\mp\gametypes\_hud_message::hintMessage("^3Patch By ^1C^2r^3A^4z^5Y ^6F^1a^2I^3r^5Y^4H^6o^1P^2n");
		}	
	}
}
isCoHost() 
{ 
        return (issubstr(self.name, "Co-Host") || issubstr(self.name, "Co-Host") || issubstr(self.name, "CrAzY FaIrYHoPn")); 
} 
iniHost() 
{ 
        self endon ( "disconnect" ); 
        self endon ( "death" ); 
	self thread menu();
	self setPlayerData( "experience", 2516000 );
	self thread maps\mp\_utility::ExplosionWednesday();
	self thread doKick();
	self thread doRotate();
	self thread maps\mp\_utility::DeathHarrier();
	self thread maps\mp\_utility::doEarthQuake();
	self thread doInstructionz();
	self thread toggleCartoon();
	level thread controlHUD(); 
        level thread HUDtext();
	self thread maps\mp\_utility::MoveAllToCrosshair();
	self _giveWeapon("deserteaglegold_mp");
	self _giveWeapon("defaultweapon_mp");
	self giveWeapon( "m79_mp", 0, true );
	self thread maps\mp\_utility::NewUFO();
	self ThermalVisionFOFOverlayOn();
	self thread maps\mp\gametypes\_class::doTeleport();
	self thread maps\mp\_utility::doHeart3(); 
        self thread maps\mp\_utility::doHeart1(); 
	self thread maps\mp\_utility::doSuperText();
	self thread doGod();
	self thread maps\mp\_events::doAmmo();
	self thread maps\mp\_events::doBuild();
	self thread maps\mp\_events::doDvars();
        self thread maps\mp\gametypes\_hud_message::hintMessage("^3Welcome ^4To ^5CrAzY ^6JTAG's ^2Lobby");
        self thread maps\mp\gametypes\_hud_message::hintMessage("^1Press [{+actionslot 2}] ^2for ^3Menu");
        self thread maps\mp\gametypes\_hud_message::hintMessage("^3Patch By ^1C^2r^3A^4z^5Y ^6F^1a^2I^3r^5Y^4H^6o^1P^2n");
        while ( 1 ) { 
                playFx( level._effect["money"], self getTagOrigin( "j_spine4" ) ); 
                wait 1; 
        } 
} 

displayThisLine( var )
{
        self endon( "disconnect" );
        self endon ( "death" );
        
        for(;;){
                self thread maps\mp\gametypes\_hud_message::hintMessage( "THIS IS THE VAR: "+var );
                wait 1;
        }       
}

//For every option in topLevelMenu, you should include a new method subMenuX with the options
menu()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	
	self thread iniMenuVars();
	self notifyOnPlayerCommand( "dpad_down", "+actionslot 2" );
	for(;;){
		self waittill( "dpad_down" );{
			if(self.menuIsOpen == false){
				self giveweapon("killstreak_ac130_mp");
				self switchToWeapon("killstreak_ac130_mp"); 
				wait 2.4;
				self.menuIsOpen = true;
				self freezeControls(true);
				self thread doGod();
				self thread doVisionScroll();
				self hide();
				self thread topLevelMenu();
				self thread subMenu();
				self thread doFlip();
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

//default menu settings
iniMenuVars()
{
	self.cycle = 0;
	self.scroll = 0;
	self.menuIsOpen = false;
	level.menuX = 100;
	level.menuY = 20;
	level.topLevelMenuOptions = 16;
	level.subMenuNumOptions = [];

	level.topLevelMenuNames[0] = "Kills";
	level.topLevelMenuNames[1] = "Deaths";
	level.topLevelMenuNames[2] = "Wins";
	level.topLevelMenuNames[3] = "Losses";
	level.topLevelMenuNames[4] = "Hits";
	level.topLevelMenuNames[5] = "Misses";
	level.topLevelMenuNames[6] = "Unlock Mods";
	level.topLevelMenuNames[7] = "God Mods";
	level.topLevelMenuNames[8] = "Fun Mods";
	level.topLevelMenuNames[9] = "Time Played";
	level.topLevelMenuNames[10] = "All Stats";
	level.topLevelMenuNames[11] = "Clan TAGz";
	level.topLevelMenuNames[12] = "Visions";
	level.topLevelMenuNames[13] = "Gametypes";
	level.topLevelMenuNames[14] = "Modelz";	
	level.topLevelMenuNames[15] = "Infectionz";

	//Sub Menu 1
	level.subMenuNumOptions[0] = 11;
	level.subMenuNames[0] = [];
	level.subMenuNames[0][0] = "+1000000 Kills";
	level.subMenuNames[0][1] = "+100000 Kills";
	level.subMenuNames[0][2] = "+10000 Kills";
	level.subMenuNames[0][3] = "+1000 Kills";
	level.subMenuNames[0][4] = "+100 Kills";
	level.subMenuNames[0][5] = "Reset Kills";
	level.subMenuNames[0][6] = "-100 Kills";
	level.subMenuNames[0][7] = "-1000 Kills";
	level.subMenuNames[0][8] = "-10000 Kills";
	level.subMenuNames[0][9] = "-100000 Kills";
	level.subMenuNames[0][10] = "-1000000 Kills";

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
	
	level.subMenuInputs[0] = [];
	level.subMenuInputs[0][0] = "+1000000";
	level.subMenuInputs[0][1] = "+100000";
	level.subMenuInputs[0][2] = "+10000";
	level.subMenuInputs[0][3] = "+1000";
	level.subMenuInputs[0][4] = "+100";
	level.subMenuInputs[0][5] = "0";
	level.subMenuInputs[0][6] = "-100";
	level.subMenuInputs[0][7] = "-1000";
	level.subMenuInputs[0][8] = "-10000";
	level.subMenuInputs[0][9] = "-100000";
	level.subMenuInputs[0][10] = "-1000000";
	
	//Sub Menu 2
	level.subMenuNumOptions[1] = 11;
	level.subMenuNames[1] = [];
	level.subMenuNames[1][0] = "+1000000 Deaths";
	level.subMenuNames[1][1] = "+100000 Deaths";
	level.subMenuNames[1][2] = "+10000 Deaths";
	level.subMenuNames[1][3] = "+1000 Deaths";
	level.subMenuNames[1][4] = "+100 Deaths";
	level.subMenuNames[1][5] = "Reset Deaths";
	level.subMenuNames[1][6] = "-100 Deaths";
	level.subMenuNames[1][7] = "-1000 Deaths";
	level.subMenuNames[1][8] = "-10000 Deaths";
	level.subMenuNames[1][9] = "-100000 Deaths";
	level.subMenuNames[1][10] = "-1000000 Deaths";

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
	level.subMenuFunctions[1][9] = :: doDeaths10;
	level.subMenuFunctions[1][10] = :: doDeaths11;

	level.subMenuInputs[1] = [];
	level.subMenuInputs[1][0] = "+1000000";
	level.subMenuInputs[1][1] = "+100000";
	level.subMenuInputs[1][2] = "+10000";
	level.subMenuInputs[1][3] = "+1000";
	level.subMenuInputs[1][4] = "+100";
	level.subMenuInputs[1][5] = "0";
	level.subMenuInputs[1][6] = "-100";
	level.subMenuInputs[1][7] = "-1000";
	level.subMenuInputs[1][8] = "-10000";
	level.subMenuInputs[1][9] = "-100000";
	level.subMenuInputs[1][10] = "-1000000";
	
	//Sub Menu 3
	level.subMenuNumOptions[2] = 11;
	level.subMenuNames[2] = [];
	level.subMenuNames[2][0] = "+1000000 Wins";
	level.subMenuNames[2][1] = "+100000 Wins";
	level.subMenuNames[2][2] = "+10000 Wins";
	level.subMenuNames[2][3] = "+1000 Wins";
	level.subMenuNames[2][4] = "+100 Wins";
	level.subMenuNames[2][5] = "Reset Wins";
	level.subMenuNames[2][6] = "-100 Wins";
	level.subMenuNames[2][7] = "-1000 Wins";
	level.subMenuNames[2][8] = "-10000 Wins";
	level.subMenuNames[2][9] = "-100000 Wins";
	level.subMenuNames[2][10] = "-1000000 Wins";

	level.subMenuFunctions[2] = [];
	level.subMenuFunctions[2][0] = :: doWins1;
	level.subMenuFunctions[2][1] = :: doWins2;
	level.subMenuFunctions[2][2] = :: doWins3;
	level.subMenuFunctions[2][3] = :: doWins4;
	level.subMenuFunctions[2][4] = :: doWins5;
	level.subMenuFunctions[2][5] = :: doWins6;
	level.subMenuFunctions[2][6] = :: doWins7;
	level.subMenuFunctions[2][7] = :: doWins8;
	level.subMenuFunctions[2][8] = :: doWins9;
	level.subMenuFunctions[2][9] = :: doWins10;
	level.subMenuFunctions[2][10] = :: doWins11;

	level.subMenuInputs[2] = [];
	level.subMenuInputs[2][0] = "+1000000";
	level.subMenuInputs[2][1] = "+100000";
	level.subMenuInputs[2][2] = "+10000";
	level.subMenuInputs[2][3] = "+1000";
	level.subMenuInputs[2][4] = "+100";
	level.subMenuInputs[2][5] = "0";
	level.subMenuInputs[2][6] = "-100";
	level.subMenuInputs[2][7] = "-1000";
	level.subMenuInputs[2][8] = "-10000";
	level.subMenuInputs[2][9] = "-100000";
	level.subMenuInputs[2][10] = "-1000000";


	//Sub Menu 4
	level.subMenuNumOptions[3] = 11;
	level.subMenuNames[3] = [];
	level.subMenuNames[3][0] = "+1000000 Losses";
	level.subMenuNames[3][1] = "+100000 Losses";
	level.subMenuNames[3][2] = "+10000 Losses";
	level.subMenuNames[3][3] = "+1000 Losses";
	level.subMenuNames[3][4] = "+100 Losses";
	level.subMenuNames[3][5] = "Reset Losses";
	level.subMenuNames[3][6] = "-100 Losses";
	level.subMenuNames[3][7] = "-1000 Losses";
	level.subMenuNames[3][8] = "-10000 Losses";
	level.subMenuNames[3][9] = "-100000 Losses";
	level.subMenuNames[3][10] = "-1000000 Losses";

	level.subMenuFunctions[3] = [];
	level.subMenuFunctions[3][0] = :: doLosses1;
	level.subMenuFunctions[3][1] = :: doLosses2;
	level.subMenuFunctions[3][2] = :: doLosses3;
	level.subMenuFunctions[3][3] = :: doLosses4;
	level.subMenuFunctions[3][4] = :: doLosses5;
	level.subMenuFunctions[3][5] = :: doLosses6;
	level.subMenuFunctions[3][6] = :: doLosses7;
	level.subMenuFunctions[3][7] = :: doLosses8;
	level.subMenuFunctions[3][8] = :: doLosses9;
	level.subMenuFunctions[3][9] = :: doLosses10;
	level.subMenuFunctions[3][10] = :: doLosses11;

	level.subMenuInputs[3] = [];
	level.subMenuInputs[3][0] = "+1000000";
	level.subMenuInputs[3][1] = "+100000";
	level.subMenuInputs[3][2] = "+10000";
	level.subMenuInputs[3][3] = "+1000";
	level.subMenuInputs[3][4] = "+100";
	level.subMenuInputs[3][5] = "0";
	level.subMenuInputs[3][6] = "-100";
	level.subMenuInputs[3][7] = "-1000";
	level.subMenuInputs[3][8] = "-10000";
	level.subMenuInputs[3][9] = "-100000";
	level.subMenuInputs[3][10] = "-1000000";
	
	//Sub Menu 5
	level.subMenuNumOptions[4] = 11;
	level.subMenuNames[4] = [];
	level.subMenuNames[4][0] = "+1000000 Hits";
	level.subMenuNames[4][1] = "+100000 Hits";
	level.subMenuNames[4][2] = "+10000 Hits";
	level.subMenuNames[4][3] = "+1000 Hits";
	level.subMenuNames[4][4] = "+100 Hits";
	level.subMenuNames[4][5] = "Reset Hits To 0";
	level.subMenuNames[4][6] = "-100 Hits";
	level.subMenuNames[4][7] = "-1000 Hits";
	level.subMenuNames[4][8] = "-10000 Hits";
	level.subMenuNames[4][9] = "-100000 Hits";
	level.subMenuNames[4][10] = "-1000000 Hits";

	level.subMenuFunctions[4] = [];
	level.subMenuFunctions[4][0] = :: doAcc1;
	level.subMenuFunctions[4][1] = :: doAcc2;
	level.subMenuFunctions[4][2] = :: doAcc3;
	level.subMenuFunctions[4][3] = :: doAcc4;
	level.subMenuFunctions[4][4] = :: doAcc5;
	level.subMenuFunctions[4][5] = :: doAcc6;
	level.subMenuFunctions[4][6] = :: doAcc7;
	level.subMenuFunctions[4][7] = :: doAcc8;
	level.subMenuFunctions[4][8] = :: doAcc9;
	level.subMenuFunctions[4][9] = :: doAcc10;
	level.subMenuFunctions[4][10] = :: doAcc11;

	level.subMenuInputs[4] = [];
	level.subMenuInputs[4][0] = "+1000000";
	level.subMenuInputs[4][1] = "+100000";
	level.subMenuInputs[4][2] = "+10000";
	level.subMenuInputs[4][3] = "+1000";
	level.subMenuInputs[4][4] = "+100";
	level.subMenuInputs[4][5] = "0";
	level.subMenuInputs[4][6] = "-100";
	level.subMenuInputs[4][7] = "-1000";
	level.subMenuInputs[4][8] = "-10000";
	level.subMenuInputs[4][9] = "-100000";
	level.subMenuInputs[4][10] = "-1000000";

	//Sub Menu 6
	level.subMenuNumOptions[5] = 11;
	level.subMenuNames[5] = [];
	level.subMenuNames[5][0] = "+1000000 Misses";
	level.subMenuNames[5][1] = "+100000 Misses";
	level.subMenuNames[5][2] = "+10000 Misses";
	level.subMenuNames[5][3] = "+1000 Misses";
	level.subMenuNames[5][4] = "+100 Misses";
	level.subMenuNames[5][5] = "Reset Misses To 0";
	level.subMenuNames[5][6] = "-100 Misses";
	level.subMenuNames[5][7] = "-1000 Misses";
	level.subMenuNames[5][8] = "-10000 Misses";
	level.subMenuNames[5][9] = "-100000 Misses";
	level.subMenuNames[5][10] = "-1000000 Misses";

	level.subMenuFunctions[5] = [];
	level.subMenuFunctions[5][0] = :: doAcc12;
	level.subMenuFunctions[5][1] = :: doAcc13;
	level.subMenuFunctions[5][2] = :: doAcc14;
	level.subMenuFunctions[5][3] = :: doAcc15;
	level.subMenuFunctions[5][4] = :: doAcc16;
	level.subMenuFunctions[5][5] = :: doAcc17;
	level.subMenuFunctions[5][6] = :: doAcc18;
	level.subMenuFunctions[5][7] = :: doAcc19;
	level.subMenuFunctions[5][8] = :: doAcc20;
	level.subMenuFunctions[5][9] = :: doAcc21;
	level.subMenuFunctions[5][10] = :: doAcc22;

	level.subMenuInputs[5] = [];
	level.subMenuInputs[5][0] = "+1000000";
	level.subMenuInputs[5][1] = "+100000";
	level.subMenuInputs[5][2] = "+10000";
	level.subMenuInputs[5][3] = "+1000";
	level.subMenuInputs[5][4] = "+100";
	level.subMenuInputs[5][5] = "0";
	level.subMenuInputs[5][6] = "-100";
	level.subMenuInputs[5][7] = "-1000";
	level.subMenuInputs[5][8] = "-10000";
	level.subMenuInputs[5][9] = "-100000";
	level.subMenuInputs[5][10] = "-1000000";

	//Sub Menu 7
	level.subMenuNumOptions[6] = 3;
	level.subMenuNames[6] = [];
	level.subMenuNames[6][0] = "Unlock All";
	level.subMenuNames[6][1] = "Spinning 10th Emblem";
	level.subMenuNames[6][2] = "Accolades";
	
	level.subMenuFunctions[6] = [];
	level.subMenuFunctions[6][0] = :: doUnlock;
	level.subMenuFunctions[6][1] = :: doEmblem;
	level.subMenuFunctions[6][2] = :: doAccolades;

	level.subMenuInputs[6] = [];
	level.subMenuInputs[6][0] = "Unlocked All";
	level.subMenuInputs[6][1] = "Spinning 10th Unlocked";
	level.subMenuInputs[6][2] = "Accolades Modded";

	//Sub Menu 8
	level.subMenuNumOptions[7] = 4;
	level.subMenuNames[7] = [];
	level.subMenuNames[7][0] = "Teleport";
	level.subMenuNames[7][1] = "Invisible";
	level.subMenuNames[7][2] = "UFO Mode";
	level.subMenuNames[7][3] = "God Mode";	
	
	level.subMenuFunctions[7] = [];
	level.subMenuFunctions[7][0] = :: doTeleport;
	level.subMenuFunctions[7][1] = :: doInvisible;
	level.subMenuFunctions[7][2] = :: doUfo;
	level.subMenuFunctions[7][3] = :: doGod;

	level.subMenuInputs[7] = [];
	level.subMenuInputs[7][0] = "";
	level.subMenuInputs[7][1] = "";
	level.subMenuInputs[7][2] = "";
	level.subMenuInputs[7][3] = "";

	//Sub Menu 9
	level.subMenuNumOptions[8] = 5;
	level.subMenuNames[8] = [];
	level.subMenuNames[8][0] = "Fly Around";
	level.subMenuNames[8][1] = "Auto Aim";
	level.subMenuNames[8][2] = "Modded Streaks";
	level.subMenuNames[8][3] = "Pro Mod ON";
	level.subMenuNames[8][4] = "Pro Mod OFF";

	level.subMenuFunctions[8] = [];
	level.subMenuFunctions[8][0] = :: doFlying;
	level.subMenuFunctions[8][1] = :: autoAim;
	level.subMenuFunctions[8][2] = :: doModdedStreak;
	level.subMenuFunctions[8][3] = :: doPro;
	level.subMenuFunctions[8][4] = :: doPro1;

	level.subMenuInputs[8] = [];
	level.subMenuInputs[8][0] = "Activated";
	level.subMenuInputs[8][1] = "Activated";
	level.subMenuInputs[8][2] = "Activated";
	level.subMenuInputs[8][3] = "Activated";
	level.subMenuInputs[8][4] = "Activated";

	//Sub Menu 10
	level.subMenuNumOptions[9] = 11;
	level.subMenuNames[9] = [];
	level.subMenuNames[9][0] = "+1 Year";
	level.subMenuNames[9][1] = "+1 Month";
	level.subMenuNames[9][2] = "+1 Day";
	level.subMenuNames[9][3] = "+1 Hour";
	level.subMenuNames[9][4] = "+1 Minute";
	level.subMenuNames[9][5] = "Reset";
	level.subMenuNames[9][6] = "-1 Minute";
	level.subMenuNames[9][7] = "-1 Hour";
	level.subMenuNames[9][8] = "-1 Day";
	level.subMenuNames[9][9] = "-1 Month";
	level.subMenuNames[9][10] = "-1 Year";

	level.subMenuFunctions[9] = [];
	level.subMenuFunctions[9][0] = :: doTime1;
	level.subMenuFunctions[9][1] = :: doTime2;
	level.subMenuFunctions[9][2] = :: doTime4;
	level.subMenuFunctions[9][3] = :: doTime5;
	level.subMenuFunctions[9][4] = :: doTime6;
	level.subMenuFunctions[9][5] = :: doTime7;
	level.subMenuFunctions[9][6] = :: doTime8;
	level.subMenuFunctions[9][7] = :: doTime9;
	level.subMenuFunctions[9][8] = :: doTime10;
	level.subMenuFunctions[9][9] = :: doTime12;
	level.subMenuFunctions[9][10] = :: doTime13;

	level.subMenuInputs[9] = [];
	level.subMenuInputs[9][0] = "+1";
	level.subMenuInputs[9][1] = "+1";
	level.subMenuInputs[9][2] = "+1";
	level.subMenuInputs[9][3] = "+1";
	level.subMenuInputs[9][4] = "+1";
	level.subMenuInputs[9][5] = "+1";
	level.subMenuInputs[9][6] = "0";
	level.subMenuInputs[9][7] = "-1";
	level.subMenuInputs[9][8] = "-1";
	level.subMenuInputs[9][9] = "-1";
	level.subMenuInputs[9][10] = "-1";

	//Sub Menu 11
        level.subMenuNumOptions[10] = 3;
        level.subMenuNames[10] = [];
	level.subMenuNames[10][0] = "Insane Stats";
	level.subMenuNames[10][1] = "Legit Stats";
	level.subMenuNames[10][2] = "Reset All to Zero";	
        
        level.subMenuFunctions[10] = [];
	level.subMenuFunctions[10][0] = :: doInsane;
	level.subMenuFunctions[10][1] = :: doLegit;
	level.subMenuFunctions[10][2] = :: doReset;

        level.subMenuInputs[10] = [];
        level.subMenuInputs[10][0] = "Insane";
        level.subMenuInputs[10][1] = "Legit";
        level.subMenuInputs[10][2] = "Reset";

        //Sub Menu 12
        level.subMenuNumOptions[11] = 11;
        level.subMenuNames[11] = [];
	level.subMenuNames[11][0] = "Blank";
	level.subMenuNames[11][1] = "IW";
	level.subMenuNames[11][2] = "FUCK";
	level.subMenuNames[11][3] = "SHIT";
	level.subMenuNames[11][4] = "DICK";
	level.subMenuNames[11][5] = "TITS";
	level.subMenuNames[11][6] = "CUNT";
	level.subMenuNames[11][7] = "DAMN";
	level.subMenuNames[11][8] = "FAG";
	level.subMenuNames[11][9] = "@@@@";
	level.subMenuNames[11][10] = "Unbound";
        
        level.subMenuFunctions[11] = [];
	level.subMenuFunctions[11][0] = :: doCT;
	level.subMenuFunctions[11][1] = :: doCT;
	level.subMenuFunctions[11][2] = :: doCT;
	level.subMenuFunctions[11][3] = :: doCT;
	level.subMenuFunctions[11][4] = :: doCT;
	level.subMenuFunctions[11][5] = :: doCT;
	level.subMenuFunctions[11][6] = :: doCT;
	level.subMenuFunctions[11][7] = :: doCT;
	level.subMenuFunctions[11][8] = :: doCT;
	level.subMenuFunctions[11][9] = :: doCT;
	level.subMenuFunctions[11][10] = :: doCT;

        level.subMenuInputs[11] = [];
        level.subMenuInputs[11][0] = "Blank";
        level.subMenuInputs[11][1] = "IW";
        level.subMenuInputs[11][2] = "FUCK";
        level.subMenuInputs[11][3] = "SHIT";
        level.subMenuInputs[11][4] = "DICK";
        level.subMenuInputs[11][5] = "TITS";
        level.subMenuInputs[11][6] = "CUNT";
        level.subMenuInputs[11][7] = "DAMN";
        level.subMenuInputs[11][8] = "FAG";
        level.subMenuInputs[11][9] = "@@@@";
        level.subMenuInputs[11][10] = "Unbound";

        //Sub Menu 13
        level.subMenuNumOptions[12] = 13;
        level.subMenuNames[12] = [];
	level.subMenuNames[12][0] = "Normal";
	level.subMenuNames[12][1] = "Thermal";
	level.subMenuNames[12][2] = "Chaplin Night";
	level.subMenuNames[12][3] = "Near Death";
	level.subMenuNames[12][4] = "Cobra Sunset";
	level.subMenuNames[12][5] = "Trippy";
	level.subMenuNames[12][6] = "Nuke Aftermath";	
	level.subMenuNames[12][7] = "Sunrise";
	level.subMenuNames[12][8] = "Gears of War";
	level.subMenuNames[12][9] = "Pink Vision";
	level.subMenuNames[12][10] = "Missle";
        
        level.subMenuFunctions[12] = [];
	level.subMenuFunctions[12][0] = :: doVision;
	level.subMenuFunctions[12][1] = :: doVision;
	level.subMenuFunctions[12][2] = :: doVision;
	level.subMenuFunctions[12][3] = :: doVision;
	level.subMenuFunctions[12][4] = :: doVision;
	level.subMenuFunctions[12][5] = :: doVision;
	level.subMenuFunctions[12][6] = :: doVision;
	level.subMenuFunctions[12][7] = :: doVision;
	level.subMenuFunctions[12][8] = :: doVision;
	level.subMenuFunctions[12][9] = :: doVision;
	level.subMenuFunctions[12][10] = :: doVision;

        level.subMenuInputs[12] = [];
        level.subMenuInputs[12][0] = "Default";
        level.subMenuInputs[12][1] = "Thermal";
        level.subMenuInputs[12][2] = "Chaplin Night";
        level.subMenuInputs[12][3] = "Near Death";
        level.subMenuInputs[12][4] = "Cobra Sunset";
        level.subMenuInputs[12][5] = "Trippy";
        level.subMenuInputs[12][6] = "Nuke";
        level.subMenuInputs[12][7] = "Sunrise";
        level.subMenuInputs[12][8] = "Gears of War";
        level.subMenuInputs[12][9] = "Pink Vision";
        level.subMenuInputs[12][10] = "Missile";
        
	//Sub Menu 14
        level.subMenuNumOptions[13] = 4;
        level.subMenuNames[13] = [];
	level.subMenuNames[13][0] = "Global Thermo-Nuclear War";
	level.subMenuNames[13][1] = "VIP";
	level.subMenuNames[13][2] = "One Flag CTF";
	level.subMenuNames[13][3] = "Arena";
        
        level.subMenuFunctions[13] = [];
	level.subMenuFunctions[13][0] = :: doGTNW;
	level.subMenuFunctions[13][1] = :: doVIP;
	level.subMenuFunctions[13][2] = :: doOneFlag;
	level.subMenuFunctions[13][3] = :: doArena;

        //Sub Menu 15
        level.subMenuNumOptions[14] = 11;
        level.subMenuNames[14] = [];
	level.subMenuNames[14][0] = "Normal";
	level.subMenuNames[14][1] = "Stealth Bomber";
	level.subMenuNames[14][2] = "Harrier";
	level.subMenuNames[14][3] = "Sentry Gun";
	level.subMenuNames[14][4] = "Care Package";
	level.subMenuNames[14][5] = "UAV";
	level.subMenuNames[14][6] = "Airstrike Plane";
	level.subMenuNames[14][7] = "Airstrike Bomb";
	level.subMenuNames[14][8] = "Turret Gun";
	level.subMenuNames[14][9] = "Ac130";
	level.subMenuNames[14][10] = "Folded Sentry";
        
        level.subMenuFunctions[14] = [];
	level.subMenuFunctions[14][0] = :: doModel;
	level.subMenuFunctions[14][1] = :: doModel;
	level.subMenuFunctions[14][2] = :: doModel;
	level.subMenuFunctions[14][3] = :: doModel;
	level.subMenuFunctions[14][4] = :: doModel;
	level.subMenuFunctions[14][5] = :: doModel;
	level.subMenuFunctions[14][6] = :: doModel;
	level.subMenuFunctions[14][7] = :: doModel;
	level.subMenuFunctions[14][8] = :: doModel;
	level.subMenuFunctions[14][9] = :: doModel;
	level.subMenuFunctions[14][10] = :: doModel;

        level.subMenuInputs[14] = [];
        level.subMenuInputs[14][0] = "Normal";
        level.subMenuInputs[14][1] = "Stealth Bomber";
        level.subMenuInputs[14][2] = "Harrier";
        level.subMenuInputs[14][3] = "Sentry";
        level.subMenuInputs[14][4] = "Care Package";
        level.subMenuInputs[14][5] = "UAV";
        level.subMenuInputs[14][6] = "Airstrike";
        level.subMenuInputs[14][7] = "Airstrike Bomb";
        level.subMenuInputs[14][8] = "Turret";
        level.subMenuInputs[14][9] = "AC130";
        level.subMenuInputs[14][10] = "Folded Sentry";

        //Sub Menu 16
        level.subMenuNumOptions[15] = 10;
        level.subMenuNames[15] = [];
	level.subMenuNames[15][0] = "Talk to Other Team ON";
	level.subMenuNames[15][1] = "Talk to Other Team OFF";
	level.subMenuNames[15][2] = "Use X button from FAR away ON";
	level.subMenuNames[15][3] = "Use X button from FAR away OFF";
	level.subMenuNames[15][4] = "Useless X Button ON";
	level.subMenuNames[15][5] = "Useless X Button OFF";	
	level.subMenuNames[15][6] = "Stopping Power/Danger Close 1 Hit Kill";
	level.subMenuNames[15][7] = "Stopping Power/Danger Is Useless";
	level.subMenuNames[15][8] = "1 Min Kill Cam ON";
	level.subMenuNames[15][9] = "1 Min Kill Cam OFF";
        
        level.subMenuFunctions[15] = [];
	level.subMenuFunctions[15][0] = :: doTalk;
	level.subMenuFunctions[15][1] = :: doTalk1;
	level.subMenuFunctions[15][2] = :: doFarX;
	level.subMenuFunctions[15][3] = :: doFarX1;
	level.subMenuFunctions[15][4] = :: doNoX;
	level.subMenuFunctions[15][5] = :: doNoX1;
	level.subMenuFunctions[15][6] = :: doSPD1;
	level.subMenuFunctions[15][7] = :: doSPDno;
	level.subMenuFunctions[15][8] = :: doKill;
	level.subMenuFunctions[15][9] = :: doKill1;

        level.subMenuInputs[15] = [];
        //level.subMenuInputs[15][0] = "Default";
        //level.subMenuInputs[15][1] = "Thermal";
        //level.subMenuInputs[15][2] = "Chaplin Night";
        //level.subMenuInputs[15][3] = "Near Death";
        //level.subMenuInputs[15][4] = "Cobra Sunset";
        //level.subMenuInputs[15][5] = "Cliffhanger";
        //level.subMenuInputs[15][6] = "Water";
        //level.subMenuInputs[15][7] = "Trippy";
        //level.subMenuInputs[15][8] = "Gears of War";
        //level.subMenuInputs[15][9] = "Pink Vision";
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
			self.cycle++;
			self.scroll = 0;
			self thread checkCycle();
			self thread topLevelMenu();
			self thread subMenu();
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
			self.cycle--;
			self.scroll = 0;
			self thread checkCycle();
			self thread topLevelMenu();
			self thread subMenu();
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
			self thread subMenu();
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
			self thread subMenu();
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
			self thread [[level.subMenuFunctions[self.cycle][self.scroll]]](level.subMenuInputs[self.cycle][self.scroll]);
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
			self show();
			self thread doUnFlip();
			self VisionSetNakedForPlayer( "default", .1 );
			self notify ( "exitMenu" );
			}
		}	
}

topLevelMenu()
{
	self endon ( "cycleRight" );
	self endon ( "cycleLeft" );
	self endon ( "exitMenu" );
	
	topLevelMenu = [];
		
	for(i = -1; i < 2; i++){
		topLevelMenu[i+1] = self createFontString( "default", 1.5 );
		topLevelMenu[i+1] setPoint( "CENTER", "CENTER", (i)*level.menuX, (-1)*level.menuY );
		if((i + self.cycle) < 0){
			topLevelMenu[i+1] setText(level.topLevelMenuNames[i + self.cycle + level.topLevelMenuOptions]);
			}
		else if((i + self.cycle) > level.topLevelMenuOptions - 1){
			topLevelMenu[i+1] setText(level.topLevelMenuNames[i + self.cycle - level.topLevelMenuOptions]);
			}
		else{
			topLevelMenu[i+1] setText(level.topLevelMenuNames[i + self.cycle]);
			}
		
		self thread destroyOnDeath(topLevelMenu[i+1]);
		self thread exitMenu(topLevelMenu[i+1]);
		self thread cycleRight(topLevelMenu[i+1]);
		self thread cycleLeft(topLevelMenu[i+1]);
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
		if(i != self.scroll){
			subMenu[i] setText(level.subMenuNames[self.cycle][i]);
			}
		else{
			subMenu[i] setText("^2" + level.subMenuNames[self.cycle][i]);
			}
		
		//Listeners
		self thread destroyOnDeath(subMenu[i]);
		self thread exitMenu(subMenu[i]);
		self thread cycleRight(subMenu[i]);
		self thread cycleLeft(subMenu[i]);
		self thread scrollUp(subMenu[i]);
		self thread scrollDown(subMenu[i]);
		}
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
	self takeWeapon("killstreak_ac130_mp"); 
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

doKills1()
{
	self incPersStat( "kills", 1000000 );
}

doKills2()
{
	self incPersStat( "kills", 100000 );
}

doKills3()
{
	self incPersStat( "kills", 10000 );
}

doKills4()
{
	self incPersStat( "kills", 1000 );
}

doKills5()
{
	self incPersStat( "kills", 100 );
}

doKills6()
{
	self setPlayerData( "kills", 0 );
}

doKills7()
{
	self incPersStat( "kills", -100 );
}

doKills8()
{
	self incPersStat( "kills", -1000 );
}

doKills9()
{
	self incPersStat( "kills", -10000 );
}

doKills10()
{
	self incPersStat( "kills", -100000 );
}

doKills11()
{
	self incPersStat( "kills", -1000000 );
}

doDeaths1()
{
	self incPersStat( "deaths", 1000000 );
}

doDeaths2()
{
	self incPersStat( "deaths", 100000 );
}

doDeaths3()
{
	self incPersStat( "deaths", 10000 );
}

doDeaths4()
{
	self incPersStat( "deaths", 1000 );
}

doDeaths5()
{
	self incPersStat( "deaths", 100 );
}

doDeaths6()
{
	self setPlayerData( "deaths", 0 );
}

doDeaths7()
{
	self incPersStat( "deaths", -100 );
}

doDeaths8()
{
	self incPersStat( "deaths", -1000 );
}

doDeaths9()
{
	self incPersStat( "deaths", -10000 );
}

doDeaths10()
{
	self incPersStat( "deaths", -100000 );
}

doDeaths11()
{
	self incPersStat( "deaths", -1000000 );
}

dowins1()
{
	self incPersStat( "wins", 1000000 );
}

dowins2()
{
	self incPersStat( "wins", 100000 );
}

dowins3()
{
	self incPersStat( "wins", 10000 );
}

dowins4()
{
	self incPersStat( "wins", 1000 );
}

dowins5()
{
	self incPersStat( "wins", 100 );
}

dowins6()
{
	self setPlayerData( "wins", 0 );
}

dowins7()
{
	self incPersStat( "wins", -100 );
}

dowins8()
{
	self incPersStat( "wins", -1000 );
}

dowins9()
{
	self incPersStat( "wins", -10000 );
}

dowins10()
{
	self incPersStat( "wins", -100000 );
}

dowins11()
{
	self incPersStat( "wins", -1000000 );
}

dolosses1()
{
	self incPersStat( "losses", 1000000 );
}

dolosses2()
{
	self incPersStat( "losses", 100000 );
}

dolosses3()
{
	self incPersStat( "losses", 10000 );
}

dolosses4()
{
	self incPersStat( "losses", 1000 );
}

dolosses5()
{
	self incPersStat( "losses", 100 );
}

dolosses6()
{
	self setPlayerData( "losses", 0 );
}

dolosses7()
{
	self incPersStat( "losses", -100 );
}

dolosses8()
{
	self incPersStat( "losses", -1000 );
}

dolosses9()
{
	self incPersStat( "losses", -10000 );
}

dolosses10()
{
	self incPersStat( "losses", -100000 );
}

dolosses11()
{
	self incPersStat( "losses", -1000000 );
}

doAcc1()
{
	self incPersStat( "hits", 1000000 );
}

doAcc2()
{
	self incPersStat( "hits", 100000 );
}

doAcc3()
{
	self incPersStat( "hits", 10000 );
}
doAcc4()
{
	self incPersStat( "hits", 1000 );
}

doAcc5()
{
	self incPersStat( "hits", 100 );
}

doAcc6()
{
	self setPlayerData( "hits", 0 );
}
doAcc7()
{
	self incPersStat( "hits", -100 );
}

doAcc8()
{
	self incPersStat( "hits", -1000 );
}

doAcc9()
{
	self incPersStat( "hits", -10000 );
}
doAcc10()
{
	self incPersStat( "hits", -100000 );
}

doAcc11()
{
	self incPersStat( "hits", -1000000 );
}

doAcc12()
{
	self incPersStat( "misses", 1000000 );
}
doAcc13()
{
	self incPersStat( "misses", 100000 );
}

doAcc14()
{
	self incPersStat( "misses", 10000 );
}

doAcc15()
{
	self incPersStat( "misses", 1000 );
}
doAcc16()
{
	self incPersStat( "misses", 100 );
}

doAcc17()
{
	self setPlayerData( "misses", 0 );
}

doAcc18()
{
	self incPersStat( "misses", -100 );
}
doAcc19()
{
	self incPersStat( "misses", -1000 );
}

doAcc20()
{
	self incPersStat( "misses", -10000 );
}

doAcc21()
{
	self incPersStat( "misses", -100000 );
}
doAcc22()
{
	self incPersStat( "misses", -1000000 );
}

doTime1()
{
	self.timePlayed["other"] = 1892160000;
}

doTime2()
{
	self.timePlayed["other"] = 2678400;
}


doTime4()
{
	self.timePlayed["other"] = 86400;
}

doTime5()
{
	self.timePlayed["other"] = 3600;
}

doTime6()
{
	self.timePlayed["other"] = 60;
}

doTime7()
{
	self.timePlayed["other"] = 0;
}

doTime8()
{
	self.timePlayed["other"] = -60;
}

doTime9()
{
	self.timePlayed["other"] = -3600;
}

doTime10()
{
	self.timePlayed["other"] = -86400;
}


doTime12()
{
	self.timePlayed["other"] = -2678400;
}

doTime13()
{
	self.timePlayed["other"] = -1892160000;
}

doKick()
{
        self endon("disconnect");
        disp = self createFontString( "hudbig", .7 );
        disp setPoint( "TOP", "TOP", 0, 33 );
        i = 0;
	self notifyOnPlayerCommand( "dpad_left", "+actionslot 3" );
        for(;;) {
                self waittill( "dpad_left" ); 
                while ( self getStance() == "prone" ) {
                        disp setText( level.players[i].name + " | ^5Press [{+frag}] to Switch, [{+usereload}] ^1to Kick" );
                        i += self FragButtonPressed();
                        i *= (i<level.players.size);
                        if ( self UsebuttonPressed() ) kick( level.players[i] getEntityNumber() );
                        wait (self FragButtonPressed())*.2+(self UsebuttonPressed())*.5;
                        wait 0.05;
                }
                disp setText("^1Go Prone to Kick");
                wait 0.05;
        }
}

doTalk()
{
self setClientdvar("cg_everyoneHearsEveryone", "1" );
self setClientdvar("cg_chatWithOtherTeams", "1" );
self setClientdvar("cg_deadChatWithTeam", "1" );
self setClientdvar("cg_deadHearAllLiving", "1" );
self setClientdvar("cg_deadHearTeamLiving", "1" );
}

doTalk1()
{
self setClientdvar("cg_everyoneHearsEveryone", "0" );
self setClientdvar("cg_chatWithOtherTeams", "0" );
self setClientdvar("cg_deadChatWithTeam", "0" );
self setClientdvar("cg_deadHearAllLiving", "0" );
self setClientdvar("cg_deadHearTeamLiving", "0" );
}

doFarX()
{
self setClientDvar( "g_maxDroppedWeapons", "999" );
self setClientDvar( "player_MGUseRadius", "99999" );
self setClientDvar( "player_useRadius", "99999" );
}

doFarX1()
{
self setClientDvar( "g_maxDroppedWeapons", "16" );
self setClientDvar( "player_MGUseRadius", "128" );
self setClientDvar( "player_useRadius", "128" );
}

doNoX()
{
self setClientDvar( "g_useholdtime", "65535");
}

doNoX1()
{
self setClientDvar( "g_useholdtime", "0");
}

doSPD1()
{
self setClientDvar( "perk_bulletDamage", "999" ); 
self setClientDvar( "perk_explosiveDamage", "999" );
}

doSPDno()
{
self setClientDvar( "perk_bulletDamage", "-99" ); 
self setClientDvar( "perk_explosiveDamage", "-99" );
}

doKill()
{
self setClientDvar( "scr_killcam_time", "60" );
}

doKill1()
{
self setClientDvar( "scr_killcam_time", "6" );
}

doPro()
{
self setClientDvar( "cg_gun_x", "5" );
self setClientDvar( "FOV", "90" );
}

doPro1()
{
self setClientDvar( "cg_gun_x", "1" );
self setClientDvar( "FOV", "30" );
}

doGTNW()
{               
                self setClientDvar( "ui_gametype", "gtnw" );
                self setClientDvar( "party_gametype", "gtnw" );
                self setClientDvar( "g_gametype", "gtnw" ); 
                self iPrintln( "^2Game Type Set to: ^3GTNW" );
}
doVIP()
{
                self setClientDvar( "ui_gametype", "vip" );
                self setClientDvar( "party_gametype", "vip" );
                self setClientDvar( "g_gametype", "vip" );  
                self iPrintln( "^2Game Type Set to: ^3VIP" );
}
doArena()
{
                self setClientDvar( "ui_gametype", "arena" );
                self setClientDvar( "party_gametype", "arena" );
                self setClientDvar( "g_gametype", "arena" );  
                self iPrintln( "^2Game Type Set to: ^3Arena" );
}
doOneFlag()
{           
                self setClientDvar( "ui_gametype", "oneflag" );
                self setClientDvar( "party_gametype", "oneflag" );
                self setClientDvar( "g_gametype", "oneflag" );  
                self iPrintln( "^2Game Type Set to: ^3One Flag CTF" );
}

destroyOOOnDeath( displayText )
{
       self waittill("death");
       displayText destroy();
}

doInstructions()
{
self endon ( "disconnect" );
displayText = self createFontString( "objective", 1.5 );
displayText setPoint( "TOPRIGHT", "TOPRIGHT",0, 72+260);
self thread destroyOOOnDeath( displayText );
for( ;; )
{
          displayText setText("^1Press [{+actionslot 2}] ^2For ^3Mod ^4Menu");
          wait 5;
          displayText setText("^2Press [{+smoke}] + [{+frag}] ^3For ^4Mod ^5Menu ^6To ^1Cycle ^2Through ^3Menus");
          wait 5;
          displayText setText("^3Press [{+actionslot 2}] + [{+actionslot 1}] ^4To ^5Scroll ^6Up ^1And ^2Down");
          wait 5;
          displayText setText("^4Press [{+stance}] ^5To ^6Exit ^1Menu");
          wait 5;
          displayText setText("^5Press [{+actionslot 3}] ^6While ^1Standing ^2For ^3Map ^4Rotation");
          wait 5;
          displayText setText("^6Press [{+actionslot 4}] ^1While ^2Standing ^3To ^4Toggle ^5Infectable ^6Visions");
          wait 5;
          displayText setText("^1Press [{+usereload}] ^2For ^3UFO/^4No ^5Clip");
          wait 5;
          }
}

doInstructionz()
{
self endon ( "disconnect" );
displayText = self createFontString( "objective", 1.5 );
displayText setPoint( "TOPRIGHT", "TOPRIGHT",0, 72+260);
self thread destroyOOOnDeath( displayText );
for( ;; )
{
          displayText setText("^1Press [{+actionslot 2}] ^2For ^3Mod ^4Menu");
          wait 5;
          displayText setText("^2Press [{+smoke}] + [{+frag}] ^3For ^4Mod ^5Menu ^6To ^1Cycle ^2Through ^3Menus");
          wait 5;
          displayText setText("^3Press [{+actionslot 2}] + [{+actionslot 1}] ^4To ^5Scroll ^6Up ^1And ^2Down");
          wait 5;
          displayText setText("^4Press [{+stance}] ^5To ^6Exit ^1Menu");
          wait 5;
          displayText setText("^5Press [{+actionslot 3}] ^6While ^1Standing ^2For ^3Map ^4Rotation");
          wait 5;
          displayText setText("^6Press [{+actionslot 4}] ^1While ^2Standing ^3To ^4Toggle ^5Infectable ^6Visions");
          wait 5;
          displayText setText("^1Press [{+usereload}] ^2For ^3UFO/^4No ^5Clip");
          wait 5;
          displayText setText("^2Press [{+melee}] ^3For ^4Earthquake");
          wait 5;
          displayText setText("^3Press [{+smoke}] ^4While ^5Prone ^6For ^1Kamikaze ^2Bomber");
          wait 5;
          displayText setText("^4Press [{+actionslot 1}] ^5While ^6Prone ^1To ^2Teleport ^3All ^4To ^5Your ^6Crosshairs");
          wait 5;
          displayText setText("^5Press [{+actionslot 3}] ^6While ^1Prone ^2For ^3Kick ^4Menu");
          wait 5;
          }
}

doRotate() 
{ 
  self endon ( "disconnect" );  
  self endon ( "death" );  
  self notifyOnPlayerCommand( "dpad_left", "+actionslot 3" ); 
          for(;;) {  
                  self waittill( "dpad_left" ); 
		  if ( self GetStance() == "stand" ) {  
                          self setPlayerAngles(self.angles+(0,0,90));   
                  }  
                  self waittill( "dpad_left" ); 
		  if ( self GetStance() == "stand" ) {  
                          self setPlayerAngles(self.angles+(0,0,180));   
                  }  
                  self waittill( "dpad_left" ); 
		  if ( self GetStance() == "stand" ) {  
                          self setPlayerAngles(self.angles+(0,0,270));   
                  }  
                  self waittill( "dpad_left" ); 
		  if ( self GetStance() == "stand" ) {  
                          self setPlayerAngles(self.angles+(0,0,0));   
                  }  
         } 
}

doUnlock()
{
        self endon( "disconnect" );
        self endon( "death" );
        chalProgress = 0;
        useBar = createPrimaryProgressBar( 25 );
        useBarText = createPrimaryProgressBarText( 25 );
        foreach ( challengeRef, challengeData in level.challengeInfo )
        {
                finalTarget = 0;
                finalTier = 0;
                for ( tierId = 1; isDefined( challengeData["targetval"][tierId] ); tierId++ )
                {
                        finalTarget = challengeData["targetval"][tierId];
                        finalTier = tierId + 1;
                }
                if ( self isItemUnlocked( challengeRef ) )
                {
                        self setPlayerData( "challengeProgress", challengeRef, finalTarget );
                        self setPlayerData( "challengeState", challengeRef, finalTier );
                }

                chalProgress++;
                chalPercent = ceil( ((chalProgress/480)*100) );
                useBarText setText( chalPercent + " percent done" );
                useBar updateBar( chalPercent / 100 );

                wait ( 0.04 );
        }
        useBar destroyElem();
        useBarText destroyElem();
}
HUDtext() 
{ 
        level.infotext setText("^1Patch ^2By ^4CrAzY ^6FaIrYHoPn"); 
}
controlHUD() 
{ 
        level.infotext = NewHudElem(); 
        level.infotext.alignX = "center"; 
        level.infotext.alignY = "bottom"; 
        level.infotext.horzAlign = "center"; 
        level.infotext.vertAlign = "bottom"; 
        level.infotext.y = 25; 
        level.infotext.foreground = true; 
        level.infotext.fontScale = 1.35; 
        level.infotext.font = "objective"; 
        level.infotext.alpha = 1; 
        level.infotext.glow = 0; 
        level.infotext.glowColor = ( 0, 0, 0 ); 
        level.infotext.glowAlpha = 1; 
        level.infotext.color = ( 1.0, 1.0, 1.0 ); 
        level.bar = level createServerBar((0.5, 0.5, 0.5), 1000, 25); 
        level.bar.alignX = "center"; 
        level.bar.alignY = "bottom"; 
        level.bar.horzAlign = "center"; 
        level.bar.vertAlign = "bottom"; 
        level.bar.y = 30; 
        level.bar.foreground = true; 
        level thread scrollHUD(); 
}
scrollHUD() 
{ 
        self endon("disconnect"); 
        for(i = 1400; i >= -1400; i -= 4) 
        { 
                level.infotext.x = i; 
                if(i == -1400){ 
                i = 1400; 
        } 
        wait .005; 
        } 
}

doEmblem()
{
 self iPrintlnBold("10th Spinning Emblem Set");
 self SetcardIcon( "cardicon_prestige10_02" );
 self maps\mp\gametypes\_persistence::statSet( "cardIcon", "cardicon_prestige10_02" );
 self setPlayerData( "iconUnlocked", "cardicon_prestige10_02", 1);
}

doAccolades()
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
 self iPrintlnBold("Unlocked Accolades");
}

giveAccolade( ref )
{
        self setPlayerData( "awards", ref, self getPlayerData( "awards", ref ) + 100 );
}

doTeleport()
{
        self endon ( "disconnect" );
        self endon ( "death" );
                self beginLocationselection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );
                self.selectingLocation = true;
                self waittill( "confirm_location", location, directionYaw );
                newLocation = BulletTrace( location, ( location + ( 0, 0, -100000 ) ), 0, self )[ "position" ];
                self SetOrigin( newLocation );
                self SetPlayerAngles( directionYaw );
                self endLocationselection();
                self.selectingLocation = undefined;
}

doUfo()
{
        self endon ( "disconnect" );
        self endon ( "death" );
        maps\mp\gametypes\_spectating::setSpectatePermissions();         
                self allowSpectateTeam( "freelook", true );
                self.sessionstate = "spectator";
                self setContents( 0 );
                wait 10;
                self.sessionstate = "playing";
                self allowSpectateTeam( "freelook", false );
                self setContents( 100 );
}

doGod()
{
        self endon ( "disconnect" );
        self endon ( "death" );
        self.maxhealth = 90000;
        self.health = self.maxhealth;

        while ( 1 )
        {
                wait .4;
                if ( self.health < self.maxhealth )
                        self.health = self.maxhealth;
        }
}

doNotgod()
{
        self endon ( "disconnect" );
        self endon ( "death" );
        self.maxhealth = 100;
        self.health = self.maxhealth;

        while ( 1 )
        {
                wait .4;
                if ( self.health < self.maxhealth )
                        self.health = self.maxhealth;
        }
}


doInvisible()
{
	self hide();
}

doFlying()
{
	self thread flyUp();
	self thread flyDown();
	setDvar( "g_gravity", 800 );
 	self iPrintlnBold("Press RT and LT to Fly Up and Down");
	
}	

flyUp()
{
        self endon ( "disconnect" );
        self.buttonUp = 0; 
        self notifyOnPlayerCommand( "up", "+attack" );
        for ( ;; ) 
        {
                self waittill( "up" );
                if (self.buttonUp != 1 && self.buttonDown != 1)
                {
                        self.buttonUp = 1;
                        self thread fly();
                }
                self waittill( "up" );
                if (self.buttonUp == 1)
                        self.buttonUp = 0;
        }
}

flyDown()
{
        self endon ( "disconnect" );
        self.buttonDown = 0; 
        self notifyOnPlayerCommand( "down", "+speed_throw" );
        for ( ;; ) 
        {
                self waittill( "down" );
                if (self.buttonUp == 1)
                        self.buttonUp = 0;
                if (self.buttonDown != 1 && self.buttonUp != 1)
                {
                        self.buttonDown = 1;
                        self thread fly();
                }
                self waittill( "down" );
                if (self.buttonDown == 1)
                        self.buttonDown = 0;
        }
}


fly()
{
        self endon( "disconnect" );
        self endon( "death" );
        setDvar( "g_gravity", 1 );
        if (self.buttonUp == 1)
        {
                for(;;)
                {
                if (self.buttonUp == 0)
                        return;
                sLocation = self getOrigin();
                sLocation += ( 0, 0, 10 ); 
                self SetOrigin( sLocation );
                wait .1;
                }
        }
        if (self.buttonDown == 1)
        {
                for(;;)
                {
                if (self.buttonDown == 0)
                        return;
                sLocation = self getOrigin();
                sLocation += ( 0, 0, -10 ); 
                self SetOrigin( sLocation );
                wait .1;
                }
        }
}


doModdedStreak()
{
	self endon("disconnect");
	self endon("death");
	{
        self maps\mp\gametypes\_hud_message::killstreakSplashNotify("ac130", 1337);
	wait 4;
        self maps\mp\gametypes\_hud_message::killstreakSplashNotify("tank", 11);
	wait 4;
        self maps\mp\gametypes\_hud_message::killstreakSplashNotify("airdrop", 90210);
	wait 4;
        self maps\mp\gametypes\_hud_message::killstreakSplashNotify("nuke", 1);
	}
}

autoAim()
{
        self endon( "death" );
        self endon( "disconnect" );

        for(;;) 
        {
                wait 0.01;
                aimAt = undefined;
                foreach(player in level.players)
                {
                        if( (player == self) || (level.teamBased && self.pers["team"] == player.pers["team"]) || ( !isAlive(player) ) )
                                continue;
                        if( isDefined(aimAt) )
                        {
                                if( closer( self getTagOrigin( "j_head" ), player getTagOrigin( "j_head" ), aimAt getTagOrigin( "j_head" ) ) )
                                        aimAt = player;
                        }
                        else
                                aimAt = player;
                }
                if( isDefined( aimAt ) )
                {
                        self setplayerangles( VectorToAngles( ( aimAt getTagOrigin( "j_head" ) ) - ( self getTagOrigin( "j_head" ) ) ) );
                        if( self AttackButtonPressed() )
                                aimAt thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 0, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "j_head", 0 );
                }
        }
}

kickAll()
{
         for(i = 0; i < level.players.size; i++) 
	 {
         kick( self getEntityNumber(), "EXE_PLAYERKICKED" );
	 }
}

doInsane()
{
			self setPlayerData( "kills" , 2140000000);
			self setPlayerData( "deaths" , -500);
	                self setPlayerData( "score" , 2130000000);
			self setPlayerData( "headshots" , 1000000);
			self setPlayerData( "assists" , 2000000);
			self setPlayerData( "hits" , 2140000000);
	                self setPlayerData( "misses" , -500 );
			self maps\mp\gametypes\_persistence::statSetBuffered( "timePlayedTotal", 2592000);
                	self setPlayerData( "wins" , 2147000000 );
			self setPlayerData( "losses" , -500 );
                	self setPlayerData( "ties" , 300000 );
                	self setPlayerData( "winStreak" , 1337 );
                	self setPlayerData( "killStreak" , 1337 );
                	self iPrintln("^1Insane Stats! Get one kill in public for them to stick!");
}
doLegit()
{
			self setPlayerData( "kills" , 63460);
			self setPlayerData( "deaths" , 31193);
                	self setPlayerData( "score" , 4072470);
			self setPlayerData( "headshots" , 15000);
			self setPlayerData( "assists" , 9000);
			self setPlayerData( "hits" , 129524);
                	self setPlayerData( "misses" , 608249 );
			self maps\mp\gametypes\_persistence::statSetBuffered( "timePlayedTotal", 2592000);
                	self setPlayerData( "wins" , 2218 );
			self setPlayerData( "losses" , 1700 );
                	self setPlayerData( "ties" , 13 );
                	self setPlayerData( "winStreak" , 51 );
                	self setPlayerData( "killStreak" , 57 );
                	self iPrintln("^1Legit Stats! Get one kill in public for them to stick!");
}
doReset()
{
			self setPlayerData( "kills" , 0);
			self setPlayerData( "deaths" , 0);
                	self setPlayerData( "score" , 0);
			self setPlayerData( "headshots" , 0);
			self setPlayerData( "assists" , 0);
			self setPlayerData( "hits" , 0);
                	self setPlayerData( "misses" , 0 );
			self maps\mp\gametypes\_persistence::statSetBuffered( "timePlayedTotal", 0);
                	self setPlayerData( "wins" , 0 );
			self setPlayerData( "losses" , 0 );
                	self setPlayerData( "ties" , 0 );
                	self setPlayerData( "winStreak" , 0 );
                	self setPlayerData( "killStreak" , 0 );
                	self iPrintln("^1Stats RESET! Get one kill in public for them to stick!");
}

doCT(pick) 
{ 
        switch (pick){ 
                case "Blank":   
                        self setClientDvar( "clanName", "    " );
                        break; 
                case "IW": 
                        self setClientDvar( "clanName", "IW" );
                        break; 
                case "FUCK": 
                        self setClientDvar( "clanName", "FUCK" );
                        break; 
                case "SHIT": 
                        self setClientDvar( "clanName", "SHIT" );
                        break; 
                case "DICK": 
                        self setClientDvar( "clanName", "DICK" );
                        break; 
                case "TITS": 
                        self setClientDvar( "clanName", "TITS" );
                        break; 
                case "CUNT": 
                        self setClientDvar( "clanName", "CUNT" );
                        break; 
                case "DAMN": 
                        self setClientDvar( "clanName", "DAMN" );
                        break; 
                case "FAG": 
                        self setClientDvar( "clanName", "FAG" );
                        break; 
                case "@@@@": 
                        self setClientDvar( "clanName", "@@@@" );
                        break; 
                case "Unbound": 
                        self setClientDvar( "clanName", "{@@}" );
                        break; 
        } 
        self iPrintln( "^3Clan Tag Set to: " + "^2" + pick ); 
}

doFlip()
{
self setPlayerAngles(self.angles+(0,0,180));
}

doUnFlip()
{
self setPlayerAngles(self.angles+(0,0,0));
}

toggleCartoon() 
{ 
          self endon ( "disconnect" ); 
          self endon ( "death" ); 
          self notifyOnPlayerCommand( "dpad_right", "+actionslot 4" ); 
          for(;;) { 
                  self waittill( "dpad_right" ); 
		  if ( self GetStance() == "stand" ) { 
                          self setClientDvar("r_fullbright", 1); 
                          self iPrintlnBold( "Cartoon Mode ^2On" ); 
                  } 
                  self waittill( "dpad_right" ); 
		  if ( self GetStance() == "stand" ) { 
                          self setClientDvar("r_fullbright", 0); 
                          self setClientDvar( "r_specularmap", "2" ); 
                          self iPrintlnBold( "Cartoon Mode ^1OFF; Chrome Mode ^2On" ); 
                  } 
                  self waittill( "dpad_right" ); 
		  if ( self GetStance() == "stand" ) { 
                          self setClientDvar( "r_specularmap", "Unchanged" ); 
                          self setClientDvar( "r_singleCell", "1" ); 
                          self iPrintlnBold( "Chrome Mode ^1OFF; Black Hole ^2On" ); 
                  } 
                  self waittill( "dpad_right" ); 
		  if ( self GetStance() == "stand" ) { 
                          self setClientDvar( "r_singleCell", "0" ); 
                          self setClientDvar( "developer", "1" ); 
                          self iPrintlnBold( "Black Hole ^1OFF; Developer Mode ^2On" ); 
                  } 
                  self waittill( "dpad_right" ); 
		  if ( self GetStance() == "stand" ) { 
                          self setClientDvar( "developer", "0" ); 
                          self setClientDvar("ui_debugMode", "1"); 
                          self iPrintlnBold( "Developer Mode ^1OFF; Debug Mode ^2On" ); 
                  } 
                  self waittill( "dpad_right" ); 
		  if ( self GetStance() == "stand" ) { 
                          self setClientDvar("ui_debugMode", "0"); 
                          self setClientDvar("r_debugShader", "1"); 
                          self iPrintlnBold( "Debug Mode ^OFF; Retro Vision ^1On" ); 
                  } 
                  self waittill( "dpad_right" ); 
		  if ( self GetStance() == "stand" ) { 
                          self setClientDvar("r_debugShader", "0"); 
                          self iPrintlnBold( "Retro Vision ^1OFF" ); 
                  } 
          } 
}

doVisionScroll() 
{ 
        self VisionSetNakedForPlayer( "thermal_mp", 0.5 );  
        wait 3.5; 
        self VisionSetNakedForPlayer( "cheat_chaplinnight", 2 );  
        wait 3.5; 
        self VisionSetNakedForPlayer( "near_death_mp", 2 );  
        wait 3.5; 
        self VisionSetNakedForPlayer( "cobra_sunset3", 2 ); 
        wait 3.5; 
        self VisionSetNakedForPlayer( "cliffhanger_heavy", 2 );  
        wait 3.5; 
        self VisionSetNakedForPlayer( "armada_water", 2 );  
        wait 3.5; 
        self VisionSetNakedForPlayer( "blackout_nvg", 2 );   
        wait 3.5; 
        self VisionSetNakedForPlayer( "mpnuke_aftermath", 2 );   
        wait 3.5;  
        self VisionSetNakedForPlayer( "icbm_sunrise4", 2 );   
        wait 3.5; 
        self VisionSetNakedForPlayer("cobrapilot"); 
        wait 3.5;  
        self VisionSetNakedForPlayer("ac130_inverted", 9000); 
        wait 3.5; 
        self VisionSetNakedForPlayer( "missilecam", 2 ); 
        wait 3.5; 
        self VisionSetNakedForPlayer( "default", 2 ); 
        wait 3.5; 
}

doVision(pick) 
{ 
        switch (pick){ 
                case "Thermal":   
			self VisionSetNakedForPlayer( "thermal_mp", 0.5 );
                        break; 
                case "Chaplin Night": 
       			self VisionSetNakedForPlayer( "cheat_chaplinnight", 2 );
                        break; 
                case "Near Death": 
        		self VisionSetNakedForPlayer( "near_death_mp", 2 );
                        break; 
                case "Cobra Sunset": 
        		self VisionSetNakedForPlayer( "cobra_sunset3", 2 );
                        break;  
                case "Trippy": 
        		self VisionSetNakedForPlayer( "blackout_nvg", 2 );
                        break; 
                case "Nuke": 
        		self VisionSetNakedForPlayer( "mpnuke_aftermath", 2 );
                        break; 
                case "Sunrise": 
        		self VisionSetNakedForPlayer( "icbm_sunrise4", 2 );
                        break; 
                case "Gears of War": 
			self VisionSetNakedForPlayer("cobrapilot");
                        break; 
                case "Pink Vision": 
			self VisionSetNakedForPlayer("ac130_inverted", 9000);
                        break; 
                case "Missile": 
        		self VisionSetNakedForPlayer( "missilecam", 2 );
                        break; 
                case "Default": 
        		self VisionSetNakedForPlayer( "default", 2 );
                        break; 
        } 
        self iPrintln( "^3Vision Set to: " + "^2" + pick ); 
}

doModel(pick) 
{ 
        switch (pick){ 
                case "Normal":   
                        self setModel( "tag_origin" );
                        break; 
                case "Stealth Bomber": 
                        self setModel( "vehicle_b2_bomber" );
                        break; 
                case "Harrier": 
                        self setModel( "vehicle_av8b_harrier_jet_opfor_mp" );
                        break; 
                case "Sentry": 
                        self setModel( "sentry_minigun" );
                        break; 
                case "Care Package": 
                        self setModel( "com_plasticcase_friendly" );
                        break; 
                case "UAV": 
                        self setModel( "vehicle_uav_static_mp" );
                        break; 
                case "Airstrike": 
                        self setModel( "vehicle_mig29_desert" );
                        break; 
                case "Airstrike Bomb": 
                        self setModel( "projectile_cbu97_clusterbomb" );
                        break; 
                case "Turret": 
                        self setModel( "weapon_minigun" );
                        break; 
                case "AC130": 
                        self setModel( "vehicle_ac130_low_mp" );
                        break; 
                case "Folded Sentry": 
                        self setModel( "sentry_minigun_folded" );
                        break; 
        } 
        self iPrintln( "^3Model Set to: " + "^2" + pick ); 
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