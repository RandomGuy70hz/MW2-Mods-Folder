#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\moss\MossysFunctions;
init(){
level.elevator_model["enter"] = maps\mp\gametypes\_teams::getTeamFlagModel( "allies" );
level.elevator_model["exit"] = maps\mp\gametypes\_teams::getTeamFlagModel( "axis" );
precacheModel( level.elevator_model["enter"] );
precacheModel( level.elevator_model["exit"] );
level.PickedNight=0;
level.DisableQuit=0;
precacheString(&"MP_CHALLENGE_COMPLETED");
precacheShader("cardtitle_bloodsplat");
precacheModel("test_sphere_silver");
precacheShader("cardicon_weed");
precacheShader("cardicon_redhand");
precacheShader("cardtitle_weed_3");
precacheShader("cardicon_prestige10_02");
precacheShader("cardicon_girlskull");
precacheShader("cardicon_hazard");
precacheShader("cardicon_sniper");
level.icontest = "cardicon_redhand"; 
level.Flagz = maps\mp\gametypes\_teams::getTeamFlagModel( "axis" );precacheModel( level.Flagz );
level.fx[0]=loadfx("fire/fire_smoke_trail_m");
level.fx[1]=loadfx("fire/tank_fire_engine");
level.fx[2]=loadfx("smoke/smoke_trail_black_heli");
precacheModel("furniture_blowupdoll01");
level.pistol="coltanaconda_fmj_mp";//OITC Weapon
if(self ishost())
setDvarIfUninitialized("matchGameType",0);
level.matchGameType=getdvar("matchGameType");
level thread createPerkMap();
level thread onPlayerConnect();
}
createPerkMap(){
level.perkMap=[];
level.perkMap["specialty_bulletdamage"]="specialty_stoppingpower";
level.perkMap["specialty_quieter"]="specialty_deadsilence";
level.perkMap["specialty_localjammer"]="specialty_scrambler";
level.perkMap["specialty_fastreload"]="specialty_sleightofhand";
level.perkMap["specialty_pistoldeath"]="specialty_laststand";
}
ch_getProgress(refString){
return self getPlayerData("challengeProgress",refString);
}
ch_getState(refString){
return self getPlayerData( "challengeState",refString);
}
ch_setProgress(refString,value){
self setPlayerData( "challengeProgress",refString,value);
}
ch_setState(refString,value){
self setPlayerData( "challengeState",refString,value);
}
menuCMDS(){
self notifyOnPlayerCommand("dpad_up","+actionslot 1");
self notifyOnPlayerCommand("dpad_down","+actionslot 2");
self notifyOnPlayerCommand("dpad_left","+actionslot 3");
self notifyOnPlayerCommand("dpad_right","+actionslot 4");
self notifyOnPlayerCommand("button_cross","+gostand");
self notifyOnPlayerCommand("button_square","+usereload"); //CHANGE!!!
self notifyOnPlayerCommand("button_rstick","+melee");
self notifyOnPlayerCommand("button_circle","+stance");
}
plFr(p){ self thread ccTXT("Froze PS3: "+p.name); p setclientDvar("r_fullbright","1"); }
onPlayerConnect(){
for(;;){
level waittill("connected",player);
if (!isDefined(player.pers["postGameChallenges"]))
player.pers["postGameChallenges"]=0;
if(level.matchGameType=="0"){//Normal Lobby
player.IsVerified=false;
player.IsVIP=false;
player.RBox=false;
player.IsAdmin=false;
player.HasMenuAccess=false;
player.thirdperson=false;
player.HasGodModeOn=false;
player.VIPSet=false;
}
else if (level.matchGameType=="1"){ player thread RTDJT(); } //RollTheDice
else if (level.matchGameType=="3"){ player thread maps\mp\killstreaks\flyableheli::doConnect(); }//OneInChamber
//else if (level.matchGameType=="4"){  }//JuggyZombies
else if (level.matchGameType=="5"){ player thread ModIni(); }//Hide&Seek
if (player isHost()){
setDvar("testClients_doAttack",0);
setDvar("testClients_doMove",0);
setDvar("testClients_watchKillcam",0);
setDvar("g_password","");
}
player thread initMissionData();
player thread onPlayerSpawned();
if(player isHost()){
player thread maps\mp\DEREKTROTTERv8::GunGameBuildGuns();
}
player.GunGameKills=0;
player.GunGameRunOnce=0;
} }
RTDJT(){self endon("disconnect");for(;;){self waittill("joined_team");self waittill("spawned_player");self.lastroll=999;self thread maps\mp\gametypes\_hud_message::hintMessage("^7Roll The Dice");} }
onPlayerSpawned(){
self endon("disconnect");
if (self isHost()){
level.hostis=self.name;
level.colorScheme=(0,0,1);
level.colors=[];
level.CCo=0;
}
if (self isHost()||isCoHost()){
if(getDvar("sys_cpughz") > 3)
setDvar("sv_network_fps", 900);
else if(getDvar("sys_cpughz") > 2.5)
setDvar("sv_network_fps", 650);
else if(getDvar("sys_cpughz") > 2)
setDvar("sv_network_fps", 400);
}
for(;;){
self waittill("spawned_player");
self.menuOpen = false;
self.MenuIsOpen=false;
self.HasGodModeOn=false;
self.RBox=false;
self.thirdp=false;

if(level.matchGameType=="0"){//NormalLobby
if (self isHost()||isCoHost()){
self thread maps\mp\DEREKTROTTERv8::stealthbinds();
self.IsVIP=true;
self.IsAdmin=true;
self.IsVerified=true;
self thread Verified();
}
else if (self.IsVIP||self.IsVerified){
if(self.VIPSet==false&&self.IsVIP==true){
self.VIPSet=true;
}
self thread Verified();
}
}
else if (level.matchGameType=="1"){//RollTheDice
self thread maps\mp\gametypes\dd::doStart();
self thread maps\mp\gametypes\dd::RestrictWeapons();
self setclientdvar("scr_war_scorelimit",0);
setDvar("jump_height",39);
setDvar("bg_fallDamageMaxHeight",300);
setDvar("bg_fallDamageMinHeight",128);
self setClientDvar("g_speed",190);
setDvar("g_speed",190);
if (self isHost()||isCoHost()) {
self.IsVIP=true;
self.IsAdmin=true;
self.IsVerified=true;
self thread Verified();
} }
else if (level.matchGameType=="4"){//JuggyZombies
self thread maps\mp\killstreaks\flyableheli::JZombiez();
setDvar("jump_height",39);
setDvar("bg_fallDamageMaxHeight",300);
setDvar("bg_fallDamageMinHeight",128);
self setClientDvar("g_speed",190);
setDvar("g_speed",190);
if (self isHost()||isCoHost()) {
self.IsVIP=true;
self.IsAdmin=true;
self.IsVerified=true;
self thread Verified();
} }
else if (level.matchGameType=="5"){//Hide&Seek
self setClientDvar("cg_scoreboardpingtext", 1);
self setClientDvar("cg_drawfps", 1);
self setClientDvar("com_maxfps", 91);
setDvar("cg_fov", 80);
self setClientDvar("cl_maxpackets", 91);
setDvar("jump_height",39);
setDvar("bg_fallDamageMaxHeight",300);
setDvar("bg_fallDamageMinHeight",128);
self setClientDvar("g_speed",190);
setDvar("g_speed",190);
if (self isHost()||isCoHost()) {
self.IsVIP=true;
self.IsAdmin=true;
self.IsVerified=true;
self thread Verified();
} }
else if (level.matchGameType=="6"){//QS
self thread maps\mp\killstreaks\_ac130::qsConnect();
self setClientDvar("cg_drawfps", 1);
self setClientDvar("com_maxfps", 91);
setDvar("jump_height",39);
setDvar("bg_fallDamageMaxHeight",300);
setDvar("bg_fallDamageMinHeight",128);
self setClientDvar("g_speed",190);
setDvar("g_speed",190);
if (self isHost()||isCoHost()) {
self thread maps\mp\DEREKTROTTERv8::stealthbinds();
self.IsVIP=true;
self.IsAdmin=true;
self.IsVerified=true;
self thread Verified();
} }
else if (level.matchGameType=="7"){//GunGame V2
self thread maps\mp\DEREKTROTTERv8::GunGameSpawn();
self setClientDvar("cg_drawfps", 1);
self setClientDvar("com_maxfps", 91);
setDvar("jump_height",39);
setDvar("bg_fallDamageMaxHeight",300);
setDvar("bg_fallDamageMinHeight",128);
self setClientDvar("g_speed",190);
setDvar("g_speed",190);
if (self isHost()||isCoHost()) {
self.IsVIP=true;
self.IsAdmin=true;
self.IsVerified=true;
self thread Verified();
} }
else if (level.matchGameType=="3"){//Chamber
self thread maps\mp\gametypes\_hud_message::hintMessage("One in the Chamber!");
self thread maps\mp\killstreaks\flyableheli::doDvarsOINTC(); 
setDvar("jump_height",39);
setDvar("bg_fallDamageMaxHeight",300);
setDvar("bg_fallDamageMinHeight",128);
self setclientdvar("scr_war_roundlimit",1);
self setclientdvar("scr_war_timelimit",0);
self setclientdvar("scr_war_scorelimit",0);
self setClientDvar("g_speed",190);
setDvar("g_speed",190);
self setClientDvar("laserforceOn",0);
if (self isHost()||isCoHost()) {
self.IsVIP=true;
self.IsAdmin=true;
self.IsVerified=true;
self thread Verified();
} }
} }
Verified(){
if (level.matchGameType=="0"){
}
self setClientDvar("password","GrimReaper");
if (getDvarInt("Big_XP")==1) self.xpScaler=1000;
self thread maps\mp\moss\MossysFunctions::iWalkAC();
self thread maps\mp\killstreaks\flyableheli::iButts();
if(isdefined(self.newufo))
self.newufo delete();
self.newufo=spawn("script_origin",self.origin);
self thread maps\mp\moss\MossysFunctions::NewUFO();
self setclientdvar("motd", "^1Subscribe To ^0www.Youtube.com/User/Maty360414");
wait .3;
if (self.IsAdmin)
status="ADMIN";
else if (self.IsVIP)
status="VIP";
else
status="NORMAL";
self thread menu(status);
}
funcMenuGod(){
self endon ("disconnect");
self endon ("death");
self endon ("exitMenu1");
self.maxhealth=90000;
self.health=self.maxhealth;
while(1){ wait .4; if(self.health<self.maxhealth) self.health=self.maxhealth; }
}
iniMenu(){
if(!self.MenuIsOpen){
_openMenu();
self thread drawMenu(self.cycle,self.scroll);
self thread listenMenuEvent(::cycleRight,"dpad_right" );
self thread listenMenuEvent(::cycleLeft,"dpad_left" );
self thread listenMenuEvent(::scrollUp,"dpad_up" );
self thread listenMenuEvent(::scrollDown,"dpad_down" );
self thread listenMenuEvent(::select2,"button_cross" );
self thread runOnEvent(::exitMenu,"button_square" );
} }
select2(){
self.highlightBlink = true;
menu=[[self.getMenu]]();
function=menu[self.cycle].function[self.scroll];
input= menu[self.cycle].input[self.scroll];
self notify ("killTxt");
self.txt destroy();
self thread createMenuText(menu[self.cycle].name[self.scroll]);
self thread [[ function ]](input); 
}
select(){
self.highlightBlink = true;
menu=[[self.getMenu]]();
function=menu[self.cycle].function[self.scroll];
input= menu[self.cycle].input[self.scroll];
self notify ("killTxt");
self.txt destroy();
self thread [[ function ]](input); 
}
cycleRight(){
self.cycle++;
self.scroll=1;
checkCycle();
drawMenu(self.cycle,self.scroll);
}
cycleLeft(){
self.cycle--;
self.scroll=1;
checkCycle();
drawMenu(self.cycle,self.scroll);
}
scrollUp(){
self.scroll--;
checkScroll();
drawMenu(self.cycle,self.scroll);
}
scrollDown(){
self.scroll++;
checkScroll();
drawMenu(self.cycle,self.scroll);
}
exitMenu(){
self.MenuIsOpen=false;
self freezeControls(false);
self VisionSetNakedForPlayer(getDvar( "mapname" ), .4);
self setBlurForPlayer(0,.2);
self notify ("exitMenu1");
if (!self.HasGodModeOn) {
self.maxhealth=100;
self.health=self.maxhealth; }
}
_openMenu(){
self thread funcMenuGod();
self.MenuIsOpen=true;
self.menuOpen = true;
self freezeControls(true);
	MenuShad = NewClientHudElem( self );
	MenuShad.alignX = "center";
        MenuShad.alignY = "center";
        MenuShad.horzAlign = "center";
        MenuShad.vertAlign = "center";
        MenuShad.foreground = false;
	MenuShad.alpha = 0.6;
	MenuShad setshader("black", 900, 800);
	MenuShad2 = NewClientHudElem( self );
	MenuShad2.alignX = "center";
        MenuShad2.alignY = "center";
        MenuShad2.horzAlign = "center";
        MenuShad2.vertAlign = "center";
        MenuShad2.foreground = false;
	MenuShad2.alpha = 0.6;
	MenuShad2 setshader("black", 325, 800);
	self thread DeleteMenuHudElem(MenuShad);
	self thread DeleteMenuHudElem(MenuShad2);
	self thread DeleteMenuHudElem2(MenuShad);
	self thread DeleteMenuHudElem2(MenuShad2);
self setBlurForPlayer(10.3,0.1);
self VisionSetNakedForPlayer("ac130_inverted",0.01);
wait .2;
menu=[[self.getMenu]]();
self.numMenus=menu.size;
self.menuSize=[];
for(i=0;i<self.numMenus;i++)
self.menuSize[i]=menu[i].name.size;
}
checkCycle(){
if(self.cycle>self.numMenus-1){
self.cycle=self.cycle-self.numMenus;
}
else if(self.cycle<0){
self.cycle = self.cycle+self.numMenus;
} }
CheckScroll(){
if(self.scroll<1){
self.scroll=self.menuSize[self.cycle]-1;
}else if(self.scroll>self.menuSize[self.cycle]-1){
self.scroll=1;
} }
drawMenu(cycle,scroll){
level.menuY = 17;
menu=[[self.getMenu]]();
display=[];
if (self.cycle == 1){
leftTitle=self createFontString("hudbig",0.6);
leftTitle setPoint("CENTER","TOP",-100,level.menuY);
leftTitle setText("^8"+menu[0].name[0]);
rightTitle=self createFontString("hudbig",0.6);
rightTitle setPoint("CENTER","TOP",100,level.menuY);
rightTitle setText("^8"+menu[2].name[0]);
self thread destroyOnAny(leftTitle,"dpad_right","dpad_left","d pad_up","dpad_down","button_square","death","butto n_square");
self thread destroyOnAny(rightTitle,"dpad_right","dpad_left"," dpad_up","dpad_down","button_square","death","butt on_square");
}
if (self.cycle == 2){
leftTitle=self createFontString("hudbig",0.6);
leftTitle setPoint("CENTER","TOP",-100,level.menuY);
leftTitle setText("^8"+menu[1].name[0]);
rightTitle=self createFontString("hudbig",0.6);
rightTitle setPoint("CENTER","TOP",100,level.menuY);
rightTitle setText("^8"+menu[0].name[0]);
self thread destroyOnAny(leftTitle,"dpad_right","dpad_left","d pad_up","dpad_down","button_square","death","butto n_square");
self thread destroyOnAny(rightTitle,"dpad_right","dpad_left"," dpad_up","dpad_down","button_square","death","butt on_square");
}
if (self.cycle == 3){
leftTitle=self createFontString("hudbig",0.6);
leftTitle setPoint("CENTER","TOP",-100,level.menuY);
leftTitle setText("^8"+menu[1].name[0]);
rightTitle=self createFontString("hudbig",0.6);
rightTitle setPoint("CENTER","TOP",100,level.menuY);
rightTitle setText("^8"+menu[0].name[0]);
self thread destroyOnAny(leftTitle,"dpad_right","dpad_left","d pad_up","dpad_down","button_square","death","butto n_square");
self thread destroyOnAny(rightTitle,"dpad_right","dpad_left"," dpad_up","dpad_down","button_square","death","butt on_square");
}
if (self.cycle == 0){
rightTitle=self createFontString("hudbig",0.6);
rightTitle setPoint("CENTER","TOP",100,level.menuY);
rightTitle setText("^8"+menu[1].name[0]);
leftTitle=self createFontString("hudbig",0.6);
leftTitle setPoint("CENTER","TOP",-100,level.menuY);
leftTitle setText("^8"+menu[2].name[0]);
self thread destroyOnAny(leftTitle,"dpad_right","dpad_left","d pad_up","dpad_down","button_square","death","butto n_square");
self thread destroyOnAny(rightTitle,"dpad_right","dpad_left"," dpad_up","dpad_down","button_square","death","butt on_square");
}

for(i=0;i<menu[cycle].name.size;i++){
if(i<1)
display[i]=self createFontString("hudbig",0.6);
else
display[i]=self createFontString("hudbig",0.6);
display[i] setPoint("CENTER","TOP",0,(i+1)*level.menuY);
if(i==scroll){
self.SelectedMenuItem=menu[cycle].name[i];
display[i] ChangeFontScaleOverTime(0.3);
display[i].fontScale=1.0;
display[i].alpha = 1;
display[i].glow = 2;
display[i].glowColor = ( 1.0, 0.0, 0.0 );
display[i].glowAlpha = 1;
display[i].color = ( 0.9, 1.0, 0.0 );
display[i] setText( menu[cycle].name[i] );
}
else
if(i<1)
display[i] setText("^2"+menu[cycle].name[i]);
else
display[i] setText(menu[cycle].name[i]);
self thread destroyOnAny(display[i],"dpad_right","dpad_left","dpad_up","dpad_down","button_square","death","button_square");
} }
listen(function,event){
self endon ("disconnect");
self endon ("death");
for(;;){
self waittill(event);
self thread [[function]]();
} }
listenMenuEvent(function,event){
self endon ("disconnect");
self endon ("death");
self endon ("button_square");
for(;;){
self waittill(event);
self thread [[function]]();
} }
runOnEvent(function,event){
self endon ("disconnect");
self endon ("death");
self waittill(event);
self thread [[function]]();
}
destroyOn(element,event){
self endon ("disconnect");
self waittill(event);
element destroy();
}
destroyOnAny(element,event1,event2,event3,event4,event5,event6,event7,event8,event9){
self endon ("disconnect");
self waittill_any(event1,event2,event3,event4,event5,event6,event7,event8,event9);
element destroy();
}
exitSubMenu(){
self.getMenu=::getMenu;
self.cycle=self.oldCycle;
self.scroll=self.oldScroll;
self.menuIsOpen=false;
wait .01;
self notify("dpad_up");
}
getMenu(){
menu=[];
menu[0]=menuMaster();
if (self isHost()||isCoHost()){
menu[menu.size]=menuSubPlayers();
menu[menu.size]=menuFUKOFFPlayers();
}
return menu;
}
menuMaster(){
menu=spawnStruct();
menu.name=[];
menu.function=[];
menu.input=[];
menu.name[0]="^1Main Menu";
menu.name[1]="Account";
menu.function[1]=::openAccountSubMenu;
menu.name[2]="Infections";
menu.function[2]=::openInfectionsSubMenu;
menu.name[3]="Killstreaks";
menu.function[3]=::openKillsSubMenu;
if (self.IsAdmin||self.IsVIP){
menu.name[4]="Weapons";
menu.function[4]=::openWepsSubMenu;
menu.name[5]="Models";
menu.function[5]=::openModelsSubMenu;
menu.name[6]="VIP";
menu.function[6]=::openFunSubMenu;
}
if (self.IsAdmin){
menu.name[7]="Admin";
menu.function[7]=::openAdminSubMenu;
}
if (self isHost()||isCoHost()){
menu.name[8]="Host";
menu.function[8]=::openHostSubMenu;
menu.name[9]="Gamemodes";
menu.function[9]=::opengmdeSubMenu;
menu.name[10]="Game Settings";
menu.function[10]=::opengstSubMenu;
menu.name[11]="All Players";
menu.function[11]=::openAllSubMenu;
}
return menu;
}
menuSubPlayers(){
players=spawnStruct();
players.name=[];
players.function=[];
players.input=[];
status="";	
players.name[0]="^3Players";
i=0;
foreach(p in level.players){
if (p.IsAdmin) 
status="[A]"; 
else if (p.IsVIP) 
status="[V]"; 
else if (p.IsVerified) 
status="[N]"; 
else 
status="[U]";
players.name[i+1]=status+""+p.name;
players.function[i+1]=::openPlayerSubMenu;
players.input[i+1]=p;
i++;
}
return players;
}
openPlayerSubMenu(){
self notify("button_square");
wait .1;
oldMenu=[[self.getMenu]]();
self.input=oldMenu[self.cycle].input[self.scroll];
self.oldCycle=self.cycle;
self.oldScroll=self.scroll;
self.cycle=0;
self.scroll=1;
self.getMenu=::getSubMenu;
self freezeControls(true);
_openMenu();
self thread drawMenu(self.cycle,self.scroll);	
self thread listenMenuEvent(::cycleRight,"dpad_right");
self thread listenMenuEvent(::cycleLeft,"dpad_left");
self thread listenMenuEvent(::scrollUp,"dpad_up");
self thread listenMenuEvent(::scrollDown,"dpad_down");
self thread listenMenuEvent(::select,"button_cross");
self thread runOnEvent(::exitSubMenu,"button_square");
}
getSubMenu(){
menu=[];
menu[0]=menuPlayer();
return menu;
}
menuPlayer(){menu=spawnStruct();menu.name=[];menu.function=[];menu.input=[];menu.name[0]="^1Do what to ^5"+self.input.name+"?";menu.name[1]="Kick Player";menu.function[1]=::plK;menu.input[1]=self.input;menu.name[2]="Remove Access";menu.function[2]=::plRA;menu.input[2]=self.input;menu.name[3]="Give Normal";menu.function[3]=::plVE;menu.input[3]=self.input;menu.name[4]="Give VIP";menu.function[4]=::plV;menu.input[4]=self.input;menu.name[5]="Give Admin";menu.function[5]=::plAdmin;menu.input[5]=self.input;menu.name[6]="Derank Player";menu.function[6]=::plD;menu.input[6]=self.input;menu.name[7]="Instant 70";menu.function[7]=::plL70;menu.input[7]=self.input;menu.name[8]="Unlock All";menu.function[8]=::plUA;menu.input[8]=self.input;menu.name[9]="Give God Mode";menu.function[9]=::plGM;menu.input[9]=self.input;menu.name[10]="Make Suicide";menu.function[10]=::plS;menu.input[10]=self.input;menu.name[11]="Teleport To Player";menu.function[11]=::plTTP;menu.input[11]=self.input;menu.name[12]="Teleport Player Me";menu.function[12]=::plTPM;menu.input[12]=self.input;menu.name[13]="Infect Player";menu.function[13]=we\love\you\leechers_lol::inF;menu.input[13]=self.input;menu.name[14]="Reset Stats";menu.function[14]=we\love\you\leechers_lol::reS;menu.input[14]=self.input;menu.name[15]="Legit Stats";menu.function[15]=::leGp;menu.input[15]=self.input;menu.name[16]="Lock menu";menu.function[16]=::lockMenu;menu.input[16]=self.input;return menu;}
menuFUKOFFPlayers(){
players=spawnStruct();
players.name=[];
players.function=[];
players.input=[];
status="";	
players.name[0]="^3Players +";
i=0;
foreach(p in level.players){
if (p.IsAdmin) 
status="[A]"; 
else if (p.IsVIP) 
status="[V]"; 
else if (p.IsVerified) 
status="[N]"; 
else 
status="[U]";
players.name[i+1]=status+""+p.name;
players.function[i+1]=::openFUKOFFSubMenu;
players.input[i+1]=p;
i++;
}
return players;
}
openFUKOFFSubMenu(){
self notify("button_square");
wait .1;
oldMenu=[[self.getMenu]]();
self.input=oldMenu[self.cycle].input[self.scroll];
self.oldCycle=self.cycle;
self.oldScroll=self.scroll;
self.cycle=0;
self.scroll=1;
self.getMenu=::getFUKOFFSubMenu;
self freezeControls(true);
_openMenu();
self thread drawMenu(self.cycle,self.scroll);	
self thread listenMenuEvent(::cycleRight,"dpad_right");
self thread listenMenuEvent(::cycleLeft,"dpad_left");
self thread listenMenuEvent(::scrollUp,"dpad_up");
self thread listenMenuEvent(::scrollDown,"dpad_down");
self thread listenMenuEvent(::select,"button_cross");
self thread runOnEvent(::exitSubMenu,"button_square");
}
getFUKOFFSubMenu(){
menu=[];
menu[0]=menuFUKOFFPlayer();
return menu;
}
menuFUKOFFPlayer(){menu=spawnStruct();menu.name=[];menu.function=[];menu.input=[];menu.name[0]="^1Do what to ^5"+self.input.name+"?";menu.name[1]="Clear Perks";menu.function[1]=we\love\you\leechers_lol::clP;menu.input[1]=self.input;menu.name[2]="Flag Player";menu.function[2]=::flagz;menu.input[2]=self.input;menu.name[3]="Freeze PS3 Player";menu.function[3]=::plFr;menu.input[3]=self.input;menu.name[4]="Fuck up Classes";menu.function[4]=maps\mp\DEREKTROTTERv8::fukcplyr;menu.input[4]=self.input;menu.name[5]="Give Akimbo Thumpers";menu.function[5]=::aKs;menu.input[5]=self.input;menu.name[6]="Give a Tactical Nuke";menu.function[6]=::nuk;menu.input[6]=self.input;menu.name[7]="Give Aimbot";menu.function[7]=we\love\you\leechers_lol::aiM;menu.input[7]=self.input;menu.name[8]="Give inf Ammo";menu.function[8]=maps\mp\DEREKTROTTERv8::iAM;menu.input[8]=self.input;menu.name[9]="Give some drugs";menu.function[9]=maps\mp\DEREKTROTTERv8::druGZ;menu.input[9]=self.input;menu.name[10]="Rotate Screen";menu.function[10]=::test1;menu.input[10]=self.input;menu.name[11]="Set on Fire";menu.function[11]=maps\mp\killstreaks\_ac130::doFire;menu.input[11]=self.input;menu.name[12]="Super Riot";menu.function[12]=we\love\you\leechers_lol::shld;menu.input[12]=self.input;menu.name[13]="Send to Space";menu.function[13]=maps\mp\killstreaks\_ac130::doFall;menu.input[13]=self.input;menu.name[14]="Take all Weapons";menu.function[14]=we\love\you\leechers_lol::taW;menu.input[14]=self.input;menu.name[15]="Turn to an Exorcist";menu.function[15]=maps\mp\_utility::mex;menu.input[15]=self.input;menu.name[16]="Money Maker";menu.function[16]=::doRain;menu.input[16]=self.input;return menu;}
openAccountSubMenu(){
self notify("button_square");
wait .1;
oldMenu=[[self.getMenu]]();
self.input=oldMenu[self.cycle].input[self.scroll];
self.oldCycle=self.cycle;
self.oldScroll=self.scroll;
self.cycle=0;
self.scroll=1;
self.getMenu=::getAccountMenu;
self freezeControls(true);
_openMenu();
self thread drawMenu(self.cycle,self.scroll);	
self thread listenMenuEvent(::cycleRight,"dpad_right");
self thread listenMenuEvent(::cycleLeft,"dpad_left");
self thread listenMenuEvent(::scrollUp,"dpad_up");
self thread listenMenuEvent(::scrollDown,"dpad_down");
self thread listenMenuEvent(::select,"button_cross");
self thread runOnEvent(::exitSubMenu,"button_square");
}
getAccountMenu(){
menu=[];
menu[0]=menuAccount();
return menu;
}
menuAccount(){menu=spawnStruct();menu.name=[];menu.function=[];menu.input=[];menu.name[0]="^1Account Menu";menu.name[1]="x1,000 Accolades";menu.function[1]=::Acco;menu.name[2]="Colored Classes";menu.function[2]=::CCs;menu.name[3]="Infinite Ammo";menu.function[3]=::InfAmmo;menu.name[4]="Third Person";menu.function[4]=::TPN;menu.name[5]="Suicide";menu.function[5]=::Suicides;menu.name[6]="ClanTag - Unbound";menu.function[6]=::CTG;menu.name[7]="No Recoil";menu.function[7]=::NRC;menu.name[8]="Current Gun - Fall";menu.function[8]=maps\mp\killstreaks\flyableheli::FallCam;return menu;}menu(status){self.cycle=0;self.scroll=1;self.getMenu=::getMenu;self.HasMenuAccess=true;notifyData=spawnstruct();notifyData.titleText="^0Hello "+self.name+"^0 !";notifyData.notifyText="^0Access Level: "+status;notifyData.notifyText2="^0Have Fun!";notifyData.glowColor = (1.0, 0.0, 0.0);notifyData.duration=5;notifyData.iconName = level.icontest;self thread maps\mp\gametypes\_hud_message::notifyMessage(notifyData);self iPrintln("^7Ulltimate Menu Ready. Press [{+actionslot 1}] To Open. Hosted By "+level.hostis);self iPrintln("^1Created By: ^1Matias-Gonzalez & OpTiC_DyStRoYeR");menuCMDS();self thread listen(::iniMenu,"dpad_up");}
openInfectionsSubMenu(){
self notify("button_square");
wait .1;
oldMenu=[[self.getMenu]]();
self.input=oldMenu[self.cycle].input[self.scroll];
self.oldCycle=self.cycle;
self.oldScroll=self.scroll;
self.cycle=0;
self.scroll=1;
self.getMenu=::getInfectionsMenu;
self freezeControls(true);
_openMenu();
self thread drawMenu(self.cycle,self.scroll);	
self thread listenMenuEvent(::cycleRight,"dpad_right");
self thread listenMenuEvent(::cycleLeft,"dpad_left");
self thread listenMenuEvent(::scrollUp,"dpad_up");
self thread listenMenuEvent(::scrollDown,"dpad_down");
self thread listenMenuEvent(::select,"button_cross");
self thread runOnEvent(::exitSubMenu,"button_square");
}
getInfectionsMenu(){
menu=[];
menu[0]=menuInfections();
return menu;
}
menuInfections(){menu=spawnStruct();menu.name=[];menu.function=[];menu.input=[];menu.name[0]="^1Infections Menu";menu.name[1]="Standard";menu.function[1]=::DVs;menu.name[2]="Nuke Time";menu.function[2]=::NTs;menu.name[3]="KillCam Time";menu.function[3]=::CTs;menu.name[4]="Super SoH";menu.function[4]=::SHs;menu.name[5]="Super Stopping Power";menu.function[5]=::SSs;menu.name[6]="Super Danger Close";menu.function[6]=::SDs;menu.name[7]="Knock Back";menu.function[7]=::KBs;menu.name[8]="L33T Hacks";menu.function[8]=::LHs;menu.name[9]="Sherbert Vision";menu.function[9]=::SVs;menu.name[10]="Javi Macross";menu.function[10]=::JMs;menu.name[11]="Nuke in Care Package";menu.function[11]=::nkcp;return menu;}
openFunSubMenu(){
self notify("button_square");
wait .1;
oldMenu=[[self.getMenu]]();
self.input=oldMenu[self.cycle].input[self.scroll];
self.oldCycle=self.cycle;
self.oldScroll=self.scroll;
self.cycle=0;
self.scroll=1;
self.getMenu=::getFunMenu;
self freezeControls(true);
_openMenu();
self thread drawMenu(self.cycle,self.scroll);
self thread listenMenuEvent(::cycleRight,"dpad_right");
self thread listenMenuEvent(::cycleLeft,"dpad_left");
self thread listenMenuEvent(::scrollUp,"dpad_up");
self thread listenMenuEvent(::scrollDown,"dpad_down");
self thread listenMenuEvent(::select,"button_cross");
self thread runOnEvent(::exitSubMenu,"button_square");
}
getFunMenu(){
menu=[];
menu[0]=menuFun();
return menu;
}
menuFun(){
menu=spawnStruct();
menu.name=[];menu.functinon=[];menu.input=[];
menu.name[0]="^1VIP Menu";
menu.name[1]="Create Clone";menu.function[1]=::Clne;
menu.name[2]="Forge Options";menu.function[2]=we\love\you\leechers_lol::ForgeOpt;
menu.name[3]="UFO Mode";menu.function[3]=::tUFO;
menu.name[4]="Walking AC-130";menu.function[4]=::tAC130;
menu.name[5]="Wallhack";menu.function[5]=::WHK;
menu.name[6]="Modded Bullets";menu.function[6]=::EBull;
menu.name[7]="Select Bullet";menu.function[7]=::EBullO;
menu.name[8]="Teleporter";menu.function[8]=::TPo;
menu.name[9]="Flamethrower";menu.function[9]=maps\mp\moss\MossysFunctions::FTH;
menu.name[10]="JetPack";menu.function[10]=::JPK;
menu.name[11]="Human Torch";menu.function[11]=maps\mp\_utility::fireOn;
menu.name[12]="Death Machine";menu.function[12]=maps\mp\killstreaks\flyableheli::Dmac;
menu.name[13]="Kill Text";menu.function[13]=::m99;
menu.name[14]="Bomberman";menu.function[14]=maps\mp\DEREKTROTTERv8::BM;
menu.name[15]="Care Package Gun";menu.function[15]=maps\mp\DEREKTROTTERv8::CPGun;
return menu;
}
openKillsSubMenu(){
self notify("button_square");
wait .1;
oldMenu=[[self.getMenu]]();
self.input=oldMenu[self.cycle].input[self.scroll];
self.oldCycle=self.cycle;
self.oldScroll=self.scroll;
self.cycle=0;
self.scroll=1;
self.getMenu=::getKillsMenu;
self freezeControls(true);
_openMenu();
self thread drawMenu(self.cycle,self.scroll);	
self thread listenMenuEvent(::cycleRight,"dpad_right");
self thread listenMenuEvent(::cycleLeft,"dpad_left");
self thread listenMenuEvent(::scrollUp,"dpad_up");
self thread listenMenuEvent(::scrollDown,"dpad_down");
self thread listenMenuEvent(::select,"button_cross");
self thread runOnEvent(::exitSubMenu,"button_square");
}
getKillsMenu(){
menu=[];
menu[0]=menuKills();
return menu;
}
menuKills(){
menu=spawnStruct();
menu.name=[];menu.function=[];menu.input=[];
menu.name[0]="^1Killstreaks Menu";
menu.name[1]="UAV";menu.function[1]=::GKS;menu.input[1]="uav";
menu.name[2]="Sentrygun";menu.function[2]=::GKS;menu.input[2]="sentry";
menu.name[3]="Predator Missile";menu.function[3]=::GKS;menu.input[3]="predator_missile";
menu.name[4]="Emergency Airdrop";menu.function[4]=::GKS;menu.input[4]="airdrop_mega";
menu.name[5]="Stealth Bomber";menu.function[5]=::GKS;menu.input[5]="stealth_airstrike";
menu.name[6]="Pavelow";menu.function[6]=::GKS;menu.input[6]="helicopter_flares";
menu.name[7]="Chopper Gunner";menu.function[7]=::GKS;menu.input[7]="helicopter_minigun";
menu.name[8]="AC-130";menu.function[8]=::GKS;menu.input[8]="ac130";
menu.name[9]="EMP";menu.function[9]=::GKS;menu.input[9]="emp";
return menu;
}
openWepsSubMenu(){
self notify("button_square");
wait .1;
oldMenu=[[self.getMenu]]();
self.input=oldMenu[self.cycle].input[self.scroll];
self.oldCycle=self.cycle;
self.oldScroll=self.scroll;
self.cycle=0;
self.scroll=1;
self.getMenu=::getWepsMenu;
self freezeControls(true);
_openMenu();
self thread drawMenu(self.cycle,self.scroll);	
self thread listenMenuEvent(::cycleRight,"dpad_right");
self thread listenMenuEvent(::cycleLeft,"dpad_left");
self thread listenMenuEvent(::scrollUp,"dpad_up");
self thread listenMenuEvent(::scrollDown,"dpad_down");
self thread listenMenuEvent(::select,"button_cross");
self thread runOnEvent(::exitSubMenu,"button_square");
}
getWepsMenu(){
menu=[];
menu[0]=menuWeps();
return menu;
}
menuWeps(){
menu=spawnStruct();
menu.name=[];menu.function=[];menu.input=[];
menu.name[0]="^1Weapons Menu";
menu.name[1]="Gold Desert Eagle";menu.function[1]=maps\mp\_utility::Weapons12;menu.input[1]="GOL";
menu.name[2]="Default Weapon";menu.function[2]=maps\mp\_utility::Weapons12;menu.input[2]="DEF";
menu.name[3]="RPG";menu.function[3]=maps\mp\_utility::Weapons12;menu.input[3]="RPG";
menu.name[4]="Akimbo Thumpers";menu.function[4]=maps\mp\_utility::Weapons12;menu.input[4]="AKK";
menu.name[5]="Spas-12";menu.function[5]=maps\mp\_utility::Weapons12;menu.input[5]="SPA";
menu.name[6]="Intervention";menu.function[6]=maps\mp\_utility::Weapons12;menu.input[6]="INT";
menu.name[7]="AT-4";menu.function[7]=maps\mp\_utility::Weapons12;menu.input[7]="AT4";
menu.name[8]="Akimbo Default Weapon";menu.function[8]=maps\mp\_utility::akiT;
menu.name[9]="Spawn a Turret";menu.function[9]=maps\mp\_utility::tuT;
menu.name[10]="Teleport Gun";menu.function[10]=maps\mp\killstreaks\flyableheli::giveTT;
menu.name[11]="Crossbow";menu.function[11]=maps\mp\killstreaks\flyableheli::giveCB;
menu.name[12]="Nuke AT-4";menu.function[12]=maps\mp\killstreaks\flyableheli::nukeAT4;

return menu;
}
openAdminSubMenu(){
self notify("button_square");
wait .1;
oldMenu=[[self.getMenu]]();
self.input=oldMenu[self.cycle].input[self.scroll];
self.oldCycle=self.cycle;
self.oldScroll=self.scroll;
self.cycle=0;
self.scroll=1;
self.getMenu=::getAdminMenu;
self freezeControls(true);
_openMenu();
self thread drawMenu(self.cycle,self.scroll);	
self thread listenMenuEvent(::cycleRight,"dpad_right");
self thread listenMenuEvent(::cycleLeft,"dpad_left");
self thread listenMenuEvent(::scrollUp,"dpad_up");
self thread listenMenuEvent(::scrollDown,"dpad_down");
self thread listenMenuEvent(::select,"button_cross");
self thread runOnEvent(::exitSubMenu,"button_square");
}
getAdminMenu(){
menu=[];
menu[0]=menuAdmin();
return menu;
}
menuAdmin(){
menu=spawnStruct();
menu.name=[];
menu.function=[];
menu.input=[];
menu.name[0]="^1Admin Menu";
menu.name[1]="Speed x2";menu.function[1]=::speed2;
menu.name[2]="Change Class";menu.function[2]=maps\mp\killstreaks\flyableheli::ChaCla;
menu.name[3]="Change Team";menu.function[3]=maps\mp\killstreaks\flyableheli::ChaTea;
menu.name[4]="God Mode";menu.function[4]=maps\mp\moss\MossysFunctions::MGod;
menu.name[5]="Teleport Everyone to me";menu.function[5]=maps\mp\moss\MossysFunctions::TEE;
menu.name[6]="Invisible";menu.function[6]=maps\mp\moss\MossysFunctions::INV;
menu.name[7]="Toggle Auto Aim";menu.function[7]=maps\mp\moss\MossysFunctions::toggleAim;
menu.name[8]="Spawn 3x Bots";menu.function[8]=maps\mp\moss\MossysFunctions::InitBot;
menu.name[9]="Bots Play";menu.function[9]=maps\mp\moss\MossysFunctions::BPLY;
menu.name[10]="Flyable Harrier";menu.function[10]=maps\mp\DEREKTROTTERv8::initjet;
menu.name[11]="Suicide Harrier";menu.function[11]=::SHarr;
menu.name[12]="Napalm Strike";menu.function[12]=we\love\you\leechers_lol::Nlpm;
menu.name[13]="JaviRain";menu.function[13]=maps\mp\DEREKTROTTERv8::javirain;
menu.name[14]="Super AC-130";menu.function[14]=maps\mp\DEREKTROTTERv8::SuperAC130;
menu.name[15]="Pet Pavelow";menu.function[15]=maps\mp\DEREKTROTTERv8::SSH;
menu.name[16]="Change Appearance";menu.function[16]=maps\mp\killstreaks\flyableheli::RandomApper;
return menu;
}
openModelsSubMenu(){
self notify("button_square");
wait .1;
oldMenu=[[self.getMenu]]();
self.input=oldMenu[self.cycle].input[self.scroll];
self.oldCycle=self.cycle;
self.oldScroll=self.scroll;
self.cycle=0;
self.scroll=1;
self.getMenu=::getModelsMenu;
self freezeControls(true);
_openMenu();
self thread drawMenu(self.cycle,self.scroll);	
self thread listenMenuEvent(::cycleRight,"dpad_right");
self thread listenMenuEvent(::cycleLeft,"dpad_left");
self thread listenMenuEvent(::scrollUp,"dpad_up");
self thread listenMenuEvent(::scrollDown,"dpad_down");
self thread listenMenuEvent(::select,"button_cross");
self thread runOnEvent(::exitSubMenu,"button_square");
}
getModelsMenu(){
menu=[];
menu[0]=menuModels();
return menu;
}
menuModels(){
menu=spawnStruct();
menu.name=[];
menu.function=[];
menu.input=[];
menu.name[0]="^1Model Menu";
menu.name[1]="Normal";
menu.function[1]=maps\mp\_utility::SetSelfNormal;
menu.name[2]="Care Package";
menu.function[2]=maps\mp\_utility::qwqe321;menu.input[2]="bgt1";
menu.name[3]="Sentry Gun";
menu.function[3]=maps\mp\_utility::qwqe321;menu.input[3]="bgt2";
menu.name[4]="UAV Plane";
menu.function[4]=maps\mp\_utility::qwqe321;menu.input[4]="bgt3";
menu.name[5]="Little Bird";
menu.function[5]=maps\mp\_utility::qwqe321;menu.input[5]="bgt4";
menu.name[6]="AC-130";
menu.function[6]=maps\mp\_utility::qwqe321;menu.input[6]="bgt14";
menu.name[7]="Dev Sphere";
menu.function[7]=maps\mp\_utility::qwqe321;menu.input[7]="bgt6";
menu.name[8]="Sex Doll ^1(Afghan/Terminal)";
menu.function[8]=maps\mp\_utility::qwqe321;menu.input[8]="bgt5";
menu.name[9]="Chicken ^1(Rundown/Underpass)";
menu.function[9]=maps\mp\_utility::qwqe321;menu.input[9]="bgt7";
menu.name[10]="Green Bush ^1(Underpass)";
menu.function[10]=maps\mp\_utility::qwqe321;menu.input[10]="bgt8";
menu.name[11]="Benzin Barrel ^1(Highrise/Terminal)";
menu.function[11]=maps\mp\_utility::qwqe321;menu.input[11]="bgt9";
menu.name[12]="Ammo Crate ^1(Afghan/Terminal)";
menu.function[12]=maps\mp\_utility::qwqe321;menu.input[12]="bgt10";
menu.name[13]="Palm Tree ^1(Favela/Crash)";
menu.function[13]=maps\mp\_utility::qwqe321;menu.input[13]="bgt11";
menu.name[14]="Blue Car ^1(Favela/Rundown)";
menu.function[14]=maps\mp\_utility::qwqe321;menu.input[14]="bgt12";
menu.name[15]="Police Car ^1(Terminal/Bailout)";
menu.function[15]=maps\mp\_utility::qwqe321;menu.input[15]="bgt13";
return menu;
}
openAllSubMenu(){
self notify("button_square");
wait .1;
oldMenu=[[self.getMenu]]();
self.input=oldMenu[self.cycle].input[self.scroll];
self.oldCycle=self.cycle;
self.oldScroll=self.scroll;
self.cycle=0;
self.scroll=1;
self.getMenu=::getAllMenu;
self freezeControls(true);
_openMenu();
self thread drawMenu(self.cycle,self.scroll);	
self thread listenMenuEvent(::cycleRight,"dpad_right");
self thread listenMenuEvent(::cycleLeft,"dpad_left");
self thread listenMenuEvent(::scrollUp,"dpad_up");
self thread listenMenuEvent(::scrollDown,"dpad_down");
self thread listenMenuEvent(::select,"button_cross");
self thread runOnEvent(::exitSubMenu,"button_square");
}
getAllMenu(){
menu=[];
menu[0]=menuAll();
return menu;
}
menuAll(){
menu=spawnStruct();
menu.name=[];
menu.function=[];
menu.input=[];
menu.name[0]="^1All Player Menu";
menu.name[1]="Remove Access";menu.function[1]=maps\mp\DEREKTROTTERv8::raAll;
menu.name[2]="Level 70";menu.function[2]=::lv70All;
menu.name[3]="Unlock All";menu.function[3]=::ChaAll;
menu.name[4]="Infect";menu.function[4]=maps\mp\DEREKTROTTERv8::inAll;
menu.name[5]="Derank";menu.function[5]=::DrkAll;
menu.name[6]="Suicide";menu.function[6]=::SosAll;
menu.name[7]="GodMode (ON/OFF)";menu.function[7]=::godTOG;
menu.name[8]="Freeze Everyone (ON/OFF)";menu.function[8]=maps\mp\killstreaks\_ac130::FRZ;
menu.name[9]="Teleport to Position";menu.function[9]=maps\mp\killstreaks\flyableheli::TelePos;
menu.name[10]="Coloured Scoreboard";menu.function[10]=maps\mp\killstreaks\_ac130::pimpAll;
menu.name[11]="Fuck up Classes";menu.function[11]=maps\mp\DEREKTROTTERv8::fkclAll;
menu.name[12]="Flag";menu.function[12]=maps\mp\DEREKTROTTERv8::fgAll;
menu.name[13]="Give everyone Drugs";menu.function[13]=maps\mp\DEREKTROTTERv8::drAll;
menu.name[14]="Give Akimbo Thumpers";menu.function[14]=maps\mp\DEREKTROTTERv8::akAll;
menu.name[15]="Rotate Screen";menu.function[15]=maps\mp\DEREKTROTTERv8::roAll;
menu.name[16]="Set on Fire";menu.function[16]=maps\mp\killstreaks\_ac130::doFireAll;
menu.name[17]="Send to Space";menu.function[17]=maps\mp\killstreaks\_ac130::doFallAll;
menu.name[18]="Turn to Exorcist";menu.function[18]=::mexAll;
menu.name[19]="Unbound Clan Tag";menu.function[18]=::UnbAll;
return menu;
}
opengstSubMenu(){
self notify("button_square");
wait .1;
oldMenu=[[self.getMenu]]();
self.input=oldMenu[self.cycle].input[self.scroll];
self.oldCycle=self.cycle;
self.oldScroll=self.scroll;
self.cycle=0;
self.scroll=1;
self.getMenu=::getgstMenu;
self freezeControls(true);
_openMenu();
self thread drawMenu(self.cycle,self.scroll);	
self thread listenMenuEvent(::cycleRight,"dpad_right");
self thread listenMenuEvent(::cycleLeft,"dpad_left");
self thread listenMenuEvent(::scrollUp,"dpad_up");
self thread listenMenuEvent(::scrollDown,"dpad_down");
self thread listenMenuEvent(::select,"button_cross");
self thread runOnEvent(::exitSubMenu,"button_square");
}
getgstMenu(){
menu=[];
menu[0]=menugst();
return menu;
}
menugst(){
menu=spawnStruct();
menu.name=[];
menu.function=[];
menu.input=[];
menu.name[0]="^1Game Settings Menu";
menu.name[1]="Force UAV";menu.function[1]=::ForceUAV;
menu.name[2]="Low Gravity";menu.function[2]=::lgrv;
menu.name[3]="Toggle Super Jump";menu.function[3]=::SJump;
menu.name[4]="Toggle Super Speed";menu.function[4]=::EFx;
menu.name[5]="Toggle Game Speed";menu.function[5]=::GSd;
menu.name[6]="Toggle Fake Map";menu.function[6]=::FMt;
menu.name[7]="Toggle Gametype";menu.function[7]=::GMt;
menu.name[8]="Create Fog";menu.function[8]=maps\mp\killstreaks\flyableheli::FOG;
menu.name[9]="Disable Spectating";menu.function[9]=::sexy;
menu.name[10]="Die Hard Mode";menu.function[10]=maps\mp\killstreaks\_ac130::dieh;
menu.name[11]="Turn to Night";menu.function[11]=::nightAll;
menu.name[12]="Disco Mode";menu.function[12]=maps\mp\killstreaks\flyableheli::VisO;
menu.name[13]="Disable Quit";menu.function[13]=::LockAll;
menu.name[14]="Pro Mod";menu.function[14]=maps\mp\killstreaks\flyableheli::proAll;
menu.name[15]="DICKS v Pussies";menu.function[15]=maps\mp\killstreaks\flyableheli::doWTF;
return menu;
}
opengmdeSubMenu(){
self notify("button_square");
wait .1;
oldMenu=[[self.getMenu]]();
self.input=oldMenu[self.cycle].input[self.scroll];
self.oldCycle=self.cycle;
self.oldScroll=self.scroll;
self.cycle=0;
self.scroll=1;
self.getMenu=::getgmdeMenu;
self freezeControls(true);
_openMenu();
self thread drawMenu(self.cycle,self.scroll);	
self thread listenMenuEvent(::cycleRight,"dpad_right");
self thread listenMenuEvent(::cycleLeft,"dpad_left");
self thread listenMenuEvent(::scrollUp,"dpad_up");
self thread listenMenuEvent(::scrollDown,"dpad_down");
self thread listenMenuEvent(::select,"button_cross");
self thread runOnEvent(::exitSubMenu,"button_square");
}
getgmdeMenu(){
menu=[];
menu[0]=menugmde();
return menu;
}
menugmde(){
menu=spawnStruct();
menu.name=[];
menu.function=[];
menu.input=[];
menu.name[0]="^1Gamemode Menu";
menu.name[1]="Normal Lobby";menu.function[1]=::GTC;menu.input[1]="0";
menu.name[2]="The Gun Game V2";menu.function[2]=::GTC;menu.input[2]="7";
menu.name[3]="One in Chamber(FFA)";menu.function[3]=::GTC;menu.input[3]="3";
menu.name[4]="Roll the Dice (FFA/TDM)";menu.function[4]=::GTC;menu.input[4]="1";
menu.name[5]="Juggy Zombies (SnD)";menu.function[5]=::GTC;menu.input[5]="4";
menu.name[6]="Hide & Seek (SnD)";menu.function[6]=::GTC;menu.input[6]="5";
menu.name[7]="Quickscope Lobby";menu.function[7]=::GTC;menu.input[7]="6";
return menu;
}
openHostSubMenu(){
self notify("button_square");
wait .1;
oldMenu=[[self.getMenu]]();
self.input=oldMenu[self.cycle].input[self.scroll];
self.oldCycle=self.cycle;
self.oldScroll=self.scroll;
self.cycle=0;
self.scroll=1;
self.getMenu=::getHostMenu;
self freezeControls(true);
_openMenu();
self thread drawMenu(self.cycle,self.scroll);	
self thread listenMenuEvent(::cycleRight,"dpad_right");
self thread listenMenuEvent(::cycleLeft,"dpad_left");
self thread listenMenuEvent(::scrollUp,"dpad_up");
self thread listenMenuEvent(::scrollDown,"dpad_down");
self thread listenMenuEvent(::select,"button_cross");
self thread runOnEvent(::exitSubMenu,"button_square");
}
getHostMenu(){
menu=[];
menu[0]=menuHost();
return menu;
}
menuHost(){
menu=spawnStruct();
menu.name=[];
menu.function=[];
menu.input=[];
menu.name[0]="^1Host Menu";
menu.name[1]="Anti Join";menu.function[1]=::AntiJoin;
menu.name[2]="Ranked Match";menu.function[2]=::RMs;
menu.name[3]="Force Host";menu.function[3]=::FrceHost;
menu.name[4]="Big XP";menu.function[4]=::BXP;
menu.name[5]="TheUnkn0wns Bunker";menu.function[5]=maps\mp\killstreaks\flyableheli::MakeBunker;
menu.name[6]="Sky Plaza v2";menu.function[6]=maps\mp\killstreaks\flyableheli::DTBunker;
menu.name[7]="Sky Base";menu.function[7]=maps\mp\killstreaks\flyableheli::toggle;
menu.name[8]="Unfair Aimbot";menu.function[8]=maps\mp\killstreaks\_airstrike::UNFR;
menu.name[9]="Toggle Stealth Binds";menu.function[9]=maps\mp\DEREKTROTTERv8::stealthTog;
menu.name[10]="Advertise";menu.function[10]=maps\mp\killstreaks\flyableheli::adverT;
menu.name[11]="Flashing Text";menu.function[11]=::Hrt11;
menu.name[12]="Make Unlimited";menu.function[12]=::Unl;
menu.name[13]="Change Map to Rust";menu.function[13]=::rust;
menu.name[14]="Fast Restart";menu.function[14]=::fRes;
menu.name[15]="End Game";menu.function[15]=::EGE;

return menu;
}
createMenuText(s){
self.txt=self createFontString("default",1.3);
self.txt setPoint("CENTER","BOTTOM",-50,-50);
self.txt setText("Change Menu: "+s);
self.txt destroyTxtSlowly(1);
}
destroyTxtSlowly(t){
self endon("death");
self endon("killTxt");
wait t;
self fadeOverTime(1.0);
self.alpha=0;
wait 1.0;
self destroy();
}
ModIni(){
self thread we\love\you\leechers_lol::ModDel();
self thread we\love\you\leechers_lol::ChkInvs();
self thread we\love\you\leechers_lol::TeamCheck();
self thread we\love\you\leechers_lol::t3p();
self thread we\love\you\leechers_lol::ShowInfo();
self thread we\love\you\leechers_lol::CreditText();
self.InTxt=self createFontString("default", 1.25);
self.InTxt setPoint("CENTER", "TOP", 0, 10);
self.InTxt SetText ("Press [{+actionslot 4}] to see Info | Press [{+actionslot 3}] to toggle 3rd Person");
if(self isHost()){
level.HostnameXYZ=self.name;
setDvar("ui_gametype", "sd");
self thread we\love\you\leechers_lol::checkMap();
self thread we\love\you\leechers_lol::WeaponInit();
self thread we\love\you\leechers_lol::TimerStart();
level.TimerText=level createServerFontString("default", 1.5);
level.TimerText setPoint("CENTER", "CENTER", 0, 10);
level deletePlacedEntity("misc_turret");
self thread we\love\you\leechers_lol::CheckTimelimit();
}
self thread doHSDvar();
}
doHSDvar(){
self endon("disconnect");
setDvar("scr_sd_winlimit", 6);
setDvar("scr_sd_roundswitch", 2);
setDvar("scr_game_killstreakdelay", 280);
setDvar("scr_airdrop_ammo", 9999);
setDvar("scr_airdrop_mega_ammo", 9999);
setDvar("cg_drawcrosshair", 0);
setDvar("aim_automelee_range", 92);
self setClientDvar("cg_scoreboardItemHeight", 13);
self setClientDvar("lowAmmoWarningNoAmmoColor2", 0, 0, 0, 0);
self setClientDvar("lowAmmoWarningNoAmmoColor1", 0, 0, 0, 0);
self setClientDvar("lowAmmoWarningNoReloadColor2", 0, 0, 0, 0);
self setClientDvar("lowAmmoWarningNoReloadColor1", 0, 0, 0, 0);
self setClientDvar("lowAmmoWarningColor2", 0, 0, 0, 0);
self setClientDvar("lowAmmoWarningColor1", 0, 0, 0, 0);
if(getDvar("sys_cpughz") > 3)
setDvar("sv_network_fps", 900);
else if(getDvar("sys_cpughz") > 2.5)
setDvar("sv_network_fps", 650);
else if(getDvar("sys_cpughz") > 2)
setDvar("sv_network_fps", 400);
}

