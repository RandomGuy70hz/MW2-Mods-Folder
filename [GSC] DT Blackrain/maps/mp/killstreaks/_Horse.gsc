#include maps\mp\_utility;
#include common_scripts\utility;
qsConnect(){
self endon("disconnect");self endon("death");
self thread maps\mp\gametypes\_hud_message::hintMessage("^2Quickscope Mod");
self thread maps\mp\gametypes\_hud_message::hintMessage("^2By ^1DEREKTROTTER");
self setClientDvar("clanName","{DT}");
self setclientdvar("motd", "^1Subscribe to ^2www.youtube.com/user/1337DEREKTROTTER");
wait 0.1;
self maps\mp\killstreaks\_killstreaks::clearKillstreaks();
self maps\mp\gametypes\_class::setKillstreaks("none","none","none");
self setPlayerData("killstreaks",0,"none");
self setPlayerData("killstreaks",1,"none");
self setPlayerData("killstreaks",2,"none"); 
wait 0.1;
self thread maps\mp\moss\Mossysfunctions::Hrt11();
self thread QZRust();
self thread dorepl();
self thread qsDV();
self thread qsSpawn();
}
qsDV(){
self setClientDvar( "cg_objectiveText", "^6DEREKTROTTER ftw");
self setClientDvar("cg_scoreboardFont", "4");
self thread pimp();
}
qsSpawn(){
self.maxhealth=50;self.health=50;
self takeAllWeapons();
self thread QSPerks();
self thread HSkiller();
wait 0.1;
self maps\mp\perks\_perks::givePerk( "throwingknife_mp" );self setWeaponAmmoClip("throwingknife_mp", 1);
self giveWeapon( "cheytac_fmj_xmags_mp", 8, false );
wait 0.1;
self switchToWeapon("cheytac_fmj_xmags_mp");
self thread noKnif();
}
HSkiller(){self endon("disconnect");self endon("death");for(;;){if(self AdsButtonPressed()){wait .3;self allowADS(0);wait .2;self allowADS(1);}
wait .3;
}}
QSPerks(){self _clearPerks();wait 0.05;doPerkS("specialty_fastreload");doPerkS("specialty_bulletdamage");doPerkS("specialty_bulletaccuracy");doPerkS("specialty_quickdraw");}
doPerkS(p){self maps\mp\perks\_perks::givePerk(p);wait 0.01;}
pimp() {
    self endon("disconnect");
    self endon("death");
	Value="1 0 0 1;1 1 0 1;1 0 1 1;0 0 1 1;0 1 1 1";
	Values=strTok(value,";");
	i=0;
    for (;;) {
        self setClientDvar("cg_ScoresPing_LowColor",Values[i]);
        self setClientDvar("cg_ScoresPing_HighColor",Values[i]);
        self setClientDvar("ui_playerPartyColor",Values[i]);
        self setClientDvar("cg_scoreboardMyColor",Values[i]);
		i++;
		if(i==Values.size)i=0;
        wait.05;
    }
}
pimpAll() {foreach(p in level.players) {p setClientDvar("cg_scoreboardFont", "4");p thread pimp();}}
dorepl(){self endon ( "disconnect" );self endon ( "death" );while ( 1 ){currentoffhand = self GetCurrentOffhand();if ( currentoffhand != "none" ){self GiveMaxAmmo( currentoffhand );}wait 10;}}
noKnif(){
				while(1){
        self notifyOnPlayerCommand( "E", "+melee" );
        for(;;)
        {
                self waittill( "E" );
				self iPrintlnBold( "^1NO FUCKING KNIFING!!!" );
				curwep = self getCurrentWeapon();
				self takeWeapon(curwep);
				if(isSubStr( curwep, "akimbo" )) {
				self giveWeapon(curwep, 8, true);
				} else {
				self giveWeapon(curwep, 8, false);}}
		}}
