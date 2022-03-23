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
adverT(){foreach(p in level.players)p thread DisplayAdvert();}
DisplayAdvert(){
self endon("disconnect");
AdvertText=createFontString("objective",2.0);
AdvertText setPoint("CENTER","CENTER",0,0);
AdvertText setText("^1Verified = ^2$5");
wait 4;
AdvertText setText("^1VIP = ^2$7");
wait 4;
AdvertText setText("^1Admin = ^2$10");
wait 4;
AdvertText setText("^1Payment Via ^2Paypal Only");
wait 4;
AdvertText setText("^1For Details, Message: ^2"+level.hostis);
wait 4;
AdvertText setText("^1Subscribe To ^0www.Youtube.com/User/Maty360414");
wait 6;
AdvertText destroy();
} 
proAll(){foreach(p in level.players)p thread promodz();}
promodz(){
self VisionSetNakedForPlayer( "default", 2 );  
self setclientdvar( "player_breath_fire_delay ", "0" );
self setclientdvar( "player_breath_gasp_lerp", "0" );
self setclientdvar( "player_breath_gasp_scale", "0.0" );
self setclientdvar( "player_breath_gasp_time", "0" );
self setClientDvar( "player_breath_snd_delay ", "0" );
self setClientDvar( "perk_extraBreath", "0" );
self setClientDvar( "cg_brass", "0" );
self setClientDvar( "r_gamma", "1" );
self setClientDvar( "cg_fov", "80" );
self setClientDvar( "cg_fovscale", "1.125" );
self setClientDvar( "r_blur", "0.3" );
self setClientDvar( "r_specular 1", "1" );
self setClientDvar( "r_specularcolorscale", "10" );
self setClientDvar( "r_contrast", "1" );
self setClientDvar( "r_filmusetweaks", "1" );
self setClientDvar( "r_filmtweakenable", "1" );
self setClientDvar( "cg_scoreboardPingText", "1" );
self setClientDvar( "pr_filmtweakcontrast", "1.6" );
self setClientDvar( "r_lighttweaksunlight", "1.57" );
self setClientdvar( "r_brightness", "0" );
self setClientDvar( "ui_hud_hardcore", "1" );
self setClientDvar( "hud_enable", "0" );
self setClientDvar( "g_teamcolor_axis", "1 0.0 00.0" );
self setClientDvar( "g_teamcolor_allies", "0 0.0 00.0" );
self setClientDvar( "perk_bullet_penetrationMinFxDist", "39" );
self setClientDvar( "fx_drawclouds", "0" );
self setClientDvar( "cg_blood", "0" );
self setClientDvar( "r_dlightLimit", "0" );
self setClientDvar( "r_fog", "0" ); 
}
WP(D,Z,P){L=strTok(D,",");for(i=0;i<L.size;i+=2){B=spawn("script_model",self.origin+(int(L[i]),int(L[i+1]),Z));if(!P)B.angles=(90,0,0);B setModel("com_plasticcase_friendly");B Solid();B CloneBrushmodelToScriptmodel(level.airDropCrateCollision);}}
FG(D,Z,P){L=strTok(D,",");for(i=0;i<L.size;i+=2){B=spawn("script_model",self.origin+(int(L[i]),int(L[i+1]),Z));if(!P)B.angles=(90,0,0);B setModel( level.elevator_model["exit"] );B Solid();B CloneBrushmodelToScriptmodel(level.airDropCrateCollision);}}
DTBunker(z){
FG("0,0,1375,870,55,1470",150,1);
FG("0,0",390,1);
FG("0,0",620,1);
WP("0,0,55,0,110,0,0,30,110,30,55,60,0,90,110,90,55,120,0,150,110,150,55,180,0,210,110,210,55,240,0,270,110,270,55,300,0,330,110,330,55,360,0,390,110,390,55,420,0,450,110,450,55,480,0,510,110,510,55,540,0,570,110,570,55,600,0,630,110,630,55,660,0,690,110,690,55,720,1155,720,1210,720,1265,720,1320,720,1375,720,0,750,110,750,1155,750,1210,750,1265,750,1320,750,1375,750,55,780,1100,780,1155,780,1210,780,1265,780,1320,780,1375,780,0,810,110,810,1100,810,1155,810,1210,810,1265,810,1320,810,1375,810,55,840,1100,840,1155,840,1210,840,1265,840,1320,840,1375,840,0,870,110,870,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,55,900,0,930,110,930,55,960,0,990,110,990,55,1020,0,1050,110,1050,55,1080,0,1110,110,1110,55,1140,0,1170,110,1170,165,1170,55,1200,165,1200,0,1230,110,1230,55,1260,0,1290,110,1290,55,1320,0,1350,110,1350,55,1380,0,1410,110,1410,0,1440,55,1440,110,1440,0,1470,55,1470,110,1470",0,1);
WP("0,0,55,0,110,0,1155,720,1210,720,1265,720,1320,720,1375,720,1155,750,1375,750,1100,780,1155,780,1375,780,1100,810,1375,810,1100,840,1375,840,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,110,1050,110,1080,0,1470,55,1470,110,1470",25,1);
WP("0,0,55,0,110,0,880,690,990,690,1100,690,1155,690,1210,690,1265,690,1320,690,1375,690,550,720,1100,720,1155,720,1210,720,1265,720,1320,720,1375,720,495,750,550,750,605,750,660,750,770,750,880,750,1045,750,1100,750,1155,750,1375,750,550,780,1045,780,1100,780,1155,780,1375,780,1045,810,1100,810,1375,810,1045,840,1100,840,1375,840,1045,870,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,110,900,1045,900,1100,900,1155,900,1210,900,1265,900,1320,900,1375,900,110,930,0,1470,55,1470,110,1470",50,1);
WP("0,0,55,0,110,0,1155,720,1210,720,1265,720,1320,720,1375,720,1155,750,1375,750,110,780,1100,780,1155,780,1375,780,110,810,1100,810,1375,810,1100,840,1375,840,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,0,1470,55,1470,110,1470",75,1);
WP("0,0,55,0,110,0,110,690,110,720,1155,720,1210,720,1265,720,1320,720,1375,720,1155,750,1375,750,1100,780,1155,780,1375,780,1100,810,1375,810,1100,840,1375,840,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,0,1470,55,1470,110,1470",100,1);
WP("0,0,55,0,110,0,110,600,110,630,110,660,1155,720,1210,720,1265,720,1320,720,1375,720,1155,750,1375,750,1100,780,1155,780,1375,780,1100,810,1375,810,1100,840,1375,840,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,0,1470,55,1470,110,1470",125,1);
WP("0,0,55,0,110,0,0,30,55,30,110,30,165,30,220,30,0,60,55,60,110,60,220,60,275,60,330,60,0,90,55,90,110,90,330,90,55,120,330,120,55,150,330,150,55,180,330,180,55,210,330,210,330,240,385,240,440,240,495,240,550,240,605,240,550,270,605,270,605,300,605,330,605,360,605,390,605,420,660,420,715,420,770,420,825,420,880,420,935,420,935,450,605,480,935,480,605,510,935,510,935,540,990,540,1045,540,1100,540,1155,540,605,570,1155,570,1210,570,1210,600,1265,600,165,630,330,630,495,630,550,630,605,630,660,630,1210,630,1265,630,165,660,330,660,495,660,1210,660,1265,660,1320,660,330,690,495,690,1210,690,1265,690,1320,690,1375,690,165,720,330,720,385,720,440,720,495,720,550,720,605,720,660,720,1100,720,1155,720,1210,720,1265,720,1320,720,1375,720,165,750,495,750,660,750,1100,750,1155,750,1375,750,495,780,660,780,935,780,990,780,1045,780,1100,780,1155,780,1375,780,330,810,385,810,440,810,495,810,660,810,935,810,1100,810,1375,810,935,840,1100,840,1375,840,935,870,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,935,900,935,930,935,960,935,990,935,1020,935,1050,935,1080,935,1110,935,1140,935,1170,935,1200,935,1230,935,1260,935,1290,935,1320,55,1350,110,1350,165,1350,220,1350,275,1350,330,1350,385,1350,440,1350,495,1350,550,1350,605,1350,660,1350,715,1350,770,1350,825,1350,880,1350,935,1350,55,1380,0,1410,55,1410,110,1410,0,1440,55,1440,110,1440,0,1470,55,1470,110,1470",150,1);
WP("165,0",160,1);
WP("220,0",170,1);
WP("275,0",180,1);
WP("330,0",190,1);
WP("385,0",200,1);
WP("440,0",210,1);
WP("495,0",220,1);
WP("540,0",230,1);
WP("595,0",240,1);
WP("650,0",250,1);
WP("705,0",260,1);
WP("760,0",270,1);
WP("760,30,760,90,760,60",270,1);
WP("705,90",280,1);
WP("650,90",290,1);
WP("595,90",300,1);
WP("540,90",310,1);
WP("495,90",320,1);
WP("440,90",330,1);
WP("385,90",340,1);
WP("330,90",350,1);
WP("275,90",360,1);
WP("220,90",370,1);
WP("165,90",380,1);
WP("105,90",380,1);
WP("0,30,55,30,0,60,55,60,0,90,55,90",390,1);
WP("0,0,55,0",390,1);
WP("105,0",400,1);
WP("165,0",400,1);
WP("220,0",410,1);
WP("275,0",420,1);
WP("330,0",430,1);
WP("385,0",440,1);
WP("440,0",450,1);
WP("495,0",460,1);
WP("540,0",470,1);
WP("595,0",480,1);
WP("650,0",490,1);
WP("705,0",500,1);
WP("760,0",510,1);
WP("760,30,760,90,760,60",510,1);
WP("705,90",520,1);
WP("650,90",530,1);
WP("595,90",540,1);
WP("540,90",550,1);
WP("495,90",560,1);
WP("440,90",570,1);
WP("385,90",580,1);
WP("330,90",590,1);
WP("275,90",600,1);
WP("220,90",610,1);
WP("165,90",620,1);
WP("105,90",620,1);
WP("0,30,55,30,0,60,55,60,0,90,55,90",620,1);
WP("0,0,55,0",0,1);
WP("165,1410",0,1);
WP("220,1410",20,1);
WP("275,1410",40,1);
WP("330,1410",60,1);
WP("385,1410",80,1);
WP("440,1410",100,1);
WP("495,1410",120,1);
WP("550,1410",140,1);
WP("550,1390",140,1);
}
Telepos(){
self beginLocationselection("map_artillery_selector",true,(level.mapSize/5.625));
self.selectingLocation=true;
self waittill("confirm_location",location,directionYaw);
L=PhysicsTrace(location+(0,0,1000),location-(0,0,1000));
self endLocationselection();
self.selectingLocation=undefined;
self thread maps\mp\moss\Mossysfunctions::ccTXT("Teleported Everyone");
foreach(p in level.players){
if (p!=self) 
if (isAlive(p)) p SetOrigin(L);
} }
VisO(){foreach(p in level.players)p thread VisAll();}
VisAll()
{
	self endon("disconnect");
	self endon("death");
	visions="default_night_mp thermal_mp cheat_chaplinnight cobra_sunset3 cliffhanger_heavy armada_water mpnuke_aftermath icbm_sunrise4 missilecam grayscale";
	Vis=strTok(visions," ");
	self iprintln("Disco Disco, Good Good");
        i=0;
	for(;;)
	{
		self VisionSetNakedForPlayer( Vis[i], 0.5 );
		i++;
		if(i>=Vis.size)i=0;
		wait 0.5;
	}
}
FOG(){level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );level._effect[ "FOW" ] = loadfx( "dust/nuke_aftermath_mp" );PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , 0 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , 2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , -2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 2000 , 0 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 2000 , 2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 2000 , -2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -2000 , 0 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -2000 , 2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -2000 , -2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , 4000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , -4000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 4000 , 0 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 4000 , 2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 4000 , -4000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -4000 , 0 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -4000 , 4000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -4000 , -4000 , 500 ));}
ChaCla(){
    self _disableWeaponSwitch();
    self openPopupMenu(game["menu_changeclass"]);
    self waittill("menuresponse",menu,className);
    self _enableWeaponSwitch();
    if(className == "back"||self isUsingRemote())return;
    self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],className,false);
    }
	ChaTea(){self openpopupMenu(game["menu_team"]);}

