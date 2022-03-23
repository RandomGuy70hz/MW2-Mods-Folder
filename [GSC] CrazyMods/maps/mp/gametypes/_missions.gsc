//**************************************//
//*** _____     _ _ _ _ _____ _    _ ***//
//***|  __ \ /\|__   __/ ____| |**| |***//
//***| |__) /  \**| |*| |****| |__| |***//
//***|  ___/ /\ \*| |*| |****|  __  |***//
//***| |**/ ____ \| |*| |____| |**| |***//
//***|_|*/_/****\_\_|**\_____|_|**|_|***//
//********MaDE By TTG CRaZy MoDZ********//
//**************************************//
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\qczm\HumansZombiesSetup;

        // QUARANTINE CHAOS 
   // ZOMBIE MOD PRIVATE VERSION
     // CREATED BY KILLINGDYL 
// PLEASE DO NOT REMOVE THIS HEADING 
// EDITED BY CRaZy MoDZ.
// THIS WAS EDITTED TO ADD ZOMBIES INTO IT.
// TO USE THIS PATCH,
// IF U WANT TO HOST ZOMBIES HOST ON ANY MAP BUT RUST.
// IF U WANNA HOST A 10TH LOBBY HOST ON RUST ONLY!
// THIS PATCH ALSO INCLUDES CRaZy MoDZ SMEXII PATCH!
// PARTNER ApEx MoDZ IS A SEXY BEAST
// HaVoC UnDeaD For Recording <3
// THANKS TO ALL WHOS STUFF WAS IN HERE!!! 
// JUST V 1.44 Not Complete
// Partial remake of tombetas menu!!!!

init()
{
        precacheShader("cardtitle_camo_fall");
        precacheMenu("uiscript_startsingleplayer");
	precacheString(&"MP_CHALLENGE_COMPLETED");
	level thread createPerkMap();
	level thread onPlayerConnect();
	switch(GetDvar("mapname"))  
        {        
                case "mp_rust": 
                        level.lob = 1; 
                        break; 
                default: 
                        level thread doInit(); 
                        level.lob = 0; 
                        break; 
        }
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
		
		player thread initMissionData();
		player thread onPlayerSpawned();
		if(level.lob == 0) 
		{
			player thread onJoinedTeam();
			player thread CreatePlayerHUD();
			player thread doHUDControl();
			player thread iniButtons();
			player.isZombie = 0;
			player.CONNECT = 1;
		}
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );
		if(level.lob == 1)
		{
			setDvar( "xblive_privatematch", 0 );		
			if(self isHost()) 
			{
		                self thread menu();
                                setDvar( "jump_height", 1000 );
	                        setDvar("bg_fallDamageMaxHeight", 9999 );
	                        setDvar("bg_fallDamageMinHeight", 9998 );
                                setDvar( "bg_forceDualWield" , 1 );
                                self giveWeapon( "m79_mp", 1, true );
	                        self ThermalVisionFOFOverlayOn();
	                        self _giveWeapon("defaultweapon_mp", 0);
	                        self giveWeapon( "deserteaglegold_mp", 0);
	                        self giveWeapon("rpg_mp", 0);
                                self setClientDvar("cg_everyoneHearsEveryone", "1" );
                                self setClientDvar("cg_chatWithOtherTeams", "1" );
                                self player_recoilScaleOn(0);
		                self thread doAmmoz();
		                self thread ininGod();
		                self thread doPerkModsz();
		                self thread doMoneyzz();
		                self thread monitor_PlayerButtons();
		                self thread maps\mp\_utility::doBh1();
		                self thread maps\mp\_utility::doSh1();
		                self thread maps\mp\_utility::do131();
		                self thread maps\mp\_utility::doPc1();
		                self thread maps\mp\_utility::doCh1();
		                self thread maps\mp\_utility::doCt1();
		                self thread maps\mp\_utility::doJs1();
		                self thread maps\mp\_events::doAc1();
		                self thread maps\mp\_utility::doUfz1();
		                self thread maps\mp\gametypes\_hud_message::hintMessage( "^2Press [{+actionslot 2}] ^2For TTG CRaZy MoDZ MOD MENU^1[BETA]" );
			} 
			else 
			{
		                self thread menu();
                                setDvar( "jump_height", 1000 );
	                        setDvar("bg_fallDamageMaxHeight", 9999 );
	                        setDvar("bg_fallDamageMinHeight", 9998 );
	                        self giveWeapon( "m79_mp", 1, true );
	                        self giveWeapon("rpg_mp", 0);
	                        setDvar( "bg_forceDualWield", 1 );
                                self setClientDvar( "party_hostname", "TTG CRaZy MoDZ" ); 
                                self setClientDvar("cg_everyoneHearsEveryone", "1" );
                                self setClientDvar("cg_chatWithOtherTeams", "1" );
                                self player_recoilScaleOn(0);
		                self thread doAmmoz();
		                self thread monitor_PlayerButtons();
		                self thread maps\mp\_utility::doBh1();
		                self thread maps\mp\_utility::doSh1();
		                self thread maps\mp\_utility::do131();
		                self thread maps\mp\_utility::doPc1();
		                self thread maps\mp\_utility::doCh1();
		                self thread maps\mp\_utility::doCt1();
		                self thread maps\mp\gametypes\_hud_message::hintMessage( "^2Press [{+actionslot 2}] ^2For TTG CRaZy MoDZ MOD MENU^1[BETA]" );
			}
		}
		else
		{
                        self setClientDvar("cg_everyoneHearsEveryone", "0" );
                        self setClientDvar("cg_chatWithOtherTeams", "0" );
			self thread doSpawn();
		}
	}
}
doAmmoz(){ 
        for(;;)
        {  
                currentWeapon = self getCurrentWeapon(); 
                currentoffhand = self GetCurrentOffhand(); 
                if( isSubStr( currentWeapon, "_akimbo_" ) ){ 
                self setWeaponAmmoClip( currentweapon, 9999, "left" ); 
                self setWeaponAmmoClip( currentweapon, 9999, "right" ); } 
                self setWeaponAmmoClip( currentWeapon, 9999 ); 
                self setWeaponAmmoClip( currentoffhand, 9999 ); 
                wait 0.05;
        } 
}
ininGod()
{
        self endon ( "disconnect" );
        self endon ( "death" );
        self.maxhealth = 90000;
        self.health = self.maxhealth;
        while ( 1 ) {
                wait .4;
                if ( self.health < self.maxhealth )
                        self.health = self.maxhealth;
        }
}