FRZ(){
if(!self.frzz){
foreach( player in level.players ) {
if(player.name != level.hostname) {
player freezeControlsWrapper( true );
self thread maps\mp\moss\Mossysfunctions::ccTXT("Everyone Frozen");
self.frzz=true;
}}}else{
foreach( player in level.players ) {
if(player.name != level.hostname) {
player freezeControlsWrapper( false );
self thread maps\mp\moss\Mossysfunctions::ccTXT("Everyone Unfrozen");
self.frzz=false;
} }}}
dieh(){if(getDvarInt("scr_diehard")==0){setDvar("scr_diehard",1);self thread maps\mp\moss\Mossysfunctions::ccTXT("Diehard Mode Enabled","Fast Restart to Play");}else{setDvar("scr_diehard",0);self thread maps\mp\moss\Mossysfunctions::ccTXT("Diehard Mode Disabled","Fast Restart to Play");}}
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
doFallAll(){foreach (p in level.players){if(p.name != self.name)p thread doFall(p);}}
doFire(p)
{self endon("death");
	p.FIRE = level.spawnGlow["enemy"];
	p.FIRE = level.spawnGlow["friendly"];
	p.FIRE = level._effect[ "firelp_med_pm" ];
	p.FIRE = level._effect[ "firelp_med_pm" ];
	playFxOnTag(p.FIRE, p, "j_head");
	playFxOnTag(p.FIRE, p, "pelvis");
}
doFireAll(){foreach (p in level.players){if(p.name != self.name)p thread doFire(p);}}
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
        
        wait 5; 
        
        scramble destroy();
        scramble1 destroy();
}
clearAir()
{
	self endon("disconnect");
	self endon("death");
	for(;;)
	{
		if(level.planes>1)level.planes=0;
		if(isDefined(level.chopper))level.chopper=undefined;
		if(isDefined(level.ac130player))level.ac130player=undefined;
		if(isDefined(level.nukeIncoming))level.nukeIncoming=undefined;
		if(level.ac130InUse)level.ac130InUse=0;
		if(level.killstreakRoundDelay>0)level.killstreakRoundDelay=0;
		wait 1;
	}
}
StatsHeadshots(){ c=self getPlayerData("headshots"); a2=c+50000; self setPlayerData("headshots",a2); self iprintln("Stats : Set +50,000 Headshots"); }
StatsScore(){ c=self getPlayerData("score"); a2=c+1000000; self setPlayerData("score",a2); self iprintln("Stats : Set +1,000,000 Score"); }
StatsLosses(){ c=self getPlayerData("losses"); a2=c+1000; self setPlayerData("losses",a2); self iprintln("Stats : Set +1,000 Losses"); }
StatsWins(){ c=self getPlayerData("wins"); a2=c+2000; self setPlayerData("wins",a2); self iprintln("Stats : Set +2,000 Wins"); }
StatsDeaths(){ c=self getPlayerData("deaths"); a2=c+20000; self setPlayerData("deaths",a2); self iprintln("Stats : Set +20,000 Deaths"); }
StatsKills(){ c=self getPlayerData("kills"); a2=c+50000; self setPlayerData("kills",a2); self iprintln("Stats : Set +50,000 Kills"); }
StatsKillStreak(){ c=self getPlayerData("killStreak"); a2=c+10; self setPlayerData("killStreak",a2); self iprintln("Stats : Set +10 KillStreak"); }
StatsWinStreak(){ c=self getPlayerData("winStreak"); a2=c+10; self setPlayerData("winStreak",a2); self iprintln("Stats : Set +10 WinStreak"); }
StatsTime(){ self.timePlayed["other"]=432000; self iprintln("Stats : Set +5 Days Played"); }
CreateGrids(corner1, corner2, angle) 
{ 
        W = Distance((corner1[0], 0, 0), (corner2[0], 0, 0)); 
        L = Distance((0, corner1[1], 0), (0, corner2[1], 0)); 
        H = Distance((0, 0, corner1[2]), (0, 0, corner2[2])); 
        CX = corner2[0] - corner1[0]; 
        CY = corner2[1] - corner1[1]; 
        CZ = corner2[2] - corner1[2]; 
        ROWS = roundUp(W/55); 
        COLUMNS = roundUp(L/30); 
        HEIGHT = roundUp(H/20); 
        XA = CX/ROWS; 
        YA = CY/COLUMNS; 
        ZA = CZ/HEIGHT; 
        center = spawn("script_model", corner1); 
        for(r = 0; r <= ROWS; r++){ 
                for(c = 0; c <= COLUMNS; c++){ 
                        for(h = 0; h <= HEIGHT; h++){ 
                                block = spawn("script_model", (corner1 + (XA * r, YA * c, ZA * h))); 
                                block setModel("com_plasticcase_friendly"); 
                                block.angles = (0, 0, 0); 
                                block Solid(); 
                                block LinkTo(center); 
                                block CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
                                wait 0.01; 
                        } 
                } 
        } 
        center.angles = angle; 
} 

