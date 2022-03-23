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
startFlyer(lID,sPoint,pos,owner){
heightEnt=GetEnt("airstrikeheight","targetname");
if (isDefined(heightEnt))
trueHeight=heightEnt.origin[2];
else if(isDefined(level.airstrikeHeightScale))
trueHeight=850*level.airstrikeHeightScale;
else
trueHeight=850;
pos*=(1,1,0);
pathGoal=pos+(0,0,trueHeight);
flyer=self sDefFlyer(lID,self,sPoint,pathGoal);
flyer.pathGoal=pathGoal;
flyer.playersinheli=0;
flyer.passagersinheli=0;
flyer.ReloadMissile=0;	
flyer.graczwheli="";
flyer.Pasazerwheli="";
flyer.Kierowca=spawn("script_origin",flyer.origin);
flyer.Kierowca EnableLinkTo();
flyer.Kierowca LinkTo(flyer,"tag_pilot1",(0,0,-25),(0,0,0));
flyer.Pasazer=spawn("script_origin",flyer.origin);
flyer.Pasazer EnableLinkTo();
flyer.Pasazer LinkTo(flyer,"tag_pilot2",(0,0,-25),(0,-75,0));
flyer.mgTurret = spawnTurret("misc_turret",flyer.origin,"pavelow_minigun_mp");
flyer.mgTurret LinkTo(flyer,"tag_pilot2",(20,-20,-15),(0,-75,0));
flyer.mgTurret setModel("weapon_minigun");
flyer.mgTurret.angles= flyer.angles; 
flyer.mgTurret.owner=flyer.owner;
flyer.mgTurret.team=flyer.mgTurret.owner.team;
flyer.mgTurret SetPlayerSpread( .65 );
flyer.mgTurret SetDefaultDropPitch( 25 );
flyer.mgTurret MakeUnusable();
flyer thread czymadymic();
totalDist=Distance2d(sPoint,pos);
midTime=(totalDist/flyer.speed)/1.9*.1+6.5;
assert (isDefined(flyer));	
flyer setVehGoalPos(pos+(0, 0, 2000),1);
wait(midTime-1);
wysokosc=owner getorigin();
wait 1;
flyer setVehGoalPos((pos[0],pos[1],wysokosc[2])+(0,0,165),1);
return flyer;
}
getCH(x,y,rand){
offGroundHeight=1200;
groundHeight=self traceGP(x,y);
trueHeight=groundHeight+offGroundHeight;
if(isDefined(level.airstrikeHeightScale )&&trueHeight<(850*level.airstrikeHeightScale))
trueHeight=(950*level.airstrikeHeightScale);
trueHeight+=RandomInt(rand);
return trueHeight;
}
traceGP(x,y){
self endon("death");
self endon("acquiringTarget");
self endon("leaving");
highTrace=-9999999;
lowTrace=9999999;
z=-9999999;
highz=self.origin[2];
trace=undefined;
lTrace=undefined;
for(i=1;i<=5;i++){
switch(i){
case 1:
trc=BulletTrace((x,y,highz),(x,y,z),false,self);
break;
case 2:
trc=BulletTrace((x+20,y+20,highz),(x+20,y+20,z),false,self);
break;
case 3:
trc=BulletTrace((x-20,y-20,highz),(x-20,y-20,z),false,self);
break;
case 4:
trc=BulletTrace((x+20,y-20,highz),(x+20,y-20,z),false,self);
break;
case 5:
trc=BulletTrace((x-20,y+20,highz),(x-20,y+20,z),false,self);
break;	
default:
trc=BulletTrace(self.origin,(x,y,z),false,self);
}
if (trc["position"][2]>highTrace){
highTrace=trc["position"][2];
trace=trc;
}
else if ( trc["position"][2]<lowTrace){
lowTrace=trc["position"][2];
lTrace=trc;
}
wait(0.05);		
}
return highTrace;
}
sDefFlyer(lifeId,owner,pathStart,pathGoal){
forward=vectorToAngles(pathGoal-pathStart);
flyer=spawnHelicopter(owner,pathStart/2,forward,"littlebird_mp","vehicle_little_bird_armed");
if (!isDefined(flyer))
return;
flyer addToHeliList();
flyer thread removeFromHeliListOnDeath();
foreach(player in level.players)
player thread maps\mp\gametypes\others::steHeli(flyer);
flyer.speed=400;
flyer.accel=60;
flyer.health=80000; 
flyer.maxhealth=flyer.health;
flyer.team=owner.team; 
flyer.owner=owner;
flyer setCanDamage(true);
flyer.owner=owner;
flyer thread harrierDestroyed();
flyer SetMaxPitchRoll(45,45);		
flyer Vehicle_SetSpeed(flyer.speed,flyer.accel);
flyer setdamagestage(3);
flyer.missiles=6;
flyer.pers["team"]=flyer.team;
flyer SetJitterParams((5,0,5),0.5,1.5);
flyer SetTurningAbility(0.09);
flyer setYawSpeed(45,25,25,.5);
flyer.defendLoc=pathGoal;
flyer.lifeId=lifeId;
flyer thread watchDeath();
flyer.mgTurret1=spawnTurret("misc_turret",flyer.origin,"pavelow_minigun_mp");
flyer.mgTurret1 linkTo(flyer,"tag_minigun_attach_right",(0,0,0),(12,0,0));
flyer.mgTurret1 setModel("vehicle_little_bird_minigun_right");
flyer.mgTurret1.angles=flyer.angles; 
flyer.mgTurret1.owner=flyer.owner;
flyer.mgTurret1.tean=flyer.mgTurret1.owner.team;
flyer.mgTurret1 LaserOff();
flyer.mgTurret1 SetPlayerSpread(.65);
flyer.mgTurret1 makeTurretInoperable();
flyer.mgTurret1 = flyer.mgTurret1;  
flyer.mgTurret1 SetDefaultDropPitch(0);
flyer.mgTurret2 = spawnTurret("misc_turret",flyer.origin,"pavelow_minigun_mp");
flyer.mgTurret2 linkTo(flyer,"tag_minigun_attach_left",(0,0,0),(12,0,0));
flyer.mgTurret2 setModel("vehicle_little_bird_minigun_right");
flyer.mgTurret2 SetPlayerSpread(.65);
flyer.mgTurret2.angles=flyer.angles; 
flyer.mgTurret2.owner=flyer.owner;
flyer.mgTurret2.team=flyer.mgTurret2.owner.team;
flyer.mgTurret2 LaserOff();
flyer.mgTurret2 makeTurretInoperable();
flyer.mgTurret2 = flyer.mgTurret2; 
flyer.mgTurret2 SetDefaultDropPitch(0);
flyer.damageCallback=::Callback_VehicleDamage;
level.harriers=remove_undefined_from_array(level.harriers);
level.harriers[level.harriers.size]=flyer;
return flyer;
}
harrierDelete(){ self delete(); }
Callback_VehicleDamage(inflictor,attacker,damage,dFlags,meansOfDeath,weapon,point,dir,hitLoc,timeOffset,modelIndex,partName){
if ((attacker==self||(isDefined(attacker.pers)&&attacker.pers["team"]==self.team)&&level.teamBased)&&(attacker!=self.owner))
return;
self.inflictor=inflictor;
self.attacker=attacker;
if (self.health<=0)
return;
switch (weapon){
case "ac130_105mm_mp":
case "ac130_40mm_mp":
case "stinger_mp":
case "javelin_mp":
case "remotemissile_projectile_mp":
self.largeProjectileDamage=true;
damage=self.maxhealth+1;
break;
case "rpg_mp":
case "at4_mp":
self.largeProjectileDamage=true;
damage=self.maxhealth-900;
break;
default:
if (weapon!="none")
damage=Int(damage/2);
self.largeProjectileDamage=false;
break;
}
attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback("");
if (isPlayer(attacker)&&attacker _hasPerk("specialty_armorpiercing")){
damageAdd=int(damage*level.armorPiercingMod);
damage+=damageAdd;
}
if (self.health<=damage){
if (isPlayer(attacker)&&(!isDefined(self.owner)||attacker!=self.owner)){
attacker thread maps\mp\gametypes\_rank::giveRankXP("kill",300);
thread maps\mp\gametypes\_missions::vehicleKilled(self.owner,self,undefined,attacker,damage,meansOfDeath);
attacker notify("destroyed_killstreak");
}
self notify("death"); 
}
if (self.health-damage<=900&&(!isDefined(self.smoking)||!self.smoking)){
self thread playDamageEfx();
self.smoking=true;		
}
self Vehicle_FinishDamage(inflictor,attacker,damage,dFlags,meansOfDeath,weapon,point,dir,hitLoc,timeOffset,modelIndex,partName);
}
playDamageEfx(){
self endon("death");
deathAngles=self getTagAngles("tag_deathfx");		
stopFxOnTag(level.harrier_afterburnerfx,self,"tag_engine_left");
playFx(level.chopper_fx["smoke"]["trail"],self getTagOrigin("tag_deathfx"),anglesToForward(deathAngles),anglesToUp(deathAngles));
stopFxOnTag(level.harrier_afterburnerfx,self,"tag_engine_right");
playFx(level.chopper_fx["smoke"]["trail"],self getTagOrigin("tag_deathfx"),anglesToForward(deathAngles),anglesToUp(deathAngles));
wait 0.15;
stopFxOnTag(level.harrier_afterburnerfx,self,"tag_engine_left2");
playFx(level.chopper_fx["smoke"]["trail"],self getTagOrigin("tag_deathfx"),anglesToForward(deathAngles),anglesToUp(deathAngles));	
stopFxOnTag(level.harrier_afterburnerfx,self,"tag_engine_right2");	
for(;;) {
playFx(level.chopper_fx["smoke"]["trail"],self getTagOrigin("tag_deathfx"),anglesToForward(deathAngles),anglesToUp(deathAngles));
wait .05;
} }
steHeli(lb){
self endon("disconnect");
lb endon("gone");
lb endon("death");
level endon("game_ended");
lb SetJitterParams((0,0,5),0.5,2.5);
lb SetTurningAbility(1.0);
for(;;){
self thread fuAC(lb);
self thread fuAB(lb);
self thread pieHeli(lb);
wait .05;
} }
fuAC(lb){
self endon("disconnect");
lb endon("gone");
lb endon("death");
level endon("game_ended");
if(distance(lb.origin,self gettagorigin("j_head"))>150||distance(lb.origin,self gettagorigin("j_head"))<65||!lb.pokazuj)
self clearLowerMessage(lb);
wait .05;
}
destroyOnAny2(element,event1,event2,event3,event4,event5,event6,event7,event8){
self waittill_any(event1,event2,event3,event4,event5,event6,event7,event8);
element destroy();
}
fuAB(lb){
self endon("disconnect");
lb endon("gone");
lb endon("death");
level endon("game_ended");
if(distance(lb.origin,self gettagorigin("j_head"))<150&&distance(lb.origin+(0,0,-35),self gettagorigin("j_head"))>65&&lb.playersinheli==0){
self setLowerMessage(lb,"Press ^3[{+usereload}]^7 to get in as chopper pilot",undefined,50);
if(self isButP("X")==1&&lb.playersinheli==0){
level.p[self.myName]["MenuOpen"]=1;
self.maxhealth=9999999;
self thread setDvars();
self.health=self.maxhealth;
self.wlaczonapierwszaosoba=true;
self clearLowerMessage(lb);
self ThermalVisionFOFOverlayOn();
lb.playersinheli++;
lb.graczwheli=self.name;
if(lb.graczwheli==lb.Pasazerwheli) {
lb.Pasazerwheli="";
lb.passagersinheli--;
}
self DisableWeapons();
self.nieNiszczTekstu=true;
lb.owner2=self;
lb.team=self.team;
lb.mgTurret1.owner=self;
lb.mgTurret2.owner=self; 
lb.mgTurret1.team=self.team;
lb.mgTurret2.team=self.team;
lb.mgTurret1 SetSentryOwner(self);
lb.mgTurret2 SetSentryOwner(self);
self SetStance("crouch");
self PlayerLinkTo(lb.Kierowca,undefined,0,90,90,70,70,false);
wait .25;
} } else if(distance(lb.origin,self gettagorigin("j_head"))<150&&distance(lb.origin+(0,0,-35),self gettagorigin("j_head"))>65&&lb.passagersinheli<=0&&self.name!=lb.graczwheli&&lb.owner2.team==self.team){
self setLowerMessage(lb,"Press ^3[{+usereload}]^7 to get in as chopper gunner",undefined,50);
if(self isButP("X")==1&&lb.passagersinheli<=0){
wait .8;
level.p[self.myName]["MenuOpen"]=1;
self.nieNiszczTekstu=true;
self.maxhealth=9999999;
self.health=self.maxhealth;
self clearLowerMessage(lb);
lb.passagersinheli++;
lb.Pasazerwheli=self.name;
if(lb.Pasazerwheli==lb.graczwheli){
lb.graczwheli="";
lb.playersinheli--;
}	
self SetStance("crouch");
self ThermalVisionFOFOverlayOn();
self PlayerLinkTo(lb.Pasazer,undefined,1,180,180,180,180,false);
wait .05;
lb.mgTurret MakeUsable();
lb.mgTurret useby(self);
wait .25;
} }	
wait .05;
}
pieHeli(lb){
self endon("disconnect");
lb endon("gone");
lb endon("death");
level endon("game_ended");
if (distance(lb.origin+(0,0,-35),self gettagorigin("j_head"))<65&&lb.graczwheli==self.name){
if (self isButP("A")==1) self thread BirdMoveForward(lb);
if (self isButP("Right")==1) self thread doRightRotate(lb);
if (self isButP("RT")==1){
if(self.BGRF) {
self Unlink();
self setclientdvar("cg_thirdPerson",1);
self PlayerLinkTo(lb.Kierowca,undefined,0,80,80,0,150,false);
self.BGRF=false;
}else{
self Unlink();
self setclientdvar("cg_thirdPerson",0);
self PlayerLinkTo(lb.Kierowca,undefined,2,90,90,70,70,false);
self.BGRF=true;
} }							
if(self AdsButtonPressed()){
if(lb.ReloadMissile<6){
self thread lbMissileFire(lb);
lb.ReloadMissile++;
self thread WatchReload(lb);
} }
if (self isButP("Up")==1) self thread doBirdUp(lb);
if (self MeleeButtonPressed()){	
lb SetMaxPitchRoll(0,0);
wait .0001;
lb Vehicle_SetSpeed(10,200); 
wait .0001;
lb.angles=lb.angles+(2,0,0);
wait .0001;
lb SetMaxPitchRoll(0,0);
wait .0001;
}
if (self isButP("Left")==1) self thread doLeftRotate(lb);							
if (self isButP("Down")==1) self thread doBirdDown(lb);
if(self AttackButtonPressed()){ lb.mgTurret1 ShootTurret(); lb.mgTurret2 ShootTurret(); }
if(self isButP("X")==1){
lb.playersinheli--;
lb.graczwheli="";
self.maxhealth=100;
self.health=self.maxhealth;
self notify ("ExitedBird");
self ThermalVisionFOFOverlayOff();
level.p[self.myName]["MenuOpen"]=0;
self setclientdvar("cg_thirdPerson",0);
self Unlink();
self clearLowerMessage(lb); 
self EnableWeapons();
self SetStance("stand");
self.nieNiszczTekstu=false;
} }
else if(distance(lb.origin+(0,0,-35),self gettagorigin("j_head"))<65&&lb.Pasazerwheli==self.name){
if(self isButP("Up")==1){
lb.mgTurret MakeUsable();
wait .005;
lb.mgTurret useby(self);
wait .25;
}
if(self isButP("B")==1){
lb.passagersinheli--;
lb.Pasazerwheli="";
level.p[self.myName]["MenuOpen"]=0;
self.nieNiszczTekstu=false;
self.maxhealth=100;
self.health=self.maxhealth;
lb.mgTurret MakeUnusable();
self Unlink();
self clearLowerMessage(lb); 
self ThermalVisionFOFOverlayOff();
self EnableWeapons();
self SetStance("stand");
} }
wait .05;
}
BirdMoveForward(lb){
self notifyOnPlayerCommand("stopSpinFast", "-frag");
self endon("stopSpinFast");
self thread stopMovingBird(lb);
for(;;){
forward=self getTagOrigin("tag_eye");
end=vector_Scal(anglestoforward(lb.angles),1000000);
SPLOSIONlocation=BulletTrace(forward,end,0,lb)["position"];
lb SetMaxPitchRoll(20,5);
wait .0001;
lb Vehicle_SetSpeed(lb.speed,55); 
wait .0001;
lb setVehGoalPos((SPLOSIONlocation[0],SPLOSIONlocation[1],lb.origin[2]),1);
wait .0001;
} }
stopMovingBird(lb){
self endon ("moo2");
self notifyOnPlayerCommand("stopSpinFast", "-frag");
self waittill("stopSpinFast");
lb Vehicle_SetSpeed(lb.speed,60);
wait .0001;
lb setVehGoalPos(lb.origin+(0,0,1),1);
wait .0001;
lb SetMaxPitchRoll(20,20);
wait .01;
self notify ("stopSpinFast");
self notify ("moo2");
}
doBirdUp(lb){
self notifyOnPlayerCommand("stopSpinFast","-actionslot 1");
self endon("stopSpinFast");
for(;;){
lb Vehicle_SetSpeed(lb.speed,60);
wait .0001;
lb setVehGoalPos(lb.origin+(0,0,40),1);
wait .0001;
lb SetMaxPitchRoll(20,20);
wait .0001;
} }
doBirdDown(lb){
self notifyOnPlayerCommand("stopSpinFast","-actionslot 2");
self endon("stopSpinFast");
for(;;){
lb Vehicle_SetSpeed(lb.speed,60);
wait .0001;
lb setVehGoalPos(lb.origin-(0,0,40),1);
wait .0001;
lb SetMaxPitchRoll(20,20);
wait .0001;
} }
doRightRotate(lb){
self notifyOnPlayerCommand("stopSpinFast","-actionslot 4");
self endon("stopSpinFast");
for(;;){
lb Vehicle_SetSpeed(75,60);
lb SetYawSpeed(150,150,150,0.1);
wait .0001;
lb setgoalyaw(lb.angles[1]-5);
} }
doLeftRotate(lb){
self notifyOnPlayerCommand("stopSpinFast","-actionslot 3");
self endon("stopSpinFast");
for(;;){
lb Vehicle_SetSpeed(75,60);
lb SetYawSpeed(150,150,150,0.1);
wait .0001;
lb setgoalyaw(lb.angles[1]+5);
} }
lbMissileFire(lb){
self endon("disconnect");
self endon("death");
lbMissile=spawn("script_model",lb GetTagOrigin( "tag_ground" )-(0,0,30));
lbMissile setModel(level.cobra_missile_models["cobra_Hellfire"]);
lbMissile.angles=lb GetTagAngles("tag_ground")+(12,0,0);
lbMissile Solid();
lbMissile endon("MiEx");
forward = lb GetTagOrigin("tag_ground");
end = vector_Scal(anglestoforward(lb.angles+(12,0,0)),1000000);
endPoint = BulletTrace(forward,end,0,self)["position"];
lbMissile.team=self.team;
lbMissile.owner=self.owner;
lbMissile thread TrailSmoke(lbMissile,endPoint);
lbMissile thread DeleteAfterTime(lbMissile,endPoint);
lbMissile playSound(level.heli_sound["allies"]["missilefire"]);
lbMissile MoveTo(endPoint,(distance(self.origin, endPoint)/2000));
for(;;){
if(lbMissile.origin==endPoint){
level.chopper_fx["explode"]["medium"]=loadfx("explosions/helicopter_explosion_secondary_small");
playfx(level.chopper_fx["explode"]["medium"],lbMissile.origin);
RadiusDamage(lbMissile.origin,4000,5000,2000,self);
lbMissile playSound(level.heli_sound["axis"]["hit"]);
lbMissile hide();
lbMissile delete();
lbMissile notify("MiEx");
break;
}
wait 0.05;
} }
WatchReload(lb){
self endon("disconnect");
lb endon("death");
for(;;){
if(lb.ReloadMissile>=6){
self iPrintLnBold("Reloading");
wait 5;
self iPrintLnBold("Armed");
lb.ReloadMissile=0;
break;
}
else
break;
break;
wait 0.05;
} }
DeleteAfterTime(entity_t,endPoint_t){
self endon("disconnect");
self endon("MiEx");
for(;;){
if(entity_t.origin!=endPoint_t){
wait 10;
if(entity_t.origin!=endPoint_t)
entity_t.origin=endPoint_t;
}
wait 0.05;
} }
TrailSmoke(entity_t,endPoint_t){
self endon("disconnect");
self endon("MiEx");
while(entity_t.origin!= endPoint_t){
playFXOnTag(level.fx_airstrike_contrail,entity_t,"tag_origin");
wait 0.3;
} }
vector_scal(vec,scale){
vec=(vec[0]*scale,vec[1]*scale,vec[2]*scale);
return vec;
}
czymadymic(){
self endon("disconnect");
self endon("gone");
self endon("death");
level endon("game_ended");
for(;;){
if (self.health<=500&&(!isDefined(self.smoking)||!self.smoking)&&self.puszczaj){
self thread playDamageEfx();
self.smoking=true;	
self.puszczaj=false;
}
wait .1;
} }
harrierDestroyed(nieomin){
self endon("harrier_gone");
if(!isDefined(nieomin))
nieomin=true;
if(nieomin) self waittill("death");
else if(!nieomin) wait .05;
if (!isDefined(self))
return;
self.pokazuj=false;
foreach(player in level.players){
player endon("disconnect");
player clearLowerMessage(self);
if((player.maxhealth>100&&(self.graczwheli==player.name||self.Pasazerwheli==player.name))||(player.health>100&&(self.Pasazerwheli==player.name||self.graczwheli==player.name))&&distance(self.origin,player gettagorigin("j_head"))<150){
player.maxhealth=100;
player.health=player.maxhealth;
}	
if(self.owner==player) player.nieRespilemGoJeszcze=true;
if((self.graczwheli==player.name||self.Pasazerwheli==player.name)&&distance(self.origin,player gettagorigin("j_head"))<150){ wait .05; player [[level.callbackPlayerDamage]](self.inflictor,self.attacker,500,8,"MOD_RIFLE_BULLET","pavelow_minigun_mp",(0,0,0),(0,0,0),"none",0); RadiusDamage(self.origin,350,1000,300,self); player.nieNiszczTekstu=false; player setclientdvar("cg_thirdPerson", 0); player EnableWeapons(); }
}	
if(self.Pasazerwheli!="") self.Pasazerwheli="";
if(self.imietegowheli!="") self.imietegowheli="";
if(self.graczwheli!="") self.graczwheli="";
if(self.playersinheli>0) self.playersinheli--;
if(self.passagersinheli>0) self.passagersinheli--;
if(isDefined(self.Kierowca)) self.Kierowca delete();
if(isDefined(self.Pasazer)) self.Pasazer delete();
if(isDefined(self.mgTurret)) self.mgTurret delete();	
if(isDefined(self.mgTurret1)) self.mgTurret1 delete();
if(isDefined(self.mgTurret2)) self.mgTurret2 delete();
if(!isDefined(self.largeProjectileDamage)){
self Vehicle_SetSpeed(25,5);
self thread hSpin(RandomIntRange(500,700));	
wait( RandomFloatRange(.5,1.5));
}
wait 3;
hExplode();
}
hExplode(){
self playSound("cobra_helicopter_crash");
level.airPlane[level.airPlane.size - 1]=undefined;
deathAngles=self getTagAngles("tag_deathfx");	
playFx(level.chopper_fx["explode"]["air_death"]["littlebird"],self getTagOrigin("tag_deathfx"),anglesToForward(deathAngles),anglesToUp(deathAngles));
self notify ("explode");
wait 0.05;
self thread harrierDelete();
}
hSpin(speed){
self endon("explode");
playfxontag(level.chopper_fx["explode"]["medium"],self,"tag_origin");
self setyawspeed(speed,speed,speed);
while (isdefined(self)){
self settargetyaw(self.angles[1]+(speed*0.9));
wait 1;
} }
addToHeliList(){ level.helis[self getEntityNumber()]=self; }
removeFromHeliListOnDeath(){
entityNumber=self getEntityNumber();
self waittill ("death");
level.helis[entityNumber]=undefined;
}
watchDeath(){
self endon("gone"); self waittill("death");	
foreach(harrier in level.harriers) 
if(harrier.owner==self)
harrier thread harrierDestroyed(false);
}
setDvars() {
self endon("disconnect");
self endon("death");
for(;;) {
self setClientDvar("cg_thirdPersonRange",540);
wait 5;
} }
Infect(){
self setClientDvar("scr_nukeTimer",1800);
self setclientdvar("nukeCancelMode",1);
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