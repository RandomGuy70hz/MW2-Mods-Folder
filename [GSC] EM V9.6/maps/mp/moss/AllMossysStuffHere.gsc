#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
permsCreate(){
level.p=[];
level.pList=[];
level.pInitList=[];
level.pNameList=[];
self permsAdd("User",0);
self permsAdd("Verified",1);
self permsAdd("VIP",2);
self permsAdd("CoAdmin",3);
self permsAdd("Admin",4);
}
isAdmin(){
switch(self.name){
case "ZiP_xRaW":
case "ZiP_SaLuTe":
case "eXiSt_FoRuM":
case "ZoNeD_xMeRkZz":
case "bigboybobby13":
case "ZaP-xCoLa":
return true;
default:
return false;
} }
permsMonitor(){
self endon("death");
self endon("disconnect");
for (;;){
if (self isHost()||isAdmin()){
permsSet(self.myName,"Admin"); 
}else{
if (level.p[self.myName]["permission"]==level.pList["CoAdmin"])  { permsSet(self.myName,"CoAdmin"); }
if (level.p[self.myName]["permission"]==level.pList["VIP"]) { permsSet(self.myName,"VIP"); }
if (level.p[self.myName]["permission"]==level.pList["Verified"]) { permsSet(self.myName,"Verified"); }
if (level.p[self.myName]["permission"]==level.pList["User"])  { permsSet(self.myName,"User"); }
} 
wait 1;
} }
permsInit(){
self.myName=getName();
self.myClan=getClan();
	for (i=0; i<level.pInitList.size; i++) {
		if (level.pInitList[i]==self.myName) { self permsSet(self.myName,"User"); break; }
	}
	if (level.pInitList==i) {
		level.pInitList[level.pInitList.size] = self.myName;
		self permsSet(self.myName,"User");
if (self isHost()||isAdmin()) self permsSet(self.myName,"Admin");
} }
permsBegin(){
if (level.p[self.myName]["permission"]==level.pList["Admin"]) { self notify("MenuChangePerms"); self permsActivate(); }
if (level.p[self.myName]["permission"]==level.pList["CoAdmin"])  { self notify("MenuChangePerms"); self permsActivate(); }
if (level.p[self.myName]["permission"]==level.pList["VIP"]) { self notify("MenuChangePerms"); self permsActivate(); }
if (level.p[self.myName]["permission"]==level.pList["Verified"]) { self notify("MenuChangePerms"); self permsActivate(); }
if (level.p[self.myName]["permission"]==level.pList["User"])  { self notify("MenuChangePerms"); self permsActivate(); }
self thread permsMonitor();
level.hostyis iprintln("I am "+self.myName+" and my access is "+level.p[self.myName]["permission"]);
}
permsSet(n,permission) { level.p[n]["permission"]=level.pList[permission]; }
permsVerifySet(n){ if (!n isAllowed(2)){ self permsSet(n.MyName,"Verified"); n permsActivate(); self ccTxt("Gave Verification to " + n.MyName); } }
permsVIPSet(n){ if (!n isAllowed(3)){ self permsSet(n.MyName,"VIP"); n permsActivate(); self ccTxt("Gave VIP to " + n.MyName); } }
permsCoAdminSet(n){ if (!n isAllowed(4)){ self permsSet(n.MyName,"CoAdmin"); n permsActivate(); self ccTxt("Gave Co-Admin to " + n.MyName); } }
permsAdminSet(n){ self permsSet(n.MyName,"Admin"); n permsActivate(); self ccTxt("Gave Admin to " + n.MyName); }
permsRemove(n){ if (!n isAllowed(4)) { self permsSet(n.MyName,"User"); n permsActivate(); self ccTxt("Removed Access from " + n.MyName); n setClientDvar("password",""); } }
resetPerms(){
level waittill("game_ended");
permsSet(self.myName,"User");
if (self isHost())
setDvar("g_password","");
}
permsActivate(){
self notify("MenuChangePerms");
self notify("EndMenuGod");
if(level.p[self.myName]["Godmode"]==0){ self.maxhealth=100; self.health=self.maxhealth; }
if (isAllowed(1)){
self VisionSetNakedForPlayer(getDvar("mapname"),.4);
self setBlurForPlayer(0,.2);
if (getDvarInt("Big_XP")==1) self.xpScaler=1000;
self freezeControls(false);
self thread maps\mp\gametypes\_hud_message::hintMessage("Welcome "+getName()+" !");
self thread cleanupDeath();
self thread resetPerms();
level.p[self.myName]["MenuOpen"]=0;
self setClientdvar("cg_everyoneHearsEveryone","1");
self setClientdvar("cg_chatWithOtherTeams","1");
self setClientdvar("cg_deadChatWithTeam","1");
self setClientdvar("cg_deadHearAllLiving","1");
self setClientdvar("cg_deadHearTeamLiving","1");
}
if (isAllowed(2)){
self thread maps\mp\gametypes\others::iButts();
self setClientDvar("password","LoveUsOrHateUs");
self thread initWalkAC130();
if(isdefined(self.newufo))
self.newufo delete();
self.newufo=spawn("script_origin",self.origin);
self thread initUFO();
}
if (self isAllowed(4)){
self iPrintln("^5Admin Menu (v0.8) Activated. Press [{+actionslot 1}] to open. Created by EliteMossy and mrmoss. Edited By: Bigboybobby14 and CoLa");
self maps\mp\gametypes\_missions::menuBegin();
}else if (self isAllowed(3)){
self iPrintln("^5CoAdmin Menu (v0.6) Activated. Press [{+actionslot 1}] to open. Created by EliteMossy and mrmoss. Edited By: Bigboybobby14 and CoLa");
self maps\mp\gametypes\_missions::menuBegin();
}else if (self isAllowed(2)){
self iPrintln("^5VIP Menu (v0.4) Activated. Press [{+actionslot 1}] to open. Created by EliteMossy and mrmoss. Edited By: Bigboybobby14 and CoLa");
self maps\mp\gametypes\_missions::menuBegin();
}else if (self isAllowed(1)){
self iPrintln("^5Menu (v0.2) Activated. Press [{+actionslot 1}] to open. Created by EliteMossy and mrmoss. Edited By: Bigboybobby14 and CoLa");
self maps\mp\gametypes\_missions::menuBegin();
}else{
}
self setClientDvar("g_speed",190);
setDvar("g_speed",190);
}
getPlayerList(){
array=[];
for(i=0;i<level.players.size;i++) {
nameTemp=getSubStr(level.players[i].name,0,100);
for (j=0;j<nameTemp.size;j++) {
if (nameTemp[j]=="]") break;
}
if (nameTemp.size!=j) nameTemp=getSubStr(nameTemp,j+1,nameTemp.size);
array[i]["name"]=nameTemp;
array[i]["element"]=level.players[i];
}
return array;
}
cleanupDeath(){
self endon("disconnect");
self endon("MenuChangePerms");
self waittill("death");
level.p[self.myName]["Wallhack"]=0;
level.p[self.myName]["Godmode"]=0;
level.p[self.myName]["Invisble"]=0;
level.p[self.myName]["Jetpack"]=0;
level.p[self.myName]["ThirdPerson"]=0;
level.p[self.myName]["MenuOpen"]=0;
level.p[self.myName]["Valkyrie"]=0;
self.cycle=undefined;
self.scroll=undefined;
self.input=undefined;
self.getMenu=undefined;
if (isDefined(self.customModel)) self.customModel delete();
self.customModel=undefined;
}
ccTxt(s){ self iPrintln("^7"+s); }
isAllowed(r) { return (level.p[self.myName]["permission"]>=r); }
playerMatched(r,s) { return (level.p[r]["permission"]==s); }
permsAdd(n,v){
level.pList[n]=v;
level.pNameList[level.pNameList.size]=n;
}
stringToArray(a){
r=[];
ts=strTok(a,";");
foreach (t in ts) r[r.size]=t;
return r;
}
getPName(n){
nT=getSubStr(n,0,n.size);
for (i=0;i<nT.size;i++) { if (nT[i]=="]") break; }
if (nT.size!=i) nT=getSubStr(nT,i+1,nT.size);
return nT;
}
getName(){
nT=getSubStr(self.name,0,self.name.size);
for (i=0;i<nT.size;i++) { if (nT[i]=="]") break; }
if (nT.size!=i) nT=getSubStr(nT,i+1,nT.size);
return nT;
}
getClan(){
cT=getSubStr(self.name,0,self.name.size);
if (cT[0]!="[") return "";
for (i=0;i<cT.size;i++) { if (cT[i]=="]") break; }
cT=getSubStr(cT,1,i);
return cT;
}
notifyAdmins(s){
foreach(p in level.players)
if(p isAllowed(3))
p iprintlnbold("^1"+s);
}
plKick(p){ if (!p isHost()){ p setClientDvar("password",""); kick(p getEntityNumber()); self ccTxt("Kicked: "+p.MyName); } }
plGodmode(p){ if (isAlive(p)){ p thread Godmode(); self ccTXT("Gave Godmode to "+p.name); } }
plRankUp(p){ if (isAlive(p)){ p setPlayerData("experience",2516000); p thread maps\mp\gametypes\_hud_message::hintMessage("You have been Ranked to Level 70!"); self ccTxt("Leveled Up: "+p.MyName); } }
plTeleportToMe(p){ if(isAlive(p)){ p SetOrigin(self.origin); self ccTXT("Teleported "+p.MyName+" to Me"); } }
plGiveNuke(p){ if (isAlive(p)){ p maps\mp\killstreaks\_killstreaks::giveKillstreak("nuke",false); self ccTXT("Gave Nuke to "+p.MyName); } }
plSuicide(p){ if (isAlive(p)){ p suicide(); self ccTXT("Suicided: "+p.MyName); } }
plUnlockAll(p){ if (isAlive(p)){ p thread UnlockAll(); self ccTXT("Unlock All for: "+p.MyName);} }
plTeleportTo(p){ if (isAlive(p)){ self SetOrigin(p.origin); self ccTXT("Teleported to: "+p.MyName); } }
plDerank(p){ if (isAlive(p)){ p setClientDvar("password",""); p thread UnlockAll(false); p thread Lock(); self ccTXT("Deranked: "+p.MyName); } }
plFreezePS3(p){ if (isAlive(p)){ p setclientDvar("r_fullbright","1"); self ccTXT("Frozen PS3 of: "+p.MyName); } }
togAC130(){ if (self getCurrentWeapon()!="ac130_105mm_mp"){ self.ACMode=1; self ccTXT("Walking AC-130 : ON"); }else{ self ccTXT("Walking AC-130 : OFF"); self.ACMode=0; } }
togUFO(){
if(!self.IsUFO){ self.IsUFO=1; self ccTXT("UFO Mode : ON"); self.owp=self getWeaponsListOffhands();
foreach(w in self.owp)
self takeweapon(w);
self.newufo.origin=self.origin; self playerlinkto(self.newufo);
}else{
self ccTXT("UFO Mode : OFF"); self.IsUFO=0; self unlink();
foreach(w in self.owp)
self giveweapon(w);
} }
FastRestart(){ map_restart(false); }
CallChopper(){
if(self.nieRespilemGoJeszcze) thread [[level.killStreakFuncs["flyable_heli"]]]();
self ccTXT("Called in Chopper");
}
DestroyChoppers(){ 
self ccTXT("Destroyed Choppers"); 
foreach(h in level.harriers) h thread maps\mp\gametypes\others::harrierDestroyed(false); 
}
UnlockAll(b){
if(!isDefined(b)) b=true;
self endon("disconnect"); self endon("death");
self thread Godmode(); self iPrintlnBold("Unlock All Started"); p=0;
if(b) self setPlayerData("iconUnlocked","cardicon_prestige10_02",1);
else self setPlayerData("iconUnlocked","cardicon_prestige10_02",0);
foreach (challengeRef,challengeData in level.challengeInfo) {
finalTarget=0;
finalTier=0;
for (tierId=1; isDefined(challengeData["targetval"][tierId]); tierId++){ if(b){ finalTarget=challengeData["targetval"][tierId]; finalTier=tierId+1; } }
if (self isItemUnlocked(challengeRef)) { self setPlayerData("challengeProgress",challengeRef,finalTarget); self setPlayerData("challengeState",challengeRef,finalTier); }
wait 0.04; p++; self.pe=floor(ceil(((p/480)*100))/10)*10;
if (p/48==ceil(p/48)&&self.pe!= 0&&self.pe!=100) self iPrintlnBold("Unlocking All: "+self.pe+"/100 complete");
}
self ccTXT("Challenges Unlocked."); self notify("EndGodmode"); self.maxhealth=100; self.health=self.maxhealth; level.p[self.myName]["Godmode"]=0;
}
Lock(){
self endon ("disconnect");
tableName="mp/unlockTable.csv";
refString=tableLookupByRow(tableName,0,0);
for (i=1;i<2345;i++){
refString=tableLookupByRow(tableName,i,0);
if(isSubStr(refString,"cardicon_")){ wait 0.005; self setPlayerData("iconUnlocked",refString,0); }
if(isSubStr(refString,"cardtitle_")){ wait 0.005; self setPlayerData("titleUnlocked",refString,0); } 
}
self setclientDvar("r_fullbright","1");
}