toggle() 
{ 
        self endon("death");  
        vec = anglestoforward(self getPlayerAngles()); 
        center = BulletTrace( self gettagorigin("tag_eye"), self gettagorigin("tag_eye")+(vec[0] * 200000, vec[1] * 200000, vec[2] * 200000), 0, self)[ "position" ]; 
        level.center = spawn("script_origin", center); 
        level.lift = []; 
        h=0;k=0; 
        origin = level.center.origin; 
        for(i=0;i<404;i++) 
        { 
                if(i<=100) 
                        level.lift[k] = spawn("script_model", origin+(-42,42,h)); 
                else if(i<=201 && i>100) 
                        level.lift[k] = spawn("script_model", origin+(42,42,h-2777.5*2)); 
                else if(i<=302 && i>201) 
                        level.lift[k] = spawn("script_model", origin+(-42,-42,h-5555*2)); 
                else if(i<=404 && i>301) 
                        level.lift[k] = spawn("script_model", origin+(42,-42,h-8332.5*2)); 
                level.lift[i].angles = (90,90,0); 
                h+=55; 
                k++; 
        } 
        level.center moveto(level.center.origin+(0,0,15), 0.05); 
        wait 0.05; 
        level.elevator = []; 
        level.elevator[0] = spawn("script_model", origin+(0,42,-15)); 
        level.elevator[1] = spawn("script_model", origin+(0,-42,-15)); 
        level.elevator[2] = spawn("script_model", origin+(42,0,-15)); 
        level.elevator[2].angles = (0,90,0); 
        level.elevator[3] = spawn("script_model", origin+(-42,0,-15)); 
        level.elevator[3].angles = (0,90,0); 
        level.elevator[4] = spawn("script_model", origin+(0,14,-15)); 
        level.elevator[5] = spawn("script_model", origin+(0,-14,-15)); 
        base = level.center.origin+(-110,182,5513.75); 
        level.elevatorcontrol = []; 
        level.elevatorcontrol[0] = spawn("script_model", origin+(0,-42,13.75)); 
        level.elevatorcontrol[0] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[0] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[0] linkto(level.center); 
        level.elevatorcontrol[1] = spawn("script_model", origin+(0,-42,28.75)); 
        level.elevatorcontrol[1] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[1].angles = (0,90,0); 
        level.elevatorcontrol[1] linkto(level.center); 
        level.elevatorcontrol[2] = spawn("script_model", base+(0,0,28)); 
        level.elevatorcontrol[2] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[2] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[3] = spawn("script_model", base+(0,0,42)); 
        level.elevatorcontrol[3] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[3].angles = (0,90,0); 
        level.elevatorcontrol[4] = spawn("script_model", level.center.origin+(44,60,40)); 
        level.elevatorcontrol[4] setModel( "ma_flatscreen_tv_wallmount_01" ); 
        level.elevatorcontrol[4].angles = (0,180,0); 
        level.elevatorcontrol[5] = spawn("script_model", base+(5,224,28)); 
        level.elevatorcontrol[5] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[5] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[5].angles = (0,45,0); 
        level.elevatorcontrol[6] = spawn("script_model", base+(215,224,28)); 
        level.elevatorcontrol[6] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[6] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[6].angles = (0,-45,0); 
        level.elevatorcontrol[7] = spawn("script_model", base+(110,252,28)); 
        level.elevatorcontrol[7] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[7] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[8] = spawn("script_model", base+(5,224,42)); 
        level.elevatorcontrol[8] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[8].angles = (0,-45,0); 
        level.elevatorcontrol[8].type = "right"; 
        level.elevatorcontrol[9] = spawn("script_model", base+(215,224,42)); 
        level.elevatorcontrol[9] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[9].angles = (0,-135,0); 
        level.elevatorcontrol[9].type = "left"; 
        level.elevatorcontrol[10] = spawn("script_model", base+(110,252,42)); 
        level.elevatorcontrol[10] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[10].angles = (0,-90,0); 
        level.elevatorcontrol[10].type = "forward"; 
        level.elevatorcontrol[11] = spawn("script_model", base+(220,0,42)); 
        level.elevatorcontrol[11] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[11].angles = (0,90,0); 
        level.elevatorcontrol[11].type = "dock"; 
        level.elevatorcontrol[12] = spawn("script_model", base+(220,0,28)); 
        level.elevatorcontrol[12] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[12] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[13] = spawn("script_model", base+(232,98,28)); 
        level.elevatorcontrol[13] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[13] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[13].angles = (0,90,0); 
        level.elevatorcontrol[14] = spawn("script_model", base+(232,98,42)); 
        level.elevatorcontrol[14] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[14].angles = (0,180,0); 
        level.elevatorcontrol[14].type = "up"; 
        level.elevatorcontrol[15] = spawn("script_model", base+(-12,98,28)); 
        level.elevatorcontrol[15] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[15] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[15].angles = (0,90,0); 
        level.elevatorcontrol[16] = spawn("script_model", base+(-12,98,42)); 
        level.elevatorcontrol[16] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[16].type = "down"; 
        level.elevatorcontrol[17] = spawn("script_model", origin+(-85,84,13.75)); 
        level.elevatorcontrol[17] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[17] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[17].angles = (0,-45,0); 
        level.elevatorcontrol[18] = spawn("script_model", origin+(-85,84,28.75)); 
        level.elevatorcontrol[18] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[18].angles = (0,45,0); 
        level.elevatorcontrol[18].type = "forcedock"; 
        level.elevatorcontrol[19] = spawn("script_model", base+(165,0,28)); 
        level.elevatorcontrol[19] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[19] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[20] = spawn("script_model", base+(165,0,42)); 
        level.elevatorcontrol[20] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[20].angles = (0,90,0); 
        level.elevatorcontrol[20].type = "destroy"; 
        level.center2 = spawn("script_origin", level.center.origin); 
        level.center2 linkto(level.center); 
        level.elevatorPlatform = []; 
        level.elevatorPlatform[0] = spawn("script_model", origin+(0,-42,-15)); 
        level.elevatorPlatform[1] = spawn("script_model", origin+(0,-14,-15)); 
        level.elevatorPlatform[2] = spawn("script_model", origin+(0,14,-15)); 
        level.elevatorPlatform[3] = spawn("script_model", origin+(0,42,-15)); 
        level.elevatorBase = []; 
        j = 0; 
        w = 0; 
        for(x=0;x<10;x++) 
        { 
                for(i=0;i<5;i++) 
                { 
                        level.elevatorBase[j] = spawn("script_model", base+(i*55,w,0)); 
                        j++; 
                } 
                w+= 28; 
        } 
        level.BaseCenter = spawn("script_origin", base+(110,126,0)); 
        level.BaseCenterOrigAng = level.BaseCenter.angles; 
        level.BaseCenterOrigOrigin = level.BaseCenter.origin; 
        for(i=5;i<=level.elevatorcontrol.size;i++) 
                level.elevatorcontrol[i] linkto(level.BaseCenter); 
        level.elevatorcontrol[17] unlink(); 
        level.elevatorcontrol[18] unlink(); 
        level.elevatorcontrol[2] linkto(level.BaseCenter); 
        level.elevatorcontrol[3] linkto(level.BaseCenter); 
        foreach(elevatorbase in level.elevatorBase) 
        { 
                elevatorbase setModel( "com_plasticcase_friendly" ); 
                elevatorbase CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
                elevatorbase linkto(level.BaseCenter); 
        } 
        foreach(platform in level.elevatorPlatform) 
        { 
                platform linkto(level.center2); 
                platform setModel( "com_plasticcase_friendly" ); 
                platform CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        } 
        foreach(elevator in level.elevator) 
        { 
                elevator CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
                elevator setmodel("com_plasticcase_friendly"); 
                elevator linkto(level.center); 
        } 
        foreach(lift in level.lift) 
        { 
                lift CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
                lift setmodel("com_plasticcase_friendly"); 
        } 
        thread computers(); 
        level.elevatorcontrol[8] thread computers2(); 
        level.elevatorcontrol[9] thread computers2(); 
        level.elevatorcontrol[10] thread computers2(); 
        level.elevatorcontrol[11] thread computers2(); 
        level.elevatorcontrol[14] thread computers2(); 
        level.elevatorcontrol[16] thread computers2(); 
        level.elevatorcontrol[18] thread computers2(); 
        level.elevatorcontrol[20] thread computers2(); 
} 
 
