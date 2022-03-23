#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	level.doCustomMap = 0;
	level.doorwait = 2;
	level.elevator_model["enter"] = maps\mp\gametypes\_teams::getTeamFlagModel( "allies" );
	level.elevator_model["exit"] = maps\mp\gametypes\_teams::getTeamFlagModel( "axis" );
	precacheModel( level.elevator_model["enter"] );
	precacheModel( level.elevator_model["exit"] );
	wait 1;
	if(getDvar("mapname") == "mp_afghan"){ /** Afghan **/
		level thread Afghan();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_boneyard"){ /** Scrapyard **/
		level thread Scrapyard();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_brecourt"){ /** Wasteland **/
		level thread Wasteland();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_checkpoint"){ /** Karachi **/
		level thread Karachi();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_derail"){ /** Derail **/
		level thread Derail();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_estate"){ /** Estate **/
		level thread Estate();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_favela"){ /** Favela **/
		level thread Favela();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_highrise"){ /** HighRise **/
		level thread HighRise();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_nightshift"){ /** Skidrow **/
		level thread Skidrow();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_invasion"){ /** Invasion **/
		level thread Invasion();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_quarry"){ /** Quarry **/
		level thread Quarry();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_rundown"){ /** Rundown **/
		level thread Rundown();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_rust"){ /** Rust **/
		level thread Rust();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_subbase"){ /** SubBase **/
		level thread SubBase();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_terminal"){ /** Terminal **/
		level thread Terminal();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_underpass"){ /** Underpass **/
		level thread Underpass();
		level.doCustomMap = 1;
	}
	if(level.doCustomMap == 1){
		level.gameState = "starting";
		level thread CreateMapWait();
	} else {
		level.gameState = "starting";
		wait 15;
		level notify("CREATED");
	}
}