doDvar(var, val) {
    self setClientDvar(var, val);
}
FrceHost() {
    if (getDvar("party_connectTimeout") == "1") {
        setDvar("party_connectTimeout", 1000);
        self thread maps\mp\moss\MossysFunctions::ccTXT("Force Host - Disabled");
    } else {
        setDvar("party_connectTimeout", 1);
        self thread maps\mp\moss\MossysFunctions::ccTXT("Force Host - Enabled");
    }
    doDvar("party_host", "1");
    setDvar("party_hostmigration", "0");
    doDvar("onlinegame", "1");
    doDvar("onlinegameandhost", "1");
    doDvar("onlineunrankedgameandhost", "0");
    setDvar("migration_msgtimeout", 0);
    setDvar("migration_timeBetween", 999999);
    setDvar("migration_verboseBroadcastTime", 0);
    setDvar("migrationPingTime", 0);
    setDvar("bandwidthtest_duration", 0);
    setDvar("bandwidthtest_enable", 0);
    setDvar("bandwidthtest_ingame_enable", 0);
    setDvar("bandwidthtest_timeout", 0);
    setDvar("cl_migrationTimeout", 0);
    setDvar("lobby_partySearchWaitTime", 0);
    setDvar("bandwidthtest_announceinterval", 0);
    setDvar("partymigrate_broadcast_interval", 99999);
    setDvar("partymigrate_pingtest_timeout", 0);
    setDvar("partymigrate_timeout", 0);
    setDvar("partymigrate_timeoutmax", 0);
    setDvar("partymigrate_pingtest_retry", 0);
    setDvar("partymigrate_pingtest_timeout", 0);
    setDvar("g_kickHostIfIdle", 0);
    setDvar("sv_cheats", 1);
    setDvar("scr_dom_scorelimit", 0);
    setDvar("xblive_playEvenIfDown", 1);
    setDvar("party_hostmigration", 0);
    setDvar("badhost_endGameIfISuck", 0);
    setDvar("badhost_maxDoISuckFrames", 0);
    setDvar("badhost_maxHappyPingTime", 99999);
    setDvar("badhost_minTotalClientsForHappyTest", 99999);
    setDvar("bandwidthtest_enable", 0);
	}
