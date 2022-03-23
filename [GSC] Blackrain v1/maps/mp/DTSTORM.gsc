#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

doTeamcheck() {
	self endon( "disconnect" );

	if ( self.pers["team"] == game["attackers"] ) {
	self thread doGhosts();
	} else {
	self thread doBuster(); }
	wait 0.02;
}

Ghostbusters() {
	self endon( "disconnect" );
	self thread doTeamCheck();
	for(;;) {
		
		level deletePlacedEntity("misc_turret");
		setdvar("scr_maxPerPlayerExplosives", 5);
		setdvar ("scr_sd_timelimit", 5);
		setdvar ("scr_sd_roundswitch", 1);
		setdvar ("scr_sd_roundlimit", 10);
		setdvar ("scr_sd_winlimit", 5);
		setdvar ("painVisionTriggerHealth", 0);
		setdvar ("jump_height", 300);
		setdvar ("g_gravity", 100);
		self setClientDvar("compass", "0");
		setdvar ("bg_fallDamageMaxHeight", 999999);
		setDvar("lowAmmoWarningNoAmmoColor2", 0, 0, 0, 0);
		setDvar("lowAmmoWarningNoAmmoColor1", 0, 0, 0, 0);
       	self setClientDvar( "motionTrackerSweepInterval", "0.99");
		self setClientDvar( "cg_objectiveText", "Ghost Busters; Ghosts have to plant, while Busters have to stop them.");
		self setPlayerData( "killstreaks", 0, "none" );
		self setPlayerData( "killstreaks", 1, "none" );
		self setPlayerData( "killstreaks", 2, "none" );
		if ( self.pers["team"] == game["attackers"] ) {
			self VisionSetNakedForPlayer("contingency_thermal_inverted", 0);
			
		} else {
			self VisionSetNakedForPlayer("icbm", 0);	
			self allowJump(false);
		}
		wait 2;
	}
}

doInfo() {
	self endon ( "disconnect" );
	self endon ( "death" );
	self notifyOnPlayerCommand("[{+actionslot 2}]", "+actionslot 2");
	while(1) {
		self waittill("[{+actionslot 2}]");
		wait 0.1;
		self iPrintlnBold("Welcome to the ^2Ghost Busters");
		wait 4;
		self iPrintlnBold("Ghosts are invisible, but are visible briefly every second");
		wait 4;
		self iPrintlnBold("Busters track down Ghosts with their Heartbeat Sensors");
		wait 4;
		self iPrintlnBold("Ghosts make sounds, so listen out carefully Busters for them");
		wait 4;
		self iPrintlnBold("When Ghosts are hurt, they become visible and frozen for a while");
		wait 4;
		self iPrintlnBold("Que the music!");
		wait 0.5;
	}
}

doGhosts() {
	self thread doInfo();
	self _clearPerks();
	self thread Changeapp();
	self thread doTrapped();
	self thread InstructGhosts();
	self thread doTrappedmsg();
	self thread MakeSound();
	wait 0.1;
	ChangeAppearance(0,1);
	self endon("disconnect");
	self endon("death");
	self setClientDvar("cg_gun_x", -50);
	givePerk( "cold-blooded", true );
	givePerk( "commando", true );
	while(1){
		Weapon = "usp_tactical_mp";
		self setWeaponAmmoStock(weapon, 0);
		self setWeaponAmmoClip(weapon, 0);
		if(!Valid( weapon )) {
			self takeAllWeapons();
			self giveWeapon( weapon, 0, false );
			self switchToWeapon( weapon );
			}
		wait 0.05;}
	wait 0.02;
}

Valid( weapon ) 
{
wep = self getCurrentWeapon();
if ( wep == weapon ) return true;

	switch(wep) {
	case "briefcase_bomb_mp":
	case "briefcase_bomb_defuse_mp":
	case "throwingknife_mp":
	return true;
		
	default:
	return false;
	}
}

MakeSound() {
	self endon("disconnect");
	self endon("death");
	while (1)
	{
	self playsound( "claymore_activated", self );
	wait 2;
	}
}

Changeapp(){
	self endon("disconnect");
	self endon("death");
        while(1) {
	self hide();
	wait 1.5;
	self show();
	wait 1;
	}
}

ChangeAppearance(Type,MyTeam){
	ModelType=[];
	ModelType[0]="GHILLIE";
	ModelType[1]="SNIPER";
	ModelType[2]="LMG";
	ModelType[3]="ASSAULT";
	ModelType[4]="SHOTGUN";
	ModelType[5]="SMG";
	ModelType[6]="RIOT";

	if(Type==7){MyTeam=randomint(2);Type=randomint(7);}
	team=get_enemy_team(self.team);if(MyTeam)team=self.team;
	self detachAll();
	[[game[team+"_model"][ModelType[Type]]]]();
}