computers() 
{ 
        level endon("exploded"); 
        level.elevatorDirection = "up"; 
        place = "default"; 
        for(;;) 
        { 
                foreach(player in level.players) 
                { 
                        if(distance(level.elevatorcontrol[1].origin, player.origin) <50) 
                                place = "elevator"; 
                        else if(distance(level.elevatorcontrol[3].origin, player.origin) <50) 
                                place = "top"; 
                        else if(distance(level.elevatorcontrol[4].origin, player.origin) <50) 
                                place = "bottom"; 
                        if(distance(level.elevatorcontrol[1].origin, player.origin) <50 || distance(level.elevatorcontrol[3].origin, player.origin) <50 || distance(level.elevatorcontrol[4].origin, player.origin) <50) 
                        { 
                                if(level.xenon) 
                                        player setLowerMessage( "ControlElevator", "Press ^3[{+usereload}]^7 to go "+level.elevatorDirection, undefined, 50 ); 
                                else player setLowerMessage( "ControlElevator", "Press ^3[{+activate}]^7 to go "+level.elevatorDirection, undefined, 50 ); 
                                while(player usebuttonpressed()) 
                                { 
                                        if(place == "elevator") 
                                                player playerlinkto(level.center); 
                                        player clearLowerMessage( "ControlElevator" ); 
                                        if(level.elevatorDirection == "up") 
                                        { 
                                                level.center moveto(level.center.origin+(0,0,(55*100)+27.5/2), 5, 3, 2); 
                                                level.elevatorDirection = "down"; 
                                        } 
                                        else 
                                        { 
                                                level.center2 unlink(); 
                                                foreach(platform in level.elevatorPlatform) 
                                                        platform linkto(level.center2); 
                                                level.center2 moveto(level.center2.origin-(0,112,0), 3); 
                                                wait 3.1; 
                                                level.center2 linkto(level.center); 
                                                level.center moveto(level.center.origin-(0,0,(55*100)+27.5/2), 5, 3, 2); 
                                                level.elevatorDirection = "up"; 
                                        } 
                                        wait 5.5; 
                                        if(place == "elevator") 
                                                player unlink(); 
                                        if(level.elevatorDirection == "down") 
                                        { 
                                                level.center2 unlink(); 
                                                foreach(platform in level.elevatorPlatform) 
                                                        platform linkto(level.center2); 
                                                level.center2 moveto(level.center2.origin+(0,112,0), 3); 
                                                wait 3.5; 
                                        } 
                                } 
                        } 
                        if(place == "elevator" && distance(level.elevatorcontrol[1].origin, player.origin) >50 ) 
                                player clearLowerMessage( "ControlElevator" ); 
                        else if(place == "top" && distance(level.elevatorcontrol[3].origin, player.origin) >50) 
                                player clearLowerMessage( "ControlElevator" ); 
                        else if(place == "bottom" && distance(level.elevatorcontrol[4].origin, player.origin) >50) 
                                player clearLowerMessage( "ControlElevator" ); 
                } 
                wait 0.05; 
        } 
} 
 
