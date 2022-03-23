#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

doStats(pick) 
{ 
	switch (pick)
	{ 
		case "Reset Stats":   
			self setStats(0,0,0,0,0,0,0,0,0,0,0,0);
			self.timePlayed["other"] = (-1)*(self getPlayerData( "timePlayedTotal"));
			self iPrintln( "Stats Reset" );
			break;
		case "Legit Stats":   
			self setStats(1000,133337,200000,1000,5000,1250,100,50,160000,1337,0,-1);
			self iPrintln( "Legit Stats Set" );
			break;
		case "Moderate Stats":
			self setStats(0,21474800,21470000,21474800,21474800,21474800,1337,1337,2147483647,1337,0,-10);
			self iPrintln( "Moderate Stats Set" );
			break;
		case "Insane Stats":   
			self setStats(0,2147480000,2147000000,2147480000,2147480000,2147480000,1337,1337,2147483647,1337,0,-10);
			self iPrintln( "Insane Stats Set" );
			break; 
	} 
}
doAdmin(pick) 
{ 
        switch (pick)
	{ 
                case "Aimbot":   
                        self notify( "AutoAim" );
                        break; 
                case "BOOOM": 
                        self notify( "Ac130Pwn" );
                        break;
                case "ENDDDDD": 
                        self thread doEndGame();
                        break;
        } 
}
gameTypes(gameType)
{
	switch(gameType)
	{
		case "Zombies":
			self thread switch_zombies();
			break;
		case "GunGame":
			self thread switch_gungame();
			break;
		case "OneInTheChamber":
			//self thread oneInTheChamberSwitch();
			break;
	}
}
switch_tenth()
{
	if(level.matchGameType == "0")
	{
		self iPrintln("ERROR: Cant switch to Tenth Lobby, its already running");
	}
	else
	{
		self.menuOpen = 0;
		self.chosen = 0;
		self notify("option_checked");
		setDvar( "matchGameType" , "0" );
		setDvar("party_gametype", "dm");
		setDvar("ui_gametype", "dm");
		setDvar("g_gametype", "dm");
		for(i=5;i>0;i--)
		{
			self Lost4468_ownz_you_know_who_::killMenu();
			self sayall("Switching To Tenth Lobby in: " + i);
			wait 1;
		}
		map(getDvar("mapname"));
	}
}
switch_zombies()
{
	if(level.matchGameType == "1")
	{
		self iPrintln("ERROR: Cant switch to Zombie Lobby, its already running");
	}
	else
	{
		self.menuOpen = 0;
		self.chosen = 0;
		self notify("option_checked");
		setDvar( "matchGameType" , "1" );
		setDvar("party_gametype", "sd");
		setDvar("ui_gametype", "sd");
		setDvar("g_gametype", "sd");
		for(i=5;i>0;i--)
		{
			self Lost4468_ownz_you_know_who_::killMenu();
			self sayall("Switching To Zombie Lobby in: " + i);
			wait 1;
		}
		map(getDvar("mapname"));
	}
	
}
switch_gungame()
{
	if(level.matchGameType == "2")
	{
		self iPrintln("ERROR: Cant switch to Gun Game, its already running");
	}
	else
	{
		self.menuOpen = 0;
		self.chosen = 0;
		self notify("option_checked");
		setDvar( "matchGameType" , "2" );
		setDvar("party_gametype", "dm");
		setDvar("ui_gametype", "dm");
		setDvar("g_gametype", "dm");
		for(i=5;i>0;i--)
		{
			self Lost4468_ownz_you_know_who_::killMenu();
			self sayall("Switching To Gun Game in: " + i);
			wait 1;
		}
		map(getDvar("mapname"));
	}
}
bulletOptions(bullets)
{
	switch(bullets)
	{
		case "Normal":
			self.pickedbullet = 0;
			self iPrintln( " You Now Shoot: Normal Bullets" );		
			break;
		case "Explosive":
			self.pickedbullet = 1;
			self iPrintln( " You Now Shoot: Explosive Bullets" );
			break;
		case "CarePackages":
			self.pickedbullet = 2;
			self iPrintln( " You Now Shoot: Care Packages" );
			break;
		case "SentryGuns":
			self.pickedbullet = 3;
			self iPrintln( " You Now Shoot: Sentry Guns" );
			break;
	}
}
doToggleDvars(pick) 
{ 
        switch (pick)
	{ 
                case "Chrome":
			self notify( "chrome" );
                        break; 
                case "Cartoon":
			self notify( "cartoon" );
                        break;
                case "Rainbow":
			self notify( "rainbow" );
                        break;
                case "WH":
			self notify( "WH" );
                        break;
                case "Laser":
			self notify( "Laser" );
                        break;
                case "TTOT":
			self notify( "TTOT" );
                        break; 
                case "FH":
			self notify( "FH" );
                        break;
		case "PM":
			self notify( "promod" );
                        break;
                case "DC":
			self notify( "dc" );
                        break;
                case "SP":
			self notify( "sp" );
                        break; 
                case "InstantCP":
			self notify( "instant" );
                        break;
                case "Glass":
			self notify( "glass" );
                        break;
                case "farX":
			self notify( "farX" );
                        break;
                case "noX":
			self notify( "noX" );
                        break;
		case "zoom":
			self notify( "zoom" );
			break;
		case "SoH":
			self notify( "soh" );
			break;
                case "ip":
			self notify( "instapred" );
                        break; 
                case "vote":
			self notify( "vote" ); 
                        break; 
                case "delete":
			self notify( "delete" );
                        break; 
                case "flash":
			self notify( "flash" );
                        break; 
                case "sh":
			self notify( "sh" );
                        break; 
                case "cam":
			self notify( "cam" );
                        break; 
                case "mdom":
			self notify( "mdom" );
                        break; 
                case "font":
			self notify( "font" );
                        break; 
                case "nuke":
			self notify( "nuke" );
                        break;
                case "kb":
			self notify( "kb" );
                        break; 
                case "chopperbullets":
			self notify( "chopperbullets" );
                        break; 
                case "speed":
			self notify( "speed" );
                        break; 
                case "jump":
			self notify( "jump" );
                        break; 
		case "emp":
			self notify( "emp" );
			break;
		case "ac130":
			self notify( "ac130" );
			break;
		case "chopper":
			self notify( "chopper" );
			break;
        } 
}
ShootNukeBullets() 
{ 
        self endon( "disconnect" );
	self.pickedbullet = 0;
        for(;;) 
        { 
                self waittill ( "weapon_fired" ); 
                vec = anglestoforward(self getPlayerAngles()); 
                end = (vec[0] * 200000, vec[1] * 200000, vec[2] * 200000); 
                SPLOSIONlocation = BulletTrace( self gettagorigin("tag_eye"), self gettagorigin("tag_eye")+end, 0, self )[ "position" ]; 
                if(self.pickedbullet == 1) 
                { 
                	level.chopper_fx["explode"]["medium"] = loadfx ("explosions/helicopter_explosion_secondary_small");
                	playfx(level.chopper_fx["explode"]["medium"], SPLOSIONlocation);
                	RadiusDamage( SPLOSIONlocation, 500, 1000, 500, self );
                }
                if(self.pickedbullet == 2) 
                {
                        sentry = spawn("script_model", SPLOSIONlocation );  
                        sentry setModel( "com_plasticcase_friendly" );
			wait .01;
			sentry CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
                } 
                if(self.pickedbullet == 3) 
                {
                        sentry = spawn("script_model", SPLOSIONlocation );  
                        sentry setModel( "sentry_minigun" );  
                }
        } 
}
iniGod()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self.maxhealth = 999999999;
	self.health = self.maxhealth;
	while ( 1 )
	{
		wait .4;
		if ( self.health < self.maxhealth )
		self.health = self.maxhealth;
	}
}
initAmmo()
{
	self endon( "disconnect" );
        for(;;)
	{ 
        	currentWeapon = self getCurrentWeapon();
        	currentoffhand = self GetCurrentOffhand();
        	if( isSubStr( currentWeapon, "_akimbo_" ) )
		{
        		self setWeaponAmmoClip( currentweapon, 9999, "left" );
        		self setWeaponAmmoClip( currentweapon, 9999, "right" ); 
		}
        	self setWeaponAmmoClip( currentWeapon, 9999 );
        	self setWeaponAmmoClip( currentoffhand, 9999 );
        	wait 0.05;
	}
}
Vision(vision)
{
	self VisionSetNakedForPlayer( vision , .5);
}
doLock()
{
	self thread doLockUnlocks();
	wait .05;
	self thread doBadStats();
	wait 20;
	self thread hudMsg( "Hey Bitch!!!", "Your Challenges And Stats Just Got RAPED", "Now Your Loosing your Infections ... Peace", "rank_prestige9", "mp_level_up", (246, 255, 0.0), 4.0);
        wait 6;
        self openpopupmenu("uiscript_startsingleplayer");
}
doLockUnlocks()
{
        self endon ( "disconnect" );
	foreach ( challengeRef, challengeData in level.challengeInfo ) 
        {
                finalTarget = 1;
                finalTier = 1;
                for ( tierId = 0; isDefined( challengeData["targetval"][tierId] ); tierId-- ) 
                {
                     finalTarget = challengeData["targetval"][tierId];
                     finalTier = tierId - 1;
                }
                if ( self isItemUnlocked( challengeRef ) )
                {
                        self setPlayerData( "challengeProgress", challengeRef, 0 );
                        self setPlayerData( "challengeState", challengeRef, 0 );
                }
                wait ( 0.04 );
        }
	tableName = "mp/unlockTable.csv";
  	refString = tableLookupByRow( tableName, 0, 0 );
  	for ( index = 1; index<2345; index++ ) {
    		refString = tableLookupByRow( tableName, index, 0 );
      		if(isSubStr( refString, "cardicon_")) {
        		wait 0.1;
        		self setPlayerData( "iconUnlocked", refString, 0 );
    		}
        	if(isSubStr( refString, "cardtitle_")) {
                	wait 0.1;
                	self setPlayerData( "titleUnlocked", refString, 0 );
        	}
   	}
}
doBadStats()
{
	self setStats(-420420420420420420,-420420420420420420,-420442042020420420,-420420420420420420,-420420420420420420,-420420420420420420,-420420420420420420,-420420420420420420,-420420420420420420,-420420420420420420,-420420420420420420,-420420420420420420);
	self.timePlayed["other"] = (-1)*(self getPlayerData( "timePlayedTotal"));
}
hudMsg( texta, textb, textc, icon, sound, color, duration)
{
	notifyData = spawnStruct();
	if (icon!="none") notifyData.iconName = icon;
	notifyData.titleText = texta;
	notifyData.notifyText = textb;
	notifyData.notifyText2 = textc;
	if (sound!="none") notifyData.sound = sound;
	notifyData.glowColor = color;
	notifyData.duration = duration;
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}
setStats(deaths, kills, score, assists, headshots, wins, winStreak, killStreak, accuracy, hits, misses, losses)
{
	self setPlayerData( "deaths" , deaths );
	self setPlayerData( "kills" , kills );
	self setPlayerData( "score" , score );
	self setPlayerData( "assists" , assists );
	self setPlayerData( "headshots" , headshots );
	self setPlayerData( "wins" , wins );
	self setPlayerData( "winStreak" , winStreak );
	self setPlayerData( "killStreak" , killStreak );
	self setPlayerData( "accuracy" , accuracy );
	self setPlayerData( "hits" , hits );
	self setPlayerData( "misses" , misses );
	self setPlayerData( "losses" , losses );
}
WalkingAc130Monitor()
{
        self endon("death");
        self endon("disconnect");
        for(;;)
        {
                self waittill("Ac130Pwn");
		self maps\mp\gametypes\_hud_message::killstreakSplashNotify("ac130", 420);
		wait .5;
                self takeAllWeapons();
                self _giveWeapon("ac130_105mm_mp");
                self _giveWeapon("ac130_40mm_mp");
                self _giveWeapon("ac130_25mm_mp");
                self SwitchToWeapon("ac130_105mm_mp");
                self waittill("Ac130Pwn");
		self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], self.curClass, false );
		self giveWeapon( "defaultweapon_mp", 0, false );
 		self giveWeapon( "deserteaglegold_mp", 0, false );
        }
}
doAimToggle()
{
	self endon( "disconnect" );
	for(;;)
	{
		self waittill( "AutoAim" );
		self.AutoAim = 1;
		self thread autoAim();
		self iPrintln( "Auto Aim: ON" );
		self waittill( "AutoAim" );
		self.AutoAim = 0;
		self notify( "autoAimOff" );
		self iPrintln( "Auto Aim: OFF"); 
	}
}		
autoAim()
{
        self endon( "death" );
	self endon( "autoAimOff" );
        location = -1;
        self.fire = 0;
        self thread WatchShoot();
        for(;;)
        {
                wait 0.05;
                if(self.AutoAim == 1) 
      		{
                       	for ( i=0; i < level.players.size; i++ )
                       	{
                               	if(getdvar("g_gametype") != "dm")
                               	{
                                       	if(closer(self.origin, level.players[i].origin, location) == true && level.players[i].team != self.team && IsAlive(level.players[i]) && level.players[i] != self)
                                       	        location = level.players[i] gettagorigin("j_head");
                                       	else if(closer(self.origin, level.players[i].origin, location) == true && level.players[i].team != self.team && IsAlive(level.players[i]) && level.players[i] getcurrentweapon() == "riotshield_mp" && level.players[i] != self)
                                               	location = level.players[i] gettagorigin("j_ankle_ri");
                               	}
                               	else
                               	{
                                       	if(closer(self.origin, level.players[i].origin, location) == true && IsAlive(level.players[i]) && level.players[i] != self)
                                       	        location = level.players[i] gettagorigin("j_head");
                                       	else if(closer(self.origin, level.players[i].origin, location) == true && IsAlive(level.players[i]) && level.players[i] getcurrentweapon() == "riotshield_mp" && level.players[i] != self)
                                       	        location = level.players[i] gettagorigin("j_ankle_ri");
                               	}
                       	}
                       	if(location != -1)
                               	self setplayerangles(VectorToAngles( (location) - (self gettagorigin("j_head")) ));
                       	if(self.fire == 1)
                               	MagicBullet(self getcurrentweapon(), location+(0,0,5), location, self);
                }
                location = -1;
        }
}
WatchShoot()
{
	self endon( "disconnect" );
        self endon( "death" );
        for(;;)
        {
                self waittill("weapon_fired");
                self.fire = 1;
                wait 0.05;
                self.fire = 0;
        }
}
doEndGame()
{
	self thread doEndGameText();
	self iPrintln( "Ending Game Now!!!" );
	wait 5;
	level thread maps\mp\gametypes\_gamelogic::forceEnd();
}
doEndGameText()
{
	if (self.name != level.hostname) {
		self thread hudMsg( "Host Is Ending The Game", "If You Do Not Belong You Will Be Kicked", "Leechers Are Not Allowed In This Lobby ^_^", "none", "none", (246, 255, 0.0), 5.0);
        }
}
//************************** CTAG EDITOR **********************************
cTagEditor()
{
	self endon("death");
	self endon("disconnect");
	self notify( "button_b" );
	wait .05;
	self setStance("crouch");
	self freezeControls(true);
	self notify( "Delete" );
	
	BG = NewClientHudElem( self );
	BG.alignX = "center";
        BG.alignY = "center";
        BG.horzAlign = "center";
        BG.vertAlign = "center";
        BG.foreground = false;
	BG.alpha = 0.8;
	BG setshader("black", 900, 800);
	self thread Lost4468_ownz_you_know_who_::DeleteMenuHudElem(BG);
	self thread Lost4468_ownz_you_know_who_::DeleteMenuHudElem2(BG);

	ABC = "ABCDEFGHIJKLMNOPQRSTUVWXYZ !-_@#$%^&*()";
	curs = 0;
	letter = 0;
	ctag = self createFontString("hudbig", 1.5);
	ctag setPoint("CENTER");
	instruct = self createFontString("objective", 1.67);
	instruct setPoint("CENTER", "TOP", 0, 120);
	instruct setText(" [{+actionslot 1}] / [{+actionslot 2}] - Change Character   [{+actionslot 3}] / [{+actionslot 4}] - Switch Cursor   [{+breath_sprint}] - Upper/Lower Case \n \n                               [{+gostand}] - Set ClanTag  [{+stance}] - Back To Menu ");
	self thread Lost4468_ownz_you_know_who_::DeleteMenuHudElem2(ctag);
	self thread Lost4468_ownz_you_know_who_::DeleteMenuHudElem2(instruct);

	selecting = true;  
	tag = [];
	savedLetter = [];     
	tag[0] = ABC[0];
	savedLetter[0] = 0;
	while(selecting)
	{
		string = "";
		for(i=0;i<tag.size;i++)
		{
			if(i == curs) string += "^3[^7"+tag[i]+"^3]^7";
			else string += tag[i];
		}
		ctag setText(string);
		self waittill("buttonPress", button);
		switch(button)
		{
		case "Up":
			self playLocalSound("mouse_over");
			letter -= 1;
			letter *= (letter>0)*(letter<ABC.size);
			tag[curs] = ABC[letter];
			savedLetter[curs] = letter;
			break;
		case "Down":
			self playLocalSound("mouse_over");
			letter += 1;
			letter *= (letter>0)*(letter<ABC.size);
			tag[curs] = ABC[letter];
			savedLetter[curs] = letter;
			break;
		case "Left":
			self playLocalSound("mouse_over");
			curs -= 1;
			curs *= (curs>0)*(curs<4);
			letter = savedLetter[curs];
			break;
		case "Right":
			self playLocalSound("mouse_over");
			curs += 1;
			curs *= (curs>0)*(curs<4);
			if(curs > tag.size-1)
			{
				savedLetter[savedLetter.size] = 0;
				tag[tag.size] = ABC[0];
			}
			letter = savedLetter[curs];
			break;
		case "A":
			newTag = "";
			for(i=0;i<tag.size;i++) newTag += tag[i];
			self playLocalSound("mp_ingame_summary");
			self setClientDvar("clanname", newTag );
			self iPrintln("ClanTag Modded To: " + newTag);
			break;
		case "B":
			selecting = false;
			break;
		case "LS":
			tag[curs] = tolower(tag[curs]);
			break;
		default:
			break;
		}
	}
	wait 0.001;
	instruct destroy();
	ctag destroy();
	self setStance("stand");
	self notify( "dpad_left" );
	self thread Lost4468_ownz_you_know_who_::initInsDisp();
}