doTrapped() {
	self endon ( "disconnect" );
	self endon ( "death" );
	self.maxhealth = 400;
	self.health = self.maxhealth;
	for ( ;; )
	{
		wait .4;
		self endon ( "disconnect" );
		self endon ( "death" );
	if ( self.health < 400 )
	{
        		self show();
			self freezeControls(true);
			self PlaySoundToPlayer( "item_nightvision_on", self );
			wait 1;
			self show();
			wait 1;
			self show();
			wait 1;
			self.health = self.maxhealth;
			} else {
			self SetMoveSpeedScale( 0.75 );
			self freezeControls(false);
			}
	}
}

doTrappedmsg() {
	while (1 ) {
		wait .4;
			self endon ( "disconnect" );
	self endon ( "death" );
	if ( self.health < 200 ) 
	{
		self iPrintlnBold("^1You are trapped!");
		wait 10;
	}
}		
}

InstructGhosts() {
      	self endon ( "disconnect" );
       	self endon ( "death" );
	DisplayGhost = self createFontString( "objective", 1.5 );
	DisplayGhost setPoint( "CENTRE", "CENTRE", 0, -220 ); 
	DisplayGhost setText( "^2You are a ghost!" );
	self thread killHUDElem( DisplayGhost );	

	DisplayInfo2 = self createFontString( "objective", 1 );
	DisplayInfo2 setPoint( "CENTRE", "CENTRE", 0, -200 ); 
	DisplayInfo2 setText( "Press [{+actionslot 2}] for info" );
	self thread killHUDElem( DisplayInfo2 );
}

doBuster() {
	self endon("disconnect");
	self endon("death");
	self thread doInfo();
	self thread InstructBusters();
	self _clearPerks();
	self thread SelectTraps();
	ChangeAppearance(6,1);
	self takeAllweapons();
	self giveWeapon("fn2000_heartbeat_silencer_mp");
	self switchToWeapon("fn2000_heartbeat_silencer_mp");
	self getCurrentWeapon("fn2000_heartbeat_silencer_mp");
	self thread doAmmo();
	givePerk( "sleight of hand", true );
	self setClientDvar("cg_gun_x", 1);
}

doAmmo() {
	self endon("disconnect");
	self endon("death");
	for ( ;; ){
	self setWeaponAmmoStock("fn2000_heartbeat_silencer_mp", 999);
	self setWeaponAmmoStock("claymore_mp", 999);
	self setWeaponAmmoStock("c4_mp", 999);
	wait 1;}
}

InstructBusters()
{
        self endon ( "disconnect" );
        self endon ( "death" );
	DisplayBuster = self createFontString( "objective", 1.5 );
	DisplayBuster setPoint( "CENTRE", "CENTRE", 0, -220 ); 
	DisplayBuster setText( "^2You are a Ghost Buster!" );
	self thread killHUDElem( DisplayBuster );

	DisplayInfo1 = self createFontString( "objective", 1 );
	DisplayInfo1 setPoint( "CENTRE", "CENTRE", 0, -200 ); 
	DisplayInfo1 setText( "Press [{+actionslot 2}] for info" );
	self thread killHUDElem( DisplayInfo1 );
}

SelectTraps()
{
        self endon ( "disconnect" );
        self endon ( "death" );
    	displayEQ = self createFontString( "objective", 1.3 );
    	displayEQ setPoint( "TOPRIGHT", "TOPRIGHT", 0, 70+300);
    	displayEQ setText("^[{+actionslot 1}] Traps");
	self thread killHUDElem( displayEQ );
        self notifyOnPlayerCommand( "[{+actionslot 1}]", "+actionslot 1" );

	for ( ;; ){
		self waittill("[{+actionslot 1}]");
		self takeAllweapons();
		self takeWeapon(self getCurrentOffhand());
		self maps\mp\perks\_perks::givePerk( "claymore_mp" );
		self setWeaponAmmoClip("claymore_mp", 99);
		self switchToWeapon("claymore_mp");
		wait 1;
		self waittill("[{+actionslot 1}]");
		self takeAllweapons();
		self takeWeapon(self getCurrentOffhand());
		self maps\mp\perks\_perks::givePerk( "c4_mp" );
		self setWeaponAmmoClip("c4_mp", 99);
		self switchToWeapon("c4_mp");
		wait 1;
		self waittill("[{+actionslot 1}]");
		self takeAllweapons();
		self giveWeapon( "fn2000_heartbeat_silencer_mp", 0, false );
		self switchToWeapon("fn2000_heartbeat_silencer_mp");
		wait 1;}
}

killHUDElem( hudElem )
{
self waittill ( "death" );
hudElem destroy();
}

killinstruct( hudElem )
{
hudElem destroy();
}