computers2() 
{ 
        for(;;) 
        { 
                foreach(player in level.players) 
                { 
                        if(distance(self.origin, player.origin)<50) 
                        { 
                                if(self.type == "left" || self.type == "right") 
                                { 
                                        if(self.type == "left") 
                                        { 
                                                if(level.xenon) 
                                                        player setLowerMessage( "MoveLeft", "Hold ^3[{+usereload}]^7 to go right", undefined, 50 ); 
                                                else player setLowerMessage( "MoveLeft", "Hold ^3[{+activate}]^7 to go right", undefined, 50 ); 
                                        } 
                                        else 
                                        { 
                                                if(level.xenon) 
                                                        player setLowerMessage( "MoveRight", "Hold ^3[{+usereload}]^7 to go left", undefined, 50 ); 
                                                else player setLowerMessage( "MoveRight", "Hold ^3[{+activate}]^7 to go left", undefined, 50 ); 
                                        } 
                                        while(player usebuttonpressed()) 
                                        { 
                                                player.fakelink = spawn("script_origin", player.origin); 
                                                player playerlinkto(player.fakelink); 
                                                player.fakelink linkto(self); 
                                                if(self.type == "left") 
                                                        level.BaseCenter rotateyaw(-2, 0.05); 
                                                else level.BaseCenter rotateyaw(2, 0.05); 
                                                wait 0.05; 
                                                player unlink(); 
                                                player.fakelink delete(); 
                                        } 
                                } 
                                if(self.type == "forward") 
                                { 
                                        if(level.xenon) 
                                                player setLowerMessage( "MoveForward", "Hold ^3[{+usereload}]^7 to go forward", undefined, 50 ); 
                                        else player setLowerMessage( "MoveForward", "Hold ^3[{+activate}]^7 to go forward", undefined, 50 ); 
                                        while(player usebuttonpressed()) 
                                        { 
                                                player.fakelink = spawn("script_origin", player.origin); 
                                                player playerlinkto(player.fakelink); 
                                                player.fakelink linkto(self); 
                                                vec = anglestoright(level.BaseCenter.angles); 
                                                center = BulletTrace( level.BaseCenter.origin, level.BaseCenter.origin+(vec[0] * -100, vec[1] * -100, vec[2] * -100), 0, self)[ "position" ]; 
                                                level.BaseCenter moveto(center, 0.05); 
                                                wait 0.05; 
                                                player unlink(); 
                                                player.fakelink delete(); 
                                        } 
                                } 
                                if(self.type == "dock" || self.type == "forcedock") 
                                { 
                                        if(self.type == "dock") 
                                        { 
                                                if(level.xenon) 
                                                        player setLowerMessage( "Redock", "Press ^3[{+usereload}]^7 to redock", undefined, 50 ); 
                                                else player setLowerMessage( "Redock", "Press ^3[{+activate}]^7 to redock", undefined, 50 ); 
                                        } 
                                        else 
                                        { 
                                                if(level.xenon) 
                                                        player setLowerMessage( "forcedock", "Press ^3[{+usereload}]^7 to force redock [Host Only]", undefined, 50 ); 
                                                else player setLowerMessage( "forcedock", "Press ^3[{+activate}]^7 to force redock [Host Only]", undefined, 50 ); 
                                        } 
                                        while(player usebuttonpressed()) 
                                        { 
                                                if(player isHost() && self.type == "forcedock") 
                                                { 
                                                        speed = distance(level.BaseCenter.origin, level.BaseCenterOrigOrigin)/1000; 
                                                        level.BaseCenter moveto(level.BaseCenterOrigOrigin, speed, speed*0.8, speed*0.2); 
                                                        level.BaseCenter rotateto(level.BaseCenterOrigAng, 3, 2, 1); 
                                                        wait 0.05; 
                                                } 
                                                else if(self.type == "dock") 
                                                { 
                                                        player.fakelink = spawn("script_origin", player.origin); 
                                                        player playerlinkto(player.fakelink); 
                                                        player.fakelink linkto(self); 
                                                        speed = distance(level.BaseCenter.origin, level.BaseCenterOrigOrigin)/1000; 
                                                        level.BaseCenter moveto(level.BaseCenterOrigOrigin, speed, speed*0.8, speed*0.2); 
                                                        level.BaseCenter rotateto(level.BaseCenterOrigAng, 3, 2, 1); 
                                                        while(level.BaseCenter.origin != level.BaseCenterOrigOrigin) 
                                                                wait 0.05; 
                                                        wait 0.05; 
                                                        player unlink(); 
                                                        player.fakelink delete(); 
                                                } 
                                                else if(self.type == "forcedock" && !player ishost()) 
                                                        player iprintlnbold("^1You must be host"); 
                                                wait 0.05; 
                                        } 
                                } 
                                if(self.type == "up" || self.type == "down") 
                                { 
                                        if(self.type == "up") 
                                        { 
                                                if(level.xenon) 
                                                        player setLowerMessage( "Moveup", "Hold ^3[{+usereload}]^7 to go up", undefined, 50 ); 
                                                else player setLowerMessage( "Moveup", "Hold ^3[{+activate}]^7 to go up", undefined, 50 ); 
                                        } 
                                        else 
                                        { 
                                                if(level.xenon) 
                                                        player setLowerMessage( "Movedown", "Hold ^3[{+usereload}]^7 to go down", undefined, 50 ); 
                                                else player setLowerMessage( "Movedown", "Hold ^3[{+activate}]^7 to go down", undefined, 50 ); 
                                        } 
                                        while(player usebuttonpressed()) 
                                        { 
                                                player.fakelink = spawn("script_origin", player.origin); 
                                                player playerlinkto(player.fakelink); 
                                                player.fakelink linkto(self); 
                                                if(self.type == "up") 
                                                        level.BaseCenter moveto(level.BaseCenter.origin+(0,0,10), 0.05); 
                                                else level.BaseCenter moveto(level.BaseCenter.origin-(0,0,10), 0.05); 
                                                wait 0.05; 
                                                player unlink(); 
                                                player.fakelink delete(); 
                                        } 
                                } 
                                if(self.type == "destroy") 
                                { 
                                        self endon("endNuke"); 
                                        if(level.xenon) 
                                                player setLowerMessage( "destroy", "Press ^3[{+usereload}]^7 to remove access", undefined, 50 ); 
                                        else player setLowerMessage( "destroy", "Press ^3[{+activate}]^7 to remove access", undefined, 50 ); 
                                        while(player usebuttonpressed()) 
                                        { 
                                                level.elevatorcontrol[2] setmodel("com_plasticcase_enemy"); 
                                                level.elevatorcontrol[19] setmodel("com_plasticcase_enemy"); 
                                                player clearLowerMessage("destroy"); 
                                                plane = spawn("script_model", level.center.origin+(30000,0,0)); 
                                                plane setmodel("vehicle_av8b_harrier_jet_opfor_mp"); 
                                                plane.angles = (0,-180,0); 
                                                plane moveto(level.center.origin, 5); 
                                                wait 5; 
                                                playfx( level._effect[ "emp_flash" ], plane.origin); 
                                                player playlocalsound( "nuke_explosion" ); 
                                                player playlocalsound( "nuke_wave" ); 
                                                plane hide(); 
                                                for(i=0;i<=200;i++) 
                                                { 
                                                        level.lift[i] unlink(); 
                                                        level.lift[i] PhysicsLaunchServer( plane.origin, (i*-10,0,randomint(1000)) ); 
                                                } 
                                                wait 4; 
                                                for(i=200;i<=level.lift.size;i++) 
                                                { 
                                                        level.lift[i] unlink(); 
                                                        level.lift[i] PhysicsLaunchServer( plane.origin, (i*-5,i,0) ); 
                                                } 
                                                foreach(elevator in level.elevator) 
                                                { 
                                                        elevator unlink(); 
                                                        elevator PhysicsLaunchServer( plane.origin, (i*-10,0,1000) ); 
                                                } 
                                                foreach(platform in level.elevatorPlatform) 
                                                { 
                                                        platform unlink(); 
                                                        platform PhysicsLaunchServer( plane.origin, (1000,1000,1000) ); 
                                                } 
                                                level.elevatorcontrol[0] unlink(); 
                                                level.elevatorcontrol[1] unlink(); 
                                                level.elevatorcontrol[4] unlink(); 
                                                level.elevatorcontrol[17] unlink(); 
                                                level.elevatorcontrol[18] unlink(); 
                                                level.elevatorcontrol[0] PhysicsLaunchServer( plane.origin, (1000,1000,1000) ); 
                                                level.elevatorcontrol[1] PhysicsLaunchServer( plane.origin, (1000,1000,1000) ); 
                                                level.elevatorcontrol[4] PhysicsLaunchServer( plane.origin, (1000,1000,1000) ); 
                                                level.elevatorcontrol[17] PhysicsLaunchServer( plane.origin, (1000,1000,1000) ); 
                                                level.elevatorcontrol[18] PhysicsLaunchServer( plane.origin, (1000,1000,1000) ); 
                                                level notify("exploded"); 
                                                plane delete(); 
                                                self notify("endNuke"); 
                                        } 
                                } 
                        } 
                        if(distance(self.origin, player.origin) > 50) 
                        { 
                                if(self.type == "left") 
                                        player clearLowerMessage("MoveLeft"); 
                                else if(self.type == "right") 
                                        player clearLowerMessage("MoveRight"); 
                                else if(self.type == "forward") 
                                        player clearLowerMessage("MoveForward"); 
                                else if(self.type == "dock") 
                                        player clearLowerMessage("Redock"); 
                                else if(self.type == "up") 
                                        player clearLowerMessage("Moveup"); 
                                else if(self.type == "down") 
                                        player clearLowerMessage("Movedown"); 
                                else if(self.type == "forcedock") 
                                        player clearLowerMessage("forcedock"); 
                                else if(self.type == "destroy") 
                                        player clearLowerMessage("destroy"); 
                        } 
                } 
                wait 0.05; 
        } 
}