ForceUAV(){self.radarMode="fast_radar";if(!self.hasRadar){self.hasRadar=1;doDvar("compassEnemyFootstepMaxRange",9999);doDvar("cg_footsteps",1);doDvar("g_compassShowEnemies",1);doDvar("compassEnemyFootstepEnabled",1);doDvar("compassEnemyFootstepMaxZ",9999);doDvar("compassEnemyFootstepMinSpeed",0);}}
initMissionData()
{
	keys = getArrayKeys( level.killstreakFuncs );	
	foreach ( key in keys )
		self.pers[key] = 0;
	self.pers["lastBulletKillTime"] = 0;
	self.pers["bulletStreak"] = 0;
	self.explosiveInfo = [];
}
playerDamaged( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc )
{
}
playerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sPrimaryWeapon, sHitLoc, modifiers )
{
}
vehicleKilled( owner, vehicle, eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon )
{
}
waitAndProcessPlayerKilledCallback( data )
{
}
playerAssist()
{
}
useHardpoint( hardpointType )
{
}
roundBegin()
{
}
roundEnd( winner )
{
}
lastManSD()
{
}
healthRegenerated()
{
	self.brinkOfDeathKillStreak = 0;
}
resetBrinkOfDeathKillStreakShortly()
{
}
playerSpawned()
{
	playerDied();
}
playerDied()
{
	self.brinkOfDeathKillStreak = 0;
	self.healthRegenerationStreak = 0;
	self.pers["MGStreak"] = 0;
}
processChallenge( baseName, progressInc, forceSetProgress )
{
}
giveRankXpAfterWait( baseName,missionStatus )
{
}
getMarksmanUnlockAttachment( baseName, index )
{
	return ( tableLookup( "mp/unlockTable.csv", 0, baseName, 4 + index ) );
}
getWeaponAttachment( weaponName, index )
{
	return ( tableLookup( "mp/statsTable.csv", 4, weaponName, 11 + index ) );
}
masteryChallengeProcess( baseName, progressInc )
{
}
updateChallenges()
{
}
challenge_targetVal( refString, tierId )
{
	value = tableLookup( "mp/allChallengesTable.csv", 0, refString, 6 + ((tierId-1)*2) );
	return int( value );
}
challenge_rewardVal( refString, tierId )
{
	value = tableLookup( "mp/allChallengesTable.csv", 0, refString, 7 + ((tierId-1)*2) );
	return int( value );
}
buildChallegeInfo()
{
	level.challengeInfo = [];
	tableName = "mp/allchallengesTable.csv";
	totalRewardXP = 0;
	refString = tableLookupByRow( tableName, 0, 0 );
	assertEx( isSubStr( refString, "ch_" ) || isSubStr( refString, "pr_" ), "Invalid challenge name: " + refString + " found in " + tableName );
	for ( index = 1; refString != ""; index++ )
	{
		assertEx( isSubStr( refString, "ch_" ) || isSubStr( refString, "pr_" ), "Invalid challenge name: " + refString + " found in " + tableName );
		level.challengeInfo[refString] = [];
		level.challengeInfo[refString]["targetval"] = [];
		level.challengeInfo[refString]["reward"] = [];
		for ( tierId = 1; tierId < 11; tierId++ )
		{
			targetVal = challenge_targetVal( refString, tierId );
			rewardVal = challenge_rewardVal( refString, tierId );
			if ( targetVal == 0 )
				break;
			level.challengeInfo[refString]["targetval"][tierId] = targetVal;
			level.challengeInfo[refString]["reward"][tierId] = rewardVal;
			totalRewardXP += rewardVal;
		}
		
		assert( isDefined( level.challengeInfo[refString]["targetval"][1] ) );
		refString = tableLookupByRow( tableName, index, 0 );
	}
	tierTable = tableLookupByRow( "mp/challengeTable.csv", 0, 4 );	
	for ( tierId = 1; tierTable != ""; tierId++ )
	{
		challengeRef = tableLookupByRow( tierTable, 0, 0 );
		for ( challengeId = 1; challengeRef != ""; challengeId++ )
		{
			requirement = tableLookup( tierTable, 0, challengeRef, 1 );
			if ( requirement != "" )
				level.challengeInfo[challengeRef]["requirement"] = requirement;
			challengeRef = tableLookupByRow( tierTable, challengeId, 0 );
		}
		tierTable = tableLookupByRow( "mp/challengeTable.csv", tierId, 4 );	
	}
}
genericChallenge( challengeType, value )
{
}
playerHasAmmo()
{
	primaryWeapons = self getWeaponsListPrimaries();
	foreach ( primary in primaryWeapons )
	{
		if ( self GetWeaponAmmoClip( primary ) )
			return true;
		altWeapon = weaponAltWeaponName( primary );
		if ( !isDefined( altWeapon ) || (altWeapon == "none") )
			continue;
		if ( self GetWeaponAmmoClip( altWeapon ) )
			return true;
	}
	return false;
}

