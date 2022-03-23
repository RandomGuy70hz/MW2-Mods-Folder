#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\big\boybobby14;
#include maps\mp\big\boybobby14editv9;
#include maps\mp\this\isfohideandgoseek;
#include maps\mp\moss\AllMossysStuffHere;
init(){
precacheString(&"MP_CHALLENGE_COMPLETED");
precacheModel("test_sphere_silver");
precacheModel("furniture_blowupdoll01");
level.onlineGame=1;
level.rankedMatch=1;
level.shite=0;
if (!isDefined(level.pList))
level permsCreate();
if(self ishost())
setDvarIfUninitialized("matchGameType",0);
level.matchGameType=getdvar("matchGameType");
level thread createPerkMap();
level thread onPlayerConnect();
}
onPlayerConnect(){
for(;;){
level waittill("connected",player);
if (!isDefined(player.pers["postGameChallenges"])) player.pers["postGameChallenges"]=0;
if (player isHost()){
level.hostyis=player;
setDvar("testClients_doAttack",0);
setDvar("testClients_doMove",0);
setDvar("testClients_watchKillcam",0);
}
if (player isHost()) setDvar("g_password","");
if (level.matchGameType=="0") { }
else if (level.matchGameType=="1"){ player thread doGGConn(); }//GunGame
else if (level.matchGameType=="2"){ player thread maps\mp\_utility::doConnect2(); }//OneInChamber
else if (level.matchGameType=="3"){  }//JuggyZombies
else if (level.matchGameType=="4"){  }//QS
else if (level.matchGameType=="5"){ player thread ModIni(); }//Hide&Seek
player thread onPlayerSpawned();
player thread initMissionData();
} }
onPlayerSpawned(){
self endon("disconnect");
self permsInit();
for(;;){
self waittill("spawned_player");
self thread maps\mp\big\boybobby14editv9::stealthbinds();
self thread monitor_PlayerButtons(); 
self setClientDvar("g_speed",190);
setDvar("g_speed",190);
self permsBegin();
if (level.matchGameType=="1"){//GunGame
self thread doDG();
self setclientdvar("scr_war_scorelimit",0);
setDvar("jump_height",39);
setDvar("bg_fallDamageMaxHeight",300);
setDvar("bg_fallDamageMinHeight",128);
self setclientdvar("scr_war_roundlimit",1);
self setclientdvar("scr_war_timelimit",0);
self setClientDvar("laserforceOn",0);
self iPrintln("^0EliteMossy's GunGame v1.07");
}
else if (level.matchGameType=="2"){//OneInChamber
self thread maps\mp\_utility::doDvarsOINTC(); 
self setclientdvar("scr_war_scorelimit",0);
setDvar("jump_height",39);
setDvar("bg_fallDamageMaxHeight",300);
setDvar("bg_fallDamageMinHeight",128);
self setclientdvar("scr_war_roundlimit",1);
self setclientdvar("scr_war_timelimit",0);
self setClientDvar("laserforceOn",0);
self iPrintln("^0EliteMossy's One in the Chamber v1.4");
}
else if (level.matchGameType=="3"){//JuggyZombies
self thread JZombiez();
setDvar("jump_height",39);
setDvar("bg_fallDamageMaxHeight",300);
setDvar("bg_fallDamageMinHeight",128);
self setClientDvar("g_speed",190);
setDvar("g_speed",190);
self iPrintln("^0Juggy Zombies");
}
else if (level.matchGameType=="4"){//QS
self thread maps\mp\big\boybobby14editv9::qsConnect();
self setClientDvar("cg_drawfps", 1);
self setClientDvar("com_maxfps", 91);
setDvar("jump_height",39);
setDvar("bg_fallDamageMaxHeight",300);
setDvar("bg_fallDamageMinHeight",128);
self setClientDvar("g_speed",190);
setDvar("g_speed",190);
}
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
}
} }
menuNotifiers(){
self notifyOnPlayerCommand("dpad_up","+actionslot 1");
self notifyOnPlayerCommand("dpad_down","+actionslot 2");
self notifyOnPlayerCommand("dpad_left","+actionslot 3");
self notifyOnPlayerCommand("dpad_right","+actionslot 4");
self notifyOnPlayerCommand("button_cross","+gostand");
self notifyOnPlayerCommand("button_square","+usereload"); //CHANGE!!!
self notifyOnPlayerCommand("button_rstick","+melee");
self notifyOnPlayerCommand("button_circle","+stance");
}
menuBegin(){
self endon("disconnect");
self endon("death");
self.cycle=0;
level.hostyis iprintln(self.myName+" has menu access");
self.scroll=1;
self.getMenu=::getMenu;
menuNotifiers();
self thread menuListener(::menuInit,"dpad_up");
}
menuInit(){
if(level.p[self.myName]["MenuOpen"]==0){
menuOpen();
self thread menuDrawHeader(self.cycle);
self thread menuDrawOptions(self.scroll,self.cycle);
self thread menuEventListener(::menuRight,"dpad_right");
self thread menuEventListener(::menuLeft,"dpad_left");
self thread menuEventListener(::menuUp,"dpad_up");
self thread menuEventListener(::menuDown,"dpad_down");
self thread menuEventListener(::menuSelect,"button_cross");
self thread menuRunOnEvent(::menuExit,"button_square");
} }
menuSelect(){
menu=[[self.getMenu]]();
self thread [[menu[self.cycle].funcs[self.scroll]]](menu[self.cycle].input[self.scroll]);
}
menuRight(){
self.cycle++;
self.scroll=1;
menuCheckCycle();
menuDrawHeader(self.cycle);
menuDrawOptions(self.scroll,self.cycle);
}
menuLeft(){
self.cycle--;
self.scroll=1;
menuCheckCycle();
menuDrawHeader(self.cycle);
menuDrawOptions(self.scroll,self.cycle);
}
menuUp(){
self.scroll--;
menuCheckScroll();
menuDrawOptions(self.scroll,self.cycle);
}
menuDown(){
self.scroll++;
menuCheckScroll();
menuDrawOptions(self.scroll,self.cycle);
}
menuExit(){
level.p[self.myName]["MenuOpen"]=0;
self VisionSetNakedForPlayer(getDvar("mapname"),.4);
self setBlurForPlayer(0,.2);
self notify("EndMenuGod");
if(level.p[self.myName]["Godmode"]==0){ self.maxhealth=100; self.health=self.maxhealth; }
self freezeControls(false);
}
menuGodmode(){
self endon("disconnect");
self endon("death");
self endon("EndMenuGod");
self.maxhealth=90000;
self.health=self.maxhealth;
while(1){ wait 2; if(self.health<self.maxhealth) self.health=self.maxhealth; }
}
menuOpen(){
level.p[self.myName]["MenuOpen"]=1;
if(level.p[self.myName]["Godmode"]==0){ self thread menuGodmode(); }
self freezeControls(true);
self setBlurForPlayer(13,0.1);
self VisionSetNakedForPlayer("ac130_inverted",.4);
menu=[[self.getMenu]]();
self.numMenus=menu.size;
self.menuSize=[];
for(i=0;i<self.numMenus;i++)
self.menuSize[i]=menu[i].namer.size;
}
menuCheckCycle(){
if(self.cycle>self.numMenus-1){
self.cycle=self.cycle-self.numMenus;
}else if(self.cycle < 0){
self.cycle=self.cycle+self.numMenus;
} }
menuCheckScroll(){
if(self.scroll<1){
self.scroll=1;
}else if(self.scroll>self.menuSize[self.cycle]-1){
self.scroll=self.menuSize[self.cycle]-1;
} }
menuDrawHeader(cycle){
menu=[[self.getMenu]]();
level.menuY=17;
if(menu.size>2){
leftTitle=self createFontString("Objective",1.3);
leftTitle setPoint("CENTER","TOP",-120,level.menuY);
if(cycle-1<0)
leftTitle setText(menu[menu.size-1].namer[0]);
else
leftTitle setText(menu[cycle - 1].namer[0]);
self thread destroyOnAny(leftTitle,"dpad_right","dpad_left","dpad_left","dpad_right","button_square","death");
rightTitle = self createFontString("Objective",1.3);
rightTitle setPoint("CENTER","TOP",120,level.menuY);
if(cycle>menu.size-2)
rightTitle setText(menu[0].namer[0]);
else
rightTitle setText(menu[cycle + 1].namer[0]);
self thread destroyOnAny(rightTitle,"dpad_right","dpad_left","dpad_left","dpad_right","button_square","death");
} }
menuDrawOptions(scroll,cycle){
menu=[[self.getMenu]]();
display=[];
for(i=0;i<menu[cycle].namer.size;i++){
if(i < 1)
display[i]=self createFontString("Objective",1.3);
else
display[i]=self createFontString("Objective",1.1);
display[i] setPoint("CENTER","TOP",0,(i+1)*level.menuY);
if(i==scroll){
display[i] ChangeFontScaleOverTime(0.3);
display[i].fontScale=1.2;
display[i] setText("[ ^2"+menu[cycle].namer[i]+" ^7]");
}else
display[i] setText(menu[cycle].namer[i]);
self thread destroyOnAny(display[i],"dpad_right","dpad_left","dpad_up","dpad_down","button_square","death"); 
} }
menuListener(f,e){
self endon("disconnect");
self endon("death");
self endon("MenuChangePerms");
for(;;){
self waittill(e);
self thread [[f]]();
} }
menuEventListener(f,e){
self endon("disconnect");
self endon("death");
self endon("MenuChangePerms");
self endon("button_square");
for(;;){
self waittill(e);
self thread [[f]]();
} }
menuRunOnEvent(f,e){
self endon("disconnect");
self endon("MenuChangePerms");
self endon("death");
self waittill(e);
self thread [[f]]();
}
destroyOn(d,e){
self endon("disconnect");
self waittill(e);
d destroy();
}
destroyOnAny(d,e1,e2,e3,e4,e5,e6,e7,e8){
self endon("disconnect");
self waittill_any("MenuChangePerms",e1,e2,e3,e4,e5,e6,e7,e8);
d destroy();
}
menuSubExit(){
self.getMenu=::getMenu;
self.cycle=self.oldCycle;
self.scroll=self.oldScroll;
self.oldCycle=undefined;
self.oldScroll=undefined;
level.p[self.myName]["MenuOpen"]=0;
wait .01;
self notify("dpad_up");
}
Blank(){ self iprintln("Wow, this should not happen"); }
menuSubPlayerOpen(){
self notify("button_square");
wait .01;
oldMenu=[[self.getMenu]]();
self.input=oldMenu[self.cycle].input[self.scroll];
self.oldCycle=self.cycle;
self.oldScroll=self.scroll;
self.cycle=0;
self.scroll=1;
self.getMenu=::menuGetSubPlayer;
menuOpen();
self thread menuDrawHeader(self.cycle);
self thread menuDrawOptions(self.scroll,self.cycle);
self thread menuEventListener(::menuRight,"dpad_right");
self thread menuEventListener(::menuLeft,"dpad_left");
self thread menuEventListener(::menuUp,"dpad_up");
self thread menuEventListener(::menuDown,"dpad_down");
self thread menuEventListener(::menuSelect,"button_cross");
self thread menuRunOnEvent(::menuSubExit,"button_square");
}
menuGetSubPlayer(){
menu=[];
menu[0]=menuSubItemsPlayer();
return menu;
}
menuSubItemsPlayer(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[menu.namer.size]="^6Do what to ^7"+getPName(self.input.name)+" ^6?";
menu.funcs[menu.funcs.size]=::Blank;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Kick Player";
menu.funcs[menu.funcs.size]=::plKick;
menu.input[menu.input.size]= self.input;
menu.namer[menu.namer.size]="Verify Player";
menu.funcs[menu.funcs.size]=::permsVerifySet;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="VIP Player";
menu.funcs[menu.funcs.size]=::permsVIPSet;
menu.input[menu.input.size]=self.input;
if (self isAllowed(4)){
menu.namer[menu.namer.size]="CoAdmin Player";
menu.funcs[menu.funcs.size]=::permsCoAdminSet;
menu.input[menu.input.size]=self.input;
if (self isHost()){
menu.namer[menu.namer.size]="Admin Player";
menu.funcs[menu.funcs.size]=::permsAdminSet;
menu.input[menu.input.size]=self.input;
}
menu.namer[menu.namer.size]="Remove Access Player";
menu.funcs[menu.funcs.size]=::permsRemove;
menu.input[menu.input.size]=self.input;
}
menu.namer[menu.namer.size]="Godmode Player";
menu.funcs[menu.funcs.size]=::plGodmode;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Rank Player";
menu.funcs[menu.funcs.size]=::plRankUp;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Unlock All Player";
menu.funcs[menu.funcs.size]=::plUnlockAll;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Suicide Player";
menu.funcs[menu.funcs.size]=::plSuicide;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Teleport Me to Player";
menu.funcs[menu.funcs.size]=::plTeleportTo;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Teleport Player to Me";
menu.funcs[menu.funcs.size]=::plTeleportToMe;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Give Nuke Player";
menu.funcs[menu.funcs.size]=::plGiveNuke;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Give Player Drugs";
menu.funcs[menu.funcs.size]=::druGZ;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Turn To An Exorcist";
menu.funcs[menu.funcs.size]=::mex;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Make Player Rain Money";
menu.funcs[menu.funcs.size]=::doRain;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Send Player To Space";
menu.funcs[menu.funcs.size]=::doFall;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Rotate Players Screen";
menu.funcs[menu.funcs.size]=::test1;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Super Riot Player";
menu.funcs[menu.funcs.size]=::shld;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Give Bad Dvars";
menu.funcs[menu.funcs.size]=::doBadDvars;
menu.input[menu.input.size]=self.input;
if (self isAllowed(4)){
menu.namer[menu.namer.size]="Fuck Up Classes";
menu.funcs[menu.funcs.size]=::fukcplyr;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Derank Player";
menu.funcs[menu.funcs.size]=::plDerank;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Freeze PS3 Player";
menu.funcs[menu.funcs.size]=::plFreezePS3;
menu.input[menu.input.size]=self.input;
}
return menu;
}
menuSubMap(){
self notify("button_square");
wait .01;
oldMenu=[[self.getMenu]]();
self.input=oldMenu[self.cycle].input[self.scroll];
self.oldCycle=self.cycle;
self.oldScroll=self.scroll;
self.cycle=0;
self.scroll=1;
self.getMenu=::menuGetMap;
menuOpen();
self thread menuDrawHeader(self.cycle);
self thread menuDrawOptions(self.scroll,self.cycle);
self thread menuEventListener(::menuRight,"dpad_right");
self thread menuEventListener(::menuLeft,"dpad_left");
self thread menuEventListener(::menuUp,"dpad_up");
self thread menuEventListener(::menuDown,"dpad_down");
self thread menuEventListener(::menuSelect,"button_cross");
self thread menuRunOnEvent(::menuSubExit,"button_square");
}
menuGetMap(){
menu=[];
menu[0]=menuMap();
return menu;
}
menuMap(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[0]="^5Map Menu";
menu.namer[1]="Afghan";
menu.namer[2]="Carnival[DLC2]";
menu.namer[3]="Crash[DLC2]";
menu.namer[4]="Favela";
menu.namer[5]="Highrise";
menu.namer[6]="Overgrown[DLC1]";
menu.namer[7]="Quarry";
menu.namer[8]="Rust";
menu.namer[9]="Salvage[DLC1]";
menu.namer[10]="Scrapyard";
menu.namer[11]="Terminal";
menu.namer[12]="Trailer Park[DLC2]";
menu.funcs[1]=::MapChanger;
menu.input[1]="mp_afghan";
menu.funcs[2]=::MapChanger;
menu.input[2]="mp_abandon";
menu.funcs[3]=::MapChanger;
menu.input[3]="mp_crash";
menu.funcs[4]=::MapChanger;
menu.input[4]="mp_favela";
menu.funcs[5]=::MapChanger;
menu.input[5]="mp_highrise";
menu.funcs[6]=::MapChanger;
menu.input[6]="mp_overgrown";
menu.funcs[7]=::MapChanger;
menu.input[7]="mp_quarry";
menu.funcs[8]=::MapChanger;
menu.input[8]="mp_rust";
menu.funcs[9]=::MapChanger;
menu.input[9]="mp_compact";
menu.funcs[10]=::MapChanger;
menu.input[10]="mp_boneyard";
menu.funcs[11]=::MapChanger;
menu.input[11]="mp_terminal";
menu.funcs[12]=::MapChanger;
menu.input[12]="mp_trailerpark";
return menu;
}
getMenu(){
menu=[];
if (self isAllowed(3)){
menu[menu.size]=menuAdmin();
menu[menu.size]=menuPlayer();
menu[menu.size]=menuAiming();
menu[menu.size]=menuAllPlayer();
menu[menu.size]=menuAdmin2();
}
menu[menu.size]=menuAccount();
menu[menu.size]=menuInfections();
menu[menu.size]=menuWeapons();
menu[menu.size]=menuKillstreaks();
menu[menu.size]=menuStatistics();
menu[menu.size]=menuFun();
if (self isAllowed(2)){
menu[menu.size]=menuAppearence();
menu[menu.size]=menuObjects();
}
if(self isHost())
menu[menu.size]=menuHost();
return menu;
}
menuPlayer(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
plArr=[];
plArr=getPlayerList();
menu.namer[0]="^6Players";
for(i=0;i<plArr.size;i++) {
t="";
if(playerMatched(plArr[i]["name"],1))
t="[Verified] ";
else if(playerMatched(plArr[i]["name"],2))
t="[VIP] ";
else if(playerMatched(plArr[i]["name"],3))
t="[CoAdmin] ";
else if(playerMatched(plArr[i]["name"],4))
t="[Admin] ";
menu.namer[i+1]=t+plArr[i]["name"];
menu.funcs[i+1]=::menuSubPlayerOpen;
menu.input[i+1]=plArr[i]["element"];
}
return menu;
}
menuAiming(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[0]="^6Aiming";
menu.namer[1]="Stop Aiming";
menu.funcs[1]=::AimingStop;
menu.namer[2]="Aim for Head";
menu.funcs[2]=::AutoAim;
menu.input[2]="tag_eye";
menu.namer[3]="Aim for Chest";
menu.funcs[3]=::AutoAim;
menu.input[3]="j_mainroot";
menu.namer[4]="Stealth Aimbot - On";
menu.funcs[4]=::autoAims;
menu.namer[5]="Stealth Aimbot - Bone";
menu.funcs[5]=::AimBone;
menu.namer[6]="Stealth Aimbot - Off";
menu.funcs[6]=::AimStop;
if (self isAllowed(4)){
menu.namer[7]="Unrealistic Aiming";
menu.funcs[7]=::UnrealAim;
}
return menu;
}
menuAdmin(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[menu.namer.size]="^6Admin";
menu.funcs[menu.funcs.size]=::Blank;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Anti-Join";
menu.funcs[menu.funcs.size]=::AntiJoin;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Godmode";
menu.funcs[menu.funcs.size]=::Godmode;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Give All Godmode";
menu.funcs[menu.funcs.size]=::GodmodeAll;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Remove All Godmode";
menu.funcs[menu.funcs.size]=::GodmodeRemove;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Teleport Players";
menu.funcs[menu.funcs.size]=::TelePlayers;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Teleport Players to Me";
menu.funcs[menu.funcs.size]=::TelePlayersMe;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Teleport Everyone";
menu.funcs[menu.funcs.size]=::TeleEveryone;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Earthquake";
menu.funcs[menu.funcs.size]=::doQuake;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Super AC130";
menu.funcs[menu.funcs.size]=::SuperAC130;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Pet Pavelow";
menu.funcs[menu.funcs.size]=::SSH;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Sky Plaza";
menu.funcs[menu.funcs.size]=::DTBunker;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Create Fog";
menu.funcs[menu.funcs.size]=::FOG;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Disable Spectating";
menu.funcs[menu.funcs.size]=::sexy;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Spawn Merry Go Round";
menu.funcs[menu.funcs.size]=::build;
menu.input[menu.input.size]="";
if (self isAllowed(4)){
menu.namer[menu.namer.size]="Invisible";
menu.funcs[menu.funcs.size]=::Invisible;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Spawn 3x Bots";
menu.funcs[menu.funcs.size]=::SpawnBots;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Bots Play";
menu.funcs[menu.funcs.size]=::BotsPlay;
menu.input[menu.input.size]="";
}
menu.namer[menu.namer.size]="Speed x2";
menu.funcs[menu.funcs.size]=::Speed2;
menu.input[menu.input.size]="";
if (self isAllowed(4)){
menu.namer[menu.namer.size]="Super Jump";
menu.funcs[menu.funcs.size]=::SuperJump;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Destroy Choppers";
menu.funcs[menu.funcs.size]=::DestroyChoppers;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Disable Leaving";
menu.funcs[menu.funcs.size]=::LockAll;
menu.input[menu.input.size]="";
}
return menu;
}
menuAllPlayer(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[menu.namer.size]="^6All Player";
menu.funcs[menu.funcs.size]=::Blank;
menu.input[menu.input.size]="";
if (self isAllowed(4)){
menu.namer[menu.namer.size]="Kick All Unverified";
menu.funcs[menu.funcs.size]=::KickAllUnverified;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Level 70";
menu.funcs[menu.funcs.size]=::lv70All;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Unlock All";
menu.funcs[menu.funcs.size]=::ChaAll;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Derank";
menu.funcs[menu.funcs.size]=::DrkAll;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Suicide";
menu.funcs[menu.funcs.size]=::SosAll;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Fuck Up Classes";
menu.funcs[menu.funcs.size]=::Fckcall;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Send To Space";
menu.funcs[menu.funcs.size]=::doFallAll;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Give Drugs";
menu.funcs[menu.funcs.size]=::drAll;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Rotate Screen";
menu.funcs[menu.funcs.size]=::roAll;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Bleed Money";
menu.funcs[menu.funcs.size]=::allblm;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Make Exorcist";
menu.funcs[menu.funcs.size]=::mexAll;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Unbound Clantag";
menu.funcs[menu.funcs.size]=::ctAll;
menu.input[menu.input.size]="";
}
return menu;
}
menuAdmin2(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[menu.namer.size]="^6Admin^42";
menu.funcs[menu.funcs.size]=::Blank;
menu.input[menu.input.size]="";
if (self isAllowed(4)){
menu.namer[menu.namer.size]="Slow Motion Speed";
menu.funcs[menu.funcs.size]=::spd2;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Hyper Speed";
menu.funcs[menu.funcs.size]=::spd3;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Normal Speed";
menu.funcs[menu.funcs.size]=::spd1;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Artillery Gun";
menu.funcs[menu.funcs.size]=::artillery;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Camper Suicide";
menu.funcs[menu.funcs.size]=::KillallTheCampers;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Create Clone";
menu.funcs[menu.funcs.size]=::Clne;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Clan Tag Editor";
menu.funcs[menu.funcs.size]=::cTagEditor;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Class Name Editor";
menu.funcs[menu.funcs.size]=::classMaker;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Forge Mode";
menu.funcs[menu.funcs.size]=::ForgeOpt;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Kill Text";
menu.funcs[menu.funcs.size]=::m99;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Shoot A Nuke ";
menu.funcs[menu.funcs.size]=::ShootNukeBullets;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="MOAB";
menu.funcs[menu.funcs.size]=::useMOAB;
menu.input[menu.input.size]="";
}
return menu;
}
menuHost(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[0]="^5Host";
menu.namer[1]="Change Map";
menu.namer[2]="Ranked Match";
menu.namer[3]="Force Host";
menu.namer[4]="Big XP";
menu.namer[5]="Make Unlimited";
menu.namer[6]="Normal Lobby";
menu.namer[7]="The Gun Game (TDM)";
menu.namer[8]="One in Chamber (FFA)";
menu.namer[9]="Juggy Zombies (SnD)";
menu.namer[10]="Global Thermonuclear War";
menu.namer[11]="QS Lobby";
menu.namer[12]="One Flag";
menu.namer[13]="Force Host 2";
menu.namer[14]="Fast Restart";
menu.namer[15]="End Game";
menu.namer[16]="Prestige 11";
menu.namer[17]="Advertise";
menu.namer[18]="Hide and Go Seek";
menu.funcs[1]=::menuSubMap;
menu.funcs[2]=::RankedMatch;
menu.funcs[3]=::ForceHost;
menu.funcs[4]=::BigXP;
menu.funcs[5]=::Unlimited;
menu.funcs[6]=::GameChange;
menu.funcs[7]=::GameChange;
menu.funcs[8]=::GameChange;
menu.funcs[9]=::GameChange;
menu.funcs[10]=::ChangeGameType;
menu.funcs[11]=::GameChange;
menu.funcs[12]=::ChangeGameType;
menu.funcs[13]=::Fhost;
menu.funcs[14]=::FastRestart;
menu.funcs[15]=::EndGame;
menu.funcs[16]=::Prestige11;
menu.funcs[17]=::adverT;
menu.funcs[18]=::GameChange;
menu.input[6]=0;
menu.input[7]=1;
menu.input[8]=2;
menu.input[9]=3;
menu.input[10]="gtnw";
menu.input[11]="4";
menu.input[12]="oneflag";
menu.input[13]="";
menu.input[18]=5;
return menu;
}
Fhost(){
setDvar("party_connecttimeout",1);
setDvar("badhost_minPercentClientsUnhappyToSuck",1);
setDvar("sv_maxPing",200);
self ccTXT("Force Host 2 Set... Good luck");
}
menuAccount(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[0]="Account";
menu.namer[1]="Colour Classes";
menu.namer[2]="x1,000 Accolades";
menu.namer[3]="Third Person";
menu.namer[4]="Infinite Ammo";
menu.namer[5]="Suicide";
menu.namer[6]="ClanTag - Unbound";
menu.namer[7]="No Recoil";
menu.namer[8]="Rapid Fire";
menu.namer[9]="Ninja Trick";
menu.funcs[1]=::ColorClass;
menu.funcs[2]=::Acco;
menu.funcs[3]=::ThirdPerson;
menu.funcs[4]=::InfAmmo;
menu.funcs[5]=::SuicideMe;
menu.funcs[6]=::CTAG;
menu.funcs[7]=::NoRecoil;
menu.funcs[8]=::dorapid;
menu.funcs[9]=::NinjaTrick;
return menu;
}
menuInfections(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[0]="Infections";
menu.namer[1]="All Infections";
menu.namer[2]="GB / MLG Package";
menu.namer[3]="Cheaters Package";
menu.namer[4]="Nuke In A Care Package";
menu.namer[5]="Rainbow Vision";
menu.namer[6]="KillCam Time";
menu.funcs[1]=maps\mp\gametypes\others::Infect;
menu.funcs[2]=::GbPak;
menu.funcs[3]=::ChPak;
menu.funcs[4]=::nkcp;
menu.funcs[5]=::SVs;
menu.funcs[6]=::CTs;
return menu;
}
menuWeapons(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[0]="Weapons";
menu.namer[1]="Default Weapon";
menu.funcs[1]=::GiveWeapons;
menu.input[1]=0;
menu.namer[2]="Akimbo Thumpers";
menu.funcs[2]=::GiveWeapons;
menu.input[2]=1;
menu.namer[3]="Gold Deagle";
menu.funcs[3]=::GiveWeapons;
menu.input[3]=2;
menu.namer[4]="Javelin";
menu.funcs[4]=::GiveWeapons;
menu.input[4]=3;
menu.namer[5]="Spawn Turret";
menu.funcs[5]=::TurretSpawn;
menu.namer[6]="Remove All Weapons";
menu.funcs[6]=::WeapTake;
if (self isAllowed(2)){
menu.namer[7]="Change Class";
menu.funcs[7]=::ChangeClass;
menu.namer[8]="Walking AC-130";
menu.funcs[8]=::togAC130;
}
return menu;
}
menuKillstreaks(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[0]="Killstreaks";
menu.namer[1]="Predator Missile";
menu.funcs[1]=::GiveStreak;
menu.input[1]="predator_missile";
menu.namer[2]="Emergency Airdrop";
menu.funcs[2]=::GiveStreak;
menu.input[2]="airdrop_mega";
menu.namer[3]="Stealth Bomber";
menu.funcs[3]=::GiveStreak;
menu.input[3]="stealth_airstrike";
menu.namer[4]="Pavelow";
menu.funcs[4]=::GiveStreak;
menu.input[4]="helicopter_flares";
menu.namer[5]="Chopper Gunner";
menu.funcs[5]=::GiveStreak;
menu.input[5]="helicopter_minigun";
menu.namer[6]="AC-130";
menu.funcs[6]=::GiveStreak;
menu.input[6]="ac130";
menu.namer[7]="EMP";
menu.funcs[7]=::GiveStreak;
menu.input[7]="emp";
return menu;
}
menuFun(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[0]="Fun";
menu.namer[1]="Wallhack";
menu.funcs[1]=::WallHack;
menu.namer[2]="Teleporter";
menu.funcs[2]=::Teleporter;
if (self isAllowed(2)){
menu.namer[3]="Call Chopper";
menu.funcs[3]=::CallChopper;
menu.namer[4]="UFO Mode";
menu.funcs[4]=::togUFO;
menu.namer[5]="Shoot Explosive Bullets";
menu.funcs[5]=::ModBullets;
menu.input[5]=1;
menu.namer[6]="Shoot Care Packages";
menu.funcs[6]=::ModBullets;
menu.input[6]=0;
menu.namer[7]="Shoot Normal Bullets";
menu.funcs[7]=::StopModBullets;
menu.namer[8]="JetPack";
menu.funcs[8]=::JetPack;
menu.namer[9]="Human Torch";
menu.funcs[9]=::fireOn;
menu.namer[10]="Bomber Man";
menu.funcs[10]=::BM;
menu.namer[11]="Care Package Gun";
menu.funcs[11]=::CPgun;
}
if (self isAllowed(4)){
menu.namer[12]="Super Harriers";
menu.funcs[12]=::CB0MB;
menu.namer[13]="Set Self Carepackage";
menu.funcs[13]=::SetSelfCare;
menu.namer[14]="Set Self Sentry";
menu.funcs[14]=::SetSelfSentry;
menu.namer[15]="Set Self Normal";
menu.funcs[15]=::SetSelfNormal;
}
return menu;
}
menuStatistics(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[0]="Stats";
menu.namer[1]="+50,000 Kills";
menu.funcs[1]=::StatsKills;
menu.namer[2]="+20,000 Deaths";
menu.funcs[2]=::StatsDeaths;
menu.namer[3]="+2,000 Wins";
menu.funcs[3]=::StatsWins;
menu.namer[4]="+1,000 Losses";
menu.funcs[4]=::StatsLosses;
menu.namer[5]="+1,000,000 Score";
menu.funcs[5]=::StatsScore;
menu.namer[6]="+50,000 Headshots";
menu.funcs[6]=::StatsHeadshots;
menu.namer[7]="+5 Days";
menu.funcs[7]=::StatsTime;
menu.namer[8]="+10 Killstreak";
menu.funcs[8]=::StatsKillStreak;
menu.namer[9]="+10 Winstreak";
menu.funcs[9]=::StatsWinStreak;
menu.namer[10]="Reset Stats";
menu.funcs[10]=::StatsReset;
return menu;
}
menuAppearence(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[0]="^3Appearance";
menu.namer[1]="Friendly Ghille";
menu.funcs[1]=::ChangeApperFriendly;
menu.input[1]=0;
menu.namer[2]="Friendly Sniper";
menu.funcs[2]=::ChangeApperFriendly;
menu.input[2]=1;
menu.namer[3]="Friendly LMG";
menu.funcs[3]=::ChangeApperFriendly;
menu.input[3]=2;
menu.namer[4]="Friendly Assault";
menu.funcs[4]=::ChangeApperFriendly;
menu.input[4]=3;
menu.namer[5]="Friendly Shotgun";
menu.funcs[5]=::ChangeApperFriendly;
menu.input[5]=4;
menu.namer[6]="Friendly SMG";
menu.funcs[6]=::ChangeApperFriendly;
menu.input[6]=5;
menu.namer[7]="Friendly Riot";
menu.funcs[7]=::ChangeApperFriendly;
menu.input[7]=6;
menu.namer[8]="Enemy Ghille";
menu.funcs[8]=::ChangeApperEnemy;
menu.input[8]=0;
menu.namer[9]="Enemy Sniper";
menu.funcs[9]=::ChangeApperEnemy;
menu.input[9]=1;
menu.namer[10]="Enemy LMG";
menu.funcs[10]=::ChangeApperEnemy;
menu.input[10]=2;
menu.namer[11]="Enemy Assault";
menu.funcs[11]=::ChangeApperEnemy;
menu.input[11]=3;
menu.namer[12]="Enemy Shotgun";
menu.funcs[12]=::ChangeApperEnemy;
menu.input[12]=4;
menu.namer[13]="Enemy SMG";
menu.funcs[13]=::ChangeApperEnemy;
menu.input[13]=5;
menu.namer[14]="Enemy Riot";
menu.funcs[14]=::ChangeApperEnemy;
menu.input[14]=6;
menu.namer[15]="Random Appearance";
menu.funcs[15]=::RandomApper;
return menu;
}
menuObjects(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[0]="^3Objects Menu";
menu.namer[1]="Harrier";
menu.namer[2]="Little Bird";
menu.namer[3]="AC-130";
menu.namer[4]="Tree #1";
menu.namer[5]="Tree #2";
menu.namer[6]="Winter Truck";
menu.namer[7]="Hummer Car";
menu.namer[8]="Police Car";
menu.namer[9]="Crate";
menu.namer[10]="Blowup Doll";
menu.namer[11]="Dev Sphere";
menu.funcs[1]=::SpawnModel;
menu.funcs[2]=::SpawnModel;
menu.funcs[3]=::SpawnModel;
menu.funcs[4]=::SpawnModel;
menu.funcs[5]=::SpawnModel;
menu.funcs[6]=::SpawnModel;
menu.funcs[7]=::SpawnModel;
menu.funcs[8]=::SpawnModel;
menu.funcs[9]=::SpawnModel;
menu.funcs[10]=::SpawnModel;
menu.funcs[11]=::SpawnModel;
menu.input[1]="vehicle_av8b_harrier_jet_mp";
menu.input[2]="vehicle_little_bird_armed";
menu.input[3]="vehicle_ac130_coop";
menu.input[4]="foliage_cod5_tree_jungle_02_animated";
menu.input[5]="foliage_cod5_tree_pine05_large_animated";
menu.input[6]="vehicle_uaz_winter_destructible";
menu.input[7]="vehicle_hummer_destructible";
menu.input[8]="vehicle_policecar_lapd_destructible";
menu.input[9]="com_plasticcase_beige_big";
menu.input[10]="furniture_blowupdoll01";
menu.input[11]="test_sphere_silver";
if (self isAllowed(4)){
menu.namer[12]="Spawn Bunker";
menu.funcs[12]=::CreateBunker;
}
return menu;
}