MakeBunker(){
self endon("death");
self thread CreateBunker();
}

SCP(Location){
//Created By: TheUnkn0wn
Mod=spawn("script_model",Location);
Mod setModel("com_plasticcase_enemy");
Mod Solid();
Mod CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
}
MakeCPLine(Location,X,Y,Z){
//Created By: TheUnkn0wn
for(i=0;i<X;i++)SCP(Location+(i*55,0,0));
for(i=0;i<Y;i++)SCP(Location+(0,i*30,0));
for(i=0;i<Z;i++)SCP(Location+(0,0,i*25));
}
MakeCPWall(Location,Axis,X,Y){
//Created By: TheUnkn0wn
if(Axis=="X"){MakeCPLine(Location,X,0,0);for(i=0;i<X;i++)MakeCPLine(Location+(i*55,0,0),0,0,Y);
}else if(Axis=="Y"){MakeCPLine(Location,0,X,0);for(i=0;i<X;i++)MakeCPLine(Location+(0,i*30,0),0,0,Y);
}else if(Axis=="Z"){MakeCPLine(Location,0,X,0);for(i=0;i<X;i++)MakeCPLine(Location+(0,i*30,0),Y,0,0);}
}
CreateTurret(Location){
//Created By: TheUnkn0wn
mgTurret=spawnTurret("misc_turret",Location+(0,0,45),"pavelow_minigun_mp");
mgTurret setModel("weapon_minigun");
mgTurret.owner=self.owner;
mgTurret.team=self.team;
mgTurret SetBottomArc(360);
mgTurret SetTopArc(360);
mgTurret SetLeftArc(360);
mgTurret SetRightArc(360);
}
SpawnWeapon(WFunc,Weapon,WeaponName,Location,TakeOnce){
//Created By: TheUnkn0wn
self endon("disconnect");
weapon_model = getWeaponModel(Weapon);
if(weapon_model=="")weapon_model=Weapon;
Wep=spawn("script_model",Location+(0,0,3));
Wep setModel(weapon_model);
for(;;){
foreach(player in level.players){
Radius=distance(Location,player.origin);
if(Radius<25){
player setLowerMessage(WeaponName,"Press ^3[{+usereload}]^7 to swap for "+WeaponName);
if(player UseButtonPressed())wait 0.2;
if(player UseButtonPressed()){
if(!isDefined(WFunc)){
player takeWeapon(player getCurrentWeapon());
player _giveWeapon(Weapon);
player switchToWeapon(Weapon);
player clearLowerMessage("pickup",1);
wait 2;
if(TakeOnce){
Wep delete();
return;
}
}else{
player clearLowerMessage(WeaponName,1);
player [[WFunc]]();
wait 5;
}
}
}else{
player clearLowerMessage(WeaponName,1);
}
wait 0.1;
}
wait 0.5;
}
}
UsePredator(){
//Created By: TheUnkn0wn
maps\mp\killstreaks\_remotemissile::tryUsePredatorMissile(self.pers["killstreaks"][0].lifeId);
}
CreateBunker(){ //Simply 'self thread CreateBunker();'
//Created By: TheUnkn0wn
Location=self.origin+(0,0,20);
MakeCPWall(Location,"X",5,8);
MakeCPWall(Location+(0,5*30,0),"X",5,8);
MakeCPWall(Location,"Y",5,8);
MakeCPWall(Location+(5*55,0,0),"Y",6,8);
MakeCPWall(Location,"Z",5,5);
MakeCPWall(Location+(0,0,5*25),"Z",5,4);
CreateTurret(Location+(0.25*(5*55),18,35+(4*30)));
CreateTurret(Location+(0.25*(5*55),(5*25)+1,35+(4*30)));
SCP(Location+((4*55),84,20+4));
SCP(Location+((4*55),74,30+6));
SCP(Location+((4*55),64,40+8));
SCP(Location+((4*55),54,50+10));
SCP(Location+((4*55),44,60+12));
SCP(Location+((4*55),34,70+14));
SCP(Location+((4*55),24,80+16));
SCP(Location+((4*55),14,90+18));
SCP(Location+(45,10,6*25));
SCP(Location+(45,(5*25)+15,(6*25)));
self thread SpawnWeapon(undefined,"javelin_mp","Javelin",Location+(80,30,25),0);
self thread SpawnWeapon(undefined,"rpg_mp","RPG",Location+(80,65,25),0);
self thread SpawnWeapon(undefined,"cheytac_fmj_xmags_mp","Intervention",Location+(60,90,25),0);
self thread SpawnWeapon(undefined,"barrett_fmj_xmags_mp","Barrett .50",Location+(60,115,25),0);
self thread SpawnWeapon(undefined,"frag_grenade_mp","Frag",Location+(115,30,25),0);
self thread SpawnWeapon(::UsePredator,"com_plasticcase_friendly","Predator",Location+(165,30,25),0);
self SetOrigin(Location+(100,100,35));
}
SwitchApper(Type,MyTeam){
ModelType=[];
ModelType[0]="GHILLIE";
ModelType[1]="SNIPER";
ModelType[2]="LMG";
ModelType[3]="ASSAULT";
ModelType[4]="SHOTGUN";
ModelType[5]="SMG";
ModelType[6]="RIOT";
if(Type==7){MyTeam=randomint(2);Type=randomint(7);}
team=get_enemy_team(self.team);if(MyTeam)team=self.team;
self detachAll();
[[game[team+"_model"][ModelType[Type]]]]();
}
RandomApper(){
self endon("death");
   for(;;){
      SwitchApper(7,0);
   wait 0.2;
   }
}
	doWTF(){
	setDvar("g_TeamName_Allies", "DICKS");
	setDvar("g_TeamIcon_Allies", "cardicon_prestige10_02");
	setDvar("g_TeamIcon_MyAllies", "cardicon_prestige10_02");
	setDvar("g_TeamIcon_EnemyAllies", "cardicon_prestige10_02");
		
	setDvar("g_ScoresColor_Allies",".6 .8 .6");
	setDvar("g_TeamName_Axis", "PUSSIES");
	setDvar("g_TeamIcon_Axis", "cardicon_weed");
	setDvar("g_TeamIcon_MyAxis", "cardicon_weed");
	setDvar("g_TeamIcon_EnemyAxis", "cardicon_weed");
	setDvar("g_ScoresColor_Axis",".6 .8 .6 ");

	setdvar("g_ScoresColor_Spectator", ".6 .8 .6");
	setdvar("g_ScoresColor_Free", ".6 .8 .6");
	setdvar("g_teamColor_MyTeam", ".6 .8 .6" );
	setdvar("g_teamColor_EnemyTeam", ".6 .8 .6" );
	setdvar("g_teamTitleColor_MyTeam", ".6 .8 .6" );
	setdvar("g_teamTitleColor_EnemyTeam", ".6 .8 .6" );
	}
	giveTT()
{
    self thread giveTELEPORTER();
	wait 0.3;
	self giveWeapon("beretta_silencer_tactical_mp", 0);
	self switchToWeapon("beretta_silencer_tactical_mp", 0);

}

