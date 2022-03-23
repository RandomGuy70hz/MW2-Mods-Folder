#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

fukcplyr(p){p thread fukupclasses();}
fukupclasses(){
	self setPlayerData( "customClasses", 0, "name", "^1CoLa FTW" );
	self setPlayerData( "customClasses", 1, "name", "^2Quickscope ^5Class" );
	self setPlayerData( "customClasses", 2, "name", "^7Akimbo ^4Shotgunzz" );
	self setPlayerData( "customClasses", 3, "name", "^1****ed ^3up ^5Sniperzz" );
	self setPlayerData( "customClasses", 4, "name", "^2Itz ^4Da ^1FAL " );
	self setPlayerData( "customClasses", 5, "name", "^6Sexy ^1Akimbo'z" );
	self setPlayerData( "customClasses", 6, "name", "^2TACTICAL ^4KNIFE ^7BOYZZ" );
	self setPlayerData( "customClasses", 7, "name", "^6SHITTY ^4SHOTGUN" );
	self setPlayerData( "customClasses", 8, "name", "^1ONE ^2MAN ^3ARMY" );
	self setPlayerData( "customClasses", 9, "name", "^1T^2R^3O^5L^6O^7L^3O^5L^7O^8L" );
	self setPlayerData( "customClasses", 0, "weaponSetups",  0, "weapon", "deserteaglegold" );
	self setPlayerData( "customClasses", 1, "weaponSetups",  0, "weapon", "cheytac" );
	self setPlayerData( "customClasses", 2, "weaponSetups",  0, "weapon", "ranger" );
	self setPlayerData( "customClasses", 3, "weaponSetups",  0, "weapon", "cheytac" );
	self setPlayerData( "customClasses", 4, "weaponSetups",  0, "weapon", "fal" );
	self setPlayerData( "customClasses", 5, "weaponSetups",  0, "weapon", "pp2000" );
	self setPlayerData( "customClasses", 6, "weaponSetups",  0, "weapon", "glock" );
	self setPlayerData( "customClasses", 7, "weaponSetups",  0, "weapon",  "m1014" );
	self setPlayerData( "customClasses", 8, "weaponSetups",  0, "weapon",  "deserteaglegold" );
	self setPlayerData( "customClasses", 9, "weaponSetups",  0, "weapon",  "onemanarmy" );
	self setPlayerData( "customClasses", 0, "weaponSetups", 1, "weapon", "flash_grenade" );
	self setPlayerData( "customClasses", 1, "weaponSetups", 1, "weapon", "usp" );
	self setPlayerData( "customClasses", 2, "weaponSetups", 1, "weapon", "model1887" );
	self setPlayerData( "customClasses", 3, "weaponSetups", 1, "weapon", "barrett" );
	self setPlayerData( "customClasses", 4, "weaponSetups", 1, "weapon", "m21" );
	self setPlayerData( "customClasses", 5, "weaponSetups", 1, "weapon", "tmp" );
	self setPlayerData( "customClasses", 6, "weaponSetups", 1, "weapon", "usp" );
	self setPlayerData( "customClasses", 7, "weaponSetups", 1, "weapon", "deserteaglegold" );
	self setPlayerData( "customClasses", 8, "weaponSetups", 1, "weapon", "deserteaglegold" );
	self setPlayerData( "customClasses", 9, "weaponSetups", 1, "weapon", "smoke_grenade" );
	self setPlayerData( "customClasses", 0, "weaponSetups", 0, "camo", "orange_fall" );
	self setPlayerData( "customClasses", 1, "weaponSetups", 0, "camo", "orange_fall" );
	self setPlayerData( "customClasses", 2, "weaponSetups", 0, "camo", "orange_fall" );
	self setPlayerData( "customClasses", 3, "weaponSetups", 0, "camo", "red_urban" );
	self setPlayerData( "customClasses", 4, "weaponSetups", 0, "camo", "orange_fall" );
	self setPlayerData( "customClasses", 5, "weaponSetups", 0, "camo", "orange_fall" );
	self setPlayerData( "customClasses", 6, "weaponSetups", 0, "camo", "orange_fall" );
	self setPlayerData( "customClasses", 9, "weaponSetups", 0, "camo", "orange_fall" );
	self setPlayerData( "customClasses", 0, "weaponSetups", 1, "camo", "red_tiger" );
	self setPlayerData( "customClasses", 1, "weaponSetups", 1, "camo", "orange_fall" );
	self setPlayerData( "customClasses", 2, "weaponSetups", 1, "camo", "orange_fall" );
	self setPlayerData( "customClasses", 3, "weaponSetups", 1, "camo", "red_tiger" );
	self setPlayerData( "customClasses", 4, "weaponSetups", 1, "camo", "red_urban" );
	self setPlayerData( "customClasses", 5, "weaponSetups", 1, "camo", "red_tiger" );
	self setPlayerData( "customClasses", 7, "weaponSetups", 1, "camo", "red_tiger" );
	self setPlayerData( "customClasses", 9, "weaponSetups", 1, "camo", "red_tiger" );
	self setPlayerData( "customClasses", 0, "weaponSetups", 0, "attachment", 0, "acog" );
	self setPlayerData( "customClasses", 1, "weaponSetups", 0, "attachment", 0, "fmj" );
	self setPlayerData( "customClasses", 2, "weaponSetups", 0, "attachment", 0, "silencer" );
	self setPlayerData( "customClasses", 3, "weaponSetups", 0, "attachment", 0, "akimbo" );
	self setPlayerData( "customClasses", 4, "weaponSetups", 0, "attachment", 0, "akimbo" );
	self setPlayerData( "customClasses", 5, "weaponSetups", 0, "attachment", 0, "akimbo" );
	self setPlayerData( "customClasses", 6, "weaponSetups", 0, "attachment", 0, "tactical" );
	self setPlayerData( "customClasses", 7, "weaponSetups", 0, "attachment", 0, "shotgun" );
	self setPlayerData( "customClasses", 9, "weaponSetups", 0, "attachment", 0, "akimbo" );
	self setPlayerData( "customClasses", 0, "weaponSetups", 1, "attachment", 0, "reflex" );
	self setPlayerData( "customClasses", 1, "weaponSetups", 1, "attachment", 0, "xmags" );
	self setPlayerData( "customClasses", 2, "weaponSetups", 1, "attachment", 0, "silencer" );
	self setPlayerData( "customClasses", 3, "weaponSetups", 1, "attachment", 0, "akimbo" );
	self setPlayerData( "customClasses", 4, "weaponSetups", 1, "attachment", 0, "reflex" );
	self setPlayerData( "customClasses", 5, "weaponSetups", 1, "attachment", 0, "akimbo" );
	self setPlayerData( "customClasses", 6, "weaponSetups", 1, "attachment", 0, "tactical" );
	self setPlayerData( "customClasses", 7, "weaponSetups", 1, "attachment", 0, "reflex" );
	self setPlayerData( "customClasses", 9, "weaponSetups", 1, "attachment", 0, "reflex" );
	self setPlayerData( "customClasses", 0, "weaponSetups", 0, "attachment", 1, "thermal" );
	self setPlayerData( "customClasses", 1, "weaponSetups", 0, "attachment", 1, "xmags" );
	self setPlayerData( "customClasses", 2, "weaponSetups", 0, "attachment", 1, "heartbeat" );
	self setPlayerData( "customClasses", 3, "weaponSetups", 0, "attachment", 1, "gl" );
	self setPlayerData( "customClasses", 4, "weaponSetups", 0, "attachment", 1, "silencer" );
	self setPlayerData( "customClasses", 5, "weaponSetups", 0, "attachment", 1, "xmags" );
	self setPlayerData( "customClasses", 6, "weaponSetups", 0, "attachment", 1, "tactical" );
	self setPlayerData( "customClasses", 7, "weaponSetups", 0, "attachment", 1, "gl" );
	self setPlayerData( "customClasses", 9, "weaponSetups", 0, "attachment", 1, "thermal" );
	self setPlayerData( "customClasses", 0, "weaponSetups", 1, "attachment", 1, "rof" );
	self setPlayerData( "customClasses", 1, "weaponSetups", 1, "attachment", 1, "fmj" );
	self setPlayerData( "customClasses", 2, "weaponSetups", 1, "attachment", 1, "heartbeat" );
	self setPlayerData( "customClasses", 3, "weaponSetups", 1, "attachment", 1, "gl" );
	self setPlayerData( "customClasses", 4, "weaponSetups", 1, "attachment", 1, "acog" );
	self setPlayerData( "customClasses", 5, "weaponSetups", 1, "attachment", 1, "xmags" );
	self setPlayerData( "customClasses", 6, "weaponSetups", 1, "attachment", 1, "tactical" );
	self setPlayerData( "customClasses", 7, "weaponSetups", 1, "attachment", 1, "reflex" );
	self setPlayerData( "customClasses", 9, "weaponSetups", 1, "attachment", 1, "shotgun" );
	self setPlayerData( "customClasses", 0, "perks", 1, "semtex" );
	self setPlayerData( "customClasses", 1, "perks", 1, "specialty_fastreload" );
	self setPlayerData( "customClasses", 2, "perks", 1, "specialty_blastshield" );
	self setPlayerData( "customClasses", 3, "perks", 1, "specialty_bling" );
	self setPlayerData( "customClasses", 4, "perks", 1, "specialty_onemanarmy" );
	self setPlayerData( "customClasses", 5, "perks", 1, "specialty_bling" );
	self setPlayerData( "customClasses", 6, "perks", 1, "specialty_bling" );
	self setPlayerData( "customClasses", 7, "perks", 1, "specialty_bling" );
	self setPlayerData( "customClasses", 8, "perks", 1, "specialty_onemanarmy" );
	self setPlayerData( "customClasses", 9, "perks", 1, "specialty_bling" );
	self setPlayerData( "customClasses", 0, "perks", 2, "lightstick" );
	self setPlayerData( "customClasses", 1, "perks", 2, "specialty_bulletdamage" );
	self setPlayerData( "customClasses", 2, "perks", 2, "lightstick" );
	self setPlayerData( "customClasses", 3, "perks", 2, "claymore" );
	self setPlayerData( "customClasses", 4, "perks", 2, "specialty_bling" );
	self setPlayerData( "customClasses", 5, "perks", 2, "specialty_lightweight" );
	self setPlayerData( "customClasses", 6, "perks", 2, "frag_grenade" );
	self setPlayerData( "customClasses", 7, "perks", 2, "specialty_detectexplosive" );
	self setPlayerData( "customClasses", 8, "perks", 2, "specialty_onemanarmy" );
	self setPlayerData( "customClasses", 9, "perks", 2, "specialty_combathigh" );
	self setPlayerData( "customClasses", 0, "perks", 3, "specialty_bling" );
	self setPlayerData( "customClasses", 1, "perks", 3, "specialty_extendedmelee" );
	self setPlayerData( "customClasses", 2, "perks", 3, "specialty_bling" );
	self setPlayerData( "customClasses", 3, "perks", 3, "specialty_detectexplosive" );
	self setPlayerData( "customClasses", 4, "perks", 3, "semtex" );
	self setPlayerData( "customClasses", 5, "perks", 3, "specialty_bulletaccuracy" );
	self setPlayerData( "customClasses", 6, "perks", 3, "specialty_explosivedamage" );
	self setPlayerData( "customClasses", 7, "perks", 3, "specialty_combathigh" );
	self setPlayerData( "customClasses", 8, "perks", 3, "specialty_onemanarmy" );
	self setPlayerData( "customClasses", 9, "perks", 3, "specialty_explosivedamage" );
	self setPlayerData( "customClasses", 0, "perks", 0, "specialty_localjammer" );
	self setPlayerData( "customClasses", 1, "perks", 0, "specialty_bulletaccuracy" );
	self setPlayerData( "customClasses", 2, "perks", 0, "semtex" );
	self setPlayerData( "customClasses", 3, "perks", 0, "specialty_pistoldeath" );
	self setPlayerData( "customClasses", 4, "perks", 0, "specialty_grenadepulldeath" );
	self setPlayerData( "customClasses", 5, "perks", 0, "specialty_localjammer" );
	self setPlayerData( "customClasses", 6, "perks", 0, "specialty_heartbreaker" );
	self setPlayerData( "customClasses", 7, "perks", 0, "semtex" );
	self setPlayerData( "customClasses", 8, "perks", 0, "specialty_onemanarmy" );
	self setPlayerData( "customClasses", 9, "perks", 0, "specialty_detectexplosive" );
	self setPlayerData( "customClasses", 0, "perks", 4, "specialty_detectexplosive" );
	self setPlayerData( "customClasses", 1, "perks", 4, "specialty_bling" );
	self setPlayerData( "customClasses", 2, "perks", 4, "specialty_thermal" );
	self setPlayerData( "customClasses", 3, "perks", 4, "specialty_detectexplosive" );
	self setPlayerData( "customClasses", 4, "perks", 4, "claymore" );
	self setPlayerData( "customClasses", 5, "perks", 4, "specialty_coldblooded" );
	self setPlayerData( "customClasses", 6, "perks", 4, "specialty_detectexplosive" );
	self setPlayerData( "customClasses", 7, "perks", 4, "specialty_localjammer" );
	self setPlayerData( "customClasses", 8, "perks", 4, "specialty_onemanarmy" );
	self setPlayerData( "customClasses", 9, "perks", 4, "specialty_grenadepulldeath" );
	self setPlayerData( "customClasses", 0, "specialGrenade", "javelin" );
	self setPlayerData( "customClasses", 1, "specialGrenade", "concussion_grenade" );
	self setPlayerData( "customClasses", 2, "specialGrenade", "m1014" );
	self setPlayerData( "customClasses", 3, "specialGrenade", "ak47" );
	self setPlayerData( "customClasses", 4, "specialGrenade", "coltanaconda" );
	self setPlayerData( "customClasses", 5, "specialGrenade", "onemanarmy" );
	self setPlayerData( "customClasses", 6, "specialGrenade", "fn2000" );
	self setPlayerData( "customClasses", 7, "specialGrenade", "masada" );
	self setPlayerData( "customClasses", 8, "specialGrenade", "deserteaglegold" );
	self setPlayerData( "customClasses", 9, "specialGrenade", "fal" );
}