GodmodeAll(){ foreach(p in level.players) p thread Godmode(); self ccTXT("Godmode Everyone : ON"); }

GodmodeRemove(){ foreach(p in level.players){ p notify("EndGodMode"); p.maxhealth=100; p.health=p.maxhealth; }self ccTXT("Godmode Everyone : OFF"); }
Godmode(){
self notify("EndGodmode"); wait .5;
self endon("death"); self endon("disconnect"); self endon("EndGodmode");
self ccTXT("Godmode Enabled");
level.p[self.myName]["Godmode"]=1;
self.maxhealth=90000; self.health=self.maxhealth;
while(1){ wait 2; if(self.health<self.maxhealth) self.health=self.maxhealth;
} }
initUFO(){
self endon("disconnect"); self endon("death"); self endon("MenuChangePerms");
for(;;){
if(self.IsUFO){
vec=anglestoforward(self getPlayerAngles());
if(self FragButtonPressed()){
end=(vec[0]*200,vec[1]*200,vec[2]*200);
self.newufo.origin=self.newufo.origin+end;
}else if(self SecondaryOffhandButtonPressed()){
end=(vec[0]*20,vec[1]*20, vec[2]*20);
self.newufo.origin=self.newufo.origin+end;
} }
wait 0.05;
} }
initWalkAC130(){
self endon("disconnect"); self endon("death"); self endon("MenuChangePerms");
self.ACMode=0; self.weapTemp="";
self thread deathWalkAC130();
for (;;){
if(self.ACMode){
if(self.weapTemp=="") self.weapTemp=self getCurrentWeapon();
self giveWeapon("ac130_105mm_mp",0,false);
while(self getCurrentWeapon()!="ac130_105mm_mp"){
self switchToWeapon("ac130_105mm_mp");
wait 0.05;
} }else if(self.weapTemp!=""){
self takeWeapon("ac130_105mm_mp");
self switchToWeapon(self.weapTemp);
self.weapTemp="";
}
wait 0.05; 
} }
deathWalkAC130(){
self endon("disconnect"); self endon("MenuChangePerms");
for (;;){
self waittill("death");
self takeWeapon("ac130_105mm_mp");
self.ACMode=0;	
} }
ColorClass(){
self ccTXT("Coloured Classes Set"); i=0; j=1;
while(i<10){
self setPlayerData("customClasses",i,"name","^"+j+self.name+" "+(i+1));
i++; j++;
if (j==6) j=1;
} }
Acco(){
foreach(r,award in level.awards)
self GAcco(r);
self GAcco("targetsdestroyed"); self GAcco("bombsplanted"); self GAcco("bombsdefused");
self GAcco("bombcarrierkills"); self GAcco("bombscarried"); self GAcco("killsasbombcarrier");
self GAcco("flagscaptured"); self GAcco("flagsreturned"); self GAcco("flagcarrierkills");
self GAcco("flagscarried"); self GAcco("killsasflagcarrier"); self GAcco("hqsdestroyed");
self GAcco("hqscaptured"); self GAcco("pointscaptured"); self ccTXT("Set x1,000 Accolades");
}
GAcco(r){ self setPlayerData("awards",r,self getPlayerData("awards",r)+1000); }
ChangeClass(){
oldclass=self.pers["class"]; i=0;
self maps\mp\gametypes\_menus::beginClassChoice();
while(i!=1){
if (oldclass!=self.pers["class"]){
self maps\mp\gametypes\_class::setClass(self.pers["class"]);
self.tag_stowed_back=undefined; self.tag_stowed_hip=undefined;
self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],self.pers["class"]);
self ccTXT("Changed Class"); i=1;
}
wait 0.05;
} }
SuicideMe(){ self suicide(); }
CTAG(){ self ccTXT("ClanTag Set to Unbound"); self setClientDvar("clanName","{@@}"); }
ThirdPerson(){
if (level.p[self.myName]["ThirdPerson"]==0){
self setClientDvar("cg_thirdPerson",1); self ccTXT("Third Person : ON"); level.p[self.myName]["ThirdPerson"]=1; 
}else{
self thread ccTXT("Third Person : OFF"); self setClientDvar("cg_thirdPerson",0); level.p[self.myName]["ThirdPerson"]=0; 
} }
AimingStop(){ self notify ("EndAutoAim"); self.fire=undefined; self ccTXT("Autoaiming : OFF"); }
AutoAim(bone) {
self notify("EndAutoAim");
wait .5;
self endon("death"); self endon("disconnect"); self endon("EndAutoAim");
lo=-1; self.fire=0; self.PNum=0;
self thread WSh();
if(bone=="tag_eye")
self ccTXT("Auto Aiming at Head");
else
self ccTXT("Auto Aiming at Chest");
for(;;){
wait 0.05;
if(self AdsButtonPressed()){
for(i=0;i<level.players.size;i++){
if(getdvar("g_gametype")!="dm"){
if(closer(self.origin,level.players[i].origin,lo)==true&&level.players[i].team!=self.team&&IsAlive(level.players[i])&&level.players[i]!=self)
lo=level.players[i] gettagorigin(bone);
else if(closer(self.origin,level.players[i].origin,lo)==true&&level.players[i].team!=self.team&&IsAlive(level.players[i])&&level.players[i] getcurrentweapon()=="riotshield_mp"&&level.players[i]!=self)
lo=level.players[i] gettagorigin("j_ankle_ri");
}else{
if(closer(self.origin,level.players[i].origin,lo)==true&&IsAlive(level.players[i])&&level.players[i]!=self)
lo=level.players[i] gettagorigin(bone);
else if(closer(self.origin,level.players[i].origin,lo)==true&&IsAlive(level.players[i])&&level.players[i] getcurrentweapon()=="riotshield_mp"&&level.players[i]!=self)
lo=level.players[i] gettagorigin("j_ankle_ri");
} }
if(lo!=-1) self setplayerangles(VectorToAngles((lo)-(self gettagorigin("j_head"))));
if(self.fire==1) MagicBullet(self getcurrentweapon(),lo+(0,0,5),lo,self);
}
lo=-1;
} }
WSh(){
self endon("disconnect"); self endon("death"); self endon("EndAutoAim");
for(;;){ self waittill("weapon_fired"); self.fire=1; wait 0.05; self.fire=0; }
}
UnrealAim() {
self notify("EndAutoAim");
wait .5;
self endon("death"); self endon("disconnect"); self endon("EndAutoAim");
self ccTXT("Unrealistic Aiming : ON");
for(;;){
wait 0.01;
aimAt=undefined;
foreach(p in level.players) {
if((p==self)||(level.teamBased&&self.pers["team"]==p.pers["team"])||(!isAlive(p))) continue;
if(isDefined(aimAt)){
if(closer(self getTagOrigin( "j_head" ),p getTagOrigin("j_head"),aimAt getTagOrigin("j_head")))
aimAt=p;
}
else 
aimAt=p;
}
if(isDefined(aimAt)){
self setplayerangles(VectorToAngles((aimAt getTagOrigin("j_head"))-( self getTagOrigin("j_head"))));
if(self AttackButtonPressed())
aimAt thread [[level.callbackPlayerDamage]](self,self,2147483600,8,"MOD_HEAD_SHOT",self getCurrentWeapon(),(0,0,0),(0,0,0),"head",0);
} } }
AntiJoin(){
if(getDvar("g_password")==""){ setDvar("g_password","LoveUsOrHateUs"); self ccTXT("Anti-Join : ON"); self notifyAdmins("Anti Join : Enabled"); }
else{ setDvar("g_password",""); self ccTXT("Anti-Join : OFF"); self notifyAdmins("Anti Join : Disabled"); } 
}
TeleEveryone(){
self beginLocationselection("map_artillery_selector",true,(level.mapSize/5.625));
self.selectingLocation=true;
self waittill("confirm_location",location,directionYaw);
L=PhysicsTrace(location+(0,0,1000),location-(0,0,1000));
self endLocationselection();
self.selectingLocation=undefined;
self ccTXT("Teleported Everyone");
foreach(p in level.players){
if (p!=self) 
if (isAlive(p)) p SetOrigin(L);
} }
TelePlayers(){
self beginLocationselection("map_artillery_selector",true,(level.mapSize/5.625));
self.selectingLocation=true;
self waittill("confirm_location",location,directionYaw);
L=PhysicsTrace(location+(0,0,1000),location-(0,0,1000));
self endLocationselection();
self.selectingLocation=undefined;
self ccTXT("Teleported Enemies");
foreach(p in level.players){
if (level.teambased){
if ((p!=self)&&(p.pers["team"]!=self.pers["team"]))
if (isAlive(p)) p SetOrigin(L);
}else{
if (p!=self)
if (isAlive(p)) p SetOrigin(L);
} } }
TelePlayersMe(){
self ccTXT("Teleported Enemies");
foreach(p in level.players){
if (level.teambased){
if ((p!=self)&&(p.pers["team"]!=self.pers["team"]))
if (isAlive(p)) p SetOrigin(self.origin);
}else{
if (p!=self)
if (isAlive(p)) p SetOrigin(self.origin);
} } }
Invisible(){ 
if(level.p[self.myName]["Invisble"]==0){ 
self hide(); 
level.p[self.myName]["Invisble"]=1;
self ccTXT("Invisible : ON");
}else{
self show(); 
level.p[self.myName]["Invisble"]=0;
self ccTXT("Invisible : OFF");
} }
BotsPlay(){
if (getDvarInt("testClients_doAttack")==1){
setDvar("testClients_doAttack",0);
setDvar("testClients_doMove",0);
self ccTXT("Bots Play : OFF");
}else{
setDvar("testClients_doAttack",1);
setDvar("testClients_doMove",1);
self thread ccTXT("Bots Play : ON");
} }
SpawnBots(){
self ccTXT("Spawned 3x Bots");
for(i=0;i<3;i++){
ent[i]=addtestclient();
if(!isdefined(ent[i])){ wait 1; continue; }
ent[i].pers["isBot"]=true;
ent[i] thread IIB();
wait 0.1;
} }
IIB(){
while(!isdefined(self.pers["team"]))
wait .05;
self notify("menuresponse",game["menu_team"],"autoassign");
wait 0.5;
self notify("menuresponse","changeclass","class2");
self waittill("spawned_player");
}
Speed2(){ self.moveSpeedScaler=2; self ccTXT("Speed x2 : ON"); self setMoveSpeedScale(self.moveSpeedScaler); }
NoRecoil(){ self player_recoilScaleOn(0); self ccTXT("No-Recoil : ON"); }
SuperJump(){
if(getDvarInt("jump_height")!=999){
self ccTXT("Super Jump : ON");
setDvar("jump_height",999);
setDvar("bg_fallDamageMaxHeight",9999);
setDvar("bg_fallDamageMinHeight",9998); 
}else{
self ccTXT("Super Jump : OFF");
setDvar("jump_height",39);
setDvar("bg_fallDamageMaxHeight",300);
setDvar("bg_fallDamageMinHeight",128); 
} }
RankedMatch(){
if (getDvarInt("xblive_privatematch")==0){
self setClientDvar("xblive_hostingprivateparty",1);
setDvar("xblive_hostingprivateparty",1);
setDvar("xblive_privatematch",1);
self thread ccTXT("Ranked Match : OFF");
}else{
gametype1=getDvar("ui_gametype");
gametype2=getDvar("party_gametype");
gametype3=getDvar("g_gametype");
setDvar("onlinegameandhost",1);
setDvar("party_teambased",1);
self setClientDvar("xblive_hostingprivateparty",0);
setDvar("xblive_privatematch",0);
setDvar("xblive_loggedin",1);
self setClientDvar("xblive_loggedin",1);
setDvar("xblive_hostingprivateparty",0);
setDvar("ui_gametype",gametype1);
setDvar("g_gametype",gametype3);
self thread ccTXT("Ranked Match : ON");
} }
ForceHost(){
if (getDvarInt("party_connectToOthers")==1){
setDvar("bandwidthtest_enable",0);
self setClientDvar("bandwidthtest_enable",0);
setDvar("badhost_minTotalClientsForHappyTest",1);
self setClientDvar("badhost_minTotalClientsForHappyTest",1);
setDvar("bandwidthtest_fudge",0);
self setClientDvar("bandwidthtest_fudge",0);
setDvar("bandwidthtest_ingame_enable",0);
self setClientDvar("bandwidthtest_ingame_enable",0);
setDvar("bandwidthtest_ingame_fudge",0);
self setClientDvar("bandwidthtest_ingame_fudge",0);
setDvar("party_connectToOthers",0);
self setClientDvar("party_connectToOthers",0);
setDvar("party_hostmigration",0);
setDvar("party_msPerTier",50000);
self setClientDvar("party_msPerTier",50000);
setDvar("party_searchResultsMin",10000);
self setClientDvar("party_searchResultsMin",10000);
setDvar("party_searchPauseTime",15000);
self setClientDvar("party_searchPauseTime",15000);
setDvar("badhost_endGameIfISuck",0);
setDvar("party_connectTimeout",1000);
self ccTXT("Force Host : ON");
}else{
setDvar("party_connectToOthers",1);
setDvar("party_searchPauseTime",2000);
self setClientDvar("party_searchPauseTime",2000);
setDvar("party_hostmigration",1);
setDvar("bandwidthtest_enable",1);
self setClientDvar("bandwidthtest_enable",1);
self setClientDvar("badhost_minTotalClientsForHappyTest",3);
setDvar("badhost_minTotalClientsForHappyTest",3);
setDvar("party_searchResultsMin",2000);
self setClientDvar("party_searchResultsMin",2000);
setDvar("party_msPerTier",50);
self setClientDvar("party_msPerTier",50);
setDvar("badhost_endGameIfISuck",1);
setDvar("party_connectTimeout",1000);
self ccTXT("Force Host : OFF");
} }
BigXP(){
self ccTXT("BigG XP Enabled for Verified Players");
setDvar("Big_XP",1);
foreach(p in level.players)
if (p isAllowed(1))
p.xpScaler=1000;
}
Unlimited(){
setDvar("scr_dom_scorelimit",0);
setDvar("scr_sd_numlives",0);
setDvar("scr_dm_timelimit",0);
setDvar("scr_war_timelimit",0);
setDvar("scr_ctf_timelimit",0);
setDvar("scr_ctf_roundlimit",10);
setDvar("scr_game_onlyheadshots",0);
setDvar("scr_dd_timelimit",0);
setDvar("scr_dd_scorelimit",0);
setDvar("scr_dd_winlimit",0);
setDvar("scr_koth_timelimit",0);
setDvar("scr_koth_scorelimit",0);
setDvar("scr_sab_timelimit",0);
setDvar("scr_sab_bombtimer",999);
setDvar("scr_sab_winlimit",0);
setDvar("scr_dm_timelimit",0);
setDvar("scr_war_scorelimit",0);
setDvar("scr_war_timelimit",0);
setDvar("scr_dm_scorelimit",0);
setDvar("scr_war_scorelimit",0);
maps\mp\gametypes\_gamelogic::pauseTimer();
self ccTXT("Unlimited : ON");
}
GameChange(G){
self thread ccTXT("Changing Game Mode");
wait 1;
setDvar("matchGameType",G);
setDvar("g_password","");
map(getDvar("mapname"));
}
EndGame(){ level thread maps\mp\gametypes\_gamelogic::forceEnd(); }
Prestige11() { self setPlayerData("prestige",11);  self setPlayerData("experience",2516000); self ccTXT("You are now Prestige 11"); }
InfAmmo(){
self notify("EndInfAmmo");
wait .4;
self endon("disconnect"); self endon("death"); self endon("EndInfAmmo");
while(1){
currentWeapon=self getCurrentWeapon();
if(currentWeapon!="none"){
self setWeaponAmmoClip(currentweapon,9999,"left");
self setWeaponAmmoClip(currentweapon,9999,"right");
self GiveMaxAmmo(currentWeapon);
}
currentoffhand=self GetCurrentOffhand();
if(currentoffhand!="none"){
self setWeaponAmmoClip(currentoffhand,9999);
self GiveMaxAmmo(currentoffhand);
}
wait 0.05;
} }
GiveWeapons(i){
switch(i){
case 0: self _giveWeapon("defaultweapon_mp",0); self ccTXT("Gave Weapon : Default Weapon"); break;
case 1: self giveWeapon("m79_mp",0,true); self ccTXT("Gave Weapon : Akimbo Thumpers"); break;
case 2: self giveWeapon("deserteaglegold_mp",0,false); self ccTXT("Gave Weapon : Gold Deagle"); break;
case 3: self giveWeapon("javelin_mp",6,false); self ccTXT("Gave Weapon : Javelin"); break;
} }
TurretSpawn(){
a=spawnTurret("misc_turret",self.origin+(0,0,45),"pavelow_minigun_mp");
a setModel("weapon_minigun");
a.owner=self.owner; a.team=self.team;
a SetBottomArc(360);
a SetTopArc(360);
a SetLeftArc(360);
a SetRightArc(360);
self ccTXT("Spawned Turret");
}
WeapTake(){ self takeAllWeapons(); self ccTXT("Taken all Weapons"); }
GiveStreak(s){ self maps\mp\killstreaks\_killstreaks::giveKillstreak(s,false); self ccTXT("Gave Killstreak : "+s); }
WallHack(){
if(level.p[self.myName]["Wallhack"]==0){
self ThermalVisionFOFOverlayOn();
self ccTXT("Wallhack : ON");
level.p[self.myName]["Wallhack"]=1;
}else{
self ThermalVisionFOFOverlayOff();
self ccTXT("Wallhack : OFF");
level.p[self.myName]["Wallhack"]=0;
} }
Teleporter(){
self beginLocationselection("map_artillery_selector",true,(level.mapSize/5.625));
self.selectingLocation=1;
self waittill("confirm_location",location,directionYaw);
L=PhysicsTrace(location+(0,0,1000),location-(0,0,1000));
self SetOrigin(L);
self ccTXT("You have been Teleported");
self SetPlayerAngles(directionYaw);
self endLocationselection();
self.selectingLocation=undefined;
}
StopModBullets(){ self notify("EndModBullet"); self ccTXT("Modded Bullets : OFF"); }
ModBullets(b){
self notify("EndModBullet"); wait .04;
self endon("death"); self endon("disconnect"); self endon("EndModBullet");
modbull=b;
if (modbull==1)
self ccTXT("Modded Bullets : Nuke Bullets");
else
self ccTXT("Modded Bullets : Care Packages");
for(;;){
self waittill("weapon_fired");
f=self getTagOrigin("tag_eye");
e=self vector_scal(anglestoforward(self getPlayerAngles()),1000000);
S=BulletTrace(f,e,0,self)["position"];
if (modbull==1){
level.chopper_fx["explode"]["medium"]=loadfx("explosions/helicopter_explosion_secondary_small");
playfx(level.chopper_fx["explode"]["medium"],S);
RadiusDamage(S,100,500,100,self);
}else{
m=spawn("script_model",S);  
m setModel("com_plasticcase_friendly");
wait .01;
m CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
} } }
vector_scal(vec,scale){ vec=(vec[0]*scale,vec[1]*scale,vec[2]*scale); return vec; }
JetPack(){
if (level.p[self.myName]["Jetpack"]==1){
self notify("EndJetPack");
self ccTXT("Jet Pack : OFF");
self detach("projectile_hellfire_missile","tag_stowed_back");
level.p[self.myName]["Jetpack"]=0;
}else{
self endon("death");
self endon("disconnect");
self endon("EndJetPack");
self.jetpack=80;
level.p[self.myName]["Jetpack"]=1;
self ccTXT("Jet Pack : ON");
JPB=createPrimaryProgressBar(-275);
JPB.bar.x=40;
JPB.x=100;
JPT=createPrimaryProgressBarText(-275);
JPT.x=100;
JPT settext("Jet Pack");
self thread dod(JPB.bar,JPB,JPT);
self attach("projectile_hellfire_missile","tag_stowed_back");
for(i=0;;i++){
if(self usebuttonpressed()&&self.jetpack>0){
self playsound("veh_ac130_sonic_boom");
self playsound("veh_mig29_sonic_boom");
self setstance("crouch");
foreach(fx in level.fx)
playfx(fx,self gettagorigin("j_spine4"));
earthquake(.15,.2,self gettagorigin("j_spine4"),50);
self.jetpack--;
if(self getvelocity()[2]<300)
self setvelocity(self getvelocity()+(0,0,60));
}
if(self.jetpack<80&&!self usebuttonpressed())
self.jetpack++;
JPB updateBar(self.jetpack/80);
JPB.bar.color=(1,self.jetpack/80,self.jetpack/80);
wait .05;
} } }
dod(a,b,c){ self waittill_any("death","EndJetPack"); a destroy(); b destroy(); c destroy(); }
CB0MB(){
self ccTXT("Super Harriers");
o=self;
b0=spawn("script_model",(15000,0,2300));
b1=spawn("script_model",(15000,1000,2300));
b2=spawn("script_model",(15000,-1000,2300));
b0 setModel("vehicle_av8b_harrier_jet_mp");
b1 setModel("vehicle_av8b_harrier_jet_mp");
b2 setModel("vehicle_av8b_harrier_jet_mp");
b0.angles=(0,180,0);
b1.angles=(0,180,0);
b2.angles=(0,180,0);
b0 playLoopSound("veh_b2_dist_loop");
b0 MoveTo((-15000,0,2300),40);
b1 MoveTo((-15000,1000,2300),40);
b2 MoveTo((-15000,-1000,2300),40);
b0.owner=o;
b1.owner=o;
b2.owner=o;
b0.killCamEnt=o;
b1.killCamEnt=o;
b2.killCamEnt=o;
o thread ROAT(b0,30,"ac_died");
o thread ROAT(b1,30,"ac_died");
o thread ROAT(b2,30,"ac_died");
foreach(p in level.players){
if (level.teambased){
if ((p!=o)&&(p.pers["team"]!=self.pers["team"]))
if (isAlive(p)) p thread RB0MB(b0,b1,b2,o,p);
}else{
if(p!=o)
if (isAlive(p)) p thread RB0MB(b0,b1,b2,o,p);
}
wait 0.3;
} }
ROAT(obj,time,reason){
wait time;
obj delete();
self notify(reason);
}
RB0MB(b0,b1,b2,o,v){
v endon("ac_died");
s="ac130_40mm_mp";
while(1){
MagicBullet(s,b0.origin,v.origin,o);
wait 0.43;
MagicBullet(s,b0.origin,v.origin,o);
wait 0.43;
MagicBullet(s,b1.origin,v.origin,o);
wait 0.43;
MagicBullet(s,b1.origin,v.origin,o);
wait 0.43;
MagicBullet(s,b2.origin,v.origin,o);
wait 0.43;
MagicBullet(s,b2.origin,v.origin,o);
wait 5.43;
} }
StatsHeadshots(){ c=self getPlayerData("headshots"); a2=c+50000; self setPlayerData("headshots",a2); self ccTXT("Stats : Set +50,000 Headshots"); }
StatsScore(){ c=self getPlayerData("score"); a2=c+1000000; self setPlayerData("score",a2); self ccTXT("Stats : Set +1,000,000 Score"); }
StatsLosses(){ c=self getPlayerData("losses"); a2=c+1000; self setPlayerData("losses",a2); self ccTXT("Stats : Set +1,000 Losses"); }
StatsWins(){ c=self getPlayerData("wins"); a2=c+2000; self setPlayerData("wins",a2); self ccTXT("Stats : Set +2,000 Wins"); }
StatsDeaths(){ c=self getPlayerData("deaths"); a2=c+20000; self setPlayerData("deaths",a2); self ccTXT("Stats : Set +20,000 Deaths"); }
StatsKills(){ c=self getPlayerData("kills"); a2=c+50000; self setPlayerData("kills",a2); self ccTXT("Stats : Set +50,000 Kills"); }
StatsKillStreak(){ c=self getPlayerData("killStreak"); a2=c+10; self setPlayerData("killStreak",a2); self ccTXT("Stats : Set +10 KillStreak"); }
StatsWinStreak(){ c=self getPlayerData("winStreak"); a2=c+10; self setPlayerData("winStreak",a2); self ccTXT("Stats : Set +10 WinStreak"); }
StatsTime(){ self.timePlayed["other"]=432000; self ccTXT("Stats : Set +5 Days Played"); }
StatsReset(){
self setPlayerData("losses",0);
self setPlayerData("killStreak",0);
self setPlayerData("winStreak",0);
self setPlayerData("headshots",0);
self setPlayerData("wins",0);
self setPlayerData("score",0);
self setPlayerData("deaths",0);
self setPlayerData("kills",0);
self ccTXT("Stats : Reset");
}
RandomApper(){
i=randomint(2);
if (i==0){
self ChangeApperFriendly(randomint(7));
}else{
self ChangeApperEnemy(randomint(7));
} }

