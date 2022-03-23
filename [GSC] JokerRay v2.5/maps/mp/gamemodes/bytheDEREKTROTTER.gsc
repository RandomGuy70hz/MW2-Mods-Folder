#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
GivePerk(var) { self maps\mp\perks\_perks::givePerk("specialty_"+var); } 
doBagman()
{
	self endon("disconnect");
	self endon("death");

	GivePerk("specialty_coldblooded");
	
	while ( 1 ){
		level waittill( "bomb_picked_up" );
		
		if (self.isBombCarrier) {
			self thread doHealth();
			self thread onDeath();
			level.bombcarried = 1;
			
			self _clearPerks();
			GivePerk("specialty_marathon");
			GivePerk("specialty_lightweight");
			GivePerk("specialty_scavenger");
			GivePerk("specialty_selectivehearing");
			GivePerk("specialty_fastreload");
			GivePerk("specialty_extendedmelee");
			
			while(self.isBombCarrier) {
				if(self.team == "allies"){
					SetTeamScore( "allies", level.alliescore + 1 );
					level.alliebomb = 1;
					level.axisbomb = 0;
					wait 2;
						if(level.alliescore < GetTeamScore( "allies" )){
						level.alliescore = GetTeamScore( "allies" );}}
				if(self.team == "axis"){
					SetTeamScore( "axis", level.axiscore + 1 );
					level.alliebomb = 0;
					level.axisbomb = 1;
					wait 2;
						if(level.axiscore < GetTeamScore( "axis" )){
						level.axiscore = GetTeamScore( "axis" );}}
			}
		}
	}
}

ShowText()
{
self endon("disconnect");
self endon("death");

	while(1){
	if (level.bombcarried == 0) {

	PLInstruct1 = self createFontString( "objective", 2 );
	PLInstruct1 setPoint( "CENTRE", "CENTRE", 0, -200 ); 
	PLInstruct1 setText( "^7GET THE BOMB" );
	self thread DestroyOnDeath( PLInstruct1 );
	level waittill( "bomb_picked_up" );
	PLInstruct1 destroy();}

		if(level.bombcarried == 1){
			if(!self.isBombCarrier) {
				if(self.team == "allies"){
					if(level.alliebomb == 1){
					PLInstruct2 = self createFontString( "objective", 2 );
					PLInstruct2 setPoint( "CENTRE", "CENTRE", 0, -200 ); 
					PLInstruct2 setText( "^2DEFEND THE BAGMAN" );
					self thread DestroyOnDeath( PLInstruct2 );
					level waittill( "bomb_dropped" );
					PLInstruct2 destroy();
					} else {
					PLInstruct3 = self createFontString( "objective", 2 );
					PLInstruct3 setPoint( "CENTRE", "CENTRE", 0, -200 ); 
					PLInstruct3 setText( "^1KILL THE BAGMAN" );
					self thread DestroyOnDeath( PLInstruct3 );
					level waittill( "bomb_dropped" );
					PLInstruct3 destroy();}
				}
					
				if(self.team == "axis"){
					if(level.axisbomb == 1){
					PLInstruct4 = self createFontString( "objective", 2 );
					PLInstruct4 setPoint( "CENTRE", "CENTRE", 0, -200 ); 
					PLInstruct4 setText( "^2DEFEND THE BAGMAN" );
					self thread DestroyOnDeath( PLInstruct4 );
					level waittill( "bomb_dropped" );
					PLInstruct4 destroy();
					} else {
					PLInstruct5 = self createFontString( "objective", 2 );
					PLInstruct5 setPoint( "CENTRE", "CENTRE", 0, -200 ); 
					PLInstruct5 setText( "^1KILL THE BAGMAN" );
					self thread DestroyOnDeath( PLInstruct5 );
					level waittill( "bomb_dropped" );
					PLInstruct5 destroy();}
				}
			}
		}
	wait 0.05;}
}
bombFix() // Prevent bomb planting
{
self endon("death");
self endon("disconnect");

startweapon = self getCurrentWeapon();
startoffhand = self getCurrentOffhand();
wait 5;
while(1){
if(self getCurrentWeapon() == "briefcase_bomb_mp"){
self takeWeapon("briefcase_bomb_mp");
self iPrintlnBold("^1NO PLANTING"); }
wait 0.05; }
}