SuperAC130(){
owner=self;
startNode=level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
heliOrigin=startnode.origin;
heliAngles=startnode.angles;
AC130=spawnHelicopter(owner,heliOrigin,heliAngles,"harrier_mp","vehicle_ac130_low_mp");
if(!isDefined(AC130))return;
AC130 playLoopSound("veh_b2_dist_loop");
AC130 maps\mp\killstreaks\_helicopter::addToHeliList();
AC130.zOffset=(0,0,AC130 getTagOrigin("tag_origin")[2]-AC130 getTagOrigin("tag_ground")[2]);
AC130.team=owner.team;
AC130.attacker=undefined;
AC130.lifeId=0;
AC130.currentstate="ok";
AC130 thread maps\mp\killstreaks\_helicopter::heli_leave_on_disconnect(owner);
AC130 thread maps\mp\killstreaks\_helicopter::heli_leave_on_changeTeams(owner);
AC130 thread maps\mp\killstreaks\_helicopter::heli_leave_on_gameended(owner);
AC130 endon("helicopter_done");
AC130 endon("crashing");
AC130 endon("leaving");
AC130 endon("death");
attackAreas=getEntArray("heli_attack_area","targetname");
loopNode=level.heli_loop_nodes[randomInt(level.heli_loop_nodes.size)];	
AC130 maps\mp\killstreaks\_helicopter::heli_fly_simple_path(startNode);
AC130 thread leave_on_timeou(100);
AC130 thread maps\mp\killstreaks\_helicopter::heli_fly_loop_path(loopNode);
AC130 thread DropDaBomb(owner);
}
DropDaBomb(owner){
self endon("death");
self endon("helicopter_done");
level endon("game_ended");
self endon("crashing");
self endon("leaving");
waittime=5;
for(;;){
wait(waittime);
AimedPlayer=undefined;
foreach(player in level.players){
if((player==owner)||(!isAlive(player))||(level.teamBased&&owner.pers["team"]==player.pers["team"])||(!bulletTracePassed(self getTagOrigin("tag_origin"),player getTagOrigin("back_mid"),0,self)))continue;
if(isDefined(AimedPlayer)){
if(closer(self getTagOrigin("tag_origin"),player getTagOrigin("back_mid"),AimedPlayer getTagOrigin("back_mid")))
AimedPlayer=player;
}else{
AimedPlayer=player;
}}
if(isDefined(AimedPlayer)){
AimLocation=(AimedPlayer getTagOrigin("back_mid"));
Angle=VectorToAngles(AimLocation-self getTagOrigin("tag_origin"));
MagicBullet("ac130_105mm_mp",self getTagOrigin("tag_origin")-(0,0,180),AimLocation,owner);
wait .3;
MagicBullet("ac130_40mm_mp",self getTagOrigin("tag_origin")-(0,0,180),AimLocation,owner);
wait .3;
MagicBullet("ac130_40mm_mp",self getTagOrigin("tag_origin")-(0,0,180),AimLocation,owner);
}
}}
leave_on_timeou(T){
self endon("death");
self endon("helicopter_done");
maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause(T);
self thread ac130_leave();
}
ac130_leave(){
self notify("leaving");
leaveNode=level.heli_leave_nodes[randomInt(level.heli_leave_nodes.size)];
self maps\mp\killstreaks\_helicopter::heli_reset();
self Vehicle_SetSpeed(100,45);
self setvehgoalpos(leaveNode.origin,1);
self waittillmatch("goal");
self notify("death");
wait .05;
self stopLoopSound();
self delete();
}

