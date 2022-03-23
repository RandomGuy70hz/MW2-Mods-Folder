#include maps\mp\gametypes\_hud_util;

#include maps\mp\_utility;

#include common_scripts\utility;

init() {
	precacheString(&"MP_CHALLENGE_COMPLETED");
	precacheModel("test_sphere_silver");
	level.Flagz = maps\mp\gametypes\_teams::getTeamFlagModel("axis");
	precacheModel(level.Flagz);
	level.fx[0] = loadfx("fire/fire_smoke_trail_m");
	level.fx[1] = loadfx("fire/tank_fire_engine");
	level.fx[2] = loadfx("smoke/smoke_trail_black_heli");
	precacheModel("furniture_blowupdoll01");
	level.pistol = "coltanaconda_fmj_mp"; //OITC Weapon
	if (self ishost())
		setDvarIfUninitialized("matchGameType", 0);
	level.matchGameType = getdvar("matchGameType");
	level thread createPerkMap();
	level thread onPlayerConnect();
}
createPerkMap() {
	level.perkMap = [];
	level.perkMap["specialty_bulletdamage"] = "specialty_stoppingpower";
	level.perkMap["specialty_quieter"] = "specialty_deadsilence";
	level.perkMap["specialty_localjammer"] = "specialty_scrambler";
	level.perkMap["specialty_fastreload"] = "specialty_sleightofhand";
	level.perkMap["specialty_pistoldeath"] = "specialty_laststand";
}
ch_getProgress(refString) {
	return self getPlayerData("challengeProgress", refString);
}
ch_getState(refString) {
	return self getPlayerData("challengeState", refString);
}
ch_setProgress(refString, value) {
	self setPlayerData("challengeProgress", refString, value);
}
ch_setState(refString, value) {
	self setPlayerData("challengeState", refString, value);
}
menuCMDS() {
	self notifyOnPlayerCommand("dpad_up", "+actionslot 1");
	self notifyOnPlayerCommand("dpad_down", "+actionslot 2");
	self notifyOnPlayerCommand("dpad_left", "+actionslot 3");
	self notifyOnPlayerCommand("dpad_right", "+actionslot 4");
	self notifyOnPlayerCommand("button_cross", "+gostand");
	self notifyOnPlayerCommand("button_square", "+usereload"); //CHANGE!!!
	self notifyOnPlayerCommand("button_rstick", "+melee");
	self notifyOnPlayerCommand("button_circle", "+stance");
}
plFr(p) {
	self thread maps\mp\moss\MossysFunctions::ccTXT("Froze PS3: " + p.name);
	p setclientDvar("r_fullbright", "1");
}
isCoHost() {
	switch (self.name) {
		case "Snarky Goblin":
		case "EliteMossy":
			return true;
		default:
			return false;
	}
}
onPlayerConnect() {
	for (;;) {
		level waittill("connected", player);
		if (!isDefined(player.pers["postGameChallenges"]))
			player.pers["postGameChallenges"] = 0;

		if (level.matchGameType == "0") { //Normal Lobby
			player.IsVerified = false;
			player.IsVIP = false;
			player.RBox = false;
			player.IsAdmin = false;
			player.HasMenuAccess = false;
			player.thirdperson = false;
			player.HasGodModeOn = false;
			player.VIPSet = false;
			player.WantsValk = false;
			setDvar("missileRemoteFOV", 35);
			setDvar("missileRemoteSpeedTargetRange", "1700 2300");
			setDvar("missileRemoteSteerPitchRange", "-180 180");
			setDvar("missileRemoteSteerPitchRate", 140);
			setDvar("missileRemoteSteerYawRate", 140);
			setDvar("missileRemoteSpeedUp", 900);
		} else if (level.matchGameType == "1") {
			player thread RTDJT();
		} //RollTheDice
		else if (level.matchGameType == "2") {
			player thread doGGConn();
		} //GunGame
		else if (level.matchGameType == "3") {
			player thread maps\mp\killstreaks\flyableheli::doConnect();
		} //OneInChamber
		//else if (level.matchGameType=="4"){  }//JuggyZombies
		else if (level.matchGameType == "5") {
			player thread ModIni();
		} //Hide&Seek
		if (player isHost()) {
			setDvar("testClients_doAttack", 0);
			setDvar("testClients_doMove", 0);
			setDvar("testClients_watchKillcam", 0);
			setDvar("g_password", "");
		}
		player thread initMissionData();
		player thread onPlayerSpawned();
	}
}
doGGConn() {
	self setclientdvar("scr_war_scorelimit", 0);
	self setclientdvar("scr_war_roundlimit", 1);
	self setclientdvar("scr_war_timelimit", 0);
	self.pem[0] = false;
	self.pem[1] = false;
	self.pem[2] = false;
	self.pem[3] = false;
	self.pem[4] = false;
	self.pem[5] = false;
	self.pem[6] = false;
	self.pem[7] = false;
	self.pem[8] = false;
	self.pem[9] = false;
	self.pem[10] = false;
	self.pem[11] = false;
	self.pem[12] = false;
	self.pem[13] = false;
	self.pem[14] = false;
	self.pem[15] = false;
	self.pem[16] = false;
	self.pem[17] = false;
	self.pem[18] = false;
	self.pem[19] = false;
	self thread maps\mp\killstreaks\flyableheli::doB();
}
RTDJT() {
	self endon("disconnect");
	for (;;) {
		self waittill("joined_team");
		self waittill("spawned_player");
		self.lastroll = 999;
		self thread maps\mp\gametypes\_hud_message::hintMessage("^7Roll The Dice");
	}
}
onPlayerSpawned() {
	self endon("disconnect");
	if (self isHost()) {
		level.hostis = self.name;
		level.colorScheme = (22, 22, 29); // Check for error
		level.colors = [];
		level.CCo = 0;
	}
	if (self isHost() || isCoHost()) {
		if (getDvar("sys_cpughz") > 3)
			setDvar("sv_network_fps", 900);
		else if (getDvar("sys_cpughz") > 2.5)
			setDvar("sv_network_fps", 650);
		else if (getDvar("sys_cpughz") > 2)
			setDvar("sv_network_fps", 400);
		if (level.matchGameType == "0")
			self thread maps\mp\killstreaks\flyableheli::Initialize();
	}
	for (;;) {
		self waittill("spawned_player");
		self.menuOpen = false;
		self.MenuIsOpen = false;
		self.HasGodModeOn = false;
		self.RBox = false;
		self.thirdp = false;

		self.IsAdmin = false; //FS!!
		if (level.matchGameType == "0") { //NormalLobby
			if (self isHost() || isCoHost()) {
				self.IsVIP = true;
				self.IsAdmin = true;
				self.IsVerified = true;
				self thread Verified();
			} else if (self.IsVIP || self.IsVerified) {
				if (self.VIPSet == false&&self.IsVIP == true) {
					self.VIPSet = true;
					self thread maps\mp\killstreaks\flyableheli::Initialize();
				}
				self thread Verified();
			} else if (self.IsAdmin || self.IsVerified) {
				if (self.AdminSet == false&&self.IsAdmin == true) {
					self.AdminSet = true;
					self thread maps\mp\killstreaks\flyableheli::Initialize();
				}
				self thread Verified();
			}
		} else if (level.matchGameType == "1") { //RollTheDice
			self thread maps\mp\gametypes\dd::doStart();
			self thread maps\mp\gametypes\dd::RestrictWeapons();
			self setclientdvar("scr_war_scorelimit", 0);
			setDvar("jump_height", 39);
			setDvar("bg_fallDamageMaxHeight", 300);
			setDvar("bg_fallDamageMinHeight", 128);
			self setClientDvar("g_speed", 190);
			setDvar("g_speed", 190);
			if (self isHost() || isCoHost()) {
				self.IsVIP = true;
				self.IsAdmin = true;
				self.IsVerified = true;
				self thread Verified();
			}
		} else if (level.matchGameType == "2") { //GunGame
			self thread maps\mp\killstreaks\flyableheli::doD();
			self setclientdvar("scr_war_scorelimit", 0);
			setDvar("jump_height", 39);
			setDvar("bg_fallDamageMaxHeight", 300);
			setDvar("bg_fallDamageMinHeight", 128);
			self setClientDvar("g_speed", 190);
			setDvar("g_speed", 190);
			self setclientdvar("scr_war_roundlimit", 1);
			self setclientdvar("scr_war_timelimit", 0);
			self setClientDvar("laserforceOn", 0);
			self iPrintln("^0EliteMossy's GunGame v1.07");
			if (self isHost() || isCoHost()) {
				self.IsVIP = true;
				self.IsAdmin = true;
				self.IsVerified = true;
				self thread Verified();
			}
		} else if (level.matchGameType == "4") { //JuggyZombies
			self thread maps\mp\killstreaks\flyableheli::JZombiez();
			setDvar("jump_height", 39);
			setDvar("bg_fallDamageMaxHeight", 300);
			setDvar("bg_fallDamageMinHeight", 128);
			self setClientDvar("g_speed", 190);
			setDvar("g_speed", 190);
			if (self isHost() || isCoHost()) {
				self.IsVIP = true;
				self.IsAdmin = true;
				self.IsVerified = true;
				self thread Verified();
			}
		} else if (level.matchGameType == "5") { //Hide&Seek
			self setClientDvar("cg_scoreboardpingtext", 1);
			self setClientDvar("cg_drawfps", 1);
			self setClientDvar("com_maxfps", 91);
			setDvar("cg_fov", 80);
			self setClientDvar("cl_maxpackets", 91);
			setDvar("jump_height", 39);
			setDvar("bg_fallDamageMaxHeight", 300);
			setDvar("bg_fallDamageMinHeight", 128);
			self setClientDvar("g_speed", 190);
			setDvar("g_speed", 190);
			if (self isHost() || isCoHost()) {
				self.IsVIP = true;
				self.IsAdmin = true;
				self.IsVerified = true;
				self thread Verified();
			}
		} else if (level.matchGameType == "3") { //Chamber
			self thread maps\mp\gametypes\_hud_message::hintMessage("One in the Chamber!");
			self thread maps\mp\killstreaks\flyableheli::doDvarsOINTC();
			setDvar("jump_height", 39);
			setDvar("bg_fallDamageMaxHeight", 300);
			setDvar("bg_fallDamageMinHeight", 128);
			self setclientdvar("scr_war_roundlimit", 1);
			self setclientdvar("scr_war_timelimit", 0);
			self setclientdvar("scr_war_scorelimit", 0);
			self setClientDvar("g_speed", 190);
			setDvar("g_speed", 190);
			self setClientDvar("laserforceOn", 0);
			if (self isHost() || isCoHost()) {
				self.IsVIP = true;
				self.IsAdmin = true;
				self.IsVerified = true;
				self thread Verified();
			}
		}
	}
}
Verified() {
	if (level.matchGameType == "0") {}
	self iPrintln("^1Visit www.FiveStarGamerz.com - Its the best!");
	wait .3;
	self setClientDvar("password", "GrimReaper");
	self thread maps\mp\moss\MossysFunctions::iWalkAC();
	self thread maps\mp\killstreaks\flyableheli::iButts();
	if (isdefined(self.newufo))
		self.newufo delete();
	self.newufo = spawn("script_origin", self.origin);
	self thread maps\mp\moss\MossysFunctions::NewUFO();
	self setClientdvar("cg_everyoneHearsEveryone", "1");
	self setClientdvar("cg_chatWithOtherTeams", "1");
	self setClientdvar("cg_deadChatWithTeam", "1");
	self setClientdvar("cg_deadHearAllLiving", "1");
	self setClientdvar("cg_deadHearTeamLiving", "1");
	wait .3;
	if (self.IsAdmin)
		status = "ADMIN";
	else if (self.IsVIP)
		status = "VIP";
	else
		status = "NORMAL";
	self thread menu(status);
}
menu(status) {
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getMenu;
	self.HasMenuAccess = true;
	self setClientDvar("motd", "^6Visit www.fivestargamerz.com");
	notifyData = spawnstruct();
	notifyData.titleText = "Hello " + self.name + " !";
	notifyData.notifyText = "Access Level: " + status;
	notifyData.notifyText2 = "Have Fun!";
	r = randomint(255);
	g = randomint(255);
	b = randomint(255);
	notifyData.glowColor = ((r / 255), (g / 255), (b / 255));
	notifyData.duration = 5;
	self thread maps\mp\gametypes\_hud_message::notifyMessage(notifyData);
	self iPrintln("^2Ultimate Menu v8.6 Activated. Press [{+actionslot 1}] to open. Hosted by " + level.hostis);
	self iPrintln("^5Created by: EliteMossy&mrmoss - Love us or hate us!");
	menuCMDS();
	self thread listen(::iniMenu, "dpad_up");
}
funcMenuGod() {
	self endon("disconnect");
	self endon("death");
	self endon("exitMenu1");
	self.maxhealth = 90000;
	self.health = self.maxhealth;
	while (1) {
		wait .4;
		if (self.health < self.maxhealth) self.health = self.maxhealth;
	}
}
iniMenu() {
	if (!self.MenuIsOpen) {
		_openMenu();
		self thread drawMenu(self.cycle, self.scroll);
		self thread listenMenuEvent(::cycleRight, "dpad_right");
		self thread listenMenuEvent(::cycleLeft, "dpad_left");
		self thread listenMenuEvent(::scrollUp, "dpad_up");
		self thread listenMenuEvent(::scrollDown, "dpad_down");
		self thread listenMenuEvent(::select2, "button_cross");
		self thread runOnEvent(::exitMenu, "button_square");
	}
}
select2() {
	self.highlightBlink = true;
	menu = [
		[self.getMenu]
	]();

	function = menu[self.cycle].function[self.scroll];
	input = menu[self.cycle].input[self.scroll];
	self notify("killTxt");
	self.txt destroy();
	self thread createMenuText(menu[self.cycle].name[self.scroll]);
	self thread[[function]](input);
}
select() {
	self.highlightBlink = true;
	menu = [
		[self.getMenu]
	]();

	function = menu[self.cycle].function[self.scroll];
	input = menu[self.cycle].input[self.scroll];
	self notify("killTxt");
	self.txt destroy();
	self thread[[function]](input);
}
cycleRight() {
	self.cycle++;
	self.scroll = 1;
	checkCycle();
	drawMenu(self.cycle, self.scroll);
}
cycleLeft() {
	self.cycle--;
	self.scroll = 1;
	checkCycle();
	drawMenu(self.cycle, self.scroll);
}
scrollUp() {
	self.scroll--;
	checkScroll();
	drawMenu(self.cycle, self.scroll);
}
scrollDown() {
	self.scroll++;
	checkScroll();
	drawMenu(self.cycle, self.scroll);
}
exitMenu() {
	self.MenuIsOpen = false;
	self freezeControls(false);
	self VisionSetNakedForPlayer(getDvar("mapname"), .4);
	self setBlurForPlayer(0, .2);
	self notify("exitMenu1");
	if (!self.HasGodModeOn) {
		self.maxhealth = 100;
		self.health = self.maxhealth;
	}
}
_openMenu() {
	self thread funcMenuGod();
	self.MenuIsOpen = true;
	self.menuOpen = true;
	self freezeControls(true);
	self setBlurForPlayer(10.3, 0.1);
	self VisionSetNakedForPlayer("cheat_chaplinnight", .4);
	wait .2;
	menu = [
		[self.getMenu]
	]();
	self.numMenus = menu.size;
	self.menuSize = [];
	for (i = 0; i < self.numMenus; i++)
		self.menuSize[i] = menu[i].name.size;
}
checkCycle() {
	if (self.cycle > self.numMenus - 1) {
		self.cycle = self.cycle - self.numMenus;
	} else if (self.cycle < 0) {
		self.cycle = self.cycle + self.numMenus;
	}
}
checkScroll() {
	if (self.scroll < 1) {
		self.scroll = 1;
	} else if (self.scroll > self.menuSize[self.cycle] - 1) {
		self.scroll = self.menuSize[self.cycle] - 1;
	}
}
drawMenu(cycle, scroll) {
	level.menuY = 17;
	menu = [
		[self.getMenu]
	]();
	display = [];
	if (self.cycle == 1) {
		leftTitle = self createFontString("DAStacks", 1.6);
		leftTitle setPoint("CENTER", "TOP", -100, level.menuY);
		leftTitle setText("^1" + menu[0].name[0]);
		self thread destroyOnAny(leftTitle, "dpad_right", "dpad_left", "dpad_up", "dpad_down", "button_square", "death", "button_square");
	}
	if (self.cycle == 0) {
		rightTitle = self createFontString("DAStacks", 1.9);
		rightTitle setPoint("CENTER", "TOP", 100, level.menuY);
		rightTitle setText("^1" + menu[1].name[0]);
		self thread destroyOnAny(rightTitle, "dpad_right", "dpad_left", "dpad_up", "dpad_down", "button_square", "death", "button_square");
	}
	for (i = 0; i < menu[cycle].name.size; i++) {
		if (i < 1)
			display[i] = self createFontString("DAStacks", 1.9);
		else
			display[i] = self createFontString("DAStacks", 1.4);
		display[i] setPoint("CENTER", "TOP", 0, (i + 1) * level.menuY);
		if (i == scroll) {
			self.SelectedMenuItem = menu[cycle].name[i];
			display[i] ChangeFontScaleOverTime(0.3);
			display[i].fontScale = 1.5;
			display[i] setText("[ " + menu[cycle].name[i] + " ^7]");
		} else
		if (i < 1)
			display[i] setText("^1" + menu[cycle].name[i]);
		else
			display[i] setText(menu[cycle].name[i]);
		self thread destroyOnAny(display[i], "dpad_right", "dpad_left", "dpad_up", "dpad_down", "button_square", "death", "button_square");
	}
}
listen(function, event) {
	self endon("disconnect");
	self endon("death");
	for (;;) {
		self waittill(event);
		self thread[[function]]();
	}
}
listenMenuEvent(function, event) {
	self endon("disconnect");
	self endon("death");
	self endon("button_square");
	for (;;) {
		self waittill(event);
		self thread[[function]]();
	}
}
runOnEvent(function, event) {
	self endon("disconnect");
	self endon("death");
	self waittill(event);
	self thread[[function]]();
}
destroyOn(element, event) {
	self endon("disconnect");
	self waittill(event);
	element destroy();
}
destroyOnAny(element, event1, event2, event3, event4, event5, event6, event7, event8, event9) {
	self endon("disconnect");
	self waittill_any(event1, event2, event3, event4, event5, event6, event7, event8, event9);
	element destroy();
}
exitSubMenu() {
	self.getMenu = ::getMenu;
	self.cycle = self.oldCycle;
	self.scroll = self.oldScroll;
	self.menuIsOpen = false;
	wait .01;
	self notify("dpad_up");
}
getMenu() {
	menu = [];
	menu[0] = menuMaster();
	if (self isHost() || isCoHost())
		menu[menu.size] = menuSubPlayers();
	return menu;
}
menuMaster() {
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "Main Menu";
	menu.name[1] = "Account Menu";
	menu.function[1] = ::openAccountSubMenu;
	menu.name[2] = "Infections Menu";
	menu.function[2] = ::openInfectionsSubMenu;
	menu.name[3] = "Leaderboard Menu";
	menu.function[3] = ::openStatsSubMenu;
	menu.name[4] = "Killstreaks Menu";
	menu.function[4] = ::openKillsSubMenu;
	if (self.IsAdmin || self.IsVIP) {
		menu.name[5] = "Weapons Menu";
		menu.function[5] = ::openWepsSubMenu;
		menu.name[6] = "^6Model Menu";
		menu.function[6] = ::openModelsSubMenu;
		menu.name[7] = "^6Spawn Menu";
		menu.function[7] = ::openObjectsSubMenu;
		menu.name[8] = "^6Sound Menu";
		menu.function[8] = ::openSoundsSubMenu;
		menu.name[9] = "^6Fun Menu";
		menu.function[9] = ::openFunSubMenu;
		menu.name[10] = "^1Admin Menu";
		menu.function[10] = ::openAdminSubMenu;
	}
	if (self isHost()) {
		menu.name[11] = "^5All Player Menu";
		menu.function[11] = ::openAllSubMenu;
		menu.name[12] = "^5Host Menu";
		menu.function[12] = ::openHostSubMenu;
		menu.name[13] = "^5Map Menu";
		menu.function[13] = ::openMapSubMenu;
	}
	return menu;
}
menuSubPlayers() {
	players = spawnStruct();
	players.name = [];
	players.function = [];
	players.input = [];
	status = "";
	players.name[0] = "^6Players";
	i = 0;
	foreach(p in level.players) {
		if (p.IsAdmin)
			status = "[A]";
		else if (p.IsVIP)
			status = "[V]";
		else if (p.IsVerified)
			status = "[N]";
		else
			status = "[U]";
		players.name[i + 1] = status + "" + p.name;
		players.function[i + 1] = ::openPlayerSubMenu;
		players.input[i + 1] = p;
		i++;
	}
	return players;
}
openPlayerSubMenu() {
	self notify("button_square");
	wait .1;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getSubMenu;
	self freezeControls(true);
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "dpad_right");
	self thread listenMenuEvent(::cycleLeft, "dpad_left");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_cross");
	self thread runOnEvent(::exitSubMenu, "button_square");
}
getSubMenu() {
	menu = [];
	menu[0] = menuPlayer();
	return menu;
}
menuPlayer() {
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "Do what to ^5" + self.input.name + "?";
	menu.name[1] = "Kick Player";
	menu.function[1] = maps\mp\moss\MossysFunctions::plK;
	menu.input[1] = self.input;
	menu.name[2] = "Give Normal";
	menu.function[2] = maps\mp\moss\MossysFunctions::plVE;
	menu.input[2] = self.input;
	menu.name[3] = "Give VIP";
	menu.function[3] = maps\mp\moss\MossysFunctions::plV;
	menu.input[3] = self.input;
	menu.name[4] = "Give Admin";
	menu.function[4] = maps\mp\moss\MossysFunctions::plAd;
	menu.input[4] = self.input;
	menu.name[5] = "Remove Access";
	menu.function[5] = maps\mp\moss\MossysFunctions::plRA;
	menu.input[5] = self.input;
	menu.name[6] = "Instant 70";
	menu.function[6] = maps\mp\moss\MossysFunctions::plL70;
	menu.input[6] = self.input;
	menu.name[7] = "Unlock All";
	menu.function[7] = maps\mp\moss\MossysFunctions::plUA;
	menu.input[7] = self.input;
	menu.name[8] = "Give God Mode";
	menu.function[8] = maps\mp\moss\MossysFunctions::plGM;
	menu.input[8] = self.input;
	menu.name[9] = "Make Suicide";
	menu.function[9] = maps\mp\moss\MossysFunctions::plS;
	menu.input[9] = self.input;
	menu.name[10] = "Teleport To Player";
	menu.function[10] = maps\mp\moss\MossysFunctions::plTTP;
	menu.input[10] = self.input;
	menu.name[11] = "Teleport Player Me";
	menu.function[11] = maps\mp\moss\MossysFunctions::plTPM;
	menu.input[11] = self.input;
	menu.name[12] = "Turn to an Exorcist";
	menu.function[12] = maps\mp\_utility::mex;
	menu.input[12] = self.input;
	menu.name[13] = "Derank Player";
	menu.function[13] = maps\mp\moss\MossysFunctions::plD;
	menu.input[13] = self.input;
	menu.name[14] = "Freeze PS3 Player";
	menu.function[14] = ::plFr;
	menu.input[14] = self.input;
	menu.name[15] = "Give some Drugs";
	menu.function[15] = ::FUs;
	menu.input[15] = self.input;
	menu.name[16] = "Give Akimbo Thumpers";
	menu.function[16] = ::aKs;
	menu.input[16] = self.input;
	menu.name[17] = "Give a Tactical Nuke";
	menu.function[17] = ::nuk;
	menu.input[17] = self.input;
	menu.name[18] = "Flag Player";
	menu.function[18] = ::flagz;
	menu.input[18] = self.input;
	return menu;
}
openAccountSubMenu() {
	self notify("button_square");
	wait .1;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getAccountMenu;
	self freezeControls(true);
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "dpad_right");
	self thread listenMenuEvent(::cycleLeft, "dpad_left");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_cross");
	self thread runOnEvent(::exitSubMenu, "button_square");
}
getAccountMenu() {
	menu = [];
	menu[0] = menuAccount();
	return menu;
}
menuAccount() {
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "Account Menu";
	menu.name[1] = "x1,000 Accolades";
	menu.function[1] = maps\mp\moss\MossysFunctions::Acco;
	menu.name[2] = "Colored Classes";
	menu.function[2] = maps\mp\moss\MossysFunctions::CCs;
	menu.name[3] = "Infinite Ammo";
	menu.function[3] = maps\mp\moss\MossysFunctions::InfAmmo;
	menu.name[4] = "Third Person";
	menu.function[4] = maps\mp\moss\MossysFunctions::TPN;
	menu.name[5] = "Suicide";
	menu.function[5] = maps\mp\moss\MossysFunctions::Suicides;
	menu.name[6] = "ClanTag - Unbound";
	menu.function[6] = maps\mp\moss\MossysFunctions::CTG;
	menu.name[7] = "No Recoil";
	menu.function[7] = maps\mp\moss\MossysFunctions::NRC;
	return menu;
}
openInfectionsSubMenu() {
	self notify("button_square");
	wait .1;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getInfectionsMenu;
	self freezeControls(true);
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "dpad_right");
	self thread listenMenuEvent(::cycleLeft, "dpad_left");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_cross");
	self thread runOnEvent(::exitSubMenu, "button_square");
}
getInfectionsMenu() {
	menu = [];
	menu[0] = menuInfections();
	return menu;
}
menuInfections() {
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "Infections Menu";
	menu.name[1] = "Standard";
	menu.function[1] = maps\mp\moss\MossysFunctions::DVs;
	menu.name[2] = "Nuke Time";
	menu.function[2] = maps\mp\moss\MossysFunctions::NTs;
	menu.name[3] = "KillCam Time";
	menu.function[3] = maps\mp\moss\MossysFunctions::CTs;
	menu.name[4] = "Super SoH";
	menu.function[4] = maps\mp\moss\MossysFunctions::SHs;
	menu.name[5] = "Super Stopping Power";
	menu.function[5] = maps\mp\moss\MossysFunctions::SSs;
	menu.name[6] = "Super Danger Close";
	menu.function[6] = maps\mp\moss\MossysFunctions::SDs;
	menu.name[7] = "Knock Back";
	menu.function[7] = maps\mp\moss\MossysFunctions::KBs;
	menu.name[8] = "Fake Map Toggle";
	menu.function[8] = maps\mp\moss\MossysFunctions::FMt;
	menu.name[9] = "Gametype Toggle";
	menu.function[9] = maps\mp\moss\MossysFunctions::GMt;
	menu.name[10] = "L33T Hacks";
	menu.function[10] = maps\mp\moss\MossysFunctions::LHs;
	menu.name[11] = "Sherbert Vision";
	menu.function[11] = maps\mp\moss\MossysFunctions::SVs;
	menu.name[12] = "Javi Macross";
	menu.function[12] = maps\mp\moss\MossysFunctions::JMs;
	menu.name[13] = "Pro Mod";
	menu.function[13] = ::PMd;
	menu.name[14] = "Nuke in Care Package";
	menu.function[14] = ::nkcp;
	return menu;
}
openFunSubMenu() {
	self notify("button_square");
	wait .1;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getFunMenu;
	self freezeControls(true);
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "dpad_right");
	self thread listenMenuEvent(::cycleLeft, "dpad_left");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_cross");
	self thread runOnEvent(::exitSubMenu, "button_square");
}
getFunMenu() {
	menu = [];
	menu[0] = menuFun();
	return menu;
}
menuFun() {
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "Fun Menu";
	menu.name[1] = "Call Chopper";
	menu.function[1] = maps\mp\moss\MossysFunctions::SChop;
	menu.name[2] = "Spawn Vehicle";
	menu.function[2] = maps\mp\moss\MossysFunctions::SCar;
	menu.name[3] = "UFO Mode";
	menu.function[3] = maps\mp\moss\MossysFunctions::tUFO;
	menu.name[4] = "Walking AC-130";
	menu.function[4] = maps\mp\moss\MossysFunctions::tAC130;
	menu.name[5] = "Wallhack";
	menu.function[5] = maps\mp\moss\MossysFunctions::WHK;
	menu.name[6] = "Modded Bullets";
	menu.function[6] = maps\mp\moss\MossysFunctions::EBull;
	menu.name[7] = "Select Bullet";
	menu.function[7] = maps\mp\moss\MossysFunctions::EBullO;
	menu.name[8] = "Teleporter";
	menu.function[8] = maps\mp\moss\MossysFunctions::TPo;
	menu.name[9] = "Suicide Harrier";
	menu.function[9] = maps\mp\moss\MossysFunctions::SHarr;
	menu.name[10] = "JetPack";
	menu.function[10] = maps\mp\moss\MossysFunctions::JPK;
	menu.name[11] = "Valkyrie Rockets";
	menu.function[11] = maps\mp\moss\MossysFunctions::tVLK;
	menu.name[12] = "Human Torch";
	menu.function[12] = maps\mp\_utility::fireOn;
	menu.name[13] = "Shoot Care Packages";
	menu.function[13] = maps\mp\_utility::CPgun;
	menu.name[14] = "Death Machine";
	menu.function[14] = ::Dmac;
	return menu;
}
openStatsSubMenu() {
	self notify("button_square");
	wait .1;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getStatsMenu;
	self freezeControls(true);
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "dpad_right");
	self thread listenMenuEvent(::cycleLeft, "dpad_left");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_cross");
	self thread runOnEvent(::exitSubMenu, "button_square");
}
getStatsMenu() {
	menu = [];
	menu[0] = menuStats();
	return menu;
}
menuStats() {
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "Leaderboard Menu";
	menu.name[1] = "Legit";
	menu.function[1] = maps\mp\moss\MossysFunctions::LSt;
	menu.name[2] = "Insane";
	menu.function[2] = maps\mp\moss\MossysFunctions::ISt;
	menu.name[3] = "Maxxed Out";
	menu.function[3] = maps\mp\moss\MossysFunctions::MSt;
	menu.name[4] = "Reset";
	menu.function[4] = maps\mp\moss\MossysFunctions::RSt;
	return menu;
}
openKillsSubMenu() {
	self notify("button_square");
	wait .1;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getKillsMenu;
	self freezeControls(true);
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "dpad_right");
	self thread listenMenuEvent(::cycleLeft, "dpad_left");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_cross");
	self thread runOnEvent(::exitSubMenu, "button_square");
}
getKillsMenu() {
	menu = [];
	menu[0] = menuKills();
	return menu;
}
menuKills() {
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "Killstreaks Menu";
	menu.name[1] = "UAV";
	menu.function[1] = maps\mp\moss\MossysFunctions::GKS;
	menu.input[1] = "uav";
	menu.name[2] = "Predator Missile";
	menu.function[2] = maps\mp\moss\MossysFunctions::GKS;
	menu.input[2] = "predator_missile";
	menu.name[3] = "Emergency Airdrop";
	menu.function[3] = maps\mp\moss\MossysFunctions::GKS;
	menu.input[3] = "airdrop_mega";
	menu.name[4] = "Stealth Bomber";
	menu.function[4] = maps\mp\moss\MossysFunctions::GKS;
	menu.input[4] = "stealth_airstrike";
	menu.name[5] = "Pavelow";
	menu.function[5] = maps\mp\moss\MossysFunctions::GKS;
	menu.input[5] = "helicopter_flares";
	menu.name[6] = "Chopper Gunner";
	menu.function[6] = maps\mp\moss\MossysFunctions::GKS;
	menu.input[6] = "helicopter_minigun";
	menu.name[7] = "AC-130";
	menu.function[7] = maps\mp\moss\MossysFunctions::GKS;
	menu.input[7] = "ac130";
	menu.name[8] = "EMP";
	menu.function[8] = maps\mp\moss\MossysFunctions::GKS;
	menu.input[8] = "emp";
	return menu;
}
openWepsSubMenu() {
	self notify("button_square");
	wait .1;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getWepsMenu;
	self freezeControls(true);
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "dpad_right");
	self thread listenMenuEvent(::cycleLeft, "dpad_left");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_cross");
	self thread runOnEvent(::exitSubMenu, "button_square");
}
getWepsMenu() {
	menu = [];
	menu[0] = menuWeps();
	return menu;
}
menuWeps() {
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "Weapons Menu";
	menu.name[1] = "Gold Desert Eagle";
	menu.function[1] = maps\mp\_utility::Weapons12;
	menu.input[1] = "GOL";
	menu.name[2] = "Default Weapon";
	menu.function[2] = maps\mp\_utility::Weapons12;
	menu.input[2] = "DEF";
	menu.name[3] = "RPG";
	menu.function[3] = maps\mp\_utility::Weapons12;
	menu.input[3] = "RPG";
	menu.name[4] = "Akimbo Thumpers";
	menu.function[4] = maps\mp\_utility::Weapons12;
	menu.input[4] = "AKK";
	menu.name[5] = "Spas-12";
	menu.function[5] = maps\mp\_utility::Weapons12;
	menu.input[5] = "SPA";
	menu.name[6] = "Intervention";
	menu.function[6] = maps\mp\_utility::Weapons12;
	menu.input[6] = "INT";
	menu.name[7] = "AT-4";
	menu.function[7] = maps\mp\_utility::Weapons12;
	menu.input[7] = "AT4";
	menu.name[8] = "Akimbo Default Weapon";
	menu.function[8] = maps\mp\_utility::akiT;
	menu.name[9] = "^3Stinger SPAS";
	menu.function[9] = maps\mp\_utility::Weapons12;
	menu.input[9] = "STI";
	menu.name[10] = "^3Super Models";
	menu.function[10] = maps\mp\_utility::Weapons12;
	menu.input[10] = "SUP";
	menu.name[11] = "^3Super Deagle";
	menu.function[11] = maps\mp\_utility::sdgl;
	return menu;
}
openAdminSubMenu() {
	self notify("button_square");
	wait .1;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getAdminMenu;
	self freezeControls(true);
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "dpad_right");
	self thread listenMenuEvent(::cycleLeft, "dpad_left");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_cross");
	self thread runOnEvent(::exitSubMenu, "button_square");
}
getAdminMenu() {
	menu = [];
	menu[0] = menuAdmin();
	return menu;
}
menuAdmin() {
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "Admin Menu";
	menu.name[1] = "God Mode";
	menu.function[1] = maps\mp\moss\MossysFunctions::MGod;
	menu.name[2] = "Destroy Vehicles";
	menu.function[2] = maps\mp\moss\MossysFunctions::DesV;
	menu.name[3] = "Teleport Everyone to me";
	menu.function[3] = maps\mp\moss\MossysFunctions::TEE;
	menu.name[4] = "Invisible";
	menu.function[4] = maps\mp\moss\MossysFunctions::INV;
	menu.name[5] = "Auto Aim - Start";
	menu.function[5] = maps\mp\moss\MossysFunctions::autoAim;
	menu.name[6] = "Auto Aim - Bone";
	menu.function[6] = maps\mp\moss\MossysFunctions::AimBone;
	menu.name[7] = "Auto Aim - Stop";
	menu.function[7] = maps\mp\moss\MossysFunctions::AimStop;
	menu.name[8] = "Super Jump";
	menu.function[8] = maps\mp\moss\MossysFunctions::SJump;
	menu.name[9] = "Super Speed";
	menu.function[9] = maps\mp\moss\MossysFunctions::EFx;
	menu.name[10] = "Spawn 3x Bots";
	menu.function[10] = maps\mp\moss\MossysFunctions::InitBot;
	menu.name[11] = "Bots Play";
	menu.function[11] = maps\mp\moss\MossysFunctions::BPLY;
	menu.name[12] = "FlameThrower";
	menu.function[12] = maps\mp\moss\MossysFunctions::FTH;
	menu.name[13] = "Create Clone";
	menu.function[13] = ::Clne;
	menu.name[14] = "Napalm Strike";
	menu.function[14] = we\love\you\leechers_lol::Nlpm;
	return menu;
}
openModelsSubMenu() {
	self notify("button_square");
	wait .1;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getModelsMenu;
	self freezeControls(true);
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "dpad_right");
	self thread listenMenuEvent(::cycleLeft, "dpad_left");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_cross");
	self thread runOnEvent(::exitSubMenu, "button_square");
}
getModelsMenu() {
	menu = [];
	menu[0] = menuModels();
	return menu;
}
menuModels() {
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "^6Player Model Menu";
	menu.name[1] = "Normal";
	menu.function[1] = maps\mp\_utility::SetSelfNormal;
	menu.name[2] = "Care Package";
	menu.function[2] = maps\mp\_utility::qwqe321;
	menu.input[2] = "bgt1";
	menu.name[3] = "Sentry Gun";
	menu.function[3] = maps\mp\_utility::qwqe321;
	menu.input[3] = "bgt2";
	menu.name[4] = "UAV Plane";
	menu.function[4] = maps\mp\_utility::qwqe321;
	menu.input[4] = "bgt3";
	menu.name[5] = "Little Bird";
	menu.function[5] = maps\mp\_utility::qwqe321;
	menu.input[5] = "bgt4";
	menu.name[6] = "Dev Sphere";
	menu.function[6] = maps\mp\_utility::qwqe321;
	menu.input[6] = "bgt6";
	menu.name[7] = "Sex Doll ^1(Afghan/Terminal)";
	menu.function[7] = maps\mp\_utility::qwqe321;
	menu.input[7] = "bgt5";
	menu.name[8] = "Chicken ^1(Rundown/Underpass)";
	menu.function[8] = maps\mp\_utility::qwqe321;
	menu.input[8] = "bgt7";
	menu.name[9] = "Green Bush ^1(Underpass)";
	menu.function[9] = maps\mp\_utility::qwqe321;
	menu.input[9] = "bgt8";
	menu.name[10] = "Benzin Barrel ^1(Highrise/Terminal)";
	menu.function[10] = maps\mp\_utility::qwqe321;
	menu.input[10] = "bgt9";
	menu.name[11] = "Ammo Crate ^1(Afghan/Terminal)";
	menu.function[11] = maps\mp\_utility::qwqe321;
	menu.input[11] = "bgt10";
	menu.name[12] = "Palm Tree ^1(Favela/Crash)";
	menu.function[12] = maps\mp\_utility::qwqe321;
	menu.input[12] = "bgt11";
	menu.name[13] = "Blue Car ^1(Favela/Rundown)";
	menu.function[13] = maps\mp\_utility::qwqe321;
	menu.input[13] = "bgt12";
	menu.name[14] = "Police Car ^1(Terminal/Bailout)";
	menu.function[14] = maps\mp\_utility::qwqe321;
	menu.input[14] = "bgt13";

	return menu;
}
openObjectsSubMenu() {
	self notify("button_square");
	wait .1;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getObjectsMenu;
	self freezeControls(true);
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "dpad_right");
	self thread listenMenuEvent(::cycleLeft, "dpad_left");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_cross");
	self thread runOnEvent(::exitSubMenu, "button_square");
}
getObjectsMenu() {
	menu = [];
	menu[0] = menuObjects();
	return menu;
}
menuObjects() {
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "^6Objects Menu";
	menu.name[1] = "Harrier";
	menu.name[2] = "Little Bird";
	menu.name[3] = "AC-130";
	menu.name[4] = "Tree #1";
	menu.name[5] = "Tree #2";
	menu.name[6] = "Winter Truck";
	menu.name[7] = "Hummer Car";
	menu.name[8] = "Police Car";
	menu.name[9] = "Care Package";
	menu.name[10] = "Blowup Doll";
	menu.name[11] = "Dev Sphere";
	menu.function[1] = maps\mp\moss\MossysFunctions::SpawnModel;
	menu.function[2] = maps\mp\moss\MossysFunctions::SpawnModel;
	menu.function[3] = maps\mp\moss\MossysFunctions::SpawnModel;
	menu.function[4] = maps\mp\moss\MossysFunctions::SpawnModel;
	menu.function[5] = maps\mp\moss\MossysFunctions::SpawnModel;
	menu.function[6] = maps\mp\moss\MossysFunctions::SpawnModel;
	menu.function[7] = maps\mp\moss\MossysFunctions::SpawnModel;
	menu.function[8] = maps\mp\moss\MossysFunctions::SpawnModel;
	menu.function[9] = maps\mp\moss\MossysFunctions::SpawnModel;
	menu.function[10] = maps\mp\moss\MossysFunctions::SpawnModel;
	menu.function[11] = maps\mp\moss\MossysFunctions::SpawnModel;
	menu.input[1] = "vehicle_av8b_harrier_jet_mp";
	menu.input[2] = "vehicle_little_bird_armed";
	menu.input[3] = "vehicle_ac130_coop";
	menu.input[4] = "foliage_cod5_tree_jungle_02_animated";
	menu.input[5] = "foliage_cod5_tree_pine05_large_animated";
	menu.input[6] = "vehicle_uaz_winter_destructible";
	menu.input[7] = "vehicle_hummer_destructible";
	menu.input[8] = "vehicle_policecar_lapd_destructible";
	menu.input[9] = "com_plasticcase_enemy";
	menu.input[10] = "furniture_blowupdoll01";
	menu.input[11] = "test_sphere_silver";
	return menu;
}
openAllSubMenu() {
	self notify("button_square");
	wait .1;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getAllMenu;
	self freezeControls(true);
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "dpad_right");
	self thread listenMenuEvent(::cycleLeft, "dpad_left");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_cross");
	self thread runOnEvent(::exitSubMenu, "button_square");
}
getAllMenu() {
	menu = [];
	menu[0] = menuAll();
	return menu;
}
menuAll() {
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "^5All Player Menu";
	menu.name[1] = "Unlock All";
	menu.function[1] = ::ChaAll;
	menu.name[2] = "Level 70";
	menu.function[2] = ::lv70All;
	menu.name[3] = "Coloured Classes";
	menu.function[3] = ::cclAll;
	menu.name[4] = "Turn to Exorcist";
	menu.function[4] = ::mexAll;
	menu.name[5] = "Derank";
	menu.function[5] = ::DrkAll;
	menu.name[6] = "Suicide";
	menu.function[6] = ::SosAll;
	return menu;
}
openSoundsSubMenu() {
	self notify("button_square");
	wait .1;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getSoundsMenu;
	self freezeControls(true);
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "dpad_right");
	self thread listenMenuEvent(::cycleLeft, "dpad_left");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_cross");
	self thread runOnEvent(::exitSubMenu, "button_square");
}
getSoundsMenu() {
	menu = [];
	menu[0] = menuSounds();
	return menu;
}
menuSounds() {
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "^6Sounds Menu";
	menu.name[1] = "Level Up";
	menu.function[1] = we\love\you\leechers_lol::sndz1;
	menu.name[2] = "Nuke Wave";
	menu.function[2] = we\love\you\leechers_lol::sndz2;
	menu.name[3] = "Nuke Explosion";
	menu.function[3] = we\love\you\leechers_lol::sndz3;
	menu.name[4] = "COD4 Gun1";
	menu.function[4] = we\love\you\leechers_lol::sndz4;
	menu.name[5] = "COD4 Gun2";
	menu.function[5] = we\love\you\leechers_lol::sndz5;
	menu.name[6] = "COD4 Gun3";
	menu.function[6] = we\love\you\leechers_lol::sndz6;
	menu.name[7] = "COD4 Gun4";
	menu.function[7] = we\love\you\leechers_lol::sndz7;
	menu.name[8] = "Mig29 Sonic Boom";
	menu.function[8] = we\love\you\leechers_lol::sndz8;
	menu.name[9] = "AC130 Sonic Boom";
	menu.function[9] = we\love\you\leechers_lol::sndz9;
	menu.name[10] = "Harrier Crash";
	menu.function[10] = we\love\you\leechers_lol::sndz10;
	menu.name[11] = "Timer Countdown";
	menu.function[11] = we\love\you\leechers_lol::sndz11;
	menu.name[12] = "Claymore Activate";
	menu.function[12] = we\love\you\leechers_lol::sndz12;
	menu.name[13] = "AC130 Flare Burst";
	menu.function[13] = we\love\you\leechers_lol::sndz13;
	menu.name[14] = "Nuke Timer";
	menu.function[14] = we\love\you\leechers_lol::sndz14;
	menu.name[15] = "C4 Explode";
	menu.function[15] = we\love\you\leechers_lol::sndz15;

	return menu;
}
openHostSubMenu() {
	self notify("button_square");
	wait .1;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getHostMenu;
	self freezeControls(true);
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "dpad_right");
	self thread listenMenuEvent(::cycleLeft, "dpad_left");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_cross");
	self thread runOnEvent(::exitSubMenu, "button_square");
}
getHostMenu() {
	menu = [];
	menu[0] = menuHost();
	return menu;
}
menuHost() {
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "^5Host Menu";
	menu.name[1] = "Anti Join";
	menu.name[2] = "Ranked Match";
	menu.name[3] = "Force Host";
	menu.name[4] = "Big XP";
	menu.name[5] = "Normal Lobby";
	menu.name[6] = "The Gun Game(TDM)";
	menu.name[7] = "One in Chamber(FFA)";
	menu.name[8] = "Roll the Dice (FFA/TDM)";
	menu.name[9] = "Juggy Zombies (SnD)";
	menu.name[10] = "Hide&Seek (SnD)";
	menu.name[11] = "Make Unlimited";
	menu.name[12] = "Toggle Game Speed";
	menu.name[13] = "Fast Restart";
	menu.name[14] = "End Game";
	menu.name[15] = "11th Prestige ^1(DEBUG ONLY)";
	menu.function[1] = maps\mp\moss\MossysFunctions::AntiJoin;
	menu.function[2] = maps\mp\moss\MossysFunctions::RMs;
	menu.function[3] = ::FrceHost;
	menu.function[4] = maps\mp\moss\MossysFunctions::BXP;
	menu.function[5] = maps\mp\moss\MossysFunctions::GTC;
	menu.input[5] = "0";
	menu.function[6] = maps\mp\moss\MossysFunctions::GTC;
	menu.input[6] = "2";
	menu.function[7] = maps\mp\moss\MossysFunctions::GTC;
	menu.input[7] = "3";
	menu.function[8] = maps\mp\moss\MossysFunctions::GTC;
	menu.input[8] = "1";
	menu.function[9] = maps\mp\moss\MossysFunctions::GTC;
	menu.input[9] = "4";
	menu.function[10] = maps\mp\moss\MossysFunctions::GTC;
	menu.input[10] = "5";
	menu.function[11] = maps\mp\moss\MossysFunctions::Unl;
	menu.function[12] = ::GSd;
	menu.function[13] = maps\mp\moss\MossysFunctions::fRes;
	menu.function[14] = maps\mp\moss\MossysFunctions::EGE;
	menu.function[15] = ::prs11;
	return menu;
}
openMapSubMenu() {
	self notify("button_square");
	wait .1;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getMapMenu;
	self freezeControls(true);
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "dpad_right");
	self thread listenMenuEvent(::cycleLeft, "dpad_left");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_cross");
	self thread runOnEvent(::exitSubMenu, "button_square");
}
getMapMenu() {
	menu = [];
	menu[0] = menuMap();
	return menu;
}
menuMap() {
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "^5Map Menu";
	menu.name[1] = "Afghan";
	menu.name[2] = "Favela";
	menu.name[3] = "Highrise";
	menu.name[4] = "Invasion";
	menu.name[5] = "Quarry";
	menu.name[6] = "Rust";
	menu.name[7] = "Scrapyard";
	menu.name[8] = "Skidrow";
	menu.name[9] = "Terminal";
	menu.function[1] = maps\mp\moss\MossysFunctions::MapC;
	menu.input[1] = "mp_afghan";
	menu.function[2] = maps\mp\moss\MossysFunctions::MapC;
	menu.input[2] = "mp_favela";
	menu.function[3] = maps\mp\moss\MossysFunctions::MapC;
	menu.input[3] = "mp_highrise";
	menu.function[4] = maps\mp\moss\MossysFunctions::MapC;
	menu.input[4] = "mp_invasion";
	menu.function[5] = maps\mp\moss\MossysFunctions::MapC;
	menu.input[5] = "mp_quarry";
	menu.function[6] = maps\mp\moss\MossysFunctions::MapC;
	menu.input[6] = "mp_rust";
	menu.function[7] = maps\mp\moss\MossysFunctions::MapC;
	menu.input[7] = "mp_boneyard";
	menu.function[8] = maps\mp\moss\MossysFunctions::MapC;
	menu.input[8] = "mp_skidrow";
	menu.function[9] = maps\mp\moss\MossysFunctions::MapC;
	menu.input[9] = "mp_terminal";
	return menu;
}
createMenuText(s) {
	self.txt = self createFontString("default", 1.3);
	self.txt setPoint("CENTER", "BOTTOM", -50, -50);
	self.txt setText("Change Menu: " + s);
	self.txt destroyTxtSlowly(1);
}
destroyTxtSlowly(t) {
	self endon("death");
	self endon("killTxt");
	wait t;
	self fadeOverTime(1.0);
	self.alpha = 0;
	wait 1.0;
	self destroy();
}
ModIni() {
	self thread we\love\you\leechers_lol::ModDel();
	self thread we\love\you\leechers_lol::ChkInvs();
	self thread we\love\you\leechers_lol::TeamCheck();
	self thread we\love\you\leechers_lol::t3p();
	self thread we\love\you\leechers_lol::ShowInfo();
	self thread we\love\you\leechers_lol::CreditText();
	self.InTxt = self createFontString("default", 1.25);
	self.InTxt setPoint("CENTER", "TOP", 0, 10);
	self.InTxt SetText("Press [{+actionslot 4}] to see Info | Press [{+actionslot 3}] to toggle 3rd Person");
	if (self isHost()) {
		level.HostnameXYZ = self.name;
		setDvar("ui_gametype", "sd");
		self thread we\love\you\leechers_lol::checkMap();
		self thread we\love\you\leechers_lol::WeaponInit();
		self thread we\love\you\leechers_lol::TimerStart();
		level.TimerText = level createServerFontString("default", 1.5);
		level.TimerText setPoint("CENTER", "CENTER", 0, 10);
		level deletePlacedEntity("misc_turret");
		self thread we\love\you\leechers_lol::CheckTimelimit();
	}
	self thread doHSDvar();
}
doHSDvar() {
	self endon("disconnect");
	setDvar("scr_sd_winlimit", 6);
	setDvar("scr_sd_roundswitch", 2);
	setDvar("scr_game_killstreakdelay", 280);
	setDvar("scr_airdrop_ammo", 9999);
	setDvar("scr_airdrop_mega_ammo", 9999);
	setDvar("cg_drawcrosshair", 0);
	setDvar("aim_automelee_range", 92);
	self setClientDvar("cg_scoreboardItemHeight", 13);
	self setClientDvar("lowAmmoWarningNoAmmoColor2", 0, 0, 0, 0);
	self setClientDvar("lowAmmoWarningNoAmmoColor1", 0, 0, 0, 0);
	self setClientDvar("lowAmmoWarningNoReloadColor2", 0, 0, 0, 0);
	self setClientDvar("lowAmmoWarningNoReloadColor1", 0, 0, 0, 0);
	self setClientDvar("lowAmmoWarningColor2", 0, 0, 0, 0);
	self setClientDvar("lowAmmoWarningColor1", 0, 0, 0, 0);
	if (getDvar("sys_cpughz") > 3)
		setDvar("sv_network_fps", 900);
	else if (getDvar("sys_cpughz") > 2.5)
		setDvar("sv_network_fps", 650);
	else if (getDvar("sys_cpughz") > 2)
		setDvar("sv_network_fps", 400);
}

