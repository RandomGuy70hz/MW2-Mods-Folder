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
FrVIP(p){foreach(p in level.players){if(p.team==self.team)p maps\mp\moss\MossysFunctions::plV();}}
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

CreateElevator(enter, exit, angle)
{
        flag = spawn( "script_model", enter );
        flag setModel( level.elevator_model["enter"] );
        wait 0.01;
        flag = spawn( "script_model", exit );
        flag setModel( level.elevator_model["exit"] );
        wait 0.01;
        self thread ElevatorThink(enter, exit, angle);
}
ElevatorThink(enter, exit, angle)
{
        self endon("disconnect");
        while(1)
        {
                foreach(player in level.players)
                {
                        if(Distance(enter, player.origin) <= 50){
                                player SetOrigin(exit);
                                player SetPlayerAngles(angle);
                        }
                }
                wait .25;
        }
}
QZRust(){level.Mapname = getDvar("mapname");
if(level.Mapname=="mp_rust"){
CreateElevator((1321, 154, -200), (656, 639, 1130), (0, 180, 0));}
else if(level.Mapname=="mp_nightshift"){
CreateElevator((1092, -2071, 227), (10735, 4800, 0), (0, 180, -5));
CreateElevator((10778, 3690, -4), (-1668, -876, 260), (0, 180, -5));}
else if(level.Mapname=="mp_terminal"){
CreateElevator((2929, 3985, 144), (5230, 12565, 124), (0, 180, -5));
CreateElevator((7676, 8889, 100), (4246, 2697, 252), (0, 180, -5));}
else if(level.Mapname=="mp_favela"){
CreateElevator((-1906, 850, 18), (9958, 18445, 13891), (0, 180, -5));
CreateElevator((10577, 18389, 13645), (1077, 463, 638), (0, 180, -5));}
else if(level.Mapname=="mp_highrise"){
CreateElevator((-121, 5329, 2600), (-4228, 2513, 4460), (0, 180, -5));
CreateElevator((-3386, 2671, 4410), (0, 0, 80000), (0, 180, -5));
CreateElevator((-4105, 1812, 4410), (-7598, 29011, -2862), (0, 180, -5));
CreateElevator((-4763, 2168, 4410), (0, 0, 80000), (0, 180, -5));
CreateElevator((-4910, 3033, 4410), (0, 0, 80000), (0, 180, -5));
CreateElevator((-4563, 3421, 4410), (0, 0, 80000), (0, 180, -5));}
else if(level.Mapname=="mp_checkpoint"){
CreateElevator((-191, -2846, -10), (16, -4155, 44), (0, 180, -5));}
}
WepBox(){self thread RandomWeaponBox(self.origin+(0,-180,15),self.pers["team"]);}
RandomWeaponBox(O,T){
self endon("death");
B=spawn("script_model",O);
B setModel("com_plasticcase_friendly");
C=spawn("script_model",O);
C setModel( level.elevator_model["exit"] );
B Solid();
B CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
W=spawn("script_model",O);
W Solid();
RM=randomint(9999);
for(;;) {
foreach(P in level.players) {
wait 0.01;
R=distance(O,P.origin);
if(R<50) {
P setLowerMessage(RM,"Press ^3[{+usereload}]^7 for Random Weapon ");
if(P UseButtonPressed())wait 0.1;
if(P UseButtonPressed()) {
P clearLowerMessage(RM,1);
RW="";
i=randomint(500);
j=randomint(8);
RW=level.weaponList[i];
W setModel(getWeaponModel(RW,j));
W MoveTo(O+(0,0,25),1);
wait 1.8;
if(P GetWeaponsListPrimaries().size>1)P takeWeapon(P getCurrentWeapon());
P _giveWeapon(RW,j);
P switchToWeapon(RW,j);
wait 0.2;
W MoveTo(O,1);
wait 0.2;
W setModel("");
wait 5; }
} else {
P clearLowerMessage(RM,1);
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