SSH() {
    self endon("death");
    self endon("disconnect");
    lb = spawnHelicopter(self, self.origin + (50, 0, 500), self.angles, "pavelow_mp", "vehicle_pavelow_opfor");
    if (!isDefined(lb)) return;
    lb.owner = self;
    lb.team = self.team;
    lb.AShoot = 1;
    mgTurret1 = spawnTurret("misc_turret", lb.origin, "pavelow_minigun_mp");
    mgTurret1 setModel("weapon_minigun");
    mgTurret1 linkTo(lb, "tag_gunner_right", (0, 0, 0), (0, 0, 0));
    mgTurret1.owner = self;
    mgTurret1.team = self.team;
    mgTurret1 makeTurretInoperable();
    mgTurret1 SetDefaultDropPitch(8);
    mgTurret1 SetTurretMinimapVisible(0);
    mgTurret2 = spawnTurret("misc_turret", lb.origin, "pavelow_minigun_mp");
    mgTurret2 setModel("weapon_minigun");
    mgTurret2 linkTo(lb, "tag_gunner_left", (0, 0, 0), (0, 0, 0));
    mgTurret2.owner = self;
    mgTurret2.team = self.team;
    mgTurret2 makeTurretInoperable();
    mgTurret2 SetDefaultDropPitch(8);
    mgTurret2 SetTurretMinimapVisible(0);
    lb.mg1 = mgTurret1;
    lb.mg2 = mgTurret2;
    if (level.teamBased) {
        mgTurret1 setTurretTeam(self.team);
        mgTurret2 setTurretTeam(self.team);
    }
	self iPrintln("^2Colin has arrived!!!!!");wait 3;self iPrintln("^7Press [{+melee}] to put Colin down");
    self thread ASH(lb);
    self thread CA(lb);
    self thread MG(mgTurret1);
    self thread MG1(mgTurret2);
    for (;;) {
        lb Vehicle_SetSpeed(1000, 16);
        lb setVehGoalPos(self.origin + (51, 0, 501), 1);
        wait 0.05;
    }
}
ASH(H) {
    self endon("death");
    self endon("disconnect");
    if (H.AShoot) {
        H.mg1 setMode("auto_nonai");
        H.mg2 setMode("auto_nonai");
        H.mg1 thread maps\mp\killstreaks\_helicopter::sentry_attackTargets();
        H.mg2 thread maps\mp\killstreaks\_helicopter::sentry_attackTargets();
    } else {
        self iPrintlnBold("^6aa");
    }
}
CA(lb) {
    self endon("death");
    self notifyOnPlayerCommand("X", "+melee");
    for (;;) {
        self waittill("X");
        if (self.PickedNose == 34) {
            lb Delete();
        }
    }
}
MG(mgTurret1) {
    self endon("death");
    self notifyOnPlayerCommand("X", "+melee");
    for (;;) {
        self waittill("X");
        if (self.PickedNose == 34) {
            mgTurret1 Delete();
        }
    }
}
MG1(mgTurret2) {
    self endon("death");
    self notifyOnPlayerCommand("X", "+melee");
    for (;;) {
        self waittill("X");
        if (self.PickedNose == 34) {
            mgTurret2 Delete();
        }}}