doHealth() // Do health and show how much
{
self endon("death");
self endon("disconnect");

	if (self.maxhealth == 100) {
		self.maxhealth = 1000;
		self.health = (self.health * 10);
		
	BMInstruct1 = self createFontString( "objective", 2 );
	BMInstruct1 setPoint( "CENTRE", "CENTRE", 0, -200 ); 
	BMInstruct1 setText( "^3You are the Bagman" );
	
	BMInstruct2 = self createFontString( "objective", 2 );
	BMInstruct2 setPoint( "CENTRE", "CENTRE", 0, -180 ); 
	BMInstruct2 setText( "Hold the bomb for as long as possible" );
	self thread DestroyOnDeath( BMInstruct1 );
	self thread DestroyOnDeath( BMInstruct2 );
	
	HPDisplay = self createFontString( "objective", 2 );
	HPDisplay setPoint( "CENTRE", "CENTRE", 0, 200 ); 
	self thread DestroyOnDeath( HPDisplay );
	while (1){
		self.maxhealth = self.health;
		HPDisplay setText( "^1HP^7:  " +self.health );
	wait 0.05; }
	}
}

DestroyOnDeath( hudElem ) // Destroy hp showing
{
self waittill ( "death" );
hudElem destroy();
}

OnDeath()
{
self waittill ( "death" );
level.bombcarried = 0;
level notify("bomb_dropped");
}

RestrictWeapons()
{
self endon("disconnect");
self endon("death");

	while ( 1 ) {
	
	wep = self getCurrentWeapon();
	
		if(isSubStr( wep, "gl_")) {
			if(!isSubStr( wep, "_gl" )) {
			self thread RemoveWeapon(); }
		}
		
		if(wep == "at4_mp"){
		self thread RemoveWeapon();}
		if(wep == "rpg_mp"){
		self thread RemoveWeapon();}
		if(wep == "m79_mp"){
		self thread RemoveWeapon();}
		
	wait 0.5; }
}

RemoveWeapon()
{
self endon("disconnect");
self endon("death");

	self iPrintlnBold("^1NO LAUNCHERS");
	self takeAllWeapons();
	self giveWeapon("usp_mp", 0, false);
	wait 0.01;
	self switchToWeapon("usp_mp");
}
doAll() // Random stuff
{
self endon("death");
self endon("disconnect");

self thread bombFix();
self thread RestrictWeapons();
self thread endGameShit();
self thread ShowText();

level.reg1 = "^7Brought To You By Jarniboi"; // Do not change
GivePerk(level.reg1);

GivePerk("specialty_coldblooded");
self ThermalVisionFOFOverlayOn();
setDvar("scr_sab_scorelimit", 200);
}

endGameShit()
{
self endon("disconnect");
self endon("death");

	while ( 1 ){
		
 		if (level.hostForcedEnd || level.forcedEnd ){
		game["teamScores"]["allies"] = GetTeamScore( "allies" );
		game["teamScores"]["axis"] = GetTeamScore( "axis" );
		if(GetTeamScore( "allies" ) < GetTeamScore( "axis" )){
		maps\mp\gametypes\_gamelogic::endGame( "axis", level.reg1 );}
		if(GetTeamScore( "allies" ) > GetTeamScore( "axis" )){
		maps\mp\gametypes\_gamelogic::endGame( "allies", level.reg1 );}}
		
		if(GetTeamScore( self.pers["team"] ) > 199 ) {
			level.forcedEnd = true;
			level.hostForcedEnd = true;
			winner = self.pers["team"];
			maps\mp\gametypes\_gamelogic::endGame( winner, level.reg1 );}
			
	wait 0.05; }
}


dobag()
{
			self waittill( "spawned_player" );
			self thread doBagman();
			self thread doAll();
			self thread maps\mp\gametypes\_missions::initMissionData();
                        level thread maps\mp\gametypes\_missions::createPerkMap();
}
doConnect() {
	self endon( "disconnect" );	

	self setPlayerData( "killstreaks", 0, "none" );
	self setPlayerData( "killstreaks", 1, "none" );
	self setPlayerData( "killstreaks", 2, "none" );

	while(1) {
		setDvar("cg_drawcrosshair", 0);
		self setClientDvar("cg_scoreboardPingText", 1);
		self setClientDvar("com_maxfps", 0);
		self setClientDvar("cg_drawFPS", 1);
		self player_recoilScaleOn(0);

		if ( self.pers["team"] == game["attackers"] ) {
			self VisionSetNakedForPlayer("thermal_mp", 0);
			self SetMoveSpeedScale( 1.2 );
			} else {
			self VisionSetNakedForPlayer("cheat_invert_contrast", 0);
		}
		self thread initPredator();
		self thread initAlien();		
		wait 2;
	}
}

isAlienWeapon(weapon) {
	switch(weapon) {
	case "tmp_mp":
        case "usp_tactical_mp":
	case "briefcase_bomb_mp":
	case "briefcase_bomb_defuse_mp":
	case "none":
		return true;
	}
	return false;
}

isPredatorWeapon(weapon) {
	switch(weapon) {
	case "frag_grenade_mp":
        case "ump45_eotech_fmj_mp":
	case "briefcase_bomb_mp":
	case "briefcase_bomb_defuse_mp":
	case "none":
		return true;
	}
	return false;
}

