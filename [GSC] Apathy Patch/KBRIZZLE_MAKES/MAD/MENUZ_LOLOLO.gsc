#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;


ChangeAppearance(Type,MyTeam)
{
	ModelType=[];
	ModelType[0]="GHILLIE";
	ModelType[1]="SNIPER";
	ModelType[2]="LMG";
	ModelType[3]="ASSAULT";
	ModelType[4]="SHOTGUN";
	ModelType[5]="SMG";
	ModelType[6]="RIOT";
	if(Type==7)
	{
		MyTeam=randomint(2);Type=randomint(7);
	}
	team=get_enemy_team(self.team);if(MyTeam)team=self.team;
	self detachAll();
	[[game[team+"_model"][ModelType[Type]]]]();
}
JZombiez()
{
	self endon("disconnect");
	self endon("death");
        if(!level.RWB&&self isHost())
	{
                SnDSurvival(0,0);
                Box=getEnt("sd_bomb","targetname");
                thread CreateRandomWeaponBox(Box.origin+(0,0,15),game["attackers"]);
                thread CreateRandomPerkBox(Box.origin+(0,50,15),game["attackers"]);
                level thread JZombiesScore();
                level.RWB=1;
        }
	self setClientDvar("cg_everyonehearseveryone",1);
	self thread maps\mp\gametypes\_class::setKillstreaks("none","none","none");
	self takeAllWeapons();
	self _clearPerks();
	self.ExpAmmo=0;
	if(self.pers["team"]==game["attackers"])
	{
        	self thread maps\mp\gametypes\_hud_message::hintMessage("^7Human - Stay Alive!");
        	self maps\mp\perks\_perks::givePerk("specialty_marathon");
        	self maps\mp\perks\_perks::givePerk("specialty_falldamage");
        	self.maxhealth=100;
        	self.health=self.maxhealth;
 	        Wep="beretta_fmj_mp";
 	        self.moveSpeedScaler=1.1;       
 	        self setMoveSpeedScale(self.moveSpeedScaler);
 	        wait 0.2;
 	        self _giveWeapon(Wep);
 	        self switchToWeapon(Wep);
 	        wait 0.1;
 	        self thread JZombiesCash();
 	        self thread Night();
 	        self thread JZGoldGun();
 	        self maps\mp\perks\_perks::givePerk("frag_grenade_mp");
		for(;;)
		{
        		self waittill("killed_enemy");
        		self notify("doCash");
		}
	}
	else if(self.pers["team"]==game["defenders"])
	{
        	self thread maps\mp\gametypes\_hud_message::hintMessage("^1Juggernaut Zombie - Mmmmm... Brains!");
        	self maps\mp\perks\_perks::givePerk("specialty_marathon");
        	self maps\mp\perks\_perks::givePerk("specialty_quieter");
        	self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
        	self maps\mp\perks\_perks::givePerk("specialty_falldamage");
        	ChangeAppearance(6,1);
        	self.maxhealth=50*(game["roundsWon"][game["attackers"]]+1);
        	self.health=self.maxhealth;
                if(self.health>50)
		{
        		self iPrintlnBold("^1Health Increased : "+(((self.maxhealth/50)-1)*100)+" Percent");
        	}
		Wep="airdrop_marker_mp";
		self.moveSpeedScaler=1; 
		self setMoveSpeedScale(self.moveSpeedScaler);
		wait 0.2;
		self _giveWeapon(Wep);
		self switchToWeapon(Wep);
		wait 0.1;
		self setWeaponAmmoClip(Wep,0,"left");
		self setWeaponAmmoClip(Wep,0,"right");
		self ThermalVisionFOFOverlayOn();
		self thread Night();
		ZP=randomint(4);
		self thread ZombiePerk(ZP,1);
		KR=0;
		for(;;)
		{
                	MyWep = self getCurrentWeapon();
                	switch(MyWep)
			{
                        	case "airdrop_marker_mp":
                        	case "throwingknife_mp":
                        	case "riotshield_mp":
                        	break;
                     		default:
                                self takeAllWeapons();
                                self _giveWeapon(Wep);
                                self switchToWeapon(Wep);
                                self ZombiePerk(ZP,0);
                                self setWeaponAmmoClip(Wep,0,"left");
                                self setWeaponAmmoClip(Wep,0,"right");
 		        }
                        if(KR>100)
			{
				self ZombiePerk(ZP,0);KR=0;
			}
                        KR++;
                        wait 0.05;
		}
	}
}
SnDSurvival(S,W)
{
	doRestart=0;if(getDvar("scr_sd_timelimit")!="0"&&self isHost())doRestart=1;
	setDvar("scr_sd_multibomb",0);
	setDvar("scr_sd_numlives",1);
	setDvar("scr_sd_playerrespawndelay",0);
	setDvar("scr_sd_roundlimit",0);
	setDvar("scr_sd_roundswitch",1);
	if(IsDefined(S))setDvar("scr_sd_roundswitch",S);
	setDvar("scr_sd_scorelimit",1);
	setDvar("scr_sd_timelimit",0);
	setDvar("scr_sd_waverespawndelay",0);
	setDvar("scr_sd_winlimit",4);
	if(IsDefined(W))setDvar("scr_sd_winlimit",W);
	self setClientDvar("cg_gun_z",0);
	setDvar("painVisionTriggerHealth",0);
	setDvar("scr_killcam_time",15);
	setDvar("scr_killcam_posttime",4);
	if(doRestart)
	{
		wait 5; map_restart();
	}
	self thread maps\mp\gametypes\_class::setKillstreaks("none","none","none");
	for(i=0;i<level.bombZones.size;i++)level.bombZones[i] maps\mp\gametypes\_gameobjects::disableObject();
	level.sdBomb maps\mp\gametypes\_gameobjects::disableObject();
	setObjectiveHintText(game["attackers"],"");setObjectiveHintText(game["defenders"],"");
}
CreateRandomWeaponBox(O,T)
{
	B=spawn("script_model",O);
	B setModel("com_plasticcase_friendly");
	B Solid();
	B CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
	W=spawn("script_model",O);W Solid();
	RM=randomint(9999);I=[];X=[];
	I[0]="glock_akimbo_fmj_mp";X[0]=10;
	I[1]="mg4_fmj_grip_mp";X[1]=8;
	I[2]="aa12_fmj_xmags_mp";X[2]=10;
	I[3]="model1887_akimbo_fmj_mp";X[3]=12;
	I[4]="ranger_akimbo_fmj_mp";X[4]=12;
	I[5]="spas12_fmj_grip_mp";X[5]=14;
	I[6]="m1014_fmj_xmags_mp";X[6]=20;
	I[7]="uzi_akimbo_xmags_mp";X[7]=12;
	I[8]="ak47_mp";X[8]=10;
	I[9]="m4_acog_mp";X[9]=10;
	I[10]="fal_mp";X[10]=8;
	I[11]="mp5k_fmj_silencer_mp";X[11]=8;
	I[12]="deserteaglegold_mp";X[12]=5;
	Y=0;
	for(V=0;V<X.size;V++)
	{
		Y+=X[V];
	}
        for(;;)
	{
                foreach(P in level.players)
		{
                	wait 0.01;
                        if(IsDefined(T)&&P.pers["team"]!=T)continue;
                        R=distance(O,P.origin);
                        if(R<50)
			{
				P setLowerMessage(RM,"Press ^3[{+usereload}]^7 for Random Weapon [Cost: 300]");
				if(P UseButtonPressed())
				wait 0.1;
				if(P UseButtonPressed())
				{
					P clearLowerMessage(RM,1);
					if(P.bounty>299)
					{
						P.bounty-=400;
						P notify("doCash");
                                                RW="";J=0;G=randomint(Y);for(V=0;V<X.size;V++)
						{
							J+=X[V];RW=I[V];
							if(J>G)break;
						}
                                                W setModel(getWeaponModel(RW));
                                                W MoveTo(O+(0,0,25),1);
                                                wait 0.2;
                                                if(P GetWeaponsListPrimaries().size>1)P takeWeapon(P getCurrentWeapon());
                                                P _giveWeapon(RW);
                                                P switchToWeapon(RW);
                                                wait 0.6;
                                                W MoveTo(O,1);
                                                wait 0.2;
                                                W setModel("");
					}
					else
					{
                                               	P iPrintlnBold("^1You DO NOT Have Enough Cash!");
                                                wait 0.05;
                                                }
                                        }
				}
				else
				{
                                       	P clearLowerMessage(RM,1);
                                }
		}
	}
}
CreateRandomPerkBox(O,T)
{
	B = spawn("script_model",O);
	B setModel("com_plasticcase_friendly");
	B Solid();
	B CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
	RM=randomint(9999);I=[];X=[];
	I[0]="specialty_fastreload";X[0]="^4Sleight of Hand";
	I[1]="specialty_bulletdamage";X[1]="^1Stopping Power";
	I[2]="specialty_coldblooded";X[3]="^1Cold Blooded";
	I[3]="specialty_grenadepulldeath";X[4]="^2Martydom";
	I[4]="ammo";X[2]="^4Extra Ammo";
        for(;;)
	{
                foreach(P in level.players)
		{
                        wait 0.01;
                        if(IsDefined(T)&&P.pers["team"]!=T)continue;
                        R=distance(O,P.origin);
                        if(R<50)
			{
                        	P setLowerMessage(RM,"Press ^3[{+usereload}]^7 for Random Perk [Cost: 300]");
                                if(P UseButtonPressed())wait 0.1;
                                if(P UseButtonPressed())
				{
                                        P clearLowerMessage(RM,1);
                                        if(P.bounty>299)
					{
						P.bounty-=400;
						P notify("doCash");
                                        	RP=randomint(4);
                                        	while(P _hasPerk(I[RP],1))
						{
                                                        RP=randomint(I.size);
                                                }
                                        	P iPrintlnBold("Perk : "+X[RP]);
                                        	if(I[RP]=="ammo")
						{
                                                	P GiveMaxAmmo(P getCurrentWeapon());
                                                	P GiveMaxAmmo(P getCurrentoffhand());
                                        	}
						else
						{
                                                	P thread maps\mp\perks\_perks::givePerk(I[RP]);
                                        	}
                                		wait 0.2;
                                	}
					else
					{
                                        	P iPrintlnBold("^1You DO NOT Have Enough Cash!");
                                		wait 0.05;
                                	}
				}
			}
			else
			{
                                P clearLowerMessage(RM,1);
                        }
                }
        }
}
ZombiePerk(N,P)
{
        if(N==0)
	{
                self.moveSpeedScaler=1.3;
                self setMoveSpeedScale(self.moveSpeedScaler);
                if(P){wait 2;self iPrintlnBold("^1Ability : Super Speed");}
        }
	else if(N==1)
	{
                Wep="riotshield_mp";
                self _giveWeapon(Wep);
                self switchToWeapon(Wep);
                if(P){wait 2;self iPrintlnBold("^1Ability : Riot Shield");}
        }
	else
	{
                self maps\mp\perks\_perks::givePerk("throwingknife_mp");
                if(P){wait 2;self iPrintlnBold("^1Ability : Throwing Knife");}
        }
}
JZGoldGun()
{
	self endon("disconnect");
	self endon("death");
        for(;;)
	{
        	W=self getCurrentWeapon();
        	if(W=="deserteaglegold_mp")
		{
        		self.ExpAmmo=1;
        	}
		else
		{
        		self.ExpAmmo=0;
        	}
        	wait 0.1;
	}	
}
JZombiesScore()
{
	for(;;)
	{
        	if(game["roundsWon"][game["defenders"]]>0)
		{
                	level.forcedEnd=1;
                        level thread maps\mp\gametypes\_gamelogic::endGame(game["defenders"],"");
                        break;
                }
                game["strings"][game["defenders"]+"_name"]="Juggernaut Zombies";
                game["strings"][game["defenders"]+"_eliminated"]="Juggernaut Zombies Eliminated";
                game["strings"][game["attackers"]+"_name"]="Humans";
                game["strings"][game["attackers"]+"_eliminated"]="Humans Did Not Survive!";
                level deletePlacedEntity("misc_turret");
        	wait 1;
        }
}
Night()
{
        V=0;
	for(;;)
	{
                self closepopupMenu();
                self VisionSetNakedForPlayer("cobra_sunset3",0.01);
        	wait 0.01;
        	V++;
        }
}
JZombiesCash()
{
	self endon("disconnect");
	self endon("death");
	self.bounty=100+(self.kills*200);
        if(self isHost())self.bounty+=9999;
        if(self.bounty>500)self iPrintlnBold("^2"+(self.bounty-500)+" BONUS CASH!");
        for(;;)
	{
                        self.cash destroy();
                        self.cash=NewClientHudElem(self);
                        self.cash.alignX="right";
                        self.cash.alignY="center";
                        self.cash.horzAlign="right";
                        self.cash.vertAlign="center";
                        self.cash.foreground=1;
                        self.cash.fontScale=1;
                        self.cash.font="hudbig";
                        self.cash.alpha=1;
                        self.cash.color=(1,1,1);
                        self.cash setText("Cash : "+self.bounty);
                        self waittill("doCash");
                        self.bounty+=100;
                }
}