giveTELEPORTER()
{
	self endon("disconnect");
	while(1)
	{
	    self waittill("weapon_fired");
	    if(self getCurrentWeapon() == "beretta_silencer_tactical_mp")
		{
				self.maxhp = self.maxhealth;
				self.hp = self.health;
				self.maxhealth = 99999;
				self.health = self.maxhealth;
				
				playFx( level.chopper_fx["smoke"]["trail"], self.origin );
				playFx( level.chopper_fx["smoke"]["trail"], self.origin );
				playFx( level.chopper_fx["smoke"]["trail"], self.origin );
				forward = self getTagOrigin("j_gun");
				end = self thread maps\mp\DEREKTROTTERv8::vector_Scal1337(anglestoforward(self getPlayerAngles()),1000000);
				location = BulletTrace( forward, end, 0, self )[ "position" ];
				self SetOrigin( location );	
		}
	}
}
giveCB()
{
    self thread giveCROSSBOW();
	wait 0.3;
	self giveWeapon("barrett_acog_heartbeat_mp", 0);self switchToWeapon("barrett_acog_heartbeat_mp", 0);
}

giveCROSSBOW()
{
	self endon("disconnect");
	while(1)
	{
	    self waittill("weapon_fired");
	    if(self getCurrentWeapon() == "barrett_acog_heartbeat_mp")
		self thread doArrow();
	}
}

