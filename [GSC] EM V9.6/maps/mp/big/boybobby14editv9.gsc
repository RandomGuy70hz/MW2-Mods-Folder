#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

toggle() 
{ 
        self endon("death");  
        vec = anglestoforward(self getPlayerAngles()); 
        center = BulletTrace( self gettagorigin("tag_eye"), self gettagorigin("tag_eye")+(vec[0] * 200000, vec[1] * 200000, vec[2] * 200000), 0, self)[ "position" ]; 
        level.center = spawn("script_origin", center); 
        level.lift = []; 
        h=0;k=0; 
        origin = level.center.origin; 
        for(i=0;i<404;i++) 
        { 
                if(i<=100) 
                        level.lift[k] = spawn("script_model", origin+(-42,42,h)); 
                else if(i<=201 && i>100) 
                        level.lift[k] = spawn("script_model", origin+(42,42,h-2777.5*2)); 
                else if(i<=302 && i>201) 
                        level.lift[k] = spawn("script_model", origin+(-42,-42,h-5555*2)); 
                else if(i<=404 && i>301) 
                        level.lift[k] = spawn("script_model", origin+(42,-42,h-8332.5*2)); 
                level.lift[i].angles = (90,90,0); 
                h+=55; 
                k++; 
        } 
        level.center moveto(level.center.origin+(0,0,15), 0.05); 
        wait 0.05; 
        level.elevator = []; 
        level.elevator[0] = spawn("script_model", origin+(0,42,-15)); 
        level.elevator[1] = spawn("script_model", origin+(0,-42,-15)); 
        level.elevator[2] = spawn("script_model", origin+(42,0,-15)); 
        level.elevator[2].angles = (0,90,0); 
        level.elevator[3] = spawn("script_model", origin+(-42,0,-15)); 
        level.elevator[3].angles = (0,90,0); 
        level.elevator[4] = spawn("script_model", origin+(0,14,-15)); 
        level.elevator[5] = spawn("script_model", origin+(0,-14,-15)); 
        base = level.center.origin+(-110,182,5513.75); 
        level.elevatorcontrol = []; 
        level.elevatorcontrol[0] = spawn("script_model", origin+(0,-42,13.75)); 
        level.elevatorcontrol[0] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[0] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[0] linkto(level.center); 
        level.elevatorcontrol[1] = spawn("script_model", origin+(0,-42,28.75)); 
        level.elevatorcontrol[1] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[1].angles = (0,90,0); 
        level.elevatorcontrol[1] linkto(level.center); 
        level.elevatorcontrol[2] = spawn("script_model", base+(0,0,28)); 
        level.elevatorcontrol[2] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[2] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[3] = spawn("script_model", base+(0,0,42)); 
        level.elevatorcontrol[3] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[3].angles = (0,90,0); 
        level.elevatorcontrol[4] = spawn("script_model", level.center.origin+(44,60,40)); 
        level.elevatorcontrol[4] setModel( "ma_flatscreen_tv_wallmount_01" ); 
        level.elevatorcontrol[4].angles = (0,180,0); 
        level.elevatorcontrol[5] = spawn("script_model", base+(5,224,28)); 
        level.elevatorcontrol[5] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[5] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[5].angles = (0,45,0); 
        level.elevatorcontrol[6] = spawn("script_model", base+(215,224,28)); 
        level.elevatorcontrol[6] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[6] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[6].angles = (0,-45,0); 
        level.elevatorcontrol[7] = spawn("script_model", base+(110,252,28)); 
        level.elevatorcontrol[7] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[7] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[8] = spawn("script_model", base+(5,224,42)); 
        level.elevatorcontrol[8] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[8].angles = (0,-45,0); 
        level.elevatorcontrol[8].type = "right"; 
        level.elevatorcontrol[9] = spawn("script_model", base+(215,224,42)); 
        level.elevatorcontrol[9] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[9].angles = (0,-135,0); 
        level.elevatorcontrol[9].type = "left"; 
        level.elevatorcontrol[10] = spawn("script_model", base+(110,252,42)); 
        level.elevatorcontrol[10] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[10].angles = (0,-90,0); 
        level.elevatorcontrol[10].type = "forward"; 
        level.elevatorcontrol[11] = spawn("script_model", base+(220,0,42)); 
        level.elevatorcontrol[11] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[11].angles = (0,90,0); 
        level.elevatorcontrol[11].type = "dock"; 
        level.elevatorcontrol[12] = spawn("script_model", base+(220,0,28)); 
        level.elevatorcontrol[12] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[12] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[13] = spawn("script_model", base+(232,98,28)); 
        level.elevatorcontrol[13] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[13] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[13].angles = (0,90,0); 
        level.elevatorcontrol[14] = spawn("script_model", base+(232,98,42)); 
        level.elevatorcontrol[14] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[14].angles = (0,180,0); 
        level.elevatorcontrol[14].type = "up"; 
        level.elevatorcontrol[15] = spawn("script_model", base+(-12,98,28)); 
        level.elevatorcontrol[15] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[15] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[15].angles = (0,90,0); 
        level.elevatorcontrol[16] = spawn("script_model", base+(-12,98,42)); 
        level.elevatorcontrol[16] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[16].type = "down"; 
        level.elevatorcontrol[17] = spawn("script_model", origin+(-85,84,13.75)); 
        level.elevatorcontrol[17] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[17] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[17].angles = (0,-45,0); 
        level.elevatorcontrol[18] = spawn("script_model", origin+(-85,84,28.75)); 
        level.elevatorcontrol[18] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[18].angles = (0,45,0); 
        level.elevatorcontrol[18].type = "forcedock"; 
        level.elevatorcontrol[19] = spawn("script_model", base+(165,0,28)); 
        level.elevatorcontrol[19] setModel( "com_plasticcase_friendly" ); 
        level.elevatorcontrol[19] CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        level.elevatorcontrol[20] = spawn("script_model", base+(165,0,42)); 
        level.elevatorcontrol[20] setModel( "com_laptop_2_open" ); 
        level.elevatorcontrol[20].angles = (0,90,0); 
        level.elevatorcontrol[20].type = "destroy"; 
        level.center2 = spawn("script_origin", level.center.origin); 
        level.center2 linkto(level.center); 
        level.elevatorPlatform = []; 
        level.elevatorPlatform[0] = spawn("script_model", origin+(0,-42,-15)); 
        level.elevatorPlatform[1] = spawn("script_model", origin+(0,-14,-15)); 
        level.elevatorPlatform[2] = spawn("script_model", origin+(0,14,-15)); 
        level.elevatorPlatform[3] = spawn("script_model", origin+(0,42,-15)); 
        level.elevatorBase = []; 
        j = 0; 
        w = 0; 
        for(x=0;x<10;x++) 
        { 
                for(i=0;i<5;i++) 
                { 
                        level.elevatorBase[j] = spawn("script_model", base+(i*55,w,0)); 
                        j++; 
                } 
                w+= 28; 
        } 
        level.BaseCenter = spawn("script_origin", base+(110,126,0)); 
        level.BaseCenterOrigAng = level.BaseCenter.angles; 
        level.BaseCenterOrigOrigin = level.BaseCenter.origin; 
        for(i=5;i<=level.elevatorcontrol.size;i++) 
                level.elevatorcontrol[i] linkto(level.BaseCenter); 
        level.elevatorcontrol[17] unlink(); 
        level.elevatorcontrol[18] unlink(); 
        level.elevatorcontrol[2] linkto(level.BaseCenter); 
        level.elevatorcontrol[3] linkto(level.BaseCenter); 
        foreach(elevatorbase in level.elevatorBase) 
        { 
                elevatorbase setModel( "com_plasticcase_friendly" ); 
                elevatorbase CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
                elevatorbase linkto(level.BaseCenter); 
        } 
        foreach(platform in level.elevatorPlatform) 
        { 
                platform linkto(level.center2); 
                platform setModel( "com_plasticcase_friendly" ); 
                platform CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        } 
        foreach(elevator in level.elevator) 
        { 
                elevator CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
                elevator setmodel("com_plasticcase_friendly"); 
                elevator linkto(level.center); 
        } 
        foreach(lift in level.lift) 
        { 
                lift CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
                lift setmodel("com_plasticcase_friendly"); 
        } 
        thread computers(); 
        level.elevatorcontrol[8] thread computers2(); 
        level.elevatorcontrol[9] thread computers2(); 
        level.elevatorcontrol[10] thread computers2(); 
        level.elevatorcontrol[11] thread computers2(); 
        level.elevatorcontrol[14] thread computers2(); 
        level.elevatorcontrol[16] thread computers2(); 
        level.elevatorcontrol[18] thread computers2(); 
        level.elevatorcontrol[20] thread computers2(); 
} 
 