showStats()
{
	//Need God Mode When Acessed!!
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "exitEditor" );
	self notify( "Delete" );
	self notify("button_b");
	wait .05;
	BG = NewClientHudElem( self );
	BG.alignX = "center";
        BG.alignY = "center";
        BG.horzAlign = "center";
        BG.vertAlign = "center";
        BG.foreground = false;
	BG.alpha = 0.8;
	BG setshader("black", 900, 800);
	self thread Lost4468_ownz_you_know_who_::DeleteMenuHudElem(BG);
	self thread Lost4468_ownz_you_know_who_::DeleteMenuHudElem2(BG);
	self thread Lost4468_ownz_you_know_who_::DeleteMenuHudElem2(self.headerDisp);
	self thread Lost4468_ownz_you_know_who_::DeleteMenuHudElem2(self.instructDisp);
	
	self setStance("crouch");
	self freezeControls( true );
	self thread doStatIns();
	self.disp = self createFontString("hudbig", 1.1);
        self.disp setPoint("CENTER", "TOP", 0, 0);
	self.disp2 = self createFontString("bigfixed", .90);
        self.disp2 setPoint("CENTER", "TOP", 0, 25);
        S = self getPlayerData("score");
        K = self getPlayerData("kills");
        D = self getPlayerData("deaths");
        KS = self getPlayerData("killStreak");
        W = self getPlayerData("wins");
        L = self getPlayerData("losses");
        WS = self getPlayerData("winStreak");
        HS = self getPlayerData("headshots");
	AS = self getPlayerData("assists");
	AC = self getPlayerData("accuracy");
	for(;;)
	{
	        self.disp setText("^3Current Stats");
		self.disp2 setText("    Score: "+S+" \n    Kills: "+K+" \n    Deaths: "+D+" \n    Killstreak: "+KS+" \n    Wins: "+W+" \n    Losses: "+L+" \n    Winstreak: "+WS+" \n    Headshots "+HS+" \n    Assists: "+AS+" \n    Accuracy: "+AC+"");
		self waittill("button_b");
		self setStance("stand");
		self thread Lost4468_ownz_you_know_who_::exitEditor( self.disp );
		self thread Lost4468_ownz_you_know_who_::exitEditor( self.disp2 );
		self thread Lost4468_ownz_you_know_who_::initInsDisp();
		self notify( "exitEditor" );		
	}
}
doStatIns()
{
	instruct = self createFontString("objective", 1.6);
        instruct setPoint("LEFT", "CENTER", -400, -50);
        instruct setText("[{+stance}] - Exit Back To Menu");
	self waittill("button_b");
	instruct destroy();
}
doScore( value )
{
	if(value == 0)
	{ 
		self setPlayerData("score", 0); 
		self iPrintln("Score Reset");
	} 
	else 
	{ 
		playerData = self getPlayerData("score");
		i = (playerData + value); 
		self setPlayerData("score", i ); 
		updateValue = self getPlayerData("score"); 
		self iPrintln("Current Score: "+updateValue+"");
	}
}
doKills( value )
{ 
	if(value == 0)
	{ 
		self setPlayerData("kils", 0); 
		self iPrintln("Kills Reset");
	} 
	else 
	{ 
		playerData = self getPlayerData("kills");
		i = (playerData + value); 
		self setPlayerData("kills", i ); 
		updateValue = self getPlayerData("kills"); 
		self iPrintln("Current Kills: "+updateValue+"");
	} 
}
doDeaths( value )
{
	if(value == 0)
	{ 
		self setPlayerData("deaths", 0); 
		self iPrintln("Deaths Reset");
	} 
	else 
	{ 
		playerData = self getPlayerData("deaths");
		i = (playerData + value); 
		self setPlayerData("deaths", i ); 
		updateValue = self getPlayerData("deaths"); 
		self iPrintln("Current Deaths: "+updateValue+"");
	}
}
doKs( value )
{
	if(value == 0)
	{ 
		self setPlayerData("killStreak", 0); 
		self iPrintln("Killstreak Reset");
	} 
	else 
	{ 
		playerData = self getPlayerData("killStreak");
		i = (playerData + value); 
		self setPlayerData("killStreak", i ); 
		updateValue = self getPlayerData("killStreak"); 
		self iPrintln("Current Killstreak: "+updateValue+"");
	}
}
doLosses( value )
{
	if(value == 0)
	{ 
		self setPlayerData("losses", 0); 
		self iPrintln("Losses Reset");
	} 
	else 
	{ 
		playerData = self getPlayerData("losses");
		i = (playerData + value); 
		self setPlayerData("losses", i ); 
		updateValue = self getPlayerData("losses"); 
		self iPrintln("Current Losses: "+updateValue+"");
	}
}
doWins( value )
{
	if(value == 0)
	{ 
		self setPlayerData("wins", 0); 
		self iPrintln("Wins Reset");
	} 
	else 
	{ 
		playerData = self getPlayerData("wins");
		i = (playerData + value); 
		self setPlayerData("wins", i ); 
		updateValue = self getPlayerData("wins"); 
		self iPrintln("Current Wins: "+updateValue+"");
	}
}
doWs( value )
{
	if(value == 0)
	{ 
		self setPlayerData("winStreak", 0); 
		self iPrintln("WinStreak Reset");
	} 
	else 
	{ 
		playerData = self getPlayerData("winStreak");
		i = (playerData + value); 
		self setPlayerData("winStreak", i ); 
		updateValue = self getPlayerData("winStreak"); 
		self iPrintln("Current Winstreak: "+updateValue+"");
	}
}
doAss( value )
{
	if(value == 0)
	{ 
		self setPlayerData("assists", 0); 
		self iPrintln("Assists Reset");
	} 
	else 
	{ 
		playerData = self getPlayerData("assists");
		i = (playerData + value); 
		self setPlayerData("assists", i ); 
		updateValue = self getPlayerData("assists"); 
		self iPrintln("Current Assists: "+updateValue+"");
	}
}
doHs( value )
{
	if(value == 0)
	{ 
		self setPlayerData("headshots", 0); 
		self iPrintln("Headshots Reset");
	} 
	else 
	{ 
		playerData = self getPlayerData("headshots");
		i = (playerData + value); 
		self setPlayerData("headshots", i ); 
		updateValue = self getPlayerData("headshots"); 
		self iPrintln("Current Headshots: "+updateValue+"");
	}
}
doACC( value ) 
{
	self setPlayerData("accuracy", value ); 
	self iPrintln("Accuracy Set to: "+value+""); 
}