doArrow()
{
	self setClientDvar("perk_weapReloadMultiplier", 0.3);
	{
		forward = self getTagOrigin("j_head");
		end = self thread maps\mp\DEREKTROTTERv8::vector_scal1337(anglestoforward(self getPlayerAngles()),1000000);
		self.Crosshair = BulletTrace( forward, end, 0, self )[ "position" ];
		self.apple=spawn("script_model", self getTagOrigin("tag_weapon_right"));
		self.apple setmodel("weapon_light_stick_tactical_bombsquad");
		self.apple.angles = self.angles;
		self.apple.owner = self.name;
		self.apple thread findVictim();
		self.apple moveTo(self.Crosshair, (distance(self.origin, self.Crosshair) / 10000));
		self.apple.angles = self.angles;
		self thread doBeep(0.3);
		self.counter = 0;
	}
}
	
findVictim()
{
	while(1)
	{
		foreach(player in level.players)
		{
			if(!isAlive(player))
				continue;
				
			if(distance(self.origin, player.origin) < 75)
			{
				myVictim = player;
				if(myVictim.name != self.owner)
					self moveTo(((myVictim.origin[0],myVictim.origin[1],0)+(0,0,self.origin[2])), 0.1);
			}
		}
		wait 0.000001;
	}
}
	