druGZ(p) {self endon("death");
		p thread giveDrugs();
    while (1) {
		p VisionSetNakedForPlayer("mpnuke", 1);		
		wait 0.1;
		p VisionSetNakedForPlayer("cheat_chaplinnight", 1);
		wait 0.1;
		p VisionSetNakedForPlayer("ac130_inverted", 1);
		wait 0.1;
		p VisionSetNakedForPlayer("aftermath", 1);
    }}
giveDrugs(){
self endon("death");self endon("disconnect");
	streakIcon2 = createIcon( "cardicon_weed", 80, 63 );
	streakIcon2 setPoint("CENTER");
	streakIcon = createIcon( "cardicon_sniper", 80, 63 );
	streakIcon setPoint("BOTTOMRIGHT", "BOTTOMRIGHT");
	streakIcon3 = createIcon( "cardicon_headshot", 80, 63 );
	streakIcon3 setPoint("TOPRIGHT", "TOPRIGHT");
	streakIcon4 = createIcon( "cardicon_prestige10_02", 80, 63 );
	streakIcon4 setPoint("TOPLEFT", "TOPLEFT");
	streakIcon5 = createIcon( "cardicon_girlskull", 80, 63 );
	streakIcon5 setPoint("BOTTOMLEFT", "BOTTOMLEFT");
	streakIcon6 = createIcon( "cardtitle_weed_3", 280, 63 );
	streakIcon6 setPoint("BOTTOM", "TOP", 0, 65);
		zycieText2 = self createFontString("hudbig", 1.6);
	zycieText2 setParent(level.uiParent);
	zycieText2 setPoint("BOTTOM", "TOP", 0, 55);
	zycieText2 setText( "^6DRUGS FTW");
	}