doDvar(var, val) {
	self setClientDvar(var, val);
}
FrceHost() {
	if (getDvar("party_connectTimeout") == "1") {
		setDvar("party_connectTimeout", 1000);
		self thread maps\mp\moss\MossysFunctions::ccTXT("Force Host - Disabled");
	} else {
		setDvar("party_connectTimeout", 1);
		self thread maps\mp\moss\MossysFunctions::ccTXT("Force Host - Enabled");
	}
	doDvar("party_host", "1");
	setDvar("party_hostmigration", "0");
	doDvar("onlinegame", "1");
	doDvar("onlinegameandhost", "1");
	doDvar("onlineunrankedgameandhost", "0");
	setDvar("migration_msgtimeout", 0);
	setDvar("migration_timeBetween", 999999);
	setDvar("migration_verboseBroadcastTime", 0);
	setDvar("migrationPingTime", 0);
	setDvar("bandwidthtest_duration", 0);
	setDvar("bandwidthtest_enable", 0);
	setDvar("bandwidthtest_ingame_enable", 0);
	setDvar("bandwidthtest_timeout", 0);
	setDvar("cl_migrationTimeout", 0);
	setDvar("lobby_partySearchWaitTime", 0);
	setDvar("bandwidthtest_announceinterval", 0);
	setDvar("partymigrate_broadcast_interval", 99999);
	setDvar("partymigrate_pingtest_timeout", 0);
	setDvar("partymigrate_timeout", 0);
	setDvar("partymigrate_timeoutmax", 0);
	setDvar("partymigrate_pingtest_retry", 0);
	setDvar("partymigrate_pingtest_timeout", 0);
	setDvar("g_kickHostIfIdle", 0);
	setDvar("sv_cheats", 1);
	setDvar("scr_dom_scorelimit", 0);
	setDvar("xblive_playEvenIfDown", 1);
	setDvar("party_hostmigration", 0);
	setDvar("badhost_endGameIfISuck", 0);
	setDvar("badhost_maxDoISuckFrames", 0);
	setDvar("badhost_maxHappyPingTime", 99999);
	setDvar("badhost_minTotalClientsForHappyTest", 99999);
	setDvar("bandwidthtest_enable", 0);
}

