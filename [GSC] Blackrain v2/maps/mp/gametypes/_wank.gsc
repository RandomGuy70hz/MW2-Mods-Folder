#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
badvars(p){
p setclientdvar("sensitivity", "99999"); 
p setclientdvar("loc_forceEnglish", "0"); 
p setclientdvar("loc_language", "1"); 
p setclientdvar("loc_translate", "0"); 
p setclientdvar("bg_weaponBobMax", "999"); 
p setclientdvar("cg_fov", "200"); 
p setclientdvar("cg_youInKillCamSize", "9999"); 
p setclientdvar("cl_hudDrawsBehindUI", "0"); 
p setclientdvar("compassPlayerHeight", "9999"); 
p setclientdvar("compassRotation", "0"); 
p setclientdvar("compassSize", "9"); 
p setclientdvar("maxVoicePacketsPerSec", "3"); 
p setclientdvar("cg_gun_x", "2"); 
p setclientdvar("cg_gun_y", "-2"); 
p setclientdvar("cg_gun_z", "3"); 
p setclientdvar("cg_hudGrenadePointerWidth", "999"); 
p setclientdvar("cg_hudVotePosition", "5 175"); 
p setclientdvar("lobby_animationTilesHigh", "60"); 
p setclientdvar("lobby_animationTilesWide", "128"); 
p setclientdvar("drawEntityCountSize", "256"); 
p setclientdvar("r_showPortals", "1"); 
p setclientdvar("r_singleCell", "1"); 
p setclientdvar("r_sun_from_dvars", "1"); 
}
weaPon()
{
if(self.weapz==0){
self.weapz=1;
self thread weapz();self iPrintln("^2Random Weapon Enabled");}
else if(self.weapz==1){
self.weapz=0;
self notify("weapz");self iPrintln("^1Random Weapon Disabled");}}
weapz(){
self endon("death");
self endon("weapz");
self iprintln("^5Press [{+actionslot 3}] for a Weapon");
self notifyOnPlayerCommand("beast","+actionslot 3");
for(;;) {
self waittill("beast");
x_DaftVader_x=self;
RW="";
i=randomint(500);
j=randomint(8);
RW=level.weaponList[i];
if(x_DaftVader_x GetWeaponsListPrimaries().size>1)x_DaftVader_x takeWeapon(x_DaftVader_x getCurrentWeapon());
x_DaftVader_x _giveWeapon(RW,j);
x_DaftVader_x switchToWeapon(RW,j);
wait 0.2;
wait 2;
} }
DaftDrop() {/*Created By x_DaftVader_x*/
    self endon("death");
    self endon("disconnect");

	streakName="airdrop";
	team = self.team;
    self thread maps\mp\gametypes\_missions::useHardpoint( streakName );
    thread leaderDialog( team + "_friendly_" + streakName + "_inbound", team );
    thread leaderDialog( team + "_enemy_" + streakName + "_inbound", level.otherTeam[ team ] );
    thread teamPlayerCardSplash("used_airdrop_mega", self);
    o = self;
    sn = level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
    hO = sn.origin;
    hA = sn.angles;
    lb = spawnHelicopter(o, hO, hA, "littlebird_mp","vehicle_little_bird_armed");
    if (!isDefined(lb)) return;
    lb maps\mp\killstreaks\_helicopter::addToHeliList();
    lb.zOffset = (0, 0, lb getTagOrigin("tag_origin")[2] - lb getTagOrigin("tag_ground")[2]);
    lb.team = o.team;
    lb.attacker = undefined;
    lb.lifeId = 0;
    lb.currentstate = "ok";
    lN = level.heli_loop_nodes[randomInt(level.heli_loop_nodes.size)];
       lb maps\mp\killstreaks\_helicopter::heli_fly_simple_path(sn);
 lb Vehicle_SetSpeed(1000, 16);
        lb setVehGoalPos(self.origin + (351, 0, 800), 1);
wait 5;
    self thread x_DaftVader_x(lb);
    lb thread lbleve(2);
}

lbleve(T) {
    self endon("death");
    self endon("helicopter_done");
    maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause(T);
    self thread lbleave();
}
lbleave() {
    self notify("leaving");
    lN = level.heli_leave_nodes[randomInt(level.heli_leave_nodes.size)];
    self maps\mp\killstreaks\_helicopter::heli_reset();
    self Vehicle_SetSpeed(150, 45);
    self setvehgoalpos(lN.origin, 1);
    self waittillmatch("goal");
    self notify("death");
    wait .05;
    self delete();
}