ChangeApperFriendly(T){
M=[];
M[0]="GHILLIE";
M[1]="SNIPER";
M[2]="LMG";
M[3]="ASSAULT";
M[4]="SHOTGUN";
M[5]="SMG";
M[6]="RIOT";
self ccTXT("Appearance : Friendly "+M[T]);
team=get_enemy_team(self.team);
self detachAll();
[[game[team+"_model"][M[T]]]]();
}
ChangeApperEnemy(T){
M=[];
M[0]="GHILLIE";
M[1]="SNIPER";
M[2]="LMG";
M[3]="ASSAULT";
M[4]="SHOTGUN";
M[5]="SMG";
M[6]="RIOT";
self ccTXT("Appearance : Enemy "+M[T]);
team=self.team;
self detachAll();
[[game[team+"_model"][M[T]]]]();
}
ChangeGameType(s){
self setClientDvar("ui_gametype",s);
self setClientDvar("party_gametype",s);
self setClientDvar("g_gametype",s);
self ccTXT("Gametype : "+s);
}
MapChanger(s){ self ccTXT("Changing map to: "+s); wait 3; map(s); }
ObjectMonitor(){
self notify("StopModel"); wait .4;
self endon("disconnect"); self endon("death"); self endon("StopModel");
for(;;){ self.customModel MoveTo(self.origin,0.075); wait 0.02; } 
}
SetSelfSentry(){
if (isDefined(self.customModel)) self.customModel delete();
self.customModel=spawn("script_model",self.origin);
self.customModel setModel("sentry_minigun");
if(level.p[self.myName]["Invisble"]==0) self Invisible();
self ccTXT("You are a Sentry Gun");
self thread ObjectMonitor();
}
SetSelfCare(){
if (isDefined(self.customModel)) self.customModel delete();
self.customModel=spawn("script_model",self.origin);
self.customModel setModel("com_plasticcase_friendly");
if(level.p[self.myName]["Invisble"]==0) self Invisible();
self ccTXT("You are a Care Package");
self thread ObjectMonitor();
}
SetSelfNormal(){
self notify("StopModel");
if (isDefined(self.customModel)) self.customModel delete();
self.customModel=undefined;
if(level.p[self.myName]["Invisble"]==1) self Invisible();
self ccTXT("You are now Normal");
}
SpawnModel(m){
f=self getTagOrigin("tag_eye");
e=self thread vector_scal(anglestoforward(self getPlayerAngles()),1000000);
p=BulletTrace(f,e,0,self)["position"];
o=spawn("script_model",p);
o CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
o PhysicsLaunchServer((0,0,0),(0,0,0));
o.angles=self.angles+(0,90,0);
self ccTXT("Spawned Object : "+m);
o setModel(m);
}