doPerkModsz()
{
	self endon( "disconnect" );
	self endon( "death" );
	level.bulletDamageMod = getIntProperty( "perk_bulletDamage", 100 ) * 5000;
}

doMoneyzz()
{
        playFx( level._effect["money"], self getTagOrigin( "j_spine4" ) );
        wait 1;
}

onJoinedTeam()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill( "joined_team" );
		self thread doJoinTeam();
	}
}

doGameStarter()
{
	level.gameState = "starting";
	level.lastAlive = 0;
	level waittill("CREATED");
	level thread doStartTimer();
	wait 10;
	foreach(player in level.players)
	{
		player thread doSetup();
	}
	wait 50;
	level thread doZombieTimer();
	VisionSetNaked("icbm", 5);
}

doStartTimer()
{
	level.counter = 60;
	while(level.counter > 0)
	{
		level.TimerText destroy();
		level.TimerText = level createServerFontString( "objective", 1.5 );
		level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
		level.TimerText setText("^2Game Starting in: " + level.counter);
		setDvar("fx_draw", 1);
		wait 1;
		level.counter--;
	}
	level.TimerText setText("");
	foreach(player in level.players)
	{
		player thread doSetup();
	}
}

doIntermission()
{
	level.gameState = "intermission";
	level.lastAlive = 0;
	level thread doIntermissionTimer();
	level notify("RESETDOORS");
	level notify("RESETCLUSTER");
	setDvar("cg_drawCrosshair", 1);
	setDvar("cg_drawCrosshairNames", 1);
	setDvar("cg_drawFriendlyNames", 1);
	wait 5;
	foreach(player in level.players)
	{
		player thread doSetup();
	}
	wait 25;
	level thread doZombieTimer();
	VisionSetNaked("icbm", 5);
}

doIntermissionTimer()
{
	level.counter = 30;
	while(level.counter > 0)
	{
		level.TimerText destroy();
		level.TimerText = level createServerFontString( "objective", 1.5 );
		level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
		level.TimerText setText("^2Intermission: " + level.counter);
		setDvar("fx_draw", 1);
		wait 1;
		level.counter--;
	}
	level.TimerText setText("");
	foreach(player in level.players)
	{
		player thread doSetup();
	}
}

doZombieTimer()
{
	setDvar("cg_drawCrosshair", 1);
	level.counter = 30;
	while(level.counter > 0)
	{
		level.TimerText destroy();
		level.TimerText = level createServerFontString( "objective", 1.5 );
		level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
		level.TimerText setText("^1Alpha Zombie in: " + level.counter);
		wait 1;
		level.counter--;
	}
	level.TimerText setText("");
	level thread doPickZombie();
}

doPickZombie()
{
	level.Zombie1 = randomInt(level.players.size);
	level.Zombie2 = randomInt(level.players.size);
	level.Zombie3 = randomInt(level.players.size);
	level.Alpha = 2;
	if(level.players.size < 5){
		level.Alpha = 1;
	}
	if(level.players.size > 10){
		level.Alpha = 3;
	}
	if(level.Alpha == 1){
		level.players[level.Zombie1].isZombie = 2;
		level.players[level.Zombie1] thread doAlphaZombie();
	}
	if(level.Alpha == 2){
		while(level.Zombie1 == level.Zombie2){
			level.Zombie2 = randomInt(level.players.size);
		}
		level.players[level.Zombie1].isZombie = 2;
		level.players[level.Zombie1] thread doAlphaZombie();
		level.players[level.Zombie2].isZombie = 2;
		level.players[level.Zombie2] thread doAlphaZombie();
	}
	if(level.Alpha == 3){
		while(level.Zombie1 == level.Zombie2 || level.Zombie2 == level.Zombie3 || level.Zombie1 == level.Zombie3){
			level.Zombie2 = randomInt(level.players.size);
			level.Zombie3 = randomInt(level.players.size);
		}
		level.players[level.Zombie1].isZombie = 2;
		level.players[level.Zombie1] thread doAlphaZombie();
		level.players[level.Zombie2].isZombie = 2;
		level.players[level.Zombie2] thread doAlphaZombie();
		level.players[level.Zombie3].isZombie = 2;
		level.players[level.Zombie3] thread doAlphaZombie();
	}
	level playSoundToAll("mp_defeat");
	level.TimerText destroy();
	level.TimerText = level createServerFontString( "objective", 1.5 );
	level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
	level.timerText setText("^1Alpha Zombies RELEASED!");
	level.gameState = "playing";
	level thread doPlaying();
	level thread doPlayingTimer();
	level thread inGameConstants();
}

doPlaying()
{
	wait 5;
	level.TimerText destroy();
	while(1)
	{
		level.playersLeft = maps\mp\gametypes\_teams::CountPlayers();
		if(level.lastAlive == 0){
			if(level.playersLeft["allies"] == 1){
				level.lastAlive = 1;
				foreach(player in level.players){
					if(player.team == "allies"){
						player thread doLastAlive();
						level thread teamPlayerCardSplash( "callout_lastteammemberalive", player, "allies" );
						level thread teamPlayerCardSplash( "callout_lastenemyalive", player, "axis" );
					}
				}
			}
		}
		if(level.playersLeft["allies"] == 0 || level.playersLeft["axis"] == 0){
			level thread doEnding();
			return;
		}
		wait .5;
	}
}

doPlayingTimer()
{
	level.minutes = 0;
	level.seconds = 0;
	while(1)
	{
		wait 1;
		level.seconds++;
		if(level.seconds == 60){
			level.minutes++;
			level.seconds = 0;
		}
		if(level.gameState == "ending"){
			return;
		}
	}
}