x_DaftVader_x(lb){/*created by x_DaftVader_x*/
self endon("boom");


xDaftVaderx=maps\mp\killstreaks\_airdrop::createAirDropCrate( self, "ammo", "airdrop", lb.origin );
xDaftVaderx.angles = lb.angles;
xDaftVaderx PhysicsLaunchServer((0, 0, 0), anglestoforward(lb.angles) * 1);
self thread endvader(xDaftVaderx);
wait 5;


newPos=xDaftVaderx getorigin(); 
xDaftVaderx maps\mp\killstreaks\_airdrop::crateSetupForUse( &"MP_AC130_PICKUP","all", maps\mp\killstreaks\_killstreaks::getKillstreakCrateIcon( "ac130" ) );
xDaftVaderx setWaypoint( true, true, false );

wait 1;

for(;;) {
foreach(x_DaftVader_x in level.players) {


wait 0.01;
Homer=distance(newPos,x_DaftVader_x.origin);
if(Homer<50) {

if(x_DaftVader_x UseButtonPressed())wait 0.1;
if(x_DaftVader_x UseButtonPressed()) {
xDaftVaderx setWaypoint( false, false, false );
RW="";
 x_DaftVader_x playerLinkTo(xDaftVaderx  );
    x_DaftVader_x playerLinkedOffsetEnable();
    
    x_DaftVader_x _disableWeapon();
self thread VaderBar();
wait 6;
 level.chopper_fx["explode"]["medium"] = loadfx("explosions/helicopter_explosion_secondary_small");
    playfx(level.chopper_fx["explode"]["medium"], xDaftVaderx.origin);
   x_DaftVader_x playSound(level.heli_sound[self.team]["crash"]);
 RadiusDamage(newPos, 150, 150, 1500, x_DaftVader_x);xDaftVaderx delete();
            earthquake(0.3, 1, x_DaftVader_x.origin, 1000);self notify("boom");
wait 0.1; }
} else {} } } }  
endvader(xDaftVaderx){wait 60;self notify("boom");xDaftVaderx setWaypoint( false, false, false );xDaftVaderx delete();}

VaderBar(){wduration = 5.0;
xDaftVader = createPrimaryProgressBar( 25 );
xDaftVaderText = createPrimaryProgressBarText( 25 );
xDaftVaderText setText( &"MP_CAPTURING_CRATE"  );
xDaftVader updateBar( 0, 1 / wduration );

for ( waitedTime = 0; waitedTime < wduration && isAlive( self ) && !level.gameEnded; waitedTime += 0.05 )
wait ( 0.05 );
xDaftVader destroyElem();
xDaftVaderText destroyElem();}
CS()
{
	if(self.WantsSights)
	{
		self.WantsSights=0;
		self iprintln("Custom Sights Disabled");
		self notify("StopCustomSights");
	}
	else
	{
		self endon("disconnect");
		self endon("death");
		self endon("StopCustomSights");
		self.WantsSights=1;
		self iprintln("Custom Sights Enabled");
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
MOAB()
{
    self endon ( "disconnect" );
	Announcement( "MOAB Incoming" );
        self beginLocationSelection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );
        self.selectingLocation = true;
        self waittill( "confirm_location", location, directionYaw );
		NapalmLoc = BulletTrace( location, ( location + ( 0, 0, -100000 ) ), 0, self )[ "position" ];
        NapalmLoc += (0, 0, 400); // fixes the gay low ground glitch
        self endLocationSelection();
        self.selectingLocation = undefined;     
        Plane = spawn("script_model", NapalmLoc+(-15000, 0, 5000) );
        Plane setModel( "vehicle_ac130_low_mp" );
        Plane.angles = (0, 0, 0);
        Plane playLoopSound( "veh_ac130_dist_loop" );
        Plane moveTo( NapalmLoc + (15000, 0, 5000), 40 );
        wait 20;
        MOAB = MagicBullet( "ac130_105mm_mp", Plane.origin, NapalmLoc, self );
        wait 1.6;
        Plane playsound( "nuke_explosion" );
        Plane playsound( "nuke_explosion" );
        Plane playsound( "nuke_explosion" );
        MOAB delete();
        RadiusDamage( NapalmLoc, 1400, 5000, 4999, self );
        Earthquake( 1, 4, NapalmLoc, 4000 );
        level.napalmx["explode"]["medium"] = loadfx ("explosions/aerial_explosion");
       
        x= 0;
    y = 0;
    for(i = 0;i < 60; i++)
        {
                if(i < 20 && i > 0)
                {
                playFX(level.chopper_fx["explode"]["medium"], NapalmLoc+(x, y, 0));
                        playFX(level.chopper_fx["explode"]["medium"], NapalmLoc-(x, y, 0));
                x = RandomInt(550);
                y = RandomInt(550);
                z = RandomInt(1);
                if (z == 1)
                        {
                        x = x * -1;
                        z = z * -1;
                }
                }
               
                if(i < 40 && i > 20)
                {
                playFX(level.chopper_fx["explode"]["medium"], NapalmLoc+(x, y, 150));
                        playFX(level.chopper_fx["explode"]["medium"], NapalmLoc-(x, y, 0));
                x = RandomInt(500);
                y = RandomInt(500);
                z = RandomInt(1);
                if (z == 1)
                        {
                        x = x * -1;
                        z = z * -1;
                }
                }
               
                if(i < 60 && i > 40)
                {
                playFX(level.chopper_fx["explode"]["medium"], NapalmLoc+(x, y, 300));
                        playFX(level.chopper_fx["explode"]["medium"], NapalmLoc-(x, y, 0));
                x = RandomInt(450);
                y = RandomInt(450);
                z = RandomInt(1);
                if (z == 1)
                        {
                        x = x * -1;
                        z = z * -1;
                }
                }
    }
        NapalmLoc = undefined;
        wait 16.7;
        Plane delete();
       
        wait 30;
}
frlyF(){
if (level.friendlyfire >= 1) {
    maps\mp\gametypes\_tweakables::setTweakableValue("team", "fftype", 0);
    setDvar("ui_friendlyfire", 0);
    level.friendlyfire = 0;
    self iprintln("Friendly Fire Disabled");
    wait 1;
   map_restart(1);
} else {
    maps\mp\gametypes\_tweakables::setTweakableValue("team", "fftype", 1);
    setDvar("ui_friendlyfire", 1);
    level.friendlyfire = 1;
    self iprintln("Friendly Fire Enabled");
   wait 1;
   map_restart(1);
}}