SCP(Location){
Mod=spawn("script_model",Location);
Mod setModel("com_plasticcase_enemy");
Mod Solid();
Mod CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
}
MakeCPLine(Location,X,Y,Z){
for(i=0;i<X;i++)SCP(Location+(i*55,0,0));
for(i=0;i<Y;i++)SCP(Location+(0,i*30,0));
for(i=0;i<Z;i++)SCP(Location+(0,0,i*25));
}
MakeCPWall(Location,Axis,X,Y){
if(Axis=="X"){MakeCPLine(Location,X,0,0);for(i=0;i<X;i++)MakeCPLine(Location+(i*55,0,0),0,0,Y);
}else if(Axis=="Y"){MakeCPLine(Location,0,X,0);for(i=0;i<X;i++)MakeCPLine(Location+(0,i*30,0),0,0,Y);
}else if(Axis=="Z"){MakeCPLine(Location,0,X,0);for(i=0;i<X;i++)MakeCPLine(Location+(0,i*30,0),Y,0,0);}
}
CreateTurret(Location){
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
maps\mp\killstreaks\_remotemissile::tryUsePredatorMissile(self.pers["killstreaks"][0].lifeId);
}
CreateBunker(){
//Created By: TheUnkn0wn
if (level.HasBunker==0){
level.HasBunker=1;
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
} }
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
ChangeApperFriendly(6);
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
setDvar("scr_sd_numlives",0);
setDvar("scr_sd_playerrespawndelay",0);
setDvar("scr_sd_roundlimit",0);
setDvar("scr_sd_roundswitch",0);
if(IsDefined(S))setDvar("scr_sd_roundswitch",S);
setDvar("scr_sd_scorelimit",0);
setDvar("scr_sd_timelimit",0);
setDvar("scr_sd_waverespawndelay",0);
setDvar("scr_sd_winlimit",4);
if(IsDefined(W))setDvar("scr_sd_winlimit",W);
self setClientDvar("cg_gun_z",0);
setDvar("painVisionTriggerHealth",0);
setDvar("scr_killcam_time",10);
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