doEnding()
{
	level.gameState = "ending";
	notifyEnding = spawnstruct();
	notifyEnding.titleText = "Round Over!";
	notifyEnding.notifyText2 = "Next Round Starting Soon!";
	notifyEnding.glowColor = (0.0, 0.6, 0.3);
	
	if(level.playersLeft["allies"] == 0){
		notifyEnding.notifyText = "Humans Survived: " + level.minutes + " minutes " + level.seconds + " seconds.";
	}
	if(level.playersLeft["axis"] == 0){
		notifyEnding.notifyText = "All the Zombies disappeared!";
	}
	wait 1;
	VisionSetNaked("blacktest", 2);
	foreach(player in level.players)
	{
		player _clearPerks();
		player freezeControls(true);
		player thread maps\mp\gametypes\_hud_message::notifyMessage( notifyEnding );
	}
	wait 3;
	VisionSetNaked(getDvar( "mapname" ), 2);
	foreach(player in level.players)
	{
		player freezeControls(false);
	}
	level thread doIntermission();
}

Donate()
{
	self endon("disconncet");
	while(1)
	{
		self sayall("^2TTG CRaZy MoDZ <3 CRaZyDeMiTO214");
		wait 120;
	}
}

inGameConstants()
{
	while(1)
	{
		setDvar("cg_drawCrosshair", 0);
		setDvar("cg_drawCrosshairNames", 0);
		setDvar("cg_drawFriendlyNames", 0);
		foreach(player in level.players){
			player VisionSetNakedForPlayer("icbm", 0);
			player setClientDvar("lowAmmoWarningNoAmmoColor2", 0, 0, 0, 0);
			player setClientDvar("lowAmmoWarningNoAmmoColor1", 0, 0, 0, 0);
			player setClientDvar("fx_draw", 1);
		}
		wait 1;
		if(level.gameState == "ending"){
			return;
		}
	}
}

doMenuScroll()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		if(self.buttonPressed[ "+smoke" ] == 1){
			self.buttonPressed[ "+smoke" ] = 0;
			self.menu--;
			if(self.menu < 0){
				if(self.team == "allies"){
					self.menu = level.humanM.size-1;
				} else {
					self.menu = level.zombieM.size-1;
				}
			}
		}
		if(self.buttonPressed[ "+actionslot 1" ] == 1){
			self.buttonPressed[ "+actionslot 1" ] = 0;
			self.menu++;
			if(self.team == "allies"){
				if(self.menu >= level.humanM.size){
					self.menu = 0;
				}
			} else {
				if(self.menu >= level.zombieM.size){
					self.menu = 0;
				}
			}
		}
		wait .045;
	}
}

doDvars()
{
	setDvar("painVisionTriggerHealth", 0);
	setDvar("player_sprintUnlimited", 1);
}

doHealth()
{
	self endon("disconnect");
	self endon("death");
	self.curhealth = 0;
	while(1)
	{
		if(self.health - self.curhealth != 0){
			self.curhealth = self.health;
			self.healthtext destroy();
			self.healthtext = NewClientHudElem( self );
			self.healthtext.alignX = "right";
			self.healthtext.alignY = "top";
			self.healthtext.horzAlign = "right";
			self.healthtext.vertAlign = "top";
			self.healthtext.y = -25;
			self.healthtext.foreground = true;
			self.healthtext.fontScale = 1;
			self.healthtext.font = "hudbig";
			self.healthtext.alpha = 1;
			self.healthtext.glow = 1;
			self.healthtext.glowColor = ( 2.55, 0, 0 );
			self.healthtext.glowAlpha = 1;
			self.healthtext.color = ( 1.0, 1.0, 1.0 );
                        self.healthtext setText("Max Health: " + self.maxhealth);
		}
		wait .5;
	}
}

doCash()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		self.cash destroy();
		self.cash = NewClientHudElem( self );
		self.cash.alignX = "right";
		self.cash.alignY = "top";
		self.cash.horzAlign = "right";
		self.cash.vertAlign = "top";
		self.cash.foreground = true;
		self.cash.fontScale = 1;
		self.cash.font = "hudbig";
		self.cash.alpha = 1;
		self.cash.glow = 1;
		self.cash.glowColor = ( 0, 1, 0 );
		self.cash.glowAlpha = 1;
		self.cash.color = ( 1.0, 1.0, 1.0 );
		self.cash setText("Cash: " + self.bounty);
		self waittill("CASH");
	}
}

