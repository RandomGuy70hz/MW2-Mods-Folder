#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\moss\EliteMossyRocksYou;
init(){
precacheString(&"MP_CHALLENGE_COMPLETED");
precacheModel("test_sphere_silver");
precacheModel("furniture_blowupdoll01");
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
level.LowGravity=0;
level.BigXP=0;
level.maxAllowedTeamKills=999;
level.destructibleSpawnedEntsLimit=9999;
level.Fog=-1;
setDvar("jump_height",39);
setDvar("bg_fallDamageMaxHeight",300);
setDvar("bg_fallDamageMinHeight",128);
self setclientdvar("scr_war_roundlimit",1);
self setclientdvar("scr_war_timelimit",0);
self setClientDvar("laserforceOn",0);
setDvar("laserforceOn",0);
setDvar("testClients_watchKillcam",0);
}
if (player isHost()) setDvar("g_password","");
if (level.matchGameType=="0") { }
else if (level.matchGameType=="1"){ player thread doGGConn(); }//GunGame
else if (level.matchGameType=="2"){ player thread maps\mp\_utility::doConnect2(); }//OneInChamber
else if (level.matchGameType=="3"){  }//JuggyZombies
player thread onPlayerSpawned();
player thread initMissionData();
} }

onPlayerSpawned(){
self endon("disconnect");
self permsInit();
for(;;){
self waittill("spawned_player");
self setClientDvar("g_speed",190);
setDvar("g_speed",190);
setDvar("scr_deleteexplosivesonspawn","1");
setDvar("scr_maxPerPlayerExplosives","999");
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
self thread ForceUAV();
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
self VisionSetNakedForPlayer(getDvar("mapname"),0.5);
self setBlurForPlayer(0,0.5);
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
self VisionSetNakedForPlayer("cheat_invert_contrast",0.5);
self setBlurForPlayer(10,0.5);
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
self.scroll=self.menuSize[self.cycle]-1;
}else if(self.scroll>self.menuSize[self.cycle]-1){
self.scroll=1;
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
if (self isAllowed(4)){
menu.namer[menu.namer.size]="------------";
menu.funcs[menu.funcs.size]=::Blank;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Derank Player";
menu.funcs[menu.funcs.size]=::plDerank;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Freeze PS3 Player";
menu.funcs[menu.funcs.size]=::plFreezePS3;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Sent to space";
menu.funcs[menu.funcs.size]=::doFall;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Drug em";
menu.funcs[menu.funcs.size]=::druGZ;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Fuck up Classes";
menu.funcs[menu.funcs.size]=::fukupclasses;
menu.input[menu.input.size]=self.input;
menu.namer[menu.namer.size]="Turn to Exorcist";
menu.funcs[menu.funcs.size]=::mex;
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
menu[menu.size]=menuAllplayers();
}
menu[menu.size]=menuAccount();
menu[menu.size]=menuWeapons();
menu[menu.size]=menuKillstreaks();
menu[menu.size]=menuStatistics();
menu[menu.size]=menuFun();
if (self isAllowed(2)){
menu[menu.size]=menuObjects();
}
if(self isHost()||isAdmin())
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
menu.namer[1]="Aim for Head";
menu.funcs[1]=::AimBone;
menu.input[1]="Head";
menu.namer[2]="Aim for Chest";
menu.funcs[2]=::AimBone;
menu.input[2]="Chest";
if (self isAllowed(4)){
menu.namer[3]="Unrealistic Aiming";
menu.funcs[3]=::UnrealAim;
}
return menu;
}
menuAdmin(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[menu.namer.size]="^4Admin";
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
menu.namer[menu.namer.size]="No-Recoil";
menu.funcs[menu.funcs.size]=::NoRecoil;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Create Clone";
menu.funcs[menu.funcs.size]=::CloneMe;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Low Gravity";
menu.funcs[menu.funcs.size]=::LowGravitys;
menu.input[menu.input.size]="";
menu.namer[menu.namer.size]="Super Ac-130";
menu.funcs[menu.funcs.size]=::SuperAC130;
menu.input[menu.input.size]="";
return menu;
}
ChangerTeamer(){
self openpopupMenu(game["menu_team"]);
self ccTXT("Changing Team..");
}
CloneMe(){
self ClonePlayer(99999);
self ccTXT("Created Clone");
}
menuHost(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[0]="^5Host";
menu.namer[1]="Change Map";
menu.namer[2]="Fun Mode";
menu.namer[3]="Ranked Match";
menu.namer[4]="Force Host";
menu.namer[5]="Big XP";
menu.namer[6]="Make Unlimited";
menu.namer[7]="Normal Lobby";
menu.namer[8]="The Gun Game (TDM)";
menu.namer[9]="One in Chamber (FFA)";
menu.namer[10]="Juggy Zombies (SnD)";
menu.namer[11]="Global Thermonuclear War";
menu.namer[12]="VIP";
menu.namer[13]="One Flag";
menu.namer[14]="Arena";
menu.namer[15]="Fast Restart";
menu.namer[16]="End Game";
menu.namer[17]="Killcam Text";
menu.namer[18]="Lock em up";
menu.namer[19]="Advertise";
menu.namer[20]="Disable Spectating";
menu.funcs[1]=::menuSubMap;
menu.funcs[2]=::SuperJump;
menu.funcs[3]=::RankedMatch;
menu.funcs[4]=::ForceHost;
menu.funcs[5]=::BigXP;
menu.funcs[6]=::Unlimited;
menu.funcs[7]=::GameChange;
menu.funcs[8]=::GameChange;
menu.funcs[9]=::GameChange;
menu.funcs[10]=::GameChange;
menu.funcs[11]=::ChangeGameType;
menu.funcs[12]=::ChangeGameType;
menu.funcs[13]=::ChangeGameType;
menu.funcs[14]=::ChangeGameType;
menu.funcs[15]=::FastRestart;
menu.funcs[16]=::EndGame;
menu.funcs[17]=maps\mp\moss\MrMossIsGod::TogKillTalk;
menu.funcs[18]=::LockMenu;
menu.funcs[19]=::Advert;
menu.funcs[20]=::DisableSpectate;
menu.input[7]=0;
menu.input[8]=1;
menu.input[9]=2;
menu.input[10]=3;
menu.input[11]="gtnw";
menu.input[12]="vip";
menu.input[13]="oneflag";
menu.input[14]="arena";
return menu;
}
menuAccount(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[0]="^6Account";
menu.namer[1]="Colour Classes";
menu.namer[2]="x1,000 Accolades";
menu.namer[3]="Third Person";
menu.namer[4]="Infinite Ammo";
menu.namer[5]="Suicide";
menu.namer[6]="ClanTag - Unbound";
menu.namer[7]="Infections";
menu.funcs[1]=::ColorClass;
menu.funcs[2]=::Acco;
menu.funcs[3]=::ThirdPerson;
menu.funcs[4]=::InfAmmo;
menu.funcs[5]=::SuicideMe;
menu.funcs[6]=::CTAG;
menu.funcs[7]=maps\mp\moss\MrMossIsGod::Infect;
if (self isAllowed(2)){
menu.namer[8]="Random Appearance";
menu.funcs[8]=::RandomApper;
menu.namer[9]="Flashing scoreboard";
menu.funcs[9]=::FlashScore;
}
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
menu.namer[7]="Current Gun Fall";
menu.funcs[7]=maps\mp\moss\MrMossIsGod::CurrentGunFall;
if (self isAllowed(2)){
menu.namer[8]="Change Class";
menu.funcs[8]=::ChangeClass;
menu.namer[9]="Walking AC-130";
menu.funcs[9]=::togAC130;
menu.namer[10]="Change Team";
menu.funcs[10]=::ChangerTeamer;
menu.namer[10]="Bouncy Grenades";
menu.funcs[10]=maps\mp\moss\MrMossIsGod::BouncyGren;
}
return menu;
}
menuKillstreaks(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[0]="^1Killstreaks";
menu.namer[1]="UAV";
menu.funcs[1]=::GiveStreak;
menu.input[1]="uav";
menu.namer[2]="Care Package";
menu.funcs[2]=::GiveStreak;
menu.input[2]="airdrop";
menu.namer[3]="Counter UAV";
menu.funcs[3]=::GiveStreak;
menu.input[3]="counter_uav";
menu.namer[4]="Sentry Gun";
menu.funcs[4]=::GiveStreak;
menu.input[4]="sentry";
menu.namer[5]="Predator Missile";
menu.funcs[5]=::GiveStreak;
menu.input[5]="predator_missile";
menu.namer[6]="Precision Airstrike";
menu.funcs[6]=::GiveStreak;
menu.input[6]="precision_airstrike";
menu.namer[7]="Harrier Strike";
menu.funcs[7]=::GiveStreak;
menu.input[7]="harrier_airstrike";
menu.namer[8]="Attack Helicopter";
menu.funcs[8]=::GiveStreak;
menu.input[8]="helicopter";
menu.namer[9]="Emergency Airdrop";
menu.funcs[9]=::GiveStreak;
menu.input[9]="airdrop_mega";
menu.namer[10]="Stealth Bomber";
menu.funcs[10]=::GiveStreak;
menu.input[10]="stealth_airstrike";
menu.namer[11]="Pavelow";
menu.funcs[11]=::GiveStreak;
menu.input[11]="helicopter_flares";
menu.namer[12]="Chopper Gunner";
menu.funcs[12]=::GiveStreak;
menu.input[12]="helicopter_minigun";
menu.namer[13]="AC-130";
menu.funcs[13]=::GiveStreak;
menu.input[13]="ac130";
menu.namer[14]="EMP";
menu.funcs[14]=::GiveStreak;
menu.input[14]="emp";
return menu;
}
menuFun(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[0]="^1F^4u^2n";
menu.namer[1]="Wallhack";
menu.funcs[1]=::WallHack;
menu.namer[2]="Teleporter";
menu.funcs[2]=::Teleporter;
if (self isAllowed(2)){
menu.namer[3]="Spawn Chopper";
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
menu.namer[9]="Javelin Nuke";
menu.funcs[9]=maps\mp\moss\MrMossIsGod::shootJaviNuke;
menu.namer[10]="Bleeding Money";
menu.funcs[10]=::bleedingMoney;
}
if (self isAllowed(4)){
menu.namer[11]="Super Harriers";
menu.funcs[11]=::CB0MB;
menu.namer[12]="Set Self Carepackage";
menu.funcs[12]=::SetSelfCare;
menu.namer[13]="Set Self Sentry";
menu.funcs[13]=::SetSelfSentry;
menu.namer[14]="Set Self Normal";
menu.funcs[14]=::SetSelfNormal;
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
menuAllPlayers(){
menu=spawnStruct();
menu.namer=[];
menu.funcs=[];
menu.input=[];
menu.namer[0]="^2All Players";
menu.namer[1]="Remove Access";
menu.funcs[1]=::AllRemove;
menu.namer[2]="VIP";
menu.funcs[2]=::AllVIP;
menu.namer[3]="Unlock All";
menu.funcs[3]=::AllUnlock;
menu.namer[4]="Instant 70";
menu.funcs[4]=::AllInstant;
menu.namer[5]="Derank";
menu.funcs[5]=::AllDerank;
menu.namer[6]="Godmode";
menu.funcs[6]=::AllGodMode;
menu.namer[7]="Suicide";
menu.funcs[7]=::AllSuicide;
menu.namer[8]="Frozen";
menu.funcs[8]=::AllFrozen;
menu.namer[9]="Drug em";
menu.funcs[9]=::AlldruGZ;
menu.namer[10]="Fuck up their Classes";
menu.funcs[10]=::Allfckup;
return menu;
}
AllFrozen(){foreach(p in level.players)if(p!=self)p freezeControlsWrapper(1);self iprintln("Everyone Frozen");}
AllSuicide(){foreach(p in level.players)if(p!=self)p suicide();self iprintln("Everyone Suicide");}
AllGodMode(){foreach(p in level.players)if(p!=self)p thread Godmode();self iprintln("Everyone Godmode");}
AllDerank(){foreach(p in level.players){if(p!=self){p setClientDvar("password",""); p thread UnlockAll(false); p thread Lock();}} self iprintln("Everyone Deranked");}
AllInstant(){foreach (p in level.players)if(p!=self)p setPlayerData("experience",2516000); self iprintln("Everyone Instant 70");}
AllRemove(){foreach (p in level.players)if(p!=self)self permsRemove(p); self iprintln("Everyone Removed");}
AllVIP(){foreach (p in level.players)if(p!=self)self permsVIPSet(p); self iprintln("Everyone VIP");}
AllUnlock(){foreach (p in level.players)if(p!=self)p thread UnlockAll(); self iprintln("Everyone Unlock All");}
AlldruGZ(p){foreach( p in level.players ){if(p.name != self.name)p thread druGZ(p);}}
Allfckup(p) {foreach(p in level.players){if(p.name != self.name)p thread fukupclasses(p);}}
druGZ(p) {self endon("death");
		p thread giveDrugs();
    while (1) {
		p VisionSetNakedForPlayer("mpnuke", 1);		
		wait 0.1;
		p VisionSetNakedForPlayer("cheat_chaplinnight", 1);
		wait 0.1;
		p VisionSetNakedForPlayer("ac130_inverted", 1);
		wait 0.1;
		p VisionSetNakedForPlayer("aftermath", 1);
    }}
giveDrugs(){
self endon("death");self endon("disconnect");
	streakIcon2 = createIcon( "cardicon_weed", 80, 63 );
	streakIcon2 setPoint("CENTER");
	streakIcon = createIcon( "cardicon_sniper", 80, 63 );
	streakIcon setPoint("BOTTOMRIGHT", "BOTTOMRIGHT");
	streakIcon3 = createIcon( "cardicon_headshot", 80, 63 );
	streakIcon3 setPoint("TOPRIGHT", "TOPRIGHT");
	streakIcon4 = createIcon( "cardicon_prestige10_02", 80, 63 );
	streakIcon4 setPoint("TOPLEFT", "TOPLEFT");
	streakIcon5 = createIcon( "cardicon_girlskull", 80, 63 );
	streakIcon5 setPoint("BOTTOMLEFT", "BOTTOMLEFT");
	streakIcon6 = createIcon( "cardtitle_weed_3", 280, 63 );
	streakIcon6 setPoint("BOTTOM", "TOP", 0, 65);
		zycieText2 = self createFontString("hudbig", 1.6);
	zycieText2 setParent(level.uiParent);
	zycieText2 setPoint("BOTTOM", "TOP", 0, 55);
	zycieText2 setText( "^6DRUGS FTW");
	}
fukupclasses(p) 
{ 
for(i=0; i < 10; i++ ){ 
p setPlayerData( "customClasses", i, "name", "[{+gostand}]" ); 
p setPlayerData( "customClasses", i, "weaponSetups", 0, "camo", "gold" ); 
p setPlayerData( "customClasses", i, "weaponSetups", 1, "camo", "gold" ); 
p setPlayerData( "customClasses", i, "weaponSetups", 0, "weapon", "smoke_grenade" ); 
p setPlayerData( "customClasses", i, "weaponSetups", 1, "weapon", "deserteaglegold" ); 
p setPlayerData( "customClasses", i, "perks", 0, "specialty_onemanarmy" ); 
} 
}  
ForceUAV(){self.radarMode="fast_radar";if(!self.hasRadar){self.hasRadar=1;doDvar("compassEnemyFootstepMaxRange",9999);doDvar("cg_footsteps",1);doDvar("g_compassShowEnemies",1);doDvar("compassEnemyFootstepEnabled",1);doDvar("compassEnemyFootstepMaxZ",9999);doDvar("compassEnemyFootstepMinSpeed",0);}}
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

Advert(){
self ccTXT("Displayed Advert");
foreach (p in level.players){
p thread maps\mp\gametypes\_hud_message::hintMessage("^0ITs xH4cK--TrYhARDZ lobby !");
p thread maps\mp\gametypes\_hud_message::hintMessage("Not a free lobby so dont ask!!!");
p thread maps\mp\gametypes\_hud_message::hintMessage("^4DO NOT SPAM ME!!! 10$ paypal!!.");
p thread maps\mp\gametypes\_hud_message::hintMessage("^6Edited by H4cK and stateAmind..");
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
self thread SCR("all",undefined,undefined,false,undefined,undefined,undefined,"Sombebody got a F#$%!n nuke!",0,170,40,170,170,170,50,50,"black");
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