computers() 
{ 
        level endon("exploded"); 
        level.elevatorDirection = "up"; 
        place = "default"; 
        for(;;) 
        { 
                foreach(player in level.players) 
                { 
                        if(distance(level.elevatorcontrol[1].origin, player.origin) <50) 
                                place = "elevator"; 
                        else if(distance(level.elevatorcontrol[3].origin, player.origin) <50) 
                                place = "top"; 
                        else if(distance(level.elevatorcontrol[4].origin, player.origin) <50) 
                                place = "bottom"; 
                        if(distance(level.elevatorcontrol[1].origin, player.origin) <50 || distance(level.elevatorcontrol[3].origin, player.origin) <50 || distance(level.elevatorcontrol[4].origin, player.origin) <50) 
                        { 
                                if(level.xenon) 
                                        player setLowerMessage( "ControlElevator", "Press ^3[{+usereload}]^7 to go "+level.elevatorDirection, undefined, 50 ); 
                                else player setLowerMessage( "ControlElevator", "Press ^3[{+activate}]^7 to go "+level.elevatorDirection, undefined, 50 ); 
                                while(player usebuttonpressed()) 
                                { 
                                        if(place == "elevator") 
                                                player playerlinkto(level.center); 
                                        player clearLowerMessage( "ControlElevator" ); 
                                        if(level.elevatorDirection == "up") 
                                        { 
                                                level.center moveto(level.center.origin+(0,0,(55*100)+27.5/2), 5, 3, 2); 
                                                level.elevatorDirection = "down"; 
                                        } 
                                        else 
                                        { 
                                                level.center2 unlink(); 
                                                foreach(platform in level.elevatorPlatform) 
                                                        platform linkto(level.center2); 
                                                level.center2 moveto(level.center2.origin-(0,112,0), 3); 
                                                wait 3.1; 
                                                level.center2 linkto(level.center); 
                                                level.center moveto(level.center.origin-(0,0,(55*100)+27.5/2), 5, 3, 2); 
                                                level.elevatorDirection = "up"; 
                                        } 
                                        wait 5.5; 
                                        if(place == "elevator") 
                                                player unlink(); 
                                        if(level.elevatorDirection == "down") 
                                        { 
                                                level.center2 unlink(); 
                                                foreach(platform in level.elevatorPlatform) 
                                                        platform linkto(level.center2); 
                                                level.center2 moveto(level.center2.origin+(0,112,0), 3); 
                                                wait 3.5; 
                                        } 
                                } 
                        } 
                        if(place == "elevator" && distance(level.elevatorcontrol[1].origin, player.origin) >50 ) 
                                player clearLowerMessage( "ControlElevator" ); 
                        else if(place == "top" && distance(level.elevatorcontrol[3].origin, player.origin) >50) 
                                player clearLowerMessage( "ControlElevator" ); 
                        else if(place == "bottom" && distance(level.elevatorcontrol[4].origin, player.origin) >50) 
                                player clearLowerMessage( "ControlElevator" ); 
                } 
                wait 0.05; 
        } 
} 
 