initGuns()
{
        self.inverse = false; //Inverted gungame?
        self.upgscore = 100; //Score necessary for upgrade. Leave at 100 for 2 kill upgrade. Do 50 for 1 kill, 150 for 3 kill.
        self.finalkills = 5; //Kills to win after getting final weapon
        self.gunList = [];
        // Gun Name, Laser Sight, Akimbo
        self.gunList[0] = createGun("throwingknife_mp", 9, false, false);
        self.gunList[1] = createGun("usp_fmj_mp", 9, false, false);
        self.gunList[2] = createGun("beretta_fmj_mp", 9, false, false);
        self.gunList[3] = createGun("coltanaconda_fmj_mp", 9, false, false);
        self.gunList[4] = createGun("deserteaglegold_mp", 9, false, false);
        self.gunList[5] = createGun("pp2000_mp", 9, true, false);
        self.gunList[6] = createGun("tmp_mp", 9, true, false);
        self.gunList[7] = createGun("beretta393_akimbo_mp", 9, true, true);
        self.gunList[8] = createGun("glock_mp", 9, true, false);
        self.gunList[9] = createGun("ranger_akimbo_mp", 9, true, true);
        self.gunList[10] = createGun("model1887_akimbo_mp", 9, true, true);
        self.gunList[11] = createGun("m1014_grip_reflex_mp", 9, true, false);
        self.gunList[12] = createGun("striker_grip_reflex_mp", 9, true, false);
        self.gunList[13] = createGun("aa12_eotech_grip_mp", 9, true, false);
        self.gunList[14] = createGun("spas12_grip_mp", 9, true, false);
        self.gunList[15] = createGun("uzi_reflex_rof_mp", 9, true, false);
        self.gunList[16] = createGun("mp5k_reflex_rof_mp", 9, true, false);
        self.gunList[17] = createGun("ump45_reflex_rof_mp", 9, true, false);
        self.gunList[18] = createGun("p90_eotech_rof_mp", 9, true, false);
        self.gunList[19] = createGun("fal_acog_mp", 9, true, false);
        self.gunList[20] = createGun("scar_reflex_mp", 9, true, false);
        self.gunList[21] = createGun("m16_reflex_mp", 9, true, false);
        self.gunList[22] = createGun("aug_grip_mp", 9, true, false);
        self.gunList[23] = createGun("masada_reflex_mp", 9, true, false);
        self.gunList[24] = createGun("rpd_grip_mp", 9, true, false);
        self.gunList[25] = createGun("mg4_grip_mp", 9, true, false);
        self.gunList[26] = createGun("m240_grip_mp", 9, true, false);
        self.gunList[27] = createGun("wa2000_fmj_mp", 9, false, false);
        self.gunList[28] = createGun("m21_fmj_mp", 9, false, false);
        self.gunList[29] = createGun("barrett_fmj_mp", 9, false, false);
        self.gunList[30] = createGun("cheytac_fmj_mp", 9, false, false);
        self.gunList[31] = createGun("m79_mp", 9, false, false);
        self.gunList[32] = createGun("at4_mp", 9, true, false);
        self.gunList[33] = createGun("rpg_mp", 9, false, false);
        self.gunList[34] = createGun("javelin_mp", 9, true, false);
}

