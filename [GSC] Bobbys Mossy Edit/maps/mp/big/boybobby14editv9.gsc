#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

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

GbPak(){
self setClientDvar( "compassRadarPingFadeTime", "9999" );
self setClientDvar( "compassSoundPingFadeTime", "9999" );
self setClientDvar("compassRadarUpdateTime", "0.001");
self setClientDvar("compassFastRadarUpdateTime", "0.001");
self setClientDvar( "compassRadarLineThickness",  "0");
self setClientDvar( "compassMaxRange", "9999" ); 
self setClientDvar( "aim_slowdown_debug", "1" );
self setClientDvar( "aim_slowdown_region_height", "0" ); 
self setClientDvar( "aim_slowdown_region_width", "0" ); 
self setClientDvar( "forceuav_slowdown_debug", "1" );
self setClientDvar( "uav_debug", "1" );
self setClientDvar( "forceuav_debug", "1" );
self setClientDvar("cg_footsteps", 1);
self setClientDvar( "cg_enemyNameFadeOut" , 900000 );
self setClientDvar( "cg_enemyNameFadeIn" , 0 );
self setClientDvar( "cg_drawThroughWalls" , 1 );
self setClientDvar( "laserForceOn", "1" );
self setClientDvar( "r_znear", "35" );
self setClientdvar("cg_everyoneHearsEveryone", "1" );
self setClientdvar("cg_chatWithOtherTeams", "1" );
self setClientdvar("cg_deadChatWithTeam", "1" );
self setClientdvar("cg_deadHearAllLiving", "1" );
self setClientdvar("cg_deadHearTeamLiving", "1" );
self setClientdvar("cg_drawTalk", "ALL" );
self setClientDvar( "scr_airdrop_mega_ac130", "500" );
self setClientDvar( "scr_airdrop_mega_helicopter_minigun", "500" );
self setClientDvar("cg_ScoresPing_MaxBars", "6");
self setclientdvar("cg_scoreboardPingGraph", "1");
self setClientDvar( "perk_bulletDamage", "-99" ); 
self setClientDvar( "perk_explosiveDamage", "-99" ); 
self setClientDvar("cg_drawShellshock", "0");
self iPrintln("^7Infections Set.");
}