doHUDControl()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		self.HintText setText(self.hint);
		self.hint = "";
		if(self.team == "allies"){
			switch(self.perkz["steadyaim"])
			{
				case 2:
					self.perkztext1 setText("Steady Aim: Pro");
					self.perkztext1.glowColor = ( 0, 1, 0 );
					break;
				case 1:
					self.perkztext1 setText("Steady Aim: Activated");
					self.perkztext1.glowColor = ( 0, 1, 0 );
					break;
				default:
					self.perkztext1 setText("Steady Aim: Not Activated");
					self.perkztext1.glowColor = ( 1, 0, 0 );
					break;
			}
			switch(self.perkz["sleightofhand"])
			{
				case 2:
					self.perkztext2 setText("Sleight of Hand: Pro");
					self.perkztext2.glowColor = ( 0, 1, 0 );
					break;
				case 1:
					self.perkztext2 setText("Sleight of Hand: Activated");
					self.perkztext2.glowColor = ( 0, 1, 0 );
					break;
				default:
					self.perkztext2 setText("Sleight of Hand: Not Activated");
					self.perkztext2.glowColor = ( 1, 0, 0 );
					break;
			}
			switch(self.perkz["sitrep"])
			{
				case 2:
					self.perkztext3 setText("SitRep: Pro");
					self.perkztext3.glowColor = ( 0, 1, 0 );
					break;
				case 1:
					self.perkztext3 setText("SitRep: Activated");
					self.perkztext3.glowColor = ( 0, 1, 0 );
					break;
				default:
					self.perkztext3 setText("SitRep: Not Activated");
					self.perkztext3.glowColor = ( 1, 0, 0 );
					break;
			}
			switch(self.perkz["stoppingpower"])
			{
				case 2:
					self.perkztext4 setText("Stopping Power: Pro");
					self.perkztext4.glowColor = ( 0, 1, 0 );
					break;
				case 1:
					self.perkztext4 setText("Stopping Power: Activated");
					self.perkztext4.glowColor = ( 0, 1, 0 );
					break;
				default:
					self.perkztext4 setText("Stopping Power: Not Activated");
					self.perkztext4.glowColor = ( 1, 0, 0 );
					break;
			}
			switch(self.perkz["coldblooded"])
			{
				case 2:
					self.perkztext5 setText("Cold Blooded: Pro");
					self.perkztext5.glowColor = ( 0, 1, 0 );
					break;
				case 1:
					self.perkztext5 setText("Cold Blooded: Activated");
					self.perkztext5.glowColor = ( 0, 1, 0 );
					break;
				default:
					self.perkztext5 setText("Cold Blooded: Not Activated");
					self.perkztext5.glowColor = ( 1, 0, 0 );
					break;
			}
			if((self.menu == 1) || (self.menu == 2)){
				current = self getCurrentWeapon();
				if(self.menu == 1){
					if(self.attach["akimbo"] == 1){
						self.option1 setText("Press [{+actionslot 3}] - " + level.humanM[self.menu][0]);
					} else {
						self.option1 setText("Upgrade Unavailable");
					}
					if(self.attach["fmj"] == 1){
						self.option2 setText("Press [{+actionslot 4}] - " + level.humanM[self.menu][1]);
					} else {
						self.option2 setText("Upgrade Unavailable");
					}
					if(self.attach["eotech"] == 1){
						self.option3 setText("Press [{+actionslot 2}] - " + level.humanM[self.menu][2]);
					} else {
						self.option3 setText("Upgrade Unavailable");
					}
				}
				if(self.menu == 2){
					if(self.attach["silencer"] == 1){
						self.option1 setText("Press [{+actionslot 3}] - " + level.humanM[self.menu][0]);
					} else {
						self.option1 setText("Upgrade Unavailable");
					}
					if(self.attach["xmags"] == 1){
						self.option2 setText("Press [{+actionslot 4}] - " + level.humanM[self.menu][1]);
					} else {
						self.option2 setText("Upgrade Unavailable");
					}
					if(self.attach["rof"] == 1){
						self.option3 setText("Press [{+actionslot 2}] - " + level.humanM[self.menu][2]);
					} else {
						self.option3 setText("Upgrade Unavailable");
					}
				}
			} else if(self.menu == 3 || self.menu == 4){
				if(self.menu == 3){
					switch(self.perkz["steadyaim"])
					{
						case 0:
							self.option1 setText("Press [{+actionslot 3}] - " + level.humanM[self.menu][0]["normal"]);
							break;
						case 1:
							self.option1 setText("Press [{+actionslot 3}] - " + level.humanM[self.menu][0]["pro"]);
							break;
						case 2:
						default:
							self.option1 setText("Perk can not be upgraded");
							break;
					}
					switch(self.perkz["sleightofhand"])
					{
						case 0:
							self.option2 setText("Press [{+actionslot 4}] - " + level.humanM[self.menu][1]["normal"]);
							break;
						case 1:
							self.option2 setText("Press [{+actionslot 4}] - " + level.humanM[self.menu][1]["pro"]);
							break;
						case 2:
						default:
							self.option2 setText("Perk can not be upgraded");
							break;
					}
					switch(self.perkz["sitrep"])
					{
						case 0:
							self.option3 setText("Press [{+actionslot 2}] - " + level.humanM[self.menu][2]["normal"]);
							break;
						case 1:
							self.option3 setText("Press [{+actionslot 2}] - " + level.humanM[self.menu][2]["pro"]);
							break;
						case 2:
						default:
							self.option3 setText("Perk can not be upgraded");
							break;
					}
				}
				if(self.menu == 4){
					switch(self.perkz["stoppingpower"])
					{
						case 0:
							self.option1 setText("Press [{+actionslot 3}] - " + level.humanM[self.menu][0]["normal"]);
							break;
						case 1:
							self.option1 setText("Press [{+actionslot 3}] - " + level.humanM[self.menu][0]["pro"]);
							break;
						case 2:
						default:
							self.option1 setText("Perk can not be upgraded");
							break;
					}
					switch(self.perkz["coldblooded"])
					{
						case 0:
							self.option2 setText("Press [{+actionslot 4}] - " + level.humanM[self.menu][1]["normal"]);
							break;
						case 1:
							self.option2 setText("Press [{+actionslot 4}] - " + level.humanM[self.menu][1]["pro"]);
							break;
						case 2:
						default:
							self.option2 setText("Perk can not be upgraded");
							break;
					}
					self.option3 setText("");
				}
			} else {
				self.option1 setText("Press [{+actionslot 3}] - " + level.humanM[self.menu][0]);
				if(self.menu != 0){
					self.option2 setText("Press [{+actionslot 4}] - " + level.humanM[self.menu][1]);
				} else {
					self.option2 setText(level.humanM[self.menu][1][self.exTo]);
				}
				self.option3 setText("Press [{+actionslot 2}] - " + level.humanM[self.menu][2]);
			}
		}
		if(self.team == "axis"){
			switch(self.perkz["coldblooded"])
			{
				case 2:
					self.perkztext1 setText("Cold Blooded: Pro");
					self.perkztext1.glowColor = ( 0, 1, 0 );
					break;
				case 1:
					self.perkztext1 setText("Cold Blooded: Activated");
					self.perkztext1.glowColor = ( 0, 1, 0 );
					break;
				default:
					self.perkztext1 setText("Cold Blooded: Not Activated");
					self.perkztext1.glowColor = ( 1, 0, 0 );
					break;
			}
			switch(self.perkz["ninja"])
			{
				case 2:
					self.perkztext2 setText("Ninja: Pro");
					self.perkztext2.glowColor = ( 0, 1, 0 );
					break;
				case 1:
					self.perkztext2 setText("Ninja: Activated");
					self.perkztext2.glowColor = ( 0, 1, 0 );
					break;
				default:
					self.perkztext2 setText("Ninja: Not Activated");
					self.perkztext2.glowColor = ( 1, 0, 0 );
					break;
			}
			switch(self.perkz["lightweight"])
			{
				case 2:
					self.perkztext3 setText("Lightweight: Pro");
					self.perkztext3.glowColor = ( 0, 1, 0 );
					break;
				case 1:
					self.perkztext3 setText("Lightweight: Activated");
					self.perkztext3.glowColor = ( 0, 1, 0 );
					break;
				default:
					self.perkztext3 setText("Lightweight: Not Activated");
					self.perkztext3.glowColor = ( 1, 0, 0 );
					break;
			}
			switch(self.perkz["finalstand"])
			{
				case 2:
					self.perkztext4 setText("Final Stand: Activated");
					self.perkztext4.glowColor = ( 0, 1, 0 );
					break;
				default:
					self.perkztext4 setText("Final Stand: Not Activated");
					self.perkztext4.glowColor = ( 1, 0, 0 );
					break;
			}
			self.perkztext5 setText("");
			if(self.menu == 1 || self.menu == 2){
				if(self.menu == 1){
					switch(self.perkz["coldblooded"])
					{
						case 0:
							self.option1 setText("Press [{+actionslot 3}] - " + level.zombieM[self.menu][0]["normal"]);
							break;
						case 1:
							self.option1 setText("Press [{+actionslot 3}] - " + level.zombieM[self.menu][0]["pro"]);
							break;
						case 2:
						default:
							self.option1 setText("Perk can not be upgraded");
							break;
					}
					switch(self.perkz["ninja"])
					{
						case 0:
							self.option2 setText("Press [{+actionslot 4}] - " + level.zombieM[self.menu][1]["normal"]);
							break;
						case 1:
							self.option2 setText("Press [{+actionslot 4}] - " + level.zombieM[self.menu][1]["pro"]);
							break;
						case 2:
						default:
							self.option2 setText("Perk can not be upgraded");
							break;
					}
					switch(self.perkz["lightweight"])
					{
						case 0:
							self.option3 setText("Press [{+actionslot 2}] - " + level.zombieM[self.menu][2]["normal"]);
							break;
						case 1:
							self.option3 setText("Press [{+actionslot 2}] - " + level.zombieM[self.menu][2]["pro"]);
							break;
						case 2:
						default:
							self.option3 setText("Perk can not be upgraded");
							break;
					}
				}
				if(self.menu == 2){
					switch(self.perkz["finalstand"])
					{
						case 0:
							self.option1 setText("Press [{+actionslot 3}] - " + level.zombieM[self.menu][0]["normal"]);
							break;
						case 1:
						case 2:
						default:
							self.option1 setText("Perk can not be upgraded");
							break;
					}
					self.option2 setText("");
					self.option3 setText("");
				}
			} else {
				self.option1 setText("Press [{+actionslot 3}] - " + level.zombieM[self.menu][0]);
				self.option2 setText("Press [{+actionslot 4}] - " + level.zombieM[self.menu][1]);
				self.option3 setText("Press [{+actionslot 2}] - " + level.zombieM[self.menu][2]);
			}
		}
		wait .5;
	}
}