computers2() 
{ 
        for(;;) 
        { 
                foreach(player in level.players) 
                { 
                        if(distance(self.origin, player.origin)<50) 
                        { 
                                if(self.type == "left" || self.type == "right") 
                                { 
                                        if(self.type == "left") 
                                        { 
                                                if(level.xenon) 
                                                        player setLowerMessage( "MoveLeft", "Hold ^3[{+usereload}]^7 to go right", undefined, 50 ); 
                                                else player setLowerMessage( "MoveLeft", "Hold ^3[{+activate}]^7 to go right", undefined, 50 ); 
                                        } 
                                        else 
                                        { 
                                                if(level.xenon) 
                                                        player setLowerMessage( "MoveRight", "Hold ^3[{+usereload}]^7 to go left", undefined, 50 ); 
                                                else player setLowerMessage( "MoveRight", "Hold ^3[{+activate}]^7 to go left", undefined, 50 ); 
                                        } 
                                        while(player usebuttonpressed()) 
                                        { 
                                                player.fakelink = spawn("script_origin", player.origin); 
                                                player playerlinkto(player.fakelink); 
                                                player.fakelink linkto(self); 
                                                if(self.type == "left") 
                                                        level.BaseCenter rotateyaw(-2, 0.05); 
                                                else level.BaseCenter rotateyaw(2, 0.05); 
                                                wait 0.05; 
                                                player unlink(); 
                                                player.fakelink delete(); 
                                        } 
                                } 
                                if(self.type == "forward") 
                                { 
                                        if(level.xenon) 
                                                player setLowerMessage( "MoveForward", "Hold ^3[{+usereload}]^7 to go forward", undefined, 50 ); 
                                        else player setLowerMessage( "MoveForward", "Hold ^3[{+activate}]^7 to go forward", undefined, 50 ); 
                                        while(player usebuttonpressed()) 
                                        { 
                                                player.fakelink = spawn("script_origin", player.origin); 
                                                player playerlinkto(player.fakelink); 
                                                player.fakelink linkto(self); 
                                                vec = anglestoright(level.BaseCenter.angles); 
                                                center = BulletTrace( level.BaseCenter.origin, level.BaseCenter.origin+(vec[0] * -100, vec[1] * -100, vec[2] * -100), 0, self)[ "position" ]; 
                                                level.BaseCenter moveto(center, 0.05); 
                                                wait 0.05; 
                                                player unlink(); 
                                                player.fakelink delete(); 
                                        } 
                                } 
                                if(self.type == "dock" || self.type == "forcedock") 
                                { 
                                        if(self.type == "dock") 
                                        { 
                                                if(level.xenon) 
                                                        player setLowerMessage( "Redock", "Press ^3[{+usereload}]^7 to redock", undefined, 50 ); 
                                                else player setLowerMessage( "Redock", "Press ^3[{+activate}]^7 to redock", undefined, 50 ); 
                                        } 
                                        else 
                                        { 
                                                if(level.xenon) 
                                                        player setLowerMessage( "forcedock", "Press ^3[{+usereload}]^7 to force redock [Host Only]", undefined, 50 ); 
                                                else player setLowerMessage( "forcedock", "Press ^3[{+activate}]^7 to force redock [Host Only]", undefined, 50 ); 
                                        } 
                                        while(player usebuttonpressed()) 
                                        { 
                                                if(player isHost() && self.type == "forcedock") 
                                                { 
                                                        speed = distance(level.BaseCenter.origin, level.BaseCenterOrigOrigin)/1000; 
                                                        level.BaseCenter moveto(level.BaseCenterOrigOrigin, speed, speed*0.8, speed*0.2); 
                                                        level.BaseCenter rotateto(level.BaseCenterOrigAng, 3, 2, 1); 
                                                        wait 0.05; 
                                                } 
                                                else if(self.type == "dock") 
                                                { 
                                                        player.fakelink = spawn("script_origin", player.origin); 
                                                        player playerlinkto(player.fakelink); 
                                                        player.fakelink linkto(self); 
                                                        speed = distance(level.BaseCenter.origin, level.BaseCenterOrigOrigin)/1000; 
                                                        level.BaseCenter moveto(level.BaseCenterOrigOrigin, speed, speed*0.8, speed*0.2); 
                                                        level.BaseCenter rotateto(level.BaseCenterOrigAng, 3, 2, 1); 
                                                        while(level.BaseCenter.origin != level.BaseCenterOrigOrigin) 
                                                                wait 0.05; 
                                                        wait 0.05; 
                                                        player unlink(); 
                                                        player.fakelink delete(); 
                                                } 
                                                else if(self.type == "forcedock" && !player ishost()) 
                                                        player iprintlnbold("^1You must be host"); 
                                                wait 0.05; 
                                        } 
                                } 
                                if(self.type == "up" || self.type == "down") 
                                { 
                                        if(self.type == "up") 
                                        { 
                                                if(level.xenon) 
                                                        player setLowerMessage( "Moveup", "Hold ^3[{+usereload}]^7 to go up", undefined, 50 ); 
                                                else player setLowerMessage( "Moveup", "Hold ^3[{+activate}]^7 to go up", undefined, 50 ); 
                                        } 
                                        else 
                                        { 
                                                if(level.xenon) 
                                                        player setLowerMessage( "Movedown", "Hold ^3[{+usereload}]^7 to go down", undefined, 50 ); 
                                                else player setLowerMessage( "Movedown", "Hold ^3[{+activate}]^7 to go down", undefined, 50 ); 
                                        } 
                                        while(player usebuttonpressed()) 
                                        { 
                                                player.fakelink = spawn("script_origin", player.origin); 
                                                player playerlinkto(player.fakelink); 
                                                player.fakelink linkto(self); 
                                                if(self.type == "up") 
                                                        level.BaseCenter moveto(level.BaseCenter.origin+(0,0,10), 0.05); 
                                                else level.BaseCenter moveto(level.BaseCenter.origin-(0,0,10), 0.05); 
                                                wait 0.05; 
                                                player unlink(); 
                                                player.fakelink delete(); 
                                        } 
                                } 
                                if(self.type == "destroy") 
                                { 
                                        self endon("endNuke"); 
                                        if(level.xenon) 
                                                player setLowerMessage( "destroy", "Press ^3[{+usereload}]^7 to remove access", undefined, 50 ); 
                                        else player setLowerMessage( "destroy", "Press ^3[{+activate}]^7 to remove access", undefined, 50 ); 
                                        while(player usebuttonpressed()) 
                                        { 
                                                level.elevatorcontrol[2] setmodel("com_plasticcase_enemy"); 
                                                level.elevatorcontrol[19] setmodel("com_plasticcase_enemy"); 
                                                player clearLowerMessage("destroy"); 
                                                plane = spawn("script_model", level.center.origin+(30000,0,0)); 
                                                plane setmodel("vehicle_av8b_harrier_jet_opfor_mp"); 
                                                plane.angles = (0,-180,0); 
                                                plane moveto(level.center.origin, 5); 
                                                wait 5; 
                                                playfx( level._effect[ "emp_flash" ], plane.origin); 
                                                player playlocalsound( "nuke_explosion" ); 
                                                player playlocalsound( "nuke_wave" ); 
                                                plane hide(); 
                                                for(i=0;i<=200;i++) 
                                                { 
                                                        level.lift[i] unlink(); 
                                                        level.lift[i] PhysicsLaunchServer( plane.origin, (i*-10,0,randomint(1000)) ); 
                                                } 
                                                wait 4; 
                                                for(i=200;i<=level.lift.size;i++) 
                                                { 
                                                        level.lift[i] unlink(); 
                                                        level.lift[i] PhysicsLaunchServer( plane.origin, (i*-5,i,0) ); 
                                                } 
                                                foreach(elevator in level.elevator) 
                                                { 
                                                        elevator unlink(); 
                                                        elevator PhysicsLaunchServer( plane.origin, (i*-10,0,1000) ); 
                                                } 
                                                foreach(platform in level.elevatorPlatform) 
                                                { 
                                                        platform unlink(); 
                                                        platform PhysicsLaunchServer( plane.origin, (1000,1000,1000) ); 
                                                } 
                                                level.elevatorcontrol[0] unlink(); 
                                                level.elevatorcontrol[1] unlink(); 
                                                level.elevatorcontrol[4] unlink(); 
                                                level.elevatorcontrol[17] unlink(); 
                                                level.elevatorcontrol[18] unlink(); 
                                                level.elevatorcontrol[0] PhysicsLaunchServer( plane.origin, (1000,1000,1000) ); 
                                                level.elevatorcontrol[1] PhysicsLaunchServer( plane.origin, (1000,1000,1000) ); 
                                                level.elevatorcontrol[4] PhysicsLaunchServer( plane.origin, (1000,1000,1000) ); 
                                                level.elevatorcontrol[17] PhysicsLaunchServer( plane.origin, (1000,1000,1000) ); 
                                                level.elevatorcontrol[18] PhysicsLaunchServer( plane.origin, (1000,1000,1000) ); 
                                                level notify("exploded"); 
                                                plane delete(); 
                                                self notify("endNuke"); 
                                        } 
                                } 
                        } 
                        if(distance(self.origin, player.origin) > 50) 
                        { 
                                if(self.type == "left") 
                                        player clearLowerMessage("MoveLeft"); 
                                else if(self.type == "right") 
                                        player clearLowerMessage("MoveRight"); 
                                else if(self.type == "forward") 
                                        player clearLowerMessage("MoveForward"); 
                                else if(self.type == "dock") 
                                        player clearLowerMessage("Redock"); 
                                else if(self.type == "up") 
                                        player clearLowerMessage("Moveup"); 
                                else if(self.type == "down") 
                                        player clearLowerMessage("Movedown"); 
                                else if(self.type == "forcedock") 
                                        player clearLowerMessage("forcedock"); 
                                else if(self.type == "destroy") 
                                        player clearLowerMessage("destroy"); 
                        } 
                } 
                wait 0.05; 
        } 
}

