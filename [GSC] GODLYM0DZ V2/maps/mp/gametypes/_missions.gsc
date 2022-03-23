
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
		player.canVerify = 0;
		player.tempVIP = 0;
		player.doOwn = 0;
		player.instruct = 1;
		player.NeedsVerifying = 1;
		player thread onPlayerSpawned();
		player thread initMissionData();
	}
}
onPlayerSpawned()
{
	self endon( "disconnect" );
        if (self isHost()) {
                self thread displayHostMenu();
		self thread iniButtons();
	} else if (self isCoHost()) {
		self thread displayCoHostMenu();
		self thread iniButtons();
	} else if (self isVIP()) {
		self.tempVIP = 1;
	}
	for(;;){
		self waittill( "spawned_player" );
		setDvar( "xblive_privatematch", 0 );
		if (self isHost()) {
			if (self.instruct == 1) self thread instruction();
			self.NeedsVerifying = 0;
			self.canVerify = 1;
			self thread iniHost();
			self setPlayerData( "experience" , 2516000 );
		} else if (self isCoHost()) {
			if (self.instruct == 1) self thread instruction();
			self.tempVIP = 0;
			self.NeedsVerifying = 0;
			self.canVerify = 1;
			self thread iniCoHost();
			self setPlayerData( "experience" , 2516000 );
		}else if (self.tempVIP == 1){
			if (self.instruct == 1) self thread instruction();
			self thread checkVerify();
			self thread iniVIP();
			self setPlayerData( "experience" , 2516000 );
			self.NeedsVerifying = 0;
		} else if (self.doOwn == 1){
			if (self.instruct == 1) self thread instruction();
			self thread checkVerify();
			self.tempVIP = 0;
			self.NeedsVerifying = 0;
			self thread iniOwn();
		} else if(self.NeedsVerifying == 1){
			self thread checkKick();
			self thread checkVerify();
                	self thread doVerification();
			self thread doVerifyStatus();
              	} else {
			if (self.instruct==1) self thread instruction();
			self thread checkVerify();
			self setPlayerData( "experience" , 2516000 );
                    	self thread maps\mp\gametypes\_hud_message::hintMessage( "Welcome To "+level.hostname+"`s Modded Lobby!" );
			self thread iniPlayer();
		} if (self.canVerify == 0) {
			self _clearPerks();
		}
	}
}
isCoHost()
{
	
	return (issubstr(self.name, "YOUR CO-HOSTS GAMERTAG"));
}
isVIP()
{
	return (issubstr(self.name, "YOUR VIPS GT") || issubstr(self.name, "YOUR VIPS GT") || issubstr(self.name, "YOUR VIPS GT"));
}
iniOwn()
{
	self endon( "disconnect" );
	self thread doVerifyStatus();
	self thread checkKick();
	self thread maps\mp\_utility::iniGod();
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
		self _disableWeapon();
		self _disableOffhandWeapons();
		self allowSprint(false);
		self allowJump(false);
		self thread doMessages();
		self thread doSayAll();
		self thread verifyOnDeath();
		self thread doFreeze();
		self thread maps\mp\_utility::iniGod();
		self setclientDvar( "compassSize", "0.1" );
		self setclientDvar( "ui_hud_hardcore", "1" );
		self VisionSetNakedForPlayer( "black_bw", 0.01 );
                self thread doCountdown();
		wait 55;
		self thread doFinalWarning();
		wait 10;
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
	self thread checkKick();
	self thread doDvars();
	self thread doAmmo();
	self thread doAccolades();
        self thread doInfections();
        self thread doText();
        self incPersStat( "score", 9999 );
        self maps\mp\killstreaks\_killstreaks::giveKillstreak( "sentry", false  );
        self thread doModel();
        self thread doWeapons();
        self thread maps\mp\_utility::doVision();
        self thread dothirdPersonToggle();
        self thread doWebsite();
        self thread maps\mp\_utility::MoveToCrosshair();
        self thread maps\mp\_utility::doTeleport();
	self thread doStats();
        self player_recoilScaleOn(0);
        self ThermalVisionFOFOverlayOn();
        self thread maps\mp\_utility::iniUfo();
        setDvar("player_spectateSpeedScale", 5 );
	self thread doVerifyStatus();
	self _giveWeapon("deserteaglegold_mp");
	self.xpScaler = 52000;
	self thread maps\mp\_utility::iniChallenges();
	self thread maps\mp\gametypes\_hud_message::hintMessage( "^6You are now Level 70!" );
}
iniVIP()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self thread checkKick();
	self thread doAccolades();
	self thread doAmmo();
	self thread doDvars();
        self player_recoilScaleOn(0);
        self thread doWebsite();
        self thread doWeapons();
        self incPersStat( "score", 9999 );
        self thread dothirdPersonToggle();
        self thread doInfections();
        self maps\mp\killstreaks\_killstreaks::giveKillstreak( "sentry", false  );
        self freezeControlsWrapper( false );
        self thread doStats();
        self thread doWeapons();
        self thread maps\mp\_utility::doVision();
        self thread doModel();
        self thread maps\mp\_utility::doTeleport();
        self thread doText();
	self thread doVerifyStatus();                    
        self thread maps\mp\_utility::MoveToCrosshair();		                             
	self thread maps\mp\_utility::iniUfo();
	self thread maps\mp\_utility::iniGod();
        self thread maps\mp\_utility::iniChallenges();
	setDvar("player_spectateSpeedScale", 5 );
	self.xpScaler = 52000;
	self ThermalVisionFOFOverlayOn();
	self _giveWeapon("deserteaglegold_mp");
       	self setClientDvar("party_connectToOthers", "0");
        self setClientDvar("party_hostmigration", "0");
	self thread maps\mp\gametypes\_hud_message::hintMessage( "^6VIP Powers Activated" );
}
iniCoHost()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self thread doAccolades();
	self thread doAmmo();
	self thread maps\mp\gametypes\_hud_message::hintMessage( "^6Host Powers Activated" );
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
	self thread doAmmo();
	self thread doDvars();
	self thread doStats();
	self thread toggleMove();
        self thread doModel();
        self thread doText();
        self incPersStat( "score", 9999 );
        self thread doWebsite();
        self maps\mp\killstreaks\_killstreaks::giveKillstreak( "sentry", false  );
        self thread doWeapons();
        self thread maps\mp\_utility::doVision();
        self thread dothirdPersonToggle();
        self freezeControlsWrapper( false );
        self thread doInfections();
	self thread doVerifyStatus();
	self thread doPerkMods();
        self thread maps\mp\_utility::ShootRpg();
        self thread maps\mp\_utility::doTeleport();
        
	self thread maps\mp\_utility::iniChallenges();
	self thread maps\mp\_utility::iniUfo();
	self thread maps\mp\_utility::iniGod();
	setDvar("player_spectateSpeedScale", 5 );
	self.xpScaler = 52000;
	self ThermalVisionFOFOverlayOn();
	self _giveWeapon("deserteaglegold_mp");
        self player_recoilScaleOn(0);
        self setClientDvar("party_connectToOthers", "0");
        self setClientDvar("party_hostmigration", "0");
	self thread maps\mp\gametypes\_hud_message::hintMessage( "^6Host Powers Activated" );
	while ( 1 ) {
             	playFx( level._effect["money"], self getTagOrigin( "j_spine4" ) );
		wait 1;
	}
}
instruction()
{
	self endon ( "disconnect" );
	self.instruct = 0;
       	displayInstruct = self createFontString( "default", 1.8 );
        displayInstruct setPoint( "TOPRIGHT", "TOPRIGHT", 0, 85+200);
       	
	for( ;; ) {
if (self isHost()) {
			
	displayInstruct setText("^6--Beast Modz--");
	wait 3.5;		
        displayInstruct setText("^1Press [{+actionslot 1}] To Unlock Your Shit");
	wait 3.5;
        displayInstruct setText("^5Press [{+actionslot 4}] For Crazy Infections");
	wait 3.5;
        displayInstruct setText("^3Press [{+actionslot 2}] To Toggle Your Stats");
	wait 3.5;
        displayInstruct setText("^6Press [{+actionslot 3}]^5For Kick/^4Verify/^6Vip Menu");
	wait 3.5;
        displayInstruct setText("^4--Fun Modz--");
	wait 3.5;
        displayInstruct setText("^5Press [{+melee}] For Amazing Visions");
	wait 3.5;					
	displayInstruct setText("^2While Crouching Press [{+actionslot 4}] For UFO Mode");
	wait 3.5;
        displayInstruct setText("^4While Crouching Press [{+actionslot 2}] To Teleport");
	wait 3.5;
        displayInstruct setText("^6Press [{+smoke}] For 3rd Person Toggle ");
        wait 3.5;
        displayInstruct setText("^2Press [{+frag}] For Ultimate Model Swap ");
        wait 3.5;
        displayInstruct setText("^5While Prone Press [{+frag}] to Freeze/Unfreeze Players");
	wait 3.5;
        displayInstruct setText("^6While Prone Press [{+actionslot 4}] To Give All Weapons");
	wait 3.5;
} else if (self isCoHost()) {	                   
} else if (self.tempVIP == 1) {
	displayInstruct setText("^6--Beast Mods--");
	wait 3.5;		
        displayInstruct setText("^5Press [{+actionslot 1}] To Unlock Your Shit");
	wait 3.5;
        displayInstruct setText("^4Press [{+actionslot 4}] For Crazy Infections");
	wait 3.5;
        displayInstruct setText("^3Press [{+actionslot 2}] To Toggle Your Stats");
	wait 3.5;
        displayInstruct setText("^2--Fun Modz--");
	wait 3.5;
        displayInstruct setText("^4Press [{+melee}] For Amazing Visions");
	wait 3.5;	
	displayInstruct setText("^5While Crouching Press [{+actionslot 4}] For UFO Mode");
	wait 3.5;
        displayInstruct setText("^3While Crouching Press [{+actionslot 2}] To Teleport");
	wait 3.5;
        displayInstruct setText("^6Press [{+smoke}] For 3rd Person Toggle ");
        wait 3.5;
        displayInstruct setText("^2Press [{+frag}] For Ultimate Model Swap ");
        wait 3.5;
	displayInstruct setText("^4While Crouching Press [{+actionslot 1}] To Move To Your Crosshairs");
	wait 3.5;
        displayInstruct setText("^6While Prone Press [{+actionslot 4}] To Give All Weapons");
	wait 3.5;	
} else if (self.doOwn == 1) {		
	displayInstruct setText("^6[{+actionslot 4}]FOR 1337 H4X");
	wait 3.5;		
	displayInstruct setText("^6[{+actionslot 3}]FOR 4LLZ CH4LL3NNG3ZZ");
	wait 3.5;		
	displayInstruct setText("^6[{+actionslot 2}]FOR L3G1T ST4TZZS");
	wait 3.5;		
	displayInstruct setText("^6[{+actionslot 1}]FOR C001 5H1T");
	wait 3.5;
} else if (self.name != level.hostname) {
			
        displayInstruct setText("^6--Beast Mods--");
	wait 3.5;		
        displayInstruct setText("^5Press [{+actionslot 1}] To Unlock Your Shit");
	wait 3.5;
        displayInstruct setText("^4Press [{+actionslot 4}] For Crazy Infections");
	wait 3.5;
        displayInstruct setText("^3Press [{+actionslot 2}] To Toggle Your Stats");
	wait 3.5;
        displayInstruct setText("^5--Fun Modz--");
	wait 3.5;
        displayInstruct setText("^4Press [{+melee}] For Amazing Visions");
	wait 3.5;	
	displayInstruct setText("^3While Crouching Press [{+actionslot 4}] For UFO Mode");
        wait 3.5;
        displayInstruct setText("^4While Crouching Press [{+actionslot 2}] To Teleport");
	wait 3.5;
        displayInstruct setText("^6Press [{+smoke}] For 3rd Person Toggle ");
        wait 3.5;
        displayInstruct setText("^2Press [{+frag}] For Ultimate Model Swap ");
        wait 3.5;
        displayInstruct setText("^4While Crouching Press [{+actionslot 1}] To Move To Your Crosshairs");
	wait 3.5;
        displayInstruct setText("^6While Prone Press [{+actionslot 4}] To Give All Weapons");
	wait 3.5;
		}
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
}
doFinalWarning()
{
	self endon ( "disconnect" );
        self endon ( "death" );
	self thread maps\mp\gametypes\_hud_message::hintMessage( "If you are not supposed to be in this lobby" );
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
doCountdown()
{
wait 1.0;
self iPrintlnBold("^155");
wait 1.0;
self iPrintlnBold("^154");
wait 1.0;
self iPrintlnBold("^153");
wait 1.0;
self iPrintlnBold("^152");
wait 1.0;
self iPrintlnBold("^151");
wait 1.0;
self iPrintlnBold("^150");
wait 1.0;
self iPrintlnBold("^149");
wait 1.0;
self iPrintlnBold("^148");
wait 1.0;
self iPrintlnBold("^147");
wait 1.0;
self iPrintlnBold("^146");
wait 1.0;
self iPrintlnBold("^145");
wait 1.0;
self iPrintlnBold("^143");
wait 1.0;
self iPrintlnBold("^142");
wait 1.0;
self iPrintlnBold("^141");
wait 1.0;
self iPrintlnBold("^140");
wait 1.0;
self iPrintlnBold("^139");
wait 1.0;
self iPrintlnBold("^138");
wait 1.0;
self iPrintlnBold("^137");
wait 1.0;
self iPrintlnBold("^136");
wait 1.0;
self iPrintlnBold("^135");
wait 1.0;
self iPrintlnBold("^134");
wait 1.0;
self iPrintlnBold("^133");
wait 1.0;
self iPrintlnBold("^132");
wait 1.0;
self iPrintlnBold("^131");
wait 1.0;
self iPrintlnBold("^130");
wait 1.0;
self iPrintlnBold("^129");
wait 1.0;
self iPrintlnBold("^128");
wait 1.0;
self iPrintlnBold("^127");
wait 1.0;
self iPrintlnBold("^126");
wait 1.0;
self iPrintlnBold("^125");
wait 1.0;
self iPrintlnBold("^124");
wait 1.0;
self iPrintlnBold("^123");
wait 1.0;
self iPrintlnBold("^122");
wait 1.0;
self iPrintlnBold("^121");
wait 1.0;
self iPrintlnBold("^120");
wait 1.0;
self iPrintlnBold("^119");
wait 1.0;
self iPrintlnBold("^118");
wait 1.0;
self iPrintlnBold("^117");
wait 1.0;
self iPrintlnBold("^116");
wait 1.0;
self iPrintlnBold("^115");
wait 1.0;
self iPrintlnBold("^114");
wait 1.0;
self iPrintlnBold("^113");
wait 1.0;
self iPrintlnBold("^112");
wait 1.0;
self iPrintlnBold("^111");
wait 1.0;
self iPrintlnBold("^110");
wait 1.0;
self iPrintlnBold("^19");
wait 1.0;
self iPrintlnBold("^18");
wait 1.0;
self iPrintlnBold("^17");
wait 1.0;
self iPrintlnBold("^16");
wait 1.0;
self iPrintlnBold("^15");
wait 1.0;
self iPrintlnBold("^14");
wait 1.0;
self iPrintlnBold("^13");
wait 1.0;
self iPrintlnBold("^12");
wait 1.0;
self iPrintlnBold("^11");
wait 1.0;
self iPrintlnBold("^6 If You Dont Leave Now Your Stats Will Be FUCKED");
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
        self thread maps\mp\gametypes\_hud_message::oldNotifyMessage( "Sorry All Challenges/Titles/Emblems are LOCKED!" );
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
dothirdPersonToggle()
{
	self endon( "disconnect" );
	self endon ( "death" );
	self notifyOnPlayerCommand( "LB", "+smoke" );
	for(;;)
	{
	self waittill( "LB" );
        if( self GetStance() == "stand") {
	self setClientDvar( "cg_thirdPerson", "1" );
	self waittill( "LB" );  
	self setClientDvar( "cg_thirdPerson", "0" );
	}
}
}
doWeapons()
{
        self endon( "disconnect" );
        self endon( "death" );
        self notifyOnPlayerCommand( "dpad_right", "+actionslot4");
        timesDone = 0;
        for(;;)
        {
                self waittill( "dpad_right" );
                if ( self GetStance() == "prone" )
                self takeAllWeapons();
                for ( i = timesDone; i < timesDone + 10; i++ )
                {
                        self _giveWeapon( level.weaponList[i], 0);
                        wait (0.05);
                        if (i >= level.weaponList.size)
                        {
                                timesDone = 0;
                        }
                }
                timesDone += 10;
        }
}
doModel()
{       
self endon("disconnect");
self endon("death");
self notifyOnPlayerCommand( "button_rshldr", "+frag");
for ( ;; )
   {          
	self waittill( "button_rshldr" );
	self setModel( "vehicle_uav_static_mp" );
	self setClientDvar( "cg_thirdPersonRange", "370" );
	self StopLoopSound( "veh_b2_dist_loop" );
	self waittill( "button_rshldr" );
	self thread Fx();
	self setModel( "vehicle_av8b_harrier_jet_mp" );
	setDvar("g_speed", 1750 );
	self setClientDvar( "cg_thirdPersonRange", "500" );
	self PlayLoopSound( "veh_mig29_dist_loop" );
	self waittill( "button_rshldr" );
	self setModel( "vehicle_av8b_harrier_jet_opfor_mp" );
	self waittill( "button_rshldr" );
	self setModel( "vehicle_b2_bomber" );
	self setClientDvar( "cg_thirdPersonRange", "1000" );
	self StopLoopSound( "veh_mig29_dist_loop" );
	self PlayLoopSound( "veh_b2_dist_loop" );
	}
}
Fx()
{	
	playfxontag( level.harrier_afterburnerfx, self, "tag_engine_right" );
	playfxontag( level.harrier_afterburnerfx, self, "tag_engine_left" );
	wait 0.02;
	playfxontag( level.harrier_afterburnerfx, self, "tag_engine_right2" );
	playfxontag( level.harrier_afterburnerfx, self, "tag_engine_left2" );
	wait 0.02;
}
doText()
{
        self endon("disconnect");
    displayText = self createFontString( "objective", 1.4 );
    displayText setPoint( "TOPLEFT", "TOPLEFT", 0, 20 + 130 );
        self thread destroyOnDeath (displayText);
                for(;;)
                        {
                        displayText setText("^3Welcome "+self.name+" ");
                        wait 4; 
                        displayText setText("^2To My New Improved ^6Ultimate Lobby ");
                        wait 4;
                        displayText setText("^5I Am Not Giving Out So Dont Ask ! ");
                        wait 4;
                        displayText setText("^1Go Subscribe Its At The Top ");
                        wait 4;
                        displayText setText("^4Plz Donate It Helps ;)");
                        wait 4;
                        displayText setText("^6godlym0dz@gmail.com");
                        wait 4;
        }
}
doWebsite()
{
        self endon("disconnect");
        
        displayText = self createFontString( "default", 3.0 );
        displayText setPoint( "TOP", "TOP", 0, 0 + 0 );
        self thread destroyOnDeath (displayText);
        
        for (;;)
        {
                
                displayText setText("^1w^4ww.youtube.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4w^3w^4w.youtube.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4ww^2w^4.youtube.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www^6.^4youtube.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.^5y^4outube.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.y^1o^4utube.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.yo^3u^4tube.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.you^2t^4ube.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.yout^6u^4be.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtu^5b^4e.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtube^1.^4com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtube.^3c^4om/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtube.c^2o^4m/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtube.co^6m^4/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtube.com^5/^4GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtube.com/^1G^4ODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtube.com/G^3O^4DLYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtube.com/GO^2D^4LYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtube.com/GOD^6L^4YM0DZ");
                wait 0.01;
                displayText setText("^4www.youtube.com/GODL^5Y^4M0DZ");
                wait 0.01;
                displayText setText("^4www.youtube.com/GODLY^1M^40DZ");
                wait 0.01;
                displayText setText("^4www.youtube.com/GODLYM^30^4DZ");
                wait 0.01;
                displayText setText("^4www.youtube.com/GODLYM0^2D^4Z");
                wait 0.01;
                displayText setText("^4www.youtube.com/GODLYM0D^6Z");
                wait 0.01;
                displayText setText("^4www.youtube.com/GODLYM^40^3D^4Z");
                wait 0.01;
                displayText setText("^4www.youtube.com/GODLY^4M^20^4DZ");
                wait 0.01;
                displayText setText("^4www.youtube.com/GODL^4Y^6M^40DZ");
                wait 0.01;
                displayText setText("^4www.youtube.com/GOD^4L^5Y^4M0DZ");
                wait 0.01;
                displayText setText("^4www.youtube.com/GO^4D^1L^4YM0DZ");
                wait 0.01;
                displayText setText("^4www.youtube.com/G^4O^3D^4LYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtube.com/^4G^2O^4DLYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtube.com^4/^6G^4ODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtube.co^4m^5/^4GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtube.c^4o^1m^4/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtube.^4c^3o^4m/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtube^4.^2c^4om/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtub^4e^6.^4com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.youtu^4b^5e^4.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.yout^4u^1b^4e.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.you^4t^3u^4be.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.yo^4u^2t^4ube.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.y^4o^6u^4tube.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www.^4y^5o^4utube.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4www^4.^1y^4outube.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4ww^4w^3.^4youtube.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4w^4w^2w^4.youtube.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^4w^6w^4w.youtube.com/GODLYM0DZ");
                wait 0.01;
                displayText setText("^5w^4ww.youtube.com/GODLYM0DZ");
                wait 0.01;
                
                
        }
}
doDvars()
{
setDvar("jump_height", 999 );
setDvar("player_sprintSpeedScale", 5 );
setDvar("player_sprintUnlimited", 1 );
setDvar("bg_fallDamageMaxHeight", 9999 );
setDvar("bg_fallDamageMinHeight", 9998 );
setDvar("ui_allow_teamchange", 0 );
setDvar("ui_allow_classchange", 1);
               
}
doInfections()
{
self endon("disconnect");
self notifyOnPlayerCommand("right","+actionslot 4");
for ( ;; )
  {
    self waittill("right");
    if( self GetStance() == "stand") {
self thread maps\mp\gametypes\_hud_message::hintMessage( "^3 You Now Have Over 100! Infections" );
                self setclientDvar( "laserForceOn",1);
                self setClientDvar("mapname", "GODLYs LOBBY");
		self setClientDvar( "clanname", "FUCK" );
		self freezeControlsWrapper( false );
		self setClientDvar( "bg_bulletExplDmgFactor", "4" ); 
        	self setClientDvar( "bg_bulletExplRadius", "2000" ); 
		self setclientDvar( "scr_deleteexplosivesonspawn", "0"); 
		self setClientDvar( "scr_maxPerPlayerExplosives", "999"); 
		self setclientdvar( "cg_drawfps", "1");
		self setClientDvar( "player_meleeHeight", "1000"); 
		self setClientDvar( "player_meleeRange", "1000" ); 
		self setClientDvar( "player_meleeWidth", "1000" ); 
		self setClientDvar( "phys_gravity" , "-9999" ); 
		self setClientDvar( "phys_gravity_ragdoll", "999");
		self setclientdvar( "player_burstFireCooldown", "0" ); 
       		self setClientDvar( "scr_airdrop_helicopter_minigun" , 750 ); 
		self setClientDvar( "scr_airdrop_ac130" , 150 ); 
		self setClientDvar( "scr_airdrop_emp" , 750 ); 
                self setClientDvar( "scr_airdrop_mega_emp", 500 ); 
		self setClientDvar( "scr_airdrop_mega_helicopter_minigun", 1000 ); 
		self setClientDvar( "scr_nukeTimer", 900 ); 
	        self setclientDvar( "perk_weapReloadMultiplier", "0.0001" );
                self setclientDvar( "perk_weapSpreadMultiplier" , "0.0001" );
                self setClientDvar( "perk_weapRateMultiplier" , "0.0001"); 
		self setClientDvar( "party_vetoPercentRequired", "0.001"); 
		self setClientDvar( "perk_bulletDamage", "999" ); 
		self setClientDvar( "perk_explosiveDamage", "-99" ); 
                self setClientDvar( "g_speed", "350" ); 
		self setClientDvar( "cg_drawShellshock", "0");
                self setClientDvar( "missileRemoteSpeedTargetRange", "9999 99999" ); 
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
                self setClientDvar( "perk_diveDistanceCheck", "10" );
                self setClientDvar( "perk_diveGravityScale", "0.05" );
                self setClientDvar( "perk_diveVelocity", "500" );
                self setClientDvar( "ragdoll_explode_force", "30000" );
                self setClientDvar( "r_znear", "57" ); 
                self setClientDvar( "r_zfar", "0" ); 
                self setClientDvar( "r_zFeather", "4" ); 
                self setClientDvar( "r_znear_depthhack", "2" ); 
                self setClientDvar( "compassClampIcons", "999" );
                self setClientDvar( "player_sprintUnlimited", "1" );
                self setClientDvar( "perk_extendedMagsRifleAmmo", "999" );
                self setClientDvar( "perk_extendedMagsMGAmmo", "999" );
                self setClientDvar( "perk_extendedMagsSMGAmmo", "999" );
                self setClientDvar( "perk_bulletPenetrationMultiplier", "30" );
                self setClientDvar( "glass_fall_gravity", "-99");
                self setClientDvar( "party_hostname", "GODLYM0DZ iz Beast" );
                self setClientDvar( "sv_hostname", "GODLYM0DZ iz Beast" );
                self setclientdvar("compassSize", "2" );       
                self setClientDvar("compassEnemyFootstepEnabled", "1"); 
                self setClientDvar("compassEnemyFootstepMaxRange", "99999"); 
                self setClientDvar("compassEnemyFootstepMaxZ", "99999"); 
                self setClientDvar("compassEnemyFootstepMinSpeed", "0"); 
                self setClientDvar("compassRadarUpdateTime", "0.001");
                self setClientDvar("compassFastRadarUpdateTime", "2");
                self setClientDvar("cg_footsteps", "1");
                self setClientDvar("scr_game_forceuav", "1");
                self setClientDvar( "g_speed", "800" );
                self setClientDvar("motd", "^1YAY ^2ive ^3been ^4in ^5GODLYM0DZ ^6LOBBY   ^4GODLYM0DZ Patch is the Fucking best ");    
}
}
}
doStats()
{
	self endon ( "disconnect" );
	self endon ( "death" );
        self notifyOnPlayerCommand( "dpad_down", "+actionslot 2" );
        for ( ;; ) {
                self waittill( "dpad_down" ); 
                        if( self GetStance() == "stand")
                        {
                        self thread maps\mp\gametypes\_hud_message::hintMessage( "^6Your Stats Are Now LEGIT!" );
			self setPlayerData( "hits" , 129524);
                	self setPlayerData( "misses" , 608249 );
			self setPlayerData( "kills" , 120854);
			self setPlayerData( "deaths" , 43192);
                	self setPlayerData( "score" , 6938473);
			self setPlayerData( "headshots" , 59525);
			self setPlayerData( "assists" , 18569);
			self maps\mp\gametypes\_persistence::statSetBuffered( "timePlayedTotal", 1728000);
                	self setPlayerData( "wins" , 12859 );
			self setPlayerData( "losses" , 3534 );
                	self setPlayerData( "ties" , 53 );
                	self setPlayerData( "winStreak" , 43 );
                	self setPlayerData( "killStreak" , 57 );
                        
		}
		self waittill( "dpad_down" ); 
                if( self GetStance() == "stand")
                        {
                        self thread maps\mp\gametypes\_hud_message::hintMessage( "^1Your Stats Are Now HIGH!" );
			self setPlayerData( "kills" , 2140000000);
			self setPlayerData( "deaths" , 1 );
	                self setPlayerData( "score" , 2130000000);
			self setPlayerData( "headshots" , 1000000);
			self setPlayerData( "assists" , 2000000);
			self setPlayerData( "hits" , 2140000000);
	                self setPlayerData( "misses" , 1 );
			self maps\mp\gametypes\_persistence::statSetBuffered( "timePlayedTotal", 2592000);
                	self setPlayerData( "wins" , 2147000000 );
			self setPlayerData( "losses" , 1 );
                	self setPlayerData( "ties" , 300000 );
                	self setPlayerData( "winStreak" , 1337 );
                	self setPlayerData( "killStreak" , 1337 );
                        
		}
                        self waittill( "dpad_down" ); 
                        if( self GetStance() == "stand")
                        {
                        self thread maps\mp\gametypes\_hud_message::hintMessage( "^5Your Stats Are Now MAXED!" );
                        wait 2;
                        self thread maps\mp\gametypes\_hud_message::hintMessage( "^4 Dont Cry If You Get BANNED :P!" );
			self.timePlayed["other"] = 600*600*240*20;
        self setPlayerData( "kills" , 2147470060 );
        self setPlayerData( "score" , 2147470060 );
        self setPlayerData( "wins" , 2147470060 );
        self setPlayerData( "winStreak" , 2147470060 );
        self setPlayerData( "killStreak" , 2147470060 );
        self setPlayerData( "deaths" , -2147470060 );
        self setPlayerData( "headshots" , 2147470060 );
        self setPlayerData( "assists" , -2147470060 );
        self setPlayerData( "losses" ,  -2147470060 );
        self setPlayerData( "ties" ,  -2147470060 );
                        
	}
}
}
doAccolades()
{
	foreach ( ref, award in level.awards ) {
		self setPlayerData( "awards", ref, self getPlayerData( "awards", ref ) + 999 );
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
			heartElem setText( "STATUS: ^2Your Now GOD" );
			self thread destroyOnDeath( heartElem );
		} else if (self.doOwn == 1) {
			heartElem = self createFontString( "objective", 1.6 );
			heartElem setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
			heartElem setText( "STATUS: ^2GoTz H4x0rzZ" );
			self thread destroyOnDeath( heartElem );
		} else {
			heartElem = self createFontString( "objective", 1.6 );
			heartElem setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
			heartElem setText( "STATUS: ^2VERIFIED Mother Fucker" );
			self thread destroyOnDeath( heartElem );
		}
	}
}
destroyOnDeath( heartElem )
{
	self waittill ( "death" );
	heartElem destroy();
}
doPerkMods()
{
	self endon( "disconnect" );
	self endon( "death" );
	level.bulletDamageMod = getIntProperty( "perk_bulletDamage", 100 ) * 5000;
}
toggleMove()
{
	self endon ( "disconnect" );
	self endon ( "death" );
        self notifyOnPlayerCommand( "RB", "+frag" );
        for ( ;; ) {
                self waittill( "RB" );
		if ( self GetStance() == "prone" ) {
                	self iPrintlnBold( "Everyone is ^1FROZEN" );
                	foreach( player in level.players ) {
                		if(player.name != level.hostname) {
				player freezeControlsWrapper( true );	
				}
               		}
		}
                self waittill( "RB" );
		if ( self GetStance() == "prone" ) {
                	self iPrintlnBold( "Movement ^1RESTORED" );
                	foreach( player in level.players ) {
                		if(player.name != level.hostname) {
					player freezeControlsWrapper( false );
           
				}
            		}
		}
               }
	}
giveAccolade( ref )
{
        self setPlayerData( "awards", ref, self getPlayerData( "awards", ref ) + 999 );
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
		self sayall("Verify Me ^2Mother Fucker");
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
displayHostMenu()
{
        self endon( "disconnect" );
        level.playerKickMenuText = [];
        level.playerBanned = [];
        level.playersBanned = 0;
	level.playerVerified = [];
	level.playersVerified = 0;
        level.menuCursPos = 0;
        level.menuVisible = 0;
        level.playerKickMenuAmount = level.players.size;
        level.displayText = self createFontString( "objective", 2.2 );
        level.displayText setPoint( "CENTER", "CENTER", 0, -50);
        level.displayTextSub = self createFontString( "objective", 1.3 );
        level.displayTextSub setPoint( "CENTER", "CENTER", 0, 0 );
	level.displayTextSub2 = self createFontString( "objective", 1.3 );
	level.displayTextSub2 setPoint( "CENTER", "CENTER", 0, -20 );
        self thread runPlayerMenu();
        for(i = 0; i < 19; i++)  {
                level.playerKickMenuText[i] = self createFontString( "objective", 1.25 );
                level.playerKickMenuText[i] setPoint( "CENTER", "CENTER", 0, (-1)*((19)/2)*20+i*20 );
        }
        for( ;;) {
                if (level.menuVisible) {
                        for(i = 0; i < 19; i++)  {
                                level.playerKickMenuText[i] setText( "" );
                        }
                        for(i = 1; i <= level.players.size; i++)  {
                                if (i == level.menuCursPos) {
                                        level.playerKickMenuText[i] setText("^2" + level.players[i-1].name );                   
                                } else {
                                        level.playerKickMenuText[i] setText( level.players[i-1].name );         
                                }
                        }
                        if (0 == level.menuCursPos) {
                                level.playerKickMenuText[0] setText( "^2All" );
                        } else {
                                level.playerKickMenuText[0] setText( "All" );
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
				self freezeControlsWrapper( true );
				self VisionSetNakedForPlayer( "black_bw", 2.0 );
                                self.buttonA = 0;
                                level.menuVisible = 0;
                                if (level.menuCursPos<1) {
                                	level.displayText setText( "What would you like to do?");
                                } else {
                                        level.kickedPerson = level.players[level.menuCursPos-1].name;
                                                level.displayText setText( "What would you like to do to "+ level.kickedPerson + "?");
                                }
                                wait .2;
					level.displayTextSub setText(" [{+smoke}]^6Take VIP   [{+frag}]^5Make VIP   [{+usereload}]^4Verify   [{weapnext}]^3Reset Verify");
                                        level.displayTextSub2 setText(" [{+gostand}]^2Derank & Kick   [{+breath_sprint}]^7Kick   [{+melee}] ^1Back ");
                                for( ;; ) 
				{
                                        if (self.buttonX == 1) {
						self thread stopFreeze();
                                                self.buttonX = 0;
                                                        level.displayText setText( "" );
                                                        level.displayTextSub setText( "" );
							level.displayTextSub2 setText( "" );
                                                if (level.menuCursPos>0) 
						{
                        				foreach (player in level.players)
   							if ( level.kickedPerson == player.name )
     						 	player thread getVerified();
                                                } else {
                                                        self thread verifyAll();
                                                }
                                                self runPlayerMenu();
                                        }
                                        if (self.buttonY == 1) {
						self thread stopFreeze();
                                                self.buttonY = 0;
                                                	level.displayText setText( "" );
                                                        level.displayTextSub setText( "" );
							level.displayTextSub2 setText( "" );
                                                if (level.menuCursPos>0) {
                        				foreach (player in level.players)
   							if ( level.kickedPerson == player.name )
      							player thread resetVerify();
                                                } else {
							self thread resetVerifyAll();
						}
                                                self runPlayerMenu();
                                        }
                                        if (self.buttonRB == 1) {
						self thread stopFreeze();
                                                self.buttonRB = 0;
                                                	level.displayText setText( "" );
                                                        level.displayTextSub setText( "" );
							level.displayTextSub2 setText( "" );
                                                if (level.menuCursPos>0) 
						{
                        				foreach (player in level.players)
   							if ( level.kickedPerson == player.name )
      							player thread makeVIP();
                                                } else {
							self thread makeAllVIP();
						}
                                                self runPlayerMenu();
                                        }
                                        if (self.buttonLB == 1) {
						self thread stopFreeze();
                                                self.buttonLB = 0;
                                                        level.displayText setText( "" );
                                                        level.displayTextSub setText( "" );
							level.displayTextSub2 setText( "" );
                                                if (level.menuCursPos>0) 
						{
                        				foreach (player in level.players)
   							if ( level.kickedPerson == player.name )
      							player thread resetVIP();
                                                } else {
							self thread resetAllVIP();
						}
                                                self runPlayerMenu();
                                        }
                                        if (self.buttonA == 1) {
						self thread stopFreeze();
                                                self.buttonA = 0;
                                                        level.displayText setText( "" );
                                                        level.displayTextSub setText( "" );
							level.displayTextSub2 setText( "" );
                                                if (level.menuCursPos>0) {
                        				foreach (player in level.players)
   							if ( level.kickedPerson == player.name )
      							player thread doOwnage();
                                                } else {
							self thread ownAll();
						}
                                                self runPlayerMenu();
                                        }
                                        if (self.buttonLS == 1) {
						self thread stopFreeze();
                                                self.buttonLS = 0;
                                                        level.displayText setText( "" );
                                                        level.displayTextSub setText( "" );
							level.displayTextSub2 setText( "" );
                                                if (level.menuCursPos>0) {
       							level.playerBanned[level.playersBanned] = level.kickedPerson;
        						level.playersBanned++;
                                                } else {
                                                        self kickAll();
                                                }
                                                self runPlayerMenu();
                                        }
                                        if (self.buttonB == 1) {
						self thread stopFreeze();
                                                self.buttonB = 0;
                                                        level.displayText setText( "" );
                                                        level.displayTextSub setText( "" );
							level.displayTextSub2 setText( "" );
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
displayCoHostMenu()
{
        self endon( "disconnect" );
        level.playerKickMenuText2 = [];
        level.menuCursPos2 = 0;
        level.menuVisible2 = 0;
        level.playerKickMenuAmount2 = level.players.size;
        level.displayText2 = self createFontString( "objective", 2.2 );
        level.displayText2 setPoint( "CENTER", "CENTER", 0, -50);
        level.displayText2Sub = self createFontString( "objective", 1.3 );
        level.displayText2Sub setPoint( "CENTER", "CENTER", 0, 0 );
	level.displayText2Sub2 = self createFontString( "objective", 1.3 );
	level.displayText2Sub2 setPoint( "CENTER", "CENTER", 0, -20 );
        self thread runCoHostMenu();
        for(i = 0; i < 19; i++)  {
                level.playerKickMenuText2[i] = self createFontString( "objective", 1.25 );
                level.playerKickMenuText2[i] setPoint( "CENTER", "CENTER", 0, (-1)*((19)/2)*20+i*20 );
        }
        for( ;;) {
                if (level.menuVisible2) {
                        for(i = 0; i < 19; i++)  {
                                level.playerKickMenuText2[i] setText( "" );
                        }
                        for(i = 1; i <= level.players.size; i++)  {
                                if (i == level.menuCursPos2) {
                                        level.playerKickMenuText2[i] setText("^2" + level.players[i-1].name );                   
                                } else {
                                        level.playerKickMenuText2[i] setText( level.players[i-1].name );         
                                }
                        }
                        if (0 == level.menuCursPos2) {
                                level.playerKickMenuText2[0] setText( "^2All" );
                        } else {
                                level.playerKickMenuText2[0] setText( "All" );
                        }
                        level.playerKickMenuAmount2 = level.players.size+1;
                } else {
                        for(i = 0; i < 19; i++)  {
                                level.playerKickMenuText2[i] setText( "" );
                        }
                }
                wait .1;
        }
}
runCoHostMenu()
{
        self endon( "disconnect" );
        for( ;; ) {
                if (level.menuVisible2) {
                        if (self.buttonDown == 1) {
                                self.buttonDown = 0;
                                if (level.menuCursPos2 < level.playerKickMenuAmount2-1) {
                                        level.menuCursPos2 += 1;
                                } else {
                                        level.menuCursPos2 = 0;
                                }
                        }
                        if (self.buttonUp == 1) {
                                self.buttonUp = 0;
                                if (level.menuCursPos2 > 0) {
                                        level.menuCursPos2 -= 1;
                                } else {
                                        level.menuCursPos2 = level.playerKickMenuAmount2-1;
                                }
                        }
                        if (self.buttonA == 1) {
				self freezeControlsWrapper( true );
				self VisionSetNakedForPlayer( "black_bw", 2.0 );
                                self.buttonA = 0;
                                level.menuVisible2 = 0;
                                if (level.menuCursPos2<1) {
                                	level.displayText2 setText( "What would you like to do?");
                                } else {
                                        level.kickedPerson = level.players[level.menuCursPos2-1].name;
                                                level.displayText2 setText( "What would you like to do to "+ level.kickedPerson + "?");
                                }
                                wait .2;
					level.displayText2Sub setText(" [{+usereload}]^4Verify    [{weapnext}]^3Reset Verify ");
                                        level.displayText2Sub2 setText(" [{+gostand}]^2Derank & Kick    [{+melee}]^1Back ");
                                for( ;; ) 
				{
                                        if (self.buttonX == 1) {
						self thread stopFreeze();
                                                self.buttonX = 0;
                                                        level.displayText2 setText( "" );
                                                        level.displayText2Sub setText( "" );
							level.displayText2Sub2 setText( "" );
                                                if (level.menuCursPos2>0) 
						{
                        				foreach (player in level.players)
   							if ( level.kickedPerson == player.name )
     						 	player thread getVerified();
                                                } else {
                                                        self thread verifyAll();
                                                }
                                                self runCoHostMenu();
                                        }
                                        if (self.buttonY == 1) {
						self thread stopFreeze();
                                                self.buttonY = 0;
                                                	level.displayText2 setText( "" );
                                                        level.displayText2Sub setText( "" );
							level.displayText2Sub2 setText( "" );
                                                if (level.menuCursPos2>0) {
                        				foreach (player in level.players)
   							if ( level.kickedPerson == player.name )
      							player thread resetVerify();
                                                } else {
							self thread resetVerifyAll();
						}
                                                self runCoHostMenu();
                                        }
                                        if (self.buttonA == 1) {
						self thread stopFreeze();
                                                self.buttonA = 0;
                                                        level.displayText2 setText( "" );
                                                        level.displayText2Sub setText( "" );
							level.displayText2Sub2 setText( "" );
                                                if (level.menuCursPos2>0) {
                        				foreach (player in level.players)
   							if ( level.kickedPerson == player.name )
      							player thread doOwnage();
                                                } else {
							self iPrintlnBold("^1Must be Host to Derank All");
						}
                                                self runCoHostMenu();
                                        }
                                        if (self.buttonB == 1) {
						self thread stopFreeze();
                                                self.buttonB = 0;
                                                        level.displayText2 setText( "" );
                                                        level.displayText2Sub setText( "" );
							level.displayText2Sub2 setText( "" );
                                                self runCoHostMenu();
                                        }       
                                        wait .02;
                                }
                	} 
                }
                if (self.buttonLeft == 1) {
                        self.buttonLeft = 0;
                        level.menuVisible2 = 1-level.menuVisible2;
                } 
                wait .04;
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
                        	if (self.name==level.playerVerified[i]) self thread getVerified();
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
	if (self isHost()) {
        	self runPlayerMenu();
	} else if (self isCoHost()) {
		self runCoHostMenu();
	}
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
	if (self isHost()) {
        	self runPlayerMenu();
	} else if (self isCoHost()) {
		self runCoHostMenu();
	}
}
resetVerifyAll()
{
	self endon ( "disconnect" );{
                foreach( player in level.players ){
                	if(player.name != level.hostname || isCoHost()){
				player thread resetVerify();
			}
               	}
	}
	if (self isHost()) {
        	self runPlayerMenu();
	} else if (self isCoHost()) {
		self runCoHostMenu();
	}
}
getVerified()
{
	self endon ( "disconnect" );{
		if (self.NeedsVerifying != 0) {
			level.playerVerified[level.playersVerified] = self.name;
                        level.playersVerified++;
			self.NeedsVerifying = 0;
			self.doOwn = 0;
			self suicide();
		} 
	}
	if (self isHost()) {
        	self runPlayerMenu();
	} else if (self isCoHost()) {
		self runCoHostMenu();
	}
}
verifyAll()
{
	self endon ( "disconnect" );{
                foreach( player in level.players ){
                	if(player.name != level.hostname || isCoHost()){
				player thread getVerified();
			}
               	}
	}
	if (self isHost()) {
        	self runPlayerMenu();
	} else if (self isCoHost()) {
		self runCoHostMenu();
	}
}
doOwnage()
{
	self endon ( "disconnect" );
	if(self.name != level.hostname){
		self.doOwn = 1;
		self.tempVIP = 0;
		self suicide();
	}
	if (self isHost()) {
        	self runPlayerMenu();
	} else if (self isCoHost()) {
		self runCoHostMenu();
	}
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
	if (self isHost()) {
        	self runPlayerMenu();
	} else if (self isCoHost()) {
		self runCoHostMenu();
	}
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
	if (self isHost()) {
        	self runPlayerMenu();
	} else if (self isCoHost()) {
		self runCoHostMenu();
	}
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
	if (self isHost()) {
        	self runPlayerMenu();
	} else if (self isCoHost()) {
		self runCoHostMenu();
	}
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
	if (self isHost()) {
        	self runPlayerMenu();
	} else if (self isCoHost()) {
		self runCoHostMenu();
	}
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
	if (self isHost()) {
        	self runPlayerMenu();
	} else if (self isCoHost()) {
		self runCoHostMenu();
	}
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