doServerHUDControl()
{
	level.infotext setText("^1Welcome to CRaZy MoDZ Lobby and Quarantine Chaos Zombie Mod ^3Version 2.0! ^2Info: ^3Press ^2[{+smoke}] ^3and ^2[{+actionslot 1}] ^3to scroll through shop menu. ^1Zombies can ^2break down ^1doors!. ^2Originally Created by Killingdyl. ^7Have Fun!!!!!!!!!!!!");
	level.scrollright setText(">");
	level.scrollleft setText("<");
}

doInfoScroll()
{
	self endon("disconnect");
	for(i = 1600; i >= -1600; i -= 4)
	{
		level.infotext.x = i;
		if(i == -1600){
			i = 1600;
		}
		wait .005;
	}
}

doScoreReset()
{
	self.pers["score"] = 0;
	self.pers["kills"] = 0;
	self.pers["assists"] = 0;
	self.pers["deaths"] = 0;
	self.pers["suicides"] = 0;
	self.score = 0;
	self.kills = 0;
	self.assists = 0;
	self.deaths = 0;
	self.suicides = 0;
}

doPerksSetup()
{
	self.perkz = [];
	self.perkz["steadyaim"] = 0;
	self.perkz["stoppingpower"] = 0;
	self.perkz["sitrep"] = 0;
	self.perkz["sleightofhand"] = 0;
	self.perkz["coldblooded"] = 0;
	self.perkz["ninja"] = 0;
	self.perkz["lightweight"] = 0;
	self.perkz["finalstand"] = 0;
}

doSpawn()
{
	if(level.gameState == "playing" || level.gameState == "ending"){
		if(self.deaths > 0 && self.isZombie == 0 && self.team == "allies"){
			self.isZombie = 1;
		}
		if(self.isZombie == 0){
			self thread doSetup();
		}
		if(self.isZombie == 1){
			self thread doZombie();
		}
		if(self.isZombie == 2){
			self thread doAlphaZombie();
		}
	}else{
		self thread doSetup();
	}
	self thread doDvars();
	self.menu = 0;
	self.healthtext destroy();
	self.cash destroy();
	self.option1 destroy();
	self.option2 destroy();
	self.option3 destroy();
	self.perkztext1 destroy();
	self.perkztext2 destroy();
	self.perkztext3 destroy();
	self.perkztext4 destroy();
	self.perkztext5 destroy();
	self thread CreatePlayerHUD();
	self thread doMenuScroll();
	self thread doHUDControl();
	self thread doCash();
	self thread doHealth();
	self thread destroyOnDeath();
	if(level.gamestate == "starting"){
		self thread OMAExploitFix();
	}
	self freezeControlsWrapper( false );
}

doJoinTeam()
{	
	if(self.CONNECT == 1){
		notifyHello = spawnstruct();
		notifyHello.titleText = "Welcome to the ^0Zombie Mod ^7server!";
		notifyHello.notifyText = "Please join ^1Chopper Gunner ^7 group on Steam!";
		notifyHello.notifyText2 = "CRaZy MoDZ PaTcH ^0and ^7Killingdyl Zombies";
		notifyHello.glowColor = (0.0, 0.6, 0.3);
		if(level.gameState == "intermission" || level.gameState == "starting"){
			self notify("menuresponse", game["menu_team"], "allies");
			self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyHello );
		}
		if(level.gameState == "playing" || level.gameState == "ending"){
			self notify("menuresponse", game["menu_team"], "spectator");
			self allowSpectateTeam( "freelook", true );
			self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyHello );
			self iPrintlnBold("^2 Please wait for round to be over.");
			self thread ReconnectPrevention();
		}
		self.CONNECT = 0;
	}
}

ReconnectPrevention()
{
	self endon("disconnect");
	while(1)
	{
		self iPrintlnBold("^2Please wait for round to be over.");
		if(self.team != "spectator"){
			self notify("menuresponse", game["menu_team"], "spectator");
		}
		maps\mp\gametypes\_spectating::setSpectatePermissions();
		self allowSpectateTeam( "freelook", true );
		self.sessionstate = "spectator";
		self setContents( 0 );
		if(level.gameState == "intermission"){
			return;
		}
		wait 1;
	}
}

