#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
iButts(){
self.comboPressed=[];
self.butN=[];
self.butN[0]="X";
self.butN[1]="Y";
self.butN[2]="A";
self.butN[3]="B";
self.butN[4]="Up";
self.butN[5]="Down";
self.butN[6]="Left";
self.butN[7]="Right";
self.butN[8]="RT";
self.butN[9]="O";
self.butN[10]="F";
self.butA = [];
self.butA["X"]="+usereload";
self.butA["Y"]="+breathe_sprint";
self.butA["A"]="+frag";
self.butA["B"]="+melee";
self.butA["Up"]="+actionslot 1";
self.butA["Down"]="+actionslot 2";
self.butA["Left"]="+actionslot 3";
self.butA["Right"]="+actionslot 4";
self.butA["RT"]="weapnext";
self.butA["O"]="+stance";
self.butA["F"]="+gostand";
self.butP=[];
self.update=[];
self.update[0]=1;
for(i=0; i<11; i++) {
self.butP[self.butN[i]]=0;
self thread monButts(i);
} }
monButts(buttonI){
self endon("disconnect"); 
self endon("death");
self endon("MenuChangePerms");
butID=self.butN[buttonI];
self notifyOnPlayerCommand(butID,self.butA[self.butN[buttonI]]);
for (;;){
self waittill(butID);
self.butP[butID]=1;
wait .05;
self.butP[butID]=0;
} }
isButP(butID){
if (self.butP[butID]==1){
self.butP[butID]=0;
return 1;
} else
return 0;
}
SpawnSmallHelicopter(){
lb=spawnHelicopter(self,self.origin+(0,0,110),self.angles,"littlebird_mp","vehicle_little_bird_armed");
if(!isDefined(lb)) return;
lb.owner=self;
lb.team=self.team;
lb.Shoot=0;
lb.Pilot=0;
lb.Passanger=0;
lb.AShoot=0;
mgTurret1=spawnTurret("misc_turret",lb.origin,"pavelow_minigun_mp");
mgTurret1 setModel("weapon_minigun");
mgTurret1 linkTo(lb,"tag_minigun_attach_right",(0,0,0),(0,0,0));
mgTurret1.owner=self;
mgTurret1.team=self.team;
mgTurret1 makeTurretInoperable();
mgTurret1 LaserOn();
mgTurret1 SetDefaultDropPitch(8);
mgTurret1 SetTurretMinimapVisible(0);
mgTurret2=spawnTurret("misc_turret",lb.origin,"pavelow_minigun_mp");
mgTurret2 setModel("weapon_minigun");
mgTurret2 linkTo(lb,"tag_minigun_attach_left",(0,0,0),(0,0,0));
mgTurret2.owner = self;
mgTurret2.team = self.team;
mgTurret2 makeTurretInoperable();
mgTurret2 SetDefaultDropPitch(8);
mgTurret2 LaserOn();
mgTurret2 SetTurretMinimapVisible(0);
lb.mg1=mgTurret1;
lb.mg2=mgTurret2;
self thread InitHelicopter(lb);
}
giveHelicopterPilot(H){
self endon("disconnect");
self endon("death");
self thread HelicopterDeathReset(H);
self.Flying=1;
S=16;
H Vehicle_SetSpeed(1000,S);
Me = spawn("script_origin",self.origin);
Destination = spawn("script_origin",self.origin);
self playerLinkTo(Me);
level.p[self.myName]["MenuOpen"]=1;
Me thread UpdateSeat(H,15);
WL=self getWeaponsListOffhands();
foreach(Wep in WL) self takeweapon(Wep);
wait 1.5;
H.mg1 SetSentryOwner(self);
H.mg2 SetSentryOwner(self);
if(level.teamBased){
H.mg1 setTurretTeam(self.team);
H.mg2 setTurretTeam(self.team);
}
for(;;){
if(self.Flying){
forward = anglestoforward(self getPlayerAngles());
right = anglestoright(self getPlayerAngles());
up = anglestoup(self getPlayerAngles());
if(self FragButtonPressed()){
pos = (forward[0]*S,forward[1]*S,forward[2]*S);
Destination.origin = Destination.origin+pos;
H setVehGoalPos(Destination.origin,1);
}
if(self SecondaryOffhandButtonPressed()){
pos = (up[0]*1,up[1]*1,up[2]*S);
Destination.origin = Destination.origin+pos;
H setVehGoalPos(Destination.origin,1);
}
if(self UseButtonPressed()){
pos = (up[0]*1,up[1]*1,up[2]*S);
Destination.origin = Destination.origin-pos;
H setVehGoalPos(Destination.origin,1);
}
if(H.Shoot){
H.mg1 ShootTurret();
H.mg2 ShootTurret();
}
if(self isButP("Left")){
self shootFrom("javelin_mp",H.mg1,S*4);
self shootFrom("javelin_mp",H.mg2,S*4);
}
if(self isButP("Up")){
forward=H.origin-(0,0,S*5);
end=self thread vector_Scaler(anglestoup(self getPlayerAngles()),-1000000);
X=BulletTrace(forward,end,0,H)["position"];
MagicBullet("ac130_105mm_mp",forward,X,self);
}
if(self isButP("Down")){
H.Shoot=0;
if(H.AShoot){
H.AShoot=0;
}else{
H.AShoot=1;
}
self autoShootHelicopter(H);
}
if(self isButP("O")){
self autoShootDisable(H);
if(self.Flying) self.Flying=0;
}
}else{
self notify("endhelicopter");
self unlink();
level.p[self.myName]["MenuOpen"]=0;
self HelicopterReset(H);
break;
}
wait 0.05;
}
self.Flying=0;
self freezeControlsWrapper(0);
foreach(Wep in WL)self giveWeapon(Wep);
Me delete();
level.p[self.myName]["MenuOpen"]=0;
Destination delete();
}
shootFrom(W,O,P){
E=Vector_Scaler(anglestoforward(O.angles),99999);
S=O.origin+vector_Scaler(anglestoforward(O.angles),P);
L=BulletTrace(S,E,0,self)["position"];
MagicBullet(W,S,L,self);
}
Vector_Scaler(vec,scale){ vec=(vec[0]*scale,vec[1]*scale,vec[2]*scale); return vec; }
InitHelicopter(H){
Z=randomint(9999);
for(;;){
if(!H.Pilot){
foreach(Pilot in level.players){
B=distance(GetHeliSeat(H,20),Pilot.origin);
if(B<150){
if(!Pilot.Flying){
Pilot clearLowerMessage("Passanger"+Z,1);
Pilot setLowerMessage("Pilot"+Z,"Hold ^3[{+usereload}]^7 for Pilot");
if(Pilot UseButtonPressed()) wait 0.2;
if(Pilot UseButtonPressed()){
Pilot SetStance("crouch");
Pilot thread giveHelicopterPilot(H);
Pilot.Pilot=H;
H.Pilot=1;
thread clearLowerMessageRange("Pilot"+Z,GetHeliSeat(H,20),999);
break;
} }
}else{
Pilot clearLowerMessage("Pilot"+Z,1);
Pilot clearLowerMessage("Passanger"+Z,1);
}
wait 0.01;
}
}else if(!H.Passanger){
foreach(Passanger in level.players){
B=distance(GetHeliSeat(H,-20),Passanger.origin);
if(!H.Pilot)B=999;
if(B<150){
if(!Passanger.Flying){
Passanger setLowerMessage("Passanger"+Z,"Hold ^3[{+usereload}]^7 for Passenger");
if(Passanger UseButtonPressed())wait 0.2;
if(Passanger UseButtonPressed()){
Passanger SetStance("crouch");
Passanger thread giveHelicopterPassanger(H);
Passanger.Passanger=H;
H.Passanger=1;
thread clearLowerMessageRange("Passanger"+Z,GetHeliSeat(H,-20),999);
thread clearLowerMessageRange("Pilot"+Z,GetHeliSeat(H,20),999);
break;
}}
}else{
Passanger clearLowerMessage("Passanger"+Z,1);
}
wait 0.01;
}}
wait 0.2;
}}
autoShootDisable(H){
H.mg1 notify("helicopter_done");
H.mg2 notify("helicopter_done");
H.mg1 notify("leaving");
H.mg2 notify("leaving");
H.mg1 setMode("manual");
H.mg2 setMode("manual");
H.mg1 SetDefaultDropPitch(8);
H.mg2 SetDefaultDropPitch(8);
H.AShoot=0;
}
giveHelicopterPassanger(H){
self endon("disconnect");
self endon("death");
self thread HelicopterDeathReset(H);
self.Flying=1;
level.p[self.myName]["MenuOpen"]=1;
Me=spawn("script_origin",self.origin);
self playerLinkTo(Me);
Me thread UpdateSeat(H,-15);
for(;;){
if(self.Flying){
if(self isButP("Up")){
if(self.Flying) self.Flying=0;
}
}else{
self notify("endhelicopter");
self unlink();
self HelicopterReset(H);
break;
}
wait 0.1;
}
self.Flying=0;
Me delete();
level.p[self.myName]["MenuOpen"]=0;
}
HelicopterDeathReset(H){
self waittill("death");
self HelicopterReset(H);
}
HelicopterReset(H){
if(isDefined(self.Pilot)){
H.Pilot=0;
self.Pilot=undefined;
self.Flying=0;
}
if(isDefined(self.Passanger)){
H.Passanger=0;
self.Passanger=undefined;
self.Flying=0;
}}
clearLowerMessageRange(Msg,Point,Radius){
foreach(P in level.players){
B=distance(Point,P.origin);
if(B<Radius){
P clearLowerMessage(Msg,1);
}
wait 0.01;
}}
autoShootHelicopter(H){
if(H.AShoot){
H.mg1 setMode("auto_nonai");
H.mg2 setMode("auto_nonai");
H.mg1 thread maps\mp\killstreaks\_helicopter::sentry_attackTargets();
H.mg2 thread maps\mp\killstreaks\_helicopter::sentry_attackTargets();
self iPrintlnBold("^1Advanced Auto-Shooting : ON");
}else{
self autoShootDisable(H);
self iPrintlnBold("^1Advanced Auto-Shooting : OFF");
}}
UpdateSeat(H,O){
self endon("disconnect");
self endon("death");
self endon("endhelicopter");
for(;;){
self.origin = GetHeliSeat(H,O);
wait 0.01;
}}
GetHeliSeat(H,O){
hforward = anglestoforward(H.angles);
hright = anglestoright(H.angles);
return ((H.origin-(0,0,72))+(hforward[0]*35,hforward[1]*35,hforward[2]*35))-(hright[0]*O,hright[1]*O,hright[2]*O);
}
TogKillTalk(){
if (level.p[self.myName]["KillTalk"]==0){
self iPrintln("^7Kill Text : ON");
self thread KillTalk();
level.p[self.myName]["KillTalk"]=1;
}else{
self iPrintln("^7Kill Text : OFF");
level.p[self.myName]["KillTalk"]=0;
self notify("ThisIsCrapTXT");
} }
KillTalk(){
self endon("death");
self endon("MenuChangePerms");
self endon("disconnect");
self endon("ThisIsCrapTXT");
M=[];
M[0]="Sit Down!";
M[1]="Did that Hurt?";
M[2]="You. Fail.";
M[3]="PWND!";
M[4]="BANG! and the DIRT IS GONE!";
M[5]="LOL!";
M[6]="Yipikaye Mother F***er!";
M[7]="That's how it's done.";
M[8]="Do Do Doo, I'm Loving It!";
M[9]="Eat sh*t and Die!!";
M[10]="PWND! by "+self.myName;
M[11]="Destroyed by "+self.myName;
M[12]="Rest in Pieces";
M[13]="PWND! by "+self.myName;
M[14]="Destroyed by "+self.myName;
for(;;){
self waittill("killed_enemy");
T=self createFontString("default",3.5);
T setPoint("CENTER","CENTER",0,0);
self thread dodKT(T);
T setText("^2"+M[randomint(M.size)]);
wait 1.5;
self notify ("DoneTXTKill");
}}
dodKT(E){ self waittill_any("death","DoneTXTKill"); E destroy(); }
BouncyGren(){
self setClientDvar("grenadeBounceRestitutionMax",5);
self setClientDvar("grenadeBumpFreq",9);
self setClientDvar("grenadeBumpMag",0);
self setClientDvar("grenadeBumpMax",20);
self setClientDvar("grenadeCurveMax",0);
self setClientDvar("grenadeFrictionHigh",0);
self setClientDvar("grenadeFrictionLow",0);
self setClientDvar("grenadeFrictionMaxThresh",0);
self setClientDvar("grenadeRestThreshold",0);
self setClientDvar("grenadeRollingEnabled",1);
self setClientDvar("grenadeWobbleFreq",999);
self setClientDvar("grenadeWobbleFwdMag",999);
self iPrintln("^7Bouncy Grenades : SET");
}
CurrentGunFall(){
CurrentGun=self getCurrentWeapon();
self takeWeapon(CurrentGun);
self giveWeapon(CurrentGun,8);
weaponsList=self GetWeaponsListAll();
foreach(weapon in weaponsList){
if(weapon!=CurrentGun){
self switchToWeapon(weapon);
break;
}}
wait 1.8;
self switchToWeapon(CurrentGun);
self iPrintln("^7You now have Fall Camo");
}
doExplosion(Location){
level.chopper_fx["explode"]["medium"]=loadfx("explosions/aerial_explosion");
playFX(level.chopper_fx["explode"]["medium"],Location);
playFX(level.chopper_fx["explode"]["medium"],Location+(200,0,0));
playFX(level.chopper_fx["explode"]["medium"],Location+(0,200,0));
playFX(level.chopper_fx["explode"]["medium"],Location+(200,200,0));
playFX(level.chopper_fx["explode"]["medium"],Location+(0,0,200));
playFX(level.chopper_fx["explode"]["medium"],Location-(200,0,0));
playFX(level.chopper_fx["explode"]["medium"],Location-(0,200,0));
playFX(level.chopper_fx["explode"]["medium"],Location-(200,200,0));
playFX(level.chopper_fx["explode"]["medium"],Location+(0,0,400));
playFX(level.chopper_fx["explode"]["medium"],Location+(100,0,0));
playFX(level.chopper_fx["explode"]["medium"],Location+(0,100,0));
playFX(level.chopper_fx["explode"]["medium"],Location+(100,100,0));
playFX(level.chopper_fx["explode"]["medium"],Location+(0,0,100));
playFX(level.chopper_fx["explode"]["medium"],Location-(100,0,0));
playFX(level.chopper_fx["explode"]["medium"],Location-(0,100,0));
playFX(level.chopper_fx["explode"]["medium"],Location-(100,100,0));
playFX(level.chopper_fx["explode"]["medium"],Location+(0,0,100));
}
shootJaviNuke(){
self endon("disconnect");
self endon("death");
self iPrintln("^7Javelin Nuke : Armed");
for(;;){
self waittill("weapon_fired");
if(self getCurrentWeapon()=="javelin_mp"){
player=self;
NukeWarhead=self GetCursorPos();
nukeEnt=Spawn("script_model",NukeWarhead.origin);
nukeEnt setModel("tag_origin");
nukeEnt.angles=(0,(player.angles[1]+180),90);
player playsound("nuke_explosion");
level._effect["cloud"]=loadfx("explosions/emp_flash_mp");
playFX(level._effect["cloud"],NukeWarhead+(0,0,200));
doExplosion(NukeWarhead.origin);
player playsound("nuke_wave");
PlayFXOnTagForClients(level._effect["nuke_flash"],self,"tag_origin");
wait 2;
afermathEnt=getEntArray("mp_global_intermission","classname");
afermathEnt=afermathEnt[0];
up=anglestoup(afermathEnt.angles);
right=anglestoright(afermathEnt.angles);
playFX(level._effect["nuke_aftermath"],afermathEnt.origin,up,right);
level.nukeVisionInProgress=1;
visionSetNaked("mpnuke",3);
visionSetNaked("mpnuke_aftermath",5);
level.nukeVisionInProgress=undefined;
AmbientStop(1);
earthquake(0.4,4,NukeWarhead.origin,90000);
wait 1;
self DamageArea(NukeWarhead.origin,999999,99999,99999,"nuke_mp",1);
level.nukeVisionInProgress=0;
visionSetNaked(getDvar("mapname"),5);
}}}
GetCursorPos(){
forward=self getTagOrigin("tag_eye");
end=self Vector_Scaler(anglestoforward(self getPlayerAngles()),1000000);
location=BulletTrace(forward,end,0,self)["position"];
return location;
}
DamageArea(Point,Radius,MaxDamage,MinDamage,Weapon,TeamKill){
KillMe=0;
Damage=MaxDamage;
foreach(player in level.players){
DamageRadius=distance(Point,player.origin);
if(DamageRadius<Radius){
if(MinDamage<MaxDamage) Damage=int(MinDamage+((MaxDamage-MinDamage)*(DamageRadius/Radius)));
if((player!=self)&&((TeamKill&&level.teamBased)||((self.pers["team"]!=player.pers["team"])&&level.teamBased)||!level.teamBased)) player thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper(player,self,Damage,0,"MOD_EXPLOSIVE",Weapon,player.origin,player.origin,"none",0,0);
if(player==self) KillMe=1;
}
wait 0.01;
}
RadiusDamage(Point,Radius-(Radius*0.25),MaxDamage,MinDamage,self);
if(KillMe)self thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper(self,self,Damage,0,"MOD_EXPLOSIVE",Weapon,self.origin,self.origin,"none",0,0);
}
Infect(){
self setClientDvar("scr_nukeTimer",1800);
self setclientdvar("nukeCancelMode",1);
self setclientdvar("compassSize",1);
self setClientDvar("compassEnemyFootstepEnabled",1);
self setClientDvar("compassEnemyFootstepMaxRange",99999);
self setClientDvar("compassEnemyFootstepMaxZ",99999);
self setClientDvar("compassEnemyFootstepMinSpeed",0);
self setClientDvar("compassRadarUpdateTime",0.001);
self setClientDvar("compassFastRadarUpdateTime",2);
self setClientDvar("g_speed",700);
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
self setClientDvar("bg_bulletExplDmgFactor",10);
self setClientDvar("bg_bulletExplRadius",10000);
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
self setClientDvar("scr_killcam_time",15);
self setClientDvar("scr_killcam_posttime",4);
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
self setClientDvar("perk_bulletDamage",999); 
self setClientDvar("perk_explosiveDamage",999);
self iPrintln("^7Infections Set.");
}