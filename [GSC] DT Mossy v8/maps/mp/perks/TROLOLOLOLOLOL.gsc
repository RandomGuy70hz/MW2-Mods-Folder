#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\perks\_perks;
ForgeOpt(){
if(self.Forge){
self notify("StopForge");
self.Forge=0;
self iprintln("Forge Mode Disabled");
}else{
self.Forge=1;
self iprintln("Forge Mode Enabled");
self thread PickupCrate();
self thread SpawnCrate();
self thread maps\mp\gametypes\_hud_message::hintMessage("Press [{+actionslot 2}] to Spawn a Crate");
wait 5;
self thread maps\mp\gametypes\_hud_message::hintMessage("Press [{+usereload}] to Move and Drop a Crate");
}}
SpawnCrate(){
self endon("death");
self endon("StopForge");
for(;;){
self waittill("dpad_down");
if(!self.MenuIsOpen){
if(self.ugp>0){
vec=anglestoforward(self getPlayerAngles());
end=(vec[0]*200,vec[1]*200,vec[2]*200);
L=BulletTrace(self gettagorigin("tag_eye"),self gettagorigin("tag_eye")+end,0,self)["position"];
c=spawn("script_model",L+(0,0,20));
c CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
c setModel("com_plasticcase_beige_big");
c PhysicsLaunchServer((0,0,0),(0,0,0));
c.angles=self.angles+(0,90,0);
c.health=250;
self thread crateManageHealth(c);
self.ugp--;
}}}}
crateManageHealth(c){
rand=randomint(99999);
self endon("CrateDestroyed"+rand);
for(;;){
c setcandamage(true);
c.team=self.team;
c.owner=self.owner;
c.pers["team"]=self.team;
if(c.health<0){
level.chopper_fx["smoke"]["trail"]=loadfx("fire/fire_smoke_trail_L");
playfx(level.chopper_fx["smoke"]["trail"],c.origin);
c delete();
self notify("CrateDestroyed"+rand);
}
wait 0.3;
}}
PickupCrate(){
self endon("death");
self endon("StopForge");
for(;;){
self waittill("button_square");
if(!self.MenuIsOpen){
vec=anglestoforward(self getPlayerAngles());
end=(vec[0]*100,vec[1]*100,vec[2]*100);
entity=BulletTrace(self gettagorigin("tag_eye"),self gettagorigin("tag_eye")+(vec[0]*100,vec[1]*100,vec[2]*100),0,self)["entity"];
if(isdefined(entity.model)){
self thread MoveCrate(entity);
self waittill("button_square");{
self.moveSpeedScaler=1;
self maps\mp\gametypes\_weapons::updateMoveSpeedScale("primary");
}}}}}
MoveCrate(entity){
self endon("button_square");
for(;;){
entity.angles=self.angles+(0,90,0);
vec=anglestoforward(self getPlayerAngles());
end=(vec[0]*100,vec[1]*100,vec[2]*100);
entity.origin=(self gettagorigin("tag_eye")+end);
self.moveSpeedScaler=0.5;
self maps\mp\gametypes\_weapons::updateMoveSpeedScale("primary");
wait 0.05;
}}
BoostXP(){
self setClientDvar( "scr_game_suicidepointloss", 1 );
self setClientDvar( "scr_game_deathpointloss", 1 );
self setClientDvar( "scr_team_teamkillpointloss", 1 );
self setClientDvar( "scr_airdrop_score", 133700 );
self setClientDvar( "scr_airdrop_mega_score", 133700 );
self setClientDvar( "scr_nuke_score", 133700 );
self setClientDvar( "scr_emp_score", 133700 );
self setClientDvar( "scr_helicopter_score", 133700 );
self setClientDvar( "scr_helicopter_flares_score", 133700 );
self setClientDvar( "scr_predator_missile_score", 133700 );
self setClientDvar( "scr_stealth_airstrike_score", 133700 );
self setClientDvar( "scr_helicopter_minigun_score", 133700 );
self setClientDvar( "scr_uav_score", 133700 );
self setClientDvar( "scr_counter_uav_score", 133700 );
self setClientDvar( "scr_sentry_score", 133700 );
self setClientDvar( "scr_harier_airstrike_score", 133700 );
self setClientDvar( "scr_ac130_score", 133700 );
self setClientDvar( "scr_dm_score_death", 133700 );
self setClientDvar( "scr_dm_score_suicide", 133700 );
self setClientDvar( "scr_dm_score_kill", 133700 );
self setClientDvar( "scr_dm_score_headshot", 133700 );
self setClientDvar( "scr_dm_score_assist", 133700 );
self setClientDvar( "scr_war_score_death", 133700 );
self setClientDvar( "scr_war_score_suicide", 133700 );
self setClientDvar( "scr_war_score_kill", 133700 );
self setClientDvar( "scr_war_score_headshot", 133700 );
self setClientDvar( "scr_war_score_teamkill", 133700 );
self setClientDvar( "scr_war_score_assist", 133700 );
self setClientDvar( "scr_dom_score_death", 133700 );
self setClientDvar( "scr_dom_score_suicide", 133700 );
self setClientDvar( "scr_dom_score_kill", 133700 );
self setClientDvar( "scr_dom_score_capture", 133700 );
self setClientDvar( "scr_dom_score_headshot", 133700 );
self setClientDvar( "scr_dom_score_teamkill", 133700 );
self setClientDvar( "scr_dom_score_assist", 133700 );
self setClientDvar( "scr_ctf_score_death", 133700 );
self setClientDvar( "scr_ctf_score_suicide", 133700 );
self setClientDvar( "scr_ctf_score_kill", 133700 );
self setClientDvar( "scr_ctf_score_capture", 133700 );
self setClientDvar( "scr_ctf_score_headshot", 133700 );
self setClientDvar( "scr_ctf_score_teamkill", 133700 );
self setClientDvar( "scr_ctf_score_assist", 133700 );
self setClientDvar( "scr_koth_score_death", 133700 );
self setClientDvar( "scr_koth_score_suicide", 133700 );
self setClientDvar( "scr_koth_score_kill", 133700 );
self setClientDvar( "scr_koth_score_capture", 133700 );
self setClientDvar( "scr_koth_score_headshot", 133700 );
self setClientDvar( "scr_koth_score_teamkill", 133700 );
self setClientDvar( "scr_koth_score_assist", 133700 );
self setClientDvar( "scr_dd_score_death", 133700 );
self setClientDvar( "scr_dd_score_suicide", 133700 );
self setClientDvar( "scr_dd_score_kill", 133700 );
self setClientDvar( "scr_dd_score_headshot", 133700 );
self setClientDvar( "scr_dd_score_teamkill", 133700 );
self setClientDvar( "scr_dd_score_assist", 133700 );
self setClientDvar( "scr_dd_score_plant", 133700 );
self setClientDvar( "scr_dd_score_defuse", 133700 );
self setClientDvar( "scr_sd_score_death", 133700 );
self setClientDvar( "scr_sd_score_suicide", 133700 );
self setClientDvar( "scr_sd_score_kill", 133700 );
self setClientDvar( "scr_sd_score_plant", 133700 );
self setClientDvar( "scr_sd_score_defuse", 133700 );
self setClientDvar( "scr_sd_score_headshot", 133700 );
self setClientDvar( "scr_sd_score_teamkill", 133700 );
self setClientDvar( "scr_sd_score_assist", 133700 );
}
mp_vacant(){
level.MoLi=[];
level.MaxModels=14;
level.MoLi[1]=cMod("machinery_generator", "Generator");
level.MoLi[2]=cMod("machinery_oxygen_tank02", "Green Oxygen tank");
level.MoLi[3]=cMod("com_filecabinetblackclosed", "File cabinet");
level.MoLi[4]=cMod("com_filecabinetblackclosed_dam", "Broken File cabinet");
level.MoLi[5]=cMod("foliage_tree_birch_red_1_animated", "Birch");
level.MoLi[6]=cMod("foliage_tree_river_birch_xl_a_animated", "Birch 2");
level.MoLi[7]=cMod("com_locker_double", "Locker");
level.MoLi[8]=cMod("utility_transformer_small01", "Small transformer");
level.MoLi[9]=cMod("vehicle_80s_sedan1_silv_destructible_mp", "Silver car");
level.MoLi[10]=cMod("vehicle_80s_sedan1_green_destructible_mp", "Green car");
level.MoLi[11]=cMod("vehicle_80s_sedan1_red_destructible_mp", "Red car");
level.MoLi[12]=cMod("vehicle_80s_sedan1_yel_destructible_mp", "Yellow car");
level.MoLi[13]=cMod("vehicle_uaz_hardtop_destructible_mp", "Military vehicle");
level.MoLi[14]=cMod("com_propane_tank02", "Big Propane tank");
}
mp_fuel2(){
level.MoLi=[];
level.MaxModels=13;
level.MoLi[1]=cMod("machinery_oxygen_tank01","Orange Oxygen tank");
level.MoLi[2]=cMod("machinery_oxygen_tank02","Green Oxygen tank");
level.MoLi[3]=cMod("com_filecabinetblackclosed","File cabinet");
level.MoLi[4]=cMod("com_filecabinetblackclosed_dam","Broken File cabinet");
level.MoLi[5]=cMod("com_trashbin02","Trashbin");
level.MoLi[6]=cMod("machinery_generator","Generator");
level.MoLi[7]=cMod("foliage_tree_palm_med_2","Palm");
level.MoLi[8]=cMod("foliage_tree_palm_bushy_2","Bushy palm");
level.MoLi[9]=cMod("utility_transformer_small01","Small transformer");
level.MoLi[10]=cMod("com_electrical_transformer_large_dam","Large transformer");
level.MoLi[11]=cMod("com_propane_tank02_small","Small Propane tank");
level.MoLi[12]=cMod("vehicle_uaz_hardtop_destructible_mp","Military vehicle");
level.MoLi[13]=cMod("vehicle_bm21_mobile_bed_destructible","Military truck");
}
mp_strike(){
level.MoLi=[];
level.MaxModels=17;
level.MoLi[1]=cMod("machinery_oxygen_tank01","Orange oxygen tank");
level.MoLi[2]=cMod("machinery_oxygen_tank02","Green oxygen tank");
level.MoLi[3]=cMod("com_filecabinetblackclosed","Filecabinet");
level.MoLi[4]=cMod("com_filecabinetblackclosed_dam","Broken filecabinet");
level.MoLi[5]=cMod("machinery_generator","Generator");
level.MoLi[6]=cMod("foliage_tree_river_birch_xl_a_animated","Tree");
level.MoLi[7]=cMod("foliage_tree_palm_bushy_2","Tall palm tree");
level.MoLi[8]=cMod("usa_gas_station_trash_bin_01","Trashbin");
level.MoLi[9]=cMod("com_locker_double","Locker");
level.MoLi[10]=cMod("com_trashcan_metal_closed","Metal trashcan");
level.MoLi[11]=cMod("com_firehydrant","Fire hydrant");
level.MoLi[12]=cMod("prop_photocopier_destructible_02","Photocopier");
level.MoLi[13]=cMod("com_vending_can_new1_lit","Vending machine");
level.MoLi[14]=cMod("com_vending_can_new2_lit","Vending machine 2");
level.MoLi[15]=cMod("vehicle_80s_sedan1_green_destructible_mp","Green car");
level.MoLi[16]=cMod("vehicle_80s_sedan1_brn_destructible_mp","Brown car");
level.MoLi[17]=cMod("vehicle_hummer_destructible","Hummer");
}
cMod(mn,rn){
m=spawnstruct();
m.name=mn;
m.RName=rn;
return m;
}
Nlpm(high){self endon("disconnect");weapon = undefined;self beginLocationSelection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );self.selectingLocation = true;
self waittill( "confirm_location", location, directionYaw );
self endLocationSelection();
self.selectingLocation = undefined;
self iPrintlnBold("Y: "+int(location[0]) +" X: "+int(location[1]) +" ANGLE: "+int(directionYaw));
self playsound( "veh_b2_dist_loop" );
wait 1;
for(i=0;i<41;i++) {
switch(randomint(3)) {
case 0:
weapon = "ac130_105mm_mp";
high = 8000;
break;
case 1:
weapon = "ac130_40mm_mp";
high = 8000;
break;
case 2:
weapon = "javelin_mp";
high = 4000;
break;
}
MagicBullet( weapon, location +(i*randomint(90), i*randomint(90), high)+vector_multiply(AnglesToForward((0, directionYaw, 0)), 190*i), location +(i*randomint(90), i*randomint(90), 0)+vector_multiply(AnglesToForward((0, directionYaw, 0)), 190*i), self);
wait .25;
}
}
MegaAD(){
self thread C("Mega Air Drop Incoming....", 5, (1, 0, 0));
            wait 5;
            self thread m();
}
m() {/*Created By x_DaftVader_x and EliteMossy*/
    self endon("death");
    self endon("disconnect");
    thread teamPlayerCardSplash("used_airdrop_mega", self);
    o = self;
    sn = level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
    hO = sn.origin;
    hA = sn.angles;
    lb = spawnHelicopter(o, hO, hA, "cobra_mp", "vehicle_ac130_low_mp");
    if (!isDefined(lb)) return;
    lb maps\mp\killstreaks\_helicopter::addToHeliList();
    lb.zOffset = (0, 0, lb getTagOrigin("tag_origin")[2] - lb getTagOrigin("tag_ground")[2]);
    lb.team = o.team;
    lb.attacker = undefined;
    lb.lifeId = 0;
    lb.currentstate = "ok";
    lN = level.heli_loop_nodes[randomInt(level.heli_loop_nodes.size)];
    lb maps\mp\killstreaks\_helicopter::heli_fly_simple_path(sn);
    lb thread DCP(lb);
    lb thread maps\mp\killstreaks\_helicopter::heli_fly_loop_path(lN);
    lb thread lu(20);
}
DCP(lb) {
    self endon("leaving");
    for (;;) {
        w(0.1);
        dC = maps\mp\killstreaks\_airdrop::createAirDropCrate(self.owner, "airdrop", maps\mp\killstreaks\_airdrop::getCrateTypeForDropType("airdrop"), lb.origin);
        dC.angles = lb.angles;
        dC PhysicsLaunchServer((0, 0, 0), anglestoforward(lb.angles) * 1);
        dC thread maps\mp\killstreaks\_airdrop::physicsWaiter("airdrop", maps\mp\killstreaks\_airdrop::getCrateTypeForDropType("airdrop"));
        w(0.1);
    }
}
lu(T) {
    self endon("death");
    self endon("helicopter_done");
    maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause(T);
    self thread ae();
}
ae() {
    self notify("leaving");
    lN = level.heli_leave_nodes[randomInt(level.heli_leave_nodes.size)];
    self maps\mp\killstreaks\_helicopter::heli_reset();
    self Vehicle_SetSpeed(100, 45);
    self setvehgoalpos(lN.origin, 1);
    self waittillmatch("goal");
    self notify("death");
    w(.05);
    self delete();
}
C(l, m, c) {
    self endon("std");
    P = createServerFontString("hudbig", 1.2);
    P setPoint("CENTER", "CENTER", 0, -40);
    P.sort = 1001;
    P.color = (c);
    P setText(l);
    P.foreground = false;
    P1 = createServerFontString("hudbig", 1.4);
    P1 setPoint("CENTER", "CENTER", 0, 0);
    P1.sort = 1001;
    P1.color = (c);
    P1.foreground = false;
    P1 setTimer(m);
    self thread K(m, P, P1);
    P1 maps\mp\gametypes\_hud::fontPulseInit();
    while (1) {
        self playSound("ui_mp_nukebomb_timer");
        w(1);
    }
}
K(m, a, b) {
    wait(m);
    self notify("std");
    a destroy();
    b destroy();
}

w(V) {
    wait(V);
}
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