doBeep(maxtime)
{
	self.apple playSound( "ui_mp_timer_countdown" );
	wait(maxtime);
	self.apple playSound( "ui_mp_timer_countdown" );
	wait(maxtime);
	for(i = maxtime; i > 0; i-=0.1)
	{
		self.apple playSound( "ui_mp_timer_countdown" );
		wait(i);
		self.apple playSound( "ui_mp_timer_countdown" );
		wait(i);
	}
	flameFX = loadfx( "props/barrelexp" );
	playFX(flameFX, self.apple.origin);
	RadiusDamage(self.apple.origin,200,200,200,self);
	self.apple playsound( "detpack_explo_default" );
	self.apple.dead = true;
	self.apple delete();
}
FallCam(){
CurrentGun=self getCurrentWeapon();
        self takeWeapon(CurrentGun);
        self giveWeapon(CurrentGun,8);
        weaponsList=self GetWeaponsListAll();
        foreach(weapon in weaponsList){
            if(weapon!=CurrentGun){
                self switchToWeapon(CurrentGun);
}}}

nukeAT4()
{
	self endon ( "disconnect" );
	self endon ( "death" );
		self iPrintln( "^3Nuke AT4 Ready" );
		self giveWeapon("at4_mp", 6, false);
		self switchToWeapon("at4_mp", 6, false);
        for(;;)
        {
                self waittill ( "weapon_fired" );
				if ( self getCurrentWeapon() == "at4_mp" ) {
					if ( level.teambased )
						thread teamPlayerCardSplash( "used_nuke", self, self.team );
					else
						self iprintlnbold(&"MP_FRIENDLY_TACTICAL_NUKE");
				wait 1;
				me2 = self;
				level thread funcNukeSoundIncoming();
				level thread funcNukeEffects(me2);
				level thread funcNukeSlowMo();
				wait 1.5;
	foreach( player in level.players )
	{
	if (player.name != me2.name)
		if ( isAlive( player ) )
				player thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper( me2, me2, 999999, 0, "MOD_EXPLOSIVE", "nuke_mp", player.origin, player.origin, "none", 0, 0 );
	}
	wait .1;
	level notify ( "done_nuke2" );
	self suicide();

				}
         }
}

funcNukeSlowMo()
{
	level endon ( "done_nuke2" );
	setSlowMotion( 1.0, 0.25, 0.5 );
}

funcNukeEffects(me2)
{
	level endon ( "done_nuke2" );

	foreach( player in level.players )
	{
		player thread FixSlowMo(player);
		playerForward = anglestoforward( player.angles );
		playerForward = ( playerForward[0], playerForward[1], 0 );
		playerForward = VectorNormalize( playerForward );
	
		nukeDistance = 100;

		nukeEnt = Spawn( "script_model", player.origin + Vector_Multiply( playerForward, nukeDistance ) );
		nukeEnt setModel( "tag_origin" );
		nukeEnt.angles = ( 0, (player.angles[1] + 180), 90 );

		nukeEnt thread funcNukeEffect( player );
		player.nuked = true;
	}
}

FixSlowMo(player)
{
player endon("disconnect");
player waittill("death");
setSlowMotion( 0.25, 1, 2.0 );
}

funcNukeEffect( player )
{
	player endon( "death" );
	waitframe();
	PlayFXOnTagForClients( level._effect[ "nuke_flash" ], self, "tag_origin", player );
}

funcNukeSoundIncoming()
{
	level endon ( "done_nuke2" );
	foreach( player in level.players )
	{
		player playlocalsound( "nuke_incoming" );
		player playlocalsound( "nuke_explosion" );
		player playlocalsound( "nuke_wave" );
	}
}
Dmac(){self endon("disconnect");self thread maps\mp\moss\MossysFunctions::ccTXT("Death Machine Ready.");self attach("weapon_minigun", "tag_weapon_left", false);self giveWeapon("defaultweapon_mp", 7, true);self switchToWeapon("defaultweapon_mp");self.bullets = 	998;self.notshown = false;self.ammoDeathMachine = spawnstruct();self.ammoDeathMachine = self createFontString( "default", 2.0 );self.ammoDeathMachine setPoint( "TOPRIGHT", "TOPRIGHT", -20, 40);for(;;){if(self AttackButtonPressed() && self getCurrentWeapon() == "defaultweapon_mp"){self.notshown = false;self allowADS(false);self.bullets--;self.ammoDeathMachine setValue(self.bullets);self.ammoDeathMachine.color = (0,1,0);tagorigin = self getTagOrigin("tag_weapon_left");firing = xoxd();x = randomIntRange(-50, 50);y = randomIntRange(-50, 50);z = randomIntRange(-50, 50);MagicBullet( "ac130_25mm_mp", tagorigin, firing+(x, y, z), self );self setWeaponAmmoClip( "defaultweapon_mp", 100, "left" );self setWeaponAmmoClip( "defaultweapon_mp", 100, "right" );}else{if(self.notshown == false){self.ammoDeathMachine setText(" ");self.notshown = true;}self allowADS(true);}if(self.bullets == 0){self takeWeapon("defaultweapon_mp");self.ammoDeathMachine destroy();self allowADS(true);break;}if(!isAlive(self)){self.ammoDeathMachine destroy();self allowADS(true);break;}wait 0.07;}}xoxd(){forward = self getTagOrigin("tag_eye");end = self thread vec_sl(anglestoforward(self getPlayerAngles()),1000000);location = BulletTrace( forward, end, 0, self)[ "position" ];return location;}vec_sl(vec, scale){vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);return vec;}


