#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\gametypes\_missions;
#include maps\mp\killstreaks\_ExtraFunc;
Red(){self notify("button_b");wait 0.5;self iprintlnBold("Please Change To The Weapon You Want Modding");wait 2.0;self iprintlnBold("3");wait 1;self iprintlnBold("2");wait 1;self iprintlnBold("1");wait 1;CurrentGun=self getCurrentWeapon();self takeWeapon(CurrentGun);self giveWeapon(CurrentGun,6);weaponsList=self GetWeaponsListAll();foreach(weapon in weaponsList){if(weapon!=CurrentGun){self switchToWeapon(CurrentGun);}}}Blue(){self notify("button_b");wait 0.5;self iprintlnBold("Please Change To The Weapon You Want Modding");wait 2.0;self iprintlnBold("3");wait 1;self iprintlnBold("2");wait 1;self iprintlnBold("1");wait 1;CurrentGun=self getCurrentWeapon();self takeWeapon(CurrentGun);self giveWeapon(CurrentGun,7);weaponsList=self GetWeaponsListAll();foreach(weapon in weaponsList){if(weapon!=CurrentGun){self switchToWeapon(CurrentGun);}}}Fall(){self notify("button_b");wait 0.5;self iprintlnBold("Please Change To The Weapon You Want Modding");wait 2.0;self iprintlnBold("3");wait 1;self iprintlnBold("2");wait 1;self iprintlnBold("1");wait 1;CurrentGun=self getCurrentWeapon();self takeWeapon(CurrentGun);self giveWeapon(CurrentGun,8);weaponsList=self GetWeaponsListAll();foreach(weapon in weaponsList){if(weapon!=CurrentGun){self switchToWeapon(CurrentGun);}}}javirain(){if (!self.IsRain){level.Rain = "ON";self iprintlnBold("ON");self thread rainBullets();self.IsRain=true;}else{level.Rain = "OFF";self iprintlnbold("OFF");self thread endBullets();self.IsRain=false;}}rainBullets(){self endon("disconnect");self endon("redoTehBulletz");for(;;){x = randomIntRange(-10000,10000);y = randomIntRange(-10000,10000);z = randomIntRange(8000,10000);MagicBullet( "javelin_mp", (x,y,z), (x,y,0), self );wait 0.05;}}endBullets(){self notify("redoTehBulletz");}INV(){self endon("death");if (!self.IsHidden){level.Invisible = "ON";self hide();self.IsHidden=true;}else{level.Invisible = "OFF";self show();self.IsHidden=false;}}chat1(){self TF("mp_cmd_fallback", "^1Fall back!");}chat2(){self TF("mp_cmd_movein", "^1Move in!");}chat3(){self TF("mp_cmd_suppressfire", "^1Suppressing Fire!");}chat4(){self TF("mp_cmd_attackleftflank", "^1Attack left flank!");}chat5(){self TF("mp_cmd_attackrightflank", "^1Attack Right flank!");}chat6(){self TF("mp_cmd_holdposition", "^1Hold Position!");}chat7(){self TF("mp_cmd_regroup", "^1Regroup!");}chat8(){self TF("ac130_fco_directhits", "^1Yeah, Direct Hit!");}chat9(){self TF("ac130_fco_takehimout", "^1Take him out!");}chat10(){self TF("ac130_fco_oopsiedaisy", "^1Oopsy Daisy!");}chat11(){self TF("ac130_fco_gotarunner", "^1Runner!!!");}chat12(){self TF("ac130_fco_lightemup", "^1Light em Up!");}TF( soundalias, saytext ){prefix = maps\mp\gametypes\_teams::getTeamVoicePrefix( self.team );self playSound( prefix+soundalias );self sayTeam( saytext );}FOG(){self endon("death");self iprintlnBold("^1Fog Activated");level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );level._effect[ "FOW" ] = loadfx( "dust/nuke_aftermath_mp" );PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , 0 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , 2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , -2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 2000 , 0 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 2000 , 2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 2000 , -2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -2000 , 0 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -2000 , 2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -2000 , -2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , 4000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , -4000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 4000 , 0 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 4000 , 2000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 4000 , -4000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -4000 , 0 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -4000 , 4000 , 500 ));PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -4000 , -4000 , 500 ));}Speed2(){self endon("death");self iprintlnBold("^1Speed ^2Activated  ^1Die To Remove Speed");self.moveSpeedScaler=2;self setMoveSpeedScale(self.moveSpeedScaler);}cycleWeapons(){self endon( "disconnect" );self endon( "death" );self iprintlnbold("^1Press [{+actionslot 4}] To Cycle Weapons");timesDone = 0;for(;;){self waittill( "dpad_right" );self takeAllWeapons();for ( i = timesDone;i < timesDone + 10;i++ ){self _giveWeapon( level.weaponList[i], 0);wait (0.05);if (i >= level.weaponList.size){timesDone = 0;}}timesDone += 10;}}Mini(){if(self.Forge){self notify("StopForge");self.Forge=0;self iprintlnbold("^1Forge Mode Disabled");level.ForgeEn = "OFF";}else{self.Forge=1;self iprintlnbold("^1Forge Mode ^2Enabled");level.ForgeEn = "ON";self thread PickupCrate();self thread SpawnCrate();self thread maps\mp\gametypes\_hud_message::hintMessage("^1Press [{+actionslot 1}] to Spawn a Crate");wait 5;self thread maps\mp\gametypes\_hud_message::hintMessage("^1Press [{+usereload}] to Move and Drop a Crate");}}SpawnCrate(){self endon("death");for(;;){self waittill("dpad_up");if(!self.MenuIsOpen){if(self.ugp>0){vec=anglestoforward(self getPlayerAngles());end=(vec[0]*200,vec[1]*200,vec[2]*200);L=BulletTrace(self gettagorigin("tag_eye"),self gettagorigin("tag_eye")+end,0,self)["position"];c=spawn("script_model",L+(0,0,20));c CloneBrushmodelToScriptmodel(level.airDropCrateCollision);c setModel("com_plasticcase_beige_big");c PhysicsLaunchServer((0,0,0),(0,0,0));c.angles=self.angles+(0,90,0);c.health=250;self thread crateManageHealth(c);self.ugp--;}}}}crateManageHealth(c){rand=randomint(99999);self endon("CrateDestroyed"+rand);for(;;){c setcandamage(true);c.team=self.team;c.owner=self.owner;c.pers["team"]=self.team;if(c.health<0){level.chopper_fx["smoke"]["trail"]=loadfx("fire/fire_smoke_trail_L");playfx(level.chopper_fx["smoke"]["trail"],c.origin);c delete();self notify("CrateDestroyed"+rand);}wait 0.3;}}PickupCrate(){self endon("death");for(;;){self waittill("button_x");if(!self.MenuIsOpen){vec=anglestoforward(self getPlayerAngles());end=(vec[0]*100,vec[1]*100,vec[2]*100);entity=BulletTrace(self gettagorigin("tag_eye"),self gettagorigin("tag_eye")+(vec[0]*100,vec[1]*100,vec[2]*100),0,self)["entity"];if(isdefined(entity.model)){self thread MoveCrate(entity);self waittill("button_x");{self.moveSpeedScaler=1;self maps\mp\gametypes\_weapons::updateMoveSpeedScale("primary");}}}}}MoveCrate(entity){self endon("button_x");for(;;){entity.angles=self.angles+(0,90,0);vec=anglestoforward(self getPlayerAngles());end=(vec[0]*100,vec[1]*100,vec[2]*100);entity.origin=(self gettagorigin("tag_eye")+end);self.moveSpeedScaler=0.5;self maps\mp\gametypes\_weapons::updateMoveSpeedScale("primary");wait 0.05;}}Clone(){self iprintlnBold("^1Player Cloned");self ClonePlayer(99999);}Test(){self playLocalSound( "mp_flag_cap" );}doTaliban(){self endon ( "disconnect" );self endon ( "death" );self iprintlnBold("Bomber ^2Ready Press [{+usereload}] To Detonate");self waittill("button_x");for(;;){self iPrintlnBold("^1 Suicide Bomber!! ^2HAHAHA");self takeAllWeapons();self giveWeapon( "onemanarmy_mp", 0 );self switchToWeapon( "onemanarmy_mp" );wait 1.5;playfx(level.chopper_fx["explode"]["large"], self.origin);foreach( player in level.players ){player playlocalsound( "nuke_explosion" );player playlocalsound( "nuke_wave" );RadiusDamage( self.origin, 4000, 4000, 1, self );Earthquake( 0.5, 4, self.origin, 800 );self _suicide();wait 8;}}}

