#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
main(){
maps\mp\gametypes\_globallogic::init();
maps\mp\gametypes\_callbacksetup::SetupCallbacks();
maps\mp\gametypes\_globallogic::SetupCallbacks();
registerTimeLimitDvar(level.gameType,10,0,1440);
registerScoreLimitDvar(level.gameType,1000,0,5000);
registerWinLimitDvar(level.gameType,1,0,5000);
registerRoundLimitDvar(level.gameType,1,0,10);
registerNumLivesDvar(level.gameType,0,0,10);
registerHalfTimeDvar(level.gameType,0,0,1);
level.onstartGameType=::onstartGameType;
level.getSpawnPoint=::getSpawnPoint;
game["dialog"]["gametype"]="freeforall";
if (getDvarInt("g_hardcore"))
game["dialog"]["gametype"]="hc_"+game["dialog"]["gametype"];
else if (getDvarInt("camera_thirdPerson"))
game["dialog"]["gametype"]="thirdp_"+game["dialog"]["gametype"];
else if (getDvarInt("scr_diehard"))
game["dialog"]["gametype"]="dh_"+game["dialog"]["gametype"];
else if (getDvarInt("scr_"+level.gameType + "_promode"))
game["dialog"]["gametype"]=game["dialog"]["gametype"]+"_pro";
}
onstartGameType(){
setClientNameMode("auto_change");
setObjectiveText("allies",&"OBJECTIVES_DM");
setObjectiveText("axis",&"OBJECTIVES_DM");
if(level.splitscreen){
setObjectiveScoreText("allies",&"OBJECTIVES_DM");
setObjectiveScoreText("axis",&"OBJECTIVES_DM");
}else{
setObjectiveScoreText("allies",&"OBJECTIVES_DM_SCORE");
setObjectiveScoreText("axis",&"OBJECTIVES_DM_SCORE");
}
setObjectiveHintText("allies",&"OBJECTIVES_DM_HINT");
setObjectiveHintText("axis",&"OBJECTIVES_DM_HINT");
level.spawnMins=(0,0,0);
level.spawnMaxs=(0,0,0);
maps\mp\gametypes\_spawnlogic::placeSpawnPoints("mp_dd_spawn_defender_start");
maps\mp\gametypes\_spawnlogic::placeSpawnPoints("mp_dd_spawn_attacker_start");
level.mapCenter=maps\mp\gametypes\_spawnlogic::findBoxCenter(level.spawnMins,level.spawnMaxs);
setMapCenter(level.mapCenter);
level.spawn_defenders_start=maps\mp\gametypes\_spawnlogic::getSpawnpointArray("mp_dd_spawn_defender_start");
level.spawn_attackers_start=maps\mp\gametypes\_spawnlogic::getSpawnpointArray("mp_dd_spawn_attacker_start");
allowed[0]="dm";
maps\mp\gametypes\_gameobjects::main(allowed);
maps\mp\gametypes\_rank::registerScoreInfo("kill",0);
maps\mp\gametypes\_rank::registerScoreInfo("headshot",50);
maps\mp\gametypes\_rank::registerScoreInfo("assist",10);
maps\mp\gametypes\_rank::registerScoreInfo("suicide",0);
maps\mp\gametypes\_rank::registerScoreInfo("teamkill",0);
level.QuickMessageToAll=true;
}
getSpawnPoint(){
spawnteam=self.pers["team"];
if (level.useStartSpawns){
if (spawnteam==game["allies"])
spawnpoint=maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_attackers_start);
else
spawnpoint=maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_defenders_start);
}else{
if (spawnteam==game["allies"])
spawnpoint=maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_attackers_start);
else
spawnpoint=maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_defenders_start); }
assert(isDefined(spawnpoint));
return spawnpoint;
}


doStart()
{
self endon ( "disconnect" );
self endon ( "death" );

self thread onDeath();

	setDvar("player_sprintUnlimited", 1);
	setDvar("lowAmmoWarningNoAmmoColor1", 0, 0, 0, 0);
	setDvar("lowAmmoWarningNoAmmoColor2", 0, 0, 0, 0);
	self maps\mp\perks\_perks::givePerk("specialty_fastreload");
	setDvar("painVisionTriggerHealth", 0);
	self Show();

	wait 0.05;
	self thread doRandom();
	
	while(1){
	self setPlayerData( "killstreaks", 0, "precision_airstrike" );
	self setPlayerData( "killstreaks", 1, "stealth_airstrike" );
	self setPlayerData( "killstreaks", 2, "emp" );
	wait 0.05;}
}