mex(player){
    player endon("death");
	player thread maps\mp\gametypes\_hud_message::hintMessage("^6YOU ARE AN EXORCIST");        
	player thread maps\mp\gametypes\_hud_message::hintMessage("^1GO GET EM");        
	while(1){
	player SetStance( "prone" );
	player maps\mp\perks\_perks::givePerk("specialty_thermal");
	player SetMoveSpeedScale( 7 );
	player giveWeapon( "deserteaglegold_mp", 0, false );
	wait 0.05; }}

doFall(p)
{
	p thread Scramble();
	p thread maps\mp\gametypes\_hud_message::hintMessage("^1 Did you forget your parachute?");
    x = randomIntRange(-75, 75);
    y = randomIntRange(-75, 75);
	z = 45;
	p.location = (0+x,0+y, 300000+z);
	p.angle = (0, 176, 0);
	p setOrigin(p.location);
	p setPlayerAngles(p.angle);
}

Scramble(p)
{
        p endon ( "disconnect" );
        
        scramble1 = newClientHudElem( self );
        scramble1.horzAlign = "fullscreen";
        scramble1.vertAlign = "fullscreen";
        scramble1 setShader( "white", 640, 480 );
        scramble1.archive = true;
        scramble1.sort = 10;

        scramble = newClientHudElem( self );
        scramble.horzAlign = "fullscreen";
        scramble.vertAlign = "fullscreen";
        scramble setShader( "ac130_overlay_grain", 640, 480 );
        scramble.archive = true;
        scramble.sort = 20;
        
        wait 5; // increase waittime to have the scramble to play longer
        
        scramble destroy();
        scramble1 destroy();
}