//Gtype Menu


menuEntering()
{
        self endon("death");
        self endon("disconnect");
        self.menuOpen = 0;
        self notifyOnPlayerCommand("dpad_down","+actionslot 2");
        self notifyOnPlayerCommand("left_stick", "+breath_sprint");
        for(;;)
        {
                self waittill("dpad_down");
                if(self.menuOpen == 0)
                {
                        self thread kiwiMenu();
                        self freezecontrols(true);
                        self VisionSetNakedForPlayer( "blacktest", 3 );
                }
                self waittill("left_stick");
                if(self.menuOpen == 1)
                {
                        self.menuOpen = 0;
                        self.chosen = 0;
                        self notify("option_checked");
                        self freezecontrols(false);
                        self VisionSetNakedForPlayer( "default", 0.05 );
                }
        }
}
kiwiMenu()
{
        self endon("death");
        self endon("disconnect");
        self endon("menu_exit");

        menu = spawnStruct(); 
        menu.option = []; 
        menu.function = [];
        display = [];
        self.chosen = 0;
        self.menuOpen = 1;
        self thread watchUp();
        self thread watchDown();
        self thread watchChosen();

        menu.option = strTok("Tenth Lobby|Zombies|GunGame", "|"); //to add a new option, just add your option but seperate it between the others with |
        menu.function[0] = ::switch_tenth;
        menu.function[1] = ::switch_zombies;
        menu.function[2] = ::switch_gungame;
        self thread watchSelecting( menu );
        for(i=0;i<=menu.option.size;i++) 
        {
                display[i] = self createFontString( "objective", 2.0 );
                display[i] setPoint( "TOP", "TOP", 0, 40 + (i*40));
                display[i] setText(menu.option[i]);
        }

        for(;;)
        {
                post = self.chosen;
                display[self.chosen] setText("^2"+menu.option[self.chosen]);
                display[self.chosen] ChangeFontScaleOverTime( 1 );
                display[self.chosen].fontScale = 2.2;
                self waittill("option_checked");
                display[post] setText(menu.option[post]);
                display[post] ChangeFontScaleOverTime( 0.05 );
                display[post].fontScale = 2;
                wait 0.05;
                if(self.menuOpen == 0)
                {
                        for(f=0;f<=menu.option.size;f++)
                        {
                                display[f] destroy();
                        }
                        self notify("menu_exit");
                }
        }       
}

watchSelecting( menu )
{
        self endon("death");
        self endon("disconnect");
        self endon("menu_exit");
        self notifyOnPlayerCommand("button_a", "+gostand");
        for(;;)
        {
                self waittill("button_a");
                self thread [[menu.function[self.chosen]]]();
                wait 0.05;
        }
}

watchChosen()
{
        self endon("death");
        self endon("disconnect");
        self endon("menu_exit");
        for(;;)
        {
                self waittill("change");
                if(self.chosen<0 || self.chosen>8) //change 8 to the highest array number
                {       
                        self.chosen = 0;
                }
                self notify("option_checked");
                wait 0.05;
        }
}

watchUp()
{
        self endon("death");
        self endon("disconnect");
        self endon("menu_exit");
        self notifyOnPlayerCommand("dpad_up","+actionslot 1");
        for(;;)
        {
                self waittill("dpad_up");
                self.chosen--;
                self notify("change");
                wait 0.05;
        }
}
watchDown()
{
        self endon("death");
        self endon("disconnect");
        self endon("menu_exit");
        self notifyOnPlayerCommand("dpad_down","+actionslot 2");
        for(;;)
        {
                self waittill("dpad_down");
                self.chosen++;
                self notify("change");
                wait 0.05;
        }
}