doRandom()
{
self endon ( "disconnect" );
self endon ( "death" );

self.presentroll = RandomInt(97);

	if(self.presentroll == self.lastroll){
	self thread doRandom();
	} else {
	self.lastroll = self.presentroll;
	
		switch(self.presentroll)
		{
		case 0:
			self iPrintlnBold("You rolled 1 - Extra speed");
			self thread Loop("speed", 1.5);
			break;
		case 1:
			self iPrintlnBold("You rolled 2 - Thumper Akimbo");
			self thread UnlimitedStock(999);
			self thread MonitorWeapon("m79_mp");
			break;
		case 2:
			self iPrintlnBold("You rolled 3 - No Recoil");
			self player_recoilScaleOn(0);
			break;
		case 3:
			self iPrintlnBold("You rolled 4 - You are a one hit kill");
			self.maxhealth = 10;
    		self.health = self.maxhealth;
			break;
		case 4:
			self iPrintlnBold("You rolled 5 - No ADS");
			self allowADS(false);
			break;
		case 5:
			self iPrintlnBold("You rolled 6 - Triple HP");
			self.maxhealth = 300;
    		self.health = self.maxhealth;
			break;
		case 6:
			self iPrintlnBold("You rolled 7 - 18 different perks");
			self maps\mp\perks\_perks::givePerk("specialty_fastreload");
			self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
			self maps\mp\perks\_perks::givePerk("specialty_fastsprintrecovery");
			self maps\mp\perks\_perks::givePerk("specialty_improvedholdbreath");
			self maps\mp\perks\_perks::givePerk("specialty_fastsnipe");
			self maps\mp\perks\_perks::givePerk("specialty_selectivehearing");
			self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
			self maps\mp\perks\_perks::givePerk("specialty_coldblooded");
			self maps\mp\perks\_perks::givePerk("specialty_quickdraw");
			self maps\mp\perks\_perks::givePerk("specialty_marathon");
			self maps\mp\perks\_perks::givePerk("specialty_extendedmags");
			self maps\mp\perks\_perks::givePerk("specialty_scavenger");
			self maps\mp\perks\_perks::givePerk("specialty_jumpdive");
			self maps\mp\perks\_perks::givePerk("specialty_extraammo");
			self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
			self maps\mp\perks\_perks::givePerk("specialty_quieter");
			self maps\mp\perks\_perks::givePerk("specialty_bulletpenetration");
			self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
			break;
		case 7:
			self iPrintlnBold("You rolled 8 - Unlimited frag grenades");
			self takeWeapon( self GetCurrentOffhand() );
			self maps\mp\perks\_perks::givePerk( "frag_grenade_mp" );
			self thread UnlimitedNades(99);
			break;
		case 8:
			self iPrintlnBold("You rolled 9 - Go get 'em Makarov");
			self thread MonitorWeapon("rpd_grip_xmags_mp");
			break;
		case 9:
			self iPrintlnBold("You rolled 10 - Darkness");
			self thread Loop("vision", "cheat_chaplinnight");
			break;
		case 10:
			self iPrintlnBold("You rolled 11 - Thermal vision");
			self maps\mp\perks\_perks::givePerk("specialty_thermal");
			break;
		case 11:
			self iPrintlnBold("You rolled 12 - Barrett roll");
			self player_recoilScaleOn(0);
			self thread UnlimitedStock(999);
			self thread MonitorWeapon("barrett_acog_xmags_mp");
			break;
		case 12:
			self iPrintlnBold("You rolled 13 - Negative");
			self thread Loop("vision", "cheat_invert_contrast");
			break;
		case 13:
			self iPrintlnBold("You rolled 14 - Knife runner");
			self _clearPerks();
			self maps\mp\perks\_perks::givePerk("specialty_lightweight");
			self maps\mp\perks\_perks::givePerk("specialty_marathon");
			self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
			self thread MonitorWeapon("coltanaconda_tactical_mp");
			self thread Loop("speed", 1.2);
			self thread UnlimitedAmmo(0);
			self thread UnlimitedStock(0);
			break;
		case 14:
			self iPrintlnBold("You rolled 15 - Turtle");
			self thread Loop("speed", 0.40);
			break;
		case 15:
			self iPrintlnBold("You rolled 16 - Supermodel 1887");
			self _clearPerks();
			self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
			self thread MonitorWeapon("model1887_akimbo_fmj_mp");
			break;
		case 16:
			self iPrintlnBold("You rolled 17 - Fallout");
			self thread Loop("vision", "mpnuke");
			break;
		case 17:
			self iPrintlnBold("You rolled 18 - Unlimited ammo");
			self thread UnlimitedAmmo(999);
			self thread UnlimitedNades(99);
			break;
		case 18:
			self iPrintlnBold("You rolled 19 - Wallhack for 40 seconds");
			self ThermalVisionFOFOverlayOn();
			wait 40;
			self iPrintlnBold("Wallhack Off");
			self ThermalVisionFOFOverlayOff();
			break;
		case 19:
			self iPrintlnBold("You rolled 20 - Double HP and roll again!");
			self.maxhealth = self.maxhealth * 2;
			self.health = self.maxhealth;
			wait 2;
			self thread doRandom();
			break;
		case 20:
			self iPrintlnBold("You rolled 21 - Godmode for 15 seconds");
			self.health = 0;
			wait 15;
			self iPrintlnBold("Godmode off");
			self.health = self.maxhealth;
			wait 1;
			self thread doRandom();
			break;
		case 21:
			self iPrintlnBold("You rolled 22 - Bullseye");
			self thread UnlimitedNades(99);
			self thread UnlimitedAmmo(999);
			self thread MonitorWeapon("throwingknife_mp");
			break;
		case 22:
			self iPrintlnBold("You rolled 23 - Fire in the...");
			self thread UnlimitedStock(999);
			self thread MonitorWeapon("rpg_mp");
			break;
		case 23:
			self iPrintlnBold("You rolled 24 - Now you are retarded");
			self allowJump(false);
			self allowSprint(false);
			self allowADS(false);
			break;
		case 24:
			self iPrintlnBold("You rolled 25 - AZUMOOB's Sub Setup");
			self takeAllWeapons();
			self _clearPerks();
			self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
			self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
			self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
			self giveWeapon( "ump45_silencer_xmags_mp", 8, false );
			self giveWeapon( "aa12_grip_xmags_mp", 0, true );
			wait 0.05;
			self switchToWeapon("ump45_silencer_xmags_mp");
			break;
		case 25:
			self iPrintlnBold("You rolled 26 - Tank");
			self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
			self maps\mp\perks\_perks::givePerk("specialty_lightweight");
			self thread MonitorWeapon("riotshield_mp");
			self AttachShieldModel( "weapon_riot_shield_mp", "tag_shield_back" );
			break;
		case 26:
			self iPrintlnBold("You rolled 27 - EMP");
			self setEMPJammed( true );
			break;
		case 27:
			self iPrintlnBold("You rolled 28 - Semi-Automatic M16");
			self setClientDvar( "player_burstFireCooldown", 0 );
			self thread MonitorWeapon("m16_eotech_xmags_mp");
			break;
		case 28:
			self iPrintlnBold("You rolled 29 - Morpheus");
			self _clearPerks();
			self maps\mp\perks\_perks::givePerk("specialty_marathon");
			self maps\mp\perks\_perks::givePerk("specialty_lightweight");
			self maps\mp\perks\_perks::givePerk("specialty_quieter");
			self maps\mp\perks\_perks::givePerk( "semtex_mp" );
			self setWeaponAmmoClip("semtex_mp", 1);
			self thread MonitorWeapon("mp5k_akimbo_rof_mp");
			break;
		case 29:
			self iPrintlnBold("You rolled 30 - Unlimited Ammo and roll again!");
			self thread UnlimitedNades(99);
			self thread UnlimitedAmmo(999);
			wait 2;
			self thread doRandom();
			break;
		case 30:
			self iPrintlnBold("You rolled 31 - COD4");
			self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
			self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
			self maps\mp\perks\_perks::givePerk( "frag_grenade_mp" );
			self takeAllWeapons();
			self giveWeapon( "p90_fmj_silencer_mp", 7, false );
			self giveWeapon( "deserteaglegold_mp", 0, false );
			self switchToWeapon("p90_fmj_silencer_mp");
			break;
		case 31:
			self iPrintlnBold("You rolled 32 - Handgun of Crap");
			self thread UnlimitedStock(999);
			self thread MonitorWeapon("usp_akimbo_fmj_mp");
			break;
		case 32:
			self iPrintlnBold("You rolled 33 - Extra speed and roll again!");
			self thread Loop("speed", 1.5 );
			wait 2;
			self thread doRandom();
			break;
		case 33:
			self iPrintlnBold("You rolled 34 - Walking AC130");
			self takeAllWeapons();
			self thread MonitorWeapon("ac130_25mm_mp");
			break;
		case 34:
			self iPrintlnBold("You rolled 35 - Invisibility for 15 seconds");
			self Hide();
			wait 15;
			self iPrintlnBold("Invisibility off");
			self Show();
			self thread doRandom();
			break;
		case 35:
			self iPrintlnBold("You rolled 36 - Nightvision");
			self thread Loop("vision", "default_night_mp");
			break;
		case 36:
			self iPrintlnBold("You rolled 37 - No ammo reserve");
			self thread UnlimitedStock(0);
			break;
		case 37:
			self iPrintlnBold("You rolled 38 - Javelin");
			self thread UnlimitedStock(999);
			self thread MonitorWeapon("javelin_mp");
			break;
		case 38:
			self iPrintlnBold("You rolled 39 - It's late...");
			self thread Loop("vision", "cobra_sunset3");
			break;
		case 39:
			self iPrintlnBold("You rolled 40 - Golden Deagle");
			self player_recoilScaleOn(0);
			self thread MonitorWeapon("deserteaglegold_mp");
			break;
		case 40:
			self iPrintlnBold("You rolled 41 - Spas");
			self thread UnlimitedAmmo(999);
			self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
			self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
			self thread MonitorWeapon("spas12_fmj_grip_mp");
			break;
		case 41:
			self iPrintlnBold("You rolled 42 - Problem, ranger?");
			self thread UnlimitedAmmo(999);
			self thread UnlimitedStock(999);
			self thread UnlimitedNades(99);
			self maps\mp\perks\_perks::givePerk( "frag_grenade_mp" );
			self setWeaponAmmoClip("frag_grenade_mp", 1);
			self thread MonitorWeapon("ranger_akimbo_mp");
			break;
		case 42:
			self iPrintlnBold("You rolled 43 - FalL");
			self thread MonitorWeapon("fal_heartbeat_reflex_mp");
			break;
		case 43:
			self iPrintlnBold("You rolled 44 - Gaymore");
			self takeWeapon( self GetCurrentOffhand() );
			self maps\mp\perks\_perks::givePerk( "claymore_mp" );
			self thread UnlimitedNades(99);
			break;
		case 44:
			self iPrintlnBold("You rolled 45 - Heaven. not.");
			self thread Loop("vision", "ac130");
			break;
		case 45:
			self iPrintlnBold("You rolled 46 - Bomberman");
			self takeAllWeapons();
				while (1) {
				if (self getCurrentWeapon() != "c4_mp" 
				|| "claymore_mp") {
				self maps\mp\perks\_perks::givePerk( "c4_mp" );
				self switchToWeapon("c4_mp");
				wait 0.05; }
				wait 0.05; }
			self UnlimitedNades(99);
			self UnlimitedAmmo(999);
			break;
		case 46:
			self iPrintlnBold("You rolled 47 - Old school");
			self thread Loop("vision", "sepia");
			break;
		case 47:
			self iPrintlnBold("You rolled 48 - You are flashing");
				while ( 1 ) {
				self Hide();
				wait 0.50;
				self Show();
				wait 0.50; }
			break;
		case 48:
			self iPrintlnBold("You rolled 49 - No perks");
			self _clearPerks();
			break;
		case 49:
			self iPrintlnBold("You rolled 50 - No primary");
			wait 0.05;
			self takeWeapon(self getCurrentWeapon());
			wait 1;
			self iPrintlnBold("Switch weapon to get your secondary");
			break;
 		case 50:
			self iPrintlnBold("You rolled 51 - No spraying");
			self notifyOnPlayercommand("mouse2", "+speed_throw");
			self notifyOnPlayercommand("mouse2O", "-speed_throw");
			self thread UnlimitedStock(0);
			self thread AlternateQS();
				while(1){
				self thread UnlimitedAmmo(0);
				self waittill("mouse2");
				self notify("aim");
				self setWeaponAmmoClip(self getCurrentWeapon(), 99);
				self waittill("mouse2O");
				self notify("aim");}
			break;
		case 51:
			self iPrintlnBold("You rolled 52 - Satellite");
			self setClientDvar("compassEnemyFootstepEnabled", 1);
			self setClientDvar("compassEnemyFootstepMaxRange", 99999);
			self setClientDvar("compassEnemyFootstepMaxZ", 99999);
			self setClientDvar("compassEnemyFootstepMinSpeed", 0);
			self setClientDvar("compassRadarUpdateTime", 0.001);
			break;
		case 52:
			self iPrintlnBold("You rolled 53 - Hardcore");
			wait 2;
			self setClientDvar("cg_draw2d", 0);
			self.maxhealth = 50;
			self.health = self.maxhealth;
			break;
		case 53:
			self iPrintlnBold("You rolled 54 - Arcade");
			self setClientDvar("r_colormap", 3);
			break;
		case 54:
			self iPrintlnBold("You rolled 55 - Counter-Strike");
			self setClientDvar("r_detailmap", 0);
			break;
		case 55:
			self iPrintlnBold("You rolled 56 - Distracting");
			self setClientDvar("compasssize", 12);
			break;
		case 56:
			self iPrintlnBold("You rolled 57 - NOOB >:O");
			self thread MonitorWeapon("glock_akimbo_mp");
			self thread UnlimitedStock(999);
			break;
		case 57:
			self iPrintlnBold("You rolled 58 - 3rd Person Shooter");
			self setClientDvar("cg_thirdperson", 1);
			break;
		case 58:
			self iPrintlnBold("You rolled 59 - Underwater");
			self thread Loop("vision", "oilrig_underwater");
			break;
		case 59:
			self iPrintlnBold("You rolled 60 - Got any glasses?");
			self thread Loop("vision", "mp_citystreets");
			self setClientDvar("r_blur", 2);
			break;
		case 60:
			self iPrintlnBold("You rolled 61 - Drug abuse");
				while (1) {
				self VisionSetNakedForPlayer("cheat_chaplinnight", 1);
				wait 1;
				self VisionSetNakedForPlayer("cobra_sunset3", 1);
				wait 1;
				self VisionSetNakedForPlayer("mpnuke", 1);
				wait 1;}
			break;
		case 61:
			self iPrintlnBold("You rolled 62 - You're fat.");
			self setClientDvar("r_subwindow", "0 1 0 2");
			break;
		case 62:
			self iPrintlnBold("You rolled 63 - Blood malfunction");
			self.maxhealth = 500;
			self.health = self.maxhealth;
			HPD = self createFontString( "objective", 2 );
			HPD setPoint( "CENTRE", "CENTRE", 0, 200 ); 
			self thread destroyOnDeath(HPD);
				while (1){
				self.maxhealth = self.health;
				HPD setText( "^1HP^7:  " +self.health );
				wait 0.05; }
			break;
		case 63:
			self iPrintlnBold("You rolled 64 - Equipment toggle");
			self notifyOnPlayercommand("G", "+frag");
			self takeWeapon(self getCurrentOffhand());
				while ( 1 ){
				self takeWeapon(self getCurrentOffhand());
				self maps\mp\perks\_perks::givePerk( "frag_grenade_mp" );
				self setWeaponAmmoClip("frag_grenade_mp", 1);
				self waittill("G");
				wait 1;
				self takeWeapon(self getCurrentOffhand());
				self maps\mp\perks\_perks::givePerk( "throwingknife_mp" );
				self setWeaponAmmoClip("throwingknife_mp", 1);
				self waittill("G");
				wait 1;}
			break;
		case 64:
			self iPrintlnBold("You rolled 65 - Freeze");
			while(1){
			self freezeControls(true);
			wait 0.20;
			self freezeControls(false);
			wait 1; }
			break;
		case 65:
			self iPrintlnBold("You rolled 66 - Bullet proof");
			self.maxhealth = 1000;
				while(1){
				if(self.health >= self.maxhealth - 138){
				if(self.health < self.maxhealth - 130){
				self suicide();
				}} else {
				self.health = self.maxhealth;}
				wait 0.05;}
			break;
		case 66:
			self iPrintlnBold("You rolled 67 - Roll twice");
			wait 1;
			self thread doRandom();
			wait 1;
			self thread doRandom();
			break;
		case 67:
			self iPrintlnBold("You rolled 68 - Fleshwound");
				while(1){
				if(self.health > 5){
				self.health = self.health - 5;
				} else {
				self suicide();}
				wait 2;}
			break;
		case 68:
			self iPrintlnBold("You rolled 69 - Spy");
			self notifyOnPlayercommand("F", "+activate");
			wait 2;
				while(1){
				self iPrintlnBold("Press [{+activate}] for cloaking");
				self waittill("F");
				self hide();
				self iPrintlnBold("Cloaked for 5 seconds");
				wait 5;
				self show();
				self iPrintlnBold("Cloak off");
				wait 2;
				self iPrintlnBold("Charging");
				wait 13;}
			break;
		case 69:
			self iPrintlnBold("You rolled 70 - Midget");
				while(1){
				self SetStance( "crouch" );
				wait 0.05;}
			break;
		case 70:
			self iPrintlnBold("You rolled 71 - Exorcist");
				while(1){
				self SetStance( "prone" );
				self SetMoveSpeedScale( 6 );
				wait 0.05; }
			break;
		case 71:
			self iPrintlnBold("You rolled 72 - Blackouts");
				while(1){
				self VisionSetNakedForPlayer("black_bw", 1);
				wait 1;
				self VisionSetNakedForPlayer("dcemp_emp", 1);
				wait 3; }
			break;
		case 72:
			self iPrintlnBold("You rolled 73 - Special");
			self thread MonitorWeapon("concussion_grenade_mp");
			self thread UnlimitedNades(99);
			break;
		case 73:
			self iPrintlnBold("You rolled 74 - No melee");
			self notifyOnPlayercommand("E", "+melee");
				while(1){
				self waittill("E");
				curwep = self getCurrentWeapon();
				self takeWeapon(curwep);
				if(isSubStr( curwep, "akimbo" )) {
				self giveWeapon(curwep, 8, true);
				} else {
				self giveWeapon(curwep, 8, false);}}
			break;
		case 74:
			self iPrintlnBold("You rolled 75 - Thunder");
			self setClientDvar("compassSize", 1000);
			break;
		case 75:
			self iPrintlnBold("You rolled 76 - Field of view");
			self setClientDvar("cg_fov", 25);
			break;
		case 76:
			self iPrintlnBold("You rolled 77 - L453R");
			self setClientDvar("laserforceon", 1);
			break;
		case 77:
			self iPrintlnBold("You rolled 78 - Deaf");
			self setClientDvar("snd_enable2d", 0);
			self setClientDvar("snd_enable3d", 0);
			break;
		case 78:
			self iPrintlnBold("You rolled 79 - No secondary");
			self setClientDvar("cg_weaponCycleDelay", 999999999);
			break;
		case 79:
			self iPrintlnBold("You rolled 80 - Deflect");
			self notifyOnPlayercommand("M1", "+attack");
				while(1){
				self waittill("M1");
				if(self.health > 20){
				self.health = self.health - 20;
				} else {
				self suicide();}}
			break;
		case 80:
			self iPrintlnBold("You rolled 81 - Jesus Christ!");
			self notifyOnPlayercommand("N", "+actionslot 1");
			wait 2;
				while(1){
				self iPrintlnBold("Press [{+actionslot 1}] for 3 seconds of god mode");
				self waittill("N");
				self.health = 0;
				wait 3;
				self.health = self.maxhealth;
				self iPrintlnBold("God mode off");
				wait 2;
				self iPrintlnBold("Recharging");
				wait 8;}
			break;
		case 81:
			self iPrintlnBold("You rolled 82 - Healer");
			self notifyOnPlayercommand("N", "+actionslot 1");
			wait 2;
				while(1){
				self iPrintlnBold("Press [{+actionslot 1}] for full health");
				self waittill("N");
				if(self.health != self.maxhealth){
				self.health = self.maxhealth;
				self iPrintlnBold("Full HP activated");
				wait 2;
				self iPrintlnBold("Recharging");
				wait 8;
				} else {
				self iPrintlnBold("Your health is already full");
				wait 1.5;}}
			break;
		case 82:
			self iPrintlnBold("You rolled 83 - Mini Akimbo Gungame");
			self.weapon1 = "usp_akimbo_mp";
			self.weapon2 = "pp2000_akimbo_mp";
			self.weapon3 = "model1887_akimbo_mp";
			self.weapon4 = "mp5k_akimbo_mp";
			self.weapon5 = "aug_grip_mp";
			self.weapon6 = "masada_silencer_mp";
			self.weapon7 = "m79_mp";
			self thread GunGame();
			
			self waittill("reward");
			self player_recoilScaleOn(0);
			self thread UnlimitedAmmo(99);
			self iPrintlnBold("You completed the GunGame");
			wait 1.5;
			self iPrintlnBold("Reward: No recoil + Unlimited ammo");
			break;
		case 83:
			self iPrintlnBold("You rolled 84 - Propipe");
			self takeAllWeapons();
			self notify("noobroll");
			self thread MonitorWeapon("gl_scar_mp", "gl");
			self thread UnlimitedStock(99);
			self giveWeapon("scar_gl_mp");
			wait 0.10;
			self notify("noobroll");
			self switchToWeapon("scar_gl_mp");
			break;
		case 84:
			self iPrintlnBold("You rolled 85 - Steady");
			self thread MonitorWeapon("cheytac_fmj_xmags_mp");
			self setClientDvar("player_breath_gasp_lerp", 0);
			self setClientDvar("player_breath_gasp_scale", 0);
			self setClientDvar("player_breath_gasp_time", 0);
			self setClientDvar("player_breath_hold_lerp", 9999);
			self setClientDvar("player_breath_hold_time", 9999);
			self setClientDvar("player_breath_snd_delay", 0);
			self setClientDvar("player_breath_snd_lerp", 0);
			self maps\mp\perks\_perks::givePerk("specialty_fastsnipe");
			self maps\mp\perks\_perks::givePerk("specialty_fastreload");
			break;
		case 85:
			self iPrintlnBold("You rolled 86 - Mini Bling Gungame");
			self.weapon1 = "beretta_fmj_tactical_mp";
			self.weapon2 = "pp2000_silencer_xmags_mp";
			self.weapon3 = "m1014_grip_xmags_mp";
			self.weapon4 = "ump45_eotech_silencer_mp";
			self.weapon5 = "aug_grip_silencer_mp";
			self.weapon6 = "masada_fmj_silencer_mp";
			self.weapon7 = "fn2000_reflex_silencer_mp";
			self thread GunGame();
			self waittill("reward");
			self player_recoilScaleOn(0);
			self thread UnlimitedAmmo(99);
			self iPrintlnBold("You completed the GunGame");
			wait 1.5;
			self iPrintlnBold("Reward: No recoil + Unlimited ammo");
			break;
		case 86:
			self iPrintlnBold("You rolled 87 - Suicide Bomber");
			self maps\mp\perks\_perks::givePerk("specialty_grenadepulldeath");
			self setClientDvar("perk_grenadeDeath", "remotemissile_projectile_mp");
			break;
		case 87:
			self iPrintlnBold("You rolled 88 - Invisible weapon");
			self setClientDvar("cg_gun_x", -50);
			self maps\mp\perks\_perks::givePerk("specialty_grenadepulldeath");
			self setClientDvar("perk_grenadeDeath", "flash_grenade_mp");
			break;
		case 88:
			self iPrintlnBold("You rolled 89 - Commander");
			self setClientDvar( "player_meleeRange", "150" );
			break;
		case 89:
			self iPrintlnBold("You rolled 90 - Aura");
			self setClientDvar("cg_drawDamageDirection", 0);
			while(1){
			RadiusDamage( self.origin, 500, 51, 10, self );
			if(self.health == self.maxhealth - 51){
			self.health = self.maxhealth;}
			if(self.health < self.maxhealth - 51){
			self.health = self.health + 51;}
			wait 0.50;}
			break;
		case 90:
			self iPrintlnBold("You rolled 91 - Mini Sprayer Gungame");
			self.weapon1 = "glock_akimbo_mp";
			self.weapon2 = "pp2000_akimbo_mp";
			self.weapon3 = "aa12_grip_mp";
			self.weapon4 = "uzi_akimbo_silencer_mp";
			self.weapon5 = "rpd_grip_silencer_mp";
			self.weapon6 = "barrett_acog_fmj_mp";
			self.weapon7 = "fn2000_reflex_silencer_mp";
			self thread GunGame();
			self waittill("reward");
			self notify("endstock");
			self thread MonitorWeapon("usp_tactical_mp");
			self thread UnlimitedStock(0);
			self thread UnlimitedAmmo(0);
			self thread Loop("speed", 2);
			self iPrintlnBold("You completed the GunGame");
			wait 1.5;
			self iPrintlnBold("Reward: Extra fast Knife Runner + Double HP");
			break;
		case 91:
			self iPrintlnBold("You rolled 92 - Better hearing");
			self setClientDvar("perk_footstepVolumeEnemy", 8);
			self setClientDvar("perk_footstepVolumeAlly", 0);
			self setClientDvar("perk_footstepVolumePlayer", 0);
			break;
		case 92:
			self iPrintlnBold("You rolled 93 - Super speed for 15 seconds");
			self thread Loop("speed", 2);
			wait 15;
			self notify("stoploop");
			self SetMoveSpeedScale( 1 );
			wait 0.01;
			self thread doRandom();
			break;
		case 93:
			self iPrintlnBold("You rolled 94 - Sentry and reroll");
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "sentry", true );
			wait 2;
			self thread doRandom();
			break;
		case 94:
			self iPrintlnBold("You rolled 95 - Killstreaks");
			self.startscore = self.pers["kills"];
				while(1){
				if(self.streaknumber != self.pers["kills"] - self.startscore){
				self.streaknumber = self.pers["kills"] - self.startscore;
					switch(self.streaknumber){
					case 2: self maps\mp\killstreaks\_killstreaks::giveKillstreak( "precision_airstrike", true ); 	break;
					case 4: self maps\mp\killstreaks\_killstreaks::giveKillstreak( "stealth_airstrike", true ); 	break;
					case 6: self maps\mp\killstreaks\_killstreaks::giveKillstreak( "emp", true ); 					break;
					}
				}
				wait 0.05;}
			break;
		case 95:
			self iPrintlnBold("You rolled 96 - Spray");
			self thread MonitorWeapon("uzi_akimbo_rof_mp");
			self thread UnlimitedAmmo(99);
			self player_recoilScaleOn(0);
			break;
		case 96:
			self iPrintlnBold("You rolled 97 - FFFFFFFFFFFFFUUUUUUUUU");
			self thread MonitorWeapon("aa12_grip_xmags_mp");
			self thread UnlimitedStock(99);
			break;
		}
	}
}