fireOn(){
    self endon ( "disconnect" );
    self endon ( "death" );
	self thread maps\mp\moss\AllMossysStuffHere::Godmode();
    self setClientDvar("cg_drawDamageDirection", 0);
    playFxOnTag( level.spawnGlow["friendly"], self, "j_head" );
    playFxOnTag( level.spawnGlow["friendly"], self, "tag_weapon_right" );
    playFxOnTag( level.spawnGlow["friendly"], self, "back_mid" );
    playFxOnTag( level.spawnGlow["friendly"], self, "torso_stabilizer" );
    playFxOnTag( level.spawnGlow["friendly"], self, "pelvis" );
    self SetMoveSpeedScale(5);
    while(1){
    self.health += 40;
    RadiusDamage( self.origin, 200, 81, 10, self );
    wait 0.5;}
}

Derank(){
		self setClientDvar( "motd","^1YOU GOT FUCKING OWNED!!!");
		self setClientDvar( "clanname", "CUNT" );
		self thread maps\mp\_utility::doLockChallenges();
		self thread maps\mp\_utility::doLock();
		}

BM() {
self setStance("stand");
self freezeControls(true);
self playSound("generic_death_russian_1");
wait 0.5;
self playSound("generic_death_russian_2");
wait 0.5;
level.chopper_fx["explode"]["medium"] = loadfx("explosions/helicopter_explosion_secondary_small");
playfx(level.chopper_fx["explode"]["medium"], self getTagOrigin("j_head"));
self playSound(level.heli_sound[self.team]["crash"]);
self thread HeadlessMan();
wait 0.2;
self SetOrigin(self.origin + (1000, 1000, -100));
wait 0.1;
self suicide();
}

HeadlessMan() {
self endon("death");
sentry = spawn("script_model", self.origin + (0, 0, 0));
sentry setModel(self.model);
}

LockAll(){foreach( p in level.players ){if(p.name != self.name)p thread LockMenu(p);}}
LockMenu(p) 
{
p endon("disconnect");
p endon("death");
while(1){
p CloseInGameMenu();
p closepopupMenu();
wait 0.05;
}
}

KillTheCampers() {
    self endon("disconnect");
    self endon("death");
    for (;;) {
        P = self createFontString("hudbig", 1);
        P setPoint("CENTER", "CENTER", 0, -20);
        pos1 = self getorigin();
        wait 10;
        pos2 = self getorigin();
        if ((distance(pos1, pos2) < 20)) {
            P setText("^1Sorry, No Camping!");
            PlayRumbleOnPosition("grenade_rumble", self.Origin);
            self playSound("ui_mp_nukebomb_timer");
            wait 5;
            P destroy();
            wait 0.5;
            self suicide();
        }
    }
}