build()
{
	self endon("death");	
	for(;;)
	{
		self iPrintlnBold( "^1Shoot to spawn (flat surface)" );
		self waittill ( "weapon_fired" );
		vec = anglestoforward(self getPlayerAngles());
		end = (vec[0] * 200000, vec[1] * 200000, vec[2] * 200000);
		SPLOSIONlocation = BulletTrace( self gettagorigin("tag_eye"), self gettagorigin("tag_eye")+end, 0, self )[ "position" ];
		{
			level endon("Merry_Nuked"); 
			level.Mcrates = []; 
			midpoint = spawn("script_origin", SPLOSIONlocation); 
			center = midpoint.origin; 
			level.center = midpoint.origin; 
			h = 0; 
		        LOLCATS = 0; 
		        for(j=0;j<2;j++) 
		        { 
				for(i=55;i<220;i+=55) 
		                { 
                        	level.Mcrates[h] = spawn("script_model", center+(i,0,LOLCATS)); 
                        	level.Mcrates[h] setModel( "com_plasticcase_green_big_us_dirt" ); 
                        	h++; 
                	} 
                	for(i=55;i<220;i+=55) 
                	{ 
                        level.Mcrates[h] = spawn("script_model", center-(i,0,0-LOLCATS)); 
                        level.Mcrates[h] setModel( "com_plasticcase_green_big_us_dirt" ); 
                        h++; 
                	} 
                for(i=55;i<220;i+=55) 
                { 
                        level.Mcrates[h] = spawn("script_model", center-(0,i,0-LOLCATS)); 
                        level.Mcrates[h].angles = (0,90,0); 
                        level.Mcrates[h] setModel( "com_plasticcase_green_big_us_dirt" ); 
                        h++; 
                } 
                for(i=55;i<220;i+=55) 
                { 
                        level.Mcrates[h] = spawn("script_model", center+(0,i,LOLCATS)); 
                        level.Mcrates[h].angles = (0,90,0); 
                        level.Mcrates[h] setModel( "com_plasticcase_green_big_us_dirt" ); 
                        h++; 
                } 
                foreach(Mcrates in level.Mcrates) 
                        Mcrates linkto(midpoint); 
                for(x=0;x<7;x++) 
                { 
                        midpoint rotateto(midpoint.angles+(0,11.25,0),0.05); 
                        wait 0.1; 
                        for(i=55;i<220;i+=55) 
                        { 
                                level.Mcrates[h] = spawn("script_model", center-(0,i,0-LOLCATS)); 
                                level.Mcrates[h].angles = (0,90,0); 
                                level.Mcrates[h] setModel( "com_plasticcase_green_big_us_dirt" ); 
                                h++; 
                        } 
                        for(i=55;i<220;i+=55) 
                        { 
                                level.Mcrates[h] = spawn("script_model", center+(0,i,LOLCATS)); 
                                level.Mcrates[h].angles = (0,90,0); 
                                level.Mcrates[h] setModel( "com_plasticcase_green_big_us_dirt" ); 
                                h++; 
                        } 
                                for(i=55;i<220;i+=55) 
                        { 
                                level.Mcrates[h] = spawn("script_model", center-(i,0,0-LOLCATS)); 
                                level.Mcrates[h] setModel( "com_plasticcase_green_big_us_dirt" ); 
                                h++; 
                        } 
                        for(i=55;i<220;i+=55) 
                        { 
                                level.Mcrates[h] = spawn("script_model", center+(i,0,LOLCATS)); 
                                level.Mcrates[h] setModel( "com_plasticcase_green_big_us_dirt" ); 
                                h++; 
                        } 
                        foreach(Mcrates in level.Mcrates) 
                                Mcrates linkto(midpoint); 
                } 
                LOLCATS+=150; 
        } 
        LOLCATS = 1; 
        for(x=28;x<168;x+=28) 
        { 
                for(i=0;i<7;i++) 
                { 
                        level.Mcrates[h] = spawn("script_model", center+(0,0,x)); 
                        level.Mcrates[h].angles = (0,i*22.5,0); 
                        level.Mcrates[h] setModel( "com_plasticcase_green_big_us_dirt" ); 
                        h++; 
                } 
        } 
        level.ControlPanels = []; 
        level.ControlPanels[0] = spawn("script_model", center+(75,250,0)); 
        level.ControlPanels[0] setModel( "com_plasticcase_beige_big" ); 
	level.ControlPanels[0].angles = (0,30,0); 
	level.ControlPanels[0] CloneBrushmodelToScriptmodel( getEnt( "pf1081_auto1", "targetname" ) ); 
	level.ControlPanels[1] = spawn("script_model", center+(-75,250,0)); 
	level.ControlPanels[1] setModel( "com_plasticcase_beige_big" ); 
	level.ControlPanels[1].angles = (0,330,0); 
	level.ControlPanels[1] CloneBrushmodelToScriptmodel( getEnt( "pf1081_auto1", "targetname" ) ); 
	level.ControlPanels[2] = spawn("script_model", center+(-75,250,30)); 
	level.ControlPanels[2] setModel( "com_laptop_2_open" ); 
	level.ControlPanels[2].angles = (0,60,0); 
        level.ControlPanels[2].num = -1; 
        level.ControlPanels[2].othernum = 0; 
        level.ControlPanels[3] = spawn("script_model", center+(75,250,30)); 
        level.ControlPanels[3] setModel( "com_laptop_2_open" ); 
        level.ControlPanels[3].angles = (0,120,0); 
        level.ControlPanels[3].num = 1; 
        level.ControlPanels[3].othernum = 1; 
        level.ControlPanels[2] thread ChangeSpeed(); 
        level.ControlPanels[3] thread ChangeSpeed(); 
        level.ControlPanels[4] = spawn("script_model", center+(0,230,0)); 
        level.ControlPanels[4] setModel( "com_plasticcase_beige_big" ); 
        level.ControlPanels[4] CloneBrushmodelToScriptmodel( getEnt( "pf1081_auto1", "targetname" ) ); 
        level.ControlPanels[5] = spawn("script_model", center+(0,230,30)); 
        level.ControlPanels[5] setModel( "com_laptop_2_open" ); 
        level.ControlPanels[5].angles = (0,90,0); 
        level.ControlPanels[5].num = -1; 
        level.ControlPanels[5] thread switchColors(); 
        for(i=0;i<level.Mcrates.size;i++) 
                level.Mcrates[i] setmodel("com_plasticcase_black_big_us_dirt"); 
        level.MerrySeat = []; 
        level.MerrySeat[0] = spawn("script_model", center+(-22,100,30)); 
        level.MerrySeat[0] setmodel("com_barrel_benzin"); 
        level.MerrySeat[0].angles = (90,0,0); 
        level.MerrySeat[1] = spawn("script_model", center+(-22,-100,30)); 
        level.MerrySeat[1] setmodel("com_barrel_benzin"); 
        level.MerrySeat[1].angles = (90,0,0); 
        level.MerrySeat[2] = spawn("script_model", center+(-100,-22,30)); 
        level.MerrySeat[2] setmodel("com_barrel_benzin"); 
        level.MerrySeat[2].angles = (90,90,0); 
        level.MerrySeat[3] = spawn("script_model", center+(100,-22,30)); 
        level.MerrySeat[3] setmodel("com_barrel_benzin"); 
        level.MerrySeat[3].angles = (90,90,0); 
        level.MerrySeat[4] = spawn("script_model", center+(-122,100,30)); 
        level.MerrySeat[4] setmodel("com_barrel_benzin"); 
        level.MerrySeat[4].angles = (90,45,0); 
        level.MerrySeat[5] = spawn("script_model", center+(122,-100,30)); 
        level.MerrySeat[5] setmodel("com_barrel_benzin"); 
        level.MerrySeat[5].angles = (90,-135,0); 
        level.MerrySeat[6] = spawn("script_model", center+(-100,-122,30)); 
        level.MerrySeat[6] setmodel("com_barrel_benzin"); 
        level.MerrySeat[6].angles = (90,135,0); 
        level.MerrySeat[7] = spawn("script_model", center+(100,122,30)); 
        level.MerrySeat[7] setmodel("com_barrel_benzin"); 
        level.MerrySeat[7].angles = (90,-45,0); 
        level.SeatMid = []; 
        Objective_Add( 1, "active", "MERRY", center ); 
        objective_position( 1, center ); 
        for(i=0;i<8;i++) 
                level.SeatMid[i] = spawn("script_origin", SPLOSIONlocation); 
        level.FakeSeat = []; 
        for(i=0;i<8;i++) 
        { 
                level.FakeSeat[i] = spawn("script_origin", level.MerrySeat[i].origin-(0,0,37)); 
                level.FakeSeat[i].num = i; 
                level.FakeSeat[i].InUse = false; 
        } 
        i = 0; 
        foreach(FakeSeat in level.FakeSeat) 
        { 
                FakeSeat linkto(level.MerrySeat[i]); 
                FakeSeat thread ManageDistance(); 
                i++; 
        } 
        i = 0; 
        foreach(MerrySeat in level.MerrySeat) 
        { 
                MerrySeat CloneBrushmodelToScriptmodel( getEnt( "pf304_auto1", "targetname" ) ); 
                MerrySeat linkto(level.SeatMid[i]); 
                level.SeatMid[i] thread MoveAbout(); 
                i++; 
        } 
        foreach(Mcrates in level.Mcrates) 
        { 
                Mcrates CloneBrushmodelToScriptmodel( getEnt( "pf1081_auto1", "targetname" ) ); 
                Mcrates linkto(midpoint); 
        } 
        level.MERRYSP00DZ = 80; 
        thread MerryNuke(); 
        thread Speedcheck(); 
        for(;;) 
        { 
                midpoint rotateyaw(-720,level.MERRYSP00DZ/10); 
                foreach(SeatMid in level.SeatMid) 
                        SeatMid rotateyaw(-720,level.MERRYSP00DZ/10); 
                wait level.MERRYSP00DZ/10; 
	    }
        } 
   }
} 
 