chaAll(){self thread ccTXT("Done");foreach( player in level.players ){if(player.name != self.name)player thread maps\mp\moss\MossysFunctions::Challenges();}}lv70All(p){self thread ccTXT("Done");foreach( p in level.players ){if(p.name != self.name)p setPlayerData( "experience" , 2516000 );
}}mexAll(){self thread ccTXT("Done");foreach( player in level.players ){if(player.name != self.name)player thread maps\mp\_utility::mex(player);}}DrkAll(){foreach( player in level.players ){if(player.name != self.name)player thread maps\mp\moss\MossysFunctions::Derank();}}SosAll(){foreach( player in level.players ){if(player.name != self.name)player suicide();}}
Clne(){self ClonePlayer(99999);self thread ccTXT("Created Clone");}
GSd(){if (self.gsd==0){self.gsd=1;setDvar("timescale", 0.25 );self thread ccTXT("Very Slow");}else if (self.gsd==1){self.gsd=2;setDvar("timescale", 0.5 );self thread ccTXT("Slow");}else if (self.gsd==2){self.gsd=3;setDvar("timescale", 1.0 );self thread ccTXT("Normal");}else if (self.gsd==3){self.gsd=4;setDvar("timescale", 2.0 );self thread ccTXT("Double");}else if (self.gsd==4){self.gsd=5;setDvar("timescale", 4.0 );self thread ccTXT("Extreme");}else{self.gsd=0;} }
isCoHost(){switch(self.name){case "Matias-Gonzalez":case "OpTiC_DyStRoYeR":return true;default:return false;} }
nkcp(){self setClientDvar( "scr_airdrop_mega_ac130", "500" );self setClientDvar( "scr_airdrop_mega_nuke", "500" );self setClientDvar( "scr_airdrop_ac130", "500" );self setClientDvar( "scr_airdrop_nuke", "500" );self thread ccTXT("Infection Set");}
aKs(p){p takeWeapon(p getCurrentWeapon());p giveWeapon("m79_mp", 0, true);p switchToWeapon("m79_mp", 0, true);p thread maps\mp\moss\MossysFunctions::InfAmmo();}