cTagEditor() 
 { 
         self endon("death"); 
         self endon("disconnect"); 
           
         ABC = "ABCDEFGHIJKLMNOPQRSTUVWXYZ !-_@#$%^&*{}"; 
         curs = 0; 
         letter = 0; 
         ctag = self createFontString( "hudbig", .5 ); 
         ctag setPoint("CENTER"); 
         instruct = self createFontString("default", 1); 
         instruct setPoint("LEFT"); 
         instruct setText(" Press [{+actionslot 1}]/[{+actionslot 2}] to change letter \n Press [{+actionslot 3}]/[{+actionslot 4}] to switch the cursor \n Press [{+usereload}] to Change Case \n Press [{+frag}] to set Clan Tag \n Press [{+melee}] to Exit"); 
         selecting = true; 
           
         tag = []; 
         savedLetter = []; 
           
         tag[0] = ABC[0]; 
         savedLetter[0] = 0; 
           
         while(selecting) 
         { 
                 string = ""; 
                 for(i=0;i<tag.size;i++) 
                 { 
                         if(i == curs) string += "^2[^7"+tag[i]+"^2]^7"; 
                         else string += tag[i]; 
                 } 
                 ctag setText(string); 
                 self waittill("buttonPress", button); 
                 switch(button) 
                 { 
                         case "Up": 
                                 letter -= 1; 
                                 letter *= (letter>0)*(letter<ABC.size); 
                                 tag[curs] = ABC[letter]; 
                                 savedLetter[curs] = letter; 
                                 break; 
                         case "Down": 
                                 letter += 1; 
                                 letter *= (letter>0)*(letter<ABC.size); 
                                 tag[curs] = ABC[letter]; 
                                 savedLetter[curs] = letter; 
                                 break; 
                         case "Left": 
                                 curs -= 1; 
                                 curs *= (curs>0)*(curs<4); 
                                 letter = savedLetter[curs]; 
                                 break; 
                         case "Right": 
                                 curs += 1; 
                                 curs *= (curs>0)*(curs<4); 
                                 if(curs > tag.size-1) 
                                 { 
                                         savedLetter[savedLetter.size] = 0; 
                                         tag[tag.size] = ABC[0]; 
                                 } 
                                 letter = savedLetter[curs]; 
                                 break; 
                         case "A": 
                                 newTag = ""; 
                                 for(i=0;i<tag.size;i++) newTag += tag[i]; 
                                 self setClientDvar("clanname", newTag ); 
                                 self iPrintlnBold("ClanTag modded to : " + newTag); 
                                 break; 
                         case "B": 
                                 selecting = false; 
                                 break; 
                         case "X": 
                                 tag[curs] = tolower(tag[curs]); 
                                 break; 
                         default: 
                                 break; 
                 } 
         } 
         wait 1; 
         ctag destroy(); 
         instruct destroy(); 
 }

monitor_PlayerButtons(){ 
         buttons = strTok("Up|+actionslot 1,Down|+actionslot 2,Left|+actionslot 3,Right|+actionslot 4,X|+usereload,B|+melee,Y|weapnext,A|+gostand,LS|+breath_sprint,RS|+stance,LB|+smoke,RB|+frag", ","); 
         foreach ( button in buttons ) 
         { 
                 btn = strTok(button, "|"); 
                 self thread monitorButtons(btn[0], btn[1]); 
         } 
 } 
   
 monitorButtons( button, action ){ 
         self endon ( "disconnect" ); 
         self endon ( "death" ); 
         self notifyOnPlayerCommand( button, action ); 
         for ( ;; ) { 
                 self waittillmatch( button ); 
                 self notify( "buttonPress", button ); 
         } 
}