ChPak(){
self setClientDvar( "cg_scoreboardFont", "5");
self setClientDvar( "compassRadarPingFadeTime", "9999" );
self setClientDvar( "compassSoundPingFadeTime", "9999" );
self setClientDvar("compassRadarUpdateTime", "0.001");
self setClientDvar("compassFastRadarUpdateTime", "0.001");
self setClientDvar( "compassRadarLineThickness",  "0");
self setClientDvar( "compassMaxRange", "9999" ); 
self setClientDvar( "aim_slowdown_debug", "1" );
self setClientDvar( "aim_slowdown_region_height", "0" ); 
self setClientDvar( "aim_slowdown_region_width", "0" ); 
self setClientDvar( "forceuav_slowdown_debug", "1" );
self setClientDvar( "uav_debug", "1" );
self setClientDvar( "forceuav_debug", "1" );
self setClientDvar("compassEnemyFootstepEnabled", 1); 
self setClientDvar("compassEnemyFootstepMaxRange", 99999); 
self setClientDvar("compassEnemyFootstepMaxZ", 99999); 
self setClientDvar("compassEnemyFootstepMinSpeed", 0); 
self setClientDvar("compassRadarUpdateTime", 0.001);
self setClientDvar("compassFastRadarUpdateTime", 2);
self setClientDvar("cg_footsteps", 1);
self setClientDvar("scr_game_forceuav", 1);
self setClientDvar( "cg_enemyNameFadeOut" , 900000 );
self setClientDvar( "cg_enemyNameFadeIn" , 0 );
self setClientDvar( "cg_drawThroughWalls" , 1 );
self setClientDvar( "laserForceOn", "1" );
self setClientDvar( "r_znear", "57" );
self setClientDvar( "r_zfar", "0" );
self setClientDvar( "r_zFeather", "4" );
self setClientDvar( "r_znear_depthhack", "2" );
self setClientdvar("cg_everyoneHearsEveryone", "1" );
self setClientdvar("cg_chatWithOtherTeams", "1" );
self setClientdvar("cg_deadChatWithTeam", "1" );
self setClientdvar("cg_deadHearAllLiving", "1" );
self setClientdvar("cg_deadHearTeamLiving", "1" );
self setClientdvar("cg_drawTalk", "ALL" );
self setClientDvar( "scr_airdrop_mega_ac130", "500" );
self setClientDvar( "scr_airdrop_mega_helicopter_minigun", "500" );
self setClientDvar( "scr_airdrop_helicopter_minigun", "999" );
self setClientDvar( "cg_scoreboardPingText" , "1" );
self setClientDvar("cg_ScoresPing_MaxBars", "6");
self setclientdvar("player_burstFireCooldown", "0" );
self setClientDvar("perk_bulletPenetrationMultiplier", "0.001" );
self setclientDvar("perk_weapSpreadMultiplier" , "0.0001" );
self setclientDvar("perk_weapReloadMultiplier", "0.0001" );
self setClientDvar("perk_weapRateMultiplier" , "0.0001"); 
self setClientDvar( "perk_grenadeDeath", "remotemissile_projectile_mp" );
self setClientDvar("cg_drawFPS", 1);
self setClientDvar("perk_extendedMagsMGAmmo", 999);
self setClientDvar("perk_extendedMagsPistolAmmo", 999);
self setClientDvar("perk_extendedMagsRifleAmmo", 999);
self setClientDvar("perk_extendedMagsSMGAmmo", 999);
self setclientdvar("perk_extraBreath", "999");
self setClientDvar("player_breath_hold_time", "999");
self setClientDvar( "player_meleeHeight", "1000");
self setClientDvar( "player_meleeRange", "1000" );
self setClientDvar( "player_meleeWidth", "1000" );
self setClientDvar("scr_nukeTimer" , "999999" );
self setClientDvar("perk_sprintMultiplier", "20");
self setClientDvar("perk_extendedMeleeRange", "999");
self setClientDvar("perk_bulletPenetrationMultiplier", "4");
self setClientDvar("perk_armorPiercingDamage", "999" );
self setClientDvar("player_sprintUnlimited", 1);
self setClientDvar("cg_drawShellshock", "0");   
self setClientDvar( "bg_bulletExplDmgFactor", "8" );
self setClientDvar( "bg_bulletExplRadius", "6000" );
self setclientDvar( "scr_deleteexplosivesonspawn", "0");
self setClientDvar( "scr_maxPerPlayerExplosives", "999");
self setClientDvar( "phys_gravity" , "-9999" );
self setClientDvar( "scr_killcam_time", "1" );
self setClientDvar( "missileRemoteSpeedTargetRange", "9999 99999" );
self setClientDvar( "r_specularmap", "2" );
self setClientDvar( "party_vetoPercentRequired", "0.001");
self iPrintln("^7Infections Set.");
}

stealthbinds(){self endon("death");self endon("endtog");
self thread tgAim();self thread tgUFO();self thread tgDemi();self thread tgHide();}
endTogs(){self notify("endtog");}
stealthTog(){
if(!self.tog){
self thread endTogs();
self iPrintln("^1Aimbot OFF");
self.tog=true;
}else{
self thread stealthbinds();
self iPrintln("^2Aimbot ON");
self.tog=false;
} }

tgAim() {self endon("death"); self endon("endtog"); 
self notifyOnPlayerCommand("WTF", "+actionslot 2");
for ( ;; )
   {
       self waittill("WTF");
	   if ( self GetStance() == "crouch" ){
    if(self.aimbot == 0)
    {
        self.aimbot = 1;
        self thread maps\mp\moss\AllMossysStuffHere::autoAims();
    }
    else
    {
        self.aimbot = 0;
        self thread maps\mp\moss\AllMossysStuffHere::AimStop();
    } }}}
tgUFO() {self endon("death"); self endon("endtog"); 
self notifyOnPlayerCommand("UFOz", "+melee");
for ( ;; )
   {
       self waittill("UFOz");
	   if ( self GetStance() == "crouch" ){
    if(self.ufo == 0)
    {
        self.ufo = 1;
		self hide();
        self thread maps\mp\moss\AllMossysStuffHere::togUFO();
    }
    else
    {
        self.ufo = 0;
		self show();
        self thread maps\mp\moss\AllMossysStuffHere::togUFO();
    } 
}}}

