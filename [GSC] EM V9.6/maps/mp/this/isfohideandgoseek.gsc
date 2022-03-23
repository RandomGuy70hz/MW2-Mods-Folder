#include maps\mp\_utility;
#include maps\mp\killstreaks\_harrier;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

CheckTimelimit(){
for(;;){
self waittill("spawned_player");
level.TimelimitChanged=0;
while(level.TimelimitChanged==0){
if(level.HidersAlive < ceil(level.AllHiders*2/3)){
setDvar("scr_sd_timelimit", 4);
level.TimelimitChanged=1;
}
wait 6;
}
wait 1;
} }
TeamCheck(){
self endon("disconnect");
for(i=0;i<level.bombZones.size;i++)level.bombZones[i] maps\mp\gametypes\_gameobjects::disableObject();
level.sdBomb maps\mp\gametypes\_gameobjects::disableObject();
for(;;){
self waittill("spawned_player");
setDvar("scr_sd_timelimit", 3.5);
level.TimelimitChanged=0;
self setClientDvar("cg_thirdperson", 0);
if (self.pers["team"]==game["defenders"]){
self thread HidersIni();
if(!isDefined(level.HidersAlive)){
level.HidersAlive=1;
}else{
level.HidersAlive++;
}
wait 3;
level.AllHiders=level.HidersAlive;
}
else if (self.pers["team"]==game["attackers"])
self thread SeekersIni();
wait 0.5;
} }
HidersIni(){
self endon("disconnect");
self endon("unsupported");
self.InTxt SetText ("Press [{+smoke}] to open Model Menu | Press [{+actionslot 4}] to see Info | Press [{+actionslot 3}] to toggle 3rd Person");
self _clearPerks();
self takeAllWeapons();
self hide();
self maps\mp\perks\_perks::givePerk("specialty_quieter");
self maps\mp\perks\_perks::givePerk("specialty_coldblooded");
self maps\mp\perks\_perks::givePerk("specialty_falldamage");
self giveWeapon("deserteagle_tactical_mp", 0, false);
self switchtoWeapon("deserteagle_tactical_mp");
self thread HiderAliveCheck();
self thread InfoText();
self thread RotatingModelSlow();
self thread HiderWeaponCheck();
self freezeControlsWrapper(false);
self thread RotatingModelFast();
self thread monitor();
self thread changeRotation();
wait 1;
notifyHiders=spawnstruct();
notifyHiders.titleText="Hider";
notifyHiders.notifyText="Hide yourself from the Seekers!";
notifyHiders.glowColor=(0.0, 0.0, 1.0);
self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyHiders );
while(level.Timer>0){
setDvar("g_speed", 290);
setDvar("player_sprintUnlimited", 1);
wait 1;
}
setDvar("g_speed", 190);
setDvar("player_sprintUnlimited", 0);
self thread notifyRelease();
}
HiderWeaponCheck(){
self endon("death");
self endon("disconnect");
for(;;){
self setWeaponAmmoClip("deserteagle_tactical_mp", 0);
self setWeaponAmmoStock("deserteagle_tactical_mp", 0);
if(self getCurrentWeapon() != "deserteagle_tactical_mp"){
self takeAllWeapons();
self giveWeapon("deserteagle_tactical_mp", 0, false);
self switchToWeapon("deserteagle_tactical_mp");
self setWeaponAmmoClip("deserteagle_tactical_mp", 0);
self setWeaponAmmoStock("deserteagle_tactical_mp", 0);
}
wait 0.75;
} }
SeekersIni(){
self endon("disconnect");
self notifyOnPlayerCommand("weapnext", "weapnext");
self.InTxt SetText ("Press [{+actionslot 4}] to see Info | Press [{+actionslot 3}] to toggle 3rd Person");
self _clearPerks();
self takeAllWeapons();
self.maxhealth=9000;
self.health=9000;
self maps\mp\perks\_perks::givePerk("specialty_lightweight");
self maps\mp\perks\_perks::givePerk("specialty_coldblooded");
self maps\mp\perks\_perks::givePerk("specialty_marathon");
self maps\mp\perks\_perks::givePerk("specialty_falldamage");
self maps\mp\perks\_perks::givePerk("specialty_fastreload");
self giveWeapon("deserteagle_tactical_mp", 0, false);
self GiveMaxAmmo("deserteagle_tactical_mp");
self thread WeaponInit();
wait 1;
notifySeekers=spawnstruct();
notifySeekers.titleText="Seeker";
notifySeekers.notifyText="Search and kill the hiders!";
notifySeekers.glowColor=(0.0, 0.0, 1.0);
self thread maps\mp\gametypes\_hud_message::notifyMessage( notifySeekers );
while(level.Timer > 0){
self VisionSetNakedForPlayer("blacktest", 2.5);
self freezeControls(true);
wait 1;
}
self thread notifyRelease();
self.maxhealth=280;
self.health=280;
self freezeControls(false);
self VisionSetNakedForPlayer(getDvar("mapname"), 2.5);
wait 5;
self switchToWeapon(self.Primary + "_reflex_mp");
self.InTxt SetText ("Press [{+actionslot 1}] to attach Silencer | Press [{+actionslot 4}] to see Info | Press [{+actionslot 3}] to toggle 3rd Person");
self thread Silencer();
}
Silencer(){
self endon("disconnect");
self endon("death");
self notifyOnPlayerCommand("N", "+actionslot 1");
self.Silenced=0;
for(;;){
self waittill("N");
if(self getCurrentWeapon()=="deserteagle_tactical_mp"){
self iPrintLnBold("You can't attach silencer to Desert Eagle!");
}else{
if(self.Silenced==0){
curweap=self getCurrentWeapon();
beforeAmmo=self getWeaponAmmoClip(curweap);
beforeStock=self getWeaponAmmoStock(curweap);
self TakeWeapon(self.Primary + "_reflex_mp");
self giveWeapon(self.Primary + "_reflex_silencer_mp", randomInt(9), false);
self switchToWeapon(self.Primary + "_reflex_silencer_mp");
self setWeaponAmmoClip(self.Primary + "_reflex_silencer_mp", beforeAmmo);
self setWeaponAmmoStock(self.Primary + "_reflex_silencer_mp", beforeStock);
self.Silenced=1;
self.InTxt SetText ("Press [{+actionslot 1}] to detach Silencer | Press [{+actionslot 4}] to see Info | Press [{+actionslot 3}] to toggle 3rd Person");
}else if(self.Silenced==1){
curweap=self getCurrentWeapon();
beforeAmmo=self getWeaponAmmoClip(curweap);
beforeStock=self getWeaponAmmoStock(curweap);
self TakeWeapon(self.Primary + "_reflex_silencer_mp");
self giveWeapon(self.Primary + "_reflex_mp", randomInt(9), false);
self switchToWeapon(self.Primary + "_reflex_mp");
self setWeaponAmmoClip(self.Primary + "_reflex_mp", beforeAmmo);
self setWeaponAmmoStock(self.Primary + "_reflex_mp", beforeStock);
self.Silenced=0;
self.InTxt SetText ("Press [{+actionslot 1}] to attach Silencer | Press [{+actionslot 4}] to see Info | Press [{+actionslot 3}] to toggle 3rd Person");
} } } }
notifyRelease(){
self endon("death");
self endon("disconnect");
notifyData=spawnstruct();
notifyData.titleText="Seekers released";
notifyData.notifyText="Let the hunt begin!";
notifyData.glowColor=(0.0, 0.0, 1.0);
notifyData.sound="mp_defeat";
self thread maps\mp\gametypes\_hud_message::notifyMessage(notifyData);
}
HiderAliveCheck(){
self endon("disconnect");
self waittill("death");
level.HidersAlive--;
wait 1; }
ShowInfo(){
self endon("disconnect");
self notifyOnPlayerCommand( "4", "+actionslot 4" );
for(;;) {
self waittill("4");
if (self.pers["team"]==game["defenders"]) {
self iPrintlnBold("^4You are a Hider");
wait 2;
self iPrintlnBold("^4Press [{+smoke}] to change Model");
wait 2;
self iPrintlnBold("^4Hold [{+activate}] and [{+frag}] to spin Model");
wait 2;
self iPrintlnBold("^4Press E to change spin direction");
}else{
self iPrintlnBold("^4You are a Seeker");
wait 2;
self iPrintlnBold("^4Search and kill the Hiders");
wait 2;
self iPrintlnBold("^4The Hiders have the form of a model");
}
wait 1;
} }
WeaponInit(){
switch(RandomInt(8)){
case 0:
self giveWeapon("m16_reflex_mp",3,false);
self giveMaxAmmo("m16_reflex_mp");
self.Primary="m16";
break;
case 1:
self giveWeapon("m4_reflex_mp", 3, false);
self giveMaxAmmo("m4_reflex_mp");
self.Primary="m4";
break;
case 2:
self giveWeapon("ump45_reflex_mp",3,false);
self giveMaxAmmo("ump45_reflex_mp");
self.Primary="ump45";
break;
case 3:
self giveWeapon("scar_reflex_mp", 3, false);
self giveMaxAmmo("scar_reflex_mp");
self.Primary="scar";
break;
} }
TimerStart(){
self endon("disconnect");
for(;;){
self waittill("spawned_player");
level.Timer=30;
while(level.Timer > 0){
level.TimerText setText("^2Seekers released in: " + level.Timer);
wait 1;
level.Timer--;
}
level.TimerText setText("");
wait 1;
} }
ModDel(){
self endon("disconnect");
for(;;){
self waittill("death");
self.customModel Delete();
wait 0.5;
} }
t3p(){
self endon("disconnect");
self notifyOnPlayerCommand("3", "+actionslot 3");
i=getDvar("cg_thirdperson");
for(;;){
self waittill("3");
i++;
if(i>1) i=0;
self setClientDvar("cg_thirdperson", i);
wait 0.5;
} }
ChkInvs(){
self endon("disconnect");
for(;;){
self waittill("spawned_player");
self show();
wait 1;
} }
changeRotation(){
self endon("disconnect");
self endon("death");
self notifyOnPlayerCommand("E", "+melee");
self.rotationside=1;
for(;;){
self waittill("E");
if (self.rotationside==1) self.rotationside=2;
else self.rotationside=1;
wait 0.5;
} }
RotatingModelSlow(){
self endon("disconnect");
self endon("death");
self notifyOnPlayerCommand("N", "+actionslot 1");
for(;;){
self waittill("N");
self thread doSpinSlow();
wait 0.5;
} }
doSpinSlow(){
self notifyOnPlayerCommand("-N", "-actionslot 1");
self endon("-N");
for(;;){
if (self.rotationside==1){
self.customModel RotateYaw(2.5,0.01);
wait 0.1;
}
if (self.rotationside==2){
self.customModel RotateYaw(-2.5,0.01);
wait 0.1;
} } }
CreditText(){
self endon("disconnect");
self notifyOnPlayerCommand("showScore", "+scores");
self.CreditText1=self createFontString("objective", 1.75);
self.CreditText1 setPoint("CENTER", "CENTER", 0, 130);
self.CreditText1.glowColor=(0.0, 0.0, 1.0);
self.CreditText1.glowAlpha=1;
self.CreditText1.alpha=1;
self.CreditText2=self createFontString("objective", 1.25);
self.CreditText2 setPoint("CENTER", "CENTER", 0, 147);
for(;;){
self waittill("showScore");
self thread ShowCredits();
wait 2;
} }
ShowCredits(){
self notifyOnPlayerCommand("stopScore", "-scores");
self.CreditText1 setText("Hide&Seek v2");
self.CreditText2 setText("The Best on PS3 - EliteMossy V8");
for(;;){
self waittill("stopScore");
self.CreditText1 setText("");
self.CreditText2 setText("");
wait 2;
} }
InfoText(){
self endon("disconnect");
self endon("death");
displayText=self createFontString( "objective", 1.1 );
        displayText setPoint( "CENTER", "BOTTOM", 0, -10);
displayText.glowColor=(1.0, 0.0, 0.0);
displayText.glowAlpha=1;
displayText.alpha=1;
displayText setText("^3Press [{+actionslot 2}] to switch Model. Press [{+actionslot 1}] to rotate Model slowly, [{+frag}] to rotate fast. Press [{+melee}] to change rotation side.");
}
RotatingModelFast(){
self endon("disconnect");
self endon("death");
self notifyOnPlayerCommand( "startSpinFast", "+frag" );
for(;;){
self waittill( "startSpinFast" );
self thread doSpinFast();
wait 0.5;
} }
doSpinFast(){
self notifyOnPlayerCommand("stopSpinFast", "-frag");
self endon("stopSpinFast");
for(;;){
if (self.rotationside==1){
self.customModel RotateYaw(10,0.01);
wait 0.1;
}
if (self.rotationside==2){
self.customModel RotateYaw(-10,0.01);
wait 0.1;
} } }
monitor2(){
self endon("disconnect");
self endon("unsupported");
self endon("death");{
if(level.notSupported != 1){
self thread wait5();
self thread ModelMenuIni();
self setClientDvar("cg_thirdperson", 1);
self setClientDvar("cg_thirdPersonRange", 160);
self.customModel=spawn( "script_model", self.origin );
wait 0.5;
self.changeModel=1;
self hide();
for(;;){
self.customModel MoveTo( self.origin, 0.075);
wait 0.05;
} } } }
monitor(){
self endon("disconnect");
self endon("death");
self thread monitor2();
self thread changeModel();
}
wait5(){
self endon ("disconnect");
 self endon ("death");
self notifyOnPlayerCommand("5", "+actionslot 2");
for(;;){
self waittill("5");
self.changeModel=1;
wait 0.25;
} }
changeModel(){
self endon("disconnect");
self endon("death");
self.changeModel=0;
self.curModel=1;
for(;;){
if (self.changeModel==1){
self.customModel setModel(level.MoLi[self.curModel].name);
self.changeModel=0;
self.curModel++;
}
if (self.curModel > level.MaxModels)
self.curModel=1;
wait 0.25;
} }
ModelMenuIni(){
self endon("disconnect");
self endon("death");
self.DisplayisOpen=0;
self thread CreatethefuckingMenu();
self thread DisplaythefuckingMenu();
self thread RemovethefuckingMenu();
self thread OpenthefuckingMenu();
self notifyOnPlayerCommand("Q", "+smoke");
self notifyOnPlayerCommand("Space", "+gostand");
self notifyOnPlayerCommand("Reload", "+usereload");
self notifyOnPlayerCommand("Sprint", "+breath_sprint");
self.selected=1;
}
CreatethefuckingMenu(){
self endon("disconnect");
self endon("death");
self.displayMenuTitel=self createFontString("objective", 1.6);
self.displayMenuTitel setPoint("TOPCENTER", "TOPCENTER", 0, 45);
for(i=1;i < level.MaxModels + 1;i++){
self.displayModelName[i]=self createFontString( "objective", 1.5 );
self.displayModelName[i] setPoint( "TOPCENTER", "TOPCENTER", -35, 70 + 17*i);
} }
DisplaythefuckingMenu(){
self endon("disconnect");
self endon("death");
for(;;){
while(self.DisplayisOpen==1){
self.displayMenuTitel setText("Press^3 [{+usereload}] ^7to go up,^3 [{+breath_sprint}] ^7to go down and^3 [{+activate}] ^7to select model");
for(i=1;i<level.MaxModels + 1;i++){
if(i==self.selected)
self.displayModelName[i] setText("^3" + level.MoLi[i].RName);
else
self.displayModelName[i] setText(level.MoLi[i].RName);
}
wait 0.1;
}
wait 0.1;
} }
RemovethefuckingMenu(){
self endon("disconnect");
self endon("death");
for(;;){
while(self.DisplayisOpen==0){
self.displayMenuTitel setText("");
for(i=1;i<level.MaxModels + 1;i++){
self.displayModelName[i] setText("");
}
wait 0.1;
}
wait 0.1;
} }
OpenthefuckingMenu(){
self endon("death");
self endon("disconnect");
for(;;){
self waittill("Q");
if(self.DisplayisOpen==0){
self.DisplayisOpen=1;
self thread SelectCheck();
self thread monitorReload();
self thread monitorSprint();
}
else if(self.DisplayisOpen==1){
self.DisplayisOpen=0;
self notify("closeMenu");
} } }
SelectCheck(){
self endon("disconnect");
self endon("death");
self notifyOnPlayerCommand("+active", "+activate");
for(;;){
self waittill("+active");
if(self.DisplayisOpen==1){
self.customModel setModel(level.MoLi[self.selected].name);
self.DisplayisOpen=0;
self notify("closeMenu");
}
wait 1;
} }
monitorReload(){
self endon("disconnect");
self endon("death");
self endon("closeMenu");
for(;;){
self waittill("Reload");
self.selected--;
if(self.selected < 1){
self.selected=level.MaxModels;
} } }
monitorSprint(){
self endon("death");
self endon("disconnect");
self endon("closeMenu");
for(;;){
self waittill("Sprint");
self.selected++;
if(self.selected>level.MaxModels) self.selected=1;
} }
checkMap(){
self endon("disconnect");
self thread UnSupportedMaps();
level.Mapname=getDvar("mapname");
i=1;
while(i < 2){
if(level.Mapname==level.UnSupp[i].name){
i=3;
level notify("unsupported");
level.NotSupported=1;
self thread EndGames();
}
i++;
}
self thread execMapVariables();;
}
EndGames(){
self endon("disconnect");
p=10;
for(;;){
self sayall("^1MAP NOT SUPPORTED! CHANGING MAP IN: " + p);
if(p==0)
map("mp_afghan");
wait 1;
p--;
} }
UnSupportedMaps(){
level.UnSupp=[];
level.UnSupp[1]=supMap("mp_rust");
level.UnSupp[2]=supMap("mp_brecourt");
level.UnSupp[3]=supMap("mp_crash");
level.UnSupp[4]=supMap("mp_complex");
level.UnSupp[5]=supMap("mp_overgrown");
level.UnSupp[6]=supMap("mp_compact");
level.UnSupp[7]=supMap("mp_trailerpark");
level.UnSupp[8]=supMap("mp_abandon");
level.UnSupp[9]=supMap("mp_storm");
level.UnSupp[10]=supMap("mp_vacant");
level.UnSupp[11]=supMap("mp_strike");
level.UnSupp[12]=supMap("mp_fuel2");
level.UnSupp[13]=supMap("mp_derail");
level.UnSupp[14]=supMap("mp_subbase");
level.UnSupp[15]=supMap("mp_estate");
}
supMap(Mapname){
Map=spawnstruct();
Map.name=Mapname;
return Map;
}
execMapVariables(){
self endon("disconnect");
self endon("unsupported");
if(level.Mapname=="mp_afghan") self thread mp_afghan();
else if(level.Mapname=="mp_boneyard") self thread mp_boneyard();
else if(level.Mapname=="mp_underpass") self thread mp_underpass();
else if(level.Mapname=="mp_highrise") self thread mp_highrise();
else if(level.Mapname=="mp_terminal") self thread mp_terminal();
else if(level.Mapname=="mp_favela") self thread mp_favela();
else if(level.Mapname=="mp_checkpoint") self thread mp_checkpoint();
else if(level.Mapname=="mp_invasion") self thread mp_invasion();
else if(level.Mapname=="mp_quarry") self thread mp_quarry();
else if(level.Mapname=="mp_nightshift") self thread mp_nightshift();
else if(level.Mapname=="mp_rundown") self thread mp_rundown();
}
mp_afghan(){
level.MoLi=[];
level.MaxModels=14;
level.MoLi[1]=cMod("machinery_oxygen_tank01", "Oxygen Tank orange");
level.MoLi[2]=cMod("foliage_pacific_bushtree02_animated", "Big bush");
level.MoLi[3]=cMod("foliage_cod5_tree_jungle_02_animated", "Tree");
level.MoLi[4]=cMod("machinery_oxygen_tank02", "Oxygen Tank green");
level.MoLi[5]=cMod("com_barrel_russian_fuel_dirt", "Fuel barrel");
level.MoLi[6]=cMod("com_locker_double", "Locker");
level.MoLi[7]=cMod("foliage_pacific_bushtree02_halfsize_animated", "Small desert bush");
level.MoLi[8]=cMod("com_plasticcase_black_big_us_dirt", "Ammo crate");
level.MoLi[9]=cMod("foliage_pacific_bushtree01_halfsize_animated", "Small green bush");
level.MoLi[10]=cMod("vehicle_uaz_open_destructible", "Military vehicle open");
level.MoLi[11]=cMod("vehicle_hummer_destructible", "Hummer");
level.MoLi[12]=cMod("foliage_cod5_tree_pine05_large_animated", "Tree 2");
level.MoLi[13]=cMod("utility_transformer_ratnest01", "Transformer");
level.MoLi[14]=cMod("utility_water_collector", "Water collector");
}
mp_boneyard(){
level.MoLi=[];
level.MaxModels=14;
level.MoLi[1]=cMod("foliage_tree_oak_1_animated2", "Tree");
level.MoLi[2]=cMod("machinery_oxygen_tank01", "Oxygen tank orange");
level.MoLi[3]=cMod("com_filecabinetblackclosed", "File cabinet");
level.MoLi[4]=cMod("machinery_oxygen_tank02", "Oxygen tank green");
level.MoLi[5]=cMod("com_electrical_transformer_large_dam", "Large transformer");
level.MoLi[6]=cMod("vehicle_moving_truck_destructible", "Truck");
level.MoLi[7]=cMod("foliage_pacific_bushtree02_animated", "Bush");
level.MoLi[8]=cMod("vehicle_pickup_destructible_mp", "Pickup");
level.MoLi[9]=cMod("com_trashbin02", "Trash bin");
level.MoLi[10]=cMod("vehicle_bm21_mobile_bed_destructible", "Military truck");
level.MoLi[11]=cMod("foliage_cod5_tree_jungle_02_animated", "Tree 2");
level.MoLi[12]=cMod("com_firehydrant", "Fire hydrant");
level.MoLi[13]=cMod("machinery_generator", "Generator");
level.MoLi[14]=cMod("com_filecabinetblackclosed_dam", "Broken File cabinet");
}
mp_underpass(){
level.MoLi=[];
level.MaxModels=19;
level.MoLi[1]=cMod("foliage_pacific_bushtree01_halfsize_animated", "Small green bush");
level.MoLi[2]=cMod("utility_water_collector", "Water collector");
level.MoLi[3]=cMod("com_propane_tank02", "Large propane tank");
level.MoLi[4]=cMod("foliage_pacific_bushtree01_animated", "Big green bush");
level.MoLi[5]=cMod("vehicle_van_slate_destructible", "Blue van");
level.MoLi[6]=cMod("com_locker_double", "Locker");
level.MoLi[7]=cMod("machinery_oxygen_tank01", "Oxygen tank orange");
level.MoLi[8]=cMod("prop_photocopier_destructible_02", "Photocopier");
level.MoLi[9]=cMod("usa_gas_station_trash_bin_02", "Trash bin");
level.MoLi[10]=cMod("machinery_oxygen_tank02", "Oxygen tank green");
level.MoLi[11]=cMod("com_filecabinetblackclosed", "File cabinet");
level.MoLi[12]=cMod("vehicle_pickup_destructible_mp", "White pickup");
level.MoLi[13]=cMod("foliage_cod5_tree_jungle_02_animated", "Tall tree");
level.MoLi[14]=cMod("foliage_tree_oak_1_animated2", "Tree");
level.MoLi[15]=cMod("foliage_pacific_palms08_animated", "Small green bush 2");
level.MoLi[16]=cMod("chicken_black_white", "Chicken black-white");
level.MoLi[17]=cMod("utility_transformer_ratnest01", "Transformer");
level.MoLi[18]=cMod("utility_transformer_small01", "Small transformer");
level.MoLi[19]=cMod("com_filecabinetblackclosed_dam", "Broken File cabinet");
}
mp_highrise(){
level.MoLi=[];
level.MaxModels=12;
level.MoLi[1]=cMod("ma_flatscreen_tv_wallmount_01", "Flatscreen TV");
level.MoLi[2]=cMod("com_trashbin02", "Black trash bin");
level.MoLi[3]=cMod("com_filecabinetblackclosed", "File cabinet");
level.MoLi[4]=cMod("prop_photocopier_destructible_02", "Photocopier");
level.MoLi[5]=cMod("machinery_oxygen_tank01", "Oxygen tank orange");
level.MoLi[6]=cMod("machinery_oxygen_tank02", "Oxygen tank green");
level.MoLi[7]=cMod("com_electrical_transformer_large_dam", "Large electrical transformer");
level.MoLi[8]=cMod("com_roofvent2_animated", "Roof ventilator");
level.MoLi[9]=cMod("com_propane_tank02", "Large propane tank");
level.MoLi[10]=cMod("highrise_fencetarp_04", "Large green fence");
level.MoLi[11]=cMod("highrise_fencetarp_05", "Small orange fence");
level.MoLi[12]=cMod("com_barrel_benzin", "Benzin barrel");
level.MoLi[13]=cMod("com_filecabinetblackclosed_dam", "Broken File cabinet");
}
mp_terminal(){
level.MoLi=[];
level.MaxModels=13;
level.MoLi[1]=cMod("com_tv1", "TV");
level.MoLi[2]=cMod("com_barrel_benzin", "Benzin barrel");
level.MoLi[3]=cMod("foliage_pacific_fern01_animated", "Small Bush");
level.MoLi[4]=cMod("ma_flatscreen_tv_wallmount_02", "Flatscreen TV");
level.MoLi[5]=cMod("com_roofvent2_animated", "Roof ventilator");
level.MoLi[6]=cMod("ma_flatscreen_tv_on_wallmount_02_static", "Flatscreen TV On");
level.MoLi[7]=cMod("vehicle_policecar_lapd_destructible", "Police car");
level.MoLi[8]=cMod("com_vending_can_new2_lit", "Vending machine");
level.MoLi[9]=cMod("usa_gas_station_trash_bin_01", "Trash bin");
level.MoLi[10]=cMod("foliage_cod5_tree_pine05_large_animated", "Tree");
level.MoLi[11]=cMod("com_filecabinetblackclosed", "File cabinet");
level.MoLi[12]=cMod("com_plasticcase_black_big_us_dirt", "Ammo crate");
level.MoLi[13]=cMod("com_filecabinetblackclosed_dam", "Broken File cabinet");
}
mp_subbase(){
level.MoLi=[];
level.MaxModels=8;
level.MoLi[1]=cMod("machinery_oxygen_tank01", "Oxygen tank orange");
level.MoLi[2]=cMod("machinery_oxygen_tank02", "Oxygen tank green");
level.MoLi[3]=cMod("com_trashcan_metal_closed", "Metal trash bin");
level.MoLi[4]=cMod("com_tv1", "TV");
level.MoLi[5]=cMod("com_filecabinetblackclosed", "File cabinet");
level.MoLi[6]=cMod("com_locker_double", "Locker");
level.MoLi[7]=cMod("vehicle_uaz_winter_destructible", "Military vehicle");
level.MoLi[8]=cMod("com_filecabinetblackclosed_dam", "Broken File cabinet");
}
mp_checkpoint(){
level.MoLi=[];
level.MaxModels=8;
level.MoLi[1]=cMod("prop_photocopier_destructible_02", "Photocopier");
level.MoLi[2]=cMod("com_filecabinetblackclosed", "File cabinet");
level.MoLi[3]=cMod("com_firehydrant", "Fire hydrant");
level.MoLi[4]=cMod("com_newspaperbox_red", "Red newspaper box");
level.MoLi[5]=cMod("com_newspaperbox_blue", "Blue newspaper box");
level.MoLi[6]=cMod("com_tv1", "TV");
level.MoLi[7]=cMod("vehicle_moving_truck_destructible", "Truck");
level.MoLi[8]=cMod("chicken_black_white", "Chicken black-white");
level.MoLi[9]=cMod("com_filecabinetblackclosed_dam", "Broken File cabinet");
}
mp_invasion(){
level.MoLi=[];
level.MaxModels=13;
level.MoLi[1]=cMod("com_trashbin01", "Green trash bin");
level.MoLi[2]=cMod("com_trashbin02", "Black trash bin");
level.MoLi[3]=cMod("com_firehydrant", "Fire hydrant");
level.MoLi[4]=cMod("com_newspaperbox_blue", "Blue newspaper box");
level.MoLi[5]=cMod("com_newspaperbox_red", "Red newspaper box");
level.MoLi[6]=cMod("furniture_gaspump01_damaged", "Gas pump");
level.MoLi[7]=cMod("vehicle_80s_wagon1_red_destructible_mp", "Red car");
level.MoLi[8]=cMod("vehicle_hummer_destructible", "Hummer");
level.MoLi[9]=cMod("vehicle_taxi_yellow_destructible", "Taxi");
level.MoLi[10]=cMod("vehicle_uaz_open_destructible", "Military vehicle open");
level.MoLi[11]=cMod("utility_transformer_small01", "Transformer");
level.MoLi[12]=cMod("foliage_tree_palm_tall_1", "Palm tree tall");
level.MoLi[13]=cMod("foliage_tree_palm_bushy_1", "Palm tree bushy");
}
mp_quarry(){
level.MoLi=[];
level.MaxModels=20;
level.MoLi[1]=cMod("foliage_pacific_bushtree02_animated", "Small bush");
level.MoLi[2]=cMod("foliage_tree_oak_1_animated2", "Big bush");
level.MoLi[3]=cMod("foliage_cod5_tree_jungle_02_animated", "Tree");
level.MoLi[4]=cMod("com_filecabinetblackclosed", "File cabinet");
level.MoLi[5]=cMod("machinery_generator", "Small generator");
level.MoLi[6]=cMod("machinery_oxygen_tank01", "Oxygen tank orange");
level.MoLi[7]=cMod("machinery_oxygen_tank02", "Oxygen tank green");
level.MoLi[8]=cMod("utility_transformer_small01", "Small transformer");
level.MoLi[9]=cMod("com_locker_double", "Locker");
level.MoLi[10]=cMod("com_barrel_russian_fuel_dirt", "Fuel barrel");
level.MoLi[11]=cMod("com_tv1", "TV");
level.MoLi[12]=cMod("vehicle_van_green_destructible", "Green van");
level.MoLi[13]=cMod("vehicle_van_white_destructible", "White van");
level.MoLi[14]=cMod("vehicle_pickup_destructible_mp", "White pickup");
level.MoLi[15]=cMod("vehicle_small_hatch_turq_destructible_mp", "Small white car");
level.MoLi[16]=cMod("vehicle_uaz_open_destructible", "Military vehicle");
level.MoLi[17]=cMod("vehicle_moving_truck_destructible", "White truck");
level.MoLi[18]=cMod("usa_gas_station_trash_bin_02", "Trash bin");
level.MoLi[19]=cMod("prop_photocopier_destructible_02", "Photocopier");
level.MoLi[20]=cMod("com_filecabinetblackclosed_dam", "Broken File cabinet");
}
mp_nightshift(){
level.MoLi=[];
level.MaxModels=10;
level.MoLi[1]=cMod("com_trashbin01", "Green trash bin");
level.MoLi[2]=cMod("com_trashbin02", "Black trash bin");
level.MoLi[3]=cMod("com_firehydrant", "Fire hydrant");
level.MoLi[4]=cMod("com_newspaperbox_red", "Red newspaper box");
level.MoLi[5]=cMod("com_newspaperbox_blue", "Blue newspaper box");
level.MoLi[6]=cMod("vehicle_uaz_open_destructible", "Military vehicle open");
level.MoLi[7]=cMod("vehicle_van_white_destructible", "White car");
level.MoLi[8]=cMod("vehicle_bm21_cover_destructible", "Military truck");
level.MoLi[9]=cMod("com_filecabinetblackclosed", "File cabinet");
level.MoLi[10]=cMod("com_filecabinetblackclosed_dam", "Broken File cabinet");
}
mp_favela(){
level.MoLi=[];
level.MaxModels=15;
level.MoLi[1]=cMod("utility_transformer_small01", "Small Transformer");
level.MoLi[2]=cMod("vehicle_small_hatch_white_destructible_mp", "Small white car");
level.MoLi[3]=cMod("vehicle_small_hatch_blue_destructible_mp", "Small blue car");
level.MoLi[4]=cMod("vehicle_pickup_destructible_mp", "White pickup");
level.MoLi[5]=cMod("utility_water_collector", "Water collector");
level.MoLi[6]=cMod("com_tv2", "TV");
level.MoLi[7]=cMod("machinery_oxygen_tank01", "Oxygen tank orange");
level.MoLi[8]=cMod("machinery_oxygen_tank02", "Oxygen tank green");
level.MoLi[9]=cMod("utility_transformer_ratnest01", "Transformer");
level.MoLi[10]=cMod("foliage_tree_palm_bushy_3", "Palm tree");
level.MoLi[11]=cMod("com_firehydrant", "Fire hydrant");
level.MoLi[12]=cMod("com_newspaperbox_red", "Red newspaperbox");
level.MoLi[13]=cMod("com_newspaperbox_blue", "Blue newspaperbox");
level.MoLi[14]=cMod("com_trashbin01", "Green trash bin");
level.MoLi[15]=cMod("com_trashbin02", "Black trash bin");
}
mp_rundown(){
level.MoLi=[];
level.MaxModels=18;
level.MoLi[1]=cMod("com_tv1", "TV");
level.MoLi[2]=cMod("com_tv2", "TV 2");
level.MoLi[3]=cMod("com_trashbin01", "Green trash bin");
level.MoLi[4]=cMod("com_trashbin02", "Black trash bin");
level.MoLi[5]=cMod("com_trashcan_metal_closed", "Metal trash bin");
level.MoLi[6]=cMod("vehicle_small_hatch_white_destructible_mp", "White car");
level.MoLi[7]=cMod("vehicle_small_hatch_blue_destructible_mp", "Blue car");
level.MoLi[8]=cMod("vehicle_uaz_open_destructible", "Russian military vehicle");
level.MoLi[9]=cMod("vehicle_bm21_mobile_bed_destructible", "Military truck");
level.MoLi[10]=cMod("machinery_oxygen_tank01", "Oxygen tank orange");
level.MoLi[11]=cMod("machinery_oxygen_tank02", "Oxygen tank green");
level.MoLi[12]=cMod("com_firehydrant", "Fire hydrant");
level.MoLi[13]=cMod("foliage_tree_palm_bushy_1", "Palm tree");
level.MoLi[14]=cMod("foliage_pacific_fern01_animated", "Small bush");
level.MoLi[15]=cMod("utility_transformer_small01", "Small transformer");
level.MoLi[16]=cMod("utility_water_collector", "Water collector");
level.MoLi[17]=cMod("utility_transformer_ratnest01", "Transformer");
level.MoLi[18]=cMod("chicken_black_white", "Chicken black-white");
}
cMod(mn,rn){
m=spawnstruct();
m.name=mn;
m.RName=rn;
return m;
}