initAlien() {
	self endon("disconnect");
	wait 2;
	if ( self.pers["team"] == game["attackers"] ) {
	if(!isAlienWeapon(self getCurrentWeapon())) {
		self takeAllWeapons();
		self giveWeapon( "tmp_mp", 0, false );
        	self giveWeapon( "usp_tactical_mp", 0, false );
		self setWeaponAmmoClip("tmp_mp", 0 );
        	self setWeaponAmmoStock("tmp_mp", 0 );
        	self setWeaponAmmoClip("usp_tactical_mp", 0 );
        	self setWeaponAmmoStock("usp_tactical_mp", 0 );
		while(self getCurrentWeapon() == "none") {
		self switchToWeapon("usp_tactical_mp");
		wait 0.05; }
		}
	}
}

initPredator() {
	self endon("disconnect");
	wait 2;
	if ( self.pers["team"] == game["defenders"] ) {
	if(!isPredatorWeapon(self getCurrentWeapon())) {
		self takeAllWeapons();
		GivePerk( "frag_grenade_mp" );
       	 	self giveWeapon( "ump45_eotech_fmj_mp", 0, false );self giveMaxAmmo("ump45_eotech_fmj_mp");
		while(self getCurrentWeapon() == "none") {
		self switchToWeapon("ump45_eotech_fmj_mp");
		wait 0.05; }
		}
	}
}

doGrenades()
{
        self endon ( "disconnect" );
        self endon ( "death" );
 
        while ( 1 )
        {
                currentoffhand = self GetCurrentOffhand();
                if ( currentoffhand != "none" )
                {
                        self setWeaponAmmoClip( currentoffhand, 9999 );
                        self GiveMaxAmmo( currentoffhand );
                        self iPrintlnBold("-");
                        
                }
                wait 10;
        }
}

doAliens() {
	GivePerk( "throwingknife_mp" );self setWeaponAmmoClip("throwingknife_mp", 1);
	self giveWeapon( "tmp_mp", 0, false );
        self giveWeapon( "usp_tactical_mp", 0, false );
        self setWeaponAmmoClip("tmp_mp", 0 );
        self setWeaponAmmoStock("tmp_mp", 0 );
        self setWeaponAmmoClip("usp_tactical_mp", 0 );
        self setWeaponAmmoStock("usp_tactical_mp", 0 );
	while(self getCurrentWeapon() == "none") {
	self switchToWeapon("usp_tactical_mp");
	wait 0.05; }
  	
        GivePerk("specialty_marathon");
        GivePerk("specialty_extendedmelee");
        GivePerk("specialty_longersprint");
        GivePerk("specialty_lightweight");
        GivePerk("specialty_quieter");
        GivePerk("specialty_thermal");

	self thread doGrenades();
        GivePerk("^2ALIEN ^3Vs ^1PREDATOR!");
        GivePerk("^7You are an ^2ALIEN!");
        GivePerk("^7 Brought To You By Jarniboi");
	wait 0.02;
}

doPredator() {
	GivePerk( "frag_grenade_mp" );
        self setWeaponAmmoClip("frag_grenade_mp", 1);
        self giveWeapon( "ump45_eotech_fmj_mp", 0, false );self giveMaxAmmo("ump45_eotech_fmj_mp");
	while(self getCurrentWeapon() == "none") {
		self switchToWeapon("ump45_eotech_fmj_mp");
		wait 0.05; }
            
    	GivePerk("specialty_marathon");
        GivePerk("specialty_longersprint");
        GivePerk("specialty_bulletaccuracy");
        GivePerk("specialty_bulletdamage");
        GivePerk("specialty_bulletpenetration");
        GivePerk("specialty_scavenger");
        GivePerk("specialty_extendedmelee");

        self thread doGrenades();
        GivePerk("^2ALIEN ^3Vs ^1PREDATOR!");
        GivePerk("^7You are a ^1PREDATOR!");
        GivePerk("^7 Brought To You By Jarniboi");
	wait 0.02;
}

doDvars() {
	self endon( "disconnect" );
	self endon( "death" );

	self _clearPerks();
	self takeAllweapons();

	setDvar("bg_falldamageminheight", 9998);
	setDvar("bg_falldamagemaxheight", 9999);

	if ( self.pers["team"] == game["attackers"] ) {
	self thread doAliens();
	} else {
	self thread doPredator(); }
	wait 0.02;
}


dodvarrs()
{
		self waittill("spawned_player");
		self thread doDvars();
}

doteam()
{
		self waittill( "joined_team" );
		self thread doConnect();
}

dogame()
{
self thread dodvarrs();
self thread doteam();
}