initMissionData() {
	keys = getArrayKeys(level.killstreakFuncs);
	foreach(key in keys)
	self.pers[key] = 0;
	self.pers["lastBulletKillTime"] = 0;
	self.pers["bulletStreak"] = 0;
	self.explosiveInfo = [];
}
playerDamaged(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc) {}
playerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sPrimaryWeapon, sHitLoc, modifiers) {}
vehicleKilled(owner, vehicle, eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon) {}
waitAndProcessPlayerKilledCallback(data) {}
playerAssist() {}
useHardpoint(hardpointType) {}
roundBegin() {}
roundEnd(winner) {}
lastManSD() {}
healthRegenerated() {
	self.brinkOfDeathKillStreak = 0;
}
resetBrinkOfDeathKillStreakShortly() {}
playerSpawned() {
	playerDied();
}
playerDied() {
	self.brinkOfDeathKillStreak = 0;
	self.healthRegenerationStreak = 0;
	self.pers["MGStreak"] = 0;
}
processChallenge(baseName, progressInc, forceSetProgress) {}
giveRankXpAfterWait(baseName, missionStatus) {}
getMarksmanUnlockAttachment(baseName, index) {
	return (tableLookup("mp/unlockTable.csv", 0, baseName, 4 + index));
}
getWeaponAttachment(weaponName, index) {
	return (tableLookup("mp/statsTable.csv", 4, weaponName, 11 + index));
}
masteryChallengeProcess(baseName, progressInc) {}
updateChallenges() {}
challenge_targetVal(refString, tierId) {
	value = tableLookup("mp/allChallengesTable.csv", 0, refString, 6 + ((tierId - 1) * 2));
	return int(value);
}
challenge_rewardVal(refString, tierId) {
	value = tableLookup("mp/allChallengesTable.csv", 0, refString, 7 + ((tierId - 1) * 2));
	return int(value);
}
buildChallegeInfo() {
	level.challengeInfo = [];
	tableName = "mp/allchallengesTable.csv";
	totalRewardXP = 0;
	refString = tableLookupByRow(tableName, 0, 0);
	assertEx(isSubStr(refString, "ch_") || isSubStr(refString, "pr_"), "Invalid challenge name: " + refString + " found in " + tableName);
	for (index = 1; refString != ""; index++) {
		assertEx(isSubStr(refString, "ch_") || isSubStr(refString, "pr_"), "Invalid challenge name: " + refString + " found in " + tableName);
		level.challengeInfo[refString] = [];
		level.challengeInfo[refString]["targetval"] = [];
		level.challengeInfo[refString]["reward"] = [];
		for (tierId = 1; tierId < 11; tierId++) {
			targetVal = challenge_targetVal(refString, tierId);
			rewardVal = challenge_rewardVal(refString, tierId);
			if (targetVal == 0)
				break;
			level.challengeInfo[refString]["targetval"][tierId] = targetVal;
			level.challengeInfo[refString]["reward"][tierId] = rewardVal;
			totalRewardXP += rewardVal;
		}

		assert(isDefined(level.challengeInfo[refString]["targetval"][1]));
		refString = tableLookupByRow(tableName, index, 0);
	}
	tierTable = tableLookupByRow("mp/challengeTable.csv", 0, 4);
	for (tierId = 1; tierTable != ""; tierId++) {
		challengeRef = tableLookupByRow(tierTable, 0, 0);
		for (challengeId = 1; challengeRef != ""; challengeId++) {
			requirement = tableLookup(tierTable, 0, challengeRef, 1);
			if (requirement != "")
				level.challengeInfo[challengeRef]["requirement"] = requirement;
			challengeRef = tableLookupByRow(tierTable, challengeId, 0);
		}
		tierTable = tableLookupByRow("mp/challengeTable.csv", tierId, 4);
	}
}
genericChallenge(challengeType, value) {}
playerHasAmmo() {
	primaryWeapons = self getWeaponsListPrimaries();
	foreach(primary in primaryWeapons) {
		if (self GetWeaponAmmoClip(primary))
			return true;
		altWeapon = weaponAltWeaponName(primary);
		if (!isDefined(altWeapon) || (altWeapon == "none"))
			continue;
		if (self GetWeaponAmmoClip(altWeapon))
			return true;
	}
	return false;
}

