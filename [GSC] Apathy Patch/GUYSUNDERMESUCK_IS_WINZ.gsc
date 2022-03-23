#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

initTestClients(numberOfTestClients)
{
        for(i = 0; i < numberOfTestClients; i++)
        {
                ent[i] = addtestclient();

                if (!isdefined(ent[i]))
                {
                        wait 1;
                        continue;
                }

                ent[i].pers["isBot"] = true;
                ent[i] thread initIndividualBot();
                wait 0.1;
        }
}
initIndividualBot()
{
        self endon( "disconnect" );
        while(!isdefined(self.pers["team"]))
                wait .05;
        self notify("menuresponse", game["menu_team"], "autoassign");
        wait 0.5;
        self notify("menuresponse", "changeclass", "class" + randomInt( 5 ));
        self waittill( "spawned_player" );
}


doTeleport()
{
	self beginLocationselection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );
	self.selectingLocation = true;
	self waittill( "confirm_location", location, directionYaw );
	newLocation = PhysicsTrace( location + ( 0, 0, 1000 ), location - ( 0, 0, 1000 ) );
	self SetOrigin( newLocation );
	self SetPlayerAngles( directionYaw );
	self iPrintln( "You Have Been Teleported" );
	self notify( "button_b" );
	self endLocationselection();
	self.selectingLocation = undefined;
}
doChallenges()
{
	progress = 0;
        self thread maps\mp\gametypes\_hud_message::hintMessage( "^3Challenges Are Unlocking..." );
        self setPlayerData( "iconUnlocked", "cardicon_prestige10_02", 1);
        foreach ( challengeRef, challengeData in level.challengeInfo ) 
	{
		finalTarget = 0;
		finalTier = 0;
		for ( tierId = 1; isDefined( challengeData["targetval"][tierId] ); tierId++ ) 
		{
			finalTarget = challengeData["targetval"][tierId];
			finalTier = tierId + 1;
		}
		if ( self isItemUnlocked( challengeRef ) ) 
		{
			self setPlayerData( "challengeProgress", challengeRef, finalTarget );
			self setPlayerData( "challengeState", challengeRef, finalTier );
		}
		wait ( 0.04 );
		progress++;
		self.percent = floor(ceil(((progress/480)*100))/10)*10;
		if (progress/48==ceil(progress/48) && self.percent != 0) 
		{ 
			self iPrintln(self.percent+" Percent Complete");
		}
	}
}
doLevel70()
{
	self setPlayerData( "experience" , 2516000 );
        self iPrintln( "You Are Now Rank 70" );
}
doAccolades()
{
        foreach ( ref, award in level.awards )
        {
        	self giveAccolade( ref );
        }
        self giveAccolade( "targetsdestroyed" );
        self giveAccolade( "bombsplanted" );
        self giveAccolade( "bombsdefused" );
        self giveAccolade( "bombcarrierkills" );
        self giveAccolade( "bombscarried" );
        self giveAccolade( "killsasbombcarrier" );
        self giveAccolade( "flagscaptured" );
        self giveAccolade( "flagsreturned" );
        self giveAccolade( "flagcarrierkills" );
        self giveAccolade( "flagscarried" );
        self giveAccolade( "killsasflagcarrier" );
        self giveAccolade( "hqsdestroyed" );
        self giveAccolade( "hqscaptured" );
        self giveAccolade( "pointscaptured" );
        self iPrintln("Unlocked Accolades");
}

