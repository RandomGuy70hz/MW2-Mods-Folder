#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
iButts(){
self endon("disconnect");
self endon("death");
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
self.butA["X"]="+usereload"; //CHANGE!!!
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
butID=self.butN[buttonI];
self notifyOnPlayerCommand(butID,self.butA[self.butN[buttonI]]);
for (;;){
self waittill(butID);
self.butP[butID]=1;
wait .05;
self.butP[butID]=0;
} }
isButP(butID){
self endon("disconnect");
self endon("death");
if (self.butP[butID]==1) {
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
player thread maps\mp\killstreaks\flyableheli::steHeli(flyer);
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
self thread usuwanietekstow(lb);
self thread wsiadaniedoheli(lb);
self thread pieHeli(lb);
wait .05;
} }
usuwanietekstow(lb){
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
HeliControlHelp(int){
if (int==1){
displayText=self createFontString("default",1.3);
self thread destroyOnAny2( displayText,"EndChopperHelp","disconnect","disconnect","death","disconnect","death");
displayText setPoint("CENTER","CENTER",0,0);
displayText setText("Controls: [{+actionslot 2}] / [{+actionslot 1}] to go Up/Down. [{+actionslot 3}] / [{+actionslot 4}] to go Left/Right");
wait 6;
displayText setText("[{+frag}] to go Forward, [{+usereload}] to Exit, [{+attack}] to Shoot Turrets, L1 to Shoot Rockets");
wait 6;
self notify ("EndChopperHelp");
}else{
displayText=self createFontString("default",1.3);
self thread destroyOnAny2(displayText,"EndChopperHelp","disconnect","disconnect","death","disconnect","death");
displayText setPoint("CENTER","CENTER",0,0);
displayText setText("Gunner: [{+actionslot 2}] to mount Turret. [{+userealod}] to dismount Turret. [{+melee}] to Exit");
wait 6;
self notify ("EndChopperHelp");	
} }
wsiadaniedoheli(lb){
self endon("disconnect");
lb endon("gone");
lb endon("death");
level endon("game_ended");
if(distance(lb.origin,self gettagorigin("j_head"))<150&&distance(lb.origin+(0,0,-35),self gettagorigin("j_head"))>65&&lb.playersinheli==0){
self setLowerMessage(lb,"Press ^3[{+usereload}]^7 to get in as chopper pilot",undefined,50);
if(self isButP("X")==1&&lb.playersinheli==0){
self.MenuIsOpen=true;
self.maxhealth=9999999;
self thread HeliControlHelp(1);
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
self.MenuIsOpen=true;
self.nieNiszczTekstu=true;
self.maxhealth=9999999;
self.health=self.maxhealth;
self clearLowerMessage(lb);
wait .05;
self thread HeliControlHelp(0);
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
if(self.wlaczonapierwszaosoba) {
self Unlink();
self setclientdvar("cg_thirdPerson",1);
self PlayerLinkTo(lb.Kierowca,undefined,0,80,80,0,150,false);
self.wlaczonapierwszaosoba=false;
}else{
self Unlink();
self setclientdvar("cg_thirdPerson",0);
self PlayerLinkTo(lb.Kierowca,undefined,2,90,90,70,70,false);
self.wlaczonapierwszaosoba=true;
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
self.MenuIsOpen=false;
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
self.MenuIsOpen=false;
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
lbMissile endon("MissleExploded");
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
lbMissile notify("MissleExploded");
break;
}
wait 0.05;
} }
WatchReload(lb){
self endon("disconnect");
lb endon("death");
for(;;){
if(lb.ReloadMissile>=6){
self iPrintLnBold("Reloading Advanced Missiles");
wait 5;
self iPrintLnBold("Finished Reloading");
lb.ReloadMissile = 0;
break;
}
else
break;
break;
wait 0.05;
} }
DeleteAfterTime(entity_t,endPoint_t){
self endon("disconnect");
self endon("MissleExploded");
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
self endon("MissleExploded");
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
nieomin = true;
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
self endon("gone");
self waittill("death");		
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
//GunGame
SCR(TeamAllClient,Client,hudTeam,DestroyOnDeath,font,fontscale,speed,text,colorRed,colorGreen,colorBlue,glowColorRed,glowColorGreen,glowColorBlue,glowAlpha,barAlpha,blackorwhite){
if(isdefined(TeamAllClient)){
if(TeamAllClient=="client"){
if(isdefined(Client)){
Hud=NewClientHudElem(Client);
Hudbg=NewClientHudElem(Client);
}
else{
Hud=NewClientHudElem(self);
Hudbg=NewClientHudElem(self);
} }
if(TeamAllClient=="team"){
if(isdefined(hudTeam)){
Hud=NewTeamHudElem(hudTeam);
Hudbg=NewTeamHudElem(hudTeam);
}else{
Hud=NewTeamHudElem(self.team);
Hudbg=NewTeamHudElem(self.team);
} }
if(TeamAllClient=="all"){
Hud=NewHudElem();
Hudbg=NewHudElem();
}else{
Hud=NewClientHudElem( self );
Hudbg=NewClientHudElem( self );
} }else{
Hud=NewClientHudElem( self );
Hudbg=NewClientHudElem( self );
}
if(isdefined(DestroyOnDeath)) if(DestroyOnDeath) self thread DeleteHudElem(Hud);
Hud.alignX="center";
Hud.alignY="top";
Hud.horzAlign="center";
Hud.vertAlign="top";
Hud.foreground=true;
if(isdefined(fontscale)) Hud.fontScale=fontscale;
else Hud.fontScale=0.75;
if(isdefined(font)) Hud.font=font;
else Hud.font="hudbig";
Hud.alpha=1;
Hud.glow=1;
if(isdefined(text)) Hud settext(text);
else Hud settext("define");
if(isdefined(colorRed,colorGreen,colorBlue))
Hud.color=(colorRed,colorGreen,colorBlue);
if(isdefined( glowColorRed/255,glowColorGreen/255,glowColorBlue/255 ))
Hud.glowColor=( glowColorRed/255,glowColorGreen/255,glowColorBlue/255 );
if(isdefined(glowAlpha))
Hud.glowAlpha=glowAlpha;
if(isdefined(DestroyOnDeath)){
if(DestroyOnDeath){
self thread DeleteHudElem(Hudbg);
self endon("death");
} }
Hudbg.alignX="center";
Hudbg.alignY="top";
Hudbg.horzAlign="center";
Hudbg.vertAlign="top";
Hudbg.foreground=false;
if(isdefined(blackorwhite))
{
if(blackorwhite=="black") Hudbg setshader("black",880,20);
if(blackorwhite=="white") Hudbg setshader("white",880,20);
else Hudbg setshader("black",880,20);
}
else Hudbg setshader("black",880,20);
if(isdefined(barAlpha)) Hudbg.alpha=barAlpha;
if(!isdefined(speed))
speed=40;
Hud.x+=(text.size+870)*1.45;
level.News=Hud;
level.News.Textsize=text.size;
for(;;){
wait 0.05;
Hud moveovertime(((level.news.Textsize+870)/speed));
Hud.x -= (level.news.Textsize+870)*2.9;
wait ((level.news.Textsize+870)/speed)-0.05;
Hud.x += (level.news.Textsize+870)*2.9;
level notify("NewsRestarted");
}
}
DeleteHudElem(E){
self waittill("death");
E Destroy();
}
iG(){
self.upgscore=50;
self.finalkills=1;
self.inverse=false;
self.gL=[];
self.gL[0]=cG("usp_fmj_silencer_mp",9,false,false,false,""); 
self.gL[1]=cG("coltanaconda_tactical_mp",9,false,false,false,"");
self.gL[2]=cG("pp2000_mp",9,false,false,false,"");
self.gL[3]=cG("spas12_fmj_grip_mp",9,true,false,false,"");
self.gL[4]=cG("mp5k_fmj_reflex_mp",9,false,false,false,"");
self.gL[5]=cG("m4_heartbeat_reflex_mp",9,false,false,false,"");
self.gL[6]=cG("sa80_grip_reflex_mp",9,false,false,false,"");
self.gL[7]=cG("barrett_fmj_thermal_mp",9,true,false,false,"");
self.gL[8]=cG("at4_mp",9,true,false,false,"");
self.gL[9]=cG("aa12_grip_mp",9,false,false,false,"");
self.gL[10]=cG("fn2000_thermal_mp",9,false,false,false,"");
self.gL[11]=cG("glock_akimbo_fmj_mp",9,false,true,false,"");
self.gL[12]=cG("beretta393_reflex_mp",9,false,false,false,"");
self.gL[13]=cG("m1014_fmj_grip_mp",9,false,false,false,"");
self.gL[14]=cG("kriss_acog_rof_mp",9,true,false,false,"");
self.gL[15]=cG("scar_fmj_reflex_mp",9,false,false,false,"");
self.gL[16]=cG("mg4_eotech_heartbeat_mp",9,true,false,false,"");
self.gL[17]=cG("cheytac_fmj_mp",9,false,false,false,"");
self.gL[18]=cG("rpg_mp",9,false,false,false,"");
self.gL[19]=cG("riotshield_mp",9,false,false,true,"sentry");
self.gL[20]=cG("semtex_mp",9,false,false,false,"");
self.gL[21]=cG("coltanaconda_fmj_mp",9,true,false,false,"");
self.gL[22]=cG("tmp_akimbo_silencer_mp",9,true,true,false,"");
self.gL[23]=cG("ranger_akimbo_fmj_mp",9,false,true,false,"");
self.gL[24]=cG("p90_acog_rof_mp",9,false,false,false,"");
self.gL[25]=cG("masada_fmj_silencer_mp",9,false,false,false,"");
self.gL[26]=cG("fal_acog_fmj_mp",9,false,false,false,"");
self.gL[27]=cG("aug_fmj_grip_mp",9,true,false,false,"");
self.gL[28]=cG("wa2000_acog_silencer_mp",9,false,false,false,"");
self.gL[29]=cG("m79_mp",9,false,false,false,"");
self.gL[30]=cG("ump45_xmags_mp",9,false,false,true,"precision_airstrike");
self.gL[31]=cG("deserteaglegold_mp",9,false,false,false,"");
self.gL[32]=cG("c4_mp",9,false,false,false,"");
self.gL[33]=cG("tmp_mp",9,false,false,false,"");
self.gL[34]=cG("model1887_akimbo_mp",9,false,true,false,"");
self.gL[35]=cG("uzi_fmj_thermal_mp",9,false,false,false,"");
self.gL[36]=cG("ak47_acog_fmj_mp",9,false,false,false,"");
self.gL[37]=cG("m240_heartbeat_reflex_mp",9,false,false,false,"");
self.gL[38]=cG("m21_silencer_thermal_mp",9,false,false,false,"");
self.gL[39]=cG("throwingknife_mp",9,false,false,false,"");
self.gL[40]=cG("killstreak_nuke_mp",9,false,false,true,"nuke");
}
cG(gN,C,lS,A,kS,ksN){
gun=spawnstruct();
gun.name=gN;
gun.camo=C;
gun.laser=lS;
gun.akimbo=A;
gun.killstreak=kS;
gun.ksname=ksN;
return gun;
}
doB(){
setDvar("jump_height",39);
setDvar("bg_fallDamageMaxHeight",300);
setDvar("bg_fallDamageMinHeight",128);
self setClientDvar("g_speed",150);
setDvar("g_speed",150);
self.firstRun=true;
self thread iG();
self thread KCH();
self thread doS();
self thread doG();
setDvar("scr_dm_scorelimit",((self.gL.size-1)*self.upgscore)+(self.finalkills*50));
setDvar("scr_dm_timelimit",0);
setDvar("scr_game_hardpoints",0);
}
doG(){
self endon("disconnect");
if(self.inverse) self.curgun=self.gL.size-1;
else self.curgun=0;
curscore=0;
done=false;
while(true){
if(self.inverse&&self.curgun<=0) done=true;
if(!self.inverse&&self.curgun>=(self.gL.size-1)) done=true;
if(!done){
if((self.score-curscore>self.upgscore)){
self.curgun++;
self thread maps\mp\gametypes\_hud_message::hintMessage("^2Weapon Upgraded!");
curscore=self.score;
} }
while(self getCurrentWeapon()!=self.gL[self.curgun].name){
if(self.gL[self.curgun].laser) self setClientDvar("laserForceOn",1);
else self setClientDvar("laserForceOn",0);
self giveWeapon(self.gL[self.curgun].name, self.gL[self.curgun].camo,self.gL[self.curgun].akimbo);
self switchToWeapon(self.gL[self.curgun].name);
if(self.gL[self.curgun].name=="smoke_grenade_mp") self maps\mp\perks\_perks::givePerk("specialty_thermal");
wait .2;
}
self giveMaxAmmo(self.gL[self.curgun].name);
wait .2;
} }
doS(){
self endon("disconnect");
T=self createFontString("default",1.5);
T setPoint("TOPRIGHT","TOPRIGHT",-5,0);
while(true){
T setText("^3 Level "+self.curgun);
wait .2;
} }
KCH(){
self endon("disconnect");
while(true){
setDvar("cg_drawcrosshair",0);
self setClientDvar("cg_scoreboardPingText",1);
self setClientDvar("com_maxfps",0);
self setClientDvar("cg_drawFPS",1);
wait 1;
} }
doD(){
self takeAllWeapons(); 
self maps\mp\killstreaks\_killstreaks::clearKillstreaks();
self maps\mp\gametypes\_class::setKillstreaks("none","none","none");
self setPlayerData("killstreaks",0,"none");
self setPlayerData("killstreaks",1,"none");
self setPlayerData("killstreaks",2,"none");  
if (self.gL[self.curgun].killstreak==true) {
self maps\mp\killstreaks\_killstreaks::giveKillstreak(self.gL[self.curgun].ksname,true); 
self iPrintlnBold("^3KillStreak available!");
if (self.gL[self.curgun].ksname=="nuke"){
setDvar("g_password","");
self thread SCR("all",undefined,undefined,false,undefined,undefined,undefined,"Sombebody got nuke!",0,170,40,170,170,170,50,50,"black");
}
if (GetTime()>=420000&&self.gL[self.curgun].name==self.gL[0].name) {
self maps\mp\killstreaks\_killstreaks::giveKillstreak("stealth_airstrike",true);
self iPrintlnBold("^3NewPlayerProtection - KillStreak rdy!");
} }
setDvar("g_speed",220);
setDvar("bg_fallDamageMaxHeight",1);
setDvar("bg_fallDamageMinHeight",99999);
self _clearPerks();
self maps\mp\perks\_perks::givePerk("specialty_marathon");
if (GetAssignedTeam(self)==1) team="axis";
else team="allies";
if (GetTeamScore(team)>=500){
self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
if (self.pem[0]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[0]=true;
} }
if (GetTeamScore(team)>=1000){
self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
if (self.pem[1]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[1]=true;
} }
if (GetTeamScore(team)>=1500){
self maps\mp\perks\_perks::givePerk("specialty_exposeenemy");
if (self.pem[2]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[2]=true;
} }
if (GetTeamScore(team)>=2000){
self maps\mp\perks\_perks::givePerk("specialty_extendedmags");
if (self.pem[3]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[3]=true;
} }
if (GetTeamScore(team)>= 2500){
self maps\mp\perks\_perks::givePerk("specialty_bulletpenetration");
if (self.pem[4]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[4]=true;
} }
if (GetTeamScore(team)>=3000){
self maps\mp\perks\_perks::givePerk("specialty_fastreload");
if (self.pem[5]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[5]=true;
} }
if (GetTeamScore(team )>=3500){
self maps\mp\perks\_perks::givePerk("specialty_fastsnipe");
if (self.pem[6]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[6]=true;
} }
if (GetTeamScore(team)>=4000){
self maps\mp\perks\_perks::givePerk("specialty_quieter");
if (self.pem[7]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[7]=true;
} }
if (GetTeamScore(team)>=4500){
self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
if (self.pem[8]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[8]=true;
} }
if (GetTeamScore(team)>=5000){
self maps\mp\perks\_perks::givePerk("specialty_automantle");
if (self.pem[9]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[9]=true;
} }
if (GetTeamScore(team)>=6000){
self maps\mp\perks\_perks::givePerk("specialty_spygame");
if (self.pem[10]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[10]=true;
} }
if (GetTeamScore(team)>= 7000){
self maps\mp\perks\_perks::givePerk("specialty_improvedholdbreath");
if (self.pem[11]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[11]=true;
} }
if (GetTeamScore(team)>=8000){
self maps\mp\perks\_perks::givePerk("specialty_selectivehearing");
if (self.pem[12]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[12]=true;
} }
if (GetTeamScore(team)>=9000){
self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
if (self.pem[13]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[13]=true;
} }
if (GetTeamScore(team )>=10000){
self maps\mp\perks\_perks::givePerk("specialty_quickdraw");
if (self.pem[14]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[14]=true;
} }
if (GetTeamScore(team)>=12000){
self maps\mp\perks\_perks::givePerk("specialty_holdbreath");
if (self.pem[15]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[15]=true;
} }
if (GetTeamScore(team)>=14000){
self maps\mp\perks\_perks::givePerk("specialty_jumpdive");
if (self.pem[16]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[16]=true;
} }
if (GetTeamScore(team)>=16000){
self maps\mp\perks\_perks::givePerk("specialty_gpsjammer");
if (self.pem[17]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[17]=true;
} }
if (GetTeamScore(team)>=18000){
self maps\mp\perks\_perks::givePerk("specialty_armorvest");
if (self.pem[18]==false){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"Teamscore! New Perk",170,0,0,170,170,170,undefined,254,"black");
self.pem[18]=true;
} }
if(self.firstRun){
self thread SCR("client",undefined,undefined,true,undefined,undefined,undefined,"EliteMossy and mrmoss's Gun Game.  Kill To Upgrade Gun.  Nuke Team Wins!  Nuke At Level 40!",0,170,40,170,170,170,undefined,254,"black");
self.firstRun=false;
} }
//OneInTheChamber
donateBullet(){
self setWeaponAmmoStock(level.pistol,0);
self setWeaponAmmoClip(level.pistol,0);
self setWeaponAmmoStock(level.pistol,1);
self setWeaponAmmoClip(level.pistol,0);
}
doSpectate() {
self endon("disconnect");
self endon("death");
maps\mp\gametypes\_spectating::setSpectatePermissions();  
self allowSpectateTeam("freelook",true);
self.sessionstate="spectator";
self setContents(0);
}
monDe(){
self endon("disconnect");
self waittill("death");
self.lives--;
}
monKi(){
self endon("disconnect");
self thread monWi();
for(;;){
self waittill("killed_enemy");
self thread donateBullet();
wait 0.05;
} }
monWi(){
self endon("disconnect");
wait 30;
for(;;){
a=0;
foreach (p in level.players)
if ((p.alive==true)&&(p.name!=self.name))
a++;
if(a==0)
level maps\mp\gametypes\_gamelogic::endGame( "self", "Congratulations "+self.name+" !" );
wait 0.05;
} }
doDvarsOINTC(){
livesLeftNote = "";
self thread monDe();
self thread monKi();
if(self.lives>1)
livesLeftNote="^1"+self.lives+"^7 lives left";
else if(self.lives==1)
livesLeftNote="^11 life left - Noob";
else
livesLeftNote="^1You suck, retard!";
self thread maps\mp\gametypes\_hud_message::hintMessage(livesLeftNote);
if(self.lives<= 0||self.lives>3){
doSpectate();
self.alive=false;
return;	
}
self takeAllWeapons();
self giveWeapon(level.pistol,0,false);
while(self getCurrentWeapon()!=level.pistol){
self switchToWeapon(level.pistol);
wait 0.2;
}
self setWeaponAmmoStock(level.pistol,0);
self setWeaponAmmoClip(level.pistol,1);
self.maxhealth=20;
self.health=self.maxhealth;
self _clearPerks();
self maps\mp\perks\_perks::givePerk("specialty_marathon");
self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
self maps\mp\perks\_perks::givePerk("specialty_fastreload");
self maps\mp\perks\_perks::givePerk("specialty_quickdraw");
self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
self maps\mp\perks\_perks::givePerk("specialty_lightweight");
self maps\mp\perks\_perks::givePerk("specialty_fastsprintrecovery");
self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
self maps\mp\perks\_perks::givePerk("specialty_falldamage");
self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
}
doConnect() {	
self endon("disconnect");
setDvar("scr_dm_scorelimit",0);
setDvar("scr_dm_timelimit",0);
setDvar("scr_game_hardpoints",0);
self.lives=3;
self.alive=true;
for(;;){
self maps\mp\killstreaks\_killstreaks::clearKillstreaks();
self maps\mp\gametypes\_class::setKillstreaks("none","none","none");
self setPlayerData("killstreaks",0,"none");
self setPlayerData("killstreaks",1,"none");
self setPlayerData("killstreaks",2,"none");
wait 0.2;
} }
Initialize(){
self notifyOnPlayerCommand("aim", "+toggleads_throw");
for(;;){
self waittill("spawned_player");
self.javelinStock = 2;
self thread InitStage();
wait 0.1;
} }
InitStage(){
self endon("valkyrie_fired");
self endon("death");
self.stage = 1;
for(;;){
if(self.stage==1){
if(self getCurrentWeapon()=="javelin_mp"&&self PlayerADS()&&self.WantsValk==true){
self.stage = 2;
self thread makeBar();
wait 0.05;
} }
if(self.stage==2){
while(self AttackButtonPressed()==false&&self getCurrentWeapon()=="javelin_mp"&&self PlayerADS()&&self.WantsValk==true){
if(isDefined(self.javelinStage))
maps\mp\_javelin::ResetJavelinLocking();
wait 0.1;
}
if(self getCurrentWeapon()=="javelin_mp" && self PlayerADS())
self thread FireValkyrie();
else
self.stage=1;
}
wait 0.1;
} }
makeBar()
{
        self endon("destroy_bar");
        self endon("death");
        self thread destroyBar();

        wait 0.5;
        self.tehbar = createPrimaryProgressBar(-250);
        self.tehbar.bar.x = -40;
        self.tehbar.x = 20;
        self.tehbar.bar.color = (0.3,0.8,0.5);
        self.tehbar updateBar(1);

        self waittill("valkyrie_fired");
        maxtime = 12;
        timeleft = 12;
        for(;;)
        {
                wait 0.05;
                timeleft=timeleft - 0.05;
                self.tehbar updateBar(timeleft/maxtime);
                if(timeleft/maxtime<0.45)
                {
                        self.tehbar.bar.color = (1,0,0);
                }
        }
}

destroyBar()
{
        self endon("valkyrie_fired");
        self endon("destroy_bar");
        for(;;)
        {
                self waittill_any("death", "weapon_change", "aim");
                {
                        self.tehbar.bar destroy();
                        self.tehbar destroy();
                        self notify("destroy_bar");
                }
                wait 0.05;
        }
}
FireValkyrie(){
forward=self getTagOrigin("j_head");
end=self thread vector_scal(anglesToForward(self getPlayerAngles()),1000000);
Crosshair=BulletTrace(forward,end,0,self)["position"];
valkyrie=MagicBullet("remotemissile_projectile_mp",forward,Crosshair,self);
self notify("valkyrie_fired");
if(!isDefined(valkyrie))
return;
valkyrie setCanDamage(true);
MissileEyes(self,valkyrie);
self.javelinStock--;
self setWeaponAmmoClip("javelin_mp", 0);
if(self.javelinStock<1){
self switchToWeapon(self getLastWeapon());
while(self getCurrentWeapon()=="javelin_mp"){
wait 0.1;
}
self takeWeapon("javelin_mp");
}else{
self thread InitStage();
} }
MissileEyes(player,valkyrie){
player endon("joined_team");
player endon("joined_spectators");
valkyrie thread maps\mp\killstreaks\_remotemissile::Rocket_CleanupOnDeath();
player thread maps\mp\killstreaks\_remotemissile::Player_CleanupOnGameEnded(valkyrie);
player thread maps\mp\killstreaks\_remotemissile::Player_CleanupOnTeamChange(valkyrie);
player VisionSetMissilecamForPlayer("black_bw",0);
player endon ("disconnect");
if(isDefined(valkyrie)){
player VisionSetMissilecamForPlayer(game["thermal_vision"], 0);
player ThermalVisionFOFOverlayOn();
player CameraLinkTo(valkyrie, "tag_origin");
player ControlsLinkTo(valkyrie);
if(getDvarInt("camera_thirdPerson"))
player setThirdPersonDOF(false);
valkyrie waittill("death");
player notify("destroy_bar");
player.tehbar.bar destroy();
player.tehbar destroy();
player ControlsUnlink();
player freezeControlsWrapper(true);
if(!level.gameEnded||isDefined(player.finalKill))
player thread maps\mp\killstreaks\_remotemissile::staticEffect(0.5);
wait 0.5;
player ThermalVisionFOFOverlayOff();
player CameraUnlink();
if(getDvarInt("camera_thirdPerson"))
player setThirdPersonDOF(true);       
}
player clearUsingRemote();
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
if(Type==7){
MyTeam=randomint(2);Type=randomint(7);
}
team=get_enemy_team(self.team);if(MyTeam)team=self.team;
self detachAll();
[[game[team+"_model"][ModelType[Type]]]]();
}
JZombiez(){
self endon("disconnect");
self endon("death");
if(!level.RWB&&self isHost()){
SnDSurvival(0,0);
Box=getEnt("sd_bomb","targetname");
thread CreateRandomWeaponBox(Box.origin+(0,0,15),game["attackers"]);
thread CreateRandomPerkBox(Box.origin+(0,50,15),game["attackers"]);
level thread JZombiesScore();
level.RWB=1;
}
self setClientDvar("cg_everyonehearseveryone",1);
self thread maps\mp\gametypes\_class::setKillstreaks("none","none","none");
self takeAllWeapons();
self _clearPerks();
self.ExpAmmo=0;
if(self.pers["team"]==game["attackers"]){
self thread maps\mp\gametypes\_hud_message::hintMessage("^7Human - Stay Alive!");
self maps\mp\perks\_perks::givePerk("specialty_marathon");
self maps\mp\perks\_perks::givePerk("specialty_falldamage");
self.maxhealth=100;
self.health=self.maxhealth;
Wep="beretta_fmj_mp";
self.moveSpeedScaler=1.1;       
self setMoveSpeedScale(self.moveSpeedScaler);
wait 0.2;
self _giveWeapon(Wep);
self switchToWeapon(Wep);
wait 0.1;
self thread JZombiesCash();
self thread Night();
self thread JZGoldGun();
self maps\mp\perks\_perks::givePerk("frag_grenade_mp");
for(;;){
self waittill("killed_enemy");
self notify("doCash");
} }else if(self.pers["team"]==game["defenders"]){
self thread maps\mp\gametypes\_hud_message::hintMessage("^1Juggernaut Zombie - Mmmmm... Brains!");
self maps\mp\perks\_perks::givePerk("specialty_marathon");
self maps\mp\perks\_perks::givePerk("specialty_quieter");
self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
self maps\mp\perks\_perks::givePerk("specialty_falldamage");
ChangeAppearance(6,1);
self.maxhealth=50*(game["roundsWon"][game["attackers"]]+1);
self.health=self.maxhealth;
if(self.health>50){
self iPrintlnBold("^1Health Increased : "+(((self.maxhealth/50)-1)*100)+" Percent");
}
Wep="airdrop_marker_mp";
self.moveSpeedScaler=1; 
self setMoveSpeedScale(self.moveSpeedScaler);
wait 0.2;
self _giveWeapon(Wep);
self switchToWeapon(Wep);
wait 0.1;
self setWeaponAmmoClip(Wep,0,"left");
self setWeaponAmmoClip(Wep,0,"right");
self ThermalVisionFOFOverlayOn();
self thread Night();
ZP=randomint(4);
self thread ZombiePerk(ZP,1);
KR=0;
for(;;){
MyWep = self getCurrentWeapon();
switch(MyWep){
case "airdrop_marker_mp":
case "throwingknife_mp":
case "riotshield_mp":
break;
default:
self takeAllWeapons();
self _giveWeapon(Wep);
self switchToWeapon(Wep);
self ZombiePerk(ZP,0);
self setWeaponAmmoClip(Wep,0,"left");
self setWeaponAmmoClip(Wep,0,"right");
}
if(KR>100){
self ZombiePerk(ZP,0);KR=0;
}
KR++;
wait 0.05;
} } }
SnDSurvival(S,W){
doRestart=0;if(getDvar("scr_sd_timelimit")!="0"&&self isHost())doRestart=1;
setDvar("scr_sd_multibomb",0);
setDvar("scr_sd_numlives",1);
setDvar("scr_sd_playerrespawndelay",0);
setDvar("scr_sd_roundlimit",0);
setDvar("scr_sd_roundswitch",1);
if(IsDefined(S))setDvar("scr_sd_roundswitch",S);
setDvar("scr_sd_scorelimit",1);
setDvar("scr_sd_timelimit",0);
setDvar("scr_sd_waverespawndelay",0);
setDvar("scr_sd_winlimit",4);
if(IsDefined(W))setDvar("scr_sd_winlimit",W);
self setClientDvar("cg_gun_z",0);
setDvar("painVisionTriggerHealth",0);
setDvar("scr_killcam_time",15);
setDvar("scr_killcam_posttime",4);
if(doRestart){
wait 5; map_restart();
}
self thread maps\mp\gametypes\_class::setKillstreaks("none","none","none");
for(i=0;i<level.bombZones.size;i++)level.bombZones[i] maps\mp\gametypes\_gameobjects::disableObject();
level.sdBomb maps\mp\gametypes\_gameobjects::disableObject();
setObjectiveHintText(game["attackers"],"");setObjectiveHintText(game["defenders"],"");
}
CreateRandomWeaponBox(O,T){
B=spawn("script_model",O);
B setModel("com_plasticcase_friendly");
B Solid();
B CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
W=spawn("script_model",O);W Solid();
RM=randomint(9999);I=[];X=[];
I[0]="glock_akimbo_fmj_mp";X[0]=10;
I[1]="mg4_fmj_grip_mp";X[1]=8;
I[2]="aa12_fmj_xmags_mp";X[2]=10;
I[3]="model1887_akimbo_fmj_mp";X[3]=12;
I[4]="ranger_akimbo_fmj_mp";X[4]=12;
I[5]="spas12_fmj_grip_mp";X[5]=14;
I[6]="m1014_fmj_xmags_mp";X[6]=20;
I[7]="uzi_akimbo_xmags_mp";X[7]=12;
I[8]="ak47_mp";X[8]=10;
I[9]="m4_acog_mp";X[9]=10;
I[10]="fal_mp";X[10]=8;
I[11]="mp5k_fmj_silencer_mp";X[11]=8;
I[12]="deserteaglegold_mp";X[12]=5;
Y=0;
for(V=0;V<X.size;V++){
Y+=X[V];
}
for(;;){
foreach(P in level.players){
wait 0.01;
if(IsDefined(T)&&P.pers["team"]!=T)continue;
R=distance(O,P.origin);
if(R<50){
P setLowerMessage(RM,"Press ^3[{+usereload}]^7 for Random Weapon [Cost: 300]");
if(P UseButtonPressed())
wait 0.1;
if(P UseButtonPressed()){
P clearLowerMessage(RM,1);
if(P.bounty>299){
P.bounty-=400;
P notify("doCash");
RW="";J=0;G=randomint(Y);for(V=0;V<X.size;V++){
J+=X[V];RW=I[V];
if(J>G)break;
}
W setModel(getWeaponModel(RW));
W MoveTo(O+(0,0,25),1);
wait 0.2;
if(P GetWeaponsListPrimaries().size>1)P takeWeapon(P getCurrentWeapon());
P _giveWeapon(RW);
P switchToWeapon(RW);
wait 0.6;
W MoveTo(O,1);
wait 0.2;
W setModel("");
}else{
P iPrintlnBold("^1You DO NOT Have Enough Cash!");
wait 0.05;
} } }else{
P clearLowerMessage(RM,1);
} } } }
CreateRandomPerkBox(O,T){
B = spawn("script_model",O);
B setModel("com_plasticcase_friendly");
B Solid();
B CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
RM=randomint(9999);I=[];X=[];
I[0]="specialty_fastreload";X[0]="^4Sleight of Hand";
I[1]="specialty_bulletdamage";X[1]="^1Stopping Power";
I[2]="specialty_coldblooded";X[3]="^1Cold Blooded";
I[3]="specialty_grenadepulldeath";X[4]="^2Martydom";
I[4]="ammo";X[2]="^4Extra Ammo";
for(;;){
foreach(P in level.players){
wait 0.01;
if(IsDefined(T)&&P.pers["team"]!=T)continue;
R=distance(O,P.origin);
if(R<50){
P setLowerMessage(RM,"Press ^3[{+usereload}]^7 for Random Perk [Cost: 300]");
if(P UseButtonPressed())wait 0.1;
if(P UseButtonPressed()){
P clearLowerMessage(RM,1);
if(P.bounty>299){
P.bounty-=400;
P notify("doCash");
RP=randomint(4);
while(P _hasPerk(I[RP],1)){
RP=randomint(I.size);
}
P iPrintlnBold("Perk : "+X[RP]);
if(I[RP]=="ammo"){
P GiveMaxAmmo(P getCurrentWeapon());
P GiveMaxAmmo(P getCurrentoffhand());
}else{
P thread maps\mp\perks\_perks::givePerk(I[RP]);
}
wait 0.2;
}else{
P iPrintlnBold("^1You DO NOT Have Enough Cash!");
wait 0.05;
} } }else{
P clearLowerMessage(RM,1);
} } } }
ZombiePerk(N,P){
if(N==0){
self.moveSpeedScaler=1.3;
self setMoveSpeedScale(self.moveSpeedScaler);
if(P){wait 2;self iPrintlnBold("^1Ability : Super Speed");}
}
else if(N==1){
Wep="riotshield_mp";
self _giveWeapon(Wep);
self switchToWeapon(Wep);
if(P){wait 2;self iPrintlnBold("^1Ability : Riot Shield");}
}else{
self maps\mp\perks\_perks::givePerk("throwingknife_mp");
if(P){wait 2;self iPrintlnBold("^1Ability : Throwing Knife");}
} }
JZGoldGun(){
self endon("disconnect");
self endon("death");
for(;;){
W=self getCurrentWeapon();
if(W=="deserteaglegold_mp"){
self.ExpAmmo=1;
}else{
self.ExpAmmo=0;
}
wait 0.1;
} }
JZombiesScore(){
for(;;){
if(game["roundsWon"][game["defenders"]]>0){
level.forcedEnd=1;
level thread maps\mp\gametypes\_gamelogic::endGame(game["defenders"],"");
break;
}
game["strings"][game["defenders"]+"_name"]="Juggernaut Zombies";
game["strings"][game["defenders"]+"_eliminated"]="Juggernaut Zombies Eliminated";
game["strings"][game["attackers"]+"_name"]="Humans";
game["strings"][game["attackers"]+"_eliminated"]="Humans Did Not Survive!";
level deletePlacedEntity("misc_turret");
wait 1;
} }
Night(){
V=0;
for(;;){
self closepopupMenu();
self VisionSetNakedForPlayer("cobra_sunset3",0.01);
wait 0.01;
V++;
} }
JZombiesCash(){
self endon("disconnect");
self endon("death");
self.bounty=100+(self.kills*200);
if(self isHost())self.bounty+=9999;
if(self.bounty>500)self iPrintlnBold("^2"+(self.bounty-500)+" BONUS CASH!");
for(;;){
self.cash destroy();
self.cash=NewClientHudElem(self);
self.cash.alignX="right";
self.cash.alignY="center";
self.cash.horzAlign="right";
self.cash.vertAlign="center";
self.cash.foreground=1;
self.cash.fontScale=1;
self.cash.font="hudbig";
self.cash.alpha=1;
self.cash.color=(1,1,1);
self.cash setText("Cash : "+self.bounty);
self waittill("doCash");
self.bounty+=100;
} }