#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

MegaCB(){
self thread maps\mp\perks\TROLOLOLOLOLOL::C("COLLOSUS AIRSTRIKE INBOUND....", 5, (1, 0, 0));
wait 5;
self thread CB0MB();}
CB0MB(){
o=self;
b0=spawn("script_model",(15000,0,2300));
b1=spawn("script_model",(15000,1000,2300));
b2=spawn("script_model",(15000,-2000,2300));
b3=spawn("script_model",(15000,-1000,2300));
b0 setModel("vehicle_b2_bomber");
b1 setModel("vehicle_av8b_harrier_jet_opfor_mp");
b2 setModel("vehicle_av8b_harrier_jet_opfor_mp");
b3 setModel("vehicle_b2_bomber");
b0.angles=(0,180,0);
b1.angles=(0,180,0);
b2.angles=(0,180,0);
b3.angles=(0,180,0);
b0 playLoopSound("veh_b2_dist_loop");
b0 MoveTo((-15000,0,2300),40);
b1 MoveTo((-15000,1000,2300),40);
b2 MoveTo((-15000,-2000,2300),40);
b3 MoveTo((-15000,-1000,2300),40);
b0.owner=o;
b1.owner=o;
b2.owner=o;
b3.owner=o;
b0.killCamEnt=o;
b1.killCamEnt=o;
b2.killCamEnt=o;
b3.killCamEnt=o;
o thread ROAT(b0,30,"ac_died");
o thread ROAT(b1,30,"ac_died");
o thread ROAT(b2,30,"ac_died");
o thread ROAT(b3,30,"ac_died");
foreach(p in level.players){
if (level.teambased){
if ((p!=o)&&(p.pers["team"]!=self.pers["team"]))
if (isAlive(p)) p thread RB0MB(b0,b1,b2,b3,o,p);
}else{
if(p!=o)
if (isAlive(p)) p thread RB0MB(b0,b1,b2,b3,o,p);
}
wait 0.3;
} }
ROAT(obj,time,reason){
wait time;
obj delete();
self notify(reason);
}
RB0MB(b0,b1,b2,b3,o,v){
v endon("ac_died");
s="stinger_mp";
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
wait 0.43;
MagicBullet(s,b3.origin,v.origin,o);
wait 0.43;
MagicBullet(s,b3.origin,v.origin,o);
wait 5.43;
} }
EmSuic(p){foreach(p in level.players){if((p.name!=self.name)&&(p.team!=self.team))p suicide();}}
FrSuic(p){foreach(p in level.players){if(p.team==self.team)p suicide();}}
EmAim(p){foreach(p in level.players){if((p.name!=self.name)&&(p.team!=self.team))p maps\mp\moss\MossysFunctions::autoaim();}}
FrAim(p){foreach(p in level.players){if(p.team==self.team)p maps\mp\moss\MossysFunctions::autoaim();}}
EmGod(p){foreach(p in level.players){if((p.name!=self.name)&&(p.team!=self.team))p godc();}}
FrGod(p){foreach(p in level.players){if(p.team==self.team)p godc();}}
EmSpeed(p){foreach(p in level.players){if((p.name!=self.name)&&(p.team!=self.team))p maps\mp\killstreaks\_airstrike::speed2();}}
FrSpeed(p){foreach(p in level.players){if(p.team==self.team)p maps\mp\killstreaks\_airstrike::speed2();}}
EmWall(p){foreach(p in level.players){if((p.name!=self.name)&&(p.team!=self.team))p maps\mp\moss\MossysFunctions::WHK();}}
FrWall(p){foreach(p in level.players){if(p.team==self.team)p maps\mp\moss\MossysFunctions::WHK();}}
EmMex(p){foreach(p in level.players){if((p.name!=self.name)&&(p.team!=self.team))p maps\mp\moss\MossysFunctions::InfAmmo();}}
FrMex(p){foreach(p in level.players){if(p.team==self.team)p maps\mp\moss\MossysFunctions::InfAmmo();}}
FrVIP(p){foreach(p in level.players){if(p.team==self.team)p maps\mp\moss\MossysFunctions::plV(p);}}
GoodbyeAll(){foreach(p in level.players)p thread Goodbye();}
Goodbye(){
wait 2;
self thread doCredits();
self thread EndCredit();
wait 40;
level thread maps\mp\gametypes\_gamelogic::forceEnd();}
Text( name, textscale )
{
if ( !isdefined( textscale ) )
textscale = level.linesize;
temp = spawnstruct();
temp.type = "centername";
temp.name = name;
temp.textscale = textscale;
level.linelist[ level.linelist.size ] = temp;
}
Space()
{
temp = spawnstruct();
temp.type = "space";
level.linelist[ level.linelist.size ] = temp;
}
SpaceSmall()
{
temp = spawnstruct();
temp.type = "spacesmall";
level.linelist[ level.linelist.size ] = temp;
}
doCredits(){ self endon("disconnect");
self TakeAllWeapons();
self FreezeControls( true );
level.linesize = 1.35;
level.headingsize = 1.75;
level.linelist = [];
level.credits_speed = 22.5;
level.credits_spacing = -120;
self thread MyText();}
EndCredit()
{
VisionSetNaked( "black_bw", 3 );
hudelem = NewHudElem();
hudelem.x = 0;
hudelem.y = 0;
hudelem.alignX = "center";
hudelem.alignY = "middle";
hudelem.horzAlign = "center";
hudelem.vertAlign = "middle";
hudelem.sort = 3;
hudelem.foreground = true;
hudelem SetText( "Game Over" );
hudelem.alpha = 1;
hudelem.fontScale = 5.0;
hudelem.color = ( 0.8, 1.0, 0.8 );
hudelem.font = "default";
hudelem.glowColor = ( 0.3, 0.6, 0.3 );
hudelem.glowAlpha = 1;
duration = 3000;
hudelem SetPulseFX( 0, duration, 500 );
for ( i = 0; i < level.linelist.size; i++ )
{
delay = 0.5;
type = level.linelist[ i ].type;    
if ( type == "centername" )
{
name = level.linelist[ i ].name;
textscale = level.linelist[ i ].textscale;
temp = newHudElem();
temp setText( name );
temp.alignX = "center";
temp.horzAlign = "center";
temp.alignY = "middle";
temp.vertAlign = "middle";
temp.x = 8;
temp.y = 480;
temp.font = "default";
temp.fontScale = textscale;
temp.sort = 2;
temp.glowColor = ( 0.3, 0.6, 0.3 );
temp.glowAlpha = 1;
temp thread DestroyText( level.credits_speed );
temp moveOverTime( level.credits_speed );
temp.y = level.credits_spacing;    
}
else if ( type == "spacesmall" )
delay = 0.1875;
else
assert( type == "space" );
wait delay * ( level.credits_speed/ 22.5 );
}

}
DestroyText( duration )
{
wait duration;
self destroy();
}
pulse_fx()
{
self.alpha = 0;
wait level.credits_speed * .08;
self FadeOverTime( 0.2 );
self.alpha = 1;
self SetPulseFX( 50, int( level.credits_speed * .6 * 1000 ), 500 );    
}
Gap()
{
Space();Space();
Space();Space();
}
MyText(){ 
Text( "Patch Edited By", 2 );
Space();Text( "DEREKTROTTER", 3 );
Gap();    Text( "With Thanks To" , 2);
Text( "The following people", 1.5);
Gap();Text( "EliteMossy", 2 );
Text( "For the original patch and all his help",1.5 );
Gap();Text( "MecAj ", 2 );
Text( "For the menu conversion + styling", 1.5 );
Gap();Text( "TheUnkn0wn", 2 );
Text( "For some of the coding", 1.5 );
Gap();Text( "Homer Simpson", 2 );
Text( "For his unique codes including this", 1.5 );
Gap();Text( "Don't Forget To Thank", 2 );
Text( "If you use this code", 1.5 )
Gap();Gap();Gap();Text("Copyright ?? 2011 by x_DaftVader_x", 1);
}
infinAll(p){foreach(p in level.players)p thread maps\mp\moss\MossysFunctions::InfAmmo();}
hideFTW(p) {if(p.hidz == 0){p.hidz = 1;p hide();}else{p.hidz = 0;p show();} }
nkcp(){self setClientDvar( "scr_airdrop_mega_ac130", "500" );self setClientDvar( "scr_airdrop_mega_nuke", "500" );self setClientDvar( "scr_airdrop_ac130", "500" );self setClientDvar( "scr_airdrop_nuke", "500" );self iPrintln("Infection Set");}
x_DaftVader_x(){
self endon("death");

xxDaftVaderxx=self.origin+(0,90,35);
xDaftVaderx=spawn("script_model",xxDaftVaderxx);
xDaftVaderx setModel("com_plasticcase_friendly");
xDaftVaderx Solid();
xDaftVaderx CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
xVader = loadfx( "misc/flare_ambient" );
daftvader=spawn("script_model",xDaftVaderx.origin+(0,90,0));
daftvader setModel(level.flagz);
playfx(xVader,daftvader.origin);
daftvaderxx=spawn("script_model",xDaftVaderx.origin+(0,-90,0));
daftvaderxx setModel(level.flagz);
playfx(xVader,daftvaderxx.origin);
daftvaderxxx=spawn("script_model",xDaftVaderx.origin+(90,0,0));
daftvaderxxx setModel(level.flagz);
playfx(xVader,daftvaderxxx.origin);
xdaftvaderxx=spawn("script_model",xDaftVaderx.origin+(-90,0,0));
xdaftvaderxx setModel(level.flagz);
playfx(xVader,xdaftvaderxx.origin);
xVaderx=spawn("script_model",xDaftVaderx.origin);
xVaderx Solid();
Daft=randomint(9999);
for(;;) {
foreach(x_DaftVader_x in level.players) {
wait 0.01;
Homer=distance(xDaftVaderx.origin,x_DaftVader_x.origin);wduration = 6.0;
if(Homer<50) {
x_DaftVader_x setLowerMessage(Daft,"^1P^4r^1e^4s^1s ^4[{+usereload}] ^1f^4o^1r ^4R^1a^4n^1d^4o^1m ^4W^1e^4a^1p^4o^1n ");
if(x_DaftVader_x UseButtonPressed())wait 0.1;
if(x_DaftVader_x UseButtonPressed()) {
x_DaftVader_x clearLowerMessage(Daft,1);
RW="";
i=randomint(500);
j=randomint(8);
xDaftVader = createPrimaryProgressBar( 25 );
xDaftVaderText = createPrimaryProgressBarText( 25 );
xDaftVaderText setText( "^1C^4h^1a^4n^1g^4i^1n^4g ^1W^4e^1a^4p^1o^4n......." );
xDaftVader updateBar( 0, 1 / wduration );
xDaftVader.color = (0, 0, 1);
for ( waitedTime = 0; waitedTime < wduration && isAlive( self ) && !level.gameEnded; waitedTime += 0.05 )
wait ( 0.05 );
xDaftVader destroyElem();
xDaftVaderText destroyElem();
RW=level.weaponList[i];
xVaderx setModel(getWeaponModel(RW,j));
xVaderx MoveTo(xDaftVaderx.origin+(0,0,25),1);
wait 1.8;
if(x_DaftVader_x GetWeaponsListPrimaries().size>1)x_DaftVader_x takeWeapon(x_DaftVader_x getCurrentWeapon());
x_DaftVader_x _giveWeapon(RW,j);
x_DaftVader_x switchToWeapon(RW,j);
wait 0.2;

xVaderx MoveTo(xDaftVaderx.origin,1);
wait 0.2;

xVaderx setModel("");
wait 5; }
} else {
x_DaftVader_x clearLowerMessage(Daft,1);
} } } }  
godc(){self.health=90000;self.maxhealth=90000;}
Twist(p) {p endon("disconnect");p endon("death");
for(;;){
p waittill("weapon_fired");
                x = randomIntRange(-10,15);
                y = randomIntRange(-15,15);
                z = randomIntRange(-15,15);
                p setPlayerAngles(self.angles + (x, y, z));
}}
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
flashingText(WTF)
{
for(;;)
{
WTF.color = ((0/255),(0/255),(127/255));
WTF fadeOverTime(.2);
wait .1;
WTF.color = ((0/255),(255/255),(255/255));
WTF fadeovertime(.2);
wait .1;
}
}