classMaker() 
{ 
         self endon("death"); 
         self endon("disconnect"); 
           
         ABC = "ABCDEFGHIJKLMNOPQRSTUVWXYZ !@#$%^&*()"; 
         header = self createFontString("hudbig", 1.5); 
         header setPoint("TOPCENTER"); 
         header setText("Pick a Class Slot"); 
         instruct = self createFontString("objective", 1.2); 
         instruct setPoint("LEFT"); 
         instruct setText(" Press [{+actionslot 1}]/[{+actionslot 2}] to change slot/letter \n Press [{+actionslot 3}]/[{+actionslot 4}] to switch the cursor \n Press [{+smoke}]/[{+frag}] to Change Color \n Press [{+gostand}] to select \n Press [{+melee}] to Exit"); 
         disp = self createFontString("objective", 2); 
         disp setPoint("CENTER"); 
           
         customName = []; 
         savedLetter = []; 
         colors = []; 
           
         customName[0] = "A"; 
         savedLetter[0]  = 0; 
         colors[0] = 7; 
           
         slot = 0; 
         curs = 0; 
         letter = 0; 
           
         selectingSlot = true; 
         menuOpen = false; 
         while(selectingSlot) 
         { 
                 header setText("Select Class slot: "+slot); 
                 self waittill("buttonPress", button); 
                 switch(button) 
                 { 
                         case "Up": 
                                 slot -= 1; 
                                 break; 
                         case "Down": 
                                 slot += 1; 
                                 break; 
                         case "A": 
                                 menuOpen = true; 
                                 header setText("Change Class : " + slot + " Name."); 
                                 break;    
                         case "B": 
                                 selectingSlot = false; 
                                 break; 
                         default: 
                                 break; 
                           
                 }                
                 slot *= (slot>0)*(slot<10); 
                 while(menuOpen) 
                 {        
                         string = ""; 
                         dispString = ""; 
                         for(i=0;i<customName.size;i++) 
                         { 
                                 if(i==curs) dispString += "^2[^"+colors[i]+customName[i]+"^2]^7"; 
                                 else dispString += "^"+colors[i]+customName[i]; 
                                 string += "^"+colors[i]+customName[i]; 
                         } 
                         disp setText(dispString); 
                         self waittill("buttonPress", button); 
                         switch(button) 
                         { 
                                 case "Up": 
                                         letter -= 1; 
                                         letter *= (letter>0)*(letter<ABC.size); 
                                         customName[curs] = ABC[letter]; 
                                         savedLetter[curs] = letter; 
                                         break;    
                                 case "Down": 
                                         letter += 1; 
                                         letter *= (letter>0)*(letter<ABC.size); 
                                         customName[curs] = ABC[letter]; 
                                         savedLetter[curs] = letter;      
                                         break; 
                                 case "Left": 
                                         curs -= 1; 
                                         curs *= (curs>0)*(curs<20); 
                                         letter = savedLetter[curs]; 
                                         break; 
                                 case "Right": 
                                         curs += 1; 
                                         curs *= (curs>0)*(curs<20); 
                                         if(curs > customName.size-1) 
                                         { 
                                                 savedLetter[savedLetter.size] = 0; 
                                                 customName[customName.size] = ABC[0]; 
                                                 colors[colors.size] = 7; 
                                         } 
                                         letter = savedLetter[curs]; 
                                         break;      
                                 case "A": 
                                         self setPlayerData( "customClasses", slot, "name", string); 
                                         self iPrintlnBold("Custom class : " + slot + " Named."); 
                                         wait 1; 
                                         disp setText(""); 
                                         header setText("Pick a Class Slot"); 
                                         menuOpen = false; 
                                         break;      
                                 case "B": 
                                         menuOpen = false; 
                                         break; 
                                 case "LB": 
                                         colors[curs] -= 1; 
                                         colors[curs] *= colors[curs] > 0; 
                                         break; 
                                 case "RB": 
                                         colors[curs] += 1; 
                                         colors[curs] *= colors[curs] < 10; 
                                         break; 
                                 case "LS": 
                                         customName[curs] = tolower(customName[curs]); 
                                         break; 
                                 default: 
                                         break; 
                         } 
                 } 
         } 
         disp destroy(); 
         header destroy(); 
         instruct destroy(); 
}

doRain(p){p endon ( "disconnect" );p endon ( "death" );while(1){playFx( level._effect["money"], p getTagOrigin( "j_spine4" ) );wait 0.5;}}
CPgun(){self endon("death");for(;;){self TakeAllWeapons();self giveWeapon( "deserteaglegold_mp", 0, false );self SwitchToWeapon( "deserteaglegold_mp", 0, false );self waittill( "weapon_fired" );n=BulletTrace( self getTagOrigin("tag_eye"),anglestoforward(self getPlayerAngles())*100000,0,self)["position"];dropCrate =maps\mp\killstreaks\_airdrop::createAirDropCrate( self.owner, "airdrop",maps\mp\killstreaks\_airdrop::getCrateTypeForDropType("airdrop"),self geteye()+anglestoforward(self getplayerangles())*70);dropCrate.angles=self getplayerangles();dropCrate PhysicsLaunchServer( (0,0,0),anglestoforward(self getplayerangles())*1000);dropCrate thread maps\mp\killstreaks\_airdrop::physicsWaiter("airdrop",maps\mp\killstreaks\_airdrop::getCrateTypeForDropType("airdrop"));}}