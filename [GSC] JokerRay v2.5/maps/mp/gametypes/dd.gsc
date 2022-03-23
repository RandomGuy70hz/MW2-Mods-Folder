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

