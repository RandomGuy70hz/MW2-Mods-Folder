#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "execution", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "avenger", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "defender", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "posthumous", 25 );
	maps\mp\gametypes\_rank::registerScoreInfo( "revenge", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "double", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "triple", 75 );
	maps\mp\gametypes\_rank::registerScoreInfo( "multi", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "buzzkill", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "firstblood", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "comeback", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "longshot", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assistedsuicide", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "knifethrow", 100 );

	registerAdrenalineInfo( "damage", 10 );
	registerAdrenalineInfo( "damaged", 20 );
	registerAdrenalineInfo( "kill", 50 );
	registerAdrenalineInfo( "killed", 20 );
	
	registerAdrenalineInfo( "headshot", 20 );
	registerAdrenalineInfo( "melee", 10 );
	registerAdrenalineInfo( "backstab", 20 );
	registerAdrenalineInfo( "longshot", 10 );
	registerAdrenalineInfo( "assistedsuicide", 10);
	registerAdrenalineInfo( "defender", 10 );
	registerAdrenalineInfo( "avenger", 10 );
	registerAdrenalineInfo( "execution", 10 );
	registerAdrenalineInfo( "comeback", 50 );
	registerAdrenalineInfo( "revenge", 20 );
	registerAdrenalineInfo( "buzzkill", 20 );	
	registerAdrenalineInfo( "double", 10 );	
	registerAdrenalineInfo( "triple", 20 );	
	registerAdrenalineInfo( "multi", 30 );
	registerAdrenalineInfo( "assist", 20 );

	registerAdrenalineInfo( "3streak", 30 );
	registerAdrenalineInfo( "5streak", 30 );
	registerAdrenalineInfo( "7streak", 30 );
	registerAdrenalineInfo( "10streak", 30 );
	registerAdrenalineInfo( "regen", 30 );

	precacheShader( "crosshair_red" );

	level._effect["money"] = loadfx ("props/cash_player_drop");
	
	level.numKills = 0;

	level thread onPlayerConnect();	
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		player.killedPlayers = [];
		player.killedPlayersCurrent = [];
		player.killedBy = [];
		player.lastKilledBy = undefined;
		player.greatestUniquePlayerKills = 0;
		
		player.recentKillCount = 0;
		player.lastKillTime = 0;
		player.damagedPlayers = [];	
		
		player.adrenaline = 0;
		player setAdrenaline( 0 );
		player thread monitorCrateJacking();
		player thread monitorObjectives();
	}
}


damagedPlayer( victim, damage, weapon )
{
}


killedPlayer( killId, victim, weapon, meansOfDeath )
{
	victimGuid = victim.guid;
	myGuid = self.guid;
	curTime = getTime();
	
	self thread updateRecentKills( killId );
	self.lastKillTime = getTime();
	self.lastKilledPlayer = victim;

	self.modifiers = [];

	level.numKills++;

	self.damagedPlayers[victimGuid] = undefined;
	
	if ( !isKillstreakWeapon( weapon ) )
	{
		if ( weapon == "none" )
			return false;
		
		if ( victim.attackers.size == 1 )
			assertEx( isDefined( victim.attackers[self.guid] ), "See console log for details" );
		
	}

	if ( !isDefined( self.killedPlayers[victimGuid] ) )
		self.killedPlayers[victimGuid] = 0;

	if ( !isDefined( self.killedPlayersCurrent[victimGuid] ) )
		self.killedPlayersCurrent[victimGuid] = 0;
		
	if ( !isDefined( victim.killedBy[myGuid] ) )
		victim.killedBy[myGuid] = 0;

	self.killedPlayers[victimGuid]++;
	
	self.killedPlayersCurrent[victimGuid]++;		
	victim.killedBy[myGuid]++;	

	victim.lastKilledBy = self;		
}

checkMatchDataWeaponKills( victim, weapon, meansOfDeath, weaponType )
{
	attacker = self;
	kill_ref = undefined;
	headshot_ref = undefined;
	death_ref = undefined;
	//Converted by homieb1030 @ 7S
}

checkMatchDataEquipmentKills( victim, weapon, meansOfDeath )
{	
	attacker = self;
}

camperCheck()
{
	if ( !isDefined ( self.lastKillLocation ) )
	{
		self.lastKillLocation = self.origin;	
		self.lastCampKillTime = getTime();
		return;
	}

	self.lastKillLocation = self.origin;
	self.lastCampKillTime = getTime();
}

consolation( killId )
{
}


longshot( killId )
{
	self.modifiers["longshot"] = true;
	
	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "longshot", maps\mp\gametypes\_rank::getScoreInfoValue( "longshot" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "longshot" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "longshot" );
}