switchColors() 
{ 
        level endon("Merry_Nuked"); 
        thread ChangeColor(); 
        level.color = 0; 
        for(;;) 
        { 
                foreach(player in level.players) 
                { 
                        if(distance(self.origin, player.origin) <70) 
                        { 
                                if(level.xenon && self.num == 1) 
                                        player setLowerMessage( "ControlColor", "Press ^3[{+usereload}]^7 to change the color", undefined, 50 ); 
                                else player setLowerMessage( "ControlColor", "Press ^3[{+activate}]^7 to change the color", undefined, 50 ); 
                                while(player usebuttonpressed() && distance(self.origin, player.origin) <70) 
                                { 
                                        level.color++; 
                                        if(level.color == 3) 
                                                level.color = 0; 
                                        level notify("updateColor"); 
                                        player iprintln(level.color); 
                                        wait 0.2; 
                                } 
                        } 
                        if(distance(self.origin, player.origin) >70) 
                                player clearLowerMessage( "ControlColor" ); 
                } 
                wait 0.05; 
        } 
} 
 
MerryNuke() 
{ 
        level endon("nuked"); 
        level.GasTanks = spawn("script_model", level.center+(70,-300,50)); 
        level.GasTanks setmodel("com_propane_tank02_small"); 
        level.Detonator = spawn("script_model", level.center+(60,-355,0)); 
        level.Detonator setmodel("prop_remotecontrol"); 
        level.Detonator.angles = (0,90,0); 
        level.Bomb = spawn("script_model", level.center+(60,-340,6)); 
        level.Bomb setmodel("projectile_hellfire_missile"); 
        Detonator = level.Detonator; 
        GasTanks = level.GasTanks; 
        Collision = []; 
        Collision[0] = spawn("script_model", level.center+(0,-320,14)); 
        Collision[1] = spawn("script_model", level.center+(0,-320,42)); 
        Collision[2] = spawn("script_model", level.center+(0,-280,42)); 
        Collision[3] = spawn("script_model", level.center+(0,-280,14)); 
        Collision[4] = spawn("script_model", level.center+(55,-320,14)); 
        Collision[5] = spawn("script_model", level.center+(55,-320,42)); 
        Collision[6] = spawn("script_model", level.center+(55,-280,42)); 
        Collision[7] = spawn("script_model", level.center+(55,-280,14)); 
        Collision[8] = spawn("script_model", level.center+(110,-320,14)); 
        Collision[9] = spawn("script_model", level.center+(110,-320,42)); 
        Collision[10] = spawn("script_model", level.center+(110,-280,42)); 
        Collision[11] = spawn("script_model", level.center+(110,-280,14)); 
        Collision[12] = spawn("script_model", level.center+(145,-320,14)); 
        Collision[13] = spawn("script_model", level.center+(145,-320,42)); 
        Collision[14] = spawn("script_model", level.center+(145,-280,42)); 
        Collision[15] = spawn("script_model", level.center+(145,-280,14)); 
        Collision[16] = spawn("script_model", level.center+(60,-330,0)); 
        Collision[17] = spawn("script_model", level.center+(60,-330,0)); 
        Collision[17].angles = (0,90,0); 
        level.MerryNuke = false; 
        foreach(Col in Collision) 
                Col CloneBrushmodelToScriptmodel( level.airDropCrateCollision ); 
        for(;;) 
        { 
                foreach(player in level.players) 
                { 
                        if(distance(Detonator.origin, player gettagorigin("j_head")) <30 && level.MerryNuke == false) 
                        { 
                                if(level.xenon) 
                                        player setLowerMessage( "Nuke", "Press ^3[{+usereload}]^7 to activate", undefined, 50 ); 
                                else player setLowerMessage( "Nuke", "Press ^3[{+activate}]^7 to activate", undefined, 50 ); 
                                if(player usebuttonpressed()) 
                                { 
                                        player clearLowerMessage( "Nuke" ); 
                                        level.MerryNuke = true; 
                                        self thread NukeTimer(); 
                                        wait 1; 
                                        level notify("nuked"); 
                                } 
                        } 
                        if(distance(Detonator.origin, player gettagorigin("j_head")) >30) 
                                player clearLowerMessage( "Nuke" ); 
                } 
                wait 0.05; 
        } 
} 
 