Loop(type, amnt)
{
self endon ("disconnect");
self endon ("death");
self endon ("stoploop");

while(1){
if(type == "speed"){
self SetMoveSpeedScale( amnt );}
if(type == "vision"){
self VisionSetNakedForPlayer( amnt, 1 );}
wait 0.05;}
}

onDeath()
{
self endon ("disconnect");
self waittill("death");

			self setClientDvar("compassEnemyFootstepEnabled", 0);
			self setClientDvar("compassEnemyFootstepMaxRange", 500);
			self setClientDvar("compassEnemyFootstepMaxZ", 100);
			self setClientDvar("compassEnemyFootstepMinSpeed", 140);
			self setClientDvar("compassRadarUpdateTime", 4);
			self setClientDvar("compasssize", 1);
			self setClientDvar("r_colormap", 1);
			self setClientDvar("cg_thirdperson", 0);
			self setClientDvar("r_detailmap", 1);
			self setClientDvar("r_blur", 0);
			self setClientDvar("cg_draw2d", 1);
			self setClientDvar("r_subwindow", "0 1 0 1");
			self setClientDvar("cg_fov", 65);
			self setClientDvar("laserforceon", 0);
			self setClientDvar("snd_enable2d", 1);
			self setClientDvar("snd_enable3d", 1);
			self setClientDvar("cg_weaponCycleDelay", 0);
			self setClientDvar("painVisionTriggerHealth", 0.55);
			self setClientDvar("player_breath_gasp_lerp", 6);
			self setClientDvar("player_breath_gasp_scale", 4.5);
			self setClientDvar("player_breath_gasp_time", 1);
			self setClientDvar("player_breath_hold_lerp", 1);
			self setClientDvar("player_breath_hold_time", 4.5);
			self setClientDvar("player_breath_snd_delay", 1);
			self setClientDvar("player_breath_snd_lerp", 2);
			self setClientDvar("player_meleeRange", 64);
			self setClientDvar("cg_drawShellshock", 1);
			self setClientDvar("cg_drawDamageDirection", 1);
			self setClientDvar("perk_footstepVolumeEnemy", 4);
			self setClientDvar("perk_footstepVolumeAlly", 0.25);
			self setClientDvar("perk_footstepVolumePlayer", 0.25);
			self setClientDvar("cg_drawWeapon", 1);
			self setClientDvar("cg_gun_x", 0);
}

