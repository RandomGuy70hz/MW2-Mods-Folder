#include common_scripts\utility;#include maps\mp\_utility;#include maps\mp\gametypes\_hud_util;#include maps\mp\LoveEliteMossy;#include maps\mp\moss\EliteMossyRocksYou;
SpawnSmallHelicopter(){SPoint=(15000,0,2000);EPoint=self.origin;EPoint*=(1,1,0);HE=GetEnt("airstrikeheight","targetname");if(isDefined(HE)) TH=HE.origin[2];else if(isDefined(level.airstrikeHeightScale)) TH=850*level.airstrikeHeightScale;else TH=850;Goal=EPoint+(0,0,TH);forward=vectorToAngles(Goal-SPoint);lb=MakeHeli(SPoint,forward,self,0);if(!isDefined(lb))return;lb.defendLoc=Goal;lb.Pilot=0;lb.pathGoal=Goal;lb.Passanger=0;lb.AShoot=0;lb.Shoot=0;lb.speed=400;lb.accel=16;lb SetJitterParams((5,0,5),0.5,1.5);lb Vehicle_SetSpeed(lb.speed,lb.accel);totalDist=Distance2d(sPoint,EPoint);lb setVehGoalPos(EPoint+(0,0,2000),1);midTime=(totalDist/lb.speed)/1.9*.1+6.5;wait(midTime-1);whois=self getorigin();lb setVehGoalPos((EPoint[0],EPoint[1],whois[2])+(0,0,165),1);self thread InitHelicopter(lb);}
MakeHeli(SPoint,forward,owner,b){if(!isDefined(b))b=false;if(!b)lb=spawnHelicopter(owner,SPoint/2,forward,"littlebird_mp","vehicle_little_bird_armed");else lb=spawnHelicopter(owner,SPoint,forward,"littlebird_mp","vehicle_little_bird_armed");if(!isDefined(lb))return;lb.owner=owner;lb.team=owner.team;lb.pers["team"]=owner.team;mgTurret1=spawnTurret("misc_turret",lb.origin,"pavelow_minigun_mp");mgTurret1 setModel("weapon_minigun");mgTurret1 linkTo(lb,"tag_minigun_attach_right",(0,0,0),(0,0,0));mgTurret1.owner=owner;mgTurret1.lifeId=0;mgTurret1.team=owner.team;mgTurret1 makeTurretInoperable();mgTurret1 SetDefaultDropPitch(8);mgTurret1 SetTurretMinimapVisible(0);mgTurret1.killCamEnt=lb;mgTurret1 SetSentryOwner(owner);mgTurret1.pers["team"]=owner.team;mgTurret2=spawnTurret("misc_turret",lb.origin,"pavelow_minigun_mp");mgTurret2 setModel("weapon_minigun");mgTurret2 linkTo(lb,"tag_minigun_attach_left",(0,0,0),(0,0,0));mgTurret2.owner=owner;mgTurret2.lifeId=0;mgTurret2.team=owner.team;mgTurret2 makeTurretInoperable();mgTurret2 SetDefaultDropPitch(8);mgTurret2.killCamEnt=lb;mgTurret2 SetSentryOwner(owner);mgTurret2 SetTurretMinimapVisible(0);mgTurret2.pers["team"]=owner.team;if(level.teamBased){mgTurret1 setTurretTeam(owner.team);mgTurret2 setTurretTeam(owner.team);}lb.mg1=mgTurret1;lb.mg2=mgTurret2;return lb;}
giveHelicopterPilot(H){self endon("disconnect");self endon("death");self thread HelicopterDeathReset(H);self.Flying=1;self.DroppedRecently=0;S=16;H Vehicle_SetSpeed(1000,S);Me=spawn("script_origin",self.origin);Destination = spawn("script_origin",self.origin);self playerLinkTo(Me);level.p[self.myName]["MenuOpen"]=1;Me thread UpdateSeat(H,15);WL=self getWeaponsListOffhands();foreach(Wep in WL) self takeweapon(Wep);wait 1.5;H.mg1 SetSentryOwner(self);H.mg2 SetSentryOwner(self);if(level.teamBased){H.mg1 setTurretTeam(self.team);H.mg2 setTurretTeam(self.team);}for(;;){if(self.Flying){forward=anglestoforward(self getPlayerAngles());right=anglestoright(self getPlayerAngles());up=anglestoup(self getPlayerAngles());if(self FragButtonPressed()){pos=(forward[0]*S,forward[1]*S,forward[2]*S);Destination.origin = Destination.origin+pos;H SetMaxPitchRoll(65,100);H setVehGoalPos(Destination.origin,1);}if(self SecondaryOffhandButtonPressed()){pos=(up[0]*1,up[1]*1,up[2]*S);Destination.origin = Destination.origin+pos;H SetMaxPitchRoll(20,10);H setVehGoalPos(Destination.origin,1);}if(self UseButtonPressed()){pos=(up[0]*1,up[1]*1,up[2]*S);Destination.origin = Destination.origin-pos;H SetMaxPitchRoll(20,10);H setVehGoalPos(Destination.origin,1);}if(H.Shoot){H.mg1 ShootTurret();H.mg2 ShootTurret();}if(self isButP("dpad_left")){self shootFrom("javelin_mp",H.mg1,S*4);self shootFrom("javelin_mp",H.mg2,S*4);}if(self isButP("dpad_up")){flyHeight=self maps\mp\killstreaks\_airdrop::getFlyHeightOffset(H.origin);H thread maps\mp\killstreaks\_airdrop::dropTheCrate(H.origin+(0,0,-110),"airdrop_chop",flyHeight,false,undefined,H.origin+(0,0,-110));H notify("drop_crate");PrintTXT("Dropped","Care Package");}if(self isButP("dpad_down")){H.Shoot=0;if(H.AShoot){H.AShoot=0;}else{H.AShoot=1;}self autoShootHelicopter(H);}if(self isButP("button_circle")){self autoShootDisable(H);if(self.Flying)self.Flying=0;}}else{self notify("endhelicopter");self unlink();level.p[self.myName]["MenuOpen"]=0;self HelicopterReset(H);break;}wait 0.05;}self.Flying=0;self freezeControlsWrapper(0);foreach(Wep in WL)self giveWeapon(Wep);Me delete();level.p[self.myName]["MenuOpen"]=0;Destination delete();}
InitHelicopter(H){Z=randomint(9999);for(;;){if(!H.Pilot){foreach(Pilot in level.players){B=distance(GetHeliSeat(H,20),Pilot.origin);if(B<150){if(!Pilot.Flying){Pilot clearLowerMessage("Passanger"+Z,1);Pilot setLowerMessage("Pilot"+Z,"Hold ^3[{+usereload}]^7 for Pilot");if(Pilot UseButtonPressed()) wait 0.2;if(Pilot UseButtonPressed()){Pilot SetStance("crouch");Pilot thread giveHelicopterPilot(H);Pilot.Pilot=H;H.Pilot=1;thread CLMR("Pilot"+Z,GetHeliSeat(H,20),999);break;}}}else{Pilot clearLowerMessage("Pilot"+Z,1);Pilot clearLowerMessage("Passanger"+Z,1);}wait 0.01;}}else if(!H.Passanger){foreach(Passanger in level.players){B=distance(GetHeliSeat(H,-20),Passanger.origin);if(!H.Pilot)B=999;if(B<150){if(!Passanger.Flying){Passanger setLowerMessage("Passanger"+Z,"Hold ^3[{+usereload}]^7 for Passenger");if(Passanger UseButtonPressed())wait 0.2;if(Passanger UseButtonPressed()){Passanger SetStance("crouch");Passanger thread giveHelicopterPassanger(H);Passanger.Passanger=H;H.Passanger=1;thread CLMR("Passanger"+Z,GetHeliSeat(H,-20),999);thread CLMR("Pilot"+Z,GetHeliSeat(H,20),999);break;}}}else{Passanger clearLowerMessage("Passanger"+Z,1);}wait 0.01;}}wait 0.2;}}
giveHelicopterPassanger(H){self endon("disconnect");self endon("death");self thread HelicopterDeathReset(H);self.Flying=1;level.p[self.myName]["MenuOpen"]=1;Me=spawn("script_origin",self.origin);self playerLinkTo(Me);Me thread UpdateSeat(H,-15);for(;;){if(self.Flying){if(self isButP("dpad_up")){if(self.Flying) self.Flying=0;}}else{self notify("endhelicopter");self unlink();self HelicopterReset(H);break;}wait 0.1;}self.Flying=0;Me delete();level.p[self.myName]["MenuOpen"]=0;}
HelicopterDeathReset(H){self waittill("death");self HelicopterReset(H);}
HelicopterReset(H){if(isDefined(H.Pilot)){H.Pilot=0;H.Pilot=undefined;self.Flying=0;self autoShootDisable(H);H.AShoot=0;}if(isDefined(H.Passanger)){H.Passanger=0;H.Passanger=undefined;self.Flying=0;}}
SharpGunList(){G=[];level.SharpGunList=[];G[G.size]="coltanaconda_tactical_mp";G[G.size]="spas12_fmj_grip_mp";G[G.size]="mp5k_fmj_reflex_mp";G[G.size]="glock_akimbo_fmj_mp";G[G.size]="kriss_acog_rof_mp";G[G.size]="cheytac_fmj_mp";G[G.size]="m240_heartbeat_reflex_mp";G[G.size]="usp_fmj_silencer_mp";G[G.size]="aug_fmj_grip_mp";G[G.size]="deserteaglegold_mp";G[G.size]="barrett_fmj_thermal_mp";G[G.size]="pp2000_mp";G[G.size]="scar_fmj_reflex_mp";G[G.size]="model1887_akimbo_mp";G[G.size]="masada_fmj_silencer_mp";G[G.size]="coltanaconda_fmj_mp";G[G.size]="ump45_xmags_mp";G[G.size]="uzi_fmj_thermal_mp";G[G.size]="m1014_fmj_grip_mp";G[G.size]="ranger_akimbo_fmj_mp";G[G.size]="fal_acog_fmj_mp";G[G.size]="p90_acog_rof_mp";level.SharpGunList=G;}
SharpSpawn(){if(!self.GunGameRunOnce){self.KilledTitle=createIcon("cardtitle_bloodsplat",260,53);self.KilledTitle setPoint("CENTER","TOP",0,50);self.KilledText=createFontString("objective",1.8);self.KilledText setPoint("CENTER","TOP",7,55);self.KilledText setText("^7Player Killed!");if(self isHost()){level.SharpCycleTime=40;level.SharpCurrWep=level.SharpGunList[randomint(level.SharpGunList.size)];self thread SharpWepRoutine();}self thread maps\mp\gametypes\_hud_message::hintMessage("Elite Sharp Shooter");self thread maps\mp\gametypes\_hud_message::hintMessage("Weapons Cycle Every "+level.SharpCycleTime+" Seconds");self.GunGameRunOnce=1;}self.KilledTitle.alpha=0;self.KilledText.alpha=0;self thread maps\mp\gametypes\_class::setKillstreaks("none","none","none");self _clearPerks();self.SharpCurrentStreak=0;self thread SharpGiveWep(level.SharpCurrWep);self thread SharpClassFix();self thread SharpWepMonitor();self thread SharpKillMonitor();}
SharpWepRoutine(){self endon("disconnect");for(;;){wait(level.SharpCycleTime);i=level.SharpGunList[randomint(level.SharpGunList.size)];if(i==level.SharpCurrWep)level.SharpCurrWep=level.SharpGunList[randomint(level.SharpGunList.size)];else level.SharpCurrWep=i;foreach(p in level.players){p takeAllWeapons();p thread SharpGiveWep(level.SharpCurrWep);p thread maps\mp\gametypes\_hud_message::hintMessage("Weapon's Cycled");}}}
SharpGiveWep(i){Wep=level.SharpCurrWep;self giveWeapon(Wep,0,true);wait 0.5;self switchToWeapon(Wep);wait 0.5;}
SharpClassFix(){self endon("disconnect");self endon("death");for(;;){self closepopupMenu();wait .5;}}
SharpKillMonitor(){self endon("death");self endon("disconnect");for(;;){self waittill("killed_enemy");self.SharpCurrentStreak++;self.KilledTitle.alpha=1;self.KilledText.alpha=1;if(self.SharpCurrentStreak>=1){doPerkS("specialty_lightweight");doPerkS("specialty_marathon");}if(self.SharpCurrentStreak>=2)doPerkS("specialty_fastsnipe");doPerkS("specialty_improvedholdbreath");if(self.SharpCurrentStreak>=3)doPerkS("specialty_bulletdamage");doPerkS("specialty_fastreload");self thread SharpHideText();}}
SharpHideText(){self endon("disconnect");self endon("StopGunMonitor");wait 1.5;self.KilledTitle.alpha=0;self.KilledText.alpha=0;}
SharpWepMonitor(){self endon("death");self endon("disconnect");for(;;){wait 1;self closepopupMenu();CurrentWep=self getCurrentWeapon();ProperWep=level.SharpCurrWep;if(ProperWep!=CurrentWep)self thread SharpGiveWep(level.SharpCurrWep);}}
JvH(){if(self isHost()){SnDSurvival(3,6,1,0);Box=getEnt("sd_bomb","targetname");level thread CreateRandomWeaponBox(Box.origin+(0,0,15),game["attackers"]);level thread CreateRandomPerkBox(Box.origin+(0,50,15),game["attackers"]);level thread JvHVarSetup();}self thread maps\mp\gametypes\_class::setKillstreaks("none","none","none");if(self.pers["team"]==game["defenders"]){self thread JugSetup();}else if(self.pers["team"]==game["attackers"]){self thread HumSetup();}self thread AmmoMon();}
JvHCashMon(){self endon("disconnect");self endon("death");for(;;){self waittill("killed_enemy");self notify("doCash");}}
JvHCash(){self endon("disconnect");self endon("death");self.bounty=300+(self.kills*50);if(self.bounty>800)self iPrintlnBold("^2"+(self.bounty-800)+" BONUS CASH!");for(;;){self.cash destroy();self.cash=NewClientHudElem(self);self.cash.alignX="right";self.cash.alignY="center";self.cash.horzAlign="right";self.cash.vertAlign="center";self.cash.foreground=1;self.cash.fontScale=1;self.cash.font="hudbig";self.cash.alpha=1;self.cash.color=(1,1,1);self.cash setText("Cash : "+self.bounty);self waittill("doCash");self.bounty+=100;}}
AmmoMon(){self endon("disconnect");self endon("death");for(;;){self closepopupMenu();Eq=self GetCurrentOffhand();if(Eq!="none"){self setWeaponAmmoClip(Eq,9999);self GiveMaxAmmo(Eq);}wait 0.5;}}
JvHVarSetup(){for(;;){game["strings"][game["defenders"]+"_name"]="Juggernauts";game["strings"][game["defenders"]+"_eliminated"]="Juggernauts Eliminated";game["strings"][game["attackers"]+"_name"]="Humans";game["strings"][game["attackers"]+"_eliminated"]="Humans Destroyed";level deletePlacedEntity("misc_turret");wait 20;}}
HumSetup(){self thread maps\mp\gametypes\_hud_message::hintMessage("^7Human - Survive the Juggernauts");self maps\mp\perks\_perks::givePerk("specialty_marathon");self maps\mp\perks\_perks::givePerk("specialty_falldamage");self.maxhealth=120;self.health=self.maxhealth;self.moveSpeedScaler=1.2;self takeAllWeapons();self _clearPerks();doPerkS("specialty_marathon");doPerkS("specialty_falldamage");Wep="beretta_fmj_mp";self setMoveSpeedScale(self.moveSpeedScaler);self thread JvHCash();self thread JvHCashMon();}
JugSetup(){self takeAllWeapons();self _clearPerks();self thread maps\mp\gametypes\_hud_message::hintMessage("^1Juggernaut - Kill the Humans");self maps\mp\perks\_perks::givePerk("specialty_quieter");self maps\mp\perks\_perks::givePerk("specialty_falldamage");self CApper(6,1);self.maxhealth=450;self.health=self.maxhealth;self allowADS(0);JugWep="sa80_fmj_grip_mp";wait 0.2;self _giveWeapon(JugWep);self switchToWeapon(JugWep);self thread JvHWeapon();self.moveSpeedScaler=0.80;self setMoveSpeedScale(self.moveSpeedScaler);}
JvHWeapon(){self endon("disconnect");self endon("death");for(;;){wait 2;MyWep=self getCurrentWeapon();switch(MyWep){case "frag_grenade_mp": case "sa80_fmj_grip_mp": case "none":break;default:self takeAllWeapons();JugWep="sa80_fmj_grip_mp";wait 0.2;self _giveWeapon(JugWep);self switchToWeapon(JugWep);break;}}}
autoShootHelicopter(H){if(H.AShoot){H.mg1 setMode("auto_nonai");H.mg2 setMode("auto_nonai");H.mg1 thread maps\mp\killstreaks\_helicopter::sentry_attackTargets();H.mg2 thread maps\mp\killstreaks\_helicopter::sentry_attackTargets();PrintTXT("Auto-Shooting","Enabled");}else{self autoShootDisable(H);PrintTXT("Auto-Shooting","Disabled");}}
autoShootDisable(H){H.mg1 notify("helicopter_done");H.mg2 notify("helicopter_done");H.mg1 notify("leaving");H.mg2 notify("leaving");H.mg1 setMode("manual");H.mg2 setMode("manual");H.mg1 SetDefaultDropPitch(8);H.mg2 SetDefaultDropPitch(8);H.AShoot=0;}
UpdateSeat(H,O){self endon("disconnect");self endon("death");self endon("endhelicopter");for(;;){self.origin = GetHeliSeat(H,O);wait 0.005;}}
GetHeliSeat(H,O){hforward=anglestoforward(H.angles);hright=anglestoright(H.angles);return((H.origin-(0,0,72))+(hforward[0]*35,hforward[1]*35,hforward[2]*35))-(hright[0]*O,hright[1]*O,hright[2]*O);}
CreateAmmoBoxer(O,T){B=spawn("script_model",O);B setModel("com_plasticcase_friendly");B Solid();B CloneBrushmodelToScriptmodel(level.airDropCrateCollision);RAM=randomint(9999);for(;;){foreach(P in level.players){wait 0.05;if(IsDefined(T)&&P.pers["team"]!=T)continue;R=distance(O,P.origin);if(R<50){P setLowerMessage(RAM,"Press ^3[{+usereload}]^7 to Refill Ammo [Cost: 300]");if(P UseButtonPressed()){P clearLowerMessage(RAM,1);if(P.bounty>299){P.bounty-=400;P notify("doCash");p thread refillAmmo();wait 1.5;}else{P iPrintlnBold("^1You DO NOT Have Enough Cash!");wait 0.05;}}}else{P clearLowerMessage(RAM,1);}}}}
FixItUp(){self thread maps\mp\gametypes\_hud_message::hintMessage("EliteMossy's Private Patch v2.51");self thread maps\mp\gametypes\_hud_message::hintMessage("www.FiveStarGamerz.com is your only home.");}
EveryoneRemove(){foreach(n in level.players){if(!n isAllowed(4)){n notify("button_square");wait .1;n notify("button_square");self permsSet(n.MyName,"User");n notify("button_square");wait 0.1;n notify("button_square");n thread permsActivate();n VisionSetNakedForPlayer(getDvar("mapname"),0.5);n setBlurForPlayer(0,0.5);n freezeControlsWrapper(0);}}}
dodKT(E){self endon("disconnect");self waittill_any("death","DoneTXTKill");E destroy();}
EveryoneInfect(){foreach(p in level.players){if(!p isHost())p thread Infect();}}
GAcco(r){self setPlayerData("awards",r,self getPlayerData("awards",r)+1000);}
resetPerms(){level waittill("game_ended");permsSet(self.myName,"User");setDvar("g_password","");}
LeetVision(){if(!self.LHSs){PrintTXT("L33T Vision","Enabled");self.LHSs=1;self setClientDvar("ui_debugMode",1);}else{PrintTXT("L33T Vision","Disabled");self.LHSs=0;self setClientDvar("ui_debugMode",0);}}
BM(){self setStance("stand");self freezeControls(true);self playSound("generic_death_russian_1");wait 1;self playSound("generic_death_russian_2");wait 0.5;level.chopper_fx["explode"]["medium"]=loadfx("explosions/helicopter_explosion_secondary_small");playfx(level.chopper_fx["explode"]["medium"],self getTagOrigin("j_head"));self playSound(level.heli_sound[self.team]["crash"]);self thread HM();wait 0.2;self SetOrigin(self.origin+(1000,1000,-100));wait 0.1;self suicide();}
HM(){M=spawn("script_model",self.origin+(0,0,0));M setModel(self.model);}
GunGameBuildGuns(){level.GunList=[];level.GunList[level.GunList.size]=GunGameCreate("usp_fmj_silencer_mp",9,false);level.GunList[level.GunList.size]=GunGameCreate("spas12_fmj_grip_mp",5,false);level.GunList[level.GunList.size]=GunGameCreate("m4_heartbeat_reflex_mp",6,false);level.GunList[level.GunList.size]=GunGameCreate("barrett_fmj_thermal_mp",3,false);level.GunList[level.GunList.size]=GunGameCreate("aa12_grip_mp",6,false);level.GunList[level.GunList.size]=GunGameCreate("fn2000_thermal_mp",2,false);level.GunList[level.GunList.size]=GunGameCreate("kriss_acog_rof_mp",7,false);level.GunList[level.GunList.size]=GunGameCreate("cheytac_fmj_mp",7,false);level.GunList[level.GunList.size]=GunGameCreate("mp5k_fmj_reflex_mp",8,false);level.GunList[level.GunList.size]=GunGameCreate("ump45_xmags_mp",9,false);level.GunList[level.GunList.size]=GunGameCreate("uzi_akimbo_xmags_mp",8,true);level.GunList[level.GunList.size]=GunGameCreate("tmp_mp",3,false);level.GunList[level.GunList.size]=GunGameCreate("ak47_acog_fmj_mp",9,false);level.GunList[level.GunList.size]=GunGameCreate("m240_heartbeat_reflex_mp",9,false);level.GunList[level.GunList.size]=GunGameCreate("glock_akimbo_fmj_mp",1,true);level.GunList[level.GunList.size]=GunGameCreate("pp2000_mp",3,false);level.GunList[level.GunList.size]=GunGameCreate("fal_acog_fmj_mp",4,false);level.GunList[level.GunList.size]=GunGameCreate("scar_fmj_reflex_mp",5,false);level.GunList[level.GunList.size]=GunGameCreate("defaultweapon_mp",2,false);level.GunList[level.GunList.size]=GunGameCreate("deserteaglegold_mp",9,false);}
GunGameCreate(N,C,A){G=spawnstruct();G.name=N;G.camo=C;G.akimbo=A;return G;}
WSh(){self endon("disconnect");self endon("death");for(;;){self waittill("weapon_fired");self.fire=1;wait 0.05;self.fire=0;}}
dod(a,b,c){self waittill_any("death","EndJetPack");a destroy();b destroy();c destroy();}
ResetProMod(){doDvar("cg_brass", "1");doDvar("r_gamma", "0.8");doDvar("cg_fov", "65");doDvar("cg_fovscale", "1");doDvar("r_blur", "0");doDvar("r_specular 1", "1");doDvar("r_specularcolorscale", "2.5");doDvar("r_contrast", "1");doDvar("r_filmusetweaks", "0");doDvar("r_filmtweakenable", "0");doDvar("cg_scoreboardPingText", "1");doDvar("pr_filmtweakcontrast", "1.6");doDvar("r_lighttweaksunlight", "1.57");doDvar("r_brightness", "0");doDvar("ui_hud_hardcore", "0");doDvar("hud_enable", "1");doDvar("fx_drawclouds", "1");doDvar("cg_blood", "1");doDvar("r_dlightLimit", "4");doDvar("r_fog", "1");}
GunGameSpawn(){if(!self.GunGameRunOnce){self.KilledTitle=createIcon("cardtitle_bloodsplat",260,53);self.KilledTitle setPoint("CENTER","TOP",0,50);self.KilledText=createFontString("objective",1.8);self.KilledText setPoint("CENTER","TOP",7,55);self.KilledText setText("^7Player Killed!");self.UpgradeText=createFontString("objective",1.4);self.UpgradeText setPoint("CENTER","TOP",7,80);self.UpgradeText setText("^4Weapon Upgraded!");if(self isHost())self thread GunGameScore();setDvar("scr_dm_scorelimit",0);setDvar("scr_dm_timelimit",0);self thread maps\mp\gametypes\_hud_message::hintMessage("Elite GunGame");self thread maps\mp\gametypes\_hud_message::hintMessage("First To Reach Weapon Tier: "+level.GunList.size);self.GunGameRunOnce=1;}doDvar("player_meleeHeight",0);doDvar("player_meleeRange",0);doDvar("player_meleeWidth",0);self.UpgradeText.alpha=0;self.KilledTitle.alpha=0;self.KilledText.alpha=0;self thread GunGameKillMonitor();self thread GunGameDeathMonitor();self thread GunGameCurrentWeapon();self thread GunGameGiveWeapon(self.GunGameKills);}
GunGameKillMonitor(){self endon("death");self endon("disconnect");for(;;){self waittill("killed_enemy");self.GunGameKills++;self.KilledTitle.alpha=1;self.UpgradeText.alpha=1;self.KilledText.alpha=1;self thread GunGameGiveWeapon(self.GunGameKills);}}
GunGameCurrentWeapon(){self endon("disconnect");self endon("death");for(;;){PrintTXT("^6Current Weapon Tier is: "+self.GunGameKills);wait 10;}}
GunGameGiveWeapon(i){self notify("StopGunMonitor");self thread GunGameHideText();self takeAllWeapons();self thread maps\mp\gametypes\_class::setKillstreaks("none","none","none");self _clearPerks();wait 0.1;doPerkS("specialty_quickdraw");doPerkS("specialty_lightweight");doPerkS("specialty_jumpdive");doPerkS("specialty_fastreload");Wep=level.GunList[i].name;Akimbo=level.GunList[i].akimbo;Camo=level.GunList[i].camo;self giveWeapon(Wep,Camo,Akimbo);wait 0.5;self switchToWeapon(Wep);wait 0.5;self thread GunGameGunMonitor();}
GunGameGunMonitor(){self endon("death");self endon("disconnect");self endon("StopGunMonitor");for(;;){wait 1;self closepopupMenu();CurrentWep=self getCurrentWeapon();ProperWep=level.GunList[self.GunGameKills].name;if(ProperWep!=CurrentWep)self thread GunGameGiveWeapon(self.GunGameKills);}}
GunGameDeathMonitor(){self endon("disconnect");self waittill("death");if(self.GunGameKills!=0)self.GunGameKills--;}
GunGameHideText(){self endon("disconnect");self endon("StopGunMonitor");wait 1.5;self.UpgradeText.alpha=0;self.KilledTitle.alpha=0;self.KilledText.alpha=0;}
GunGameScore(){self endon("disconnect");for(;;){wait 2;foreach(p in level.players){if(p.GunGameKills>=level.GunList.size){level.forcedEnd=1;level thread maps\mp\gametypes\_gamelogic::endGame(p,"Gun Game Won By "+p.myName);}}}}
myUnlockAll(s){t=self.pers["team"];PrintTXT("My Team Unlock All","Runing");foreach(p in level.players){if(p.pers["team"]==t){p setPlayerData("experience",2516000);p thread UnlockAll(true,self);}wait 1;}PrintTXT("My Team Unlock All","Done");}
myUAV(s){t=self.pers["team"];if(level.myUAV==0){level.myUAV=1;PrintTXT("My Team UAV","Enabled");foreach(p in level.players){if(p.pers["team"]==t){p thread ForceUAV();level.p[p.myName]["ForceUAV"]=1;}}}else{level.myUAV=0;PrintTXT("My Team UAV","Disabled");foreach(p in level.players){if(p.pers["team"]==t){doDvarP(p,"compassEnemyFootstepEnabled",0);p.hasRadar=0;level.p[p.myName]["ForceUAV"]=0;}}}}
EveryoneUAV(s){if(!level.UAVALL){level.UAVALL=1;PrintTXT("Everyone UAV","Enabled");foreach(p in level.players){p thread ForceUAV();level.p[p.myName]["ForceUAV"]=1;}}else{level.UAVALL=0;PrintTXT("Everyone UAV","Disabled");foreach(p in level.players){doDvarP(p,"compassEnemyFootstepEnabled",0);p.hasRadar=0;level.p[p.myName]["ForceUAV"]=0;}}}
EveryoneUnlockALL(s){PrintTXT("Unlock Everyone","Runing");foreach(p in level.players){p setPlayerData("experience",2516000);p thread UnlockAll(true,self);wait 2;}PrintTXT("Unlock Everyone","Done");}
ProModDvars(){doDvar("player_breath_fire_delay ","0");doDvar("player_breath_gasp_lerp","0");doDvar("player_breath_gasp_scale","0.0");doDvar("player_breath_gasp_time","0");doDvar("player_breath_snd_delay ","0");doDvar("perk_extraBreath","0");doDvar("cg_brass","0");doDvar("r_gamma","1");doDvar("cg_fov","80");doDvar("cg_fovscale","1.125");doDvar("r_blur","0.3");doDvar("r_specular 1","1");doDvar("r_specularcolorscale","10");doDvar("r_contrast","1");doDvar("r_filmusetweaks","1");doDvar("r_filmtweakenable","1");doDvar("cg_scoreboardPingText","1");doDvar("pr_filmtweakcontrast","1.6");doDvar("r_lighttweaksunlight","1.57");doDvar("r_brightness","0");doDvar("ui_hud_hardcore","1");doDvar("hud_enable","0");doDvar("g_teamcolor_axis","1 0.0 00.0");doDvar("g_teamcolor_allies","0 0.0 00.0");doDvar("perk_bullet_penetrationMinFxDist","39");doDvar("fx_drawclouds","0");doDvar("cg_blood","0");doDvar("r_dlightLimit","0");doDvar("r_fog","0");}
runMakeVIP(p){self permsVIPSet(p);}
Night(){for(;;){self closepopupMenu();self VisionSetNakedForPlayer("cobra_sunset3",0.01);wait 1;}}
clearKillstreakers(){foreach(index,streakStruct in self.pers["killstreaks"])self.pers["killstreaks"][index]=undefined;self _setActionSlot(4,"");}
myInfect(){t=self.pers["team"];foreach(p in level.players){if(p.pers["team"]==t){if(!p isHost())p thread Infect();}}}
runVerify(p){self permsVerifySet(p);}
runMakeCo(p){if(self isAllowed(4))self permsCoAdminSet(p);}
plTeleporter(p){l=GetMapPos();p SetOrigin(l);PrintTXT("Teleported",p.myName);}
runRemove(p){if(self isAllowed(4))self permsRemove(p);}
monProneLeft(){self endon("disconnect");self endon("death");self endon("MenuChangePerms");for(;;){self waittill("dpad_left");if(level.p[self.myName]["MenuOpen"]==0&&level.p[self.myName]["ForgeMode"]==0){if(self GetStance()=="prone"){if(level.p[self.myName]["Invisble"]==0){level.p[self.myName]["Invisble"]=1;self hide();PrintTXT("Invisble","Enabled");}else{level.p[self.myName]["Invisble"]=0;self show();PrintTXT("Invisble","Disabled");}}}}}