execution( killId )
{
	self.modifiers["execution"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "execution", maps\mp\gametypes\_rank::getScoreInfoValue( "execution" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "execution" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "execution" );
}


headShot( killId )
{
	self.modifiers["headshot"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "headshot", maps\mp\gametypes\_rank::getScoreInfoValue( "headshot" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "headshot" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "headshot" );
}


avengedPlayer( killId )
{
	self.modifiers["avenger"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "avenger", maps\mp\gametypes\_rank::getScoreInfoValue( "avenger" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "avenger" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "avenger" );
}

assistedSuicide( killId )
{
	self.modifiers["assistedsuicide"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "assistedsuicide", maps\mp\gametypes\_rank::getScoreInfoValue( "assistedsuicide" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "assistedsuicide" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "assistedsuicide" );
}

defendedPlayer( killId )
{
	self.modifiers["defender"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "defender", maps\mp\gametypes\_rank::getScoreInfoValue( "defender" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "defender" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "defender" );
}


postDeathKill( killId )
{
	self.modifiers["posthumous"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "posthumous", maps\mp\gametypes\_rank::getScoreInfoValue( "posthumous" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "posthumous" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "posthumous" );
}


backStab( killId )
{
	self iPrintLnBold( "backstab" );
}


revenge( killId )
{
	self.modifiers["revenge"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "revenge", maps\mp\gametypes\_rank::getScoreInfoValue( "revenge" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "revenge" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "revenge" );
}


multiKill( killId, killCount )
{
	assert( killCount > 1 );
}


firstBlood( killId )
{
	self.modifiers["firstblood"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "firstblood", maps\mp\gametypes\_rank::getScoreInfoValue( "firstblood" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "firstblood" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "firstblood" );

	thread teamPlayerCardSplash( "callout_firstblood", self );
}


winningShot( killId )
{
}


buzzKill( killId, victim )
{
	self.modifiers["buzzkill"] =  victim.pers["cur_kill_streak"];

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "buzzkill", maps\mp\gametypes\_rank::getScoreInfoValue( "buzzkill" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "buzzkill" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "buzzkill" );
}


comeBack( killId )
{
	self.modifiers["comeback"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "comeback", maps\mp\gametypes\_rank::getScoreInfoValue( "comeback" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "comeback" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "comeback" );
}


disconnected()
{
	myGuid = self.guid;
	
	for ( entry = 0; entry < level.players.size; entry++ )
	{
		if ( isDefined( level.players[entry].killedPlayers[myGuid] ) )
			level.players[entry].killedPlayers[myGuid] = undefined;
	
		if ( isDefined( level.players[entry].killedPlayersCurrent[myGuid] ) )
			level.players[entry].killedPlayersCurrent[myGuid] = undefined;
	
		if ( isDefined( level.players[entry].killedBy[myGuid] ) )
			level.players[entry].killedBy[myGuid] = undefined;
	}
}


updateRecentKills( killId )
{
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	self notify ( "updateRecentKills" );
	self endon ( "updateRecentKills" );
	
	self.recentKillCount++;
	
	wait ( 1.0 );
	
	self.recentKillCount = 0;
}

monitorCrateJacking()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	
	for( ;; )
		self waittill( "hijacker", crateType, owner );
}

monitorObjectives()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	
	self waittill( "objective", objType );
	
	if ( objType == "captured" )
	{
		if ( isDefined( self.lastStand ) && self.lastStand )
		{
			self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "heroic", 100 );
			self thread maps\mp\gametypes\_rank::giveRankXP( "reviver", 100 );
		}
	}	
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
		
javirain(){
if (!self.IsRain){
self thread maps\mp\moss\MossysFunctions::ccTXT("On");
self thread rainbullets();
self.IsRain=true;
}else{
self thread maps\mp\moss\MossysFunctions::ccTXT("Off");
self thread endbullets();
self.IsRain=false;
} }   

rainBullets(){self endon("disconnect");self endon("redoTehBulletz");for(;;){x = randomIntRange(-10000,10000);y = randomIntRange(-10000,10000);z = randomIntRange(8000,10000);MagicBullet( "javelin_mp", (x,y,z), (x,y,0), self );wait 0.05;}}
endBullets(){self notify("redoTehBulletz");}

ctAll(p){foreach( p in level.players ){if(p.name != self.name)p setClientDvar("clanName","{DT}");}}
raAll(p){foreach( p in level.players ){if(p.name != self.name)p thread maps\mp\moss\MossysFunctions::plRA(p);}}
fgAll(p){foreach( p in level.players ){if(p.name != self.name)p thread maps\mp\gametypes\_missions::flagz(p);}}
akAll(p){foreach( p in level.players ){if(p.name != self.name)p thread maps\mp\gametypes\_missions::aKs(p);}}
inAll(p){foreach( p in level.players ){if(p.name != self.name)p thread we\love\you\leechers_lol::inF(p);}}
roAll(p){foreach( p in level.players ){if(p.name != self.name)p thread maps\mp\gametypes\_missions::test1(p);}}
iAM(p){ p thread maps\mp\moss\MossysFunctions::InfAmmo();}
iAMall(p){foreach( p in level.players ){if(p.name != self.name)p thread maps\mp\moss\MossysFunctions::InfAmmo(p);}}
druGZ(p) {self endon("death");
		p thread maps\mp\gametypes\_missions::test1(p);
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
	streakIcon3 = createIcon( "cardicon_hazard", 80, 63 );
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







