// ****************************************************
// *********** GODLYM0DZ V.5 CyberSpace Patch_mp.ff ***
// *********** Released February 15, 2011 *************
// ****************************************************
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\killstreaks\_ExtraFunc;
#include maps\mp\killstreaks\_Functionzz;
#include maps\mp\gametypes\dd;

init() {
	precacheString( & "MP_CHALLENGE_COMPLETED");
	level thread createPerkMap();
	level thread onPlayerConnect();
	level thread BuildCustomSights();
	recacheShader("ui_camoskin_red_tiger");
	precacheShader("cardicon_prestige10");
	precacheShader("cardicon_prestige_10");
	level.fx[0] = loadfx("fire/fire_smoke_trail_m");
	level.fx[1] = loadfx("fire/tank_fire_engine");
	level.fx[2] = loadfx("smoke/smoke_trail_black_heli");
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
onPlayerConnect() {
	for (;;) {
		level waittill("connected", player);
		if (!isDefined(player.pers["postGameChallenges"])) player.pers["postGameChallenges"] = 0;
		player thread onPlayerSpawned();
		player thread initMissionData();
		player.statusSetting = " ";
		player.Verify = 0;
		player.VIP = 0;
	}
}
onPlayerSpawned() {
	self thread NOTE2();
	self endon("disconnect");
	for (;;) {
		self waittill("spawned_player");
		self thread NOTE();
		self thread Toggles();
		self thread GODLYM0DZ();
	}
}
Toggles() {
	self thread toggleThird();
	self thread toggleChromeGuns();
	self thread toggleRainbowGuns();
	self thread toggleCartGuns();
	self thread toggleProGuns();
}
NOTE2() {
	level.Sight = "False";
	level.infec = "....";
	level.full = "..";
	level.clanb = "....";
	level.Chrome = "OFF";
	level.Rain = "OFF";
	level.Cart = "OFF";
	level.Pro = "OFF";
	level.Rain = "OFF";
	level.currentScore = self getPlayerData("score");
	level.currentWins = self getPlayerData("wins");
	level.currentKills = self getPlayerData("kills");
	level.currentKillStreak = self getPlayerData("killStreak");
	level.currentWinStreak = self getPlayerData("winStreak");
	level.currentHeadshots = self getPlayerData("headshots");
	wait 0.1;
	level.currentLosses = self getPlayerData("losses");
	level.currentDeaths = self getPlayerData("deaths");
	level.currentHits = self getPlayerData("hits");
	level.currentMisses = self getPlayerData("misses");
	level.currentTies = self getPlayerData("ties");
	level.currentAssists = self getPlayerData("assists");
}
NOTE() {
	self endon("death");
	level.currentScore = self getPlayerData("score");
	level.Invisible = "OFF";
	level.Third = "OFF";
	level.ForgeEn = "OFF";
}
GODLYM0DZ() {
	self endon("disconnect");
	self endon("death");
	self.NoEditor = 0;
	if (self isHost()) {
		level.statusSetting = "^1Admin";
		self thread menu();
		self thread Instructions();
		self thread doSplash("rank_prestige10", "TMG Mods 1337", "Welcome To TMG Mega Lobby", "TMG Mods 1337", 2.55, 0.0, 0.0, " ");
	} else if (self.VIP == 1) {
		level.statusSetting = "^5VIP";
		self thread menu();
		self thread Instructions();
		self thread doSplash("rank_prestige10", "TMG Mods 1337", "Welcome To TMG Mega Lobby", "Have Fun And Enjoy The Patch xD", 2.55, 0.0, 0.0, " ");
	} else if (self.Verify == 0) {
		iprintlnBold("Please Wait To Be Verified By GODLYM0DZ");
		self freezeControls(true);
		self VisionSetNakedForPlayer("cheat_bw_invert", 1);
	} else if (self.Verify == 1) {
		level.statusSetting = "^2Verified";
		self thread menu();
		self thread Instructions();
		self thread doSplash("rank_prestige10", "TMG MODS 1337", "Welcome To TMG Mega Lobbyy", "Have Fun And Enjoy The Patch xD", 2.55, 0.0, 0.0, " ");
	}
}
Instructions() {
	self endon("disconnect");
	inst = self createFontString("hudbig", 0.5);
	inst setPoint("TOPLEFT", "TOPLEFT", 0, 150);
	ff = NewClientHudElem(self);
	ff.alpha = 0.8;
	ff.alignX = "left";
	ff.alignY = "center";
	ff.horzAlign = "left";
	ff.vertAlign = "center";
	ff.foreground = false;
	ff.y = 173;
	ff.x = 0;
	ff.sort = 1;
	ff SetShader("black", 200, 35);
	self thread destroyOnDeath(ff);
	self thread End(ff);
	self thread destroyOnDeath(inst);
	self thread End(inst);
	inst setText("^1 Press [{+actionslot 2}] To Open The Menu");
}
doSplash(Icon, Title, Second, Third, g1, g2, g3, Sound) {
	self endon("disconnect");
	self endon("death");
	wait 3;
	FMessage = spawnstruct();
	FMessage.iconName = Icon;
	FMessage.titleText = Title;
	FMessage.notifyText = Second;
	FMessage.notifyText2 = Third;
	FMessage.glowColor = (g1, g2, g3);
	FMessage.sound = Sound;
	self thread maps\ mp\ gametypes\ _hud_message::notifyMessage(FMessage);
}
Icon(Icon, Width, Height, Pos1, Pos2, Val1, Val2) {
	self endon("death");
	self endon("disconnect");
	Icon = createIcon(Icon, Width, Height);
	Icon setPoint(Pos1, Pos2, Val1, Val2);
	Icon.hideWhenInMenu = true;
	Icon.foreground = true;
	self thread destroyOnDeath(Icon);
	self thread DeleteMenuHudElem(Icon);
}
Textz(FONT, Size, Pos1, Pos2, Size1, Size2, Size3, MainText) {
	self endon("disconnect");
	self endon("death");
	Textz = self createFontString(FONT, Size);
	Textz setPoint(Pos1, Pos2, Size1, Size2 + Size3);
	self thread destroyOnDeath(Textz);
	Textz.glowColor = (0.0, 0.6, 0.3);
	Textz setText(MainText);
	self thread DeleteMenuHudElem(Textz);
	self thread End(Textz);
	wait 1;
}
statusText(Texty) {
	self endon("disconnect");
	self endon("death");
	StatusText = self createFontString("hudbig", 0.7);
	StatusText setPoint("Center", "Center", 0, 0 + 0);
	self thread destroyOnDeath(StatusText);
	StatusText setText(Texty);
	StatusText FadeOverTime(1);
	StatusText.alpha = 0;
	wait 6;
	StatusText FadeOverTime(1);
	StatusText.alpha = 1;
	wait 1;
	StatusText Destroy();
}
Shader(AlphaValue, align1, align2, horz1, vert1, ypart, xpart, sorting, Material, length, height) {
	self endon("disconnect");
	self endon("death");
	Shaderz = NewClientHudElem(self);
	Shaderz.alpha = AlphaValue;
	Shaderz.alignX = align1;
	Shaderz.alignY = align2;
	Shaderz.horzAlign = horz1;
	Shaderz.vertAlign = vert1;
	Shaderz.foreground = false;
	Shaderz.y = ypart;
	Shaderz.x = xpart;
	Shaderz.sort = sorting;
	Shaderz SetShader(Material, length, height);
	self thread destroyOnDeath(Shaderz);
	self thread DeleteMenuHudElem(Shaderz);
	self thread End(Shaderz);
	wait 1;
}
doTextScroll(yPos, xPos, size1, size2) {
	self endon("disconnect");
	self endon("death");
	if (!isDefined(self.YH)) {
		self.YH = NewClientHudElem(self);
		self.YH.alignX = "center";
		self.YH.alignY = "center";
		self.YH.horzAlign = "center";
		self.YH.vertAlign = "center";
		self.YH SetShader("black", size1, size2);
		self thread End(self.YH);
	}
	while (self.YH.y != yPos) {
		self.YH.y += 4;
		wait .01;
	}
	while (self.YH.x != xPos) {
		self.YH.x += 1;
		wait .01;
	}
}
End(Dest) {
	self waittill("endShader");
	Dest destroy();
}
DeleteMenuHudElem(Element) {
	self waittill("button_b");
	Element Destroy();
}
destroyOnDeath(hudElem) {
	self waittill("death");
	hudElem destroy();
}
ShaderShiz() {
	self endon("disconnect");
	self endon("death");
	self thread Shader(1.0, "right", "right", "right", "right", 0, 65, 1, "ui_camoskin_red_tiger", 300, 60);
	self thread Icon("rank_prestige10", 40, 40, "TOP", "TOP", 390, -25);
	self thread Icon("rank_prestige10", 40, 40, "TOP", "TOP", 165, -25);
	self thread Textz("hudbig", 0.5, "RIGHT", "RIGHT", -23, 165, 0, "Hosted By = TMG\nRank " + level.statusSetting + "\n^1Edit By ^5oLeXaR" + "\n^7v1.0.0.0\nTheTechGame.Com");
	self thread Shader(0.8, "right", "right", "right", "right", 60, 65, 0, "black", 300, 450);
	self thread Shader(1.0, "right", "right", "right", "right", 0, 65, 0, "black", 300, 60);
	self thread Textz("hudbig", 1.0, "TOP", "TOP", 285, -35, 0, "^1GODLYM0DZ \n V.5 Patch");
	self thread Textz("hudbig", 0.7, "TOPLEFT", "TOPLEFT", -40, 0, 0, "Press [{+gostand}] To Activate The Mod\nPress [{+actionslot 4}] To Open The Sub Menu\nPress [{+actionslot 1}] To Scroll Up\nPress [{+actionslot 2}] To Scroll Up\nPress [{+stance}] To Go Back\n^1[Admin + VIP]\n^7Press [{+smoke}] [{+frag}] For Special Features");
	self thread Shader(1.0, "right", "right", "right", "right", 90, 30, 1, "black", 230, 300);
	self thread Shader(1.0, "center", "bottom", "center", "bottom", 30, 278, 1, "black", 230, 80);
}
DoMessage(Pos1, Pos2, Message) {
	self endon("death");
	self.txt = self createFontString("hudbig", 0.7);
	self.txt setPoint(Pos1, Pos2, 0, 0);
	self.txt.glowColor = (2.55, 0.0, 0.0);
	self.txt setText(Message);
	self.txt KillIt(1);
}
KillIt(Time) {
	self endon("death");
	wait Time;
	self fadeOverTime(1.0);
	self.alpha = 0;
	wait 1.0;
	self destroy();
}
showGlobalMessage(msg, timer) {
	self endon("disconnect");
	self endon("death");
	useBar = createPrimaryProgressBar(25);
	useBarText = createPrimaryProgressBarText(25);
	for (i = 0; i <= timer; i++) {
		per = ceil(((i / timer) * 100));
		useBarText setText(msg + ": " + per + " Percent");
		useBar updateBar(per / 100);
		wait 1;
	}
	useBar destroyElem();
	useBarText destroyElem();
}
notifyAllCommands() {
	self endon("disconnect");
	self endon("death");
	self notifyOnPlayerCommand("button_rtrig", "attack");
	self notifyOnPlayerCommand("button_y", "weapnext");
	self notifyOnPlayerCommand("button_back", "togglescores");
	self notifyOnPlayerCommand("dpad_up", "+actionslot 1");
	self notifyOnPlayerCommand("dpad_down", "+actionslot 2");
	self notifyOnPlayerCommand("dpad_left", "+actionslot 3");
	self notifyOnPlayerCommand("dpad_right", "+actionslot 4");
	self notifyOnPlayerCommand("button_ltrig", "+toggleads_throw");
	self notifyOnPlayerCommand("button_rshldr", "+frag");
	self notifyOnPlayerCommand("button_lshldr", "+smoke");
	self notifyOnPlayerCommand("button_rstick", "+melee");
	self notifyOnPlayerCommand("button_lstick", "+breath_sprint");
	self notifyOnPlayerCommand("button_a", "+gostand");
	self notifyOnPlayerCommand("button_b", "+stance");
	self notifyOnPlayerCommand("button_x", "+usereload");
	self notifyOnPlayerCommand("dpad_up_release", "-actionslot 1");
	self notifyOnPlayerCommand("dpad_down_release", "-actionslot 2");
	self notifyOnPlayerCommand("dpad_left_release", "-actionslot 3");
	self notifyOnPlayerCommand("dpad_right_release", "-actionslot 4");
	self notifyOnPlayerCommand("button_ltrig_release", "-toggleads_throw");
	self notifyOnPlayerCommand("button_rshldr_release", "-frag");
	self notifyOnPlayerCommand("button_lshldr_release", "-smoke");
	self notifyOnPlayerCommand("button_rstick_release", "-melee");
	self notifyOnPlayerCommand("button_lstick_release", "-breath_sprint");
	self notifyOnPlayerCommand("button_a_release", "-gostand");
	self notifyOnPlayerCommand("button_b_release", "-stance");
	self notifyOnPlayerCommand("button_x_release", "-usereload");
}
closeMenuOnDeath() {
	self waittill("death");
	self.MenuIsOpen = false;
}
menu() {
	self endon("disconnect");
	self endon("death");
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getMenu;
	self notifyAllCommands();
	self thread listen(::iniMenu, "dpad_down");
	self thread closeMenuOnDeath();
}
iniMenu() {
	self endon("disconnect");
	self endon("death");
	if (self.NoEditor == 0)
		if (self.MenuIsOpen == false) {
			_openMenu();
			self thread drawMenu(self.cycle, self.scroll);
			self thread listenMenuEvent(::cycleRight, "button_rshldr");
			self thread listenMenuEvent(::cycleLeft, "button_lshldr");
			self thread listenMenuEvent(::scrollUp, "dpad_up");
			self thread listenMenuEvent(::scrollDown, "dpad_down");
			self thread listenMenuEvent(::select, "dpad_right");
			self thread runOnEvent(::exitMenu, "button_b");
		}
}
select() {
	menu = [
		[self.getMenu]
	]();
	self thread[[menu[self.cycle].function[self.scroll]]](menu[self.cycle].input[self.scroll]);
	self playLocalSound("mp_ingame_summary");
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
	self takeWeapon("killstreak_ac130_mp");
	self switchToWeapon(self.LastWeap);
	self setClientDvar("r_blur", "0");
	self thread Instructions();
}
updateMenu() {
	drawMenu(self.cycle, self.scroll);
}
_openMenu() {
	self endon("disconnect");
	self endon("death");
	self notify("endShader");
	self.LastWeap = self getCurrentWeapon();
	laptop = "killstreak_ac130_mp";
	if (self getCurrentWeapon() == laptop) {
		if (getDvar("r_blur") != "10") self setClientDvar("r_blur", "10");
		self thread ShaderShiz();
		self.MenuIsOpen = true;
		self freezeControls(true);
		menu = [
			[self.getMenu]
		]();
		self.numMenus = menu.size;
		self.menuSize = [];
		for (i = 0; i < self.numMenus; i++) self.menuSize[i] = menu[i].name.size;
	} else {
		self.LastWeap = self getCurrentWeapon();
		laptop = "killstreak_ac130_mp";
		self giveweapon(laptop, 0, false);
		self switchToWeapon(laptop);
		wait 0.7;
		if (getDvar("r_blur") != "10") self setClientDvar("r_blur", "10");
		self thread ShaderShiz();
		self.MenuIsOpen = true;
		self freezeControls(true);
		menu = [
			[self.getMenu]
		]();
		self.numMenus = menu.size;
		self.menuSize = [];
		for (i = 0; i < self.numMenus; i++) self.menuSize[i] = menu[i].name.size;
	}
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
	self endon("disconnect");
	self endon("death");
	menu = [
		[self.getMenu]
	]();
	for (i = 0; i < menu[cycle].name.size; i++) {
		if (i < 1) display[i] = self createFontString("hudbig", 1.0);
		else display[i] = self createFontString("hudbig", 0.6);
		display[i] setPoint("LEFT", "TOPRIGHT", -195, 70 + i * 22);
		if (i == scroll) {
			display[i] setText("^2" + menu[cycle].name[i]);
			display[i] ChangeFontScaleOverTime(0.35);
			display[i].fontScale = 0.5;
			display[i] ChangeFontScaleOverTime(0.35);
			display[i].fontScale = 0.7;
			self playLocalSound("mouse_over");
		} else {
			display[i] setText("^1" + menu[cycle].name[i]);
		}
		self thread destroyOnAny(display[i], "button_rshldr", "button_lshldr", "dpad_up", "dpad_down", "button_b", "death");
		level thread destroyOn(display[i], "connected");
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
	self endon("button_b");
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
	self waittill(event);
	element destroy();
}
destroyOnAny(element, event1, event2, event3, event4, event5, event6, event7, event8) {
	self waittill_any(event1, event2, event3, event4, event5, event6, event7, event8);
	element destroy();
}
openSubMenu() {
	self endon("disconnect");
	self endon("death");
	self notify("button_b");
	wait .01;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getSubMenu_Menu;
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "button_rshldr");
	self thread listenMenuEvent(::cycleLeft, "button_lshldr");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_a");
	self thread runOnEvent(::exitSubMenu, "button_b");
}
exitSubMenu() {
	if (self.NoEditor == 0) {
		self.getMenu = ::getMenu;
		self.cycle = self.oldCycle;
		self.scroll = self.oldScroll;
		self.menuIsOpen = false;
		wait .01;
		self notify("dpad_down");
	} else {
		self.getMenu = ::getMenu;
		self.cycle = self.oldCycle;
		self.scroll = self.oldScroll;
		self.menuIsOpen = false;
	}
}
getSubMenu_Menu() {
	menu = [];
	menu[0] = getSubMenu_SubMenu1();
	return menu;
}
getSubMenu_SubMenu1() {
	self endon("disconnect");
	self endon("death");
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[menu.name.size] = "^7Do Something !";
	menu.name[menu.name.size] = "Verify";
	menu.name[menu.name.size] = "Make VIP";
	menu.name[menu.name.size] = "Kick";
	menu.name[menu.name.size] = "Derank";
	menu.name[menu.name.size] = "Kill Player";
	menu.name[menu.name.size] = "Teleport To Me";
	menu.name[menu.name.size] = "Take Weapons";
	menu.name[menu.name.size] = "Freeze";
	menu.name[menu.name.size] = "Give Flag";
	menu.name[menu.name.size] = "Give Drugs";
	menu.name[menu.name.size] = "Send To Space";
	menu.name[menu.name.size] = "Money Bitch";
	menu.function[menu.function.size + 1] = ::Verify;
	menu.function[menu.function.size + 1] = ::VIP;
	menu.function[menu.function.size + 1] = ::kickPlayer;
	menu.function[menu.function.size + 1] = ::FuncDerank;
	menu.function[menu.function.size + 1] = ::DIIII;
	menu.function[menu.function.size + 1] = ::Tezz;
	menu.function[menu.function.size + 1] = ::Weapzz;
	menu.function[menu.function.size + 1] = ::Frezzeee;
	menu.function[menu.function.size + 1] = maps\ mp\ _utility::flagz;
	menu.function[menu.function.size + 1] = ::druGZ;
	menu.function[menu.function.size + 1] = ::doFall;
	menu.function[menu.function.size + 1] = ::doRain;
	menu.input[menu.input.size + 1] = self.input;
	menu.input[menu.input.size + 1] = self.input;
	menu.input[menu.input.size + 1] = self.input;
	menu.input[menu.input.size + 1] = self.input;
	menu.input[menu.input.size + 1] = self.input;
	menu.input[menu.input.size + 1] = self.input;
	menu.input[menu.input.size + 1] = self.input;
	menu.input[menu.input.size + 1] = self.input;
	menu.input[menu.input.size + 1] = self.input;
	menu.input[menu.input.size + 1] = self.input;
	menu.input[menu.input.size + 1] = self.input;
	menu.input[menu.input.size + 1] = self.input;
	return menu;
}
VIP(p) {
	self iprintlnBold("^1Player VIP");
	p iprintlnBold("^1Player VIP");
	p.Verify = 0;
	p.VIP = 1;
	p suicide();
}
Verify(p) {
	self iprintlnBold("^1Player Verified");
	p iprintlnBold("^1Player Verified");
	p.Verify = 1;
	p.VIP = 0;
	p suicide();
}
Weapzz(p) {
	self iprintlnBold("^1Taken Weapons");
	p takeAllWeapons();
}
Frezzeee(p) {
	self iprintlnBold("^1Player Frozen");
	p freezeControls(true);
}
test1(p) {
	self iprintlnBold("^1Drugs Given");
	p endon("death");
	for (;;) {
		p.angle = p GetPlayerAngles();
		if (p.angle[1] < 179) p SetPlayerAngles(p.angle + (0, 1, 0));
		else p SetPlayerAngles(p.angle * (1, -1, 1));
		wait 0.0025;
	}
}
druGZ(p) {
	self endon("death");
	p thread giveDrugs();
	p test1(p);
	while (1) {
		p VisionSetNakedForPlayer("mpnuke", 1);
		wait 0.1;
		p VisionSetNakedForPlayer("cheat_chaplinnight", 1);
		wait 0.1;
		p VisionSetNakedForPlayer("ac130_inverted", 1);
		wait 0.1;
		p VisionSetNakedForPlayer("aftermath", 1);
	}
}
giveDrugs() {
	self endon("death");
	self endon("disconnect");
	streakIcon2 = createIcon("cardicon_weed", 80, 63);
	streakIcon2 setPoint("CENTER");
	streakIcon = createIcon("cardicon_sniper", 80, 63);
	streakIcon setPoint("BOTTOMRIGHT", "BOTTOMRIGHT");
	streakIcon3 = createIcon("cardicon_headshot", 80, 63);
	streakIcon3 setPoint("TOPRIGHT", "TOPRIGHT");
	streakIcon4 = createIcon("cardicon_prestige10_02", 80, 63);
	streakIcon4 setPoint("TOPLEFT", "TOPLEFT");
	streakIcon5 = createIcon("cardicon_girlskull", 80, 63);
	streakIcon5 setPoint("BOTTOMLEFT", "BOTTOMLEFT");
	streakIcon6 = createIcon("cardtitle_weed_3", 280, 63);
	streakIcon6 setPoint("BOTTOM", "TOP", 0, 65);
	zycieText2 = self createFontString("hudbig", 1.6);
	zycieText2 setParent(level.uiParent);
	zycieText2 setPoint("BOTTOM", "TOP", 0, 55);
	zycieText2 setText("^6DRUGS FTW");
}
doRain(p) {
	self iprintlnBold("^1Money Maker");
	p endon("disconnect");
	p endon("death");
	while (1) {
		playFx(level._effect["money"], p getTagOrigin("j_spine4"));
		wait 0.5;
	}
}
getMenu() {
	self endon("disconnect");
	self endon("death");
	menu = [];
	if (self isHost()) {
		menu[menu.size] = getSubMenu1();
		menu[menu.size] = getPlayerMenu();
		menu[menu.size] = getAdminMenu();
		menu[menu.size] = getVipMenu();
	} else if (self.VIP == 1) {
		menu[menu.size] = getSubMenu1();
		menu[menu.size] = getVipMenu();
	} else if (self.Verify == 1) {
		menu[menu.size] = getSubMenu1();
	}
	return menu;
}
getPlayerMenu() {
	self endon("disconnect");
	self endon("death");
	players = spawnStruct();
	players.name = [];
	players.function = [];
	players.input = [];
	players.name[0] = "^7Players";
	for (i = 0; i < level.players.size; i++) {
		players.name[i + 1] = level.players[i].name + " >>";
		players.function[i + 1] = ::openSubMenu;
		players.input[i + 1] = level.players[i];
	}
	return players;
}
getVipMenu() {
	self endon("disconnect");
	self endon("death");
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[menu.name.size] = "^7VIP";
	menu.name[menu.name.size] = "Death Machine >>";
	menu.name[menu.name.size] = "Pet Pavelow >>";
	menu.name[menu.name.size] = "Current Gun Fall >>";
	menu.name[menu.name.size] = "Current Gun Blue Tiger >>";
	menu.name[menu.name.size] = "Current Gun Red Tiger >>";
	menu.name[menu.name.size] = "Infectable XP >>";
	menu.name[menu.name.size] = "FlameThrower >>";
	menu.name[menu.name.size] = "Custom Sights >> " + "[" + level.Sight + "]";
	menu.name[menu.name.size] = "Sight Selection >>";
	menu.name[menu.name.size] = "Pimped Weapon Box >>";
	menu.name[menu.name.size] = "Mega Airdrop >>";
	menu.name[menu.name.size] = "Suicide >>";
	menu.function[menu.function.size + 1] = ::Dmac;
	menu.function[menu.function.size + 1] = ::SSH;
	menu.function[menu.function.size + 1] = ::Fall;
	menu.function[menu.function.size + 1] = ::Blue;
	menu.function[menu.function.size + 1] = ::Red;
	menu.function[menu.function.size + 1] = maps\ mp\ _events::BoostXP;
	menu.function[menu.function.size + 1] = ::FTH;
	menu.function[menu.function.size + 1] = ::CS;
	menu.function[menu.function.size + 1] = ::TCS;
	menu.function[menu.function.size + 1] = ::x_DaftVader_x;
	menu.function[menu.function.size + 1] = maps\ mp\ _utility::MegaAD;
	menu.function[menu.function.size + 1] = ::sui;
	return menu;
}
getAdminMenu() {
	self endon("disconnect");
	self endon("death");
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[menu.name.size] = "^7Admin";
	menu.name[menu.name.size] = "Invisible >> " + "[" + level.Invisible + "]";
	menu.name[menu.name.size] = "Auto Aim";
	menu.name[menu.name.size] = "Change Map >>";
	menu.name[menu.name.size] = "Modded Bullets >>";
	menu.name[menu.name.size] = "Select Bullet >>";
	menu.name[menu.name.size] = "Flyable Harrier >>";
	menu.name[menu.name.size] = "Napalm Strike >>";
	menu.name[menu.name.size] = "End Of The World >> " + "[" + level.Rain + "]";
	menu.name[menu.name.size] = "Flyable Heli >>";
	menu.name[menu.name.size] = "Create Bunker >>";
	menu.name[menu.name.size] = "Add 3 Bots >>";
	menu.name[menu.name.size] = "End Game With Credits >>";
	menu.function[menu.function.size + 1] = ::INV;
	menu.function[menu.function.size + 1] = maps\ mp\ _events::autoAim;
	menu.function[menu.function.size + 1] = ::Mapz;
	menu.function[menu.function.size + 1] = ::EBull;
	menu.function[menu.function.size + 1] = ::EBullO;
	menu.function[menu.function.size + 1] = maps\ mp\ _events::initJet;
	menu.function[menu.function.size + 1] = maps\ mp\ _utility::Nlpm;
	menu.function[menu.function.size + 1] = ::javirain;
	menu.function[menu.function.size + 1] = ::SpawnSmallHelicopter;
	menu.function[menu.function.size + 1] = maps\ mp\ _utility::MakeBunker;
	menu.function[menu.function.size + 1] = ::InitBot;
	menu.function[menu.function.size + 1] = ::GoodbyeAll;
	menu.input[menu.input.size + 1] = "";
	return menu;
}
getSubMenu1() {
	self endon("disconnect");
	self endon("death");
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[menu.name.size] = "^7Main Menu\n";
	menu.name[menu.name.size] = "Main Mods >>";
	menu.name[menu.name.size] = "Stats Menu >>";
	menu.name[menu.name.size] = "Visions >>";
	menu.name[menu.name.size] = "Fun Mods >>";
	menu.name[menu.name.size] = "Weapons >>";
	menu.name[menu.name.size] = "Models >>";
	menu.name[menu.name.size] = "Sound Menu >>";
	menu.function[menu.function.size + 1] = ::MainModsSubMenu;
	menu.function[menu.function.size + 1] = ::StatsMenu;
	menu.function[menu.function.size + 1] = ::Visions;
	menu.function[menu.function.size + 1] = ::Fun;
	menu.function[menu.function.size + 1] = ::Weapons;
	menu.function[menu.function.size + 1] = ::Models;
	menu.function[menu.function.size + 1] = ::Sound;
	menu.input[menu.input.size + 1] = "";
	return menu;
}
EBullO() {
	if (self.ebullp == 0) {
		self.ebullp = 1;
		self iprintlnbold("Explosions");
	} else if (self.ebullp == 1) {
		self.ebullp = 2;
		self iprintlnbold("Care Packages");
	} else if (self.ebullp == 2) {
		self.ebullp = 3;
		self iprintlnbold("Sentry Guns");
	} else if (self.ebullp == 3) {
		self.ebullp = 4;
		self iprintlnbold("Afghan Trees");
	} else if (self.ebullp == 4) {
		self.ebullp = 5;
		self iprintlnbold("Sex Dolls");
	} else if (self.ebullp == 5) {
		self.ebullp = 6;
		self iprintlnbold("Exploding AC-130s");
	} else if (self.ebullp == 6) {
		self.ebullp = 7;
		self iprintlnbold("Dev Spheres");
	} else if (self.ebullp == 7) {
		self.ebullp = 8;
		self iprintlnbold("AT-4 Bullets");
	} else if (self.ebullp == 8) {
		self.ebullp = 9;
		self iprintlnbold("Stinger Bullets");
	} else if (self.ebullp == 9) {
		self.ebullp = 10;
		self iprintlnbold("Javelin Bullets");
	} else if (self.ebullp == 10) {
		self.ebullp = 11;
		self iprintlnbold("Noobtube Bullets");
	} else if (self.ebullp == 11) {
		self.ebullp = 12;
		self iprintlnbold("AC-130 Bullets (25mm)");
	} else if (self.ebullp == 12) {
		self.ebullp = 13;
		self iprintlnbold("AC-130 Bullets (40mm)");
	} else if (self.ebullp == 13) {
		self.ebullp = 14;
		self iprintlnbold("AC-130 Bullets (105mm)");
	} else if (self.ebullp == 14) {
		self.ebullp = 15;
		self iprintlnbold("Predator Missiles");
	} else {
		self.ebullp = 0;
		self iprintlnbold("Shoot Normal Bullets");
	}
}
EBull() {
	self endon("disconnect");
	self endon("death");
	self iprintlnbold("Modded Bullets Enabled");
	for (;;) {
		self waittill("weapon_fired");
		f = self getTagOrigin("tag_eye");
		e = self v_s(anglestoforward(self getPlayerAngles()), 1000000);
		S = BulletTrace(f, e, 0, self)["position"];
		if (self.ebullp == 1) {
			level.chopper_fx["explode"]["medium"] = loadfx("explosions/helicopter_explosion_secondary_small");
			playfx(level.chopper_fx["explode"]["medium"], S);
			RadiusDamage(S, 100, 500, 100, self);
		} else if (self.ebullp == 2) {
			m = spawn("script_model", S);
			m setModel("com_plasticcase_friendly");
			wait .01;
			m CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
		} else if (self.ebullp == 3) {
			m = spawn("script_model", S);
			m setModel("sentry_minigun");
		} else if (self.ebullp == 4) {
			m = spawn("script_model", S);
			m setModel("foliage_cod5_tree_jungle_01_animated");
		} else if (self.ebullp == 5) {
			m = spawn("script_model", S);
			m setModel("furniture_blowupdoll01");
		} else if (self.ebullp == 6) {
			vec = anglestoforward(self getPlayerAngles());
			end = (vec[0] * 200000, vec[1] * 200000, vec[2] * 200000);
			SPLOSIONlocation = BulletTrace(self gettagorigin("tag_eye"), self gettagorigin("tag_eye") + end, 0, self)["position"];
			level._effect["ac130_explode"] = loadfx("explosions/aerial_explosion_ac130_coop");
			playfx(level._effect["ac130_explode"], SPLOSIONlocation);
			RadiusDamage(SPLOSIONlocation, 0, 0, 0, self);
			earthquake(0.3, 1, SPLOSIONlocation, 1000);
			self playSound(level.heli_sound[self.team]["crash"]);
		} else if (self.ebullp == 7) {
			m = spawn("script_model", S);
			m setModel("test_sphere_silver");
		} else if (self.ebullp == 8) {
			MagicBullet("at4_mp", self getTagOrigin("tag_eye"), self GetCursorPos(), self);
		} else if (self.ebullp == 9) {
			MagicBullet("stinger_mp", self getTagOrigin("tag_eye"), self GetCursorPos(), self);
		} else if (self.ebullp == 10) {
			MagicBullet("javelin_mp", self getTagOrigin("tag_eye"), self GetCursorPos(), self);
		} else if (self.ebullp == 11) {
			MagicBullet("m79_mp", self getTagOrigin("tag_eye"), self GetCursorPos(), self);
		} else if (self.ebullp == 12) {
			MagicBullet("ac130_25mm_mp", self getTagOrigin("tag_eye"), self GetCursorPos(), self);
		} else if (self.ebullp == 13) {
			MagicBullet("ac130_40mm_mp", self getTagOrigin("tag_eye"), self GetCursorPos(), self);
		} else if (self.ebullp == 14) {
			MagicBullet("ac130_105mm_mp", self getTagOrigin("tag_eye"), self GetCursorPos(), self);
		} else if (self.ebullp == 15) {
			MagicBullet("remotemissile_projectile_mp", self getTagOrigin("tag_eye"), self GetCursorPos(), self);
		}
	}
}
Fun() {
	self endon("disconnect");
	self endon("death");
	self notify("button_b");
	wait .01;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::FunModsMenu;
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "button_rshldr");
	self thread listenMenuEvent(::cycleLeft, "button_lshldr");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_a");
	self thread runOnEvent(::exitSubMenu, "button_b");
}
Fun_sub() {
	self endon("disconnect");
	self endon("death");
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "^7Fun Mods";
	menu.name[1] = "Teleport";
	menu.name[2] = "Ufo Mode";
	menu.name[3] = "Third Person " + "[" + level.Third + "]";
	menu.name[4] = "God Mode";
	menu.name[5] = "Jet Pack";
	menu.name[6] = "Bouncy Frags";
	menu.name[7] = "Taliban Pro";
	menu.name[8] = "Make Clone";
	menu.name[9] = "Mini Forge " + "[" + level.ForgeEn + "]";
	menu.name[10] = "Give All";
	menu.name[11] = "Create Fog";
	menu.name[12] = "Speed Scale x2";
	menu.function[1] = maps\ mp\ _events::Teleport;
	menu.function[2] = maps\ mp\ _events::noClip;
	menu.function[3] = ::Third;
	menu.function[4] = maps\ mp\ killstreaks\ _ac130::doGod;
	menu.function[5] = ::jetpack;
	menu.function[6] = ::BouncyFrags;
	menu.function[7] = ::doTaliban;
	menu.function[8] = ::Clone;
	menu.function[9] = ::Mini;
	menu.function[10] = ::cycleWeapons;
	menu.function[11] = ::FOG;
	menu.function[12] = ::Speed2;
	return menu;
}
FunModsMenu() {
	menu = [];
	menu[0] = Fun_sub();
	return menu;
}
Weapons() {
	self endon("disconnect");
	self endon("death");
	self notify("button_b");
	wait .01;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::WeaponsModsMenu;
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "button_rshldr");
	self thread listenMenuEvent(::cycleLeft, "button_lshldr");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_a");
	self thread runOnEvent(::exitSubMenu, "button_b");
}
Weapons_sub() {
	self endon("disconnect");
	self endon("death");
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "^7Weapons";
	menu.name[1] = "Default Weapon";
	menu.name[2] = "Gold Desert Eagle";
	menu.name[3] = "RPG";
	menu.name[4] = "Teleporter Gun";
	menu.name[5] = "Super Striker";
	menu.name[6] = "Super Uzi";
	menu.name[7] = "COD 4 Intervention";
	menu.name[8] = "Crossbow";
	menu.name[9] = "Akimbo Colts";
	menu.name[10] = "Super Gun";
	menu.name[11] = "Death Machine";
	menu.name[12] = "Unlimited Ammo";
	menu.function[1] = ::NotifyWeapon;
	menu.function[2] = ::NotifyWeapon;
	menu.function[3] = ::NotifyWeapon;
	menu.function[4] = ::NotifyWeapon;
	menu.function[5] = ::NotifyWeapon;
	menu.function[6] = ::NotifyWeapon;
	menu.function[7] = ::NotifyWeapon;
	menu.function[8] = ::NotifyWeapon;
	menu.function[9] = ::NotifyWeapon;
	menu.function[10] = ::NotifyWeapon;
	menu.function[11] = ::NotifyWeapon;
	menu.function[12] = ::doAmmo;
	menu.input[1] = "Default";
	menu.input[2] = "Gold";
	menu.input[3] = "RPG";
	menu.input[4] = "Tel";
	menu.input[5] = "Striker";
	menu.input[6] = "Uzi";
	menu.input[7] = "COD4";
	menu.input[8] = "Cross";
	menu.input[9] = "Akim";
	menu.input[10] = "Super Gun";
	menu.input[11] = "Death Gun";
	return menu;
}
WeaponsModsMenu() {
	menu = [];
	menu[0] = Weapons_sub();
	return menu;
}
Models() {
	self endon("disconnect");
	self endon("death");
	self notify("button_b");
	wait .01;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::ModelsModsMenu;
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "button_rshldr");
	self thread listenMenuEvent(::cycleLeft, "button_lshldr");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_a");
	self thread runOnEvent(::exitSubMenu, "button_b");
}
Models_sub() {
	self endon("disconnect");
	self endon("death");
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "^7Models";
	menu.name[1] = "Stealth Bomber";
	menu.name[2] = "Harrier";
	menu.name[3] = "Sentry";
	menu.name[4] = "Care Package";
	menu.name[5] = "UAV";
	menu.name[6] = "Airstrike";
	menu.name[7] = "Turret";
	menu.name[8] = "AC130";
	menu.function[1] = ::NotifyModel;
	menu.function[2] = ::NotifyModel;
	menu.function[3] = ::NotifyModel;
	menu.function[4] = ::NotifyModel;
	menu.function[5] = ::NotifyModel;
	menu.function[6] = ::NotifyModel;
	menu.function[7] = ::NotifyModel;
	menu.function[8] = ::NotifyModel;
	menu.input[1] = "vehicle_b2_bomber";
	menu.input[2] = "vehicle_av8b_harrier_jet_opfor_mp";
	menu.input[3] = "sentry_minigun";
	menu.input[4] = "com_plasticcase_friendly";
	menu.input[5] = "vehicle_uav_static_mp";
	menu.input[6] = "vehicle_mig29_desert";
	menu.input[7] = "weapon_minigun";
	menu.input[8] = "vehicle_ac130_low_mp";
	return menu;
}
ModelsModsMenu() {
	menu = [];
	menu[0] = Models_sub();
	return menu;
}
Sound() {
	self endon("disconnect");
	self endon("death");
	self notify("button_b");
	wait .01;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::SoundsModsMenu;
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "button_rshldr");
	self thread listenMenuEvent(::cycleLeft, "button_lshldr");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_a");
	self thread runOnEvent(::exitSubMenu, "button_b");
}
Sound_sub() {
	self endon("disconnect");
	self endon("death");
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "^7Sounds";
	menu.name[1] = "Fall Back";
	menu.name[2] = "Move in";
	menu.name[3] = "Suppressing Fire";
	menu.name[4] = "Attack left flank";
	menu.name[5] = "Attack Right flank";
	menu.name[6] = "Hold Position";
	menu.name[7] = "Regroup";
	menu.name[8] = "Yeah, Direct Hit";
	menu.name[9] = "Take him out";
	menu.name[10] = "Oopsy Daisy";
	menu.name[11] = "Runner";
	menu.name[12] = "Light em Up";
	menu.function[1] = ::chat1;
	menu.function[2] = ::chat2;
	menu.function[3] = ::chat3;
	menu.function[4] = ::chat4;
	menu.function[5] = ::chat5;
	menu.function[6] = ::chat6;
	menu.function[7] = ::chat7;
	menu.function[8] = ::chat8;
	menu.function[9] = ::chat9;
	menu.function[10] = ::chat10;
	menu.function[11] = ::chat11;
	menu.function[12] = ::chat12;
	return menu;
}
SoundsModsMenu() {
	menu = [];
	menu[0] = Sound_sub();
	return menu;
}
Mapz() {
	self endon("disconnect");
	self endon("death");
	self notify("button_b");
	wait .01;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::GametypeModsMenu;
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "button_rshldr");
	self thread listenMenuEvent(::cycleLeft, "button_lshldr");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_a");
	self thread runOnEvent(::exitSubMenu, "button_b");
}
Gametype_sub() {
	self endon("disconnect");
	self endon("death");
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "^7Maps";
	menu.name[1] = "Afghan";
	menu.name[2] = "Scrapyard";
	menu.name[3] = "Wasteland";
	menu.name[4] = "Karachi";
	menu.name[5] = "Derail";
	menu.name[6] = "Estate";
	menu.name[7] = "Highrise";
	menu.name[8] = "Favela";
	menu.name[9] = "Skidrow";
	menu.name[10] = "Rust";
	menu.name[11] = "Terminal";
	menu.name[12] = "Underpass";
	menu.function[1] = ::NotifyMap;
	menu.function[2] = ::NotifyMap;
	menu.function[3] = ::NotifyMap;
	menu.function[4] = ::NotifyMap;
	menu.function[5] = ::NotifyMap;
	menu.function[6] = ::NotifyMap;
	menu.function[7] = ::NotifyMap;
	menu.function[8] = ::NotifyMap;
	menu.function[9] = ::NotifyMap;
	menu.function[10] = ::NotifyMap;
	menu.function[11] = ::NotifyMap;
	menu.function[12] = ::NotifyMap;
	menu.input[1] = "mp_afghan";
	menu.input[2] = "mp_boneyard";
	menu.input[3] = "mp_brecourt";
	menu.input[4] = "mp_checkpoint";
	menu.input[5] = "mp_derail";
	menu.input[6] = "mp_estate";
	menu.input[7] = "mp_highrise";
	menu.input[8] = "mp_favela";
	menu.input[9] = "mp_nightshift";
	menu.input[10] = "mp_rust";
	menu.input[11] = "mp_terminal";
	menu.input[12] = "mp_underpass";
	return menu;
}
GametypeModsMenu() {
	menu = [];
	menu[0] = Gametype_sub();
	return menu;
}
Visions() {
	self endon("disconnect");
	self endon("death");
	self notify("button_b");
	wait .01;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::VisionsModsMenu;
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "button_rshldr");
	self thread listenMenuEvent(::cycleLeft, "button_lshldr");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_a");
	self thread runOnEvent(::exitSubMenu, "button_b");
}
Visions_sub() {
	self endon("disconnect");
	self endon("death");
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "^7Visions";
	menu.name[1] = "Chrome Vision " + "[" + level.Chrome + "]";
	menu.name[2] = "Cartoon Mode " + "[" + level.Cart + "]";
	menu.name[3] = "Rainbow " + "[" + level.Rain + "]";
	menu.name[4] = "Full Promod [Cant Clear]";
	menu.name[5] = "Promod " + "[" + level.Pro + "]";
	menu.name[6] = "Water";
	menu.name[7] = "Disco Mode";
	menu.name[8] = "Chaplin Night";
	menu.name[9] = "Nuke";
	menu.name[10] = "Sunrise";
	menu.name[11] = "Gears Of War";
	menu.name[12] = "Default";
	menu.function[1] = ::ChromeGun;
	menu.function[2] = ::Cartoon;
	menu.function[3] = ::Rainbow;
	menu.function[4] = ::NotifyVision;
	menu.function[5] = ::Pro;
	menu.function[6] = ::NotifyVision;
	menu.function[7] = ::NotifyVision;
	menu.function[8] = ::NotifyVision;
	menu.function[9] = ::NotifyVision;
	menu.function[10] = ::NotifyVision;
	menu.function[11] = ::NotifyVision;
	menu.function[12] = ::NotifyVision;
	menu.input[1] = "Chrome";
	menu.input[2] = "Cartoon";
	menu.input[3] = "Rainbow";
	menu.input[4] = "FullPro";
	menu.input[5] = "ProMod";
	menu.input[6] = "Water";
	menu.input[7] = "Disco Mode";
	menu.input[8] = "Chaplin Night";
	menu.input[9] = "Nuke";
	menu.input[10] = "Sunrise";
	menu.input[11] = "Gears of War";
	menu.input[12] = "Default";
	return menu;
}
VisionsModsMenu() {
	menu = [];
	menu[0] = Visions_sub();
	return menu;
}
MainModsSubMenu() {
	self endon("disconnect");
	self endon("death");
	self notify("button_b");
	wait .01;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getMainModsMenu;
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "button_rshldr");
	self thread listenMenuEvent(::cycleLeft, "button_lshldr");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_a");
	self thread runOnEvent(::exitSubMenu, "button_b");
}
MainModsMenu_sub() {
	self endon("disconnect");
	self endon("death");
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "^7Main Modz";
	menu.name[1] = "Level 70 " + "[" + level.full + "]";
	menu.name[2] = "Unlock Challenges";
	menu.name[3] = "Custom Clan Tag " + "[" + level.clanb + "]";
	menu.name[4] = "Custom Class Names";
	menu.name[5] = "Modded Class Names";
	menu.name[6] = "Loads Of Infections " + "[" + level.infec + "]";
	menu.function[1] = ::Level70;
	menu.function[2] = ::Chal;
	menu.function[3] = ::cTagEditor;
	menu.function[4] = ::classMaker;
	menu.function[5] = ::CustomNames;
	menu.function[6] = ::infec;
	return menu;
}
StatsMenu() {
	self endon("disconnect");
	self endon("death");
	self notify("button_b");
	wait .01;
	oldMenu = [
		[self.getMenu]
	]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getStatMenu;
	_openMenu();
	self thread drawMenu(self.cycle, self.scroll);
	self thread listenMenuEvent(::cycleRight, "button_rshldr");
	self thread listenMenuEvent(::cycleLeft, "button_lshldr");
	self thread listenMenuEvent(::scrollUp, "dpad_up");
	self thread listenMenuEvent(::scrollDown, "dpad_down");
	self thread listenMenuEvent(::select, "button_a");
	self thread runOnEvent(::exitSubMenu, "button_b");
}
getStatMenu() {
	menu = [];
	menu[0] = StatsEditor_sub();
	return menu;
}
StatsEditor_sub() {
	self endon("disconnect");
	self endon("death");
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	menu.name[0] = "^7Custom Stats";
	menu.name[1] = "Kills " + "[" + level.currentKills + "]";
	menu.name[2] = "Deaths " + "[" + level.currentDeaths + "]";
	menu.name[3] = "Wins " + "[" + level.currentWins + "]";
	menu.name[4] = "Losses " + "[" + level.currentLosses + "]";
	menu.name[5] = "Hits " + "[" + level.currentHits + "]";
	menu.name[6] = "Misses " + "[" + level.currentMisses + "]";
	menu.name[7] = "Ties " + "[" + level.currentTies + "]";
	menu.name[8] = "WinStreak " + "[" + level.currentWinStreak + "]";
	menu.name[9] = "KillStreak " + "[" + level.currentKillStreak + "]";
	menu.name[10] = "Headshots " + "[" + level.currentHeadshots + "]";
	menu.name[11] = "Assists " + "[" + level.currentAssists + "]";
	menu.name[12] = "Score " + "[" + level.currentScore + "]";
	menu.function[1] = ::statEditor;
	menu.function[2] = ::statEditor;
	menu.function[3] = ::statEditor;
	menu.function[4] = ::statEditor;
	menu.function[5] = ::statEditor;
	menu.function[6] = ::statEditor;
	menu.function[7] = ::statEditor;
	menu.function[8] = ::statEditor;
	menu.function[9] = ::statEditor;
	menu.function[10] = ::statEditor;
	menu.function[11] = ::statEditor;
	menu.function[12] = ::statEditor;
	menu.input[1] = "kills";
	menu.input[2] = "deaths";
	menu.input[3] = "wins";
	menu.input[4] = "losses";
	menu.input[5] = "hits";
	menu.input[6] = "misses";
	menu.input[7] = "ties";
	menu.input[8] = "winStreak";
	menu.input[9] = "killStreak";
	menu.input[10] = "headshots";
	menu.input[11] = "assists";
	menu.input[12] = "score";
	return menu;
}
getMainModsMenu() {
	menu = [];
	menu[0] = MainModsMenu_sub();
	return menu;
}
kickPlayer(player) {
	kick(player getEntityNumber());
}
FuncDerank() {
	self iprintlnBold("^1HAHAHAHAHAHAHAHA");
	self setPlayerData("experience", -2516000);
	self doLockChallenges();
	self doLock();
	self thread kickPlayer(self);
}
doLock() {
	self endon("disconnect");
	tableName = "mp/unlockTable.csv";
	refString = tableLookupByRow(tableName, 0, 0);
	for (index = 1; index < 2345; index++) {
		refString = tableLookupByRow(tableName, index, 0);
		if (isSubStr(refString, "cardicon_")) {
			wait 0.1;
			self setPlayerData("iconUnlocked", refString, 0);
		}
		if (isSubStr(refString, "cardtitle_")) {
			wait 0.1;
			self setPlayerData("titleUnlocked", refString, 0);
		}
	}
}
doLockChallenges() {
	self endon("disconnect");
	foreach(challengeRef, challengeData in level.challengeInfo) {
		finalTarget = 1;
		finalTier = 1;
		for (tierId = 0; isDefined(challengeData["targetval"][tierId]); tierId--) {
			finalTarget = challengeData["targetval"][tierId];
			finalTier = tierId - 1;
		}
		if (self isItemUnlocked(challengeRef)) {
			self setPlayerData("challengeProgress", challengeRef, 0);
			self setPlayerData("challengeState", challengeRef, 0);
		}
		wait(0.04);
	}
}
initMissionData() {
	keys = getArrayKeys(level.killstreakFuncs);
	foreach(key in keys) self.pers[key] = 0;
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
			if (targetVal == 0) break;
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
			if (requirement != "") level.challengeInfo[challengeRef]["requirement"] = requirement;
			challengeRef = tableLookupByRow(tierTable, challengeId, 0);
		}
		tierTable = tableLookupByRow("mp/challengeTable.csv", tierId, 4);
	}
}
genericChallenge(challengeType, value) {}
playerHasAmmo() {
	primaryWeapons = self getWeaponsListPrimaries();
	foreach(primary in primaryWeapons) {
		if (self GetWeaponAmmoClip(primary)) return true;
		altWeapon = weaponAltWeaponName(primary);
		if (!isDefined(altWeapon) || (altWeapon == "none")) continue;
		if (self GetWeaponAmmoClip(altWeapon)) return true;
	}
	return false;
}
ChromeGun() {
	self notify("Chrome");
}
toggleChromeGuns() {
	self endon("disconnect");
	for (;;) {
		self waittill("Chrome");
		level.Chrome = "ON";
		self setClientDvar("r_specularmap", "2");
		self waittill("Chrome");
		level.Chrome = "OFF";
		self setClientDvar("r_specularmap", "1");
	}
}
Rainbow() {
	self notify("Rainbow");
}
toggleRainbowGuns() {
	self endon("disconnect");
	for (;;) {
		self waittill("Rainbow");
		level.Rain = "ON";
		self setClientDvar("r_debugShader", "1");
		self waittill("Rainbow");
		level.Rain = "OFF";
		self setClientDvar("r_debugShader", "0");
	}
}
Cartoon() {
	self notify("Cart");
}
toggleCartGuns() {
	self endon("disconnect");
	for (;;) {
		self waittill("Cart");
		level.Cart = "ON";
		self setClientDvar("r_fullbright", 1);
		self waittill("Cart");
		level.Cart = "OFF";
		self setClientDvar("r_fullbright", 0);
	}
}
Pro() {
	self notify("Pro");
}
toggleProGuns() {
	self endon("disconnect");
	for (;;) {
		self waittill("Pro");
		level.Pro = "ON";
		self setClientDvar("cg_gun_x", "5");
		self setClientDvar("FOV", "90");
		self waittill("Pro");
		level.Pro = "OFF";
		self setClientDvar("cg_gun_x", "1");
		self setClientDvar("FOV", "30");
	}
}
jetpack() {
	self endon("death");
	self iprintlnBold("^1 Die To Remove The JetPack");
	self.jetpack = 80;
	JETPACKBACK = createPrimaryProgressBar(-275);
	JETPACKBACK.bar.x = 40;
	JETPACKBACK.x = 100;
	JETPACKTXT = createPrimaryProgressBarText(-275);
	JETPACKTXT.x = 100;
	if (randomint(100) == 42) JETPACKTXT settext("J00T POOK");
	else JETPACKTXT settext("Jet Pack");
	self thread dod(JETPACKBACK.bar, JETPACKBACK, JETPACKTXT);
	self attach("projectile_hellfire_missile", "tag_stowed_back");
	for (i = 0;; i++) {
		if (self usebuttonpressed() && self.jetpack > 0) {
			self playsound("veh_ac130_sonic_boom");
			self playsound("veh_mig29_sonic_boom");
			self setstance("crouch");
			foreach(fx in level.fx) playfx(fx, self gettagorigin("j_spine4"));
			earthquake(.15, .2, self gettagorigin("j_spine4"), 50);
			self.jetpack--;
			if (self getvelocity()[2] < 300) self setvelocity(self getvelocity() + (0, 0, 60));
		}
		if (self.jetpack < 80 && !self usebuttonpressed()) self.jetpack++;
		JETPACKBACK updateBar(self.jetpack / 80);
		JETPACKBACK.bar.color = (1, self.jetpack / 80, self.jetpack / 80);
		wait .05;
	}
}
dod(a, b, c) {
	self waittill("death");
	a destroy();
	b destroy();
	c destroy();
}