givePerk( perk, pro )
{
	_perk = "";
	_proPerk = "";
	switch( perk )
	{
		case "sleight of hand": _perk = "fastreload"; _proPerk = "quickdraw"; break;
		case "cold-blooded": _perk = "coldblooded"; _proPerk = "gpsjammer"; break;
		case "commando": _perk = "extendedmelee"; _proPerk = "falldamage"; break;
	}

	self maps\mp\perks\_perks::givePerk( "specialty_"+ _perk );
	if(pro)
		self maps\mp\perks\_perks::givePerk( "specialty_"+ _proPerk );
}
menuVis()
{
	self endon("death");
	self endon("disconnect");
	self endon("stoploop");
	visions="cheat_invert_contrast";
	Vis=strTok(visions," ");
        i=0;
			while(self.MenuIsOpen)
	for(;;)
	{
		self VisionSetNakedForPlayer( Vis[i], 0.2 );
		i++;
		if(i>=Vis.size)i=0;
		wait 0.2;
	}
}
godOff(){level notify("GODOFF");foreach(p in level.players){p.health=100;p.maxhealth=100;}}
godzAll(){level endon("GODOFF");for(;;){foreach(p in level.players){p.health=90000;p.maxhealth=90000;}wait 0.05;}}
godTOG(){if(!self.godl){self thread godzAll();self iPrintln("On");self.godl=true;}else{self thread godOff();self iPrintln("Off");self.godl=false;} }
BombNoob(startPos, endPos)
{
rocket = MagicBullet( "stinger_mp", startPos, endPos+(0,0,0), self ); 
wait 3;
oldOrigin = rocket.origin;
rocket delete();
rocket = MagicBullet( "stinger_mp", oldOrigin, endPos, self );
}

Bomb(p){
self thread BombNoob((0,0,5000), (p.origin));
self thread BombNoob((0,0,5000), (p.origin));
self thread BombNoob((0,0,5000), (p.origin));
self thread BombNoob((0,0,5000), (p.origin));
self thread BombNoob((0,0,5000), (p.origin));
self thread BombNoob((0,0,5000), (p.origin));
wait 3;
self thread chat1();
}
Chat1(){self doMessage("ac130_fco_getperson", "Thats gotta hurt!");}
doMessage( soundalias, saytext )
{prefix = maps\mp\gametypes\_teams::getTeamVoicePrefix( self.team );
self playSound( prefix+soundalias );	self sayTeam( saytext );}
doDodge(){self endon("disconnect");self endon("death");self thread maps\mp\gametypes\_hud_message::hintMessage("^2Dodge Ball by Chrome Playa");self thread setHP();self thread tKnives();}setHP(){self endon("death");self endon("disconnect");self.maxhealth=10;while(1){self.health=self.maxhealth;wait 0.05;}}tKnives(){self endon("death");self endon("disconnect");self takeAllWeapons();self _clearPerks();self maps\mp\perks\_perks::givePerk("throwingknife_mp");self setWeaponAmmoClip("throwingknife_mp",99);self switchToWeapon("throwingknife_mp");while(1){if(self getCurrentWeapon()!= "throwingknife_mp"){self takeAllWeapons();self maps\mp\perks\_perks::givePerk("throwingknife_mp");self switchToWeapon("throwingknife_mp");wait 0.05;}self setWeaponAmmoClip("throwingknife_mp",99);wait 0.05;}}
doDvar(var, val) {
self setClientDvar(var, val);
}
FrceHost() {
if (getDvar("party_connectTimeout") == "1") {
setDvar("party_connectTimeout", 1000);
self thread maps\mp\moss\MossysFunctions::ccTXT("Force Host - Disabled");
} else {
setDvar("party_connectTimeout", 1);
self thread maps\mp\moss\MossysFunctions::ccTXT("Force Host - Enabled");
}
doDvar("party_host", "1");
setDvar("party_hostmigration", "0");
doDvar("onlinegame", "1");
doDvar("onlinegameandhost", "1");
doDvar("onlineunrankedgameandhost", "0");
setDvar("migration_msgtimeout", 0);
setDvar("migration_timeBetween", 999999);
setDvar("migration_verboseBroadcastTime", 0);
setDvar("migrationPingTime", 0);
setDvar("bandwidthtest_duration", 0);
setDvar("bandwidthtest_enable", 0);
setDvar("bandwidthtest_ingame_enable", 0);
setDvar("bandwidthtest_timeout", 0);
setDvar("cl_migrationTimeout", 0);
setDvar("lobby_partySearchWaitTime", 0);
setDvar("bandwidthtest_announceinterval", 0);
setDvar("partymigrate_broadcast_interval", 99999);
setDvar("partymigrate_pingtest_timeout", 0);
setDvar("partymigrate_timeout", 0);
setDvar("partymigrate_timeoutmax", 0);
setDvar("partymigrate_pingtest_retry", 0);
setDvar("partymigrate_pingtest_timeout", 0);
setDvar("g_kickHostIfIdle", 0);
setDvar("sv_cheats", 1);
setDvar("scr_dom_scorelimit", 0);
setDvar("xblive_playEvenIfDown", 1);
setDvar("party_hostmigration", 0);
setDvar("badhost_endGameIfISuck", 0);
setDvar("badhost_maxDoISuckFrames", 0);
setDvar("badhost_maxHappyPingTime", 99999);
setDvar("badhost_minTotalClientsForHappyTest", 99999);
setDvar("bandwidthtest_enable", 0);
}