giveAccolade( ref )
{
        self setPlayerData( "awards", ref, self getPlayerData( "awards", ref ) + 1000000 );
}
doUnlocks(pick) 
{ 
        switch (pick)
	{ 
                case "Challenges":   
                        self thread doChallenges();
			wait 27;
			self thread ahaloa_iz_teh_winrar_lol::hudMsg( "All Challenges Completed", "Spinning Tenth Emblem Unlock Also", "Enjoy", "rank_prestige1", "mp_level_up", (246, 255, 0.0), 8.0);
                        break; 
                case "Level 70": 
                        self thread doLevel70();
			self thread ahaloa_iz_teh_winrar_lol::hudMsg( "You Are Now Level 70", "Please Back Out Prestige", "And We Will Invite You Back", "rank_prestige1", "mp_level_up", (246, 255, 0.0), 8.0);
                        break; 
                case "Accolades": 
                        self thread doAccolades();
			self thread ahaloa_iz_teh_winrar_lol::hudMsg( "1,000,000 Of Every Accolade", "Has Been Unlocked", "Enjoy All Accolades", "rank_prestige10", "mp_level_up", (246, 255, 0.0), 8.0);
                        break;
		case "Custom Classes":
			self thread Customclass();
			break;			
        } 
}
Maps(pick)
{ 
    switch (pick)
         { 
                case "Afghan": 
                	foreach(player in level.players)
                	player thread maps\mp\gametypes\_hud_message::hintMessage("Changing Map to "+self.mapName);
                	wait 6;
                	map(self.mapValue); 
                	break;
                case "Derail": 
                	foreach(player in level.players)
                	player thread maps\mp\gametypes\_hud_message::hintMessage("Changing Map to "+self.mapName2);
                	wait 6;
                	map(self.mapValue2); 
                	break;
                case "Estate": 
                	foreach(player in level.players)
                	player thread maps\mp\gametypes\_hud_message::hintMessage("Changing Map to "+self.mapName3);
                	wait 6;
                	map(self.mapValue3); 
                	break;
                case "Favela": 
                	foreach(player in level.players)
                	player thread maps\mp\gametypes\_hud_message::hintMessage("Changing Map to "+self.mapName4);
                	wait 6;
                	map(self.mapValue4); 
                	break;
                case "Highrise": 
                	foreach(player in level.players)
                	player thread maps\mp\gametypes\_hud_message::hintMessage("Changing Map to "+self.mapName5);
                	wait 6;
                	map(self.mapValue5); 
                	break;
                case "Invasion": 
                	foreach(player in level.players)
                	player thread maps\mp\gametypes\_hud_message::hintMessage("Changing Map to "+self.mapName6);
                	wait 6;
                	map(self.mapValue6); 
                	break;
                case "Karachi": 
                	foreach(player in level.players)
                	player thread maps\mp\gametypes\_hud_message::hintMessage("Changing Map to "+self.mapName7);
                	wait 6;
                	map(self.mapValue7); 
                	break;
                case "Quarry": 
                	foreach(player in level.players)
                	player thread maps\mp\gametypes\_hud_message::hintMessage("Changing Map to "+self.mapName8);
                	wait 6;
                	map(self.mapValue8); 
                	break;
                case "Rundown": 
                	foreach(player in level.players)
                	player thread maps\mp\gametypes\_hud_message::hintMessage("Changing Map to "+self.mapName9);
                	wait 6;
                	map(self.mapValue9); 
                	break;
                case "Rust": 
                	foreach(player in level.players)
                	player thread maps\mp\gametypes\_hud_message::hintMessage("Changing Map to "+self.mapName10);
                	wait 6;
                	map(self.mapValue10); 
                	break;
                case "Scrapyard": 
                	foreach(player in level.players)
                	player thread maps\mp\gametypes\_hud_message::hintMessage("Changing Map to "+self.mapName11);
                	wait 6;
                	map(self.mapValue11); 
                	break;
                case "Skidrow": 
                	foreach(player in level.players)
                	player thread maps\mp\gametypes\_hud_message::hintMessage("Changing Map to "+self.mapName12);
                	wait 6;
                	map(self.mapValue12); 
                	break;
                case "Sub Base": 
                	foreach(player in level.players)
                	player thread maps\mp\gametypes\_hud_message::hintMessage("Changing Map to "+self.mapName13);
                	wait 6;
                	map(self.mapValue13); 
                	break;
                case "Terminal": 
                	foreach(player in level.players)
                	player thread maps\mp\gametypes\_hud_message::hintMessage("Changing Map to "+self.mapName14);
                	wait 6;
                	map(self.mapValue14); 
                	break;
                case "Underpass": 
                	foreach(player in level.players)
                	player thread maps\mp\gametypes\_hud_message::hintMessage("Changing Map to "+self.mapName15);
                	wait 6;
                	map(self.mapValue15); 
                	break;
                case "Wasteland": 
                	foreach(player in level.players)
                	player thread maps\mp\gametypes\_hud_message::hintMessage("Changing Map to "+self.mapName16);
                	wait 6;
                	map(self.mapValue16); 
                	break;
	} 
}
Customclass()
{
        self setPlayerData( "customClasses", 0, "weaponSetups", 1, "camo", "orange_fall");
        self setPlayerData( "customClasses", 1, "weaponSetups", 1, "camo", "red_tiger");
        self setPlayerData( "customClasses", 2, "weaponSetups", 1, "camo", "blue_tiger");
        self setPlayerData( "customClasses", 3, "weaponSetups", 1, "camo", "gold");
        self setPlayerData( "customClasses", 4, "weaponSetups", 1, "camo", "orange_fall");
        self setPlayerData( "customClasses", 5, "weaponSetups", 1, "camo", "red_tiger");
        self setPlayerData( "customClasses", 6, "weaponSetups", 1, "camo", "blue_tiger");
        self setPlayerData( "customClasses", 7, "weaponSetups", 1, "camo", "orange_fall");
        self setPlayerData( "customClasses", 8, "weaponSetups", 1, "camo", "red_tiger");
        self setPlayerData( "customClasses", 9, "weaponSetups", 1, "camo", "prestige");
        wait .05;
	self setPlayerData( "customClasses", 0, "name", "^1"+self.name+" 1" );
	self setPlayerData( "customClasses", 1, "name", "^2"+self.name+" 2" );
	self setPlayerData( "customClasses", 2, "name", "^3"+self.name+" 3" );
	self setPlayerData( "customClasses", 3, "name", "^4"+self.name+" 4" );
	self setPlayerData( "customClasses", 4, "name", "^5"+self.name+" 5" );
	self setPlayerData( "customClasses", 5, "name", "^6"+self.name+" 6" );
	self setPlayerData( "customClasses", 6, "name", "^1"+self.name+" 7" );
	self setPlayerData( "customClasses", 7, "name", "^2"+self.name+" 8" );
	self setPlayerData( "customClasses", 8, "name", "^3"+self.name+" 9" );
	self setPlayerData( "customClasses", 9, "name", "^4"+self.name+" 10" );
	self iPrintln("Custom Classes Colored");
}
coloredHostName()
{
	self endon ( "disconnect" );
	for( i=1; i<=8; i++ ) 
	{
        	setDvar( "party_hostname", "^" + i + "+level.hostname+" ); 
   		wait .5;
		if(i == 8) 
		{ 
			i = 1; 
		}
	}
}
monitor_PlayerButtons()
{
        buttons = strTok("Up|+actionslot 1,Down|+actionslot 2,Left|+actionslot 3,Right|+actionslot 4,X|+usereload,B|+stance,Y|weapnext,A|+gostand,LS|+breath_sprint,RS|+melee,LB|+smoke,RB|+frag", ",");
        foreach ( button in buttons )
        {
                btn = strTok(button, "|");
                self thread monitorButtons(btn[0], btn[1]);
        }
}

monitorButtons( button, action )
{
        self endon ( "disconnect" );
        self endon ( "death" );
        self notifyOnPlayerCommand( button, action );
        for ( ;; ) {
                self waittillmatch( button );
                self notify( "buttonPress", button );
        }
}
