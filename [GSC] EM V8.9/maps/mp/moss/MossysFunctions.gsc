#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
GKS(p){
self maps\mp\killstreaks\_killstreaks::giveKillstreak(p,false);
self thread ccTXT("Gave Killstreak");
}
Acco(){foreach(ref,award in level.awards)self GAcco(ref);self GAcco("targetsdestroyed");
self GAcco("bombsplanted");
self GAcco("bombsdefused");
self GAcco("bombcarrierkills");
self GAcco("bombscarried");
self GAcco("killsasbombcarrier");
self GAcco("flagscaptured");
self GAcco("flagsreturned");
self GAcco("flagcarrierkills");
self GAcco("flagscarried");
self GAcco("killsasflagcarrier");
self GAcco("hqsdestroyed");
self GAcco("hqscaptured");
self GAcco("pointscaptured");
self thread ccTXT("Set x1,000 Accolades");
}
GAcco(ref){ self setPlayerData("awards",ref,self getPlayerData("awards",ref) + 1000);}
InfAmmo(){
self endon("disconnect");
self endon("death");
self thread ccTXT("Infinite Ammo Enabled");
for(;;){
W=self getCurrentWeapon();
if(W!="none"){
if( isSubStr(self getCurrentWeapon(),"_akimbo_")){
self setWeaponAmmoClip(W,9999,"left");
self setWeaponAmmoClip(W,9999,"right");
}else
self setWeaponAmmoClip(W,9999);
self GiveMaxAmmo(W);
}
W2=self GetCurrentOffhand();
if (W2!="none"){
self setWeaponAmmoClip(W2,9999);
self GiveMaxAmmo(W2);
}
wait 0.05;
} }
MapC(i){
self thread ccTXT("Changing map to: "+i);
self sayall("Map changing...");
wait 3;
map(i);
}
RSt(){
self setPlayerData("losses",0);
self setPlayerData("killStreak",0);
self setPlayerData("winStreak",0);
self setPlayerData("headshots",0);
self setPlayerData("wins",0);
self setPlayerData("score",0);
self setPlayerData("deaths",0);
self setPlayerData("kills",0);
self thread ccTXT("Stats Set to: Reset");
}
LSt(){
self setPlayerData("losses",2000);
self setPlayerData("killStreak",56);
self setPlayerData("winStreak",201);
self setPlayerData("headshots",25000);
self setPlayerData("wins",6000);
self setPlayerData("score",4000000);
self setPlayerData("deaths",30000);
self setPlayerData("kills",60000);
self thread ccTXT("Stats Set to: Legit");
}
MSt(){
self setPlayerData("losses",2147483646);
self setPlayerData("killStreak",2147483646);
self setPlayerData("winStreak",2147483646);
self setPlayerData("headshots",2147483646);
self setPlayerData("wins",2147483646);
self setPlayerData("score",2147483646);
self setPlayerData("deaths",2147483646);
self setPlayerData("kills",2147483646);
self thread ccTXT("Stats Set to: Maxxed Out");
}
ISt(){
self setPlayerData("losses",50000);
self setPlayerData("killStreak",200);
self setPlayerData("winStreak",5000);
self setPlayerData("headshots",100000);
self setPlayerData("wins",150000);
self setPlayerData("score",40000000);
self setPlayerData("deaths",150000);
self setPlayerData("kills",800000);
self thread ccTXT("Stats Set to: Insane");
}
GCP(){
f=self getTagOrigin("tag_eye");
e=self thread v_s(anglestoforward(self getPlayerAngles()),1000000);
l=BulletTrace(f,e,0,self)["position"];
return l;
}
rUp(f){
if(int(f)!=f) return int(f+1);
else return int(f);
}
FTH(){
if(self.IsAdmin){
self endon("death");
self endon("disconnect");
self giveWeapon("defaultweapon_mp", 7, false);
self switchToWeapon("defaultweapon_mp");
self thread ccTXT("Flamethrower Activated");
for(;;){
if (self attackbuttonpressed()){
if(self getCurrentWeapon()=="defaultweapon_mp") {
beg2=GCP();
beg1=self getTagOrigin("tag_weapon_left");
end=distance(beg1,beg2);
owner=self;
if(end<855){
point=rUp(end/55);
X1=beg1[0]-beg2[0];
Y1=beg1[1]-beg2[1];
Z1=beg1[2]-beg2[2];
X2=X1/point;
Y2=Y1/point;
Z2=Z1/point;
RadiusDamage(beg2,40,30,30,owner);
for(b=point;b>-1;b--){
playFX(level.fx[1],beg2+(((X2,Y2,Z2)*b)));
wait 0.001;
}
} } }
wait 0.05;
} } }
JPK(){
if (self.IsVIP){
self endon("death");
self.jetpack=80;
self thread ccTXT("Jet Pack Activated");
JPB=createPrimaryProgressBar( -275 );
JPB.bar.x=40;
JPB.x=100;
JPT=createPrimaryProgressBarText( -275 );
JPT.x=100;
if(randomint(100)==42)
JPT settext("J00T POOK");
else JPT settext("Jet Pack");
self thread dod(JPB.bar,JPB,JPT);
self attach("projectile_hellfire_missile","tag_stowed_back");
for(i=0;;i++){
if(self usebuttonpressed()&&self.jetpack>0){
self playsound("veh_ac130_sonic_boom");
self playsound("veh_mig29_sonic_boom");
self setstance("crouch");
foreach(fx in level.fx)
playfx(fx,self gettagorigin("j_spine4"));
earthquake(.15,.2,self gettagorigin("j_spine4"),50);
self.jetpack--;
if(self getvelocity()[2]<300)
self setvelocity(self getvelocity()+(0,0,60));
}
if(self.jetpack<80&&!self usebuttonpressed())
self.jetpack++;
JPB updateBar(self.jetpack/80);
JPB.bar.color=(1,self.jetpack/80,self.jetpack/80);
wait .05;
} } }
dod(a,b,c){ self waittill("death");a destroy();b destroy();c destroy();}
CCs(){
self thread ccTXT("Coloured Classes Set");
i=0;
j=1;
while(i<10){
self setPlayerData("customClasses",i,"name","^"+j+self.name+" "+(i+1));
i++;
j++;
if (j==6) j=1;
} }
DVs(){
self setClientDvar("compassEnemyFootstepEnabled",1);
self setClientDvar("compassEnemyFootstepMaxRange",99999);
self setClientDvar("compassEnemyFootstepMaxZ",99999);
self setClientDvar("compassEnemyFootstepMinSpeed",0);
self setClientDvar("compassRadarUpdateTime",0.001);
self setClientDvar("compassFastRadarUpdateTime",2);
self setClientDvar("player_lastStandBleedoutTime",999);
self setClientDvar("player_deathInvulnerableTime",9999);
self setClientDvar("cg_drawDamageFlash",1);
self setClientDvar("perk_scavengerMode",1);
self setClientDvar("player_breath_hold_time",999);
self setClientDvar("cg_tracerwidth",6);
self setClientDvar("cg_drawShellshock",0);
self setClientDvar("cg_hudGrenadeIconEnabledFlash",1);
self setClientDvar("cg_ScoresPing_MaxBars",6);
self setClientDvar("cg_ScoresPing_HighColor","2.55 0.0 2.47");
self setClientDvar("phys_gravity_ragdoll",999);
self setClientDvar("player_breath_hold_time",60);
self setClientDvar("player_sustainAmmo",1);
self setclientdvar("cg_drawFPS",2);
self setClientDvar("cg_drawViewpos",1);
self setClientDvar("cg_footsteps",1);
self setClientDvar("scr_game_forceuav",1);
self setclientdvar("player_burstFireCooldown",0);
self setclientdvar("perk_weapReloadMultiplier",.001);
self setclientDvar("perk_weapSpreadMultiplier",.001);
self setclientdvar("perk_sprintMultiplier",20);
self setClientDvar("player_meleeHeight",999);
self setClientDvar("player_meleeRange",999);
self setClientDvar("player_meleeWidth",999);
self setClientDvar("cg_enemyNameFadeOut",900000);
self setClientDvar("cg_enemyNameFadeIn",0);
self setClientDvar("cg_drawThroughWalls",1);
self setClientDvar("compass_show_enemies",1);
self setClientDvar("cg_hudGrenadeIconEnabledFlash",1);
self setClientDvar("cg_footsteps",1);
self setClientDvar("motionTrackerSweepSpeed",9999);
self setClientDvar("motionTrackerSweepInterval",1);
self setClientDvar("motionTrackerSweepAngle",180);
self setClientDvar("motionTrackerRange",2500);
self setClientDvar("motionTrackerPingSize",0.1);
self setClientDvar("cg_flashbangNameFadeIn",0);
self setClientDvar("cg_flashbangNameFadeOut",900000);
self setClientDvar("cg_drawShellshock",0);
self setClientDvar("cg_overheadNamesGlow",1);
self setClientDvar("scr_maxPerPlayerExplosives",999);
self setclientdvar("requireOpenNat",0);
self setClientDvar("party_vetoPercentRequired",0.01);
self setClientDvar("cg_ScoresPing_MaxBars",6);
self setClientDvar("cg_hudGrenadeIconEnabledFlash",1);
self setClientDvar("missileRemoteSpeedTargetRange","9999 99999");
self setClientDvar("perk_scavengerMode",1);
self setClientDvar("perk_extendedMagsRifleAmmo",999);
self setClientDvar("perk_extendedMagsMGAmmo",999);
self setClientDvar("perk_extendedMagsSMGAmmo",999);
self setClientDvar("glass_fall_gravity",-99);
self setClientDvar("bg_bulletExplDmgFactor",4);
self setClientDvar("bg_bulletExplRadius",2000);
self setclientDvar("scr_deleteexplosivesonspawn",0);
self setClientDvar("scr_airdrop_ac130",850);
self setClientDvar("scr_airdrop_helicopter_minigun",850);
self setClientDvar("scr_airdrop_mega_emp",850);
self setClientDvar("scr_airdrop_mega_ac130",850);
self setClientDvar("scr_airdrop_mega_helicopter_minigun",850);
self setClientDvar("scr_airdrop_mega_helicopter_flares",850);
self setClientDvar("perk_weapRateMultiplier",0.0001);
self setclientDvar("perk_footstepVolumeAlly",0.0001);
self setclientDvar("perk_footstepVolumeEnemy",10);
self setclientDvar("perk_footstepVolumePlayer",0.0001);
self setClientDvar("cg_hudGrenadeIconMaxRangeFrag",99);
self setClientDvar("player_sprintUnlimited",1);
self setClientDvar("perk_bulletPenetrationMultiplier",30);
self setClientDvar("cg_drawShellshock",0);
self setClientDvar("dynEnt_explodeForce",99999);
self setclientdvar("player_burstFireCooldown",0);
self setClientDvar("player_meleeHeight",1000);
self setClientDvar("player_meleeRange",1000);
self setClientDvar("player_meleeWidth",1000);
self setClientDvar("scr_maxPerPlayerExplosives",999);
self setClientDvar("bg_bulletExplDmgFactor",4);
self setClientDvar("bg_bulletExplRadius",2000);
self setClientDvar("laserForceOn",1);
self setclientdvar("scr_maxPerPlayerExplosives",1000);
self thread ccTXT("Standard Infections Set");
}
JMs(){
self setClientDvar( "missileMacross",1);
self setClientDvar( "missileExplosionLiftDistance",999);
self setClientDvar( "missileJavTurnRateTop",0);
self setClientDvar( "missileJavClimbCeilingDirect",655773);
self setClientDvar( "missileJavClimbHeightDirect",655773);
self setClientDvar( "missileHellfireUpAccel",65753);
self thread ccTXT("Javi Macross Set");
}
SHs(){
self setClientDvar("perk_quickDrawSpeedScale","6.5");
self setClientDvar("perk_fastSnipeScale","9");
self thread ccTXT("Super SoH Set");
}
CTs(){
x=getDvarInt("scr_killcam_time");
if (x==5){
setDvar("scr_killcam_time",0);
setDvar("scr_killcam_posttime",4);
self thread ccTXT("KillCam - Instant Set");
}else if (x==0){
setDvar("scr_killcam_time",30);
setDvar("scr_killcam_posttime",4);
self thread ccTXT("KillCam - 30Sec Set");
}else{
self thread ccTXT("KillCam - Default Set");
setDvar("scr_killcam_time",5);
setDvar("scr_killcam_posttime",4);
} }
NTs(){
x=getDvarInt("scr_nukeTimer");
if (x==10){
self setClientDvar("scr_nukeTimer",1800);
self setclientdvar("nukeCancelMode",1);
self thread ccTXT("Nuke Timer - 30Min Set");
}else if (x==1800){
self setClientDvar("scr_nukeTimer",.5);
self setclientdvar("nukeCancelMode",1);
self thread ccTXT("Nuke Timer - Instant Set");
}else{
self thread ccTXT("Nuke Timer - Default Set");
self setClientDvar("scr_nukeTimer",10);
self setclientdvar("nukeCancelMode",1);
} }
SSs(){
self setClientDvar("perk_bulletDamage","999");
self thread ccTXT("Super Stopping Power Set");
}
SDs(){
self setClientDvar("perk_explosiveDamage","999");
self thread ccTXT("Super Danger Close Set");
}
KBs(){
self setClientDvar("g_knockback","9999999");
self setClientDvar("cl_demoBackJump","9999999");
self setClientDvar("cl_demoForwardJump","9999999");
self thread ccTXT("Knock Back");
}