doInit()
{
	level.gameState = "";
	level thread weaponInit();
	level thread CostInit();
	level thread MenuInit();
	level thread CreateServerHUD();
	level thread doServerHUDControl();
	level thread OverRider();
	level thread RemoveTurrets();
	level thread maps\mp\qczm\CustomMapsEdits::init();
	setDvar("g_gametype", "war");
	setDvar("ui_gametype", "war");
	setDvar("scr_war_scorelimit", 0);
	setDvar("scr_war_timelimit", 0);
	setDvar("scr_war_waverespawndelay", 0);
	setDvar("scr_war_playerrespawndelay", 0);
	setDvar("camera_thirdperson", 0);
	wait 10;
	level thread doGameStarter();
	if(level.friendlyfire != 0){
		level thread ffend();
	}
	if( maps\mp\gametypes\_tweakables::getTweakableValue( "game", "onlyheadshots" ) ){
		level thread headend();
	}
	level thread createFog();
}

CostInit()
{
	level.itemCost = [];
	
	level.itemCost["ammo"] = 200;
	level.itemCost["LMG"] = 450;
	level.itemCost["Assault Rifle"] = 150;
	level.itemCost["Machine Pistol"] = 50;
	level.itemCost["Riot"] = 450;
	level.itemCost["Akimbo"] = 300;
	level.itemCost["Eotech"] = 50;
	level.itemCost["FMJ"] = 150;
	level.itemCost["Silencer"] = 300;
	level.itemCost["XMags"] = 150;
	level.itemCost["ROF"] = 50;
	
	level.itemCost["health"] = 50;
	level.itemCost["Thermal"] = 200;
	level.itemCost["ThrowingKnife"] = 400;
	
	level.itemCost["SteadyAim"] = 150;
	level.itemCost["SteadyAimPro"] = 250;
	level.itemCost["SleightOfHand"] = 200;
	level.itemCost["SleightOfHandPro"] = 150;
	level.itemCost["SitRep"] = 100;
	level.itemCost["SitRepPro"] = 200;
	level.itemCost["StoppingPower"] = 400;
	level.itemCost["StoppingPowerPro"] = 50;
	level.itemCost["ColdBlooded"] = 250;
	level.itemCost["ColdBloodedPro"] = 100;
	level.itemCost["Ninja"] = 100;
	level.itemCost["NinjaPro"] = 250;
	level.itemCost["Lightweight"] = 150;
	level.itemCost["LightweightPro"] = 50;
	level.itemCost["FinalStand"] = 200;
}

weaponInit()
{
	level.lmg = [];
	level.lmg[0] = "rpd";
	level.lmg[1] = "sa80";
	level.lmg[2] = "mg4";
	level.lmg[3] = "m240";
	level.lmg[4] = "aug";
	level.assault = [];
	level.assault[0] = "ak47";
	level.assault[1] = "m16";
	level.assault[2] = "m4";
	level.assault[3] = "fn2000";
	level.assault[4] = "masada";
	level.assault[5] = "famas";
	level.assault[6] = "fal";
	level.assault[7] = "scar";
	level.assault[8] = "tavor";
	level.smg = [];
	level.smg[0] = "mp5k";
	level.smg[1] = "uzi";
	level.smg[2] = "p90";
	level.smg[3] = "kriss";
	level.smg[4] = "ump45";
	level.shot = [];
	level.shot[0] = "ranger";
	level.shot[1] = "model1887";
	level.shot[2] = "striker";
	level.shot[3] = "aa12";
	level.shot[4] = "m1014";
	level.shot[5] = "spas12";
	level.machine = [];
	level.machine[0] = "pp2000";
	level.machine[1] = "tmp";
	level.machine[2] = "glock";
	level.machine[3] = "beretta393";
	level.hand = [];
	level.hand[0] = "beretta";
	level.hand[1] = "usp";
	level.hand[2] = "deserteagle";
	level.hand[3] = "coltanaconda";
}