createGun(gunName, camo, laserSight, akimbo)
{
        gun = spawnstruct();
        gun.name = gunName;
        gun.camo = camo;
        gun.laser = laserSight;
        gun.akimbo = akimbo;
        return gun;
}

doBinds() //Put persistent threads that are started once here
{
        self.firstRun = true;
        self thread initGuns();
        self.nv = false;
        self thread killCrosshairs();
        self thread doScore();
        self thread doGun();
        setDvar("scr_dm_scorelimit", ((self.gunList.size - 1) * self.upgscore) + (self.finalkills * 50));
        setDvar("scr_dm_timelimit", 0);
        setDvar("ui_gametype", "ffa");
        setDvar("scr_game_hardpoints", 0);
        setDvar("scr_game_killstreakdelay", 9999999);
}

doDvars() //Put threads that are called with every respawn
{
        setDvar("g_speed", 220);
        setDvar("bg_fallDamageMaxHeight", 1);
        setDvar("bg_fallDamageMinHeight", 99999);
        self setClientDvar("player_meleerange", 0);
        self _clearPerks();
        self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
        self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
        self maps\mp\perks\_perks::givePerk("specialty_bulletpenetration");
        self maps\mp\perks\_perks::givePerk("specialty_exposeenemy");
        self maps\mp\perks\_perks::givePerk("specialty_extendedmags");
        self maps\mp\perks\_perks::givePerk("specialty_fastreload");
        self maps\mp\perks\_perks::givePerk("specialty_fastsnipe");
        self maps\mp\perks\_perks::givePerk("specialty_marathon");
        self maps\mp\perks\_perks::givePerk("specialty_quieter");
                if(self.nv) self VisionSetNakedForPlayer("default_night_mp", 1);
        else self VisionSetNakedForPlayer(getDvar("mapname"), 2);
        self thread doNV();
        if(self.firstRun){
                if(self.inverse){
                        self thread maps\mp\gametypes\_hud_message::hintMessage("^2Inverse Gun Game");
                        self thread maps\mp\gametypes\_hud_message::hintMessage("^2Kill Enemies to Downgrade Your Gun");
                }else{
                        self thread maps\mp\gametypes\_hud_message::hintMessage("^2Gun Game");
                        self thread maps\mp\gametypes\_hud_message::hintMessage("^2Kill Enemies to Upgrade Your Gun");
                }
                self thread maps\mp\gametypes\_hud_message::hintMessage("^2Press [{+actionslot 1}] to Toggle Night Vision");
                //DO NOT REMOVE THE FOLLOWING LINE
                self thread maps\mp\gametypes\_hud_message::hintMessage("^2For more great mods:");
                self thread maps\mp\gametypes\_hud_message::hintMessage("^2Donate at skixtech.com/donate!");
                //DO NOT REMOVE THAT ^
                self.firstRun = false;
        }
}