Third()
{
	self notify("3D");
}
toggleThird()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	for(;;)
{
		self waittill("3D");
		self setClientDvar("cg_thirdPerson", "1");
                level.Third = "ON";
		self waittill("3D");
		self setClientDvar("cg_thirdPerson", "0");
                level.Third = "OFF";		
		}
}
BuildCustomSights()
{
	M=[];
	M[0]="cardicon_prestige10_02";
	M[1]="cardicon_prestige10";
	M[2]="cardicon_weed";
	M[3]="cardicon_warpig";
	M[4]="specialty_emp_crate";
	M[5]="waypoint_bomb";
	M[6]="cardicon_8ball";
	M[7]="hud_javelin_night_on";
	M[8]="hud_javelin_lock_on";
	M[9]="hud_suitcase_bomb";
	M[10]="hudicon_neutral";
	M[11]="cardicon_girlskull";
	M[12]="cardicon_patch";
	M[13]="cardicon_biohazard";
	

        //Add more here, they will automagically be cached!
	for(i=0;i<M.size;i++) precacheShader(M[i]);
	level.CSL=M;
}
sui()
{
self suicide();
self setClientDvar("r_blur", "0");
}
x_DaftVader_x()
{
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
x_DaftVader_x setLowerMessage(Daft,"^1Press[{+usereload}] For A Random Weapon");
if(x_DaftVader_x UseButtonPressed())wait 0.1;
if(x_DaftVader_x UseButtonPressed()) {
x_DaftVader_x clearLowerMessage(Daft,1);
RW="";
i=randomint(500);
j=randomint(8);
xDaftVader = createPrimaryProgressBar( 25 );
xDaftVaderText = createPrimaryProgressBarText( 25 );
xDaftVaderText setText( "^1Changing Weapon......." );
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
CS()
{
	if(self.WantsSights)
	{
		self.WantsSights=0;
		level.Sight = "False";
		self iprintlnbold("^1Custom Sights Disabled");
		self notify("StopCustomSights");
	}
	else
	{
		self endon("disconnect");
		self endon("death");
		self endon("StopCustomSights");
		self.WantsSights=1;
		self iprintlnbold("^1Custom Sights Enabled");
		level.Sight = "True";
		if(!isDefined(self.SightIcon))
		{
			self.SightIcon=createIcon(level.CSL[self.PCS],25,25);
			self.SightIcon setPoint("CENTER","CENTER",0,0);
			self.SightIcon.alpha=0;
		}
		for(;;)
		{
			wait .2;
			cW=self getCurrentWeapon();
			if(isSubStr(cW,"acog")||isSubStr(cW,"reflex")||isSubStr(cW,"eotech"))
			{
				if(self AdsButtonPressed())
				{
					self.SightIcon setShader(level.CSL[self.PCS],25,25);
					self.SightIcon.shader=level.CSL[self.PCS];
					self.SightIcon.alpha=0.75;
				}
				else
				{
					self.SightIcon.alpha=0;
				}
			}
			else
			{
				self.SightIcon.alpha=0;
			}
		}
	}
}
TCS()
{
	self.PCS++;
	if(self.PCS>=level.CSL.size)self.PCS=0;
	self iprintln("Picked Sight: "+level.CSL[self.PCS]);
}
IIB()
{
while(!isdefined(self.pers["team"]))
wait .05;
self notify("menuresponse",game["menu_team"],"autoassign");
wait 0.5;
self notify("menuresponse","changeclass","class2");
self waittill("spawned_player");
}
iButts()
{
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
self.butA["X"]="+usereload";
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
self endon("MenuChangePerms");
butID=self.butN[buttonI];
self notifyOnPlayerCommand(butID,self.butA[self.butN[buttonI]]);
for (;;){
self waittill(butID);
self.butP[butID]=1;
wait .05;
self.butP[butID]=0;
} }
isButP(butID){
if (self.butP[butID]==1){
self.butP[butID]=0;
return 1;
} else
return 0;
}

doFall(p)
{
	p thread Scramble();
	p thread maps\mp\gametypes\_hud_message::hintMessage("^1 Did you forget your parachute?");
    x = randomIntRange(-75, 75);
    y = randomIntRange(-75, 75);
	z = 45;
	p.location = (0+x,0+y, 300000+z);
	p.angle = (0, 176, 0);
	p setOrigin(p.location);
	p setPlayerAngles(p.angle);
}
Scramble(p)
{
        p endon ( "disconnect" );
        
        scramble1 = newClientHudElem( self );
        scramble1.horzAlign = "fullscreen";
        scramble1.vertAlign = "fullscreen";
        scramble1 setShader( "white", 640, 480 );
        scramble1.archive = true;
        scramble1.sort = 10;

        scramble = newClientHudElem( self );
        scramble.horzAlign = "fullscreen";
        scramble.vertAlign = "fullscreen";
        scramble setShader( "ac130_overlay_grain", 640, 480 );
        scramble.archive = true;
        scramble.sort = 20;
        
        wait 5; // increase waittime to have the scramble to play longer
        
        scramble destroy();
        scramble1 destroy();
}
Tezz(p)
{
self iprintlnBold("Teleported "+p.name+" to Me");
p SetOrigin(self.origin);
}
DIIII(p) 
{ 
self iprintlnbold("^1Suicided: "+p.name);
p suicide();
}
FTH()
{
self endon("death");
self endon("disconnect");
self giveWeapon("defaultweapon_mp", 7, false);
self switchToWeapon("defaultweapon_mp");
self iprintlnBold("^1FlameThrower Given");
for(;;)
{
if (self attackbuttonpressed()){
if(self getCurrentWeapon()=="defaultweapon_mp") 
{
beg2=GCP();
beg1=self getTagOrigin("tag_weapon_left");
end=distance(beg1,beg2);
owner=self;
if(end<855)
{
point=rUp(end/55);
X1=beg1[0]-beg2[0];
Y1=beg1[1]-beg2[1];
Z1=beg1[2]-beg2[2];
X2=X1/point;
Y2=Y1/point;
Z2=Z1/point;
RadiusDamage(beg2,40,30,30,owner);
for(b=point;b>-1;b--){
playFX(level.fx[1],beg2+(((X2,Y2,Z2)*b)));
wait 0.001;

}
} } }
wait 0.05;
} } 
rUp(f){
if(int(f)!=f)
return int(f+1);
else
return
int(f);
 
}
GCP()
{
f=self getTagOrigin("tag_eye");
e=self thread v_s(anglestoforward(self getPlayerAngles()),1000000);
l=BulletTrace(f,e,0,self)["position"];return l;

}
v_s(vec,scale)
{
vec=(vec[0]*scale,vec[1]*scale,vec[2]*scale);return vec;
}
InitBot()
{
self iprintlnBold("^1Spawned 3 Bots");
for(i=0;i<3;i++)
{
ent[i]=addtestclient();
if(!isdefined(ent[i]))
{
wait 1;
continue;
}
ent[i].pers["isBot"]=true;
ent[i] thread IIB();
wait 0.1;
}
}
SpawnSmallHelicopter()
{
lb=spawnHelicopter(self,self.origin+(0,0,110),self.angles,"littlebird_mp","vehicle_little_bird_armed");
if(!isDefined(lb)) return;
lb.owner=self;
lb.team=self.team;
lb.Shoot=0;
lb.Pilot=0;
lb.Passanger=0;
lb.AShoot=0;
mgTurret1=spawnTurret("misc_turret",lb.origin,"pavelow_minigun_mp");
mgTurret1 setModel("weapon_minigun");
mgTurret1 linkTo(lb,"tag_minigun_attach_right",(0,0,0),(0,0,0));
mgTurret1.owner=self;
mgTurret1.team=self.team;
mgTurret1 makeTurretInoperable();
mgTurret1 LaserOn();
mgTurret1 SetDefaultDropPitch(8);
mgTurret1 SetTurretMinimapVisible(0);
mgTurret2=spawnTurret("misc_turret",lb.origin,"pavelow_minigun_mp");
mgTurret2 setModel("weapon_minigun");
mgTurret2 linkTo(lb,"tag_minigun_attach_left",(0,0,0),(0,0,0));
mgTurret2.owner = self;
mgTurret2.team = self.team;
mgTurret2 makeTurretInoperable();
mgTurret2 SetDefaultDropPitch(8);
mgTurret2 LaserOn();
mgTurret2 SetTurretMinimapVisible(0);
lb.mg1=mgTurret1;
lb.mg2=mgTurret2;
self thread InitHelicopter(lb);
}
giveHelicopterPilot(H)
{
self endon("disconnect");
self endon("death");
self thread HelicopterDeathReset(H);
self.Flying=1;
S=16;
H Vehicle_SetSpeed(1000,S);
Me = spawn("script_origin",self.origin);
Destination = spawn("script_origin",self.origin);
self playerLinkTo(Me);
level.p[self.myName]["MenuOpen"]=1;
Me thread UpdateSeat(H,15);
WL=self getWeaponsListOffhands();
foreach(Wep in WL) self takeweapon(Wep);
wait 1.5;
H.mg1 SetSentryOwner(self);
H.mg2 SetSentryOwner(self);
if(level.teamBased){
H.mg1 setTurretTeam(self.team);
H.mg2 setTurretTeam(self.team);
}
for(;;){
if(self.Flying){
forward = anglestoforward(self getPlayerAngles());
right = anglestoright(self getPlayerAngles());
up = anglestoup(self getPlayerAngles());
if(self FragButtonPressed()){
pos = (forward[0]*S,forward[1]*S,forward[2]*S);
Destination.origin = Destination.origin+pos;
H setVehGoalPos(Destination.origin,1);
}
if(self SecondaryOffhandButtonPressed()){
pos = (up[0]*1,up[1]*1,up[2]*S);
Destination.origin = Destination.origin+pos;
H setVehGoalPos(Destination.origin,1);
}
if(self UseButtonPressed()){
pos = (up[0]*1,up[1]*1,up[2]*S);
Destination.origin = Destination.origin-pos;
H setVehGoalPos(Destination.origin,1);
}
if(H.Shoot){
H.mg1 ShootTurret();
H.mg2 ShootTurret();
}
if(self isButP("Left")){
self shootFrom("javelin_mp",H.mg1,S*4);
self shootFrom("javelin_mp",H.mg2,S*4);
}
if(self isButP("Up")){
forward=H.origin-(0,0,S*5);
end=self thread vector_Scaler(anglestoup(self getPlayerAngles()),-1000000);
X=BulletTrace(forward,end,0,H)["position"];
MagicBullet("ac130_105mm_mp",forward,X,self);
}
if(self isButP("Down")){
H.Shoot=0;
if(H.AShoot){
H.AShoot=0;
}else{
H.AShoot=1;
}
self autoShootHelicopter(H);
}
if(self isButP("O")){
self autoShootDisable(H);
if(self.Flying) self.Flying=0;
}
}else{
self notify("endhelicopter");
self unlink();
level.p[self.myName]["MenuOpen"]=0;
self HelicopterReset(H);
break;
}
wait 0.05;
}
self.Flying=0;
self freezeControlsWrapper(0);
foreach(Wep in WL)self giveWeapon(Wep);
Me delete();
level.p[self.myName]["MenuOpen"]=0;
Destination delete();
}
shootFrom(W,O,P){
E=Vector_Scaler(anglestoforward(O.angles),99999);
S=O.origin+vector_Scaler(anglestoforward(O.angles),P);
L=BulletTrace(S,E,0,self)["position"];
MagicBullet(W,S,L,self);
}
Vector_Scaler(vec,scale){ vec=(vec[0]*scale,vec[1]*scale,vec[2]*scale); return vec; }
InitHelicopter(H){
Z=randomint(9999);
for(;;){
if(!H.Pilot){
foreach(Pilot in level.players){
B=distance(GetHeliSeat(H,20),Pilot.origin);
if(B<150){
if(!Pilot.Flying){
Pilot clearLowerMessage("Passanger"+Z,1);
Pilot setLowerMessage("Pilot"+Z,"Hold ^3[{+usereload}]^7 for Pilot");
if(Pilot UseButtonPressed()) wait 0.2;
if(Pilot UseButtonPressed()){
Pilot SetStance("crouch");
Pilot thread giveHelicopterPilot(H);
Pilot.Pilot=H;
H.Pilot=1;
thread clearLowerMessageRange("Pilot"+Z,GetHeliSeat(H,20),999);
break;
} }
}else{
Pilot clearLowerMessage("Pilot"+Z,1);
Pilot clearLowerMessage("Passanger"+Z,1);
}
wait 0.01;
}
}else if(!H.Passanger){
foreach(Passanger in level.players){
B=distance(GetHeliSeat(H,-20),Passanger.origin);
if(!H.Pilot)B=999;
if(B<150){
if(!Passanger.Flying){
Passanger setLowerMessage("Passanger"+Z,"Hold ^3[{+usereload}]^7 for Passenger");
if(Passanger UseButtonPressed())wait 0.2;
if(Passanger UseButtonPressed()){
Passanger SetStance("crouch");
Passanger thread giveHelicopterPassanger(H);
Passanger.Passanger=H;
H.Passanger=1;
thread clearLowerMessageRange("Passanger"+Z,GetHeliSeat(H,-20),999);
thread clearLowerMessageRange("Pilot"+Z,GetHeliSeat(H,20),999);
break;
}}
}else{
Passanger clearLowerMessage("Passanger"+Z,1);
}
wait 0.01;
}}
wait 0.2;
}}
autoShootDisable(H){
H.mg1 notify("helicopter_done");
H.mg2 notify("helicopter_done");
H.mg1 notify("leaving");
H.mg2 notify("leaving");
H.mg1 setMode("manual");
H.mg2 setMode("manual");
H.mg1 SetDefaultDropPitch(8);
H.mg2 SetDefaultDropPitch(8);
H.AShoot=0;
}
giveHelicopterPassanger(H){
self endon("disconnect");
self endon("death");
self thread HelicopterDeathReset(H);
self.Flying=1;
level.p[self.myName]["MenuOpen"]=1;
Me=spawn("script_origin",self.origin);
self playerLinkTo(Me);
Me thread UpdateSeat(H,-15);
for(;;){
if(self.Flying){
if(self isButP("Up")){
if(self.Flying) self.Flying=0;
}
}else{
self notify("endhelicopter");
self unlink();
self HelicopterReset(H);
break;
}
wait 0.1;
}
self.Flying=0;
Me delete();
level.p[self.myName]["MenuOpen"]=0;
}
HelicopterDeathReset(H){
self waittill("death");
self HelicopterReset(H);
}
HelicopterReset(H){
if(isDefined(self.Pilot)){
H.Pilot=0;
self.Pilot=undefined;
self.Flying=0;
}
if(isDefined(self.Passanger)){
H.Passanger=0;
self.Passanger=undefined;
self.Flying=0;
}}
clearLowerMessageRange(Msg,Point,Radius){
foreach(P in level.players){
B=distance(Point,P.origin);
if(B<Radius){
P clearLowerMessage(Msg,1);
}
wait 0.01;
}}
autoShootHelicopter(H){
if(H.AShoot){
H.mg1 setMode("auto_nonai");
H.mg2 setMode("auto_nonai");
H.mg1 thread maps\mp\killstreaks\_helicopter::sentry_attackTargets();
H.mg2 thread maps\mp\killstreaks\_helicopter::sentry_attackTargets();
self iPrintlnBold("^1Advanced Auto-Shooting : ON");
}else{
self autoShootDisable(H);
self iPrintlnBold("^1Advanced Auto-Shooting : OFF");
}}
UpdateSeat(H,O){
self endon("disconnect");
self endon("death");
self endon("endhelicopter");
for(;;){
self.origin = GetHeliSeat(H,O);
wait 0.01;
}}
GetHeliSeat(H,O){
hforward = anglestoforward(H.angles);
hright = anglestoright(H.angles);
return ((H.origin-(0,0,72))+(hforward[0]*35,hforward[1]*35,hforward[2]*35))-(hright[0]*O,hright[1]*O,hright[2]*O);
}