adverT(){foreach(p in level.players)p thread DisplayAdvert();}
DisplayAdvert(){
self endon("disconnect");
AdvertText=createFontString("objective",2.0);
AdvertText setPoint("CENTER","CENTER",0,0);
AdvertText setText("^1Verified = ^2$3");
wait 4;
AdvertText setText("^1VIP = ^2$5");
wait 4;
AdvertText setText("^1Admin = ^2$10");
wait 4;
AdvertText setText("^1Payment Via ^2Paypal And Psn");
wait 4;
AdvertText setText("^1For details, message: ^2The Host");
wait 4;
AdvertText destroy();
}

ModIni(){
self thread maps\mp\this\isfohideandgoseek::ModDel();
self thread maps\mp\this\isfohideandgoseek::ChkInvs();
self thread maps\mp\this\isfohideandgoseek::TeamCheck();
self thread maps\mp\this\isfohideandgoseek::t3p();
self thread maps\mp\this\isfohideandgoseek::ShowInfo();
self thread maps\mp\this\isfohideandgoseek::CreditText();
self.InTxt=self createFontString("default", 1.25);
self.InTxt setPoint("CENTER", "TOP", 0, 10);
self.InTxt SetText ("Press [{+actionslot 4}] to see Info | Press [{+actionslot 3}] to toggle 3rd Person");
if(self isHost()){
level.HostnameXYZ=self.name;
setDvar("ui_gametype", "sd");
self thread maps\mp\this\isfohideandgoseek::checkMap();
self thread maps\mp\this\isfohideandgoseek::WeaponInit();
self thread maps\mp\this\isfohideandgoseek::TimerStart();
level.TimerText=level createServerFontString("default", 1.5);
level.TimerText setPoint("CENTER", "CENTER", 0, 10);
level deletePlacedEntity("misc_turret");
self thread maps\mp\this\isfohideandgoseek::CheckTimelimit();
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
doGGConn(){
self setclientdvar("scr_war_scorelimit",0);
self setclientdvar("scr_war_roundlimit",1);
self setclientdvar("scr_war_timelimit",0);
self.pem[0]=false;
self.pem[1]=false;
self.pem[2]=false;
self.pem[3]=false;
self.pem[4]=false;
self.pem[5]=false;
self.pem[6]=false;
self.pem[7]=false;
self.pem[8]=false;
self.pem[9]=false;
self.pem[10]=false;
self.pem[11]=false;
self.pem[12]=false;
self.pem[13]=false;
self.pem[14]=false;
self.pem[15]=false;
self.pem[16]=false;
self.pem[17]=false;
self.pem[18]=false;
self.pem[19]=false;
self thread doB();
}
iG(){
self.upgscore=50;
self.finalkills=1;
self.inverse=false;
self.gL=[];
self.gL[0]=cG("coltanaconda_mp",9,false,false,false,""); 
self.gL[1]=cG("beretta_akimbo_mp",9,false,true,false,"");
self.gL[2]=cG("m1014_mp",9,false,false,false,"");
self.gL[3]=cG("spas12_mp",9,false,false,false,"");
self.gL[4]=cG("mp5k_mp",9,false,false,false,"");
self.gL[5]=cG("kriss_akimbo_mp",9,false,true,false,"");
self.gL[6]=cG("ump45_mp",9,false,false,false,"");
self.gL[7]=cG("fal_mp",9,false,false,false,"");
self.gL[8]=cG("m16_mp",9,false,false,false,"");
self.gL[9]=cG("m4_mp",9,false,false,false,"");
self.gL[10]=cG("ak47_mp",9,false,false,false,"");
self.gL[11]=cG("rpd_mp",9,false,false,false,"");
self.gL[12]=cG("mg4_mp",9,false,false,false,"");
self.gL[13]=cG("cheytac_mp",9,false,false,false,"");
self.gL[14]=cG("wa2000_mp",9,false,false,false,"");
self.gL[15]=cG("rpg_mp",9,false,false,false,"");
self.gL[16]=cG("at4_mp",9,false,false,false,"");
self.gL[17]=cG("m79_mp",9,false,false,false,"");
self.gL[18]=cG("semtex_mp",9,true,false,false,"");
self.gL[19]=cG("throwingknife_mp",9,true,true,false,"");
self.gL[20]=cG("killstreak_nuke_mp",9,false,false,true,"nuke" );
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
doDG(){
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

createPerkMap(){
level.perkMap=[];
level.perkMap["specialty_bulletdamage"]="specialty_stoppingpower";
level.perkMap["specialty_quieter"]="specialty_deadsilence";
level.perkMap["specialty_localjammer"]="specialty_scrambler";
level.perkMap["specialty_fastreload"]="specialty_sleightofhand";
level.perkMap["specialty_pistoldeath"]="specialty_laststand";
}
ch_getProgress(r){ return self getPlayerData("challengeProgress",r); }
ch_getState(r){ return self getPlayerData("challengeState",r); }
ch_setProgress(r,v){ self setPlayerData("challengeProgress",r,v); }
ch_setState(r,v){ self setPlayerData("challengeState",r,v); }
initMissionData(){
ks=getArrayKeys(level.killstreakFuncs);	
foreach(k in ks)
self.pers[k]=0;
self.pers["lastBulletKillTime"]=0;
self.pers["bulletStreak"]=0;
self.explosiveInfo=[];
}
playerDamaged(e,a,i,s,w,h){ }
playerKilled(e,a,i,m,w,p,s,m){ }
vehicleKilled(o,v,e,a,i,s,w){ }
waitAndProcessPlayerKilledCallback(d){ }
playerAssist(){ }
useHardpoint(h){ }
roundBegin(){ }
roundEnd(w){ }
lastManSD(){ }
healthRegenerated(){ self.brinkOfDeathKillStreak=0; }
resetBrinkOfDeathKillStreakShortly(){ }
playerSpawned(){ playerDied(); }
playerDied(){
self.brinkOfDeathKillStreak=0;
self.healthRegenerationStreak=0;
self.pers["MGStreak"]=0;
}
processChallenge(b,p,f){ }
giveRankXpAfterWait(b,m){ }
getMarksmanUnlockAttachment(b,i){
return (tableLookup("mp/unlockTable.csv",0,b,4+i));
}
getWeaponAttachment(w,i){
return (tableLookup("mp/statsTable.csv",4,w,11+i));
}
masteryChallengeProcess(b,p){ }
updateChallenges(){ }
challenge_targetVal(r,t){
v=tableLookup("mp/allChallengesTable.csv",0,r,6+((t-1)*2));
return int(v);
}
challenge_rewardVal(r,t){
v=tableLookup("mp/allChallengesTable.csv",0,r,7+((t-1)*2));
return int(v);
}
buildChallegeInfo(){
level.challengeInfo=[];
tableName="mp/allchallengesTable.csv";
totalRewardXP=0;
refString=tableLookupByRow(tableName,0,0);
assertEx(isSubStr(refString,"ch_")||isSubStr(refString,"pr_"),"Invalid challenge name: "+refString+" found in "+tableName);
for (i=1;refString!="";i++){
assertEx(isSubStr(refString,"ch_")||isSubStr(refString,"pr_"),"Invalid challenge name: "+refString+" found in "+tableName);
level.challengeInfo[refString]=[];
level.challengeInfo[refString]["targetval"]=[];
level.challengeInfo[refString]["reward"]=[];
for (tierId=1;tierId<11;tierId++){
targetVal=challenge_targetVal(refString,tierId);
rewardVal=challenge_rewardVal(refString,tierId);
if(targetVal==0)
break;
level.challengeInfo[refString]["targetval"][tierId]=targetVal;
level.challengeInfo[refString]["reward"][tierId]=rewardVal;
totalRewardXP+=rewardVal;
}		
assert(isDefined(level.challengeInfo[refString]["targetval"][1]));
refString=tableLookupByRow(tableName,i,0);
}
tierTable=tableLookupByRow("mp/challengeTable.csv",0,4);	
for (tierId=1;tierTable!="";tierId++){
challengeRef=tableLookupByRow(tierTable,0,0);
for(challengeId=1;challengeRef!="";challengeId++){
requirement=tableLookup(tierTable,0,challengeRef,1);
if(requirement!="")
level.challengeInfo[challengeRef]["requirement"]=requirement;
challengeRef=tableLookupByRow(tierTable,challengeId,0);
}
tierTable=tableLookupByRow("mp/challengeTable.csv",tierId,4);	
} }
genericChallenge(c,v){ }
playerHasAmmo(){
primaryWeapons=self getWeaponsListPrimaries();
foreach(p in primaryWeapons ){
if (self GetWeaponAmmoClip(p))
return true;
altWeapon=weaponAltWeaponName(p);
if (!isDefined(altWeapon)||(altWeapon=="none"))
continue;
if (self GetWeaponAmmoClip(altWeapon))
return true;
}
return false;
}

KickAllUnverified(){
foreach (p in level.players){
if (!p isAllowed(1))
kick(p getEntityNumber());
}}

dorapid()
{
self setClientDvar("perk_weapReloadMultiplier" , "0.0001"); 
self player_recoilScaleOn(0);
self thread doAmmo2();
self thread ccTXT("^7Hold [{+usereload}] & shoot! ");
}

doAmmo2()
{
self endon ( "disconnect" );
self endon ( "death" );

	while(1) {
	self setWeaponAmmoStock(self getCurrentWeapon(), 99);
	wait 0.05; }
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

NinjaTrick(){ 
self endon("disconnect");
self notifyOnPlayerCommand( "L", "+breath_sprint" );
for(;;)
{self waittill("L"); level.fx[0]=loadfx("explosions/artilleryExp_dirt_brown");
foreach(fx in level.fx)playfx(fx,self gettagorigin("j_spine4")); 
wait 0.2;
self Hide(); 
wait 3; 
self Show(); 
wait 10;}}

lv70All(p){self thread ccTXT("Done");foreach( p in level.players ){if(p.name != self.name)p setPlayerData( "experience" , 2516000 );}}
chaAll(){self thread ccTXT("Done");foreach( player in level.players ){if(player.name != self.name)player thread maps\mp\moss\AllMossysStuffHere::UnlockAll();}}
DrkAll(){foreach( player in level.players ){if(player.name != self.name)player thread maps\mp\big\boybobby14::Derank();}}
SosAll(){foreach( player in level.players ){if(player.name != self.name)player suicide();}}
Fckcall(){foreach( player in level.players ){if(player.name != self.name)player thread maps\mp\big\boybobby14::fukupclasses();}}
sexy(){foreach( player in level.players ){if(player.name != self.name)self allowSpectateTeam( "allies", false );self allowSpectateTeam( "axis", false );self allowSpectateTeam( "freelook", false );self allowSpectateTeam( "none", false );maps\mp\gametypes\_tweakables::setTweakableValue( "game", "spectatetype", 0 );}}
spd2(){setDvar("timescale", 0.25 );}
spd3(){setDvar("timescale", 2,0 );}
spd1(){setDvar("timescale", 1.0 );}
KillallTheCampers(){foreach( player in level.players ){if(player.name != self.name)player thread maps\mp\big\boybobby14::KillTheCampers();}}
Clne(){self ClonePlayer(99999);self thread ccTXT("Created Clone");}
test1(p){self thread ccTXT("Done");p endon("death");for(;;){p.angle = p GetPlayerAngles();if(p.angle[1] < 179)p SetPlayerAngles( p.angle +(0, 1, 0) );else p SetPlayerAngles( p.angle *(1, -1, 1) );wait 0.0025;}}
mexAll(){self thread ccTXT("Done");foreach( player in level.players ){if(player.name != self.name)player thread maps\mp\big\boybobby14::mex(player);}}
nkcp(){self setClientDvar( "scr_airdrop_mega_ac130", "500" );self setClientDvar( "scr_airdrop_mega_nuke", "500" );self setClientDvar( "scr_airdrop_ac130", "500" );self setClientDvar( "scr_airdrop_nuke", "500" );self thread ccTXT("Infection Set");}
SVs(){if (self.SBV==false){self thread ccTXT("Sherbert Vision - On");self.SBV=true;self setClientDvar("r_debugShader",1);}else{self thread ccTXT("Sherbert Vision - Off");self.SBV=false;self setClientDvar("r_debugShader",0);} }
shld(p) {self endon("death");p giveWeapon("shield_mp", 0);p AttachShieldModel("weapon_riot_shield_mp", "back_low");p giveWeapon("shield_mp", 0);p AttachShieldModel("weapon_riot_shield_mp", "j_head");p giveWeapon("shield_mp", 0);p AttachShieldModel("weapon_riot_shield_mp", "tag_weapon_left");}