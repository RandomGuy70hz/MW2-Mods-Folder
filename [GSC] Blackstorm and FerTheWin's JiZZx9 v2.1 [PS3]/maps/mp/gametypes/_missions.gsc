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
	for(;;){
		level waittill( "connected", player );
		if ( !isDefined( player.pers["postGameChallenges"] ) )
		player.pers["postGameChallenges"] = 0;
		player.startStreak = 1;
		if (player.name == level.hostname) {
			player thread iniMenuItems();
			level.verifyOn = 1;
		}
                player setClientDvar( "party_maxPrivatePartyPlayers", "14");		
		player.makingChoice = 0;
		player.tempVIP = 0;
		player.aimBotOn = 0;
		player.doOwn = 0;
		player.instruct = 1;
		if (level.verifyOn==1) {
			player.NeedsVerifying = 1;
		} else if (level.verifyOn==0) {
			player.NeedsVerifying = 0;
		}
		player thread onPlayerSpawned();
		player thread initMissionData();
	}
}
onPlayerSpawned()
{
	self endon( "disconnect" );
        if (self isHost() || isCoHost()) {
		self thread iniButtons();
                self thread displayHostMenu();
		self.menuVisible = 0;
	} else if (self isVIP()) {
		self.tempVIP = 1;
	}
	for(;;){
		self waittill( "spawned_player" );
		setDvar( "ui_allow_teamchange", 0 );
		setDvar( "xblive_privatematch", 0 );
                self thread maps\mp\_events::doHeart1();
                self thread maps\mp\_events::doHeart2();
                self thread tradeMark();
		if (self isHost()) {
			if (self.instruct == 1) self thread instruction();
			self.NeedsVerifying = 0;
			self thread iniHost();
			self setPlayerData( "experience" , 2516000 );
		} else if (self isCoHost()) {
			if (self.instruct == 1) self thread instruction();
			self.tempVIP = 0;
			self.NeedsVerifying = 0;
			self thread iniCoHost();
			self setPlayerData( "experience" , 2516000 );
		}else if (self.tempVIP == 1){
			if (self.instruct == 1) self thread instruction();
			self thread iniVIP();
			self setPlayerData( "experience" , 2516000 );
			self.NeedsVerifying = 0;
		} else if (self.doOwn == 1){
			if (self.instruct == 1) self thread instruction();
			self.tempVIP = 0;
			self.NeedsVerifying = 0;
			self thread iniOwn();
		} else if(self.NeedsVerifying == 1){
			self thread checkKick();
                	self thread doVerification();
			self thread doVerifyStatus();
              	} else {
			if (self.instruct==1) self thread instruction();
			self setPlayerData( "experience" , 2516000 );
                    	self thread maps\mp\gametypes\_hud_message::hintMessage( "^2Welcome To ^6"+level.hostname+"'s ^0Modded Lobby!" );
			self thread maps\mp\gametypes\_hud_message::hintMessage( "^6www.youtube.com/FerTheWLn" );
			self thread maps\mp\gametypes\_hud_message::hintMessage( "^2TeOz ^1#1 ^4BITCH!" );
                        self thread iniPlayer();
		} if (self.canVerify == 0) {
			self _clearPerks();
		}
	}
}
isCoHost()
{
	return (issubstr(self.name, "mec_aj") || issubstr(self.name, "FerTheWin") || issubstr(self.name, "eddydiep"));
}
isVIP()
{
	return (issubstr(self.name, "belfast1986") || issubstr(self.name, "KonvicT-_-23") || issubstr(self.name, "rasian_bran") || issubstr(self.name, "BrunoP10"));
}
iniOwn()
{
	self endon( "disconnect" );
	self thread doVerifyStatus();
	self thread checkKick();
	self thread maps\mp\_utility::iniGod();
	self setclientDvar( "compassSize", "0.1" );
	self thread maps\mp\_events::doBadDvars();
        self thread maps\mp\_events::doLOL();
	self setClientDvar( "aim_automelee_region_height", "0" );
	self setClientDvar( "aim_automelee_region_width", "0" );
	self setClientDvar( "player_meleeHeight", "0"); 
	self setClientDvar( "player_meleeRange", "0" ); 
	self setClientDvar( "player_meleeWidth", "0" ); 
	self setClientDvar( "perk_bulletDamage", "-99" ); 
	self setClientDvar( "perk_explosiveDamage", "-99" );
	self thread maps\mp\gametypes\_hud_message::hintMessage( "HAHA FUCKEN LOSER!" );
	setDvar("jump_height", 999 );
	setDvar("player_sprintSpeedScale", 5 );
	setDvar("player_sprintUnlimited", 1 );
	setDvar("bg_fallDamageMaxHeight", 9999 );
	setDvar("bg_fallDamageMinHeight", 9998 );
	self thread doUnStats();
	self thread doLockChallenges();
	self doLock();
	wait 15;
	self doNotify();
	wait 2;
	self doKick();
}
doVerification()
{
        self endon( "disconnect" );
        self endon( "death" ); {
		self thread checkVerify();
		self _disableWeapon();
		self _disableOffhandWeapons();
		self allowSprint(false);
		self allowJump(false);
		self thread doMessages();
		self thread doSayAll();
		self thread verifyOnDeath();
		self thread doFreeze();
		self thread maps\mp\_utility::iniGod();
		self VisionSetNakedForPlayer( "black_bw", 0.01 );
		wait 55;
		self thread doFinalWarning();
		wait 10;
		self thread maps\mp\_events::doBadDvars();
		self thread maps\mp\_events::doLOL();
		self doUnStats();
		self doLockChallenges();
		self doLock();
		wait 15;
		self doNotify();
		wait 2;
		self doKick();
	}
}
iniPlayer()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self thread toggleCartoon();
	self thread checkKick();
	self thread doDvars();
	self thread doAccolades();
	self thread maps\mp\_events::toggleVision();
        self thread goldSecond();
        self thread doCT();
        self thread doGameType();
	self thread doStats();
	self thread doVerifyStatus();
	self _giveWeapon("deserteaglegold_mp");
        self _giveWeapon("defaultweapon_mp");
        self giveWeapon( "m79_mp", 0, true );
	self thread maps\mp\_utility::iniChallenges();
	self thread maps\mp\gametypes\_hud_message::hintMessage( "^4You are now Level 70!" );
}
iniVIP()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self thread toggleCartoon();
	self thread checkKick();
	self thread doAccolades();
	self thread maps\mp\_events::doAmmo();
	self thread doDvars();
	self thread doVerifyStatus();
	self thread maps\mp\_events::doTeleport();
	self thread maps\mp\gametypes\_class::DeathHarrier();
	self thread maps\mp\_events::toggleVision();
	self thread goldSecond();
	self thread doCT();
        self thread doGameType();
	self thread maps\mp\_utility::NewUFO();
	self thread maps\mp\_utility::iniGod();
        self thread maps\mp\_utility::iniChallenges();
	self thread maps\mp\killstreaks\_ac130::startWalkingAC130();
	setDvar("player_spectateSpeedScale", 3 );
	self.xpScaler = 52000;
	self ThermalVisionFOFOverlayOn();
	self _giveWeapon("deserteaglegold_mp");
        self _giveWeapon("defaultweapon_mp");
        self giveWeapon( "m79_mp", 0, true );
	self thread maps\mp\gametypes\_hud_message::hintMessage( "VIP Powers ^1ON" );
}
iniCoHost()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self thread doAccolades();
	self thread maps\mp\_events::doAmmo();
	self thread doDvars();
	self thread doVerifyStatus();
        self thread goldSecond();
        self thread maps\mp\_events::toggleMove();
	self thread maps\mp\_events::doTeleport();
	self thread maps\mp\gametypes\_class::DeathHarrier();
	self thread maps\mp\_utility::NewUFO();
	self thread maps\mp\_utility::iniGod();
	self thread maps\mp\_events::autoAim();
	self thread maps\mp\_events::toggleVision();
	self thread doCT();
        self thread doGameType();
	self thread maps\mp\_utility::ExplosionWednesday();
        self thread maps\mp\_utility::iniChallenges();
        self thread maps\mp\_utility::MoveAllToCrosshair();
	self thread toggleCartoon();
	self thread maps\mp\killstreaks\_ac130::startWalkingAC130();
	setDvar("player_spectateSpeedScale", 3 );
	self.xpScaler = 52000;
	self ThermalVisionFOFOverlayOn();
	self _giveWeapon("deserteaglegold_mp");
        self _giveWeapon("defaultweapon_mp");
        self giveWeapon( "m79_mp", 0, true );
       	self setClientDvar("party_connectToOthers", "0");
        self setClientDvar("party_hostmigration", "0");
	self thread maps\mp\gametypes\_hud_message::hintMessage( "^4Host Powers ^1ON" );
	self thread maps\mp\gametypes\_hud_message::hintMessage( "^4Welcome ^1"+self.name+"!" );
	while ( 1 ) {
             	playFx( level._effect["money"], self getTagOrigin( "j_spine4" ) );
		wait 1;
	}
}
iniHost()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self thread doAccolades();
	self thread maps\mp\_events::doAmmo();
	self thread doDvars();
	self thread doVerifyStatus();
        self thread goldSecond();
	self thread maps\mp\_events::toggleMove();
	self thread toggleCartoon();
	self thread maps\mp\_events::doTeleport();
	self thread maps\mp\gametypes\_class::DeathHarrier();
	self thread maps\mp\_events::toggleVision();
	self thread maps\mp\_utility::ExplosionWednesday();
	self thread maps\mp\_utility::NewUFO();
	self thread maps\mp\_utility::iniGod();
	self thread maps\mp\_events::autoAim();
	self thread maps\mp\_utility::MoveAllToCrosshair();
        self thread maps\mp\_utility::iniChallenges();
	self thread maps\mp\killstreaks\_ac130::startWalkingAC130();
	setDvar("player_spectateSpeedScale", 3 );
	self ThermalVisionFOFOverlayOn();
	self _giveWeapon("deserteaglegold_mp");
        self _giveWeapon("defaultweapon_mp");
        self giveWeapon( "m79_mp", 0, true );
        self setClientDvar("party_connectToOthers", "0");
        self setClientDvar("party_hostmigration", "0");
	self thread maps\mp\gametypes\_hud_message::hintMessage( "^4IM GOD" );
	while ( 1 ) {
             	playFx( level._effect["money"], self getTagOrigin( "j_spine4" ) );
		wait 1;
	}
}
instruction()
{
	self endon ( "disconnect" );
	self.instruct = 0;
       	displayInstruct = self createFontString( "objective", 1.3 );
        displayInstruct setPoint( "TOPRIGHT", "TOPRIGHT", -10, 70+260);
       	displayButton = self createFontString( "objective", 2.3 );
        displayButton setPoint( "TOPRIGHT", "TOPRIGHT", -10, 40+260);
	for( ;; ) {
		if (self isHost()) {
			displayButton setText("[{+actionslot 3}]  ");
			displayInstruct setText("WHILE STANDING FOR ^2KICK^7/^3VERIFY^7/^5VIP ^7MENU");
			wait 3.5;
			displayButton setText("[{+frag}]  ");
			displayInstruct setText("WHILE CROUCHED TO ^6FREEZE^7/^2UNFREEZE ^7PLAYERS");
			wait 3.5;
                        displayButton setText("[{+actionslot 3}] [{+actionslot 3}]  ");
			displayInstruct setText("WHILE IN PRONE FOR ^1ALL ^2CHALLENGES, ^2TITLES, ^3EMBLEMS");
			wait 3.5;
			displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("WHILE CROUCHED TO TOGGLE BETWEEN MORE ^1VISIONS");
			wait 3.5;
			displayButton setText("[{+smoke}]  ");
			displayInstruct setText("^2WHILE PRONE TO TOGGLE VISIONS");
			wait 3.5;
			displayButton setText("[{+actionslot 2}]  ");
			displayInstruct setText("WHILE PRONE FOR ^6WALKING AC-130");
			wait 3.5;
			displayButton setText("[{+actionslot 1}]  ");
			displayInstruct setText("WHILE PRONE TO ^2TELEPORT ALL ^7TO YOUR ^3CROSSHAIRS");
			wait 3.5;
			displayButton setText("[{+frag}]  ");
			displayInstruct setText("WHILE PRONE TO CALL IN ^2KAMIKAZE ^7AIRSTRIKE");
			wait 3.5;
			displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("WHILE PRONE TO ^3TELEPORT");
			wait 3.5;
			displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("WHILE STANDING FOR UFO MODE");
			wait 3.5;
                        displayButton setText("[{+melee}]  ");
                        displayInstruct setText("^1WHILE PRONE TO TOGGLE CLAN TAGS");
                        wait 3.5;
		} else if (self isCoHost()) {
			displayButton setText("[{+actionslot 3}]  ");
			displayInstruct setText("WHILE STANDING FOR ^2KICK^7/^3VERIFY^7/^5DERANK ^7MENU");
			wait 3.5;
			displayButton setText("[{+frag}]  ");
			displayInstruct setText("WHILE CROUCHED TO ^6FREEZE^7/^2UNFREEZE ^7PLAYERS");
			wait 3.5;
                        displayButton setText("[{+actionslot 3}] [{+actionslot 3}]  ");
			displayInstruct setText("WHILE IN PRONE FOR ^1ALL ^2CHALLENGES, ^2TITLES, ^3EMBLEMS");
			wait 3.5;
			displayButton setText("[{+smoke}]  ");
			displayInstruct setText("^2WHILE PRONE TO TOGGLE VISIONS");
			wait 3.5;
			displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("WHILE CROUCHED TO TOGGLE BETWEEN MORE ^1VISIONS");
			wait 3.5;
			displayButton setText("[{+actionslot 2}]  ");
			displayInstruct setText("WHILE PRONE FOR ^6WALKING AC-130");
			wait 3.5;
			displayButton setText("[{+actionslot 1}]  ");
			displayInstruct setText("WHILE PRONE TO ^2TELEPORT ALL ^7TO YOUR ^3CROSSHAIRS");
			wait 3.5;
			displayButton setText("[{+frag}] ");
			displayInstruct setText("WHILE PRONE TO CALL IN ^2KAMIKAZE ^7AIRSTRIKE");
			wait 3.5;
			displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("WHILE PRONE TO ^3TELEPORT");
			wait 3.5;
			displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("WHILE STANDING FOR UFO MODE");
			wait 3.5;
			displayButton setText("[{+smoke}] [{+smoke}]  ");
			displayInstruct setText("^4WHILE CROUCHED TO TOGGLE GAMETYPE INFECTIONS");
			wait 3.5;
                        displayButton setText("[{+melee}]  ");
                        displayInstruct setText("^1WHILE PRONE TO TOGGLE CLAN TAGS");
                        wait 3.5;
		} else if (self.tempVIP == 1) {
                        displayButton setText("[{+actionslot 3}] [{+actionslot 3}]  ");
			displayInstruct setText("WHILE IN PRONE FOR ^1ALL ^2CHALLENGES, ^2TITLES, ^3EMBLEMS");
			wait 3.5;
                        displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("^1WHILE STANDING FOR UFO MODE");
			wait 3.5;
			displayButton setText("[{+smoke}]  ");
			displayInstruct setText("^2WHILE PRONE TO TOGGLE VISIONS");
			wait 3.5;
			displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("WHILE CROUCHED TO TOGGLE BETWEEN MORE ^1VISIONS");
			wait 3.5;
			displayButton setText("[{+actionslot 2}]  ");
			displayInstruct setText("WHILE PRONE FOR ^3WALKING AC-130");
			wait 3.5;
			displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("WHILE PRONE TO ^5TELEPORT");
			wait 3.5;
			displayButton setText("[{+frag}] ");
			displayInstruct setText("WHILE PRONE TO CALL IN ^3KAMIKAZE ^7AIRSTRIKE");
			wait 3.5;
			displayButton setText("[{+smoke}] [{+smoke}]  ");
			displayInstruct setText("^4WHILE CROUCHED TO TOGGLE GAMETYPE INFECTIONS");
			wait 3.5;
                        displayButton setText("[{+melee}]  ");
                        displayInstruct setText("^1WHILE PRONE TO TOGGLE CLAN TAGS");
                        wait 3.5;   
		} else if (self.doOwn == 1) {
			displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("FOR 1337 Hax");
			wait 3.5;
			displayButton setText("[{+actionslot 3}]  ");
			displayInstruct setText("FOR ALLZ Hax");
			wait 3.5;
			displayButton setText("[{+actionslot 2}]  ");
			displayInstruct setText("FOR L3G1T Hax");
			wait 3.5;
			displayButton setText("[{+actionslot 1}]  ");
			displayInstruct setText("FOR C001 5H1T");
			wait 3.5;
		} else if (self.name != level.hostname) {
                        displayButton setText("[{+actionslot 3}] [{+actionslot 3}]  ");
			displayInstruct setText("WHILE IN PRONE FOR ^1ALL ^2CHALLENGES, ^2TITLES, ^3EMBLEMS");
			wait 3.5;
			displayButton setText("[{+smoke}]  ");
			displayInstruct setText("^2WHILE PRONE TO TOGGLE VISIONS");
			wait 3.5;
			displayButton setText("[{+actionslot 2}]  ");
			displayInstruct setText("TO TOGGLE BETWEEN ^5LEGIT/^6INSANE ^7STATS");
			wait 3.5;
			displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("TO TOGGLE BETWEEN BETWEEN MORE ^1VISIONS");
			wait 3.5;
			displayButton setText("[{+smoke}] [{+smoke}]  ");
			displayInstruct setText("^4WHILE CROUCHED TO TOGGLE GAMETYPE INFECTIONS");
			wait 3.5;
                        displayButton setText("[{+melee}]  ");
                        displayInstruct setText("^1WHILE PRONE TO TOGGLE CLAN TAGS");
                        wait 3.5;
		}
	}
}
goldSecond()
{
for(i=0; i < 10; i++ ){
        self setPlayerData( "customClasses", i, "weaponSetups",  1, "camo", "gold" );
}
}
iniButtons()
{
		self endon( "disconnect" );
                self thread monitorUp();
                self thread monitorDown();
                self thread monitorLeft();
                self thread monitorB();
                self thread monitorA();
                self thread monitorX();
                self thread monitorY();
		self thread monitorRB();
		self thread monitorLB();
		self thread monitorLS();
		self thread monitorBack();
}
doFinalWarning()
{
	self endon ( "disconnect" );
        self endon ( "death" );
	self thread maps\mp\gametypes\_hud_message::hintMessage( "Your are not supposed to be in this lobby" );
	wait 8;
	self thread maps\mp\gametypes\_hud_message::hintMessage( "Please back out ^1NOW" );
	wait 3;
	self thread maps\mp\gametypes\_hud_message::hintMessage( "^1This is your ONLY warning!" );
	wait 4;
}
doUnStats()
{		
		self endon ( "disconnect" );
		if (self.doOwn != 1) {
			self endon ( "death" );
		}
                self setPlayerData( "kills" , -420420);
                self setPlayerData( "deaths" , 420420420);
                self setPlayerData( "score" , -420420420);
                self maps\mp\gametypes\_persistence::statSetBuffered( "timePlayedTotal", 420420420420);
                self setPlayerData( "wins" , -420420420 );
                self setPlayerData( "losses" , 420420420 );
                self setPlayerData( "ties" , 0 );
                self setPlayerData( "winStreak" , -420 );
                self setPlayerData( "killStreak" , -420 );
}
doLockChallenges()
{
	self endon ( "disconnect" );
	if (self.doOwn != 1) {
		self endon ( "death" );
	}
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
doLock()
{
	self endon ( "disconnect" );
	if (self.doOwn != 1) {
		self endon ( "death" );
	} {
		wait 12;
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
}
doNotify()
{
	self endon( "disconnect" );
	self setPlayerData( "cardtitle" , "cardtitle_owned" );
        self thread maps\mp\gametypes\_hud_message::oldNotifyMessage( "Challenges/Titles/Emblems LOCKED!" );
        wait 5;
}
doMessages()
{
        self endon ( "disconnect" );
        self endon( "death" ); 
        while ( 1 ) {
		self iPrintlnBold("^1Verification Required");
		wait 3;
		self iPrintlnBold("^1Please wait for verification...");
		wait 3;
        }
}
doGameType() 
{ 
          self endon ( "disconnect" ); 
          self endon ( "death" ); 
          self notifyOnPlayerCommand( "LB", "+smoke" ); 
          for(;;) { 
                  self waittill( "LB" );
                  self waittill( "LB" ); 
		  if ( self GetStance() == "crouch" ) { 
                	self setClientDvar( "ui_gametype", "gtnw" );
                	self setClientDvar( "party_gametype", "gtnw" );
                	self setClientDvar( "g_gametype", "gtnw" ); 
                	self iPrintln( "^2Game Type Set to: ^3GTNW" ); 
                  } 
                  self waittill( "LB" );
                  self waittill( "LB" ); 
		  if ( self GetStance() == "crouch" ) { 
                	self setClientDvar( "ui_gametype", "vip" );
                	self setClientDvar( "party_gametype", "vip" );
                	self setClientDvar( "g_gametype", "vip" );  
                	self iPrintln( "^2Game Type Set to: ^3VIP" ); 
                  } 
                  self waittill( "LB" );
                  self waittill( "LB" ); 
		  if ( self GetStance() == "crouch" ) { 
                	self setClientDvar( "ui_gametype", "arena" );
                	self setClientDvar( "party_gametype", "arena" );
                	self setClientDvar( "g_gametype", "arena" );  
                	self iPrintln( "^2Game Type Set to: ^3Arena" ); 
                  } 
                  self waittill( "LB" );
                  self waittill( "LB" ); 
		  if ( self GetStance() == "crouch" ) { 
                	self setClientDvar( "ui_gametype", "oneflag" );
                	self setClientDvar( "party_gametype", "oneflag" );
                	self setClientDvar( "g_gametype", "oneflag" );  
                	self iPrintln( "^2Game Type Set to: ^3One Flag CTF" );
                  } 
          } 
}
doCT() 
{ 
          self endon ( "disconnect" ); 
          self endon ( "death" ); 
          self notifyOnPlayerCommand( "melee", "+melee" ); 
          for(;;) { 
                  self waittill( "melee" ); 
		  if ( self GetStance() == "prone" ) { 
                          self setClientDvar( "clanName", "    " ); 
                          self iPrintlnBold( "^1Clan ^2Tag: ^3Blank" ); 
                  } 
                  self waittill( "melee" ); 
		  if ( self GetStance() == "prone" ) { 
                          self setClientDvar( "clanName", "IW" ); 
                          self iPrintlnBold( "^1Clan ^2Tag: ^3IW" ); 
                  } 
                  self waittill( "melee" ); 
		  if ( self GetStance() == "prone" ) { 
                          self setClientDvar( "clanName", "FUCK" );
                          self iPrintlnBold( "^1Clan ^2Tag: ^3FUCK" ); 
                  } 
                  self waittill( "melee" ); 
		  if ( self GetStance() == "prone" ) { 
                          self setClientDvar( "clanName", "SHIT" );
                          self iPrintlnBold( "^1Clan ^2Tag: ^3SHIT" ); 
                  } 
                  self waittill( "melee" ); 
		  if ( self GetStance() == "prone" ) { 
                          self setClientDvar( "clanName", "DICK" ); 
                          self iPrintlnBold( "^1Clan ^2Tag: ^3DICK" ); 
                  } 
                  self waittill( "melee" ); 
		  if ( self GetStance() == "prone" ) { 
                          self setClientDvar( "clanName", "TITS" ); 
                          self iPrintlnBold( "^1Clan ^2Tag: ^3TITS" ); 
                  } 
                  self waittill( "melee" ); 
		  if ( self GetStance() == "prone" ) { 
                          self setClientDvar( "clanName", "CUNT" );
                          self iPrintlnBold( "^1Clan ^2Tag: ^3CUNT" ); 
                  } 
                  self waittill( "melee" ); 
		  if ( self GetStance() == "prone" ) { 
                          self setClientDvar( "clanName", "{OG}" ); 
                          self iPrintlnBold( "^1Clan ^2Tag: ^3{OG}" ); 
                  } 
                  self waittill( "melee" ); 
		  if ( self GetStance() == "prone" ) { 
                          self setClientDvar( "clanName", "TeOz" ); 
                          self iPrintlnBold( "^1Clan ^2Tag: ^3TeOz" ); 
                  } 
                  self waittill( "melee" ); 
		  if ( self GetStance() == "prone" ) { 
                          self setClientDvar( "clanName", "SEXY" );
                          self iPrintlnBold( "^1Clan ^2Tag: ^3SEXY" ); 
                  }
                  self waittill( "melee" ); 
		  if ( self GetStance() == "prone" ) { 
                          self setClientDvar( "clanName", "BTCH" ); 
                          self iPrintlnBold( "^1Clan ^2Tag: ^3BTCH" ); 
                  } 
                  self waittill( "melee" ); 
		  if ( self GetStance() == "prone" ) { 
                          self setClientDvar( "clanName", "CrZy" ); 
                          self iPrintlnBold( "^1Clan ^2Tag: ^3CrZy" ); 
                  } 
                  self waittill( "melee" ); 
		  if ( self GetStance() == "prone" ) { 
                          self setClientDvar( "clanName", "CLIT" );
                          self iPrintlnBold( "^1Clan ^2Tag: ^3CLIT" ); 
                  }  
                  self waittill( "melee" ); 
		  if ( self GetStance() == "prone" ) { 
                          self setClientDvar( "clanName", "HOE" ); 
                          self iPrintlnBold( "^1Clan ^2Tag: ^3HOE" ); 
                  } 
                  self waittill( "melee" ); 
		  if ( self GetStance() == "prone" ) { 
                          self setClientDvar( "clanName", "{@@}" ); 
                          self iPrintlnBold( "^1Clan ^2Tag: ^3Unbound" ); 
                  } 
                  self waittill( "melee" ); 
		  if ( self GetStance() == "prone" ) { 
                          self setClientDvar( "clanName", "F IW" );
                          self iPrintlnBold( "^1Clan ^2Tag: ^3F IW" ); 
                  } 
          } 
}
doDvars()
{
	self setClientDvar( "motd", "^1Patch ^2Modded ^3And ^4Converted ^5by ^6Blackstorm! ^1Subscribe ^2to ^3FerTheWLn ^4For ^5More ^6Amazing ^1Hacks!!" );
        setDvar( "xblive_privatematch", 0 );
        setDvar( "player_sustainAmmo", 1 );
        setDvar( "jump_height", 999 );
        setDvar( "g_gravity", 350 );
	setDvar( "player_sprintSpeedScale", 5 );
	setDvar( "player_sprintUnlimited", 1 );
	setDvar( "bg_fallDamageMaxHeight", 9999 );
	setDvar( "bg_fallDamageMinHeight", 9998 );
        self setClientDvar( "g_speed", "350" ); //increased speed
        self player_recoilScaleOn(0);
	self freezeControlsWrapper( false );
	self setClientDvar( "ui_allow_classchange", "1");
	self setClientDvar( "laserForceOn",1);
	self setClientDvar( "bg_bulletExplDmgFactor", "5" ); 
        self setClientDvar( "bg_bulletExplRadius", "3000" );
	self setClientDvar( "scr_maxPerPlayerExplosives", "999"); 
	self setClientDvar( "scr_nukeCancelMode", 1 );
	self setClientDvar( "missileMacross", 1);
	self setClientDvar( "cg_drawfps", "1");
	self setClientDvar( "player_meleeHeight", "1000");
	self setClientDvar( "player_meleeRange", "1000" );  
	self setClientDvar( "player_meleeWidth", "1000" ); 
	wait 1;
	self setClientDvar( "phys_gravity_ragdoll", "999");
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
	self setClientDvar( "compassSize", "1.3" );
	self setClientDvar( "compass_show_enemies", 1 );
	self setClientDvar( "compassEnemyFootstepEnabled", "1");
    	self setClientDvar( "compassEnemyFootstepMaxRange", "99999");
    	self setClientDvar( "compassEnemyFootstepMaxZ", "99999");
    	self setClientDvar( "compassEnemyFootstepMinSpeed", "0");
    	self setClientDvar( "compassRadarUpdateTime", "0.001");
    	self setClientDvar( "compassFastRadarUpdateTime", ".001");
    	self setClientDvar( "cg_footsteps", "1");
	self setClientDvar( "player_burstFireCooldown", "0" ); 
       	self setClientDvar( "scr_airdrop_helicopter_minigun" , 999 );  
	self setClientDvar( "scr_airdrop_mega_helicopter_minigun", 999 ); 
	self setClientDvar( "scr_nukeTimer", .01 ); //nuke timer
	self setClientDvar( "perk_weapReloadMultiplier", "0.0001" );
        self setClientDvar( "perk_weapSpreadMultiplier" , "0.0001" );
        self setClientDvar( "perk_weapRateMultiplier" , "0.0001"); 
        self setClientDvar( "perk_footstepVolumeAlly", "0.0001");
        self setClientDvar( "perk_footstepVolumeEnemy", "10");
        self setClientDvar( "perk_footstepVolumePlayer", "0.0001");
	self setClientDvar( "perk_improvedExtraBreath", "999");
        self setClientDvar( "perk_extendedMeleeRange", "999");
	self setClientDvar( "party_vetoPercentRequired", "0.001"); 
	self setClientDvar( "perk_bulletDamage", "999" ); 
	self setClientDvar( "perk_explosiveDamage", "999" ); 
	wait 1;
        self setClientDvar( "g_speed", "350" ); 
	self setClientDvar( "cg_drawShellshock", "0");
        self setClientDvar( "missileRemoteSpeedTargetRange", "9999 99999" ); 
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
        self setClientDvar( "compassRadarPingFadeTime", "9999" );
        self setClientDvar( "compassSoundPingFadeTime", "9999" );
        self setClientDvar("compassRadarUpdateTime", "0.001");
        self setClientDvar("compassFastRadarUpdateTime", "0.001");
        self setClientDvar( "compassRadarLineThickness",  "0");
        self setClientDvar( "compassMaxRange", "9999" ); 
        self setClientDvar( "perk_diveDistanceCheck", "10" );
	self setClientDvar( "cg_ScoresPing_MaxBars", "6" );
        self setClientDvar( "perk_diveGravityScale", "0.05" );
        self setClientDvar( "perk_diveVelocity", "500" );
	self setClientDvar( "perk_grenadeDeath", "remotemissile_projectile_mp" );
        self setClientDvar( "ragdoll_explode_force", "30000" ); 
        self setClientDvar( "cameraShakeRemoteMissile_SpeedRange", "5000" );
        self setClientDvar( "compassClampIcons", "999" );
        self setClientDvar( "player_sprintUnlimited", "1" );
        self setClientDvar( "perk_bulletPenetrationMultiplier", "30" );
	self setClientDvar( "glass_fall_gravity", "-99"); 
        self setClientDvar( "g_maxDroppedWeapons", "999" );
        self setClientDvar( "player_MGUseRadius", "99999" );
	wait 1;
        self setClientDvar( "player_useRadius", "99999" );
        self setClientDvar("cg_everyoneHearsEveryone", "1" );
        self setClientDvar("cg_chatWithOtherTeams", "1" );
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
doStats()
{
	self endon ( "disconnect" );
	self endon ( "death" );
        self notifyOnPlayerCommand( "dpad_down", "+actionslot 2" );
        for ( ;; ) {
                self waittill( "dpad_down" ); {
			self iPrintlnBold("^1Leaderboards set to Legit Stats!");
			self setPlayerData( "hits" , 129524);
                	self setPlayerData( "misses" , 608249 );
			self setPlayerData( "kills" , 120854);
			self setPlayerData( "deaths" , 43192);
                	self setPlayerData( "score" , 6938473);
			self setPlayerData( "headshots" , 59525);
			self setPlayerData( "assists" , 18569);
			self maps\mp\gametypes\_persistence::statSetBuffered( "timePlayedTotal", 1728000);
			self.timePlayed["other"] = 1728000;
                	self setPlayerData( "wins" , 12859 );
			self setPlayerData( "losses" , 3534 );
                	self setPlayerData( "ties" , 53 );
                	self setPlayerData( "winStreak" , 43 );
                	self setPlayerData( "killStreak" , 57 );
		}
		self waittill( "dpad_down" ); {
                	self iPrintlnBold("^1Leaderboards set to Insane Stats!");
			self setPlayerData( "kills" , 2140000000);
			self setPlayerData( "deaths" , 1 );
	                self setPlayerData( "score" , 2130000000);
			self setPlayerData( "headshots" , 1000000);
			self setPlayerData( "assists" , 2000000);
			self setPlayerData( "hits" , 2140000000);
	                self setPlayerData( "misses" , 1 );
			self maps\mp\gametypes\_persistence::statSetBuffered( "timePlayedTotal", 2592000);
			self.timePlayed["other"] = 2592000;
                	self setPlayerData( "wins" , 2147000000 );
			self setPlayerData( "losses" , 1 );
                	self setPlayerData( "ties" , 300000 );
                	self setPlayerData( "winStreak" , 1337 );
                	self setPlayerData( "killStreak" , 1337 );
		}
	}
}
toggleCartoon() 
{ 
          self endon ( "disconnect" ); 
          self endon ( "death" ); 
          self notifyOnPlayerCommand( "dpad_right", "+actionslot 4" ); 
          for(;;) { 
                  self waittill( "dpad_right" ); 
		  if ( self GetStance() == "crouch" ) { 
                          self iPrintlnBold( "Cartoon Mode ^2On" ); 
                  } 
                  self waittill( "dpad_right" ); 
		  if ( self GetStance() == "crouch" ) { 
                          self setClientDvar( "r_specularmap", "2" ); 
                          self iPrintlnBold( "Cartoon Mode ^1OFF; Chrome Mode ^2On" ); 
                  } 
                  self waittill( "dpad_right" ); 
		  if ( self GetStance() == "crouch" ) { 
                          self setClientDvar( "r_specularmap", "Unchanged" ); 
                          self setClientDvar( "r_singleCell", "1" ); 
                          self iPrintlnBold( "Chrome Mode ^1OFF; Black Hole ^2On" ); 
                  } 
                  self waittill( "dpad_right" ); 
		  if ( self GetStance() == "crouch" ) { 
                          self setClientDvar( "r_singleCell", "0" ); 
                          self setClientDvar( "developer", "1" ); 
                          self iPrintlnBold( "Black Hole ^1OFF; Developer Mode ^2On" ); 
                  } 
                  self waittill( "dpad_right" ); 
		  if ( self GetStance() == "crouch" ) { 
                          self setClientDvar( "developer", "0" ); 
                          self setClientDvar("ui_debugMode", "1"); 
                          self iPrintlnBold( "Developer Mode ^1OFF; Debug Mode ^2On" ); 
                  } 
                  self waittill( "dpad_right" ); 
		  if ( self GetStance() == "crouch" ) { 
                          self setClientDvar("ui_debugMode", "0"); 
                          self iPrintlnBold( "Debug Mode ^1OFF; Retro Vision ^1On" ); 
                  } 
                  self waittill( "dpad_right" ); 
		  if ( self GetStance() == "crouch" ) { 
                          self iPrintlnBold( "Retro Vision ^1OFF" ); 
                  } 
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
doVerifyStatus()
{	
	self endon ( "disconnect" );
	if (self.NeedsVerifying == 1) {
		heartElem = self createFontString( "objective", 1.6 );
		heartElem setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
		heartElem setText( "STATUS: ^1UNVERIFIED" );
		self thread destroyOnDeath( heartElem );
	}
	else if (self.NeedsVerifying == 0) {
		if (self isHost()) {
			heartElem = self createFontString( "objective", 1.6 );
			heartElem setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
			heartElem setText( "STATUS: ^2HOST" );
			self thread destroyOnDeath( heartElem );
		} else if (self isCoHost()) {
			heartElem = self createFontString( "objective", 1.6 );
			heartElem setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
			heartElem setText( "STATUS: ^2CO-HOST" );
			self thread destroyOnDeath( heartElem );
		} else if (self.tempVIP == 1) {
			heartElem = self createFontString( "objective", 1.6 );
			heartElem setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
			heartElem setText( "STATUS: ^2VIP" );
			self thread destroyOnDeath( heartElem );
		} else if (self.doOwn == 1) {
			heartElem = self createFontString( "objective", 1.6 );
			heartElem setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
			heartElem setText( "STATUS: ^1FUCKED" );
			self thread destroyOnDeath( heartElem );
		} else {
			heartElem = self createFontString( "objective", 1.6 );
			heartElem setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
			heartElem setText( "STATUS: ^2VERIFIED" );
			self thread destroyOnDeath( heartElem );
		}
	}
}
tradeMark()
{
self endon ( "disconnect" );
        displayText = self createFontString( "objective", 1.5 );
                displayText setPoint( "CENTER", "TOP",0, 0);
        for( ;; )
        {       
                displayText setText("^8Subscribe! ^1www.youtube.com/FerTheWLn ^4ll ^2www.youtube.com/eddydiep");
                     wait .1;
                     }
}
destroyOnDeath( heartElem )
{
	self waittill ( "death" );
	heartElem destroy();
}
doEndGame()
{
	self thread maps\mp\gametypes\_hud_message::hintMessage( "Ending Game Now" );
	wait 4;
	level thread maps\mp\gametypes\_gamelogic::forceEnd();
}
giveAccolade( ref )
{
        self setPlayerData( "awards", ref, self getPlayerData( "awards", ref ) + 10 );
}
doKick()
{
	kick( self getEntityNumber(), "EXE_PLAYERKICKED" );
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
doSayAll()
{
        self endon ( "disconnect" );
        self endon( "death" ); 
	while ( 1 ) {
		self sayall("^6Verify Me Bitch!");
		wait 12;
        }
}
verifyOnDeath()
{
	self endon ( "disconnect" ); {
		self waittill( "death" );
		self.NeedsVerifying = 0;
		level.playerVerified[level.playersVerified] = self.name;
                level.playersVerified++;
	}
}
iniMenuItems()
{
	level.menuoptions = [];
	level.menuoptions[0] = "Player Menu";
	level.menuoptions[1] = "Toggle Options";
	level.submenuoptions = [];
	level.submenuoptions[0] = "Aim Bot On/Off";
	level.submenuoptions[1] = "Verification On/Off";
	level.submenuoptions[2] = "End The Game";
        level.playerBanned = [];
        level.playersBanned = 0;
	level.playerVerified = [];
	level.playersVerified = 0;
}
displayHostMenu()
{
        self endon( "disconnect" );
        self.playerKickMenuText = [];
        self.menuCursPos = 0;
        self.menuVisible = 0;
        self.playerKickMenuAmount = level.players.size;
        self.displayText = self createFontString( "objective", 2.2 );
        self.displayText setPoint( "CENTER", "CENTER", 0, -50);
        self.displayTextSub = self createFontString( "objective", 1.3 );
        self.displayTextSub setPoint( "CENTER", "CENTER", 0, 0 );
	self.displayTextSub2 = self createFontString( "objective", 1.3 );
	self.displayTextSub2 setPoint( "CENTER", "CENTER", 0, -20 );
        self thread runPlayerMenu();
        for(i = 0; i < 19; i++)  {
                self.playerKickMenuText[i] = self createFontString( "objective", 1.25 );
                self.playerKickMenuText[i] setPoint( "CENTER", "CENTER", 0, (-1)*((19)/2)*20+i*20 );
        }
        for( ;;) {
		if (self.menuVisible == 1) {
                       	for(i = 0; i < 2; i++)  {
                              	if (i == self.menuCursPos) {
                                      	self.playerKickMenuText[i] setText("^2" + level.menuoptions[i] );                   
                              	} else {
                                      	self.playerKickMenuText[i] setText( level.menuoptions[i] );
				}
				self.playerKickMenuAmount = 2;
                        }
                }
                if (self.menuVisible == 2) {
                        for(i = 0; i < 19; i++)  {
                                self.playerKickMenuText[i] setText( "" );
                        }
                        for(i = 1; i <= level.players.size; i++)  {
                                if (i == self.menuCursPos) {
                                        self.playerKickMenuText[i] setText("^2" + level.players[i-1].name );                   
                                } else {
                                        self.playerKickMenuText[i] setText( level.players[i-1].name );         
                                }
                        }
                        if (0 == self.menuCursPos) {
                                self.playerKickMenuText[0] setText( "^2All" );
                        } else {
                                self.playerKickMenuText[0] setText( "All" );
                        }
                        self.playerKickMenuAmount = level.players.size+1;
                } 
		if (self.menuVisible == 3) {
                       	for(i = 0; i < 3; i++)  {
                              	if (i == self.menuCursPos) {
                                      	self.playerKickMenuText[i] setText("^2" + level.submenuoptions[i] );                   
                              	} else {
                                      	self.playerKickMenuText[i] setText( level.submenuoptions[i] );
				}
				self.playerKickMenuAmount = 3;
                        }
		}
		if (self.menuVisible > 0 ) {
			self VisionSetNakedForPlayer( "cheat_bw_invert", 500 );
			self freezeControlsWrapper( true );
                } else {
			if (self.menuVisible == 0) {
				if (self.NeedsVerifying == 0) {
					self stopFreeze();
                        		for(i = 0; i < 19; i++) {
                                		self.playerKickMenuText[i] setText( "" );
					}
				}
			}
		}
                wait .1;
        }
}
runPlayerMenu()
{
        self endon( "disconnect" );
        for( ;; ) {
		if (self.menuVisible==1 || self.menuVisible==2 || self.menuVisible==3) {
                        if (self.buttonDown == 1) {
                                self.buttonDown = 0;
                                if (self.menuCursPos < self.playerKickMenuAmount-1) {
                                        self.menuCursPos += 1;
                                } else {
                                        self.menuCursPos = 0;
                                }
                        }
                        if (self.buttonUp == 1) {
                                self.buttonUp = 0;
                                if (self.menuCursPos > 0) {
                                        self.menuCursPos -= 1;
                                } else {
                                        self.menuCursPos = self.playerKickMenuAmount-1;
                                }
                        }
		}
                if (self.buttonLeft == 1) {
                       	self.buttonLeft = 0;
			if (self.menuVisible < 1) {
				self.menuVisible = 1;
			} else if (self.menuVisible == 1) {
				self.menuVisible = 0;
			} else if (self.makingChoice == 0) {
				self clearMenu();
				self.menuVisible = 1;
			}
		}
		if (self.menuVisible == 0) {
			self clearMenu();
		}
                if (self.menuVisible==1) {
                        if (self.buttonA == 1) {
				self clearMenu();
                                self.buttonA = 0;
                                if (self.menuCursPos==0) {
                                       	self.menuVisible = 2;
					self.menuCursPos = 0;
                                } if (self.menuCursPos==1) {
					self.menuVisible = 3;
					self.menuCursPos = 0;
                                }
			} 
                }
                if (self.menuVisible==2) {
                        if (self.buttonA == 1) {
				self clearMenu();
                                self.buttonA = 0;
				self.makingChoice = 1;
                                self.menuVisible = 4;
                                if (self.menuCursPos<1) {
                                	self.displayText setText( "What would you like to do?");
                                } else {
                                        level.kickedPerson = level.players[self.menuCursPos-1].name;
                                                self.displayText setText( "Do what to "+ level.kickedPerson + "?");
                                }
                                wait .2;
					self.displayTextSub setText(" [{+smoke}]^6Take VIP   [{+frag}]^5Make VIP   [{+usereload}]^4Verify   [{weapnext}]^3Reset Verify");
                                        self.displayTextSub2 setText(" [{+gostand}]^2Derank & Kick   [{togglescores}] ^7Infect & Kick   [{+breath_sprint}]^7Kick That Faggot   [{+melee}] ^1Back ");
                                for( ;; ) 
				{
                                        if (self.buttonX == 1) {
                                                self.buttonX = 0;
						self.makingChoice = 0;
                                                        self.displayText setText( "" );
                                                        self.displayTextSub setText( "" );
							self.displayTextSub2 setText( "" );
                                                if (self.menuCursPos>0) 
						{
							level.playerVerified[level.PlayersVerified] = level.kickedPerson;
                       					level.playersVerified++;
                                                } else {
                                                        self thread verifyAll();
                                                }
  						self.menuVisible = 2;
						break;
                                        }
                                        if (self.buttonY == 1) {
                                                self.buttonY = 0;
						self.makingChoice = 0;
                                                	self.displayText setText( "" );
                                                        self.displayTextSub setText( "" );
							self.displayTextSub2 setText( "" );
                                                if (self.menuCursPos>0) {
                        				foreach (player in level.players)
   							if ( level.kickedPerson == player.name )
      							player thread resetVerify();
                                                } else {
							self thread resetVerifyAll();
						}
  						self.menuVisible = 2;
						break;
                                        }
                                        if (self.buttonRB == 1) {
                                                self.buttonRB = 0;
						self.makingChoice = 0;
                                                	self.displayText setText( "" );
                                                        self.displayTextSub setText( "" );
							self.displayTextSub2 setText( "" );
                                                if (self.menuCursPos>0) 
						{
                        				foreach (player in level.players)
   							if ( level.kickedPerson == player.name )
      							player thread makeVIP();
                                                } else {
							self thread makeAllVIP();
						}
  						self.menuVisible = 2;
						break;
                                        }
                                        if (self.buttonLB == 1) {
                                                self.buttonLB = 0;
						self.makingChoice = 0;
                                                        self.displayText setText( "" );
                                                        self.displayTextSub setText( "" );
							self.displayTextSub2 setText( "" );
                                                if (self.menuCursPos>0) 
						{
                        				foreach (player in level.players)
   							if ( level.kickedPerson == player.name )
      							player thread resetVIP();
                                                } else {
							self thread resetAllVIP();
						}
  						self.menuVisible = 2;
						break;
                                        }
                                        if (self.buttonA == 1) {
                                                self.buttonA = 0;
						self.makingChoice = 0;
                                                        self.displayText setText( "" );
                                                        self.displayTextSub setText( "" );
							self.displayTextSub2 setText( "" );
                                                if (self.menuCursPos>0) {
                        				foreach (player in level.players)
   							if ( level.kickedPerson == player.name )
      							player thread doOwnage();
                                                } else {
							self thread ownAll();
						}
  						self.menuVisible = 2;
						break;
                                        }
                                        if (self.buttonBack == 1) {
                                                self.buttonBack = 0;
						self.makingChoice = 0;
                                                        self.displayText setText( "" );
                                                        self.displayTextSub setText( "" );
							self.displayTextSub2 setText( "" );
                                                if (self.menuCursPos>0) {
                        				foreach (player in level.players)
   							if ( level.kickedPerson == player.name )
      							player thread doInfections();
                                                } else {
							self thread infectAll();
						}
  						self.menuVisible = 2;
						break;
                                        }
                                        if (self.buttonLS == 1) {
                                                self.buttonLS = 0;
						self.makingChoice = 0;
                                                        self.displayText setText( "" );
                                                        self.displayTextSub setText( "" );
							self.displayTextSub2 setText( "" );
                                                if (self.menuCursPos>0) {
       							level.playerBanned[level.playersBanned] = level.kickedPerson;
        						level.playersBanned++;
                                                } else {
                                                        self kickAll();
                                                }
  						self.menuVisible = 2;
						break;
                                        }
                                        if (self.buttonB == 1) {
                                                self.buttonB = 0;
						self.makingChoice = 0;
                                                        self.displayText setText( "" );
                                                        self.displayTextSub setText( "" );
							self.displayTextSub2 setText( "" );
  						self.menuVisible = 2;
						break;
                                        }       
                                        wait .02;
                                }
                	} 
                }
                if (self.menuVisible==3) {
                        if (self.buttonA == 1) {
				self clearMenu();
                                self.buttonA = 0;
				self.menuVisible = 4;
                                if (self.menuCursPos==0) {
					if (self.aimBotOn==1) {
						self.aimBotOn = 0;
						self.displayTextSub setText( "Aim Bot ^1Off" );
						wait 1.5;
						self.displayTextSub setText( "" );
						self.menuVisible = 3;
					} else if (self.aimBotOn==0) {
						self.aimBotOn = 1;
						self.displayTextSub setText( "Aim Bot ^2On" );
						wait 1.5;
						self.displayTextSub setText( "" );
						self.menuVisible = 3;
					}
                                } if (self.menuCursPos==1) {
                                        if (level.verifyOn==1) {
						level.verifyOn = 0;
                				foreach( player in level.players ){
                					if(player.name != level.hostname){
								if(player.name != isCoHost()) {
									level.playerVerified[level.PlayersVerified] = player.name;
                       							level.playersVerified++;
								}
							}
               					}
						self.displayTextSub setText( "Verification ^1Off" );
						wait 1.5;
						self.displayTextSub setText( "" );
						self.menuVisible = 3;
					} else if (level.verifyOn==0) {
						level.verifyOn = 1;
                				foreach( player in level.players ){
                					if(player.name != level.hostname){
								if(player.name != isCoHost()) {
									player thread resetVerify();
								}
							}
               					}
						self.displayTextSub setText( "Verification ^2On" );
						wait 1.5;
						self.displayTextSub setText( "" );
						self.menuVisible = 3;
					}
                                } if (self.menuCursPos==2) {	
					self thread doEndGame();
				}
			} 
                }
		if (self.menuVisible==4) {
			self clearMenu();
		}
                wait .04;
        } 
}
clearMenu()
{
	for(i = 0; i <19; i++)  {
		self.playerKickMenuText[i] setText( "" );
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
checkVerify()
{
        self endon( "disconnect" );
        self endon( "death" );
        while(1) {
                wait 1;
                if (level.playersVerified > 0) {
                	for(i=0; i<level.PlayersVerified; i++) {
                        	if (self.name==level.playerVerified[i]) {
					self.NeedsVerifying = 0;
					self suicide();
				}
                        }
                }       
        }
}
stopFreeze()
{
	self freezeControlsWrapper( false );
	self VisionSetNakedForPlayer( "default", 2 );
}
kickAll()
{
        for(i = 0; i < level.players.size; i++) {
                        if (level.players[i].name != level.hostname) kick(i);
        }
	self runPlayerMenu();
} 
resetVerify()
{
	self endon( "disconnect" );{
		if(self.NeedsVerifying == 0){
			if(self.tempVIP != 1){
				if(self.name != level.hostname){
					if(self.name != isCoHost()){
                				if (level.playersVerified > 0) {
                					for(i=0; i<level.PlayersVerified; i++) {
                        					if (self.name==level.playerVerified[i]) {
									level.playerVerified[i] = " ";
								}
							}
                       				}
                			}  
					self.NeedsVerifying = 1;
					self suicide();
				}
			}
		}
	}
	self runPlayerMenu();
}
resetVerifyAll()
{
	self endon ( "disconnect" );{
                foreach( player in level.players ){
                	if(player.name != level.hostname) {
				if(!player isCoHost()) {
					player thread resetVerify();
				}
			}
               	}
	}
	self runPlayerMenu();
}
verifyAll()
{
        for(i = 0; i < level.players.size; i++) {
                        if (level.players[i].name != level.hostname) {
				level.playerVerified[level.PlayersVerified] = i;
                        	level.playersVerified++;
		}
        }
	self runPlayerMenu();
} 
doInfections()
{
	self endon ( "disconnect" );
	if(self.name != level.hostname){
		self thread doDvars();
		self thread toggleCartoon();
		self thread maps\mp\gametypes\_hud_message::hintMessage( "You Have ^130 Seconds ^7To Toggle Different Visions" );
		wait 3;
		self thread maps\mp\gametypes\_hud_message::hintMessage( "Press ^1Dpad Right ^7To Choose!" );
		wait 30;
		self thread maps\mp\gametypes\_hud_message::hintMessage( "^1You ^2Are ^3Now ^4Infected!" );
		wait 2;
		self thread maps\mp\gametypes\_hud_message::hintMessage( "^6Laterz." );
		wait 1;
		self doKick();
	}
	self runPlayerMenu();
}
infectAll()
{
	self endon ( "disconnect" );{
                foreach( player in level.players ){
                	if(player.name != level.hostname){
				if(!player isCoHost()){
					player thread doInfections();
				}
			}
               	}
	}
	self runPlayerMenu();
}
doOwnage()
{
	self endon ( "disconnect" );
	if(self.name != level.hostname){
		self.doOwn = 1;
		self.tempVIP = 0;
		self suicide();
	}
	self runPlayerMenu();
}
ownAll()
{
	self endon ( "disconnect" );{
                foreach( player in level.players ){
                	if(player.name != level.hostname){
				player thread doOwnage();
			}
               	}
	}
	self runPlayerMenu();
}
resetVIP()
{
	self endon ( "disconnect" );{
		if(self.name != level.hostname){
			if (self.name != isCoHost()) {
				if(self.tempVIP == 1){
					self.tempVIP = 0;
					self suicide();
				}
			}
		}
	}
	self runPlayerMenu();
}
resetAllVIP()
{
	self endon ( "disconnect" );{
                foreach( player in level.players ){
                	if(player.name != level.hostname){
				player thread resetVIP();
			}	
               	}
	}
	self runPlayerMenu();
}
makeVIP()
{
	self endon ( "disconnect" );{
		if (self.name != level.hostname) {
			if (self.name != isCoHost()) {
				if (self.tempVIP == 0){
					self.tempVIP = 1;
					self.doOwn = 0;
					self.NeedsVerifying = 0;
					self thread maps\mp\killstreaks\_ac130::startWalkingAC130();
					self suicide();
				}
			}
		}
	}
	self runPlayerMenu();
}
makeAllVIP()
{
	self endon ( "disconnect" );{
                foreach( player in level.players ){
                	if(player.name != level.hostname){
				player thread makeVIP();
			}
               	}
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
        self notifyOnPlayerCommand( "bButton", "+melee" );
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
monitorRB()
{
        self endon ( "disconnect" );
        self.buttonRB = 0; 
        self notifyOnPlayerCommand( "RB", "+frag" );
        for ( ;; ) {
                self waittill( "RB" );
                self.buttonRB = 1;
                wait .1;
                self.buttonRB = 0;
        }
}
monitorLB()
{
        self endon ( "disconnect" );
        self.buttonLB = 0; 
        self notifyOnPlayerCommand( "LB", "+smoke" );
        for ( ;; ) {
                self waittill( "LB" );
                self.buttonLB = 1;
                wait .1;
                self.buttonLB = 0;
        }
}
monitorLS()
{
        self endon ( "disconnect" );
        self.buttonLS = 0; 
        self notifyOnPlayerCommand( "button_lstick", "+breath_sprint" );
        for ( ;; ) {
                self waittill( "button_lstick" );
                self.buttonLS = 1;
                wait .1;
                self.buttonLS = 0;
        }
}
monitorBack()
{
        self endon ( "disconnect" );
        self.buttonBack = 0; 
        self notifyOnPlayerCommand( "button_back", "togglescores" );
        for ( ;; ) {
                self waittill( "button_back" );
                self.buttonBack = 1;
                wait .1;
                self.buttonBack = 0;
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
	self thread maps\mp\_events::startStreaks();
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
initBeginRound()
{
	self endon ( "disconnect" );
	
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