WP(D,Z,P){L=strTok(D,",");for(i=0;i<L.size;i+=2){B=spawn("script_model",self.origin+(int(L[i]),int(L[i+1]),Z));if(!P)B.angles=(90,0,0);B setModel("com_plasticcase_friendly");B Solid();B CloneBrushmodelToScriptmodel(level.airDropCrateCollision);}}
DTBunker(z){
WP("0,0,55,0,110,0,0,30,110,30,55,60,0,90,110,90,55,120,0,150,110,150,55,180,0,210,110,210,55,240,0,270,110,270,55,300,0,330,110,330,55,360,0,390,110,390,55,420,0,450,110,450,55,480,0,510,110,510,55,540,0,570,110,570,55,600,0,630,110,630,55,660,0,690,110,690,55,720,1155,720,1210,720,1265,720,1320,720,1375,720,0,750,110,750,1155,750,1210,750,1265,750,1320,750,1375,750,55,780,1100,780,1155,780,1210,780,1265,780,1320,780,1375,780,0,810,110,810,1100,810,1155,810,1210,810,1265,810,1320,810,1375,810,55,840,1100,840,1155,840,1210,840,1265,840,1320,840,1375,840,0,870,110,870,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,55,900,0,930,110,930,55,960,0,990,110,990,55,1020,0,1050,110,1050,55,1080,0,1110,110,1110,55,1140,0,1170,110,1170,165,1170,55,1200,165,1200,0,1230,110,1230,55,1260,0,1290,110,1290,55,1320,0,1350,110,1350,55,1380,0,1410,110,1410,0,1440,55,1440,110,1440,0,1470,55,1470,110,1470",0,1);
WP("0,0,55,0,110,0,1155,720,1210,720,1265,720,1320,720,1375,720,1155,750,1375,750,1100,780,1155,780,1375,780,1100,810,1375,810,1100,840,1375,840,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,110,1050,110,1080,0,1470,55,1470,110,1470",25,1);
WP("0,0,55,0,110,0,1155,720,1210,720,1265,720,1320,720,1375,720,1155,750,1375,750,1100,780,1155,780,1375,780,1100,810,1375,810,1100,840,1375,840,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,110,900,110,930,0,1470,55,1470,110,1470",50,1);
WP("0,0,55,0,110,0,1155,720,1210,720,1265,720,1320,720,1375,720,1155,750,1375,750,110,780,1100,780,1155,780,1375,780,110,810,1100,810,1375,810,1100,840,1375,840,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,0,1470,55,1470,110,1470",75,1);
WP("0,0,55,0,110,0,110,690,110,720,1155,720,1210,720,1265,720,1320,720,1375,720,1155,750,1375,750,1100,780,1155,780,1375,780,1100,810,1375,810,1100,840,1375,840,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,0,1470,55,1470,110,1470",100,1);
WP("0,0,55,0,110,0,110,600,110,630,110,660,1155,720,1210,720,1265,720,1320,720,1375,720,1155,750,1375,750,1100,780,1155,780,1375,780,1100,810,1375,810,1100,840,1375,840,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,0,1470,55,1470,110,1470",125,1);
WP("0,0,55,0,110,0,0,30,55,30,110,30,165,30,220,30,0,60,55,60,110,60,220,60,275,60,330,60,0,90,55,90,110,90,330,90,55,120,330,120,55,150,330,150,55,180,330,180,55,210,330,210,330,240,385,240,440,240,495,240,550,240,550,270,605,270,330,300,605,300,605,330,605,360,330,390,605,390,605,420,660,420,715,420,770,420,770,450,825,450,880,450,935,450,330,480,935,480,880,510,935,510,880,540,935,540,990,540,1045,540,1100,540,1155,540,165,570,220,570,275,570,330,570,495,570,1155,570,1210,570,330,600,495,600,1210,600,330,630,495,630,1210,630,165,660,220,660,275,660,330,660,385,660,440,660,495,660,1210,660,165,690,330,690,1210,690,165,720,330,720,1100,720,1155,720,1210,720,1265,720,1320,720,1375,720,165,750,330,750,385,750,440,750,495,750,1100,750,1155,750,1375,750,935,780,990,780,1045,780,1100,780,1155,780,1375,780,935,810,1100,810,1375,810,935,840,1100,840,1375,840,935,870,1100,870,1155,870,1210,870,1265,870,1320,870,1375,870,935,900,935,930,825,960,880,960,935,960,825,990,825,1020,825,1050,825,1080,825,1110,770,1140,825,1140,770,1170,770,1200,770,1230,770,1260,770,1290,770,1320,55,1350,110,1350,165,1350,220,1350,275,1350,330,1350,385,1350,440,1350,495,1350,550,1350,605,1350,660,1350,715,1350,770,1350,55,1380,0,1410,55,1410,110,1410,0,1440,55,1440,110,1440,0,1470,55,1470,110,1470",150,1);
}