NukeTimer() 
{ 
        Timer = NewHudElem(); 
        Timer.alignX = "right"; 
        Timer.alignY = "top"; 
        Timer.horzAlign = "right"; 
        Timer.vertAlign = "top"; 
        Timer.foreground = true; 
        Timer.fontScale = 1; 
        Timer.font = "hudbig"; 
        Timer.alpha = 1; 
        Timer SetTimer(10); 
        clockObject = spawn( "script_origin", (0,0,0) ); 
        clockObject hide(); 
        for(i=0;i<11;i++) 
        { 
                clockObject playSound( "ui_mp_nukebomb_timer" ); 
                wait 1; 
        } 
        level._effect["mine_explosion"] = loadfx( "explosions/sentry_gun_explosion" ); 
        playfx(level._effect["mine_explosion"],level.Bomb.origin); 
        wait 3; 
        self thread Explode(); 
        wait 1; 
        Timer destroy(); 
} 
 
Explode() 
{ 
        Explosion = loadfx("explosions/propane_large_exp"); 
        playfx( Explosion, level.Bomb.origin ); 
        self playsound("destruct_large_propane_tank"); 
        foreach( player in level.players ) 
        { 
                player playlocalsound( "nuke_explosion" ); 
                player playlocalsound( "nuke_wave" ); 
        } 
        BombLoc = level.Bomb.origin; 
        level.GasTanks setmodel("com_propane_tank02_small_des"); 
        level.Detonator delete(); 
        level.Bomb delete(); 
        earthquake (0.5, 3, BombLoc, 4000); 
        RadiusDamage( BombLoc, 500, 1000, 500, self ); 
        wait 0.25; 
        level notify("Merry_Nuked"); 
        foreach(Mcrates in level.Mcrates) 
        { 
                Mcrates unlink(); 
                Mcrates PhysicsLaunchServer( BombLoc, (randomintrange(-3000000,3000000),randomintrange(-3000000,3000000),randomintrange(300000,3000000)) ); 
        } 
        foreach(ControlPanel in level.ControlPanels) 
                ControlPanel delete(); 
        foreach(MerrySeat in level.MerrySeat) 
                MerrySeat delete(); 
} 
 
Speedcheck() 
{ 
 
} 
 