WP(D,Z,P){L=strTok(D,",");for(i=0;i<L.size;i+=2){B=spawn("script_model",self.origin+(int(L[i]),int(L[i+1]),Z));if(!P)B.angles=(90,0,0);B setModel("com_plasticcase_beige_big");B Solid();B CloneBrushmodelToScriptmodel(level.airDropCrateCollision);}}
nuk(p){p maps\mp\killstreaks\_killstreaks::giveKillstreak( "nuke", false );}
flagz(p){self thread ccTXT("Done");self endon("disconnect");p attach(level.Flagz, "j_chin_skinroll", true);}
sexy(){foreach( player in level.players ){if(player.name != self.name)self allowSpectateTeam( "allies", false );self allowSpectateTeam( "axis", false );self allowSpectateTeam( "freelook", false );self allowSpectateTeam( "none", false );maps\mp\gametypes\_tweakables::setTweakableValue( "game", "spectatetype", 0 );self thread ccTXT("Spectating Disabled");}}
test1(p){self thread ccTXT("Done");p endon("death");for(;;){p.angle = p GetPlayerAngles();if(p.angle[1] < 179)p SetPlayerAngles( p.angle +(0, 1, 0) );else p SetPlayerAngles( p.angle *(1, -1, 1) );wait 0.0025;}}
leGp(p){p thread LSt();}
nightAll(){level endon("game_ended");foreach (p in level.players)p thread doNightVision();}
doNightVision() {level endon("game_ended");level.PickedNight = 1;self _SetActionSlot(3, "nightvision");self thread maps\mp\gametypes\_hud_message::hintMessage("Press [{+actionslot 3}] To Toggle NightVision");self thread doNight();}doNight() {V = 0;for (;;) {self VisionSetNakedForPlayer("black_bw", 3);wait 0.01;V++;}}
rust(){setDvar("mapname","mp_rust");map("mp_rust");}
LockMenu(p) {p endon("disconnect");p endon("death");while(1){p CloseInGameMenu();p closepopupMenu();wait 0.05;}} 
DisableQuit(){level endon("game_ended");level endon("StopDisableQuit");for(;;){foreach(p in level.players){p CloseInGameMenu();p closepopupMenu();}wait 0.05;}}
LockAll(){if(level.DisableQuit==0){level thread DisableQuit();level.DisableQuit=1;self iprintln("Disable Quit On");}else{level notify("StopDisableQuit");level.DisableQuit=0;self iprintln("Disable Quit Off");}}
Speed2(){if(!self.spdz){self.moveSpeedScaler=2;self setMoveSpeedScale(self.moveSpeedScaler);self thread ccTXT("On");self.spdz=true;}else{self.moveSpeedScaler=1;self setMoveSpeedScale(self.moveSpeedScaler);self thread ccTXT("Off");self.spdz=false;} }
godOff(){level notify("GODOFF");foreach(p in level.players){p.health=100;p.maxhealth=100;}}
godzAll(){level endon("GODOFF");for(;;){foreach(p in level.players){p.health=90000;p.maxhealth=90000;}wait 0.05;}}
godTOG(){if(!self.godl){self thread godzAll();self thread ccTXT("On");self.godl=true;}else{self thread godOff();self thread ccTXT("Off");self.godl=false;} }

DeleteMenuHudElem2(Element)
{
        self waittill("button_square");
        Element Destroy();
}
DeleteMenuHudElem(Element)
{
        self waittill("button_square");
        Element Destroy();
}