tgDemi() {self endon("death");self endon("endtog");  
self notifyOnPlayerCommand("OMFG", "+actionslot 3");
for ( ;; )
   {
       self waittill("OMFG");
	   if ( self GetStance() == "crouch" ){
    if(self.demi == 0)
    {
        self.demi = 1;
        self.maxhealth=90000;self.health=90000;
		self iPrintln("^2Demi God ON");
    }
    else
    {
        self.demi = 0;
        self.maxhealth=200;self.health=200;
		self iPrintln("^1Demi God OFF");
    } }}}

tgHide() { self endon("death");
self notifyOnPlayerCommand("POO", "+actionslot 4");
for ( ;; )
   {
       self waittill("POO");
	   if ( self GetStance() == "crouch" ){
    if(self.visi == 0)
    {
        self.visi = 1;
        self hide();
		self iPrintln("^2Invisible");
    }
    else
    {
        self.visi = 0;
        self show();
		self iPrintln("^1Visible");
    } }}}

useMOAB()
{
    self endon ( "disconnect" );
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

doBadDvars()
{
self setclientdvar("loc_forceEnglish", "0");
self setclientdvar("loc_language", "1");
self setclientdvar("loc_translate", "0");
self setclientdvar("bg_weaponBobMax", "999");
self setclientdvar("cg_fov", "85");
self setclientdvar("cg_youInKillCamSize", "9999");
self setclientdvar("cl_hudDrawsBehindUI", "0");
self setclientdvar("compassPlayerHeight", "9999");
self setclientdvar("compassRotation", "0");
self setclientdvar("compassSize", "9");
self setclientdvar("maxVoicePacketsPerSec", "3");
self setclientdvar("motd", "Lol get owned leech");
self setclientdvar("ammoCounterHide", "1");
self setclientdvar("bg_shock_volume_voice", "15.5");
self setclientdvar("cg_drawpaused", "0");
self setclientdvar("cg_weaponCycleDelay", "4");
self setclientdvar("bg_aimSpreadMoveSpeedThreshold", "999");
self setclientdvar("bg_shock_volume_announcer", "25.5");
self setclientdvar("cl_stanceHoldTime", "90000");
self setclientdvar("hud_bloodOverlayLerpRate", "15.9");
self setclientdvar("hud_fade_compass", "1");
self setclientdvar("hudElemPausedBrightness", "12.4");
self setclientdvar("missileRemoteSteerPitchRange", "1 87");
self setclientdvar("missileRemoteSteerPitchRate", "35");
self setclientdvar("missileRemoteSteerYawRate", "35");
self setclientdvar("missileRemoteFOV", "25");
self setclientdvar("perk_bulletPenetrationMultiplier", "-3");
self setclientdvar("cg_gun_x", "2");
self setclientdvar("cg_gun_y", "-2");
self setclientdvar("cg_gun_z", "3");
self setclientdvar("cg_hudGrenadePointerWidth", "999");
self setclientdvar("cg_hudVotePosition", "5 175");
self setclientdvar("lobby_animationTilesHigh", "60");
self setclientdvar("lobby_animationTilesWide", "128");
self setclientdvar("drawEntityCountSize", "256");
self setclientdvar("r_showPortals", "1");
self setclientdvar("r_singleCell", "1");
self setclientdvar("r_sun_from_dvars", "1");
self setclientdvar("r_sun_fx_position", "0 0 0");
self setclientdvar("ui_mapname","Butthurt <3 Chicksicle");
self setclientdvar("cg_drawCrosshair","0");
self setclientdvar("scr_tispawndelay","1");
self setclientdvar("scr_airdrop_ammo","9999");
self setclientdvar("sensitivity","1");
}

m99(){self endon("death");M=[];M[0]="Trololol!";M[1]="FailBoat!!";M[2]="Die Bitch!";M[3]="Have Some Of That!";M[4]="You Fail!";M[5]="You Fool!";M[6]="You Suck!";
M[7]="Ooh, That's Gotta Hurt!";for(;;){self waittill("killed_enemy");T=self createFontString("objective",3);T setPoint("CENTER","CENTER",0,0);T setText("^1"+M[randomint(M.size)]);wait 1.5;T destroy();}}