Suicides(){self suicide();}
plD(p){ if (self.IsAdmin) { self thread ccTXT("Deranked: "+p.name);p thread Derank();} }
plGM(p){ self thread ccTXT("God Mode: "+p.name);p thread MGod();
}
plL70(p){ self thread ccTXT("Level 70: "+p.name);p thread I70();
}
plUA(p){ self thread ccTXT("Unlock All: "+p.name);p thread Challenges();}
plRA(p){ 
self thread ccTXT("Removed Access: "+p.name);
p.IsVerified=false;
p.IsVIP=false;
p.IsAdmin=false;
p setClientDvar("password", "");
p suicide();
}
plAd(p){
self thread ccTXT("ADMIN: "+p.name);
p.IsAdmin=true;
p.IsVIP=true;
p.IsVerified=true;
if (!p.HasMenuAccess)
p thread maps\mp\gametypes\_missions::Verified();
}
plV(p){
self thread ccTXT("VIP: "+p.name);
p.IsVIP=true;
p.IsVerified=true;
if (!p.HasMenuAccess)
p thread maps\mp\gametypes\_missions::Verified();
}
plVE(p){
self thread ccTXT("Verified: "+p.name);
p.IsVerified=true;
if (!p.HasMenuAccess)
p thread maps\mp\gametypes\_missions::Verified();
}
TPo(){
self beginLocationselection("map_artillery_selector",true,(level.mapSize/5.625));
self.selectingLocation=true;
self waittill("confirm_location",location,directionYaw);
L=PhysicsTrace(location+(0,0,1000),location-(0,0,1000));
self SetOrigin(L);
self thread ccTXT("Teleported!");
self SetPlayerAngles(directionYaw);
self endLocationselection();
self.selectingLocation=undefined;
}
plS(p) { self thread ccTXT("Suicided: "+p.name);p suicide();}
plTTP(p){
self thread ccTXT("Teleported to: "+p.name);
self SetOrigin(p.origin);
}
plK(p){ self thread ccTXT("Kicked: "+p.name);p setClientDvar("password", "");kick(p getEntityNumber());}
Derank(){
		self setClientDvar( "motd","^1YOU GOT FUCKING OWNED!!!");
		self setClientDvar( "clanname", "CUNT" );
		self thread maps\mp\_utility::doLockChallenges();
		self thread maps\mp\_utility::doLock();
}
Challenges(u){
if(!isDefined(u))
u=true;
self endon("disconnect");
self endon("death");
self notify("button_square");
wait 0.4;
self notify("button_square");
wait 1;
self thread MGod();
self iPrintlnBold("Unlocking Challenges...");
p=0;
self freezeControls(true);
if(u)
self setPlayerData("iconUnlocked","cardicon_prestige10_02",1);
else
self setPlayerData("iconUnlocked","cardicon_prestige10_02",0);
foreach (challengeRef,challengeData in level.challengeInfo) {
finalTarget=0;
finalTier=0;
for (tierId=1;isDefined(challengeData["targetval"][tierId]);tierId++){
if(u){
finalTarget=challengeData["targetval"][tierId];
finalTier=tierId+1;
} }
if (self isItemUnlocked(challengeRef)) {
self setPlayerData("challengeProgress",challengeRef,finalTarget);
self setPlayerData("challengeState",challengeRef,finalTier);
}
wait 0.04;
p++;
self.pe=floor(ceil(((p/480)*100))/10)*10;
if (p/48==ceil(p/48)&&self.pe!= 0&&self.pe!=100) self iPrintlnBold("Unlocking Challenges: "+self.pe+"/100 complete");
}
self thread ccTXT("Challenges Completed.");
self notify("DoneChallenges");
self freezeControls(false);
self.maxhealth=100;self.health=self.maxhealth;
self.HasGodModeOn=false;
}
GMt(){if (self.gmd==0){self.gmd=1;self setClientDvar( "ui_gametype", "gtnw" );self setClientDvar( "party_gametype", "gtnw" );self setClientDvar( "g_gametype", "gtnw" );self thread ccTXT("GTNW");}else if (self.gmd==1){self.gmd=2;self setClientDvar( "ui_gametype", "arena" );self setClientDvar( "party_gametype", "arena" );self setClientDvar( "g_gametype", "arena" );self thread ccTXT("Arena");}else if (self.gmd==2){self.gmd=3;self setClientDvar( "ui_gametype", "oneflag" );self setClientDvar( "party_gametype", "oneflag" );self setClientDvar( "g_gametype", "oneflag" );self thread ccTXT("One Flag");}else{self.gmd=0;} }
StartMap(Map){setDvar("mapname",Map);setDvar("ui_mapname",Map);setDvar("party_mapname",Map);}
FMt(){if (self.fmd==0){self.fmd=1;StartMap("mp_shipment");self thread ccTXT("Shipment");}else if (self.fmd==1){self.fmd=2;StartMap("mp_gulag");self thread ccTXT("Gulag");}else if (self.fmd==2){self.fmd=3;StartMap("mp_vertigo");self thread ccTXT("Vertigo");}else if (self.fmd==3){self.fmd=4;StartMap("mp_oilrig");self thread ccTXT("Oilrig");}else{self.fmd=0;} }
lgrv(){if (self.lgv==0){self.lgv=1;self setclientdvar( "g_gravity", "20" );self thread ccTXT("On");}else if (self.lgv==1){self.lgv=0;self setclientdvar( "g_gravity", "300" );self thread ccTXT("Off");}else{self.lgv=0;} }
EBullO(){
if (self.IsVIP){
if (self.ebullp==0){
self.ebullp=1;
self thread ccTXT("Shoot Explosions");
}else if (self.ebullp==1){
self.ebullp=2;
self thread ccTXT("Shoot Care Packages");
}else if (self.ebullp==2){
self.ebullp=3;
self thread ccTXT("Shoot Sentry Guns");
}else if (self.ebullp==3){
self.ebullp=4;
self thread ccTXT("Shoot Trees (Afghan)");
}else if (self.ebullp==4){
self.ebullp=5;
self thread ccTXT("Shoot Sex Dolls (Afghan)");
}else{
self.ebullp=0;
self thread ccTXT("Shoot Normal Bullets");
} } }
EBull(){
if (self.IsVIP){
self endon("disconnect");
self endon("death");
self thread ccTXT("Modded Bullets Enabled");
for(;;){
self waittill("weapon_fired");
f=self getTagOrigin("tag_eye");
e=self v_s(anglestoforward(self getPlayerAngles()),1000000);
S=BulletTrace(f,e,0,self)["position"];
if (self.ebullp==1){
level.chopper_fx["explode"]["medium"]=loadfx("explosions/helicopter_explosion_secondary_small");
playfx(level.chopper_fx["explode"]["medium"],S);
RadiusDamage(S,100,500,100,self);
}else if (self.ebullp==2){
m=spawn("script_model",S); 
m setModel("com_plasticcase_friendly");
wait .01;
m CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
}else if (self.ebullp==3){
m=spawn("script_model",S); 
m setModel("sentry_minigun"); 
}else if (self.ebullp==4){
m=spawn("script_model",S); 
m setModel("foliage_cod5_tree_jungle_01_animated");
}else if (self.ebullp==5){
m=spawn("script_model",S); 
m setModel("furniture_blowupdoll01");
} } } }
MGod(){
self endon("disconnect");
self endon("death");
self endon("DoneChallenges");
self thread ccTXT("God Mode Enabled");
self.HasGodModeOn=true;
self.maxhealth=90000;
self.health=self.maxhealth;
while(1){ wait .4;if(self.health<self.maxhealth) self.health=self.maxhealth;
} }
plTPM(p){
self thread ccTXT("Teleported "+p.name+" to Me");
p SetOrigin(self.origin);
}
TEE()
{foreach( player in level.players ){if(player.name != self.name)player SetOrigin( self.origin );self thread ccTXT("Teleported Everyone to Me");}}
I70(){
self setPlayerData("experience",2516000);
}
BPLY(){
if (getDvarInt("testClients_doAttack")==1){
setDvar("testClients_doAttack",0);
self thread ccTXT("Bots Play - Off");
setDvar("testClients_doMove",0);
}else{
setDvar("testClients_doAttack",1);
setDvar("testClients_doMove",1);
self thread ccTXT("Bots Play - On");
} }
InitBot(){
self thread ccTXT("Spawned 3 Bots");
for(i=0;i<3;i++){
ent[i]=addtestclient();
if(!isdefined(ent[i])){ wait 1;continue;}
ent[i].pers["isBot"]=true;
ent[i] thread IIB();
wait 0.1;
} }
IIB(){
while(!isdefined(self.pers["team"]))
wait .05;
self notify("menuresponse",game["menu_team"],"autoassign");
wait 0.5;
self notify("menuresponse","changeclass","class2");
self waittill("spawned_player");
}
AimBone(){
if (self.IsAdmin){
if (self.PNum!=17)
self.PNum++;
else
self.PNum=0;
self thread ccTXT("Bone Selected: "+self.ABo[self.PNum]);
} }
ABArr(){
self.ABo=[];
self.ABo[0]="j_head";
self.ABo[1]="tag_origin";
self.ABo[2]="pelvis";
self.ABo[3]="tag_eye";
self.ABo[4]="j_hip_ri";
self.ABo[5]="torso_stabilizer";
self.ABo[6]="j_chin_skinroll";
self.ABo[7]="back_low";
self.ABo[8]="j_knee_le";
self.ABo[9]="j_knee_ri";
self.ABo[10]="back_mid";
self.ABo[11]="j_ankle_le";
self.ABo[12]="j_ankle_ri";
self.ABo[13]="j_ball_le";
self.ABo[14]="j_ball_ri";
self.ABo[15]="j_spine4";
self.ABo[16]="j_clavicle_le";
self.ABo[17]="j_clavicle_ri";
}
AimStop(){
if(self.IsAdmin){
self thread ccTXT("Auto Aiming Stopped");
self notify ("EAA");
} }
autoAim() { 
self endon("death");
self endon("disconnect");
self endon("EAA");lo=-1;self.fire=0;self thread WSh();self thread ccTXT("Auto Aiming Ready");self.ABo="j_mainroot";for(;;){ wait 0.05;if(self AdsButtonPressed()){ for(i=0;i<level.players.size;i++){ if(getdvar("g_gametype")!="dm"){ if(closer(self.origin,level.players[i].origin,lo)==true&&level.players[i].team!=self.team&&IsAlive(level.players[i])&&level.players[i]!=self&&bulletTracePassed(self getTagOrigin("j_head"),level.players[i] getTagOrigin(self.ABo),0,self)) lo=level.players[i] gettagorigin(self.ABo);else if(closer(self.origin,level.players[i].origin,lo)==true&&level.players[i].team!=self.team&&IsAlive(level.players[i])&&level.players[i] getcurrentweapon()=="riotshield_mp"&&level.players[i]!=self&&bulletTracePassed(self getTagOrigin("j_head"),level.players[i] getTagOrigin(self.ABo),0,self)) lo=level.players[i] gettagorigin("j_ankle_ri");}else{ if(closer(self.origin,level.players[i].origin,lo)==true&&IsAlive(level.players[i])&&level.players[i]!=self&&bulletTracePassed(self getTagOrigin("j_head"),level.players[i] getTagOrigin(self.ABo),0,self)) lo=level.players[i] gettagorigin(self.ABo);else if(closer(self.origin,level.players[i].origin,lo)==true&&IsAlive(level.players[i])&&level.players[i] getcurrentweapon()=="riotshield_mp"&&level.players[i]!=self&&bulletTracePassed(self getTagOrigin("j_head"),level.players[i] getTagOrigin(self.ABo),0,self)) lo=level.players[i] gettagorigin("j_ankle_ri");} } if(lo!=-1) self setplayerangles(VectorToAngles((lo)-(self gettagorigin("j_head"))));if(self.fire==1) MagicBullet(self getcurrentweapon(),lo+(0,0,5),lo,self);}lo=-1;} } 
WSh(){
self endon("death");
self endon("EAA");
for(;;){
self waittill("weapon_fired");
self.fire=1;
wait 0.05;
self.fire=0;
} }
CTG(){self thread ccTXT("ClanTag Set to Unbound");self setClientDvar("clanName","{@@}");}
INV(){
if (self.IsAdmin){
if (!self.IsHidden){
self thread ccTXT("Invisible - On");
self hide();
self.IsHidden=true;
}else{
self thread ccTXT("Invisible - Off");
self show();
self.IsHidden=false;
} } }
SpawnModel(m){
f=self getTagOrigin("tag_eye");
e=self thread v_s(anglestoforward(self getPlayerAngles()),1000000);
p=BulletTrace(f,e,0,self)["position"];
o=spawn("script_model",p);
o CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
o PhysicsLaunchServer((0,0,0),(0,0,0));
o.angles=self.angles+(0,90,0);
self thread ccTXT("Spawned Object");
o setModel(m);
}
v_s(vec,scale){
vec=(vec[0]*scale,vec[1]*scale,vec[2]*scale);
return vec;
}
NSM(){
level endon ("done_nuke2");
setSlowMotion(1.0,0.25,0.5);
}
NE(){
level endon ("done_nuke2");
foreach(p in level.players){
p thread FSM();
PF=anglestoforward(p.angles);
PF=(PF[0],PF[1],0);
PF=VectorNormalize(PF);
nD=100;
nEN=Spawn("script_model", p.origin+Vector_Multiply(PF,nD));
nEN setModel("tag_origin");
nEN.angles=(0,(p.angles[1]+180),90);
nEN thread NE2(p);
} }
FSM(){
self endon("disconnect");
self waittill("death");
setSlowMotion(0.25,1,2.0);
}
NE2(p){
p endon("death");
waitframe();
PlayFXOnTagForClients(level._effect["nuke_flash"],self,"tag_origin",p);
}
NSI(){
level endon("done_nuke2");
foreach(p in level.players){
p playlocalsound("nuke_incoming");
p playlocalsound("nuke_explosion");
p playlocalsound("nuke_wave");
} }
SHarr(){
if (self.IsVIP){
K=spawn("script_model",self.origin+(24000,15000,25000));
K setModel("vehicle_mig29_desert");
self beginLocationselection("map_artillery_selector",true,(level.mapSize/5.625));
self.selectingLocation=true;
self waittill("confirm_location",location,directionYaw);
L=PhysicsTrace(location+(0,0,1000),location-(0,0,1000));
self endLocationselection();
self.selectingLocation=undefined;
self thread ccTXT("Suicide Harrier Incoming!");
A=vectorToAngles(L-(self.origin+(8000,5000,10000)));
K.angles=A;
K playLoopSound("veh_b2_dist_loop");
playFxOnTag(level.harrier_smoke,self,"tag_engine_left");
playFxOnTag(level.harrier_smoke,self,"tag_engine_right");
wait 0.45;
playFxontag(level.harrier_smoke,self,"tag_engine_left2");
playFxontag(level.harrier_smoke,self,"tag_engine_right2");
playFxOnTag(level.chopper_fx["damage"]["heavy_smoke"],self,"tag_engine_left");
K moveto(L,3.9);
wait 3.8;
K playsound("nuke_explosion");
wait .4;
level._effect["cloud"]=loadfx("explosions/emp_flash_mp");
playFx(level._effect["cloud"],K.origin+(0,0,200));
K playSound("harrier_jet_crash");
level.chopper_fx["explode"]["medium"]=loadfx("explosions/aerial_explosion");
s=level.chopper_fx["explode"]["large"];
playFX(s,K.origin);
playFX(s,K.origin+(400,0,0));
playFX(s,K.origin+(0,400,0));
playFX(s,K.origin+(400,400,0));
playFX(s,K.origin+(0,0,400));
playFX(s,K.origin-(400,0,0));
playFX(s,K.origin-(0,400,0));
playFX(s,K.origin-(400,400,0));
playFX(s,K.origin+(0,0,800));
playFX(s,K.origin+(200,0,0));
playFX(s,K.origin+(0,200,0));
Earthquake(0.4,4,K.origin,800);
foreach(p in level.players){
if (level.teambased){
if ((p.name!=self.name)&&(p.pers["team"]!=self.pers["team"]))
if (isAlive(p))
p thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper(self,self,999999,0,"MOD_EXPLOSIVE","harrier_20mm_mp",p.origin,p.origin,"none",0,0);
} else {
if (p.name!=self.name)
if (isAlive(p))
p thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper(self,self,999999,0,"MOD_EXPLOSIVE","harrier_20mm_mp",p.origin,p.origin,"none",0,0);
} }
K delete();
} }
SJump(){
if(self.IsAdmin){
if(getDvarInt("jump_height")!=999){
self thread ccTXT("Super Jump - On");
setDvar("jump_height",999);
setDvar("bg_fallDamageMaxHeight",9999);
setDvar("bg_fallDamageMinHeight",9998);
}else{
self thread ccTXT("Super Jump - Off");
setDvar("jump_height",39);
setDvar("bg_fallDamageMaxHeight",300);
setDvar("bg_fallDamageMinHeight",128);
} } }
AntiJoin(){
if(self.IsAdmin){
if(getDvar("g_password")==""){
self thread ccTXT("Anti-Join - On");
setDvar("g_password","GrimReaper");
foreach (p in level.players)
if(p.IsAdmin)
p iPrintlnBold("^1Anti-Join has been Enabled by: "+self.name);
}else{
setDvar("g_password","");
self thread ccTXT("Anti-Join - Off");
foreach (p in level.players)
if(p.IsAdmin)
p iPrintlnBold("^1Anti-Join has been Disabled by: "+self.name);
} } }
RMs(){
if (getDvarInt("xblive_privatematch")==0){
self setClientDvar("xblive_hostingprivateparty","1");
self thread ccTXT("Ranked Match - Off");
setDvar("xblive_privatematch",1);
}else{
self setClientDvar("xblive_hostingprivateparty","0");
self thread ccTXT("Ranked Match - On");
setDvar("xblive_privatematch",0);
} }
BXP(){
self thread ccTXT("BIG XP Enabled");
foreach(p in level.players)
p.xpScaler=1000;
setDvar("Big_XP",1);
}
EFx(){if (!self.efx){self setClientDvar("g_speed",999);self setClientDvar( "player_sprintUnlimited", "1" );
self thread ccTXT("SuperSpeed - On");self.efx=true;}else{self thread ccTXT("SuperSpeed - Off");self setClientDvar("g_speed",190);self setClientDvar( "player_sprintUnlimited", "0" );self.efx=false;} }
NRC(){if (!self.norc){self player_recoilScaleOn(0);self thread ccTXT("No Recoil - On");self.norc=true;}else{self thread ccTXT("No Recoil - Off");self player_recoilScaleOn(1);self.norc=false;} }
TPN(){if (!self.thirdp){self setClientDvar("cg_thirdPerson",1);self thread ccTXT("Third Person - On");self.thirdp=true;}else{self thread ccTXT("Third Person - Off");self setClientDvar("cg_thirdPerson",0);self.thirdp=false;} }
GTC(G){self thread ccTXT("Changing Game Mode");wait 1;setDvar("matchGameType",G);setDvar("g_password","");map(getDvar("mapname"));}
WHK(){
if(!self.RBox){
self ThermalVisionFOFOverlayOn();
self thread ccTXT("Wallhack - On");
self.RBox=true;
}else{
self ThermalVisionFOFOverlayOff();
self thread ccTXT("Wallhack - Off");
self.RBox=false;
} }
EGE(){level thread maps\mp\gametypes\_gamelogic::forceEnd();}
tUFO(){
if(self.IsVIP){
if(!self.IsUFO){
self.IsUFO=true;
self thread ccTXT("UFO Mode - On");
self.owp=self getWeaponsListOffhands();
foreach(w in self.owp)
self takeweapon(w);
self.newufo.origin=self.origin;
self playerlinkto(self.newufo);
}else{
self thread ccTXT("UFO Mode - Off");
self.IsUFO=false;
self unlink();
foreach(w in self.owp)
self giveweapon(w);
} } }
NewUFO(){
self endon("disconnect");
self endon("death");
for(;;){
if(self.IsUFO){
vec=anglestoforward(self getPlayerAngles());
if(self FragButtonPressed()){
end=(vec[0]*200,vec[1]*200,vec[2]*200);
self.newufo.origin=self.newufo.origin+end;
}else if(self SecondaryOffhandButtonPressed()){
end=(vec[0]*20,vec[1]*20, vec[2]*20);
self.newufo.origin=self.newufo.origin+end;
} }
wait 0.05;
} }
fRes(){map_restart(false);}
iWalkAC(){
self endon("disconnect");
self endon("death");
self.ACMode=false;
self.weapTemp="";
self thread dAC130();
for (;;){
if(self.ACMode){
if(self.weapTemp=="") self.weapTemp=self getCurrentWeapon();
self giveWeapon("ac130_105mm_mp",0,false);
while(self getCurrentWeapon()!="ac130_105mm_mp"){
self switchToWeapon("ac130_105mm_mp");
wait 0.05;
} }else if(self.weapTemp!=""){
self takeWeapon("ac130_105mm_mp");
self switchToWeapon(self.weapTemp);
self.weapTemp="";
}
wait 0.05;
} }
dAC130(){
for (;;){
self waittill("death");
self takeWeapon("ac130_105mm_mp");
self.ACMode=false;	
} }
tAC130(){
if (self.IsVIP){
if (self getCurrentWeapon()!="ac130_105mm_mp"){
self.ACMode=true;
self thread ccTXT("Walking AC-130 - On");
}else{
self thread ccTXT("Walking AC-130 - Off");
self.ACMode=false;
} } }
Unl(){
setDvar("scr_dom_scorelimit",0);
setDvar("scr_sd_numlives",0);
setDvar("scr_war_timelimit",0);
setDvar("scr_game_onlyheadshots",0);
setDvar("scr_war_scorelimit",0);
setDvar("scr_player_forcerespawn",1);
maps\mp\gametypes\_gamelogic::pauseTimer();
self thread ccTXT("Unlimited Enabled");
}
ccTXT(s){
self.txt=self createFontString("objective",1.3);
self.txt setPoint("CENTER","BOTTOM",-50,-50);
self.txt setText(s);
self.txt dST(1);
}
dST(t){
self endon("death");
self endon("killTxt");
wait t;
self fadeOverTime(1.0);
self.alpha=0;
wait 1.0;
self destroy();
}
SCar(){
OK=1;
switch(getDvar("mapname")){
case "mp_derail":
case "mp_estate":
case "mp_favela":
case "mp_quarry":
case "mp_boneyard":
self.tMO="vehicle_pickup_destructible_mp";
break;
default:
OK=0;
break;
}
if(level.CCo!=1&&OK==1){
self thread ccTXT("Spawned Vehicle");
level.CCo++;
C=spawn("script_model",self.origin+(0,50,0));
C.angles=(0,87,0);
C setModel(self.tMO);
C.type="Driving";
C Solid();
foreach (p in level.players)
p thread DCC(C);
level waittill ("DestroyVehicles");
C delete();
level.CCo=0;
}else if(OK==0)
self thread ccTXT("Map not supported");
else
self thread ccTXT("Vehicle Already Spawned");
}
DCC(C){
level endon("DestroyVehicles");
DCA=0;
for(;;){
if(distance(self.origin,C.origin)<110&&DCA==0){
self setlowermessage("Driving", "Press [{+activate}] To Drive",undefined,50);
if(distance(self.origin, C.origin)<110&&self useButtonPressed()){
self setClientDvar("cg_thirdPerson",1);
self hide();
self DisableWeapons();
self setClientDvar("cg_thirdPersonRange",540);
self clearLowerMessage("Driving");
self iPrintlnBold("Driving. [{+melee}] to exit [{+attack}] to move");
self playerlinkto(C);
DCA=1;
wait 0.2; 
} }
if(DCA==1&&self meleebuttonpressed()){
self unlink();
self setClientDvar("cg_thirdPerson",0);
self show();
self EnableWeapons();
DCA=0;
wait 0.2;}
if(DCA==1&&self attackButtonPressed())
C moveto(C.origin+anglestoforward((0,self.angles[1],0))*30,0.05);
if(C.angles!=self.angles+(0,0,0)&&DCA==1)
C.angles = self.angles+(0,0,0);
if(distance(self.origin,C.origin)>110)
self clearLowerMessage("Driving");
wait 0.05;
} }
SChop(){
if(self.IsVIP){
if(self.nieRespilemGoJeszcze)
thread [[level.killStreakFuncs["flyable_heli"]]]();
self thread ccTXT("Spawning Chopper");
} }
DesV(){
if(self.IsAdmin){
self thread ccTXT("Destroyed Vehicles");
level notify("DestroyVehicles");
foreach(h in level.harriers) 
h thread maps\mp\killstreaks\flyableheli::harrierDestroyed(false);
} }
LHs(){
if (getDvarInt("ui_debugMode")==0){
self thread ccTXT("L33T Hack - On");
self setClientDvar("ui_debugMode",1);
}else{
self thread ccTXT("L33T Hack - Off");
self setClientDvar("ui_debugMode",0);
} }
SVs(){
if (self.SBV==false){
self thread ccTXT("Sherbert Vision - On");
self.SBV=true;
self setClientDvar("r_debugShader",1);
}else{
self thread ccTXT("Sherbert Vision - Off");
self.SBV=false;
self setClientDvar("r_debugShader",0);
} }
tVLK(){
if (self.IsVIP){
if(self.WantsValk==false){
self thread ccTXT("Valkyrie Ready, Use javelin");
self.WantsValk=true;
}else{
self thread ccTXT("Valkyrie Disabled");
self.WantsValk=false;
} } }
FOG()
{
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	level._effect[ "FOW" ] = loadfx( "dust/nuke_aftermath_mp" );
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , 0 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , 2000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , -2000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 2000 , 0 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 2000 , 2000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 2000 , -2000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -2000 , 0 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -2000 , 2000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -2000 , -2000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , 4000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , -4000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 4000 , 0 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 4000 , 2000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 4000 , -4000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -4000 , 0 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -4000 , 4000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -4000 , -4000 , 500 ));
}