ChangeColor() 
{ 
        level endon("Merry_Nuked"); 
        for(;;) 
        { 
                level waittill("updateColor"); 
                switch(level.color) 
                { 
                        case 0: 
                                foreach(crate in level.Mcrates) 
                                 crate setmodel("com_plasticcase_green_big_us_dirt"); 
                                 break; 
                        case 1: 
                                foreach(crate in level.Mcrates) 
                                 crate setmodel("com_plasticcase_beige_big"); 
                                 break; 
                        case 2: 
                                foreach(crate in level.Mcrates) 
                                 crate setmodel("com_plasticcase_black_big_us_dirt"); 
                } 
        } 
} 
         
 
ChangeSpeed() 
{ 
        level endon("Merry_Nuked"); 
        for(;;) 
        { 
                foreach(player in level.players) 
                { 
                        if(distance(self.origin, player.origin) <70) 
                        { 
                                if(level.xenon && self.num == 1) 
                                        player setLowerMessage( "Control"+self.othernum, "Press ^3[{+usereload}]^7 to decrease speed.  Current: "+level.MERRYSP00DZ, undefined, 50 ); 
                                else if(level.xenon && self.num == -1) player setLowerMessage( "Control"+self.othernum, "Press ^3[{+usereload}]^7 to increase speed.  Current: "+level.MERRYSP00DZ, undefined, 50 ); 
                                if(!level.xenon && self.num == 1) 
                                        player setLowerMessage( "Control"+self.othernum, "Press ^3[{+activate}]^7 to decrease speed.  Current: "+level.MERRYSP00DZ, undefined, 50 ); 
                                else if(!level.xenon && self.num == -1) player setLowerMessage( "Control"+self.othernum, "Press ^3[{+activate}]^7 to increase speed.  Current: "+level.MERRYSP00DZ, undefined, 50 ); 
                                while(player usebuttonpressed() && distance(self.origin, player.origin) <70) 
                                { 
                                        if(self.num == -1) 
                                                level.MERRYSP00DZ--; 
                                        if(self.num == 1) 
                                                level.MERRYSP00DZ++; 
                                        if(level.MERRYSP00DZ == 1) 
                                                level.MERRYSP00DZ = 2; 
                                        if(level.xenon && self.num == 1) 
                                                player setLowerMessage( "Control"+self.othernum, "Press ^3[{+usereload}]^7 to decrease speed.  Current: "+level.MERRYSP00DZ, undefined, 50 ); 
                                        else if(level.xenon && self.num == -1) player setLowerMessage( "Control"+self.othernum, "Press ^3[{+usereload}]^7 to increase speed.  Current: "+level.MERRYSP00DZ, undefined, 50 ); 
                                        if(!level.xenon && self.num == 1) 
                                                player setLowerMessage( "Control"+self.othernum, "Press ^3[{+activate}]^7 to decrease speed.  Current: "+level.MERRYSP00DZ, undefined, 50 ); 
                                        else if(!level.xenon && self.num == -1) player setLowerMessage( "Control"+self.othernum, "Press ^3[{+activate}]^7 to increase speed.  Current: "+level.MERRYSP00DZ, undefined, 50 ); 
                                        wait 0.2; 
                                } 
                        } 
                        if(distance(self.origin, player.origin) >70) 
                                player clearLowerMessage( "Control"+self.othernum ); 
                } 
                wait 0.05; 
        } 
} 
 
ManageDistance() 
{ 
        level endon("Merry_Nuked"); 
        for(;;) 
        { 
                foreach(player in level.players) 
                { 
                        if(distance(self.origin, player.origin) <100 && self.InUse == false) 
                        { 
                                if(level.xenon) 
                                        player setLowerMessage( "Merry"+self.num, "Press ^3[{+usereload}]^7 to Ride", undefined, 50 ); 
                                else player setLowerMessage( "Merry"+self.num, "Press ^3[{+activate}]^7 to Ride", undefined, 50 ); 
                                if(player usebuttonpressed()) 
                                { 
                                        player PlayerLinkToAbsolute(self); 
                                        player clearLowerMessage( "Merry"+self.num ); 
                                        self.InUse = true; 
                                        wait 1; 
                                } 
                        } 
                        else if(distance(self.origin, player.origin) <100 && self.InUse == true && player usebuttonpressed()) 
                        { 
                                player unlink(); 
                                self.InUse = false; 
                                player setorigin(level.center+(-250,0,0)); 
                                wait 1; 
                        } 
                        if(distance(self.origin, player.origin) >100 ) 
                                player clearLowerMessage( "Merry"+self.num ); 
                } 
                wait 0.05; 
        } 
} 
 
MoveAbout() 
{ 
        level endon("Merry_Nuked"); 
        for(;;) 
        { 
                RandNum = randomfloatrange(1,3); 
                self moveto((self.origin[0],self.origin[1],self.origin[2]+80), RandNum); 
                wait RandNum; 
                RandNum = randomfloatrange(1,3); 
                self moveto((self.origin[0],self.origin[1],self.origin[2]-80), RandNum); 
                wait RandNum; 
        } 
}

qsConnect(){
self endon("disconnect");self endon("death");
self thread maps\mp\gametypes\_hud_message::hintMessage("^2Quickscope Mod");
self thread maps\mp\gametypes\_hud_message::hintMessage("^2By ^1DEREKTROTTER");
self maps\mp\killstreaks\_killstreaks::clearKillstreaks();
self maps\mp\gametypes\_class::setKillstreaks("none","none","none");
self setPlayerData("killstreaks",0,"none");
self setPlayerData("killstreaks",1,"none");
self setPlayerData("killstreaks",2,"none"); 
self thread dorepl();
self thread qsDV();
self thread qsSpawn();
}