doGun()
{
        self endon("disconnect");
        if(self.inverse) self.curgun = self.gunList.size - 1;
        else self.curgun = 0;
        curscore = 0;
        done = false;
        while(true){
                if(self.inverse && self.curgun <= 0) done = true;
                if(!self.inverse && self.curgun >= (self.gunList.size - 1)) done = true;
                if(!done){
                        if(self.inverse && (self.score - curscore >= self.upgscore)){
                                self.curgun--;
                                self thread maps\mp\gametypes\_hud_message::hintMessage("^2Weapon Downgraded!");
                                curscore = self.score;
                        }else if((self.score - curscore >= self.upgscore)){
                                self.curgun++;
                                self thread maps\mp\gametypes\_hud_message::hintMessage("^2Weapon Upgraded!");
                                curscore = self.score;
                        }
                }
                while(self getCurrentWeapon() != self.gunList[self.curgun].name){
                        if(self.gunList[self.curgun].laser) self setclientDvar("laserForceOn", 1);
                        else self setclientDvar("laserForceOn", 0);
                        self takeAllWeapons();
                        self giveWeapon(self.gunList[self.curgun].name, self.gunList[self.curgun].camo, self.gunList[self.curgun].akimbo);
                        self switchToWeapon(self.gunList[self.curgun].name);
                        wait .2;
                }
                self giveMaxAmmo(self.gunList[self.curgun].name);
                wait .2;
        }
}

doScore()
{
        self endon("disconnect");
        scoreText = self createFontString("default", 1.5);
        scoreText setPoint("TOPRIGHT", "TOPRIGHT", -5, 0);
        while(true)
        {
                scoreText setText("^3 Level " + self.curgun);
                wait .2;
        }
}

doNV() //Night Vision
{
        self endon("disconnect");
        self endon("death");
        self notifyOnPlayerCommand("dpad_up", "+actionslot 1");
        while(true){
                self waittill("dpad_up");
                self playSound("claymore_activated");
                if(!self.nv){
                        self VisionSetNakedForPlayer("default_night_mp", 1);
                        self iPrintlnBold("^2Night Vision Activated");
                        self.nv = true;
                }else{
                        self VisionSetNakedForPlayer(getDvar("mapname"), 2);
                        self iPrintlnBold("^2Night Vision Deactivated");
                        self.nv = false;
                }
        }
}

killCrosshairs() //Get rid of those f***ing useless hax
{
        self endon("disconnect");

        while(true){
                setDvar("cg_drawcrosshair", 0);
                self setClientDvar("cg_scoreboardPingText", 1);
                self setClientDvar("com_maxfps", 0);
                self setClientDvar("cg_drawFPS", 1);
                wait 1;
        }
}