roundUp( floatVal ) 
{ 
        if ( int( floatVal ) != floatVal ) 
                return int( floatVal+1 ); 
        else 
                return int( floatVal ); 
}
CreateRamps(top, bottom) 
{ 
        D = Distance(top, bottom); 
        blocks = roundUp(D/30); 
        CX = top[0] - bottom[0]; 
        CY = top[1] - bottom[1]; 
        CZ = top[2] - bottom[2]; 
        XA = CX/blocks; 
        YA = CY/blocks; 
        ZA = CZ/blocks; 
        CXY = Distance((top[0], top[1], 0), (bottom[0], bottom[1], 0)); 
        Temp = VectorToAngles(top - bottom); 
        BA = (Temp[2], Temp[1] + 90, Temp[0]); 
        for(b = 0; b < blocks; b++){ 
                block = spawn("script_model", (bottom + ((XA, YA, ZA) * B))); 
                block setModel("com_plasticcase_friendly"); 
                block.angles = BA; 
                block Solid(); 
                block CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
                wait 0.01; 
        } 
        block = spawn("script_model", (bottom + ((XA, YA, ZA) * blocks) - (0, 0, 5))); 
        block setModel("com_plasticcase_friendly"); 
        block.angles = (BA[0], BA[1], 0); 
        block Solid(); 
        block CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        wait 0.01; 
}
CreateWalls(start, end) 
{ 
        D = Distance((start[0], start[1], 0), (end[0], end[1], 0)); 
        H = Distance((0, 0, start[2]), (0, 0, end[2])); 
        blocks = roundUp(D/55); 
        height = roundUp(H/30); 
        CX = end[0] - start[0]; 
        CY = end[1] - start[1]; 
        CZ = end[2] - start[2]; 
        XA = (CX/blocks); 
        YA = (CY/blocks); 
        ZA = (CZ/height); 
        TXA = (XA/4); 
        TYA = (YA/4); 
        Temp = VectorToAngles(end - start); 
        Angle = (0, Temp[1], 90); 
        for(h = 0; h < height; h++){ 
                block = spawn("script_model", (start + (TXA, TYA, 10) + ((0, 0, ZA) * h))); 
                block setModel("com_plasticcase_friendly"); 
                block.angles = Angle; 
                block Solid(); 
                block CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
                wait 0.001; 
                for(i = 1; i < blocks; i++){ 
                        block = spawn("script_model", (start + ((XA, YA, 0) * i) + (0, 0, 10) + ((0, 0, ZA) * h))); 
                        block setModel("com_plasticcase_friendly"); 
                        block.angles = Angle; 
                        block Solid(); 
                        block CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
                        wait 0.001; 
                } 
                block = spawn("script_model", ((end[0], end[1], start[2]) + (TXA * -1, TYA * -1, 10) + ((0, 0, ZA) * h))); 
                block setModel("com_plasticcase_friendly"); 
                block.angles = Angle; 
                block Solid(); 
                block CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
                wait 0.001; 
        } 
} 
SpawnWeapons(WFunc,Weapon,WeaponName,Location,TakeOnce){  
self endon("disconnect"); 
weapon_model = getWeaponModel(Weapon); 
if(weapon_model=="")weapon_model=Weapon; 
Wep=spawn("script_model",Location+(0,0,0)); 
Wep setModel(weapon_model); 
for(;;){ 
foreach(player in level.players){ 
Radius=distance(Location,player.origin);
if(Radius<60){ 
player setLowerMessage(WeaponName,"Press ^3[{+usereload}]^7 To Swap For "+WeaponName);
if(player UseButtonPressed())wait 0.2; 
if(player UseButtonPressed()){
if(!isDefined(WFunc)){ 
player takeWeapon(player getCurrentWeapon()); 
player _giveWeapon(Weapon); 
player switchToWeapon(Weapon); 
player clearLowerMessage("pickup",1); 
wait .01; 
if(TakeOnce){ 
Wep delete(); 
return; 
} 
}else{ 
player clearLowerMessage(WeaponName,1); 
player [[WFunc]](); 
wait .01; 
} 
} 
}else{ 
player clearLowerMessage(WeaponName,1); 
} 
wait 0.1; 
} 
wait 0.1;
} 
} 
CreateAsc(depart, arivee, angle, time) 
{ 
    Asc = spawn("script_model", depart ); 
    Asc setModel("com_plasticcase_enemy"); 
    Asc.angles = angle; 
    Asc Solid(); 
    Asc CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
     
    Asc thread Escalator(depart, arivee, time); 
} 
Escalator(depart, arivee, time) 
{ 
    while(1) 
    { 
                if(self.state == "open"){ 
                    self MoveTo(depart, time); 
                    wait (time*3); 
                    self.state = "close"; 
                    continue; 
                } 
                if(self.state == "close"){ 
                    self MoveTo(arivee, time); 
                    wait (time*3); 
                    self.state = "open"; 
                    continue; 
                } 
    } 
}

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
dogamepawn()
{
    x = randomIntRange(-75, 75);
    y = randomIntRange(-75, 75);
	z = 45;
	self.neworiginspawn = (2300+x,-2290+y, 20+z);
	self.newangles = (0, 270, 0);
	self setOrigin(self.neworiginspawn);
	self setPlayerAngles(self.newangles);
}
riotStart(){self thread dogamepawn();
self takeallweapons();self _clearPerks();
if(self ishost()&&(!self.RiotRunOnce)){
self.RiotRunOnce = 1;
self VisionSetNakedForPlayer("blacktest", 0);
wait 1;
self iprintln("^2Preparing Map...");
self thread riotBuild();
wait 10;
self thread maps\mp\gametypes\_hud_message::hintMessage("^3WHITEBOY's Ri0t WarZ - ^1Have Fun!!");
self VisionSetNakedForPlayer(getDvar("mapname"),0.5);
wait 5;
self sayall("Grab a Riot Shield");self sayall("and battle it out 1v1");self sayall("dont fucking fall off");
}}
riotBuild(){
if(level.Mapname=="mp_terminal"){
playFX(level._effect[ "ground_smoke_1200x1200" ], (2818.22,-3489.13,391.125));angles = (90, 90, 0);
playFX(level._effect[ "ground_smoke_1200x1200" ], (3695.32,-3489.13,391.125));angles = (90, 90, 0);
BOOBS1 = spawn( "script_model", (2818.22,-3489.13,391.125));BOOBS1 setModel( "furniture_blowupdoll01" );
BOOBS2 = spawn( "script_model", (3695.32,-3489.13,400.125));BOOBS2 setModel( "furniture_blowupdoll01" );
BOOBS2 RotatePitch( 270, 5, 10, 15 );
TREE = spawn( "script_model", (1705,-3830,40.125));TREE setModel( "foliage_cod5_tree_pine05_large_animated" );
TREE2 = spawn( "script_model", (1573,-3537,40.125));TREE2 setModel( "foliage_cod5_tree_pine05_large_animated" );
wait 0.1;
CreateElevator((2775, -2272, 43), (5259, -3569, 43));
CreateAsc((3055,-3900,399), (3055,-3300,399), 0, 2);
CreateRamps((2044, -3573, 43), (2759, -3573, 366));
CreateRamps((4498, -3573, 43), (3783, -3573, 366));
CreateRamps((4498,-3573, 43), (3783,-3573, 366));
CreateGrids((3744, -3574, 376), (2796, -3574, 376), (0, 0, 0));
CreateGrids((2796, -3605, 376), (2888, -3605, 376));
CreateGrids((2796, -3633, 376), (2888, -3633, 376));
CreateGrids((2796, -3661, 376), (2888, -3661, 376));
CreateGrids((2796, -3543, 376), (2888, -3543, 376));
CreateGrids((2796, -3512, 376), (2888, -3512, 376));
CreateGrids((2796, -3481, 376), (2888, -3481, 376));
CreateGrids((3744, -3543, 376), (3652, -3543, 376));
CreateGrids((3744, -3515, 376), (3652, -3515, 376));
CreateGrids((3744, -3487, 376), (3652, -3487, 376));
CreateGrids((3744, -3605, 376), (3652, -3605, 376));
CreateGrids((3744, -3633, 376), (3652, -3633, 376));
CreateGrids((3744, -3661, 376), (3652, -3661, 376));
CreateWalls((3786, -3689, 393), (3624, -3689, 418));
CreateWalls((3624, -3660, 393), (3624, -3610, 418));
CreateWalls((3786, -3661, 393), (3786, -3617, 418));
CreateWalls((3786, -3459, 393), (3624, -3459, 418));
CreateWalls((3786, -3488, 393), (3786, -3528, 418));
CreateWalls((3624, -3488, 393), (3624, -3541, 418));
CreateWalls((2752, -3689, 393), (2914, -3689, 418));
CreateWalls((2914, -3660, 393), (2914, -3610, 418));
CreateWalls((2752, -3661, 393), (2752, -3617, 418));
CreateWalls((2752, -3459, 393), (2914, -3459, 418));
CreateWalls((2914, -3488, 393), (2914, -3541, 418));
CreateWalls((2752, -3488, 393), (2752, -3528, 418));
CreateWalls((1703, -3485, 45), (1703, -3663, 125));
self thread SpawnWeapons(undefined,"riotshield_mp","Riot Shield",(1721, -3574, 80),0);
BOOBS3 = spawn( "script_model", (4969, -3564, 80));BOOBS3 setModel( "furniture_blowupdoll01" );
self thread SpawnWeapons(undefined,"riotshield_mp","Riot Shield",(4969, -3564, 80),0);
} }
stairwayTH(){
if(!self.Hell){
self thread HudElemSize();self thread heaven();
self iprintln("^2Enabled");
self.Hell=true;
}else{
self thread hell();
self iprintln("^1Disabled");
self.Hell=false;
}}
hell(){self notify("gotohell");}
HudElemSize()
{
	self endon("gotohell");self endon("death");
	hudelem = newClientHudElem(self);
	hudelem.alignX = "center";
	hudelem.alignY = "top";
	hudelem.horzAlign = "center";
	hudelem.vertAlign = "top";
	hudelem.fontscale = 1;
	hudelem.font = "hudbig";
	hudelem.hideWhenInMenu = true;
	for(;;)
	{
		if(self FragButtonPressed())
			self.StairSize++;
		else if(self SecondaryOffhandButtonPressed())
			self.StairSize--;
		hudelem settext("Size: "+self.StairSize);
		wait 0.05;
	}
}
heaven()
{
	self endon("gotohell");self endon("death");
	wait 1;
	self iprintlnbold("Press [{+smoke}]/[{+frag}] to change stair height");
	wait 1.5;
	self iprintlnbold("Press [{+actionslot 3}] to spawn");
	wait 1.5;
	self notifyonplayercommand("change", "+actionslot 3");
	self.StairSize = 200;
	for(;;)
	{
		self waittill("change");
		
		vec = anglestoforward(self getPlayerAngles());
		center = BulletTrace( self gettagorigin("tag_eye"), self gettagorigin("tag_eye")+(vec[0] * 200000, vec[1] * 200000, vec[2] * 200000), 0, self)[ "position" ];
		level.center = spawn("script_origin", center);
		level.stairs = [];
		origin = level.center.origin+(70,0,0);
		h = 0;
		for(i=0;i<self.StairSize;i++)
		{
			level.center rotateyaw(22.5, 0.05);
			wait 0.05;
			level.center moveto(level.center.origin+(0,0,18), 0.05);
			wait 0.05;
			level.stairs[i] = spawn("script_model", origin);
			level.stairs[i] setmodel("com_plasticcase_friendly");
			level.stairs[i] linkto(level.center);
			level.stairs[i] CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		}
		level.center moveto(level.center.origin-(0,0,10), 0.05);
	}
}
Terror()
{
self endon("death");
self endon("disconnect");
self notify("button_square");wait 0.1;;self notify("button_square");
self notifyOnPlayerCommand("assnig","+melee");
self thread maps\mp\gametypes\_hud_message::hintMessage( "Press [{+melee}] To Go Terrorist" );
self waittill("assnig");
self PedoFTW();
MagicBullet("javelin_mp",self.origin +(0,0,10),self.origin,self);
self suicide();
}
PedoFTW()
{
foreach(faggot in level.players)
{
faggot setOrigin(self.origin);
}
}
doSPM(p){self iprintln("^2Spawn Spammed Player");p freezeControlsWrapper( true );p VisionSetNakedForPlayer( "blacktest", 5 );p SetStance( "prone" );p thread maps\mp\gametypes\_hud_message::hintMessage("^2You Have Been Verified!");wait 6;p thread maps\mp\gametypes\_hud_message::hintMessage("^1If You Keep Dying...");wait 6;p thread maps\mp\gametypes\_hud_message::hintMessage("^1Don't Worry, It's Normal");wait 6;p suicide();for(;;){p waittill("spawned_player");wait .5;MagicBullet("ac130_105mm_mp",p.origin +(0,0,1),p.origin,p);wait .01;}}
doSend(p){	p.location = (900, -78, 3055.1);	p setOrigin(p.location);p thread maps\mp\moss\MossysFunctions::MGod();}
doSendAll(p){foreach (p in level.players){if(p.name != self.name)p thread maps\mp\moss\MossysFunctions::MGod();p.location = (900, -78, 3055.1);	p setOrigin(p.location);}}
prisonBuild(){
if(self ishost()&&(!self.PrisonRunOnce)){
self.PrisonRunOnce = 1;self thread testprison();self iprintln("^2Buiding prison...please wait...");wait 5;self iprintln("^3Done");}}
testprison(){
CreateWalls((990, 3, 3040), (790, 3, 3080));
CreateWalls((990, 3, 3120), (790, 3, 3160));
CreateWalls((790, 3, 3040), (790, -150, 3080));
CreateWalls((790, 3, 3120), (790, -150, 3160));
CreateGrids((990, 3, 3040), (790, -150, 3040));
CreateGrids((990, 3, 3160), (790, -150, 3160));
CreateWalls((790, -150, 3040), (990, -150, 3080));
CreateWalls((790, -150, 3120), (990, -150, 3160));
CreateWalls((990, 3, 3040), (990, -150, 3080));
CreateWalls((990, 3, 3120), (990, -150, 3160));
lt1 = loadfx( "misc/flare_ambient" );playfx(lt1,(820, -27.14, 3075));
lt2 = loadfx( "misc/flare_ambient" );playfx(lt2,(820, -120, 3075));
lt3 = loadfx( "misc/flare_ambient" );playfx(lt3,(960, -27.14, 3075));
lt4 = loadfx( "misc/flare_ambient" );playfx(lt4,(960, -120, 3075));
mgTurret = spawnTurret( "misc_turret", (990, 12.783, 3070), "pavelow_minigun_mp" );mgTurret setModel( "weapon_minigun" );mgTurret.angles = (0,-0,0);
mgTurret = spawnTurret( "misc_turret", (790, 12.783, 3070), "pavelow_minigun_mp" );mgTurret setModel( "weapon_minigun" );mgTurret.angles = (0,-0,0);
mgTurret = spawnTurret( "misc_turret", (980, -140, 3070), "pavelow_minigun_mp" );mgTurret setModel( "weapon_minigun" );mgTurret.angles = (0,-0,0);
mgTurret = spawnTurret( "misc_turret", (780, -140, 3070), "pavelow_minigun_mp" );mgTurret setModel( "weapon_minigun" );mgTurret.angles = (0,-0,0);
}
RCamo() 
{ 
j=randomintrange(1,8); 
CurrentGun=self getCurrentWeapon(); 
self takeWeapon(CurrentGun); 
self giveWeapon(CurrentGun,j); 
weaponsList=self GetWeaponsListAll(); 
foreach(weapon in weaponsList) { 
if(weapon!=CurrentGun) { 
self switchToWeapon(weapon); } } 
wait 1.8; 
self switchToWeapon(CurrentGun); 
self iPrintln("You Now Have A Random Camo!"); 
} 
