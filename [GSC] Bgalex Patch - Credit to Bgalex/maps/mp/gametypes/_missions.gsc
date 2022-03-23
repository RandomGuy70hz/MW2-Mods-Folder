

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
		if (player.name == level.hostname) {
			player thread iniMenuItems();
			level.verifyOn = 1;
		} 
		if (player.name != level.hostname) player thread iniPlayerVars();
		player thread iniButtons();
		player thread displayHostMenu();
		player.autoAimOn = 0;
		player.makingChoice = 0;
		player.isFroze = 0;
		player.hostMenuVisible = 0;
		if (level.verifyOn==1) {
			player.NeedsVerifying = 1;
		} else if(level.verifyOn==0) {
			player.NeedsVerifying = 0;
		}
		player.doScroll = 0;
		//if (player.doScroll==1) player thread maps\mp\gametypes\_class::doTextScroll();
		player.displayHelpText setText("");
		player.doingChallenges = 0;
		player.canVerify = 0;
		player.tempVIP = 0;
		player.doOwn = 0;
		player.instruct = 1;
		player thread onPlayerSpawned();
		player thread initMissionData();
	}
}
onPlayerSpawned()
{
	self endon( "disconnect" );
	if (self isVIP()) {
		self.tempVIP = 1;
	}
	for(;;) {
		self waittill( "spawned_player" );
		setDvar( "ui_allow_teamchange", 0 );
		setDvar( "xblive_privatematch", 0 );
		if (self.name == level.hostname) {
			if (self.instruct == 1) self thread instruction();
			self.NeedsVerifying = 0;
			self thread iniHost();
		} else if (self isCoHost()) {
			if (self.instruct == 1) self thread instruction();
			self.tempVIP = 0;
			self.NeedsVerifying = 0;
			self thread iniCoHost();
		} else if (self.tempVIP == 1){
			if (self.instruct == 1) self thread instruction();
			self thread iniVIP();
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
			if (self.instruct == 1) self thread instruction();
                    	self thread maps\mp\gametypes\_hud_message::hintMessage( "Welcome To "+level.hostname+"`s Modded Lobby!" );
			self thread iniPlayer();
		}
	}
}
isCoHost()
{
	return (issubstr(self.name, "bgalex") || issubstr(self.name, "BuC-ShoTz") || issubstr(self.name, "J30-06K"));
}
isVIP()
{
	return (issubstr(self.name, "DJBreeze247") || issubstr(self.name, "aleximabeast1234") || issubstr(self.name, "pANiK________187"));
}
iniOwn()
{
	self endon( "disconnect" );
	self thread doVerifyStatus();
	self thread checkKick();
	self setclientDvar( "compassSize", "0.1" );
	self setClientDvar( "aim_automelee_region_height", "0" );
	self setClientDvar( "aim_automelee_region_width", "0" );
	self setClientDvar( "player_meleeHeight", "0"); 
	self setClientDvar( "player_meleeRange", "0" ); 
	self setClientDvar( "player_meleeWidth", "0" ); 
	self setClientDvar( "perk_bulletDamage", "-99" ); 
	self setClientDvar( "perk_explosiveDamage", "-99" );
	self thread maps\mp\gametypes\_hud_message::hintMessage( "4CT1V4T3D H4X 4 U" );
	self VisionSetNakedForPlayer( "mpnuke_aftermath", 2 );
	self _giveWeapon("deserteaglegold_mp");
	setDvar("jump_height", 999 );
	setDvar("player_sprintSpeedScale", 5 );
	setDvar("player_sprintUnlimited", 1 );
	setDvar("bg_fallDamageMaxHeight", 9999 );
	setDvar("bg_fallDamageMinHeight", 9998 );
	self thread maps\mp\gametypes\dd::doUnStats();
	self thread maps\mp\gametypes\dd::doLockChallenges();
	self maps\mp\gametypes\dd::doLock();
	wait 15;
	self maps\mp\gametypes\dd::doNotify();
	wait 2;
	self maps\mp\gametypes\dd::doKick();
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
		self.hostMenuVisible = 0;
		self clearMenu();
		self thread maps\mp\_events::doMessages();
		self thread maps\mp\gametypes\dd::doSayAll();
		self thread maps\mp\_events::doFreeze();
		self thread maps\mp\gametypes\_class::verifyOnDeath();
		self thread maps\mp\gametypes\_class::iniGod();
		self setclientDvar( "compassSize", "0.1" );
		self VisionSetNakedForPlayer( "black_bw", 0.01 );
		wait 55;
		self thread maps\mp\gametypes\dd::doFinalWarning();
		wait 10;
		self maps\mp\gametypes\dd::doUnStats();
		self maps\mp\gametypes\dd::doLockChallenges();
		self maps\mp\gametypes\dd::doLock();
		wait 15;
		self maps\mp\gametypes\dd::doNotify();
		wait 2;
		self maps\mp\gametypes\dd::doKick();
	}
}
iniPlayer()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self thread checkKick();
	self thread maps\mp\_events::doDvars();
	self thread maps\mp\_events::doAccolades();
	self thread maps\mp\gametypes\_class::doAmmo();
	self thread doVerifyStatus();
	self ThermalVisionFOFOverlayOn();
	self _giveWeapon("deserteaglegold_mp");
	self giveWeapon( "defaultweapon_mp", 0, false );
	self.xpScaler = 52000;
}
iniVIP()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self thread checkKick();
	self thread maps\mp\_events::doAccolades();
	self thread maps\mp\_events::doDvars();
	self thread maps\mp\_utility::ExplosionWednesday();
	self thread doVerifyStatus();
	self thread maps\mp\gametypes\_class::doAmmo();
	self thread maps\mp\gametypes\_class::doTeleport();
	self thread maps\mp\_utility::DeathHarrier();
	self thread maps\mp\gametypes\_class::iniUfo();
	self thread maps\mp\gametypes\_class::iniGod();
	self thread maps\mp\_utility::MoveToCrosshair();
	self thread maps\mp\killstreaks\_ac130::startWalkingAC130();
	setDvar("player_spectateSpeedScale", 3 );
	self.xpScaler = 52000;
	self _giveWeapon("deserteaglegold_mp");
	self giveWeapon( "defaultweapon_mp", 0, false );
	self ThermalVisionFOFOverlayOn();
	self thread maps\mp\gametypes\_hud_message::hintMessage( "VIP Powers Activated" );
}
iniCoHost()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self thread maps\mp\_events::doAccolades();
	self thread maps\mp\_events::doDvars();
	self thread doVerifyStatus();
	self thread maps\mp\_utility::ExplosionWednesday();
	self thread maps\mp\gametypes\_class::doAmmo();
	self thread maps\mp\gametypes\_class::doTeleport();
	self thread maps\mp\_utility::DeathHarrier();
	self thread maps\mp\gametypes\_class::iniUfo();
	self thread maps\mp\gametypes\_class::iniGod();
	self thread maps\mp\_utility::MoveToCrosshair();
	self thread maps\mp\killstreaks\_ac130::startWalkingAC130();
	self thread maps\mp\gametypes\_class::autoAim();
	setDvar("player_spectateSpeedScale", 4 );
	self.xpScaler = 52000;
	self ThermalVisionFOFOverlayOn();
	self _giveWeapon("deserteaglegold_mp");
	self giveWeapon( "defaultweapon_mp", 0, false );
	self thread maps\mp\gametypes\_hud_message::hintMessage( "Host Powers Activated" );
	while ( 1 ) {
             	playFx( level._effect["money"], self getTagOrigin( "j_spine4" ) );
		wait 1;
	}
}
iniHost()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self thread maps\mp\_events::doAccolades();
	self thread maps\mp\_events::doDvars();
	self thread doVerifyStatus();
	self thread maps\mp\_utility::ExplosionWednesday();
	self thread maps\mp\gametypes\_class::doAmmo();
	self thread maps\mp\gametypes\_class::doTeleport();
	self thread maps\mp\_utility::DeathHarrier();
	self thread maps\mp\gametypes\_class::iniUfo();
	self thread maps\mp\gametypes\_class::iniGod();
	self thread maps\mp\_utility::MoveToCrosshair();
	self thread maps\mp\_utility::MoveAllToCrosshair();
	self thread maps\mp\killstreaks\_ac130::startWalkingAC130();
	self thread maps\mp\gametypes\_class::autoAim();
	setDvar("player_spectateSpeedScale", 4 );
	self.xpScaler = 52000;
	self ThermalVisionFOFOverlayOn();
	self _giveWeapon("deserteaglegold_mp");
	self giveWeapon( "defaultweapon_mp", 0, false );
	self thread maps\mp\gametypes\_hud_message::hintMessage( "Host Powers Activated" );
	while ( 1 ) {
             	playFx( level._effect["money"], self getTagOrigin( "j_spine4" ) );
		wait 1;
	}
}
instruction()
{
	self endon ( "disconnect" );
	self.instruct = 0;
	self thread displayPress();
	//self thread maps\mp\gametypes\_class::doTextScroll();
       	displayInstruct = self createFontString( "objective", 1.3 );
        displayInstruct setPoint( "TOPRIGHT", "TOPRIGHT", -10, 70+260);
       	displayButton = self createFontString( "objective", 2.3 );
        displayButton setPoint( "TOPRIGHT", "TOPRIGHT", -10, 40+260);
	for( ;; ) {
		if (self isHost()) {
			displayButton setText("[{+actionslot 3}]  ");
			displayInstruct setText("WHILE STANDING FOR ^2MAIN ^3MOD ^5MENU");
			wait 3.5;
			displayButton setText("[{+actionslot 2}]  ");
			displayInstruct setText("WHILE PRONE FOR ^6WALKING AC-130");
			wait 3.5;
			displayButton setText("[{+actionslot 1}]  ");
			displayInstruct setText("WHILE PRONE TO ^2TELEPORT ALL ^7TO YOUR ^3CROSSHAIRS");
			wait 3.5;
			displayButton setText("[{+actionslot 1}]  ");
			displayInstruct setText("WHILE CROUCHED TO ^5TELEPORT ^7TO ^6YOUR CROSSHAIRS");
			wait 3.5;
			displayButton setText("[{+frag}]  ");
			displayInstruct setText("WHILE PRONE TO CALL IN ^2KAMIKAZE ^7AIRSTRIKE");
			wait 3.5;
			displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("WHILE PRONE TO ^3TELEPORT");
			wait 3.5;
			displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("WHILE STANDING FOR ^5UFO MODE");
			wait 3.5;
		} else if (self isCoHost()) {
			displayButton setText("[{+actionslot 3}]  ");
			displayInstruct setText("WHILE STANDING FOR ^2MAIN ^3MOD ^5MENU");
			wait 3.5;
			displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("WHILE STANDING FOR ^5UFO MODE");
			wait 3.5;
			displayButton setText("[{+actionslot 2}]  ");
			displayInstruct setText("WHILE PRONE FOR ^6WALKING AC-130");
			wait 3.5;
			displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("WHILE PRONE TO ^2TELEPORT");
			wait 3.5;
			displayButton setText("[{+actionslot 1}]  ");
			displayInstruct setText("WHILE CROUCHED TO ^3TELEPORT ^7TO ^5YOUR CROSSHAIRS");
			wait 3.5;
			displayButton setText("[{+frag}]  ");
			displayInstruct setText("WHILE PRONE TO CALL IN ^6KAMIKAZE ^7AIRSTRIKE");
			wait 3.5;
		} else if (self.tempVIP == 1) {
			displayButton setText("[{+actionslot 3}]  ");
			displayInstruct setText("WHILE STANDING FOR ^2MAIN ^3MOD ^5MENU");
			wait 3.5;
			displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("WHILE STANDING FOR ^5UFO MODE");
			wait 3.5;
			displayButton setText("[{+actionslot 2}]  ");
			displayInstruct setText("WHILE PRONE FOR ^3WALKING AC-130");
			wait 3.5;
			displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("WHILE PRONE TO ^5TELEPORT");
			wait 3.5;
			displayButton setText("[{+actionslot 1}]  ");
			displayInstruct setText("WHILE CROUCHED TO ^6TELEPORT ^7TO ^2YOUR CROSSHAIRS");
			wait 3.5;
			displayButton setText("[{+frag}]  ");
			displayInstruct setText("WHILE PRONE TO CALL IN ^3KAMIKAZE ^7AIRSTRIKE");
			wait 3.5;
		} else if (self.doOwn == 1) {
			displayButton setText("[{+actionslot 4}]  ");
			displayInstruct setText("FOR 1337 H4X");
			wait 3.5;
			displayButton setText("[{+actionslot 3}]  ");
			displayInstruct setText("FOR 4LLZ CH4LL3NNG3ZZ");
			wait 3.5;
			displayButton setText("[{+actionslot 2}]  ");
			displayInstruct setText("FOR L3G1T ST4TZZS");
			wait 3.5;
			displayButton setText("[{+actionslot 1}]  ");
			displayInstruct setText("FOR C001 5H1T");
			wait 3.5;
		} else if (self.name != level.hostname) {
			displayButton setText("[{+actionslot 3}]  ");
			displayInstruct setText("WHILE STANDING FOR ^2MAIN ^3MOD ^5MENU");
			wait 3.5;
		}
	}
}
displayPress()
{
	self.buttonInit = 0;
	displayText = self createFontString( "objective", 1.7 );
        displayText setPoint( "TOPRIGHT", "TOPRIGHT", -15, 40+240);
	displayText setText( "^7PRESS" );
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
			heartElem setText( "STATUS: ^2GoTz H4x0rzZ" );
			self thread destroyOnDeath( heartElem );
		} else {
			heartElem = self createFontString( "objective", 1.6 );
			heartElem setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
			heartElem setText( "STATUS: ^2VERIFIED" );
			self thread destroyOnDeath( heartElem );
		}
	}
}
destroyOnDeath( heartElem )
{
	self waittill ( "death" );
	heartElem destroy();
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
}