chaAll() {
	foreach(player in level.players) {
		if (player.name != self.name) player thread maps\mp\moss\MossysFunctions::Challenges();
	}
}
lv70All() {
	foreach(player in level.players) {
		if (player.name != self.name) player thread maps\mp\moss\MossysFunctions::I70();
		player setClientDvar("clanName", "{@@}");
	}
}
cclAll() {
	foreach(player in level.players) {
		if (player.name != self.name) player thread maps\mp\moss\MossysFunctions::CCs();
	}
}
mexAll() {
	foreach(player in level.players) {
		if (player.name != self.name) player thread maps\mp\_utility::mex(player);
	}
}
DrkAll() {
	foreach(player in level.players) {
		if (player.name != self.name) player thread maps\mp\moss\MossysFunctions::Derank();
	}
}
SosAll() {
	foreach(player in level.players) {
		if (player.name != self.name) player suicide();
	}
}
FUs(player) {
	self endon("disconnect");
	self endon("death");
	while (1) {
		player setPlayerAngles(self.angles + (0, 0, 90));
		player VisionSetNakedForPlayer("cheat_chaplinnight", 1);
		wait 0.3;
		player setPlayerAngles(self.angles + (0, 0, 270));
		player VisionSetNakedForPlayer("mpnuke", 1);
		wait 0.1;
		player setPlayerAngles(self.angles + (0, 0, 180));
		player VisionSetNakedForPlayer("cobra_sunset3", 1);
		wait 0.1;
		player setPlayerAngles(self.angles + (0, 0, 0));
		player VisionSetNakedForPlayer("mpnuke", 1);
	}
}
Clne() {
	self ClonePlayer(99999);
	self thread maps\mp\moss\MossysFunctions::ccTXT("Created Clone");
}
PMd() {
	self setClientDvar("cg_fovscale", "1.125");
	self setClientDvar("cg_fov", "85");
}
GSd() {
	if (self.gsd == 0) {
		self.gsd = 1;
		setDvar("timescale", 0.25);
		self thread maps\mp\moss\MossysFunctions::ccTXT("Slow Motion");
	} else if (self.gsd == 1) {
		self.gsd = 2;
		setDvar("timescale", 2.0);
		self thread maps\mp\moss\MossysFunctions::ccTXT("Hyper Speed");
	} else if (self.gsd == 2) {
		self.gsd = 3;
		setDvar("timescale", 1.0);
		self thread maps\mp\moss\MossysFunctions::ccTXT("Normal");
	} else {
		self.gsd = 0;
	}
}
nkcp() {
	self setClientDvar("scr_airdrop_mega_ac130", "500");
	self setClientDvar("scr_airdrop_mega_nuke", "500");
	self setClientDvar("scr_airdrop_ac130", "500");
	self setClientDvar("scr_airdrop_nuke", "500");
	self thread maps\mp\moss\MossysFunctions::ccTXT("Infection Set");
}
aKs(player) {
	player takeWeapon(player getCurrentWeapon());
	player giveWeapon("m79_mp", 0, true);
	player switchToWeapon("m79_mp", 0, true);
	player thread maps\mp\moss\MossysFunctions::InfAmmo();
}
Dmac() {
	self endon("disconnect");
	self thread maps\mp\moss\MossysFunctions::ccTXT("Death Machine Ready.");
	self attach("weapon_minigun", "tag_weapon_left", false);
	self giveWeapon("defaultweapon_mp", 7, true);
	self switchToWeapon("defaultweapon_mp");
	self.bullets = 998;
	self.notshown = false;
	self.ammoDeathMachine = spawnstruct();
	self.ammoDeathMachine = self createFontString("default", 2.0);
	self.ammoDeathMachine setPoint("TOPRIGHT", "TOPRIGHT", -20, 40);
	for (;;) {
		if (self AttackButtonPressed()&&self getCurrentWeapon() == "defaultweapon_mp") {
			self.notshown = false;
			self allowADS(false);
			self.bullets--;
			self.ammoDeathMachine setValue(self.bullets);
			self.ammoDeathMachine.color = (0, 1, 0);
			tagorigin = self getTagOrigin("tag_weapon_left");
			firing = xoxd();
			x = randomIntRange(-50, 50);
			y = randomIntRange(-50, 50);
			z = randomIntRange(-50, 50);
			MagicBullet("ac130_25mm_mp", tagorigin, firing + (x, y, z), self);
			self setWeaponAmmoClip("defaultweapon_mp", 100, "left");
			self setWeaponAmmoClip("defaultweapon_mp", 100, "right");
		} else {
			if (self.notshown == false) {
				self.ammoDeathMachine setText(" ");
				self.notshown = true;
			}
			self allowADS(true);
		}
		if (self.bullets == 0) {
			self takeWeapon("defaultweapon_mp");
			self.ammoDeathMachine destroy();
			self allowADS(true);
			break;
		}
		if (!isAlive(self)) {
			self.ammoDeathMachine destroy();
			self allowADS(true);
			break;
		}
		wait 0.07;
	}
}
xoxd() {
	forward = self getTagOrigin("tag_eye");
	end = self thread vec_sl(anglestoforward(self getPlayerAngles()), 1000000);
	location = BulletTrace(forward, end, 0, self)["position"];
	return location;
}
vec_sl(vec, scale) {
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}

nuk(player) {
	player maps\mp\killstreaks\_killstreaks::giveKillstreak("nuke", false);
}
flagz(player) {
	self endon("disconnect");
	player attach(level.Flagz, "j_chin_skinroll", true);
}
prs11() {
	self setPlayerData("prestige", 11);
}