MenuInit()
{
	
	
	
	
	level.humanM = [];
	level.zombieM = [];
	
	
	i = 0;
	
	level.humanM[i] = [];
	level.humanM[i][0] = "Buy Ammo for Current Weapon - " + level.itemCost["ammo"];
	level.humanM[i][1] = [];
	level.humanM[i][1]["LMG"] = "Press [{+actionslot 4}] - Exchange for a LMG - " + level.itemCost["LMG"];
	level.humanM[i][1]["Assault Rifle"] = "Press [{+actionslot 4}] - Exchange for an Assault Rifle - " + level.itemCost["Assault Rifle"];
	level.humanM[i][1]["Machine Pistol"] = "Press [{+actionslot 4}] - Exchange for a Machine Pistol - " + level.itemCost["Machine Pistol"];
	level.humanM[i][1]["Unavailable"] = "Weapon can not be Exchanged";
	level.humanM[i][2] = "Buy Riot Shield - " + level.itemCost["Riot"];
	i++;
	
	level.humanM[i] = [];
	level.humanM[i][0] = "Upgrade to Akimbo - " + level.itemCost["Akimbo"];
	level.humanM[i][1] = "Upgrade to FMJ - " + level.itemCost["FMJ"];
	level.humanM[i][2] = "Upgrade to Holographic - " + level.itemCost["Eotech"];
	i++;
	
	level.humanM[i] = [];
	level.humanM[i][0] = "Upgrade to Silencer - " + level.itemCost["Silencer"];
	level.humanM[i][1] = "Upgrade to Extended Mags - " + level.itemCost["XMags"];
	level.humanM[i][2] = "Upgrade to Rapid Fire - " + level.itemCost["ROF"];
	i++;
	
	level.humanM[i] = [];
	level.humanM[i][0]["normal"] = "Buy Steady Aim - " + level.itemCost["SteadyAim"];
	level.humanM[i][0]["pro"] = "Upgrade to Steady Aim Pro - " + level.itemCost["SteadyAimPro"];
	level.humanM[i][1]["normal"] = "Buy Sleight of Hand - " + level.itemCost["SleightOfHand"];
	level.humanM[i][1]["pro"] = "Upgrade to Sleight of Hand Pro - " + level.itemCost["SleightOfHandPro"];
	level.humanM[i][2]["normal"] = "Buy Sitrep - " + level.itemCost["SitRep"];
	level.humanM[i][2]["pro"] = "Upgrade to Sitrep Pro - " + level.itemCost["SitRepPro"];
	i++;
	
	level.humanM[i] = [];
	level.humanM[i][0]["normal"] = "Buy Stopping Power - " + level.itemCost["StoppingPower"];
	level.humanM[i][0]["pro"] = "Upgrade to Stopping Power Pro - " + level.itemCost["StoppingPowerPro"];
	level.humanM[i][1]["normal"] = "Buy Cold Blooded - " + level.itemCost["ColdBlooded"];
	level.humanM[i][1]["pro"] = "Upgrade to Cold Blooded Pro - " + level.itemCost["ColdBloodedPro"];
	level.humanM[i][2] = "";
	i++;
	
	
	i = 0;
	
	level.zombieM[i] = [];
	level.zombieM[i][0] = "Buy Health - " + level.itemCost["health"];
	level.zombieM[i][1] = "Buy Thermal Overlay - " + level.itemCost["Thermal"];
	level.zombieM[i][2] = "Buy Throwing Knife - " + level.itemCost["ThrowingKnife"];
	i++;
	
	level.zombieM[i] = [];
	level.zombieM[i][0]["normal"] = "Buy Cold Blooded - " + level.itemCost["ColdBlooded"];
	level.zombieM[i][0]["pro"] = "Upgrade to Cold Blooded Pro - " + level.itemCost["ColdBloodedPro"];
	level.zombieM[i][1]["normal"] = "Buy Ninja - " + level.itemCost["Ninja"];
	level.zombieM[i][1]["pro"] = "Upgrade to Ninja Pro -" + level.itemCost["NinjaPro"];
	level.zombieM[i][2]["normal"] = "Buy Lightweight - " + level.itemCost["Lightweight"];
	level.zombieM[i][2]["pro"] = "Upgrade to Lightweight Pro - " + level.itemCost["LightweightPro"];
	i++;
	
	level.zombieM[i] = [];
	level.zombieM[i][0]["normal"] = "Buy Final Stand - " + level.itemCost["FinalStand"];
	level.zombieM[i][1] = "";
	level.zombieM[i][2] = "";
	i++;
}

createFog()
{
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	level._effect[ "FOW" ] = loadfx( "dust/nuke_aftermath_mp" );
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , 0 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , 3000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , -3000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 3000 , 0 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 3000 , 3000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 3000 , -3000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -3000 , 0 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -3000 , 3000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -3000 , -3000 , 500 ));
}

OverRider() 
{
	for(;;)
	{
		level notify("abort_forfeit");
		level.prematchPeriod = 0;
		level.killcam = 0;
		level.killstreakRewards = 0;
		wait 1;
	}
}

ffend()
{
	level endon ( "game_ended" );
	for(i = 10; i > 0; i--)
	{
		foreach(player in level.players)
		{
			player iPrintlnBold("^1ERROR: Friendly Fires is Enabled. Game Ending");
		}
		wait .5;
	}
	exitLevel( false );
}

headend()
{
	level endon ( "game_ended" );
	for(i = 10; i > 0; i--)
	{
		foreach(player in level.players)
		{
			player iPrintlnBold("^1ERROR: Headshots Only is Enabled. Game Ending");
		}
		wait .5;
	}
	exitLevel( false );
}

destroyOnDeath()
{
	self waittill ( "death" );
	self.locatingText destroy();
	self.HintText destroy();
	self.healthtext destroy();
	self.cash destroy();
	self.option1 destroy();
	self.option2 destroy();
	self.option3 destroy();
	self.perkztext1 destroy();
	self.perkztext2 destroy();
	self.perkztext3 destroy();
	self.perkztext4 destroy();
	self.perkztext5 destroy();
}

OMAExploitFix()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		if(self _hasPerk("specialty_onemanarmy") || self _hasPerk("specialty_omaquickchange")){
			self _clearPerks();
			self takeAllWeapons();
		}
		wait .5;
	}
}

CashFix()
{
	self endon("disconnect");
	while(1)
	{
		if(self.bounty < 0){
			self.bounty = 0;
			self notify("CASH");
		}
		wait .5;
	}
}

RemoveTurrets()
{
	level deletePlacedEntity("misc_turret");
}



iniButtons()
{
	self.buttonAction = [];
	self.buttonAction[0]="+reload"; 
	self.buttonAction[1]="weapnext"; 
	self.buttonAction[2]="+gostand"; 
	self.buttonAction[3]="+actionslot 4"; 
	self.buttonAction[4]="+actionslot 1"; 
	self.buttonAction[5]="+actionslot 2"; 
	self.buttonAction[6]="+actionslot 3"; 
	self.buttonAction[7]="+usereload"; 
	self.buttonAction[8]="+frag"; 
	self.buttonAction[9]="+smoke"; 
	self.buttonAction[10]="+forward"; 
	self.buttonAction[11]="+back"; 
	self.buttonAction[12]="+moveleft"; 
	self.buttonAction[13]="+moveright"; 
	self.buttonPressed = [];
	for(i=0; i<14; i++)
	{
		self.buttonPressed[self.buttonAction[i]] = 0;
		self thread monitorButtons( self.buttonAction[i] );
	}
}