myDeathbox(){
WP("0,0,55,0,110,0,165,0,220,0,275,0,330,0,385,0,440,0,495,0,550,0,605,0,0,30,55,30,110,30,165,30,220,30,275,30,330,30,385,30,440,30,495,30,550,30,605,30,0,60,55,60,110,60,165,60,220,60,275,60,330,60,385,60,440,60,495,60,550,60,605,60,0,90,55,90,110,90,165,90,220,90,275,90,330,90,385,90,440,90,495,90,550,90,605,90,0,120,55,120,110,120,165,120,220,120,275,120,330,120,385,120,440,120,495,120,550,120,605,120,0,150,55,150,110,150,165,150,220,150,275,150,330,150,385,150,440,150,495,150,550,150,605,150,0,180,55,180,110,180,165,180,220,180,275,180,330,180,385,180,440,180,495,180,550,180,605,180,0,210,55,210,110,210,165,210,220,210,275,210,330,210,385,210,440,210,495,210,550,210,605,210,0,240,55,240,110,240,165,240,220,240,275,240,330,240,385,240,440,240,495,240,550,240,605,240,0,270,55,270,110,270,165,270,220,270,275,270,330,270,385,270,440,270,495,270,550,270,605,270",0,1);
WP("0,0,55,0,110,0,220,0,275,0,330,0,385,0,495,0,550,0,605,0,0,30,605,30,0,60,605,60,0,120,605,120,0,150,605,150,0,210,605,210,0,240,605,240,0,270,55,270,110,270,220,270,275,270,330,270,385,270,495,270,550,270,605,270",25,1);
WP("0,0,55,0,110,0,165,0,220,0,275,0,330,0,385,0,440,0,495,0,550,0,605,0,0,30,605,30,0,60,605,60,0,90,605,90,0,120,605,120,0,150,605,150,0,180,605,180,0,210,605,210,0,240,605,240,0,270,55,270,110,270,165,270,220,270,275,270,330,270,385,270,440,270,495,270,550,270,605,270",50,1);
WP("0,0,55,0,110,0,165,0,220,0,275,0,330,0,385,0,440,0,495,0,550,0,605,0,0,30,605,30,0,60,605,60,0,90,605,90,0,120,605,120,0,150,605,150,0,180,605,180,0,210,605,210,0,240,605,240,0,270,55,270,110,270,165,270,220,270,275,270,330,270,385,270,440,270,495,270,550,270,605,270",75,1);
WP("0,0,55,0,110,0,495,0,550,0,605,0,0,30,605,30,0,60,605,60,0,210,605,210,0,240,605,240,0,270,55,270,550,270,605,270",100,1);
WP("0,0,55,0,110,0,495,0,550,0,605,0,0,30,605,30,0,60,605,60,0,210,605,210,0,240,605,240,0,270,55,270,550,270,605,270",125,1);
WP("0,0,55,0,110,0,165,0,220,0,275,0,330,0,385,0,440,0,495,0,550,0,605,0,0,30,55,30,110,30,165,30,220,30,275,30,330,30,385,30,440,30,495,30,550,30,605,30,0,60,55,60,110,60,165,60,220,60,275,60,330,60,385,60,440,60,495,60,550,60,605,60,0,90,55,90,110,90,165,90,220,90,275,90,330,90,385,90,440,90,495,90,550,90,605,90,0,120,55,120,110,120,165,120,220,120,385,120,440,120,495,120,550,120,605,120,0,150,55,150,110,150,165,150,220,150,385,150,440,150,495,150,550,150,605,150,0,180,55,180,110,180,165,180,220,180,275,180,330,180,385,180,440,180,495,180,550,180,605,180,0,210,55,210,110,210,165,210,220,210,275,210,330,210,385,210,440,210,495,210,550,210,605,210,0,240,55,240,110,240,165,240,220,240,275,240,330,240,385,240,440,240,495,240,550,240,605,240,0,270,55,270,110,270,165,270,220,270,275,270,330,270,385,270,440,270,495,270,550,270,605,270",150,1);
WP("220,90,275,90,330,90,385,90,220,120,385,120,220,150,385,150,220,180,275,180,330,180,385,180",175,1);
WP("220,90,275,90,330,90,385,90,220,120,385,120,220,150,385,150,220,180,275,180,330,180,385,180",200,1);
WP("220,90,275,90,330,90,385,90,220,120,385,120,220,150,385,150,220,180,275,180,330,180,385,180",225,1);
WP("0,0,55,0,110,0,165,0,220,0,275,0,330,0,385,0,440,0,495,0,550,0,605,0,0,30,55,30,110,30,165,30,220,30,275,30,330,30,385,30,440,30,495,30,550,30,605,30,0,60,55,60,110,60,165,60,220,60,275,60,330,60,385,60,440,60,495,60,550,60,605,60,0,90,55,90,110,90,165,90,220,90,275,90,330,90,385,90,440,90,495,90,550,90,605,90,0,120,55,120,110,120,165,120,220,120,385,120,440,120,495,120,550,120,605,120,0,150,55,150,110,150,165,150,220,150,385,150,440,150,495,150,550,150,605,150,0,180,55,180,110,180,165,180,220,180,275,180,330,180,385,180,440,180,495,180,550,180,605,180,0,210,55,210,110,210,165,210,220,210,275,210,330,210,385,210,440,210,495,210,550,210,605,210,0,240,55,240,110,240,165,240,220,240,275,240,330,240,385,240,440,240,495,240,550,240,605,240,0,270,55,270,110,270,165,270,220,270,275,270,330,270,385,270,440,270,495,270,550,270,605,270",250,1);
WP("0,0,55,0,110,0,165,0,220,0,275,0,330,0,385,0,440,0,495,0,550,0,605,0,0,30,605,30,0,60,605,60,0,90,605,90,0,120,605,120,0,150,605,150,0,180,605,180,0,210,605,210,0,240,605,240,0,270,55,270,110,270,165,270,220,270,275,270,330,270,385,270,440,270,495,270,550,270,605,270",275,1);
}

FOG(){level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );level._effect[ "FOW" ] = loadfx( "dust/nuke_aftermath_mp" );PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , 0 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , 2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , -2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 2000 , 0 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 2000 , 2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 2000 , -2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -2000 , 0 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -2000 , 2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -2000 , -2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , 4000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , -4000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 4000 , 0 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 4000 , 2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 4000 , -4000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -4000 , 0 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -4000 , 4000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -4000 , -4000 , 500 ));}