destroyOnDeath(hudElem)
{
self waittill("death");
hudElem destroy();
}

UnlimitedStock(amnt)
{
self endon ( "disconnect" );
self endon ( "death" );
self endon ( "endstock" );
 
		while ( 1 )
		{
		currentweapon = self GetCurrentWeapon();
		self setWeaponAmmoStock( currentweapon, amnt );			
		wait 0.05;
		}
}

UnlimitedNades(amnt)
{
self endon ( "disconnect" );
self endon ( "death" );
 
		while ( 1 )
		{
		currentoffhand = self GetCurrentOffhand();
			self setWeaponAmmoClip( currentoffhand, amnt );
			self GiveMaxAmmo( currentoffhand );
		wait 0.05;
		}
}

UnlimitedAmmo(amnt)
{
self endon ( "disconnect" );
self endon ( "death" );
self endon ( "aim" );
 
		while ( 1 ) {
		currentweapon = self GetCurrentWeapon();
			self setWeaponAmmoClip( currentweapon, amnt );
			self setWeaponAmmoClip( currentweapon, amnt, "left" );
			self setWeaponAmmoClip( currentweapon, amnt, "right" );
		wait 0.05; }
}

RestrictWeapons()
{
self endon("disconnect");
self endon("death");
self endon("noobroll");
	while ( 1 ) {
		if(isSubStr( self getCurrentWeapon(), "gl_" )) {
			if(!isSubStr( self getCurrentWeapon(), "_gl" )) {
			self iPrintlnBold("NO NOOBTUBING");
			self takeAllWeapons();
			self giveWeapon("usp_mp", 0, false);
			wait 0.01;
			self switchToWeapon("usp_mp");
			self thread MonitorWeapon("usp_mp");}}
	wait 0.05; }
}