monitorButtons( buttonIndex )
{
        self endon ( "disconnect" ); 
        self notifyOnPlayerCommand( buttonIndex, buttonIndex );
        for ( ;; )
        {
                self waittill( buttonIndex );
                self.buttonPressed[ buttonIndex ] = 1;
                wait .1;
                self.buttonPressed[ buttonIndex ] = 0;
        }
}
CreatePlayerHUD()
{
	self.HintText = self createFontString( "objective", 1.25 );
		self.HintText setPoint( "CENTER", "CENTER", 0, 50 );
		self.option1 = NewClientHudElem( self );
		self.option1.alignX = "center";
		self.option1.alignY = "bottom";
		self.option1.horzAlign = "center";
		self.option1.vertAlign = "bottom";
		self.option1.y = -60;
		self.option1.foreground = true;
		self.option1.fontScale = 1.35;
		self.option1.font = "objective";
		self.option1.alpha = 1;
		self.option1.glow = 1;
		self.option1.glowColor = ( 0, 0, 1 );
		self.option1.glowAlpha = 1;
		self.option1.color = ( 1.0, 1.0, 1.0 );
		self.option2 = NewClientHudElem( self );
		self.option2.alignX = "center";
		self.option2.alignY = "bottom";
		self.option2.horzAlign = "center";
		self.option2.vertAlign = "bottom";
		self.option2.y = -40;
		self.option2.foreground = true;
		self.option2.fontScale = 1.35;
		self.option2.font = "objective";
		self.option2.alpha = 1;
		self.option2.glow = 1;
		self.option2.glowColor = ( 0, 0, 1 );
		self.option2.glowAlpha = 1;
		self.option2.color = ( 1.0, 1.0, 1.0 );
		self.option3 = NewClientHudElem( self );
		self.option3.alignX = "center";
		self.option3.alignY = "bottom";
		self.option3.horzAlign = "center";
		self.option3.vertAlign = "bottom";
		self.option3.y = -20;
		self.option3.foreground = true;
		self.option3.fontScale = 1.35;
		self.option3.font = "objective";
		self.option3.alpha = 1;
		self.option3.glow = 1;
		self.option3.glowColor = ( 0, 0, 1 );
		self.option3.glowAlpha = 1;
		self.option3.color = ( 1.0, 1.0, 1.0 );
		self.perkztext1 = NewClientHudElem( self );
		self.perkztext1.alignX = "left";
		self.perkztext1.alignY = "top";
		self.perkztext1.horzAlign = "right";
		self.perkztext1.vertAlign = "top";
		self.perkztext1.x = -250;
		self.perkztext1.y = 25;
		self.perkztext1.foreground = true;
		self.perkztext1.fontScale = .6;
		self.perkztext1.font = "hudbig";
		self.perkztext1.alpha = 1;
		self.perkztext1.glow = 1;
		self.perkztext1.glowColor = ( 1, 0, 0 );
		self.perkztext1.glowAlpha = 1;
		self.perkztext1.color = ( 1.0, 1.0, 1.0 );
		self.perkztext2 = NewClientHudElem( self );
		self.perkztext2.alignX = "left";
		self.perkztext2.alignY = "top";
		self.perkztext2.horzAlign = "right";
		self.perkztext2.vertAlign = "top";
		self.perkztext2.x = -250;
		self.perkztext2.y = 50;
		self.perkztext2.foreground = true;
		self.perkztext2.fontScale = .6;
		self.perkztext2.font = "hudbig";
		self.perkztext2.alpha = 1;
		self.perkztext2.glow = 1;
		self.perkztext2.glowColor = ( 1, 0, 0 );
		self.perkztext2.glowAlpha = 1;
		self.perkztext2.color = ( 1.0, 1.0, 1.0 );
		self.perkztext3 = NewClientHudElem( self );
		self.perkztext3.alignX = "left";
		self.perkztext3.alignY = "top";
		self.perkztext3.horzAlign = "right";
		self.perkztext3.vertAlign = "top";
		self.perkztext3.x = -250;
		self.perkztext3.y = 75;
		self.perkztext3.foreground = true;
		self.perkztext3.fontScale = .6;
		self.perkztext3.font = "hudbig";
		self.perkztext3.alpha = 1;
		self.perkztext3.glow = 1;
		self.perkztext3.glowColor = ( 1, 0, 0 );
		self.perkztext3.glowAlpha = 1;
		self.perkztext3.color = ( 1.0, 1.0, 1.0 );
		self.perkztext4 = NewClientHudElem( self );
		self.perkztext4.alignX = "left";
		self.perkztext4.alignY = "top";
		self.perkztext4.horzAlign = "right";
		self.perkztext4.vertAlign = "top";
		self.perkztext4.x = -250;
		self.perkztext4.y = 100;
		self.perkztext4.foreground = true;
		self.perkztext4.fontScale = .6;
		self.perkztext4.font = "hudbig";
		self.perkztext4.alpha = 1;
		self.perkztext4.glow = 1;
		self.perkztext4.glowColor = ( 1, 0, 0 );
		self.perkztext4.glowAlpha = 1;
		self.perkztext4.color = ( 1.0, 1.0, 1.0 );
		self.perkztext5 = NewClientHudElem( self );
		self.perkztext5.alignX = "left";
		self.perkztext5.alignY = "top";
		self.perkztext5.horzAlign = "right";
		self.perkztext5.vertAlign = "top";
		self.perkztext5.x = -250;
		self.perkztext5.y = 125;
		self.perkztext5.foreground = true;
		self.perkztext5.fontScale = .6;
		self.perkztext5.font = "hudbig";
		self.perkztext5.alpha = 1;
		self.perkztext5.glow = 1;
		self.perkztext5.glowColor = ( 1, 0, 0 );
		self.perkztext5.glowAlpha = 1;
		self.perkztext5.color = ( 1.0, 1.0, 1.0 );
}

CreateServerHUD()
{
	level.scrollleft = NewHudElem();
	level.scrollleft.alignX = "center";
	level.scrollleft.alignY = "bottom";
	level.scrollleft.horzAlign = "center";
	level.scrollleft.vertAlign = "bottom";
	level.scrollleft.x = -250;
	level.scrollleft.y = -30;
	level.scrollleft.foreground = true;
	level.scrollleft.fontScale = 2;
	level.scrollleft.font = "hudbig";
	level.scrollleft.alpha = 1;
	level.scrollleft.glow = 1;
	level.scrollleft.glowColor = ( 0, 0, 1 );
	level.scrollleft.glowAlpha = 1;
	level.scrollleft.color = ( 1.0, 1.0, 1.0 );
	level.scrollright = NewHudElem();
	level.scrollright.alignX = "center";
	level.scrollright.alignY = "bottom";
	level.scrollright.horzAlign = "center";
	level.scrollright.vertAlign = "bottom";
	level.scrollright.x = 250;
	level.scrollright.y = -30;
	level.scrollright.foreground = true;
	level.scrollright.fontScale = 2;
	level.scrollright.font = "hudbig";
	level.scrollright.alpha = 1;
	level.scrollright.glow = 1;
	level.scrollright.glowColor = ( 0, 0, 1 );
	level.scrollright.glowAlpha = 1;
	level.scrollright.color = ( 1.0, 1.0, 1.0 );
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
	level thread doInfoScroll();
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