CreateMapWait()
{
	for(i = 30; i > 0; i--)
	{
		level.TimerText destroy();
		level.TimerText = level createServerFontString( "objective", 1.5 );
		level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
		level.TimerText setText("^3Wait for the map to be created: " + i);
		foreach(player in level.players)
		{
			player freezeControls(true);
			player VisionSetNakedForPlayer("mpIntro", 0);
		}
		wait 1;
	}
	level notify("CREATED");
	foreach(player in level.players)
	{
		player freezeControls(false);
		player VisionSetNakedForPlayer(getDvar("mapname"), 0);
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

CreateBlocks(pos, angle)
{
	block = spawn("script_model", pos );
	block setModel("com_plasticcase_friendly");
	block.angles = angle;
	block Solid();
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	wait 0.01;
}

CreateDoors(open, close, angle, size, height, hp, range)
{
	offset = (((size / 2) - 0.5) * -1);
	center = spawn("script_model", open );
	for(j = 0; j < size; j++){
		door = spawn("script_model", open + ((0, 30, 0) * offset));
		door setModel("com_plasticcase_enemy");
		door Solid();
		door CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		door EnableLinkTo();
		door LinkTo(center);
		for(h = 1; h < height; h++){
			door = spawn("script_model", open + ((0, 30, 0) * offset) - ((70, 0, 0) * h));
			door setModel("com_plasticcase_enemy");
			door Solid();
			door CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
			door EnableLinkTo();
			door LinkTo(center);
		}
		offset += 1;
	}
	center.angles = angle;
	center.state = "open";
	center.hp = hp;
	center.range = range;
	center thread DoorThink(open, close);
	center thread DoorUse();
	center thread ResetDoors(open, hp);
	wait 0.01;
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
		block = spawn("script_model", (bottom + ((XA, YA, ZA) * b)));
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

CreateCluster(amount, pos, radius)
{
	for(i = 0; i < amount; i++)
	{
		half = radius / 2;
		power = ((randomInt(radius) - half), (randomInt(radius) - half), 500);
		block = spawn("script_model", pos + (0, 0, 1000) );
		block setModel("com_plasticcase_friendly");
		block.angles = (90, 0, 0);
		block PhysicsLaunchServer((0, 0, 0), power);
		block Solid();
		block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		block thread ResetCluster(pos, radius);
		wait 0.05;
	}
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

DoorThink(open, close)
{
	while(1)
	{
		if(self.hp > 0){
			self waittill ( "triggeruse" , player );
			if(player.team == "allies"){
				if(self.state == "open"){
					self MoveTo(close, level.doorwait);
					wait level.doorwait;
					self.state = "close";
					continue;
				}
				if(self.state == "close"){
					self MoveTo(open, level.doorwait);
					wait level.doorwait;
					self.state = "open";
					continue;
				}
			}
			if(player.team == "axis"){
				if(self.state == "close"){
					self.hp--;
					player iPrintlnBold("HIT");
					wait 1;
					continue;
				}
			}
		} else {
			if(self.state == "close"){
				self MoveTo(open, level.doorwait);
			}
			self.state = "broken";
			wait .5;
		}
	}
}

DoorUse()
{
	self endon("disconnect");
	while(1)
	{
		foreach(player in level.players)
		{
			if(Distance(self.origin, player.origin) <= self.range){
				if(player.team == "allies"){
					if(self.state == "open"){
						player.hint = "Press ^3[{+usereload}] ^7to ^2Close ^7the door";
					}
					if(self.state == "close"){
						player.hint = "Press ^3[{+usereload}] ^7to ^2Open ^7the door";
					}
					if(self.state == "broken"){
						player.hint = "^1Door is Broken";
					}
				}
				if(player.team == "axis"){
					if(self.state == "close"){
						player.hint = "Press ^3[{+usereload}] ^7to ^2Attack ^7the door";
					}
					if(self.state == "broken"){
						player.hint = "^1Door is Broken";
					}
				}
				if(player.buttonPressed[ "+usereload" ] == 1){
					player.buttonPressed[ "+usereload" ] = 0;
					self notify( "triggeruse" , player);
				}
			}
		}
		wait .045;
	}
}

ResetDoors(open, hp)
{
	while(1)
	{
		level waittill("RESETDOORS");
		self.hp = hp;
		self MoveTo(open, level.doorwait);
		self.state = "open";
	}
}

ResetCluster(pos, radius)
{
	wait 5;
	self RotateTo(((randomInt(36)*10), (randomInt(36)*10), (randomInt(36)*10)), 1);
	level waittill("RESETCLUSTER");
	self thread CreateCluster(1, pos, radius);
	self delete();
}

roundUp( floatVal )
{
	if ( int( floatVal ) != floatVal )
		return int( floatVal+1 );
	else
		return int( floatVal );
}

Afghan()
{
	CreateRamps((2280, 1254, 142), (2548, 1168, 33));
	CreateDoors((1590, -238, 160), (1590, -168, 160), (90, 0, 0), 2, 2, 5, 50);
	CreateDoors((1938, -125, 160), (1938, -15, 160), (90, 0, 0), 4, 2, 15, 75);
	CreateDoors((2297, 10, 160), (2297, -100, 160), (90, 0, 0), 4, 2, 10, 75);
	CreateDoors((525, 1845, 162), (585, 1845, 162), (90, 90, 0), 2, 2, 5, 50);
	CreateDoors((-137, 1380, 226), (-137, 1505, 226), (90, 0, 0), 4, 2, 15, 75);
	CreateDoors((820, 1795, 165), (820, 1495, 165), (90, 0, 0), 12, 2, 40, 100);
	CreateDoors((2806, 893, 210), (2806, 806, 210), (90, 0, 0), 3, 2, 10, 50);
}

Derail()
{
	CreateElevator((-110, 2398, 124), (-125, 2263, 333), (0, 270, 0));
	CreateBlocks((-240, 1640, 422), (0, 90, 0));
	CreateBlocks((-270, 1640, 422), (0, 90, 0));
	CreateBlocks((-270, 1585, 422), (0, 90, 0));
	CreateBlocks((-270, 1530, 422), (0, 90, 0));
	CreateBlocks((-270, 1475, 422), (0, 90, 0));
	CreateBlocks((-270, 1420, 422), (0, 90, 0));
	CreateBlocks((-270, 1365, 422), (0, 90, 0));
	CreateBlocks((-270, 1310, 422), (0, 90, 0));
	CreateBlocks((-270, 1255, 422), (0, 90, 0));
	CreateBlocks((-970, 3018, 138), (0, 90, 0));
	CreateBlocks((-985, 3018, 148), (0, 90, 0));
	CreateBlocks((-1000, 3018, 158), (0, 90, 0));
	CreateBlocks((-1015, 3018, 168), (0, 90, 0));
	CreateBlocks((-1030, 3018, 178), (0, 90, 0));
	CreateBlocks((-1045, 3018, 188), (0, 90, 0));
	CreateBlocks((-1060, 3018, 198), (0, 90, 0));
	CreateBlocks((-1075, 3018, 208), (0, 90, 0));
	CreateBlocks((-1090, 3018, 218), (0, 90, 0));
	CreateBlocks((-1105, 3018, 228), (0, 90, 0));
	CreateBlocks((-1120, 3018, 238), (0, 90, 0));
	CreateBlocks((-1135, 3018, 248), (0, 90, 0));
	CreateRamps((-124, 2002, 437), (-124, 2189, 332));
	CreateDoors((400, 1486, 128), (400, 1316, 128), (90, 0, 0), 6, 2, 30, 100);
	CreateDoors((-61, 755, 128), (-161, 755, 128), (90, 90, 0), 3, 2, 20, 75);
}

Estate()
{
	CreateBlocks((-2378, 782, -130), (90, 0, 0));
	CreateBlocks((-2388, 823, -130), (90, 0, 0));
	CreateBlocks((-2398, 863, -130), (90, 0, 0));
	CreateBlocks((-1098, 2623, 37), (90, 0, 0));
	CreateBlocks((-3227, 3483, -101), (90, 0, 0));
	CreateBlocks((-371, 919, 245), (0, 100, 90));
	CreateBlocks((-383, 991, 245), (0, 100, 90));
	CreateBlocks((-371, 919, 275), (0, 100, 90));
	CreateBlocks((-383, 991, 275), (0, 100, 90));
	CreateBlocks((-371, 919, 305), (0, 100, 90));
	CreateBlocks((-383, 991, 305), (0, 100, 90));
	CreateBlocks((-371, 919, 335), (0, 100, 90));
	CreateBlocks((-383, 991, 335), (0, 100, 90));
	CreateBlocks((-349, 1115, 245), (0, 50, 90));
	CreateBlocks((-302, 1166, 245), (0, 50, 90));
	CreateBlocks((-349, 1115, 275), (0, 50, 90));
	CreateBlocks((-302, 1166, 275), (0, 50, 90));
	CreateBlocks((-349, 1115, 305), (0, 50, 90));
	CreateBlocks((-302, 1166, 305), (0, 50, 90));
	CreateBlocks((-349, 1115, 335), (0, 50, 90));
	CreateBlocks((-302, 1166, 335), (0, 50, 90));
	CreateBlocks((-371, 919, 395), (0, 100, 90));
	CreateBlocks((-383, 991, 395), (0, 100, 90));
	CreateBlocks((-371, 919, 425), (0, 100, 90));
	CreateBlocks((-383, 991, 425), (0, 100, 90));
	CreateBlocks((-371, 919, 455), (0, 100, 90));
	CreateBlocks((-383, 991, 455), (0, 100, 90));
	CreateBlocks((-371, 919, 485), (0, 100, 90));
	CreateBlocks((-383, 991, 485), (0, 100, 90));
	CreateBlocks((-349, 1115, 395), (0, 50, 90));
	CreateBlocks((-302, 1166, 395), (0, 50, 90));
	CreateBlocks((-349, 1115, 425), (0, 50, 90));
	CreateBlocks((-302, 1166, 425), (0, 50, 90));
	CreateBlocks((-349, 1115, 455), (0, 50, 90));
	CreateBlocks((-302, 1166, 455), (0, 50, 90));
	CreateBlocks((-349, 1115, 485), (0, 50, 90));
	CreateBlocks((-302, 1166, 485), (0, 50, 90));
	CreateBlocks((-55, 1231, 245), (0, -20, 90));
	CreateBlocks((8, 1217, 245), (0, -20, 90));
	CreateBlocks((102, 1188, 245), (0, -20, 90));
	CreateBlocks((162, 1168, 245), (0, -20, 90));
	CreateBlocks((-55, 1231, 275), (0, -20, 90));
	CreateBlocks((8, 1217, 275), (0, -20, 90));
	CreateBlocks((102, 1188, 275), (0, -20, 90));
	CreateBlocks((162, 1168, 275), (0, -20, 90));
	CreateBlocks((-3200, 998, -143), (90, 0, 0));
	CreateBlocks((-3200, 1028, -143), (90, 0, 0));
	CreateBlocks((-3200, 1058, -143), (90, 0, 0));
	CreateBlocks((-3200, 1088, -143), (90, 0, 0));
	CreateBlocks((-3200, 1118, -143), (90, 0, 0));
	CreateBlocks((-3181, 3124, -218), (90, 0, 0));
	CreateBlocks((-3211, 3124, -218), (90, 0, 0));
	CreateBlocks((-3241, 3124, -218), (90, 0, 0));
	CreateBlocks((-3181, 3124, -163), (90, 0, 0));
	CreateBlocks((-3211, 3124, -163), (90, 0, 0));
	CreateBlocks((-3241, 3124, -163), (90, 0, 0));
	CreateBlocks((-2622, 3676, -106), (90, 0, 0));
	CreateBlocks((-3741, 3245, -200), (90, 0, 0));
	CreateBlocks((-3821, 2170, -250), (90, 0, 0));
	CreateBlocks((-3791, 2170, -250), (90, 0, 0));
	CreateBlocks((-3761, 2170, -250), (90, 0, 0));
	CreateBlocks((-3821, 2170, -195), (90, 0, 0));
	CreateBlocks((-3791, 2170, -195), (90, 0, 0));
	CreateBlocks((-3761, 2170, -195), (90, 0, 0));
	CreateBlocks((-471, -126, 193), (0, 0, 90));
	CreateBlocks((-547, -104, 193), (0, 0, 90));
	CreateBlocks((-625, -84, 193), (0, 0, 90));
	CreateBlocks((-702, -61, 193), (0, 0, 90));
	CreateBlocks((-778, -38, 193), (0, 0, 90));
	CreateBlocks((-830, -13, 193), (0, 0, 90));
	CreateBlocks((1333, -92, 210), (0, 0, 90));
	CreateRamps((1025, 3563, 291), (692, 3563, 146));
	CreateDoors((489, 1321, 212), (409, 1341, 212), (90, 70, 0), 4, 2, 20, 75);
	CreateDoors((421, 861, 212), (461, 1011, 212), (90, -20, 0), 4, 2, 20, 75);
	CreateDoors((64, 680, 212), (184, 640, 212), (90, 75, 0), 6, 2, 30, 100);
	CreateDoors((706, 575, 185), (791, 545, 185), (0, -15, 0), 6, 1, 25, 75);
	CreateDoors((24, 477, 341), (48, 552, 341), (90, -15, 0), 3, 2, 5, 50);
}

Favela()
{
	CreateDoors((-64, 277, 198), (-64, 337, 198), (90, -6, 0), 2, 2, 5, 50);
	CreateDoors((-438, 987, 310), (-438, 1047, 310), (90, 4, 0), 2, 2, 5, 50);
	CreateDoors((-625, -238, 174), (-625, -298, 174), (90, -9, 0), 2, 2, 5, 50);
	CreateDoors((893, 1056, 368), (833, 1056, 368), (90, 90, 0), 2, 2, 5, 50);
	CreateDoors((80, 450, 198), (145, 450, 198), (90, 90, 0), 2, 2, 5, 50);
}

HighRise()
{
	CreateBlocks((-2723, 5162, 3030), (90, 0, 0));
	CreateBlocks((-2753, 5162, 3030), (90, 0, 0));
	CreateBlocks((-2723, 5132, 3030), (90, 0, 0));
	CreateDoors((-1550, 5875, 2967), (-1550, 5649, 2967), (0, 0, 0), 7, 1, 20, 100);
	CreateDoors((-1185, 5900, 2967), (-1185, 6117, 2967), (0, 0, 0), 7, 1, 20, 100);
}

Invasion()
{
	CreateElevator((-2150, -2366, 268), (-2276, -1353, 573), (0, -90, 0));
	CreateElevator((-1413, -1333, 270), (-1558, -1485, 1064), (0, 0, 0));
	CreateElevator((-607, -984, 293), (-842, -1053, 878), (0, 0, 0));
	CreateGrids((-1400, -1850, 390), (-1359, -1455, 390), (0, 0, 0));
	CreateBlocks((-1468, -1470, 1044), (0, -80, 0));
	CreateBlocks((-1498, -1475, 1044), (0, -80, 0));
	CreateBlocks((-1528, -1480, 1044), (0, -80, 0));
	CreateBlocks((-1558, -1485, 1044), (0, -80, 0));
	CreateBlocks((-1588, -1490, 1044), (0, -80, 0));
	CreateBlocks((-1618, -1495, 1044), (0, -80, 0));
	CreateBlocks((-1648, -1500, 1044), (0, -80, 0));
}

Karachi()
{
	CreateElevator((25, 519, 200), (25, 457, 336), (0, 180, 0));
	CreateElevator((-525, 520, 336), (-522, 783, 336), (0, 0, 0));
	CreateElevator((25, 854, 336), (25, 854, 472), (0, 180, 0));
	CreateElevator((-522, 783, 472), (-525, 520, 472), (0, 0, 0));
	CreateElevator((25, 457, 472), (25, 457, 608), (0, 180, 0));
	CreateElevator((-525, 520, 608), (-522, 783, 608), (0, 0, 0));
	CreateElevator((561, 116, 176), (568, -67, 280), (0, 0, 0));
	CreateBlocks((800, 206, 254), (0, 0, 0));
	CreateBlocks((800, 256, 254), (0, 0, 0));
	CreateBlocks((800, 375, 254), (0, 0, 0));
	CreateBlocks((479, -831, 369), (90, 90, 0));
	CreateBlocks((768, -253, 582), (90, -45, 0));
	CreateBlocks((814, -253, 582), (90, -45, 0));
	CreateBlocks((860, -253, 582), (90, -45, 0));
	CreateBlocks((916, -253, 582), (90, -45, 0));
	CreateBlocks((962, -253, 582), (90, -45, 0));
	CreateBlocks((415, -777, 582), (0, 0, 0));
	CreateBlocks((360, -777, 582), (0, 0, 0));
	CreateBlocks((305, -777, 582), (0, 0, 0));
	CreateBlocks((516, -74, 564), (90, 90, 0));
	CreateBlocks((516, -74, 619), (90, 90, 0));
	CreateRamps((559, -255, 554), (559, -99, 415));
}

Quarry()
{
	CreateBlocks((-5817, -319, -88), (0, 0, 0));
	CreateBlocks((-5817, -289, -108), (0, 0, 0));
	CreateRamps((-3742, -1849, 304), (-3605, -1849, 224));
	CreateRamps((-3428, -1650, 224), (-3188, -1650, 160));
	CreateRamps((-3412, -1800, 416), (-3735, -1800, 304));
	CreateGrids((-3520, -1880, 320), (-3215, -2100, 320), (0, 0, 0));
	CreateGrids((-3100, -1725, 400), (-2740, -1840, 400), (3, 0, 0));
}

Rundown()
{
	CreateDoors((360, -1462, 202), (300, -1342, 202), (90, 25, 0), 3, 2, 10, 75);
	CreateDoors((460, -1420, 206), (400, -1300, 206), (90, 25, 0), 3, 2, 10, 75);
	CreateDoors((30, -1630, 186), (-30, -1510, 186), (90, 25, 0), 4, 2, 15, 75);
	CreateDoors((-280, -1482, 186), (-220, -1602, 186), (90, 25, 0), 4, 2, 15, 75);
	CreateBlocks((385, -1660, 40), (0, 120, 90));
	CreateRamps((-597, -280, 212), (-332, -522, 180));
	CreateRamps((726, -389, 142), (560, -373, 13));
	CreateRamps((2250, -1155, 306), (1905, -876, 200));
	CreateRamps((850, -3125, 312), (535, -3125, 189));
	CreateRamps((1775, 450, 144), (1775, 735, -5));
}

Rust()
{
	CreateBlocks((773, 1080, 258), (0, 90, 0));
	CreateRamps((745, 1570, 383), (745, 1690, 273));
	CreateDoors((565, 1540, 295), (653, 1540, 295), (90, 90, 0), 3, 2, 15, 60);
	CreateGrids((773, 1135, 258), (533, 1795, 258), (0, 0, 0));
	CreateGrids((695, 1795, 378), (533, 1540, 378), (0, 0, 0));
	CreateGrids((773, 1540, 498), (533, 1795, 498), (0, 0, 0));
	CreateWalls((533, 1795, 278), (773, 1795, 498));
	CreateWalls((790, 1795, 278), (790, 1540, 498));
	CreateWalls((515, 1540, 278), (515, 1795, 498));
	CreateWalls((773, 1540, 278), (715, 1540, 378));
	CreateWalls((590, 1540, 278), (533, 1540, 378));
	CreateWalls((773, 1540, 398), (533, 1540, 428));
	CreateWalls((773, 1540, 458), (740, 1540, 498));
	CreateWalls((566, 1540, 458), (533, 1540, 498));
}

Scrapyard()
{
	CreateBlocks((420, 1636, 174), (0, 0, 0));
	CreateBlocks((475, 1636, 174), (0, 0, 0));
	CreateBlocks((530, 1636, 174), (0, 0, 0));
	CreateBlocks((585, 1636, 174), (0, 0, 0));
	CreateBlocks((640, 1636, 174), (0, 0, 0));
	CreateBlocks((695, 1636, 174), (0, 0, 0));
	CreateBlocks((750, 1636, 174), (0, 0, 0));
	CreateBlocks((805, 1636, 174), (0, 0, 0));
	CreateBlocks((860, 1636, 174), (0, 0, 0));
	CreateBlocks((420, 1606, 174), (0, 0, 0));
	CreateBlocks((475, 1606, 174), (0, 0, 0));
	CreateBlocks((530, 1606, 174), (0, 0, 0));
	CreateBlocks((585, 1606, 174), (0, 0, 0));
	CreateBlocks((640, 1606, 174), (0, 0, 0));
	CreateBlocks((695, 1606, 174), (0, 0, 0));
	CreateBlocks((750, 1606, 174), (0, 0, 0));
	CreateBlocks((805, 1606, 174), (0, 0, 0));
	CreateBlocks((860, 1606, 174), (0, 0, 0));
	CreateBlocks((420, 1576, 174), (0, 0, 0));
	CreateBlocks((475, 1576, 174), (0, 0, 0));
	CreateBlocks((530, 1576, 174), (0, 0, 0));
	CreateBlocks((585, 1576, 174), (0, 0, 0));
	CreateBlocks((640, 1576, 174), (0, 0, 0));
	CreateBlocks((695, 1576, 174), (0, 0, 0));
	CreateBlocks((750, 1576, 174), (0, 0, 0));
	CreateBlocks((805, 1576, 174), (0, 0, 0));
	CreateBlocks((860, 1576, 174), (0, 0, 0));
	CreateBlocks((-1541, -80, 1), (0, 90, -33.3));
	CreateBlocks((-1517.7, -80, 16.3), (0, 90, -33.3));
	CreateBlocks((-1494.4, -80, 31.6), (0, 90, -33.3));
	CreateBlocks((-1471.1, -80, 46.9), (0, 90, -33.3));
	CreateBlocks((-1447.8, -80, 62.2), (0, 90, -33.3));
	CreateBlocks((-1424.5, -80, 77.5), (0, 90, -33.3));
	CreateBlocks((-1401.2, -80, 92.8), (0, 90, -33.3));
	CreateBlocks((-1377.9, -80, 108.1), (0, 90, -33.3));
	CreateBlocks((-1354.6, -80, 123.4), (0, 90, -33.3));
	CreateElevator((10, 1659, -72), (860, 1606, 194), (0, 180, 0));
	CreateDoors((1992, 266, -130), (1992, 336, -130), (90, 0, 0), 2, 2, 5, 50);
	CreateDoors((1992, 710, -130), (1992, 640, -130), (90, 0, 0), 2, 2, 5, 50);
}

Skidrow()
{
	CreateElevator((-725, -410, 136), (-910, -620, 570), (0, 0, 0));
	CreateRamps((-705, -830, 688), (-495, -830, 608));
	CreateRamps((-580, -445, 608), (-580, -375, 568));
	CreateRamps((1690, 325, 213), (1890, 325, 108));
	CreateGrids((-1540, -1687, 600), (-275, -1687, 660), (0, 0, 0));
	CreateGrids((-1060, -1535, 584), (-470, -1650, 584), (0, 0, 0));
	CreateGrids((-700, -120, 580), (-700, -120, 640), (0, 90, 0));
	CreateGrids((-705, -490, 580), (-705, -770, 580), (-45, 0, 0));
}

SubBase()
{
	CreateBlocks((-1506, 800, 123), (0, 0, 45));
	CreateDoors((-503, -3642, 22), (-313, -3642, 22), (90, 90, 0), 7, 2, 25, 75);
	CreateDoors((-423, -3086, 22), (-293, -3086, 22), (90, 90, 0), 6, 2, 20, 75);
	CreateDoors((-183, -3299, 22), (-393, -3299, 22), (90, 90, 0), 7, 2, 25, 75);
	CreateDoors((1100, -1138, 294), (1100, -1078, 294), (90, 0, 0), 2, 2, 5, 50);
	CreateDoors((331, -1400, 294), (331, -1075, 294), (90, 0, 0), 11, 2, 40, 100);
	CreateDoors((-839, -1249, 278), (-839, -1319, 278), (90, 0, 0), 2, 2, 5, 50);
	CreateDoors((-1428, -1182, 278), (-1498, -1182, 278), (90, 90, 0), 2, 2, 5, 50);
	CreateDoors((-435, -50, 111), (-380, -50, 111), (90, 90, 0), 2, 2, 5, 50);
	CreateDoors((-643, -50, 111), (-708, -50, 111), (90, 90, 0), 2, 2, 5, 50);
	CreateDoors((1178, -438, 102), (1248, -438, 102), (90, 90, 0), 2, 2, 5, 50);
	CreateDoors((1112, -90, 246), (1112, -160, 246), (90, 0, 0), 2, 2, 5, 50);
}

Terminal()
{
	CreateElevator((2859, 4529, 192), (3045, 4480, 250), (0, 0, 0));
	CreateElevator((2975, 4080, 192), (2882, 4289, 55), (0, 180, 0));
	CreateElevator((520, 7375, 192), (-898, 5815, 460), (0, -90, 0));
	CreateElevator((-670, 5860, 460), (1585, 7175, 200), (0, 180, 0));
	CreateElevator((-895, 4300, 392), (-895, 4300, 570), (0, 90, 0));
	CreateWalls((-640, 4910, 390), (-640, 4685, 660));
	CreateWalls((-1155, 4685, 390), (-1155, 4910, 660));
	CreateWalls((-570, 5440, 460), (-640, 4930, 660));
	CreateWalls((-1155, 4930, 460), (-1155, 5945, 660));
	CreateWalls((-1155, 5945, 460), (-910, 5945, 660));
	CreateWalls((-1105, 4665, 392), (-965, 4665, 512));
	CreateWalls((-825, 4665, 392), (-685, 4665, 512));
	CreateWalls((3375, 2715, 195), (3765, 3210, 245));
	CreateWalls((4425, 3580, 195), (4425, 3230, 315));
	CreateWalls((4425, 3580, 380), (4425, 3230, 440));
	CreateWalls((4045, 3615, 382), (3850, 3615, 412));
	CreateWalls((2960, 2800, 379), (3250, 2800, 409));
	CreateDoors((-705, 4665, 412), (-895, 4665, 412), (90, -90, 0), 4, 2, 20, 75);
	CreateDoors((3860, 3305, 212), (3860, 3485, 212), (90, 0, 0), 6, 2, 30, 100);
	CreateRamps((3620, 2415, 369), (4015, 2705, 192));
	CreateGrids((4380, 2330, 360), (4380, 2980, 360), (0, 0, 0));
	CreateBlocks((1635, 2470, 121), (0, 0, 0));
	CreateBlocks((2675, 3470, 207), (90, 0, 0));
}

Underpass()
{
	CreateElevator((-415, 3185, 392), (-1630, 3565, 1035), (0, 180, 0));
	CreateBlocks((1110, 1105, 632), (90, 0, 0));
	CreateBlocks((-2740, 3145, 1100), (90, 0, 0));
	CreateBlocks((2444, 1737, 465), (90, 0, 0));
	CreateWalls((-1100, 3850, 1030), (-1100, 3085, 1160));
	CreateWalls((-2730, 3453, 1030), (-2730, 3155, 1150));
	CreateWalls((-2730, 3155, 1030), (-3330, 3155, 1180));
	CreateWalls((-3330, 3155, 1030), (-3330, 3890, 1180));
	CreateWalls((-3330, 3890, 1030), (-2730, 3890, 1180));
	CreateWalls((-2730, 3890, 1030), (-2730, 3592, 1150));
	CreateWalls((-2730, 3890, 1150), (-2730, 3155, 1180));
	CreateDoors((-2730, 3400, 1052), (-2730, 3522.5, 1052), (90, 180, 0), 4, 2, 20, 75);
	CreateRamps((-3285, 3190, 1125), (-3285, 3353, 1030));
	CreateRamps((-3285, 3855, 1125), (-3285, 3692, 1030));
	CreateGrids((-2770, 3190, 1120), (-3230, 3190, 1120), (0, 0, 0));
	CreateGrids((-2770, 3855, 1120), (-3230, 3855, 1120), (0, 0, 0));
	CreateGrids((-2770, 3220, 1120), (-2770, 3825, 1120), (0, 0, 0));
	CreateCluster(20, (-3030, 3522.5, 1030), 250);
}

Wasteland()
{
	CreateDoors((1344, -778, -33), (1344, -898, -33), (90, 0, 0), 5, 2, 15, 75);
	CreateDoors((684, -695, -16), (684, -825, -16), (90, 0, 0), 5, 2, 15, 75);
	CreateDoors((890, -120, -12), (760, -120, -12), (90, 90, 0), 5, 2, 15, 125);
	CreateDoors((958, -1072, -36), (958, -972, -36), (90, 0, 0), 3, 2, 10, 50);
	CreateDoors((1057, -648, -36), (997, -748, -36), (90, -30, 0), 3, 2, 10, 50);
}

