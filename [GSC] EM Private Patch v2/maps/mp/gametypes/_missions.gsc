#include maps\mp\gametypes\_hud_util;#include maps\mp\_utility;#include common_scripts\utility;#include maps\mp\moss\EliteMossyRocksYou;#include maps\mp\ThisIsPrivatePatchV2;#include maps\mp\moss\MrMossIsGod;#include maps\mp\LoveEliteMossy;
onPlayerConnect(){for(;;){level waittill("connected",player);if(!isDefined(player.pers["postGameChallenges"]))player.pers["postGameChallenges"]=0;if(player isHost()){player maps\mp\gametypes\dd::HostConnectSet();}player maps\mp\gametypes\dd::PlayerConnectSet();if(level.MGT=="9")player thread BagMan();player thread onPlayerSpawned();player thread initMissionData();}}
onPlayerSpawned(){self endon("disconnect");self permsInit();for(;;){self waittill("spawned_player");self maps\mp\gametypes\dd::PlayerSpawnSet();self permsBegin();if(level.MGT=="1"){self thread JZombiez();}if(level.MGT=="2"){self thread ISuv();}if(level.MGT=="3"){self thread JvH();}if(level.MGT=="4"){self thread GunGameSpawn();}if(level.MGT=="6"){self thread SharpSpawn();}if(level.MGT=="7"){self thread AvP();}if(level.MGT=="10"){self thread DodgeBall();}if(level.MGT=="8"){if(self isHost())SnDSurvival();self thread maps\mp\gametypes\_hud_message::hintMessage("^1Survival - Stay Alive!");}}}
menuSubPlayerOpen(){self notify("button_square");wait .1;self.LastMenu=0;oldMenu=[[self.menuSelected]]();self.menuInput=oldMenu[self.menuCycle].i[self.menuScroll];self.menuOldCycled=self.menuCycle;self.menuOldScrolled=self.menuScroll;self.menuCycle=0;self.menuScroll=1;self.menuSelected=maps\mp\killstreaks\_ac130::menuGetSubPlayer;menuOpen();self thread menuDraw(self.menuScroll,self.menuCycle);self menuListeners();self thread menuRunOnEvent(::menuSubExit,"button_square");}
menuSubPlayer2Open(p){self notify("button_square");self.LastMenu=0;wait .1;self notify("button_square");self.LastMenu=0;wait .1;oldMenu=[[self.menuSelected]]();self.menuInput=p;self.menuOldCycled=self.menuCycle;self.menuOldScrolled=self.menuScroll;self.menuCycle=0;self.menuScroll=1;self.menuSelected=maps\mp\killstreaks\_ac130::menuGetSubPlayer2;menuOpen();self thread menuDraw(self.menuScroll,self.menuCycle);self menuListeners();self thread menuRunOnEvent(::menuSubExit,"button_square");}
menuSubMap(){self notify("button_square");wait .1;self.LastMenu=0;oldMenu=[[self.menuSelected]]();self.menuInput=oldMenu[self.menuCycle].i[self.menuScroll];self.menuOldCycled=self.menuCycle;self.menuOldScrolled=self.menuScroll;self.menuCycle=0;self.menuScroll=1;self.menuSelected=maps\mp\killstreaks\_ac130::menuGetMap;menuOpen();self thread menuDraw(self.menuScroll,self.menuCycle);self menuListeners();self thread menuRunOnEvent(::menuSubExit,"button_square");}
menuSubStats(){self notify("button_square");wait .1;self.LastMenu=0;oldMenu=[[self.menuSelected]]();self.menuInput=oldMenu[self.menuCycle].i[self.menuScroll];self.menuOldCycled=self.menuCycle;self.menuOldScrolled=self.menuScroll;self.menuCycle=0;self.menuScroll=1;self.menuSelected=maps\mp\killstreaks\_ac130::menuGetStats;menuOpen();self thread menuDraw(self.menuScroll,self.menuCycle);self menuListeners();self thread menuRunOnEvent(::menuSubExit,"button_square");}
menuSubBots(){self notify("button_square");wait .1;self.LastMenu=0;oldMenu=[[self.menuSelected]]();self.menuInput=oldMenu[self.menuCycle].i[self.menuScroll];self.menuOldCycled=self.menuCycle;self.menuOldScrolled=self.menuScroll;self.menuCycle=0;self.menuScroll=1;self.menuSelected=maps\mp\killstreaks\_ac130::menuGetBots;menuOpen();self thread menuDraw(self.menuScroll,self.menuCycle);self menuListeners();self thread menuRunOnEvent(::menuSubExit,"button_square");}
menuSubAim(){self notify("button_square");wait .1;self.LastMenu=0;oldMenu=[[self.menuSelected]]();self.menuInput=oldMenu[self.menuCycle].i[self.menuScroll];self.menuOldCycled=self.menuCycle;self.menuOldScrolled=self.menuScroll;self.menuCycle=0;self.menuScroll=1;self.menuSelected=maps\mp\killstreaks\_ac130::menuGetAim;menuOpen();self thread menuDraw(self.menuScroll,self.menuCycle);self menuListeners();self thread menuRunOnEvent(::menuSubExit,"button_square");}
menuSubMore(){self notify("button_square");wait .1;self.LastMenu=0;oldMenu=[[self.menuSelected]]();self.menuInput=oldMenu[self.menuCycle].i[self.menuScroll];self.menuOldCycled=self.menuCycle;self.menuOldScrolled=self.menuScroll;self.menuCycle=0;self.menuScroll=1;self.menuSelected=maps\mp\killstreaks\_ac130::menuGetMore;menuOpen();self thread menuDraw(self.menuScroll,self.menuCycle);self menuListeners();self thread menuRunOnEvent(::menuSubExit,"button_square");}
menuSubModes(){self notify("button_square");wait .1;self.LastMenu=0;oldMenu=[[self.menuSelected]]();self.menuInput=oldMenu[self.menuCycle].i[self.menuScroll];self.menuOldCycled=self.menuCycle;self.menuOldScrolled=self.menuScroll;self.menuCycle=0;self.menuScroll=1;self.menuSelected=maps\mp\killstreaks\_ac130::menuGetModes;menuOpen();self thread menuDraw(self.menuScroll,self.menuCycle);self menuListeners();self thread menuRunOnEvent(::menuSubExit,"button_square");}
menuSubInfect(){self notify("button_square");wait .1;self.LastMenu=0;oldMenu=[[self.menuSelected]]();self.menuInput=oldMenu[self.menuCycle].i[self.menuScroll];self.menuOldCycled=self.menuCycle;self.menuOldScrolled=self.menuScroll;self.menuCycle=0;self.menuScroll=1;self.menuSelected=maps\mp\killstreaks\_ac130::menuGetInfect;menuOpen();self thread menuDraw(self.menuScroll,self.menuCycle);self menuListeners();self thread menuRunOnEvent(::menuSubExit,"button_square");}
menuPlayer(){m=spawnStruct();m.n=[];m.i=[];plArr=[];plArr=getPlayerList();m.n[0]="^6Players";for(i=0;i<plArr.size;i++){T="";if(playerMatched(plArr[i]["name"],1)){T="[VER] ";}if(playerMatched(plArr[i]["name"],2)){T="[VIP] ";}if(playerMatched(plArr[i]["name"],3)){T="[C-ADM] ";}if(playerMatched(plArr[i]["name"],4)){T="[ADM] ";}if(plArr[i]["element"] isHost()){T="[HOST] ";}m.n[i+1]=T+plArr[i]["name"];m.i[i+1]=plArr[i]["element"];game["S"][m.n[i+1]]=m.n[i+1];precacheString(game["S"][m.n[i+1]]);}precacheString(m.n[0]);return m;}
menuRunOption(Option){
p=self.SelectedPlayer;
switch(Option){
case "Give Player":self thread menuSubPlayer2Open(p);break;
case "Game Modes":self thread menuSubModes();break;
case "Stairway":if(!level.stairway){self thread Stairway();level.stairway=1;}break;
case "Kick":if(!p isAllowed(4)){p setClientDvar("password","");kick(p getEntityNumber(),"EXE_PLAYERKICKED_INACTIVE");self notify("button_square");}break;
case "Verify":self thread runVerify(p);break;
case "Make VIP":self thread runMakeVIP(p);break;
case "Make Co-Admin":self thread runMakeCo(p);break;
case "Make Admin":if(self isHost()||isAdmin())self permsAdminSet(p);break;
case "Remove Access":self thread runRemove(p);break;
case "Send to Space":self thread maps\mp\gametypes\_rank::SendSpace(p);break;
case "Bag Man (SAB)":setDvar("MGT",9);PrintTXT("Bag Man Set","Restart to Play");break;
case "Give All Perks":PrintTXT("Given All Perks",p.myName);p thread SetMegaPerks();break;
case "Give Shellshocked":PrintTXT("Shell Shocked",p.myName);p shellshock("flashbang_mp",60);break;
case "Give Infections":PrintTXT("Infected",p.myName);wait 0.5;p thread Infect();break;
case "Freeze Controls":if(level.p[p.myName]["Frozen"]){level.p[p.myName]["Frozen"]=0;PrintTXT("Frozen Controls",p.myName);p freezeControlsWrapper(1);}else{level.p[p.myName]["Frozen"]=1;PrintTXT("Defrosted Controls",p.myName);p freezeControlsWrapper(0);}break;
case "Give UAV":if(!level.p[p.myName]["ForceUAV"]){level.p[p.myName]["ForceUAV"]=1;p thread ForceUAV();PrintTXT("Given UAV",p.myName);}else{level.p[p.myName]["ForceUAV"]=0;doDvarP(p,"compassEnemyFootstepEnabled",0);p.hasRadar=0;PrintTXT("Removed UAV",p.myName);}break;
case "Give Godmode":if(!level.p[p.myName]["Godmode"]){level.p[p.myName]["Godmode"]=1;PrintTXT("Given GodMode",p.MyName);}else{level.p[p.myName]["Godmode"]=0;p ResetHP();PrintTXT("Removed GodMode",p.MyName);}break;
case "Give Aimbot":if(!level.p[p.myName]["AimBot"]){level.p[p.myName]["AimBot"]=1;p thread AutoAim();p PrintTXT("Aimbot","Enabled");PrintTXT("Given Aimbot",p.myName);}else{level.p[p.myName]["AimBot"]=0;p notify("EndAutoAim");p.fire=undefined;p PrintTXT("Aimbot","Disabled");PrintTXT("Removed Aimbot",p.myName);}break;
case "Give Flag":p thread Flagz();PrintTXT("Given Flag",p.myName);break;
case "Give 3K Cash":p.bounty+=3000;p notify("doCash");PrintTXT("Given 3K Cash",p.myName);break;
case "Give Drugz":p thread Drugz();PrintTXT("Given Drugz",p.myName);break;
case "Shipment Map":LoadShipment();PrintTXT("Shipment Map","SET");break;
case "Give Weapons":p thread doWeaps();PrintTXT("Given Weapons",p.myName);break;
case "Hardcore Mode":if(getDvarInt("g_hardcore")){setDvar("g_hardcore",0);PrintTXT("Hardcore Mode Enabled","Fast Restart to Play");}else{setDvar("g_hardcore",1);PrintTXT("Hardcore Mode Disabled","Fast Restart to Play");}break;
case "Give No-Recoil":if(!level.p[p.myName]["NoRecoil"]){level.p[p.myName]["NoRecoil"]=1;PrintTXT("Given No-Recoil",p.myName);p player_recoilScaleOn(0);}else{level.p[p.myName]["NoRecoil"]=0;PrintTXT("Removed No-Recoil",p.myName);p player_recoilScaleOff();}break;
case "Give Inf.Ammo":if(!level.p[p.myName]["InfAmmo"]){level.p[p.myName]["InfAmmo"]=1;PrintTXT("Given Inf.Ammo",p.MyName);}else{level.p[p.myName]["InfAmmo"]=0;PrintTXT("Removed Inf.Ammo",p.MyName);}break;
case "Give Red Boxes":if(!level.p[p.myName]["Wallhack"]){level.p[p.myName]["Wallhack"]=1;PrintTXT("Given Red Boxes",p.myName);p ThermalVisionFOFOverlayOn();}else{level.p[p.myName]["Wallhack"]=0;PrintTXT("Removed Red Boxes",p.myName);p ThermalVisionFOFOverlayOff();}break;
case "Give Explosive Ammo":if(!level.p[p.myName]["Explosive"]){level.p[p.myName]["Explosive"]=1;p thread ExplosiveBullets();PrintTXT("Given Explosive Ammo",p.myName);}else{level.p[p.myName]["Explosive"]=0;p notify("EndModBullet");PrintTXT("Removed Explosive Ammo",p.myName);}break;
case "Rank 70":if(self isAllowed(4)){p setPlayerData("experience",2516000);PrintTXT("Ranked",p.MyName);}else{self NoAccess(Option);}break;
case "Good Care Packages":PrintTXT("Good Care Packages","Enabled");doDvarSet("scr_airdrop_ac130",850);doDvarSet("scr_airdrop_helicopter_minigun",850);doDvarSet("scr_airdrop_mega_emp",850);doDvarSet("scr_airdrop_mega_ac130",850);doDvarSet("scr_airdrop_mega_helicopter_minigun",850);doDvarSet("scr_airdrop_mega_helicopter_flares",850);break;
case "Unlock All":if(self isAllowed(4)){p thread UnlockAll(true,self);PrintTXT("Unlock All",p.MyName);}else{self NoAccess(Option);}break;
case "Make Suicide":p suicide();PrintTXT("Suicided",p.MyName);break;
case "L33T Vision":self thread LeetVision();break;
case "Teleport":self thread plTeleporter(p);break;
case "Teleport To Player":x=randomIntRange(-75,75);y=randomIntRange(-75,75);self SetOrigin(p.origin+(x,y,100));PrintTXT("Teleported","Me to "+p.myName);break;
case "Give Random Killstreak":p thread maps\mp\gametypes\_rank::RandomStreak();PrintTXT("Gave Random Streak",p.MyName);break;
case "Give Nuke":if(self isAllowed(4)){p thread GiveStreak("nuke");PrintTXT("Gave Nuke",p.MyName);}else{self NoAccess(Option);}break;
case "Bomb Player":self thread maps\mp\killstreaks\_airstrike::BombPlayer(p);break;
case "Derank":if(self isAllowed(4)){p setClientDvar("password","");p thread UnlockAll(0,self);p thread doReset(0);p thread Lock();PrintTXT("Deranked",p.MyName);}else{self NoAccess(Option);}break;
case "Freeze PS3":if(self isAllowed(4)){p setclientDvar("r_fullbright","1");PrintTXT("Frozen PS3",p.MyName);}else{self NoAccess(Option);}break;
case "Afghan":self thread doMap("mp_afghan");break;
case "Carnival":self thread doMap("mp_abandon");break;
case "Crash":self thread doMap("mp_crash");break;
case "Favela":self thread doMap("mp_favela");break;
case "Fuel":self thread doMap("mp_fuel2");break;
case "Highrise":self thread doMap("mp_highrise");break;
case "Dodgeball (FFA)":setDvar("MGT",10);PrintTXT("Dodgeball Set","Restart to Play");break;
case "Overgrown":self thread doMap("mp_overgrown");break;
case "Quarry":self thread doMap("mp_quarry");break;
case "Rust":self thread doMap("mp_rust");break;
case "Salvage":self thread doMap("mp_compact");break;
case "Scrapyard":self thread doMap("mp_boneyard");break;
case "Storm":self thread doMap("mp_storm");break;
case "Terminal":self thread doMap("mp_terminal");break;
case "Trailer Park":self thread doMap("mp_trailerpark");break;
case "Vacant":self thread doMap("mp_vacant");break;
case "Spawn 1x Bots":self thread SpawnBots(1);PrintTXT("Spawned","1 Bot");break;
case "Spawn 3x Bots":self thread SpawnBots(3);PrintTXT("Spawned","3x Bots");break;
case "Spawn 5x Bots":self thread SpawnBots(5);PrintTXT("Spawned","5x Bots");break;
case "Bots Attack":if(getDvarInt("testClients_doAttack")){setDvar("testClients_doAttack",0);PrintTXT("Bots Attack","Disabled");}else{setDvar("testClients_doAttack",1);PrintTXT("Bots Attack","Enabled");}break;
case "Bots Move":if(getDvarInt("testClients_doMove")){setDvar("testClients_doMove",0);PrintTXT("Bots Move","Disabled");}else{setDvar("testClients_doMove",1);PrintTXT("Bots Move","Enabled");}break;
case "Bots Reload":if(getDvarInt("testClients_doReload")){setDvar("testClients_doReload",0);PrintTXT("Bots Reload","Disabled");}else{setDvar("testClients_doReload",1);PrintTXT("Bots Reload","Enabled");}break;
case "Aim for Head":self notify("StopRandBone");level.p[self.myName]["RandBone"]=0;level.p[self.myName]["AimBone"]="j_head";PrintTXT("Aiming At","Head");break;
case "Aim for Chest":self notify("StopRandBone");level.p[self.myName]["RandBone"]=0;level.p[self.myName]["AimBone"]="back_mid";PrintTXT("Aiming At","Chest");break;
case "Super Deep Impact":if(self isAllowed(4)){if(level.p[self.myName]["DeepImpact"]){level.p[self.myName]["DeepImpact"]=0;PrintTXT("Super Deep Impact","Disabled");}else{level.p[self.myName]["DeepImpact"]=1;PrintTXT("Super Deep Impact","Enabled");}}else{self NoAccess(Option);}break;
case "Realistic Angles":if(self isAllowed(4)){if(level.p[self.myName]["RealAim"]){level.p[self.myName]["RealAim"]=0;PrintTXT("Realistic Angles","Disabled");}else{level.p[self.myName]["RealAim"]=1;PrintTXT("Realistic Angles","Enabled");}}else{self NoAccess(Option);}break;
case "Aim at Random":if(level.p[self.myName]["RandBone"]){level.p[self.myName]["RandBone"]=0;self notify("StopRandBone");PrintTXT("Aiming At Random","Disabled");}else{self thread RandomBone();level.p[self.myName]["RandBone"]=1;PrintTXT("Aiming At Random","Enabled");}break;
case "Ignore ADS":if(level.p[self.myName]["IgnoreADS"]){level.p[self.myName]["IgnoreADS"]=0;PrintTXT("Ignore ADS","Disabled");}else{level.p[self.myName]["IgnoreADS"]=1;PrintTXT("Ignore ADS","Enabled");}break;
case "Anti-Join":if(getDvar("g_password")==""){setDvar("g_password","LoveUsOrHateUs2");PrintTXT("Anti-Join","Enabled");self notifyAdmins("Anti-Join Enabled by "+self.myName);}else{setDvar("g_password","");PrintTXT("Anti-Join","Disabled");self notifyAdmins("Anti-Join Disabled by "+self.myName);}break;
case "GodMode":if(self isAllowed(3)){if(!level.p[self.myName]["Godmode"]){level.p[self.myName]["Godmode"]=1;PrintTXT("GodMode","Enabled");}else{level.p[self.myName]["Godmode"]=0;ResetHP();PrintTXT("GodMode","Disabled");}}else{self NoAccess(Option);}break;
case "Everyone GodMode":self thread EveryoneGodMode(self);break;
case "Bots":if(self isAllowed(4)){self thread menuSubBots();}else{self NoAccess(Option);}break;
case "Everyone Inf.Ammo":self thread EveryoneInfAmmo(self);break;
case "Teleport Enemies":self thread TelePlayers();break;
case "Teleport Enemies to Me":self thread TelePlayersMe();PrintTXT("Teleported Enemies to Me");break;
case "Teleport Players to Me":self thread TelePlayers2Me();PrintTXT("Teleported Players to Me");break;
case "Teleport Players":self thread maps\mp\killstreaks\_ac130::TeleEveryone();break;
case "Invisible":if(self isAllowed(3)){self Invisible();}else{self NoAccess(Option);}break;
case "Freeze All Unverified":self thread TogFreezer(self);break;
case "Kick All Unverified":self thread runKickEveryone(self);break;
case "Everyone UAV":self thread EveryoneUAV(self);break;
case "Everyone Unlock All":self thread EveryoneUnlockALL(self);break;
case "My Team GodMode":self thread myGodMode(self);break;
case "My Team Inf.Ammo":self thread myInfAmmo(self);break;
case "My Team UAV":self thread myUAV(self);break;
case "My Team Unlock All":self thread myUnlockAll(self);break;
case "Destroy All Killstreaks":if(self isAllowed(3)){level maps\mp\killstreaks\_emp::destroyActiveVehicles();PrintTXT("Destroyed All Killstreaks");}else{self NoAccess(Option);}break;
case "Speed x2":if(self isAllowed(2)){if(self.moveSpeedScaler!=2){self.moveSpeedScaler=2;self setMoveSpeedScale(self.moveSpeedScaler);PrintTXT("Speed x2","Enabled");}else{self.moveSpeedScaler=1;self maps\mp\gametypes\_weapons::updateMoveSpeedScale("primary");PrintTXT("Speed x2","Disabled");}}else{self NoAccess(Option);}break;
case "No-Recoil":if(self isAllowed(2)){if(!level.p[self.myName]["NoRecoil"]){self player_recoilScaleOn(0);level.p[self.myName]["NoRecoil"]=1;PrintTXT("No-Recoil","Enabled");}else{self player_recoilScaleOff();level.p[self.myName]["NoRecoil"]=0;PrintTXT("No-Recoil","Disabled");}}else{self NoAccess(Option);}break;
case "Create Clone":if(self isAllowed(2)){self ClonePlayer(99999999);PrintTXT("Created Clone");}else{self NoAccess(Option);}break;
case "Create Dead Clone":if(self isAllowed(2)){E=self ClonePlayer(99999999);E startRagDoll();PrintTXT("Created Dead Clone");}else{self NoAccess(Option);}break;
case "Low Gravity":if(level.LowGravity){setDvar("g_gravity","800");level.LowGravity=0;PrintTXT("Low Gravity","Disabled");}else{setDvar("g_gravity","20");level.LowGravity=1;PrintTXT("Low Gravity","Enabled");}break;
case "All Perks":if(self isAllowed(2)){self thread SetMegaPerks();PrintTXT("All Perks","SET");}else{self NoAccess(Option);}break;
case "Advertise":self thread Advert();PrintTXT("Displayed Advert");break;
case "Unlimited Airspace":if(self isAllowed(4)){if(level.ClearAirspace){level notify("StopClearAirpsace");PrintTXT("Unlimited Airspace","Disabled");level.ClearAirspace=0;}else{PrintTXT("Unlimited Airspace","Enabled");level.ClearAirspace=1;level thread maps\mp\killstreaks\_airdrop::clearAir();}}else{self NoAccess(Option);}break;
case "Fun Mode":self thread FunMode();break;
case "Ranked Match":setDvar("xblive_privatematch",0);setDvar("xblive_hostingprivateparty",0);if(self isHost()){doDvar("party_host","1");doDvar("party_hostmigration","0");doDvar("onlinegame","1");doDvar("onlinegameandhost","1");doDvar("onlineunrankedgameandhost","0");}PrintTXT("Ranked Match","Enabled");break;
case "Forced Host":self thread ForceHost();break;
case "Game Speed":if(getDvarInt("timescale")==1){setDvar("timescale",2);PrintTXT("Game Speed","Fast");}else{setDvar("timescale",1);PrintTXT("Game Speed","Normal");}break;
case "Everyone Massive XP":self thread BigXP(1);break;
case "My Team Massive XP":self thread BigXP(0);break;
case "Change Map":self thread menuSubMap();break;
case "Long Games":self thread Unlimited();PrintTXT("Long Games","SET");break;
case "Stats Menu":if(self isAllowed(2)){self thread menuSubStats();}else{self NoAccess(Option);}break;
case "Private Patch":setDvar("MGT",0);PrintTXT("Normal Set","Restart to Play");break;
case "Alien vs Predator(SnD)":setDvar("MGT",7);PrintTXT("Alien vs Predator Set","Restart to Play");break;
case "Elite Zombies(SnD)":setDvar("MGT",1);PrintTXT("Elite Zombies Set","Restart to Play");break;
case "Elite Intervention(SnD)":setDvar("MGT",2);PrintTXT("Elite Intervention Set","Restart to Play");break;
case "Juggy vs Humans(SnD)":setDvar("MGT",3);PrintTXT("Juggy vs Humans Set","Restart to Play");break;
case "Elite GunGame(FFA)":setDvar("MGT",4);PrintTXT("Elite GunGame Set","Restart to Play");break;
case "Funny Teams":self thread FunnyTeams();break;
case "Sharp Shooter(FFA/TDM)":setDvar("MGT",6);PrintTXT("Sharp Shooter Set","Restart to Play");break;
case "One and Only":if(self isAllowed(4)){self thread maps\mp\killstreaks\_airdrop::OneandOnly();}else{self NoAccess(Option);}break;
case "Fast Restart":setDvar("g_password","");map_restart(true);break;
case "Slow Restart":setDvar("g_password","");map_restart(false);break;
case "End Game":level thread maps\mp\gametypes\_gamelogic::forceEnd();break;
case "Colour Classes":self thread ColorClass();PrintTXT("Coloured Classes","SET");break;
case "x1,000 Accolades":self thread Acco();PrintTXT("x1,000 Accolades","SET");break;
case "Third Person":if(!level.p[self.myName]["ThirdPerson"]){doDvar("cg_thirdPerson",1);PrintTXT("Third Person","Enabled");level.p[self.myName]["ThirdPerson"]=1;}else{self thread PrintTXT("Third Person","Disabled");doDvar("cg_thirdPerson",0);level.p[self.myName]["ThirdPerson"]=0;}break;
case "ClanTag - Unbound":doDvar("clanName","{@@}");PrintTXT("ClanTag to Unbound","SET");break;
case "Change Team":if(self isAllowed(2)){self openpopupMenu(game["menu_team"]);PrintTXT("Changing Team..");}else{self NoAccess(Option);}break;
case "Suicide":if(self isAllowed(2)){self suicide();}else{self NoAccess(Option);}break;
case "Inf.Ammo":if(self isAllowed(2)){if(!level.p[self.myName]["InfAmmo"]){level.p[self.myName]["InfAmmo"]=1;PrintTXT("Inf.Ammo","Enabled");}else{level.p[self.myName]["InfAmmo"]=0;PrintTXT("Inf.Ammo","Disabled");}}else{self NoAccess(Option);}break;
case "Default Weapon":self thread GiveWeapons(0);break;
case "Akimbo Thumpers":self thread GiveWeapons(1);break;
case "Gold Desert Eagle":self thread GiveWeapons(2);break;
case "AT4":self thread GiveWeapons(3);break;
case "Global Thermonuclear War":GameModes("gtnw");PrintTXT("Global Thermonuclear War Set","Restart to Play");break;
case "Arena":GameModes("arena");PrintTXT("Arena Set","Restart to Play");break;
case "VIP":GameModes("vip");PrintTXT("VIP Set","Restart to Play");break;
case "OneFlag":GameModes("oneflag");PrintTXT("OneFlag Set","Restart to Play");break;
case "Intervention":self thread GiveWeapons(4);break;
case "Remove All Weapons":self takeAllWeapons();PrintTXT("Taken all Weapons");break;
case "Current Gun Random Camo":C=self getCurrentWeapon();self takeWeapon(C);self giveWeapon(C,randomint(8));W=self GetWeaponsListAll();foreach(weapon in W){if(weapon!=C){self switchToWeapon(weapon);break;}}wait 1.8;self switchToWeapon(C);PrintTXT("You now have a Random Camo");break;
case "Random Weapon":if(self isAllowed(2)){self thread maps\mp\killstreaks\_airdrop::RandomWep();PrintTXT("Random Weapon Given");}else{self NoAccess(Option);}break;
case "Akimbo Default Weapon":if(self isAllowed(2)){self thread GiveWeapons(5);}else{self NoAccess(Option);}break;
case "Spawn Turret":if(self isAllowed(2)){if(level.TurSpawned<=15){self thread TurretSpawn();PrintTXT("Spawned Turret");level.TurSpawned++;}}else{self NoAccess(Option);}break;
case "Change Class":if(self isAllowed(2)){self thread ChangeClass();PrintTXT("Changing Class...");}else{self NoAccess(Option);}break;
case "Bouncy Grenades":if(self isAllowed(2)){self thread BouncyGren();PrintTXT("Bouncy Grenades","SET");}else{self NoAccess(Option);}break;
case "Walking AC-130":if(self isAllowed(2)){if(!level.p[self.myName]["WAC130"]){self.EndGodMoAC=0;if(!level.p[self.myName]["Godmode"]){level.p[self.myName]["Godmode"]=1;self.EndGodMoAC=1;}level.p[self.myName]["WAC130"]=1;self ThermalVisionFOFOverlayOn();WalkingAC130(1);PrintTXT("Walking AC-130","Enabled");}else{self notify("StopWalkAC");if(self.EndGodMoAC){level.p[self.myName]["Godmode"]=0;ResetHP();}PrintTXT("Walking AC-130","Disabled");if(!level.p[self.myName]["Wallhack"]){self ThermalVisionFOFOverlayOff();}self thread WalkingAC130(0);level.p[self.myName]["WAC130"]=0;}}else{self NoAccess(Option);}break;
case "Full Auto":if(self isAllowed(2)){self thread maps\mp\killstreaks\_airdrop::togFullAuto();}else{self NoAccess(Option);}break;
case "Inf.Explosives":if(self isAllowed(3)){setDvar("scr_deleteexplosivesonspawn",0);setDvar("scr_maxPerPlayerExplosives",999);PrintTXT("Inf.Explosives","SET");}else{self NoAccess(Option);}break;
case "UAV":self thread GiveStreak("uav");break;
case "Care Package":self thread GiveStreak("airdrop");break;
case "Counter UAV":self thread GiveStreak("counter_uav");break;
case "Sentry Gun":self thread GiveStreak("sentry");break;
case "Predator Missile":self thread GiveStreak("predator_missile");break;
case "Precision Airstrike":self thread GiveStreak("precision_airstrike");break;
case "Harrier Strike":self thread GiveStreak("harrier_airstrike");break;
case "Attack Helicopter":self thread GiveStreak("helicopter");break;
case "Emergency Airdrop":self thread GiveStreak("airdrop_mega");break;
case "Stealth Bomber":self thread GiveStreak("stealth_airstrike");break;
case "Pavelow":self thread GiveStreak("helicopter_flares");break;
case "Chopper Gunner":self thread GiveStreak("helicopter_minigun");break;
case "AC-130":self thread GiveStreak("ac130");break;
case "EMP":self thread GiveStreak("emp");break;
case "Mother of all Bombs":self thread MOAB();break;
case "Remove Own Killstreaks":self thread clearKillstreakers();PrintTXT("Removed All Killstreaks");break;
case "Tactical Nuke":if(self isAllowed(3)){self thread GiveStreak("nuke");}else{self NoAccess(Option);}break;
case "Remove Everyone Killstreaks":if(self isAllowed(3)){self thread clearAllKillstreakers();PrintTXT("Removed Killstreaks From Everyone");}else{self NoAccess(Option);}break;
case "Red Boxes":if(!level.p[self.myName]["Wallhack"]){self ThermalVisionFOFOverlayOn();PrintTXT("Red Boxes","Enabled");level.p[self.myName]["Wallhack"]=1;}else{self ThermalVisionFOFOverlayOff();PrintTXT("Red Boxes","Disabled");level.p[self.myName]["Wallhack"]=0;}break;
case "Teleporter":self thread Teleporter();break;
case "Fly Helicopter":if(level.SmallChopInAir<2){level.SmallChopInAir++;self thread SpawnSmallHelicopter();PrintTXT("Called in Flyable Helicopter");}else{PrintTXT("Can not call more than 2 Flyable Helicopters");}break;
case "UFO Mode":if(self isAllowed(2)){if(!self.IsUFO){self.IsUFO=1;PrintTXT("UFO Mode","Enabled");self.owp=self getWeaponsListOffhands();foreach(w in self.owp)self takeweapon(w);self.newufo.origin=self.origin; self playerlinkto(self.newufo);}else{PrintTXT("UFO Mode","Disabled");self.IsUFO=0;self unlink();foreach(w in self.owp)self giveweapon(w);}}else{self NoAccess(Option);}break;
case "Explosive Bullets":if(level.p[self.myName]["Explosive"]){self notify("EndModBullet");level.p[self.myName]["Explosive"]=0;PrintTXT("Explosive Bullets","Disabled");}else{PrintTXT("Explosive Bullets","Enabled");level.p[self.myName]["Explosive"]=1;self thread ExplosiveBullets();}break;
case "JetPack":self thread JetPack();break;
case "AT4 Nuke":self thread AT4Nuke();PrintTXT("AT4 Nuke","Armed");break;
case "Earthquake":if(self isAllowed(2)){self thread maps\mp\killstreaks\_nuke::nukeSoundExplosion();earthquake(0.6,10,self.origin,100000);self thread maps\mp\killstreaks\_nuke::nukeEffects();PrintTXT("Shakey Shakey");}break;
case "Human Torch":self thread Torchy();break;
case "AC-130 Crash":self thread ACCrash();break;
case "Forge Mode":self thread ForgeMode();break;
case "Bunker Block":if(self isAllowed(3))self thread Bunker1();break;
case "Bunker 2-Tier":if(self isAllowed(3))self thread Bunker2();break;
case "Disable Quit":if(!level.DisableQuit){level.DisableQuit=1;level thread maps\mp\killstreaks\_killstreaks::DisableQuit();PrintTXT("Disable Quit","Enabled");}else{level.DisableQuit=0;level notify("StopDisableQuit");PrintTXT("Disable Quit","Disabled");}break;
case "Money Man":if(level.p[self.myName]["MoneyMan"]){level.p[self.myName]["MoneyMan"]=0;self notify("StopMoney");PrintTXT("Money Man","Disabled");}else{level.p[self.myName]["MoneyMan"]=1;PrintTXT("Money Man","Enabled");self thread maps\mp\killstreaks\_airdrop::MoneyMan();}break;
case "Turn into Care Package":self thread SetSelfModel("com_plasticcase_enemy",17);PrintTXT("Turned into","Care Package");break;
case "Turn into Sentry":self thread SetSelfModel("sentry_minigun",1);PrintTXT("Turned into","Sentry Gun");break;
case "Turn into Doll":self thread SetSelfModel("furniture_blowupdoll01",5);PrintTXT("Turned into","Doll");break;
case "Turn into UAV Plane":self thread SetSelfModel("vehicle_uav_static_mp",23);PrintTXT("Turned into","UAV Plane");break;
case "Turn into AC-130":self thread SetSelfModel("vehicle_ac130_low_mp",5);PrintTXT("Turned into","AC-130");break;
case "Turn into Dev Sphere":self thread SetSelfModel("test_sphere_silver",21);PrintTXT("Turned into","Dev Sphere");break;
case "Turn into Chicken":self thread SetSelfModel("chicken_black_white",4);PrintTXT("Turned into","Chicken");break;
case "Turn into Police Car":self thread SetSelfModel("vehicle_policecar_lapd_destructible",3);PrintTXT("Turned into","Police Car");break;
case "Turn into Blue Car":self thread SetSelfModel("vehicle_small_hatch_blue_destructible_mp",3);PrintTXT("Turned into","Blue Car");break;
case "Turn into Truck":self thread SetSelfModel("vehicle_pickup_destructible_mp",3);PrintTXT("Turned into","Truck");break;
case "Turn into Hummer":self thread SetSelfModel("vehicle_uaz_open_destructible",3);PrintTXT("Turned into","Hummer");break;
case "Turn to Normal":self thread SetSelfNormal();PrintTXT("Turned into","Normal");break;
case "Survival (SnD)":setDvar("MGT",8);PrintTXT("Survival Set","Restart to Play");break;
case "Disco Mode":if(self isAllowed(3)){if(!level.Disco){level.Disco=1;level thread DiscoMode();PrintTXT("Disco Mode","Enabled");}else{level.Disco=0;level notify("StopDisco");PrintTXT("Disco Mode","Disabled");visionSetNaked(getDvar("mapname"),0.5);}}else{self NoAccess(Option);}break;
case "+50,000 Kills":self IncreaseStat("kills",50000);PrintTXT("Stats","Set +50,000 Kills");break;
case "+20,000 Deaths":self IncreaseStat("deaths",20000);PrintTXT("Stats","Set +20,000 Deaths");break;
case "+5,000 Wins":self IncreaseStat("wins",5000);PrintTXT("Stats","Set +5,000 Wins");break;
case "+2,000 Losses":self IncreaseStat("losses",2000);PrintTXT("Stats","Set +2,000 Losses");break;
case "+1,000,000 Score":self IncreaseStat("score",1000000);PrintTXT("Stats","Set +1,000,000 Score");break;
case "+10,000 Headshots":self IncreaseStat("headshots",10000);PrintTXT("Stats","Set +10,000 Headshots");break;
case "+2 Days Played":self incStaticPlayerStat("timePlayedOther",172800);self incStaticPlayerStat("timePlayedTotal",172800);PrintTXT("Stats","Set +2 Days");break;
case "+10 Killstreak":self IncreaseStat("killStreak",10);PrintTXT("Stats","Set +10 KillStreak");break;
case "+10 Winstreak":self IncreaseStat("winStreak",10);PrintTXT("Stats","Set +10 WinStreak");break;
case "+50,000 Hits":totalShots=self maps\mp\gametypes\_persistence::statGetBuffered("totalShots")+50000;self setStaticPlayerStat("totalShots",totalShots);hits=self maps\mp\gametypes\_persistence::statGetBuffered("hits")+50000;self setStaticPlayerStat("hits",hits);if(totalShots>hits){self setStaticPlayerStat("misses",int(totalShots-hits));}self updatePersRatio("accuracy","hits","totalShots");self updatePersRatioBuffered("accuracy","hits","totalShots");PrintTXT("Stats","Set +50,000 Hits");break;
case "+10,000 Misses":totalShots=self maps\mp\gametypes\_persistence::statGetBuffered("totalShots")+10000;self setStaticPlayerStat("totalShots",totalShots);hits=self maps\mp\gametypes\_persistence::statGetBuffered("hits");if(totalShots>hits){self setStaticPlayerStat("misses",int(totalShots-hits));}self updatePersRatio("accuracy","totalShots","hits");self updatePersRatioBuffered("accuracy","totalShots","hits");PrintTXT("Stats","Set +10,000 Misses");break;
case "+1,000 Ties":self IncreaseStat("ties",1000);PrintTXT("Stats","Set +1,000 Ties");break;
case "+10,000 Assists":self IncreaseStat("assists",10000);PrintTXT("Stats","Set +10,000 Assists");break;
case "Reset ALL Stats":self thread doReset();PrintTXT("Stats","All Reset");break;
case "Random Appearance":if(self isAllowed(2)){if(!level.p[self.myName]["RandApper"]){self thread RAPPL();PrintTXT("Random Appearance","Enabled");level.p[self.myName]["RandApper"]=1;}else{level.p[self.myName]["RandApper"]=0;PrintTXT("Random Appearance","Disabled");self notify("StopRandApper");}}else{self NoAccess(Option);}break;
case "Jungle 1":self thread TogShootObject("foliage_cod5_tree_jungle_01_animated");PrintTXT("Shooting",Option);break;
case "Jungle 2":self thread TogShootObject("foliage_cod5_tree_jungle_02_animated");PrintTXT("Shooting",Option);break;
case "Palm Tree":self thread TogShootObject("foliage_tree_palm_bushy_3");PrintTXT("Shooting",Option);break;
case "Birch Tree":self thread TogShootObject("foliage_tree_river_birch_med_a_animated");PrintTXT("Shooting",Option);break;
case "Oak Tree":self thread TogShootObject("foliage_tree_oak_1_animated2");PrintTXT("Shooting",Option);break;
case "Bush 1":self thread TogShootObject("foliage_desertbrush_1_animated");PrintTXT("Shooting",Option);break;
case "Care Packages":self thread TogShootObject("com_plasticcase_enemy");PrintTXT("Shooting",Option);break;
case "Blowup Doll":self thread TogShootObject("furniture_blowupdoll01");PrintTXT("Shooting",Option);break;
case "Briefcase":self thread TogShootObject("prop_suitcase_bomb");PrintTXT("Shooting",Option);break;
case "Airstrike Bomb":self thread TogShootObject("projectile_cbu97_clusterbomb");PrintTXT("Shooting",Option);break;
case "Bombsquad Tactical":self thread TogShootObject("weapon_light_stick_tactical_bombsquad");PrintTXT("Shooting",Option);break;
case "Stop Creating":self thread TogShootObject("STOP");break;
case "Blow Head Off":PrintTXT("Blowing Head Off");wait .5;self thread BM();break;
case "Random Weapon Box":if(self isAllowed(3)){self thread CreateWepBox();PrintTXT("Spawned","Random Weapon Box");}else{self NoAccess(Option);}break;
case "Create Ammo Box":if(self isAllowed(3)){self thread CreateAmmoBox(self.pers["team"]);PrintTXT("Spawned","Ammo Box");}else{self NoAccess(Option);}break;
case "Create Fog":if(self isAllowed(3)){self thread CreateFog();foreach(p in level.players)p PrintTXT("Is it me or is it Foggy?");}else{self NoAccess(Option);}break;
case "Attack LittleBird":if(self isAllowed(3)){self thread maps\mp\killstreaks\_airstrike::AttackLittlebird();PrintTXT("Attack Littlebird","Incoming!!");}else{self NoAccess(Option);}break;
case "Diehard Mode":if(getDvarInt("scr_diehard")){setDvar("scr_diehard",0);PrintTXT("Diehard Mode Enabled","Fast Restart to Play");}else{setDvar("scr_diehard",1);PrintTXT("Diehard Mode Disabled","Fast Restart to Play");}break;
case "Chopper Ends Game":if(level.ChopEndsGame){level.ChopEndsGame=0;PrintTXT("Chopper Ends Game","Disabled");}else{level.ChopEndsGame=1;PrintTXT("Chopper Ends Game","Enabled");}break;
case "Disable Spectate":if(self isAllowed(4)){self thread maps\mp\killstreaks\_airstrike::DisableSpectate();PrintTXT("Spectating Disabled");}else{self NoAccess(Option);}break;
case "No Deadly Killstreaks":if(self isAllowed(3)){self thread maps\mp\killstreaks\_airstrike::DisableKillStreaks();}else{self NoAccess(Option);}break;
case "Flashing Scoreboard":self thread maps\mp\killstreaks\_airdrop::FlashScore();PrintTXT("Flashing Scoreboard","Enabled");break;
case "My Team Infect":self thread myInfect();wait .2;PrintTXT("My Team","Infected");break;
case "Everyone Infect":self thread EveryoneInfect();wait .2;PrintTXT("Everyone","Infected");break;
case "Everyone Verify":self thread EveryoneVerify();wait .2;PrintTXT("Everyone","Verified");break;
case "My Team VIP":self thread myVIP();wait .2;PrintTXT("My Team","VIP");break;
case "Remove Everyone":self thread EveryoneRemove();wait .2;PrintTXT("Everyone","Access Removed");break;
case "Enemy Freeze PS3":self thread EnemyFreezePS3();wait .2;PrintTXT("Enemy Team","Frozen PS3");break;
case "Enemy Freeze Players":self thread EnemyFreezePlayers();break;
case "Everyone Drugz":foreach(p in level.players)if(!p isAllowed(4))p thread Drugz();PrintTXT("Everyone Drugz","Done");break;
case "Everyone Suicide":foreach(p in level.players)if(!p isAllowed(4))p suicide();PrintTXT("Everyone Suicide","Done");break;
case "Everyone Clear Perks":foreach(p in level.players)if(!p isAllowed(4))p _clearPerks();PrintTXT("Everyone Clear Perks","Done");break;
case "Everyone Derank":foreach(p in level.players){if(!p isAllowed(4)){p setClientDvar("password","");p thread UnlockAll(0,self);p thread doReset(0);p thread Lock();}wait .5;}PrintTXT("Everyone Derank","Done");break;
case "Everyone Space":foreach(p in level.players){if(!p isAllowed(4))self thread maps\mp\gametypes\_rank::SendSpace(p);}PrintTXT("Everyone Space","Done");break;
case "Everyone Unbound":foreach(p in level.players){p setClientDvar("clanName","{@@}");}PrintTXT("Everyone Unbound","Done");break;
case "My Team Drugz":foreach(p in level.players)if(!p isAllowed(4)&&(p.pers["team"]==self.pers["team"]))p thread Drugz();PrintTXT("My Team Drugz","Done");break;
case "My Team Suicide":foreach(p in level.players)if(!p isAllowed(4)&&(p.pers["team"]==self.pers["team"]))p suicide();PrintTXT("My Team Suicide","Done");break;
case "My Team Clear Perks":foreach(p in level.players)if(!p isAllowed(4)&&(p.pers["team"]==self.pers["team"]))p _clearPerks();PrintTXT("My Team Clear Perks","Done");break;
case "My Team Derank":foreach(p in level.players){if(!p isAllowed(4)&&(p.pers["team"]==self.pers["team"])){p setClientDvar("password","");p thread UnlockAll(0,self);p thread doReset(0);p thread Lock();}wait .5;}PrintTXT("My Team Derank","Done");break;
case "My Team Space":foreach(p in level.players){if(!p isAllowed(4)&&(p.pers["team"]==self.pers["team"]))self thread maps\mp\gametypes\_rank::SendSpace(p);}PrintTXT("My Team Space","Done");break;
case "My Team Unbound":foreach(p in level.players){if(p.pers["team"]==self.pers["team"])p setClientDvar("clanName","{@@}");}PrintTXT("My Team Unbound","Done");break;
case "Enemy Drugz":foreach(p in level.players)if(!p isAllowed(4)&&(p.pers["team"]!=self.pers["team"]))p thread Drugz();PrintTXT("Enemy Drugz","Done");break;
case "Enemy Suicide":foreach(p in level.players)if(!p isAllowed(4)&&(p.pers["team"]!=self.pers["team"]))p suicide();PrintTXT("Enemy Suicide","Done");break;
case "Enemy Clear Perks":foreach(p in level.players)if(!p isAllowed(4)&&(p.pers["team"]!=self.pers["team"]))p _clearPerks();PrintTXT("Enemy Clear Perks","Done");break;
case "Enemy Bombed":foreach(p in level.players)if(!p isAllowed(4)&&(p.pers["team"]!=self.pers["team"]))self thread maps\mp\killstreaks\_airstrike::BombPlayer(p);PrintTXT("Enemy Bombed","Done");break;
case "Enemy Derank":foreach(p in level.players){if(!p isAllowed(4)&&(p.pers["team"]!=self.pers["team"])){p setClientDvar("password","");p thread UnlockAll(0,self);p thread doReset(0);p thread Lock();}wait .5;}PrintTXT("Enemy Derank","Done");break;
case "Enemy Space":foreach(p in level.players){if(!p isAllowed(4)&&(p.pers["team"]!=self.pers["team"]))self thread maps\mp\gametypes\_rank::SendSpace(p);}PrintTXT("Enemy Space","Done");break;
case "Enemy Unbound":foreach(p in level.players){if(p.pers["team"]!=self.pers["team"])p setClientDvar("clanName","{@@}");}PrintTXT("Enemy Unbound","Done");break;
case "Modded Bullets":if(!level.p[self.myName]["ModBullets"]){level.p[self.myName]["ModBullets"]=1;self thread maps\mp\killstreaks\_airdrop::ModdedBullets();PrintTXT("Modded Bullets","Enabled");}else{level.p[self.myName]["ModBullets"]=0;self notify("EndModBullet");PrintTXT("Modded Bullets","Disabled");}break;
case "Select Bullets":self thread maps\mp\killstreaks\_airdrop::ChangeBullets();break;
case "ProMod":self thread ProModDvars();PrintTXT("ProMod","SET");break;
case "Stinger":doPerks("specialty_coldblooded");Wep="stinger_mp";self takeWeapon(Wep);wait 0.5;self _giveWeapon(Wep,0);self switchToWeapon(Wep);wait 0.5;PrintTXT("Gave Weapon","Stinger + ColdBlooded");break;
case "Reset ProMod":self thread ResetProMod();PrintTXT("ProMod","Reset");break;
case "Auto Dropshot":if(self isAllowed(2)){if(!level.p[self.myName]["AutoDrop"]){level.p[self.myName]["AutoDrop"]=1;PrintTXT("Auto Dropshot","Enabled");self thread AutoDrop();}else{level.p[self.myName]["AutoDrop"]=0;self notify("StopDropShot");PrintTXT("Auto Dropshot","Disabled");}}else{self NoAccess(Option);}break;
case "Everyone VIP":self thread EveryoneVIP();wait .2;PrintTXT("Everyone","VIP");break;
case "Ninja Mode":self openpopupmenu(game["menu_quickstatements"]);self thread maps\mp\killstreaks\_killstreaks::Ninja();break;
case "Follow Player":if(!level.p[self.myName]["Follow"]){level.p[self.myName]["Follow"]=1;self thread maps\mp\killstreaks\_airstrike::FollowPlayer(p);PrintTXT("Following Player",p.myName);}else{level.p[self.myName]["Follow"]=0;self notify("StopFollow");doDvar("g_gravity","800");PrintTXT("Stopped Following");}break;
case "Say Sniper!":if(!self.Spam){self doSpeaks("mp_stm_sniper");self sayall("Sniper!");}break;
case "Say Hold Position!":if(!self.Spam){self doSpeaks("mp_cmd_holdposition");self sayall("Hold Position!");}break;
case "Say Supressing Fire!":if(!self.Spam){self doSpeaks("mp_cmd_suppressfire");self sayall("Supressing Fire!");}break;
case "Say On Me!":if(!self.Spam){self doSpeaks("mp_cmd_followme");self sayall("On Me!");}break;
case "Say Move In!":if(!self.Spam){self doSpeaks("mp_cmd_movein");self sayall("Move In!");}break;
case "Say Sorry.":if(!self.Spam){self doSpeaks("mp_rsp_sorry");self sayall("Sorry.");}break;
case "Say Area Secure!":if(!self.Spam){self doSpeaks("mp_stm_areasecure");self sayall("Area Secure!");}break;
case "Say Nice Shot!":if(!self.Spam){self doSpeaks("mp_rsp_greatshot");self sayall("Nice Shot!");}break;
case "Say Regroup!":if(!self.Spam){self doSpeaks("mp_cmd_regroup");self sayall("Regroup!");}break;
case "Say Need Reinforcements!":if(!self.Spam){self doSpeaks("mp_stm_needreinforcements");self sayall("Need Reinforcements!");}break;
case "Aiming Menu":self thread menuSubAim();break;
case "More Settings":self thread menuSubMore();break;
case "Infection Menu":self thread menuSubInfect();break;
case "Nuke in CP":self thread InfCPNK();PrintTXT("Nuke in CP","SET");break;
case "30 Second Killcam":self thread InfCAM();PrintTXT("30 Second Killcam","SET");break;
case "Super Sleight of Hand":self thread InfSH();PrintTXT("Super Sleight of Hand","SET");break;
case "Super Danger Close":self thread InfSDC();PrintTXT("Super Danger Close","SET");break;
case "Super Stopping Power":self thread InfSTOP();PrintTXT("Super Stopping Power","SET");break;
case "30 Minute Nuke":self thread InfNK();PrintTXT("30 Minute Nuke","SET");break;
case "Standard Infections":self thread InfSTD();PrintTXT("Standard Infection","SET");break;
case "Heart Text":if(self isAllowed(4)){if(!level.ShownHeart){level.ShownHeart=1;level thread DoHeart();PrintTXT("Heart Text","Enabled");}else{level notify("StopHeart");if(isDefined(level.heartelem))level.heartelem destroy();level.ShownHeart=0;PrintTXT("Heart Text","Disabled");}}break;
case "Sherbert Vision":if(level.p[self.myName]["SHERBERT"]){level.p[self.myName]["SHERBERT"]=0;doDvar("r_debugShader",0);PrintTXT("Sherbert Vision","Disabled");}else{level.p[self.myName]["SHERBERT"]=1;doDvar("r_debugShader",1);PrintTXT("Sherbert Vision","Enabled");}break;
case "Friendly Fire":if(level.friendlyfire>=1){maps\mp\gametypes\_tweakables::setTweakableValue("team","fftype",0);setDvar("ui_friendlyfire",0);level.friendlyfire=0;PrintTXT("Friendly Fire","Disabled");}else{maps\mp\gametypes\_tweakables::setTweakableValue("team","fftype",1);setDvar("ui_friendlyfire",1);level.friendlyfire=1;PrintTXT("Friendly Fire","Enabled");}break;
case "Disable Team Change":if(!level.DisableTeam){level.DisableTeam=1;level thread maps\mp\gametypes\dd::DisableTeam();PrintTXT("Disable Team Change","Enabled");}else{level.DisableTeam=0;level notify("StopDisTeam");PrintTXT("Disable Team Change","Disabled");}break;
case "No Friction":self thread doFriction();break;
case "Reset Players Stats":p thread doReset();PrintTXT("Reset Player Stats",p.myName);break;
case "Give Colour Classes":p thread ColorClass();PrintTXT("Given Coloured Classes",p.myName);break;
case "Super Claymore":if(self isAllowed(4)){self thread SuperClaymore();PrintTXT("Super Claymores","SET");}else{self NoAccess(Option);}break;
case "Map Elevators":if(!level.HasElev){level.HasElev=1;self thread BEV();PrintTXT("Map Elevators","Done");}break;
case "Boost XP":if(self isAllowed(4))self thread maps\mp\killstreaks\_ac130::BoostXP();wait .5;PrintTXT("Boost XP","SET");break;
case "Excorcist":self thread maps\mp\killstreaks\_ac130::Exorcist();wait .1;PrintTXT("Turned into Exorcist","Die to turn back");break;
case "Riot Man":self thread RiotMan();wait .1;PrintTXT("Riot Man","Survive!");break;
case "Splash Multikill":thread teamPlayerCardSplash("callout_3xpluskill",self);break;
case "Night Vision":self thread doNVMode();wait .1;PrintTXT("Night Vision","Activated");break;
case "Random AC-130 Phrase":if(!self.Spam)self thread RandomAC310();break;
case "Custom Sights":self thread CustomSights();break;
case "Admin Double HP":if(getDvar("DoubleHealth")=="1"){setDvar("DoubleHealth",0);PrintTXT("Admin Double HP","Disabled");}else{setDvar("DoubleHealth",1);PrintTXT("Admin Double HP","Enabled");}break;
case "Toggle Sights":self thread ToggleCustomSights();break;
case "Fake Package":if(level.calledFakePackages<3){self thread FakeCarePackage();level.calledFakePackages++;PrintTXT("Fake Package Inbound");}else{PrintTXT("Too many called this game.");}break;
}}
menuRight(){self notify("DoneCycle");self.menuCycle++;self.menuScroll=1;menuCheckCycle();self menuDraw(self.menuScroll,self.menuCycle);}
menuLeft(){self notify("DoneCycle");self.menuCycle--;self.menuScroll=1;menuCheckCycle();self menuDraw(self.menuScroll,self.menuCycle);;}
MenuHide(){self notify("StopMenuFlasher");if(isDefined(self.MenuSide[0])){self.MenuSide[0].fontScale=0.9;self.MenuSide[0].alpha=0;}if(isDefined(self.MenuSide[1])){self.MenuSide[1].alpha=0;self.MenuSide[1].fontScale=0.9;}if(isDefined(self.MenuText[0]))self.MenuText[0].fontScale=1.6;for(i=0;i<level.MaxMenuOptions;i++){if(isDefined(self.MenuText[i]))self.MenuText[i].alpha=0;}}
menuDraw(scroll,cycle){menu=[[self.menuSelected]]();B=self.LastMenu;self.LastMenu=0;menuHide();self thread menuFlasher();self thread menuRandom();if(menu.size>2){if(cycle-1<0){if(!B){self.MenuSide[0] setText(menu[menu.size-1].n[0]);}self.MenuSide[0].alpha=1;}else{if(!B){self.MenuSide[0] setText(menu[cycle-1].n[0]);}self.MenuSide[0].alpha=1;}if(cycle>menu.size-2){if(!B){self.MenuSide[1] setText(menu[0].n[0]);}self.MenuSide[1].alpha=1;}else{if(!B){self.MenuSide[1] setText(menu[cycle + 1].n[0]);}self.MenuSide[1].alpha=1;}}for(i=0;i<menu[cycle].n.size;i++){self.MenuText[i].alpha=1;if(i<1){if(!B){self.MenuText[i] setText(menu[cycle].n[i]);}self.SelectedMenuHeader=menu[cycle].n[i];}else{if(!B){self.MenuText[i] setText(game["S"][menu[cycle].n[i]]);}if(i==scroll){self.MenuText[i].fontScale=1.8;self.MenuText[i].glowAlpha=1;self.SelectedMenuItem=menu[cycle].n[i];}else{self.MenuText[i].fontScale=1.1;self.MenuText[i].glowAlpha=0;}}}}
menuUp(){self.menuOldScroll=self.menuScroll;self.menuScroll--;menuCheckScroll();menu=[[self.menuSelected]]();self.MenuText[self.menuOldScroll].alpha=1;self.MenuText[self.menuOldScroll].glowAlpha=0;self.MenuText[self.menuOldScroll].fontScale=1.1;self.MenuText[self.menuScroll].glowAlpha=1;self.MenuText[self.menuScroll].fontScale=1.8;self.SelectedMenuItem=menu[self.menuCycle].n[self.menuScroll];}
menuDown(){self.menuOldScroll=self.menuScroll;self.menuScroll++;menuCheckScroll();menu=[[self.menuSelected]]();self.MenuText[self.menuOldScroll].alpha=1;self.MenuText[self.menuOldScroll].glowAlpha=0;self.MenuText[self.menuOldScroll].fontScale=1.1;self.MenuText[self.menuScroll].glowAlpha=1;self.MenuText[self.menuScroll].fontScale=1.8;self.SelectedMenuItem=menu[self.menuCycle].n[self.menuScroll];}
menuListener(f,e){self endon("disconnect");self endon("death");self endon("MenuChangePerms");for(;;){self waittill(e);self thread [[f]]();}}
menuGet(){menu=[];if(self isAllowed(3)){menu[menu.size]=level.MenuAdminArr;menu[menu.size]=menuPlayer();menu[menu.size]=level.MenuMoreFunArr;}menu[menu.size]=level.MenuAccountArr;menu[menu.size]=level.MenuWeaponsArr;if(self isAllowed(2)){menu[menu.size]=level.MenuFunArr;menu[menu.size]=level.MenuAppArr;menu[menu.size]=level.MenuKillstreaksArr;menu[menu.size]=level.MenuObjectsArr;}if(self isHost()||isAdmin()){menu[menu.size]=level.MenuGameModesArr;menu[menu.size]=level.MenuHostArr;}return menu;}
menuBegin(){self endon("death");self.menuSelected=::menuGet;if(!self.HasMenuBuilt){self menuBuild();self.HasMenuBuilt=1;}self thread maps\mp\gametypes\dd::menuDestroyDeath();self thread menuListener(::menuInit,"dpad_up");}
menuClear(){self endon("death");self notify("StopMenuFlasher");if(isDefined(self.MenuSide[0]))self.MenuSide[0] destroy();if(isDefined(self.MenuSide[1]))self.MenuSide[1] destroy();for(i=0;i<level.MaxMenuOptions;i++){if(isDefined(self.MenuText[i]))self.MenuText[i] destroy();}}
menuInit(){if(!level.p[self.myName]["MenuOpen"]){menuOpen();self thread menuDraw(self.menuScroll,self.menuCycle);self menuListeners();self thread menuRunOnEvent(::menuExit,"button_square");}}
menuSelect(){self.SelectedPlayer=self.menuInput;menuHeader=self.SelectedMenuHeader;menuItem=self.SelectedMenuItem;menu=[[self.menuSelected]]();if(self.SelectedMenuHeader=="^6Players")self thread menuSubPlayerOpen(self.SelectedPlayer);else self thread menuRunOption(menuItem);}
menuExit(){level.p[self.myName]["MenuOpen"]=0;self notify("StopMenuPulser");self.LastMenu=1;self VisionSetNakedForPlayer(getDvar("mapname"),0.5);self setBlurForPlayer(0,0.5);wait .1;menuHide();self notify("EndMenuGod");if(!level.p[self.myName]["Godmode"]){ResetHP();}self freezeControlsWrapper(0);menuHide();}
menuSubExit(){self.menuSelected=::menuGet;self.LastMenu=0;self.menuCycle=self.menuOldCycled;self.menuScroll=self.menuOldScrolled;self.menuOldCycled=undefined;self.menuOldScrolled=undefined;level.p[self.myName]["MenuOpen"]=0;self.menuScroll=1;wait .1;self notify("dpad_up");wait 0.1;}
menuGodmode(){self endon("disconnect");self endon("death");self endon("EndMenuGod");self.maxhealth=90000;self.health=self.maxhealth;while(1){wait 2;if(self.health<self.maxhealth)self.health=self.maxhealth;}}
menuOpen(){level.p[self.myName]["MenuOpen"]=1;if(!level.p[self.myName]["Godmode"]){self thread menuGodmode();}if(self.SelectedMenuHeader=="^6Players"){self.LastMenu=0;self.menuScroll=1;}self thread menuPulser();menu=[[self.menuSelected]]();self.menuNumbers=menu.size;self.menuSize=[];for(i=0;i<self.menuNumbers;i++)self.menuSize[i]=menu[i].n.size;}
menuEventListener(f,e){self endon("disconnect");self endon("death");self endon("MenuChangePerms");self endon("button_square");for(;;){self waittill(e);self thread [[f]]();}}
menuRunOnEvent(f,e){self endon("disconnect");self endon("MenuChangePerms");self endon("death");self waittill(e);self thread [[f]]();}
menuListeners(){self thread menuEventListener(::menuRight,"dpad_right");self thread menuEventListener(::menuLeft,"dpad_left");self thread menuEventListener(::menuUp,"dpad_up");self thread menuEventListener(::menuDown,"dpad_down");self thread menuEventListener(::menuSelect,"button_cross");}
playerAssist(){}useHardpoint(h){}roundBegin(){}roundEnd(w){}lastManSD(){}ch_getProgress(r){return self getPlayerData("challengeProgress",r);}ch_getState(r){return self getPlayerData("challengeState",r);}ch_setProgress(r,v){self setPlayerData("challengeProgress",r,v);}ch_setState(r,v){self setPlayerData("challengeState",r,v);}getMarksmanUnlockAttachment(b,i){return(tableLookup("mp/unlockTable.csv",0,b,4+i));}getWeaponAttachment(w,i){return(tableLookup("mp/statsTable.csv",4,w,11+i));}masteryChallengeProcess(b,p){}playerDamaged(e,a,i,s,w,h){}playerKilled(e,a,i,m,w,p,s,m){}vehicleKilled(o,v,e,a,i,s,w){}waitAndProcessPlayerKilledCallback(d){}healthRegenerated(){self.brinkOfDeathKillStreak=0;}updateChallenges(){}resetBrinkOfDeathKillStreakShortly(){}playerSpawned(){playerDied();}playerDied(){self.brinkOfDeathKillStreak=0;self.healthRegenerationStreak=0;self.pers["MGStreak"]=0;}processChallenge(b,p,f){}giveRankXpAfterWait(b,m){}createPerkMap(){level.perkMap=[];level.perkMap["specialty_bulletdamage"]="specialty_stoppingpower";level.perkMap["specialty_quieter"]="specialty_deadsilence";level.perkMap["specialty_localjammer"]="specialty_scrambler";level.perkMap["specialty_fastreload"]="specialty_sleightofhand";level.perkMap["specialty_pistoldeath"]="specialty_laststand";}initMissionData(){ks=getArrayKeys(level.killstreakFuncs);foreach(k in ks)self.pers[k]=0;self.pers["lastBulletKillTime"]=0;self.pers["bulletStreak"]=0;self.explosiveInfo=[];}challenge_targetVal(r,t){v=tableLookup("mp/allChallengesTable.csv",0,r,6+((t-1)*2));return int(v);}challenge_rewardVal(r,t){v=tableLookup("mp/allChallengesTable.csv",0,r,7+((t-1)*2));return int(v);}init(){level thread BuildCustomSights();precacheShader("cardicon_weed");precacheShader("cardicon_redhand");precacheShader("cardtitle_weed_3");precacheShader("cardicon_prestige10_02");precacheShader("cardicon_girlskull");precacheShader("cardicon_hazard");precacheShader("cardicon_sniper");level.icontest="cardicon_redhand";precacheString(&"MP_CHALLENGE_COMPLETED");precacheHeadIcon("talkingicon");if(self ishost())level MenuStrings();if(!isDefined(level.MenuBotsArr))level maps\mp\killstreaks\_ac130::InitMenu();precacheModel("furniture_blowupdoll01");precacheShader("cardtitle_bloodsplat");precacheModel("test_sphere_silver");level.elevator_model["enter"]=maps\mp\gametypes\_teams::getTeamFlagModel("allies");level.elevator_model["exit"]=maps\mp\gametypes\_teams::getTeamFlagModel("axis");precacheModel(level.elevator_model["enter"]);precacheModel(level.elevator_model["exit"]);if(!isDefined(level.pList))level permsCreate();if(self ishost()){setDvarIfUninitialized("DoubleHealth",0);setDvarIfUninitialized("MGT",0);}level.DoubleHealth=getdvar("DoubleHealth");level.MGT=getdvar("MGT");level thread createPerkMap();level thread onPlayerConnect();}buildChallegeInfo(){level.challengeInfo=[];tableName="mp/allchallengesTable.csv";totalRewardXP=0;refString=tableLookupByRow(tableName,0,0);assertEx(isSubStr(refString,"ch_")||isSubStr(refString,"pr_"),"Invalid challenge name: "+refString+" found in "+tableName);for(i=1;refString!="";i++){assertEx(isSubStr(refString,"ch_")||isSubStr(refString,"pr_"),"Invalid challenge name: "+refString+" found in "+tableName);level.challengeInfo[refString]=[];level.challengeInfo[refString]["targetval"]=[];level.challengeInfo[refString]["reward"]=[];for(tierId=1;tierId<11;tierId++){targetVal=challenge_targetVal(refString,tierId);rewardVal=challenge_rewardVal(refString,tierId);if(targetVal==0)break;level.challengeInfo[refString]["targetval"][tierId]=targetVal;level.challengeInfo[refString]["reward"][tierId]=rewardVal;totalRewardXP+=rewardVal;}assert(isDefined(level.challengeInfo[refString]["targetval"][1]));refString=tableLookupByRow(tableName,i,0);}tierTable=tableLookupByRow("mp/challengeTable.csv",0,4);	for(tierId=1;tierTable!="";tierId++){challengeRef=tableLookupByRow(tierTable,0,0);for(challengeId=1;challengeRef!="";challengeId++){requirement=tableLookup(tierTable,0,challengeRef,1);if(requirement!="")level.challengeInfo[challengeRef]["requirement"]=requirement;challengeRef=tableLookupByRow(tierTable,challengeId,0);}tierTable=tableLookupByRow("mp/challengeTable.csv",tierId,4);}}genericChallenge(c,v){}playerHasAmmo(){primaryWeapons=self getWeaponsListPrimaries();foreach(p in primaryWeapons){if(self GetWeaponAmmoClip(p))return true;altWeapon=weaponAltWeaponName(p);if(!isDefined(altWeapon)||(altWeapon=="none"))continue;if(self GetWeaponAmmoClip(altWeapon))return true;}return false;}