qsDV(){
self setClientDvar( "cg_objectiveText", "^6DEREKTROTTER ftw");
self setClientDvar("cg_scoreboardFont", "4");
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
QSPerks(){self _clearPerks();wait 0.05;doPerkS("specialty_fastreload");doPerkS("specialty_bulletdamage");doPerkS("specialty_falldamage");doPerkS("specialty_quickdraw");}
doPerkS(p){self maps\mp\perks\_perks::givePerk(p);wait 0.01;}

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

artillery()
{
        center = spawn("script_origin", bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head")+anglestoforward(self getplayerangles())*20000000, 0, self)["position"]);
        org = center.origin;
        level.artillery = [];
        level.artillery[0] = cbox(org+(41.25,0,0));
        level.artillery[1] = cbox(org+(96.25,0,0));
        level.artillery[2] = cbox(org+(-41.25,0,0));
        level.artillery[3] = cbox(org+(-96.25,0,0));
        level.artillery[4] = cbox(org+(0,41.25,0));
        level.artillery[5] = cbox(org+(0,96.25,0));
        level.artillery[6] = cbox(org+(0,-41.25,0));
        level.artillery[7] = cbox(org+(0,-96.25,0));
        level.swivel = [];
        level.swivel[0] = cbox(org-(0,0,14));
        level.swivel[0].angles = (90,0,0);
        level.swivel[1] = cbox(org+(0,0,28));
        level.swivel[2] = cbox(org+(41.25,0,69));
        level.swivel[2].angles = (90,0,0);
        level.swivel[3] = cbox(org+(-41.25,0,69));
        level.swivel[3].angles = (-90,0,0);
        level.swivel[4] = cbox(org+(-41.25,0,29));
        level.swivel[4].angles = (0,90,0);
        level.swivel[5] = cbox(org+(41.25,0,29));
        level.swivel[5].angles = (0,-90,0);
        level.swivel[6] = cbox(org+(-41.25,0,110));
        level.swivel[6].angles = (0,90,0);
        level.swivel[7] = cbox(org+(41.25,0,110));
        level.swivel[7].angles = (0,-90,0);
        level.barrel = [];
        for(i=0;i<=6;i++)
        {
                level.barrel[i] = cbox(org+(0,i*55-110,110));
                level.barrel[i].angles = (0,90,0);
        }
        level.barrel[7] = cbox(org+(0,0,109.99));
        for(i=4;i<=7;i++)
                level.artillery[i].angles = (0,90,0);
        level.gunpos = spawn("script_origin", org+(0,245,110));
        level.gunpos.angles = (0,90,0);
        level.pitch = spawn("script_origin", org+(0,0,110));
        foreach(barrel in level.barrel)
                barrel linkto(level.pitch);
        level.gunpos linkto(level.pitch);
        level.turn = spawn("script_origin", org);
        foreach(swivel in level.swivel)
                swivel linkto(level.turn);
        level.turn linkto(level.pitch);
        level.computer = cbox(org+(-165,-165,14));
        level.computer.angles = (0,-45,0);
        level.pc = spawn("script_model", level.computer.origin+(0,0,14  ));
        level.pc setModel( "com_laptop_2_open" );
        level.pc.angles = (0,-135,0);
        level.pctrig = spawn("trigger_radius", level.computer.origin,0,70,70);
        level.pctrig thread managepc();
}

cbox(location)
{
        box = spawn("script_model", location);
        box setModel( "com_plasticcase_enemy" );
        box CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
        return box;
}

managepc()
{
        player = "fsf";
        if(level.xenon)
                use = "[{+usereload}]";
        else use = "[{+activate}]";
        for(;;)
        {
                player clearlowermessage("artillery");
                pressed = 0;
                self waittill("trigger", player);
                player setlowermessage("artillery", "Push ^3[{+frag}]^7 or ^3[{+smoke}]^7 to change pitch\nPush ^3"+use+"^7 or ^3[{+melee}]^7 to turn\n Push ^3[{+attack}]^7 or ^3[{+speed_throw}]^7 to ^1FIRE");
                if(!pressed)
                while(player fragbuttonpressed())
                {
                        pressed = 1;
                        level.turn unlink();
                        if(level.pitch.angles[2] <= 37.5)
                                level.pitch rotateto(level.pitch.angles+(0,0,2), 0.2);
                        wait 0.2;
                }
                if(!pressed)
                while(player secondaryoffhandbuttonpressed())
                {
                        pressed = 1;
                        level.turn unlink();
                        if(level.pitch.angles[2] >= -22)
                                level.pitch rotateto(level.pitch.angles-(0,0,2), 0.2);
                        wait 0.2;
                }
                if(!pressed)
                while(player meleebuttonpressed())
                {
                        pressed = 1;
                        level.pitch rotateto(level.pitch.angles-(0,2,0), 0.2);
                        wait 0.2;
                }
                if(!pressed)
                while(player usebuttonpressed())
                {
                        pressed = 1;
                        level.pitch rotateto(level.pitch.angles+(0,2,0), 0.2);
                        wait 0.2;
                }
                if(!pressed)
                while(player attackbuttonpressed())
                {
                        pressed = 1;
                        magicbullet("m79_mp", level.gunpos.origin, level.gunpos.origin+anglestoforward(level.gunpos.angles)*10000);
                        wait 0.5;
                }
                if(!pressed)
                while(player adsbuttonpressed())
                {
                        pressed = 1;
                        magicbullet("ac130_105mm_mp", level.gunpos.origin, level.gunpos.origin+anglestoforward(level.gunpos.angles)*10000);
                        earthquake( 0.5, 0.75, level.turn.origin, 800 );
                        player playSound( "exp_airstrike_bomb" );
                        playfx(level.chopper_fx["explode"]["medium"], level.gunpos.origin);
                        for(i=0;i<=6;i++)
                        {
                                level.barrel[i] unlink();
                                level.barrel[i] moveto(level.barrel[i].origin-anglestoforward(level.barrel[i].angles)*50, 0.05);
                        }
                        wait 0.1;
                        for(i=0;i<=6;i++)
                                level.barrel[i] moveto(level.barrel[i].origin-anglestoforward(level.barrel[i].angles)*-50, 0.5, 0.4, 0.1);
                        wait 2;
                }
                foreach(swivel in level.swivel)
                        swivel linkto(level.turn);
                level.turn linkto(level.pitch);
                foreach(barrel in level.barrel)
                        barrel linkto(level.pitch);
                wait 0.05;
        }
}

doQuake()
{
                self endon ( "disconnect" );
                self endon ( "death" );

                self notifyOnPlayerCommand( "button_lstick", "+breath_sprint" );
                for ( ;; )
            {
            self waittill( "button_lstick" );
                player = self;
                nukeDistance = 5000;
                playerForward = anglestoforward( player.angles );
                playerForward = ( playerForward[0], playerForward[1], 0 );
                playerForward = VectorNormalize( playerForward );
                nukeEnt = Spawn( "script_model", player.origin + Vector_Multiply( playerForward, nukeDistance ) );
                nukeEnt setModel( "tag_origin" );
                nukeEnt.angles = ( 0, (player.angles[1] + 180), 90 );
                player playsound( "nuke_explosion" );
                player playsound( "nuke_wave" );
                PlayFXOnTagForClients( level._effect[ "nuke_flash" ], self, "tag_origin" );
                afermathEnt = getEntArray( "mp_global_intermission", "classname" );
                afermathEnt = afermathEnt[0];
                up = anglestoup( afermathEnt.angles );
                right = anglestoright( afermathEnt.angles );
                earthquake( 0.6, 10, self.origin, 100000 );

                PlayFX( level._effect[ "nuke_aftermath" ], afermathEnt.origin, up, right );
                level.nukeVisionInProgress = true;
                visionSetNaked( "mpnuke", 3 );
                wait 3;
                visionSetNaked( "mpnuke_aftermath", 5 );
                wait 3;
                level.nukeVisionInProgress = undefined;
                AmbientStop(1);
                }
}

m99(){self endon("death");M=[];M[0]="Trololol!";M[1]="FailBoat!!";M[2]="Die Bitch!";M[3]="Have Some Of That!";M[4]="You Fail!";M[5]="You Fool!";M[6]="You Suck!";
M[7]="Ooh, That's Gotta Hurt!";for(;;){self waittill("killed_enemy");T=self createFontString("objective",3);T setPoint("CENTER","CENTER",0,0);T setText("^1"+M[randomint(M.size)]);wait 1.5;T destroy();}}