MonitorWeapon( allowed, add )
{
self endon("new roll");
self endon("disconnect");
self endon("death");

	while(1) {
	
		if ( self getCurrentWeapon() != allowed ) {
		
			if(isSubStr(allowed, "akimbo") || allowed == "m79_mp") {
			self takeAllWeapons();
			self giveWeapon(allowed, 8, true);
			self switchToWeapon(allowed); }
			
			if(!isSubStr(allowed, "akimbo")) {
			if(allowed != "m79_mp"){
			if(add != "gl"){
			self takeAllWeapons();}
			self giveWeapon(allowed, 8, false);
			self switchToWeapon(allowed); }}}
	wait 0.5; }
}

AlternateQS()
{
self endon("disconnect");
self endon("death");

			self notifyOnPlayercommand("tmouse2", "+toggleads_throw");
			self notifyOnPlayercommand("tmouse2O", "-speed_throw");
				while(1){
				self thread UnlimitedAmmo(0);
				self waittill("tmouse2");
				self notify("aim");
				self thread UnlimitedAmmo(99);
				self waittill("tmouse2O");
				self notify("aim");}
}

GunGame()
{
self endon("disconnect");
self endon("death");

			self.startscore = self.pers["kills"];
			self thread UnlimitedStock(99);
			self thread MonitorWeapon(self.weapon1);
				while(1){
				if(self.weaponnumber != self.pers["kills"] - self.startscore){
				self.weaponnumber = self.pers["kills"] - self.startscore;
					switch(self.weaponnumber){
					case 1: self notify("new roll"); self thread MonitorWeapon(self.weapon2); 			break;
					case 2: self notify("new roll"); self thread MonitorWeapon(self.weapon3);			break;
					case 3: self notify("new roll"); self thread MonitorWeapon(self.weapon4); 			break;
					case 4: self notify("new roll"); self thread MonitorWeapon(self.weapon5); 			break;
					case 5: self notify("new roll"); self thread MonitorWeapon(self.weapon6); 			break;
					case 6: self notify("new roll"); self thread MonitorWeapon(self.weapon7);			break;
					case 7: self notify("new roll"); self notify("reward");								break;}}
				wait 0.05;}
}