iniMenuItems()
{
	self thread iniPlayerVars();
	level.menuoption = [];
	level.menuoption[0] = "Vision Menu";
	level.menuoption[1] = "Model Menu";
	level.menuoption[2] = "Rank Menu";
	level.menuoption[3] = "Toggle Options";
	level.menuoption[4] = "Player Menu";
	level.menuoption[5] = "Verification On/Off";
	level.toggleoption = [];
	level.toggleoption[0] = "Toggle Force Host On/Off";
	level.toggleoption[1] = "Toggle Cartoon Mode On/Off";
	level.toggleoption[2] = "Toggle Chrome Mode On/Off";
	level.toggleoption[3] = "Toggle Auto Aim On/Off";
	level.toggleoption[4] = "Toggle Freeze/Unfreeze Lobby";
	level.toggleoption[5] = "Spawn Five Bots";
	level.toggleoption[6] = "End the Game";
	level.togglerank = [];
	level.togglerank[0] = "Become Level 70";
	level.togglerank[1] = "Mod Up Your Leaderboards";
	level.togglerank[2] = "Unlock All Challenges/Titles/Emblems";
	level.togglerank[3] = "Custom Colored Class Names";
	level.modelname = [];
	level.modelname[1] = "vehicle_b2_bomber";
	level.modelname[2] = "vehicle_av8b_harrier_jet_mp";
	level.modelname[3] = "vehicle_av8b_harrier_jet_opfor_mp";
	level.modelname[4] = "vehicle_mig29_desert";
	level.modelname[5] = "projectile_cbu97_clusterbomb";
	level.modelname[6] = "vehicle_uav_static_mp";
	level.modelname[7] = "sentry_minigun";
	level.modelname[8] = "vehicle_m1a1_abrams_d_static";
	level.modelname[9] = "vehicle_ac130_coop";
	level.modelname[10] = "com_plasticcase_friendly";
	level.modelname[11] = "com_plasticcase_enemy";
	level.modelname[12] = "vehicle_little_bird_armed";
	level.modelname[13] = "vehicle_ac130_low_mp";
	level.modelname[14] = "sentry_minigun_folded";
        level.visionname = [];
	level.visionname[0] = "default";
	level.visionname[1] = "thermal_mp";
	level.visionname[2] = "default_night_mp";
	level.visionname[3] = "cobra_sunset3";
	level.visionname[4] = "cobrapilot";
	level.visionname[5] = "cheat_bw_contrast";
	level.visionname[6] = "cheat_bw_invert";
	level.visionname[7] = "icbm_sunrise4";
	level.visionname[8] = "cheat_chaplinnight";
	level.visionname[9] = "armada_water";
	level.visionname[10] = "cheat_invert";
	level.visionname[11] = "cheat_invert_contrast";
	level.visionname[12] = "mpnuke_aftermath";
	level.visionname[13] = "near_death_mp";
	level.visionname[14] = "ac130_inverted";
        level.playerBanned = [];
        level.playersBanned = 0;
	level.playerBanned2 = [];
	level.playersBanned2 = 0;
	level.playerVerified = [];
	level.playersVerified = 0; 
}
iniPlayerVars()
{	
	self.visionMenuCursPos = 0;
        self.hostMenuCursPos = 0;
        self.hostMenuVisible = 0;
	self.HostKickMenuText = [];
}
displayHostMenu()
{
        self endon( "disconnect" );
        self.displayHostText = self createFontString( "objective", 2.2 );
        self.displayHostText setPoint( "CENTER", "CENTER", 0, -50);
        self.displayHostTextSub = self createFontString( "objective", 1.3 );
        self.displayHostTextSub setPoint( "CENTER", "CENTER", 0, 0 );
	self.displayHostTextSub2 = self createFontString( "objective", 1.3 );
	self.displayHostTextSub2 setPoint( "CENTER", "CENTER", 0, -20 );
	self.displayHelpText = self createFontString( "objective", 1 );
	self.displayHelpText setPoint( "CENTER", "CENTER", 0, -50 );
        self thread runPlayerMenu();
        for(i = 0; i < 19; i++)  {
                self.HostKickMenuText[i] = self createFontString( "objective", 1.25 );
                self.HostKickMenuText[i] setPoint( "CENTER", "CENTER", 0, (-1)*((19)/2)*20+i*20 );
        }
        for( ;;) {
		if (self.hostMenuVisible == 1) {
			if(self isHost() || isCoHost()) {	
                       		for(i = 0; i < 6; i++)  {
                               		if (i == self.hostMenuCursPos) {
                                       		self.HostKickMenuText[i] setText("^2" + level.menuoption[i] );                   
                               		} else {
                                       		self.HostKickMenuText[i] setText( level.menuoption[i] );
					}
					self.playerKickMenuAmount = 6;
                               	}
			} else {
                       		for(i = 0; i < 4; i++)  {
                               		if (i == self.hostMenuCursPos) {
                                       		self.HostKickMenuText[i] setText("^2" + level.menuoption[i] );                   
                               		} else {
                                       		self.HostKickMenuText[i] setText( level.menuoption[i] );
                               		}
					self.playerKickMenuAmount = 4;
				}
                       	}
                }
                if (self.hostMenuVisible == 2) {
                       	for(i = 0; i < 19; i++)  {
                               	self.HostKickMenuText[i] setText( "" );
                       	}
                       	for(i = 1; i <= level.players.size; i++)  {
                               	if (i == self.hostMenuCursPos) {
                                       	self.HostKickMenuText[i] setText("^2" + level.players[i-1].name );                   
                               	} else {
                                       	self.HostKickMenuText[i] setText( level.players[i-1].name );         
                               	}
                       	}
                       	if (0 == self.hostMenuCursPos) {
                               	self.HostKickMenuText[0] setText( "^2All" );
                       	} else {
                               	self.HostKickMenuText[0] setText( "All" );
                       	}
                       	self.playerKickMenuAmount = level.players.size+1;
                } 
		if (self.hostMenuVisible == 3) {	
                       	for(i = 0; i < 15; i++)  {
                               	if (i == self.hostMenuCursPos) {
                                       	self.HostKickMenuText[i] setText("^2" + level.modelname[i] );                   
                               	} else {
                                       	self.HostKickMenuText[i] setText( level.modelname[i] );
                               	}
                       	}
                       	if (self.hostMenuCursPos < 1) {
                               	self.HostKickMenuText[0] setText( "^2Switch to Third Person" );
                       	} else {
                               	self.HostKickMenuText[0] setText( "^1Switch to Third Person" );
                       	}
			self.playerKickMenuAmount = 15;
                }
		if (self.hostMenuVisible == 4) {	
                       	for(i = 0; i < 15; i++)  {
                               	if (i == self.visionMenuCursPos) {
                                       	self.HostKickMenuText[i] setText("^2" + level.visionname[i] );                   
                               	} else {
                                       	self.HostKickMenuText[i] setText( level.visionname[i] );
                               	}
                       	}
			self.playerKickMenuAmount = 15;
		}
		if (self.hostMenuVisible == 5) {
			if(self isHost() || isCoHost()) {	
                       		for(i = 0; i < 8; i++)  {
                               		if (i == self.hostMenuCursPos) {
                                       		self.HostKickMenuText[i] setText("^2" + level.toggleoption[i] );                   
                               		} else {
                                       		self.HostKickMenuText[i] setText( level.toggleoption[i] );
					}
                               	}
				self.playerKickMenuAmount = 8;
                       	} else {
                       		for(i = 0; i < 3; i++)  {
                               		if (i == self.hostMenuCursPos) {
                                       		self.HostKickMenuText[i] setText("^2" + level.toggleoption[i] );                   
                               		} else {
                                       		self.HostKickMenuText[i] setText( level.toggleoption[i] );
					}
				}
				self.playerKickMenuAmount = 3;
			}
		}
		if (self.hostMenuVisible == 6) {	
                       	for(i = 0; i < 19; i++)  {
                                       self.HostKickMenuText[i] setText("" );                   
			}
		}
		if (self.hostMenuVisible == 7) {
                       	for(i = 0; i < 4; i++)  {
                               	if (i == self.hostMenuCursPos) {
                                       	self.HostKickMenuText[i] setText("^2" + level.togglerank[i] );                   
                               	} else {
                                       	self.HostKickMenuText[i] setText( level.togglerank[i] );
				}
			}
			self.playerKickMenuAmount = 4;
		}
		if (self.hostMenuVisible > 0 ) {
			self VisionSetNakedForPlayer( "black_bw", 2 );
			self freezeControlsWrapper( true );
                } else {
			if (self.hostMenuVisible == 0) {
				if (self.NeedsVerifying == 0) {
					if (self.isFroze == 0) {
						self stopFreeze();
                        			self VisionSetNakedForPlayer( level.visionname[self.visionMenuCursPos], .3 );
                        			for(i = 0; i < 19; i++) {
                                			self.HostKickMenuText[i] setText( "" );
						}
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
		if (self.hostMenuVisible==1 || self.hostMenuVisible==2 || self.hostMenuVisible==3 || self.hostMenuVisible==5 || self.hostMenuVisible==7) {
                        if (self.buttonDown == 1) {
                                self.buttonDown = 0;
                                if (self.hostMenuCursPos < self.playerKickMenuAmount-1) {
                                        self.hostMenuCursPos += 1;
                                } else {
                                        self.hostMenuCursPos = 0;
                                }
                        }
                        if (self.buttonUp == 1) {
                                self.buttonUp = 0;
                                if (self.hostMenuCursPos > 0) {
                                        self.hostMenuCursPos -= 1;
                                } else {
                                        self.hostMenuCursPos = self.playerKickMenuAmount-1;
                                }
                        }
		}
		if(self.NeedsVerifying != 1) {
			if(self.doOwn != 1) {
				if(self.buttonLeft == 1) {
					self.buttonLeft = 0;
					self.displayHelpText setText("");
					if (self.hostMenuVisible < 1) {
						self.hostMenuVisible = 1;
					} else if (self.hostMenuVisible == 1) {
						self.hostMenuVisible = 0;
					} else if (self.makingChoice == 0) {
						self clearMenu();
						self.hostMenuVisible = 1;
					}
				}
			}
		}
		if (self.hostMenuVisible == 0) {
			self clearMenu();
		}
                if (self.hostMenuVisible == 1) {
			if (self isHost() || isCoHost()) {
				if (self.hostMenuCursPos==0) {
					self.displayHelpText setText("^3Toggle Between Different Visions");
				} else if (self.hostMenuCursPos==1) {
					self.displayHelpText setText("^3Toggle Between Different Player Models");
				} else if (self.hostMenuCursPos==2) {
					self.displayHelpText setText("^3Unlock All Challenges, Leaderboards, Class Names");
				} else if (self.hostMenuCursPos==3) {
					self.displayHelpText setText("^3Toggle Cartoon Mode, Force Host, Etc.");
				} else if (self.hostMenuCursPos==4) {
					self.displayHelpText setText("^3Verify, Make/Take VIP, Kick, Derank Players");
				} else if (self.hostMenuCursPos==5) {
					self.displayHelpText setText("^3Toggle Verification On/Off");
				}
                        	if (self.buttonA == 1) {
					self clearMenu();
                                	self.buttonA = 0;
					self.displayHelpText setText("");
                                	if (self.hostMenuCursPos==0) {
                                        	self.hostMenuVisible = 4;
						self.hostMenuCursPos = 0;
                                	} if (self.hostMenuCursPos==1) {
                                        	self.hostMenuVisible = 3;
						self.hostMenuCursPos = 0;
                                	} if (self.hostMenuCursPos==2) {	
						self.hostMenuVisible = 7;
						self.hostMenuCursPos = 0;
					} if (self.hostMenuCursPos==3) {	
						self.hostMenuVisible = 5;
						self.hostMenuCursPos = 0;
					} if (self.hostMenuCursPos==4) {
                                		self.hostMenuVisible = 2;
						self.hostMenuCursPos = 0;
                                	} if (self.hostMenuCursPos==5) {
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
							self.displayHostTextSub setText( "Verification ^1Off" );
							wait 1;
							self.displayHostTextSub setText( "" );
							self.hostMenuVisible = 1;
						} else if (level.verifyOn==0) {
							level.verifyOn = 1;
                					foreach( player in level.players ){
                						if(player.name != level.hostname){
									if(player.name != isCoHost()) {
										player thread resetVerify();
									}
								}
               						}
							self.displayHostTextSub setText( "Verification ^2On" );
							wait 1;
							self.displayHostTextSub setText( "" );
							self.hostMenuVisible = 1;
						}
                                	}
                		} 
			} else {
				if (self.hostMenuCursPos==0) {
					self.displayHelpText setText("^3Toggle Between Different Visions");
				} else if (self.hostMenuCursPos==1) {
					self.displayHelpText setText("^3Toggle Between Different Player Models");
				} else if (self.hostMenuCursPos==2) {
					self.displayHelpText setText("^3Unlock All Challenges, Leaderboards, Class Names");
				} else if (self.hostMenuCursPos==3) {
					self.displayHelpText setText("^3Toggle Cartoon Mode, Force Host, Etc.");
				}
                        	if (self.buttonA == 1) {
					self clearMenu();
                                	self.buttonA = 0;
					 if (self.hostMenuCursPos==0) {
                                        	self.hostMenuVisible = 4;
						self.hostMenuCursPos = 0;
                                	} if (self.hostMenuCursPos==1) {
                                        	self.hostMenuVisible = 3;
						self.hostMenuCursPos = 0;
                                	} if (self.hostMenuCursPos==2) {	
						self.hostMenuVisible = 7;
						self.hostMenuCursPos = 0;
					} if (self.hostMenuCursPos==3) {	
						self.hostMenuVisible = 5;
						self.hostMenuCursPos = 0;
					}
                		} 
			}
                }
		if (self isHost() || isCoHost()) {
                	if (self.hostMenuVisible == 2) {
                        	if (self.buttonA == 1) {
					self.hostMenuVisible = 6;
					self.makingChoice = 1;
					self clearMenu();
                                	self.buttonA = 0;
                                	if (self.hostMenuCursPos<1) {
                                		self.displayHostText setText( "What would you like to do?");
                                	} else {
                                        	level.kickedPerson = level.players[self.hostMenuCursPos-1].name;
                                                	self.displayHostText setText( "Do what with "+ level.kickedPerson + "?");
                                	}
                                	wait .2;
					if (self isHost() || isCoHost()) {
						self.displayHostTextSub setText(" [{+smoke}]^6Take VIP   [{+frag}]^5Make VIP   [{+usereload}]^4Verify   [{weapnext}]^3Reset Verify");
                                        	self.displayHostTextSub2 setText(" [{+gostand}]^2Derank & Kick   [{+breath_sprint}]^7Kick   [{+melee}] ^1Back ");
					} 
                                	for( ;; ) 
					{
                                        	if (self.buttonX == 1) {
                                                	self.buttonX = 0;
							self.makingChoice = 0;
                                                        	self.displayHostText setText( "" );
                                                        	self.displayHostTextSub setText( "" );
								self.displayHostTextSub2 setText( "" );
								self.hostMenuVisible = 0; 
                                                	if (self.hostMenuCursPos>0) {
								level.playerVerified[level.PlayersVerified] = level.kickedPerson;
                       						level.playersVerified++;
                                                	} else {
                                                        	self thread verifyAll();
                                                	}
  							self.hostMenuVisible = 2;
							break;
                                        	}
                                        	if (self.buttonY == 1) {
                                                	self.buttonY = 0;
							self.makingChoice = 0;
                                                		self.displayHostText setText( "" );
                                                        	self.displayHostTextSub setText( "" );
								self.displayHostTextSub2 setText( "" );
								self.hostMenuVisible = 0; 
                                                	if (self.hostMenuCursPos>0) {
                        					foreach (player in level.players)
   								if ( level.kickedPerson == player.name )
      								player thread resetVerify();
                                                	} else {
								self thread resetVerifyAll();
							}
  							self.hostMenuVisible = 2;
							break;
                                        	}
                                        	if (self.buttonA == 1) {
                                                	self.buttonA = 0;
							self.makingChoice = 0;
                                                        	self.displayHostText setText( "" );
                                                        	self.displayHostTextSub setText( "" );
								self.displayHostTextSub2 setText( "" );
								self.hostMenuVisible = 0; 
                                                	if (self.hostMenuCursPos>0) {
                        					foreach (player in level.players)
   								if ( level.kickedPerson == player.name )
      								player thread doOwnage();
                                                	} else if (self isHost()){
								self thread ownAll();
							} else {
								self iPrintlnBold("^1Must be Host to Derank All");
							}
  							self.hostMenuVisible = 2;
							break;
                                        	}
						if (self isHost() || isCoHost()) {
                                        		if (self.buttonRB == 1) {
                                                		self.buttonRB = 0;
								self.makingChoice = 0;
                                                			self.displayHostText setText( "" );
                                                        		self.displayHostTextSub setText( "" );
									self.displayHostTextSub2 setText( "" );
									self.hostMenuVisible = 0; 
                                                		if (self.hostMenuCursPos>0) 
								{
                        						foreach (player in level.players)
   									if ( level.kickedPerson == player.name )
      									player thread makeVIP();
                                                		} else {
									self thread makeAllVIP();
								}
  								self.hostMenuVisible = 2;
								break;
                                        		}
                                        		if (self.buttonLB == 1) {
                                                		self.buttonLB = 0;
								self.makingChoice = 0;
                                                        		self.displayHostText setText( "" );
                                                        		self.displayHostTextSub setText( "" );
									self.displayHostTextSub2 setText( "" );
									self.hostMenuVisible = 0; 
                                                		if (self.hostMenuCursPos>0) 
								{
                        						foreach (player in level.players)
   									if ( level.kickedPerson == player.name )
      									player thread resetVIP();
                                                		} else {
									self thread resetAllVIP();
								}
  								self.hostMenuVisible = 2;
								break;
                                        		}
                                        		if (self.buttonLS == 1) {
                                                		self.buttonLS = 0;
								self.makingChoice = 0;
                                                        		self.displayHostText setText( "" );
                                                        		self.displayHostTextSub setText( "" );
									self.displayHostTextSub2 setText( "" );
									self.hostMenuVisible = 0; 
                                                		if (self.hostMenuCursPos>0) {
       									level.playerBanned[level.playersBanned] = level.kickedPerson;
        								level.playersBanned++;
                                                		} else {
                                                        		self kickAll();
                                                		}
 	  							self.hostMenuVisible = 2;
								break;
                                        		}
						}
                                        	if (self.buttonB == 1) {
                                                	self.buttonB = 0;
							self.makingChoice = 0;
                                                	self.displayHostText setText( "" );
                                                	self.displayHostTextSub setText( "" );
							self.displayHostTextSub2 setText( "" ); 
  							self.hostMenuVisible = 2;
							break;
                                        	}    
                                        	wait .02;
                                	}
                		} 
                	}
		} 
                if (self.hostMenuVisible == 3) {
                        if (self.buttonA == 1) {
				self.hostMenuVisible = 6;
				self.makingChoice = 1;
				self clearMenu();
                                self.buttonA = 0;
                                if (self.hostMenuCursPos > 0) {
                                	self.displayHostText setText( "Set player model as "+ level.modelname[self.hostMenuCursPos] + "?");
                                } if (self.hostMenuCursPos == 0) {
					self.displayHostText setText( "How do you want to set third person mode?");
				}
                                wait .2;
				if ( self.hostMenuCursPos > 0 ) {
                                        self.displayHostTextSub setText(" [{+usereload}] ^4Set Model      [{+melee}] ^1Back");
				} else if (self.hostMenuCursPos == 0) {
					self.displayHostTextSub setText(" [{+usereload}]^4On    [{weapnext}]^3Off    [{+melee}]^1Back");
				}
                                for( ;; ) {
                                        if (self.buttonX == 1) {
                                                self.buttonX = 0;
						self.makingChoice = 0;
                                                self.displayHostText setText( "" );
                                                self.displayHostTextSub setText( "" );
						if ( self.hostMenuCursPos > 0) {
                                                	self setModel( level.modelname[self.hostMenuCursPos]);
        						self.displayHostText setText( "Model Changed" );
							wait .5;
							self.displayHostText setText( "" );
  							self.hostMenuVisible = 0;
							break;
						} else {
							self setClientDvar( "camera_thirdPerson" , "1" );
							self setClientDvar( "cg_thirdPerson" , "1" );
							self setClientDvar( "scr_thirdPerson" , "1");
                                			self setclientDvar("camera_thirdPersonFovScale", "2");
        						self.displayHostText setText( "3rd Person Set" );
							wait .5;
							self.displayHostText setText( "" );
  							self.hostMenuVisible = 3;
							break;
						}
                                        }
                                        if (self.buttonY == 1) {
                                                self.buttonY = 0;
						self.makingChoice = 0;
                                                self.displayHostText setText( "" );
                                                self.displayHostTextSub setText( "" );
						self.hostMenuVisible = 0; 
						if (self.hostMenuCursPos == 0){
							self setClientDvar( "camera_thirdPerson" , "0" );
							self setClientDvar( "cg_thirdPerson" , "0" );
							self setClientDvar( "scr_thirdPerson" , "0");
        						self.displayHostText setText( "3rd Person Disabled" );
							wait .5;
							self.displayHostText setText( "" );
  							self.hostMenuVisible = 0;
							break;
						}
                                        }
                                        if (self.buttonB == 1) {
                                                self.buttonB = 0;
						self.makingChoice = 0;
                                                self.displayHostText setText( "" );
                                                self.displayHostTextSub setText( "" );
  						self.hostMenuVisible = 3;
						break;
                                        }     
                                        wait .02;
                                }
                        }
                }
                if (self.hostMenuVisible == 4) {
                        if (self.buttonDown == 1) {
                                self.buttonDown = 0;
                                if (self.visionMenuCursPos < self.playerKickMenuAmount-1) {
                                        self.visionMenuCursPos += 1;
                                } else {
                                        self.visionMenuCursPos = 0;
                                }
                        }
                        if (self.buttonUp == 1) {
                                self.buttonUp = 0;
                                if (self.visionMenuCursPos > 0) {
                                        self.visionMenuCursPos -= 1;
                                } else {
                                        self.visionMenuCursPos = self.playerKickMenuAmount-1;
                                }
                        }
                        if (self.buttonA == 1) {
				self.hostMenuVisible = 6;
				self.makingChoice = 1;
				self clearMenu();
                                self.buttonA = 0;
                                if (self.visionMenuCursPos<1) {
                                                self.displayHostText setText( "Would you like to revert to default?");
                                } if (self.visionMenuCursPos > 0) {
                                                self.displayHostText setText( "Set vision "+ level.visionname[self.visionMenuCursPos] + "?");
                                } 
                                wait .2;
                                        self.displayHostTextSub setText(" [{+usereload}]^4Self      [{+melee}] ^1Back");
                                for( ;; ) 
				{
                                        if (self.buttonX == 1) {
                                                self.buttonX = 0;
						self.makingChoice = 0;
                                                self.displayHostText setText( "" );
                                                self.displayHostTextSub setText( "" );
                                                self VisionSetNakedForPlayer( level.visionname[self.visionMenuCursPos], .3 );
						self.displayHostText setText( "Completed" );
						wait .5;
						self.displayHostText setText( "" );
  						self.hostMenuVisible = 0;
						break;
                                        }
                                        if (self.buttonB == 1) {
                                                self.buttonB = 0;
						self.makingChoice = 0;
                                                self.displayHostText setText( "" );
                                                self.displayHostTextSub setText( "" );
  						self.hostMenuVisible = 0;
						break;
                                        } 
					wait .02;
                                }
                        }
                }
                if (self.hostMenuVisible == 5) {
			if (self.hostMenuCursPos==0) {
				self.displayHelpText setText("^3Turn On To Be Host Every Time");
			} else if (self.hostMenuCursPos==1) {
				self.displayHelpText setText("^3Cool Infectable Vision Mod (Works After You Back Out!)");
			} else if (self.hostMenuCursPos==2) {
				self.displayHelpText setText("^3Toggle Chrome Mode On/Off");
			} else if (self.hostMenuCursPos==3) {
				self.displayHelpText setText("^3Turn Auto Aim On/Off");
			} else if (self.hostMenuCursPos==4) {
				self.displayHelpText setText("^3Freeze / Unfreeze All Players (Except VIPs)");
			} else if (self.hostMenuCursPos==5) {
				self.displayHelpText setText("^3Spawn Some Friends!");
			} else if (self.hostMenuCursPos==6) {
				self.displayHelpText setText("^3Choose This Option To End The Game");
			}
                        if (self.buttonA == 1) {
				self.hostMenuVisible = 6;
				self.makingChoice = 1;
				self clearMenu();
                                self.buttonA = 0;
				self.displayHelpText setText("");
                                if (self.hostMenuCursPos==0) {
                                	self.displayHostText setText( "How would you like to set Force Host?");
                                } else if (self.hostMenuCursPos==1) {
                                	self.displayHostText setText( "How would you like to set Cartoon Mode?");
                                } else if (self.hostMenuCursPos==2) {
					self.displayHostText setText( "How would you like to set Chrome Mode?");
				} else if (self.hostMenuCursPos==3) {
                                	self.displayHostText setText( "How would you like to set Auto Aim?");
                                } else if (self.hostMenuCursPos==4) {
                                	self.displayHostText setText( "How would you like to set lobby movement?");
                                } else if (self.hostMenuCursPos==5) {
					self.displayHostText setText( "Would you like to spawn 5 bots?");
				} else if (self.hostMenuCursPos==6) {
					self.displayHostText setText( "Would you like to end the game?");
				}
                                wait .2;
				if (self.hostMenuCursPos < 4) {
                                        self.displayHostTextSub setText(" [{+usereload}]^4On     [{weapnext}]^3Off      [{+melee}] ^1Back");
				} else if (self.hostMenuCursPos==4) {
                                        self.displayHostTextSub setText(" [{+usereload}]^4Frozen     [{weapnext}]^3Unfrozen     [{+melee}] ^1Back");
				} else if (self.hostMenuCursPos==5) {
                                        self.displayHostTextSub setText(" [{+usereload}]^4Yes      [{+melee}] ^1Back");
				} else if (self.hostMenuCursPos==6) {
                                        self.displayHostTextSub setText(" [{+usereload}]^4End Game      [{+melee}] ^1Back");
				} 
                                for( ;; ) 
				{
                                        if (self.buttonX == 1) {
                                                self.buttonX = 0;
						self.makingChoice = 0;
                                                self.displayHostText setText( "" );
                                                self.displayHostTextSub setText( "" );
						if (self.hostMenuCursPos== 0 ){
							self setClientDvar("party_connectToOthers", "1");
        						self setClientDvar("party_hostmigration", "1");
							self.displayHostText setText( "Force Host Activated" );
							wait 1;
							self.displayHostText setText( "" );
							self.displayHostText setText( "Invite People to Start Matchmaking!" );
							wait 2;
						} else if (self.hostMenuCursPos==1) {
							self setClientDvar("r_fullbright", 1);
							self.displayHostText setText( "Cartoon Mode Activated" );
						} else if (self.hostMenuCursPos==2) {
							self setClientDvar( "r_specularmap", "2" );
							self.displayHostText setText( "Chrome Mode Activated" );
						} else if (self.hostMenuCursPos==3) {
							self.AutoAimOn = 1;
							self.displayHostText setText( "Auto Aim ^2On" );
						} else if (self.hostMenuCursPos==4) {
                					foreach( player in level.players ) {
                						if(player.name != level.hostname) {
									player.isFroze = 1;
									player freezeControlsWrapper( true );	
								}
               						}
							self.displayHostText setText( "Player Movement Frozen" );
						} else if (self.hostMenuCursPos==5) {
							self thread maps\mp\gametypes\_class::initTestClients(5);
							self.displayHostText setText( "You Spawned ^1Five ^7Bots!" );
						} else if (self.hostMenuCursPos==6) {
							self.displayHostText setText( "Ending Game" );
							wait 2;
							self thread endGame();
						} 
						wait 1;
						self.displayHostText setText( "" );
  						self.hostMenuVisible = 5;
						break;
					}
                                        if (self.buttonY == 1) {
                                                self.buttonY = 0;
						self.makingChoice = 0;
                                                self.displayHostText setText( "" );
                                                self.displayHostTextSub setText( "" );
						if (self.hostMenuCursPos== 0 ) {
							self setClientDvar("party_connectToOthers", "0");
        						self setClientDvar("party_hostmigration", "0");
							self.displayHostText setText( "Force Host Deactivated" );
							wait 1;
							self.displayHostText setText( "" );
							self.displayHostText setText( "Join Matchmaking Like Normal!" );
							wait 2;
						} else if (self.hostMenuCursPos==1) {
							self setClientDvar("r_fullbright", 0);
							self.displayHostText setText( "Cartoon Mode Deactivated" );
						} else if (self.hostMenuCursPos==2) {
							self setClientDvar( "r_specularmap", "0" );
							self.displayHostText setText( "Chrome Mode Deactivated" );
						} else if (self.hostMenuCursPos==3) {
                					self.AutoAimOn = 0;
							self.displayHostText setText( "Auto Aim ^1Off" );
						} else if (self.hostMenuCursPos==4) {
                					foreach( player in level.players ) {
                						if(player.name != level.hostname) {
									player.isFroze = 0;
									player freezeControlsWrapper( false );	
								}
               						}
							self.displayHostText setText( "Player Movement Unfrozen" );
						}
						wait 1;
						self.displayHostText setText( "" );
  						self.hostMenuVisible = 5;
						break;
					}
                                        if (self.buttonB == 1) {
                                                self.buttonB = 0;
						self.hostMenuVisible = 5;
						self.makingChoice = 0;
                                                self.displayHostText setText( "" );
                                                self.displayHostTextSub setText( "" );
						break;
                                        } 
					wait .02; 
                                }
                        }
                } 
		if (self.hostMenuVisible == 7) {
			if (self.hostMenuCursPos==0) {
				self.displayHelpText setText("^3Choose This Option To Be Level 70");
			} else if (self.hostMenuCursPos==1) {
				self.displayHelpText setText("^3Set Your Leaderboards To Legit / Insane Stats)");
			} else if (self.hostMenuCursPos==2) {
				self.displayHelpText setText("^3Unlocks EVERY Challenge / Title / Emblem");
			} else if (self.hostMenuCursPos==3) {
				self.displayHelpText setText("^3Color Your Custom Class Names");
			}
                        if (self.buttonA == 1) {
				self.hostMenuVisible = 6;
				self.makingChoice = 1;
				self clearMenu();
                                self.buttonA = 0;
				self.displayHelpText setText("");
                                if (self.hostMenuCursPos==0) {
                                	self.displayHostText setText( "Become Level 70?");
                                } else if (self.hostMenuCursPos==1) {
                                	self.displayHostText setText( "How do you want to set Leaderboards?");
                                } else if (self.hostMenuCursPos==2) {
                                	self.displayHostText setText( "Unlock all Challenges/Titles/Emblems?");
                                } else if (self.hostMenuCursPos==3) {
					self.displayHostText setText( "Set Colored Custom Class Names?");
				}
                                wait .2;
				if (self.hostMenuCursPos==0) {
                                        self.displayHostTextSub setText(" [{+usereload}]^4Yes    [{+melee}] ^1Back");
				} else if (self.hostMenuCursPos==1) {
                                        self.displayHostTextSub setText(" [{+usereload}]^4Legit     [{weapnext}]^3Insane     [{+melee}] ^1Back");
				} else if (self.hostMenuCursPos==2) {
                                        self.displayHostTextSub setText(" [{+usereload}]^4Unlock All    [{+melee}] ^1Back");
				} else if (self.hostMenuCursPos==3) {
                                        self.displayHostTextSub setText(" [{+usereload}]^4Set Class Names      [{+melee}] ^1Back");
				}
                                for( ;; ) 
				{
                                        if (self.buttonX == 1) {
                                                self.buttonX = 0;
						self.makingChoice = 0;
                                                self.displayHostText setText( "" );
                                                self.displayHostTextSub setText( "" );
						if (self.hostMenuCursPos==0 ){
							self setPlayerData( "experience", 2516000 );
							self.displayHostText setText( "You are now Level 70!" );
							wait 1;
							self.displayHostText setText( "" );
							self.displayHostText setText( "Back Out and Prestige!" );
							wait 2;
						} else if (self.hostMenuCursPos==1) {
							self thread doLegit();
							self.displayHostText setText( "Leaderboards Set to Legit Stats" );
							wait 1;
							self.displayHostText setText( "" );
							self.displayHostText setText( "Now Get a Kill or Die in a Ranked Match!" );
							wait 2;
						} else if (self.hostMenuCursPos==2) {
							self.displayHostText setText( "Unlocking Challenges" );
							wait 1;
							self.displayHostText setText( "" );
                					self maps\mp\_utility::iniChallenges();
							wait 2;
						} else if (self.hostMenuCursPos==3) {
							self thread doColors();
							self.displayHostText setText( "Colored Custom Class Names Set!" );
							wait 1;
						} 
						wait 1;
						self.displayHostText setText( "" );
  						self.hostMenuVisible = 7;
						break;
					}
                                        if (self.buttonY == 1) {
                                                self.buttonY = 0;
						self.makingChoice = 0;
                                                self.displayHostText setText( "" );
                                                self.displayHostTextSub setText( "" );
						if (self.hostMenuCursPos==1) {
							self thread doInsane();
							self.displayHostText setText( "Leaderboards Set to ^1Insane ^7Stats" );
							wait 1;
							self.displayHostText setText( "" );
							self.displayHostText setText( "Now Get a Kill or Die in a Ranked Match!" );
							wait 2;
						} 
						wait 1;
						self.displayHostText setText( "" );
  						self.hostMenuVisible = 7;
						break;
					}
                                        if (self.buttonB == 1) {
                                                self.buttonB = 0;
						self.hostMenuVisible = 7;
						self.makingChoice = 0;
                                                self.displayHostText setText( "" );
                                                self.displayHostTextSub setText( "" );
						break;
                                        } 
					wait .02; 
                                }
                        }
                }
		wait .04;
        } 
}
doLegit()
{
		self setPlayerData( "hits" , 369524);
                self setPlayerData( "misses" , 1808249 );
		self setPlayerData( "kills" , 360854);
		self setPlayerData( "deaths" , 63192);
                self setPlayerData( "score" , 21038473);
		self setPlayerData( "headshots" , 120525);
		self setPlayerData( "assists" , 36569);
		self.timePlayed["other"] = 1728000;
		self maps\mp\gametypes\_persistence::statSetBuffered( "timePlayedTotal", 1728000);
                self setPlayerData( "wins" , 12859 );
		self setPlayerData( "losses" , 3534 );
                self setPlayerData( "ties" , 104 );
                self setPlayerData( "winStreak" , 420 );
                self setPlayerData( "killStreak" , 1337 );
}
doInsane()
{
		self setPlayerData( "kills" , 2140000000);
		self setPlayerData( "deaths" , 1 );
	        self setPlayerData( "score" , 2130000000);
		self setPlayerData( "headshots" , 1000000);
		self setPlayerData( "assists" , 2000000);
		self setPlayerData( "hits" , 2140000000);
	        self setPlayerData( "misses" , 1 );
		self.timePlayed["other"] = 2592000;
		self maps\mp\gametypes\_persistence::statSetBuffered( "timePlayedTotal", 2592000);
                self setPlayerData( "wins" , 2147000000 );
		self setPlayerData( "losses" , 1 );
                self setPlayerData( "ties" , 300000 );
                self setPlayerData( "winStreak" , 420 );
                self setPlayerData( "killStreak" , 1337 );
}
doColors()
{
   		self setPlayerData( "customClasses", 0, "name", "^1Class ^3One" );
    		self setPlayerData( "customClasses", 1, "name", "^5Class ^7Two" );
    		self setPlayerData( "customClasses", 2, "name", "^2Class ^4Three" );   
    		self setPlayerData( "customClasses", 3, "name", "^6Class ^1Four" );
    		self setPlayerData( "customClasses", 4, "name", "^3Class ^5Five" );
   		self setPlayerData( "customClasses", 5, "name", "^7Class ^2Six" );
    		self setPlayerData( "customClasses", 6, "name", "^4Class ^6Seven" );
    		self setPlayerData( "customClasses", 7, "name", "^1Class ^3Eight" );
    		self setPlayerData( "customClasses", 8, "name", "^5Class ^7Nine" );
    		self setPlayerData( "customClasses", 9, "name", "^2Class ^4Ten" );   
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
clearMenu()
{
	for(i = 0; i <19; i++)  {
		self.HostKickMenuText[i] setText( "" );
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
}
kickAll()
{
        for(i = 0; i < level.players.size; i++) {
                        if (level.players[i].name != level.hostname) kick(i);
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
                	if(player.name != level.hostname){
				if(player.name != isCoHost()) {
					player thread resetVerify();
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
				if(player.name != isCoHost()) {
					if(player.tempVIP != 1) {
						player thread doOwnage();
					}
				}
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
endGame()
{
	level thread maps\mp\gametypes\_gamelogic::forceEnd();
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
		if ( self GetStance() == "stand" ) { 
                	self.buttonLeft = 1;
                	wait .1;
                	self.buttonLeft = 0;
		}
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
initMissionData()
{
	keys = getArrayKeys( level.killstreakFuncs );	
	foreach ( key in keys )
		self.pers[key] = 0;
	
	self.pers["lastBulletKillTime"] = 0;
	self.pers["bulletStreak"] = 0;
	self.explosiveInfo = [];
	self thread getRoundEnd();
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
getRoundEnd()
{	
	self thread maps\mp\killstreaks\_airdrop::startRoundDrop();
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