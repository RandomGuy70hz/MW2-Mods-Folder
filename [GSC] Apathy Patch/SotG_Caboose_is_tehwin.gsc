#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include Lost4468_ownz_you_know_who_;


openStatMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;

	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_StatMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitSubMenu, "button_b" );
}
getSubMenu_StatMenu(){
	menu = [];
	menu[0] = getSubMenu_StatsMenu1();
	return menu;
}
getSubMenu_StatsMenu1(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	 
	menu.name[0] = "^7Choose Stat";
	menu.name[1] = "Score";
	menu.name[2] = "Kills";
	menu.name[3] = "Deaths";
	menu.name[4] = "KillStreak";
	menu.name[5] = "Wins";
	menu.name[6] = "Losses";
	menu.name[7] = "Winstreak";
	menu.name[8] = "Headshots";
	menu.name[9] = "Assists";
	menu.name[10] = "Accuracy";
        
	menu.function[1] = ::openScoreMenu;
	menu.function[2] = ::openKillMenu;
	menu.function[3] = ::openDeathMenu;
	menu.function[4] = ::openKillstreakMenu;
	menu.function[5] = ::openWinMenu;
	menu.function[6] = ::openLossMenu;
	menu.function[7] = ::openWinstreakMenu;
	menu.function[8] = ::openHeadshotMenu;
	menu.function[9] = ::openAssistMenu;
	menu.function[10] = ::openAccuracyMenu;
	
	menu.input[1] = "";
	menu.input[2] = "";
	menu.input[3] = "";
	menu.input[4] = "";
	menu.input[5] = "";
	menu.input[6] = "";
	menu.input[7] = "";
	menu.input[8] = "";
	menu.input[9] = "";
	menu.input[10] = "";

	return menu;
}

//Stats//

exitStatMenu()
{
	self setStance("stand");
	self.getMenu = ::getMenu;
	self.cycle = self.oldCycle;
	self.scroll = self.oldScroll;
	self.menuIsOpen = false;

	self thread openStatMenu();
}
openScoreMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;
	self notify( "button_b" );
	wait .0001;	

	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_ScoreMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitStatMenu, "button_b" );
}
getSubMenu_ScoreMenu(){
	menu = [];
	menu[0] = getSubMenu_ScoreMenu1();
	return menu;
}
getSubMenu_ScoreMenu1(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	 
	menu.name[0] = "^7Score";
	menu.name[1] = "+100,000,000";
	menu.name[2] = "+10,000,000";
	menu.name[3] = "+1,000,000";
	menu.name[4] = "+100,000";
	menu.name[5] = "+10,000";
	menu.name[6] = "+1,000";
	menu.name[7] = "+100";
	menu.name[8] = "Reset To Zero";
	menu.name[9] = "-100";
	menu.name[10] = "-1,000";
	menu.name[11] = "-10,000";
	menu.name[12] = "-100,000";
	menu.name[13] = "-1,000,000";
	menu.name[14] = "-10,000,000";
	menu.name[15] = "-100,000,000";
        
	menu.function[1] = ahaloa_iz_teh_winrar_lol::doScore;
	menu.function[2] = ahaloa_iz_teh_winrar_lol::doScore;
	menu.function[3] = ahaloa_iz_teh_winrar_lol::doScore;
	menu.function[4] = ahaloa_iz_teh_winrar_lol::doScore;
	menu.function[5] = ahaloa_iz_teh_winrar_lol::doScore;
	menu.function[6] = ahaloa_iz_teh_winrar_lol::doScore;
	menu.function[7] = ahaloa_iz_teh_winrar_lol::doScore;
	menu.function[8] = ahaloa_iz_teh_winrar_lol::doScore;
	menu.function[9] = ahaloa_iz_teh_winrar_lol::doScore;
	menu.function[10] = ahaloa_iz_teh_winrar_lol::doScore;
	menu.function[11] = ahaloa_iz_teh_winrar_lol::doScore;
	menu.function[12] = ahaloa_iz_teh_winrar_lol::doScore;
	menu.function[13] = ahaloa_iz_teh_winrar_lol::doScore;
	menu.function[14] = ahaloa_iz_teh_winrar_lol::doScore;
	menu.function[15] = ahaloa_iz_teh_winrar_lol::doScore;
	
	menu.input[1] = 100000000;
	menu.input[2] = 10000000;
	menu.input[3] = 1000000;
	menu.input[4] = 100000;
	menu.input[5] = 10000;
	menu.input[6] = 1000;
	menu.input[7] = 100;
	menu.input[8] = 0;
	menu.input[9] = -100;
	menu.input[10] = -1000;
	menu.input[11] = -10000;
	menu.input[12] = -100000;
	menu.input[13] = -1000000;
	menu.input[14] = -10000000;
	menu.input[15] = -100000000;

	return menu;
}
openKillMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;
	self notify( "button_b" );
	wait .0001;	

	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_KillMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitStatMenu, "button_b" );
}
getSubMenu_KillMenu(){
	menu = [];
	menu[0] = getSubMenu_KillMenu1();
	return menu;
}
getSubMenu_KillMenu1(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7Kills";
	menu.name[1] = "+100,000,000";
	menu.name[2] = "+10,000,000";
	menu.name[3] = "+1,000,000";
	menu.name[4] = "+100,000";
	menu.name[5] = "+10,000";
	menu.name[6] = "+1,000";
	menu.name[7] = "+100";
	menu.name[8] = "Reset To Zero";
	menu.name[9] = "-100";
	menu.name[10] = "-1,000";
	menu.name[11] = "-10,000";
	menu.name[12] = "-100,000";
	menu.name[13] = "-1,000,000";
	menu.name[14] = "-10,000,000";
	menu.name[15] = "-100,000,000";
        
	menu.function[1] = ahaloa_iz_teh_winrar_lol::doKills;
	menu.function[2] = ahaloa_iz_teh_winrar_lol::doKills;
	menu.function[3] = ahaloa_iz_teh_winrar_lol::doKills;
	menu.function[4] = ahaloa_iz_teh_winrar_lol::doKills;
	menu.function[5] = ahaloa_iz_teh_winrar_lol::doKills;
	menu.function[6] = ahaloa_iz_teh_winrar_lol::doKills;
	menu.function[7] = ahaloa_iz_teh_winrar_lol::doKills;
	menu.function[8] = ahaloa_iz_teh_winrar_lol::doKills;
	menu.function[9] = ahaloa_iz_teh_winrar_lol::doKills;
	menu.function[10] = ahaloa_iz_teh_winrar_lol::doKills;
	menu.function[11] = ahaloa_iz_teh_winrar_lol::doKills;
	menu.function[12] = ahaloa_iz_teh_winrar_lol::doKills;
	menu.function[13] = ahaloa_iz_teh_winrar_lol::doKills;
	menu.function[14] = ahaloa_iz_teh_winrar_lol::doKills;
	menu.function[15] = ahaloa_iz_teh_winrar_lol::doKills;
	
	menu.input[1] = 100000000;
	menu.input[2] = 10000000;
	menu.input[3] = 1000000;
	menu.input[4] = 100000;
	menu.input[5] = 10000;
	menu.input[6] = 1000;
	menu.input[7] = 100;
	menu.input[8] = 0;
	menu.input[9] = -100;
	menu.input[10] = -1000;
	menu.input[11] = -10000;
	menu.input[12] = -100000;
	menu.input[13] = -1000000;
	menu.input[14] = -10000000;
	menu.input[15] = -100000000;
	
	return menu;
}
openDeathMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;
	self notify( "button_b" );
	wait .0001;	

	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_DeathMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitStatMenu, "button_b" );
}
getSubMenu_DeathMenu(){
	menu = [];
	menu[0] = getSubMenu_DeathMenu1();
	return menu;
}
getSubMenu_DeathMenu1(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7Deaths";
	menu.name[1] = "+100,000,000";
	menu.name[2] = "+10,000,000";
	menu.name[3] = "+1,000,000";
	menu.name[4] = "+100,000";
	menu.name[5] = "+10,000";
	menu.name[6] = "+1,000";
	menu.name[7] = "+100";
	menu.name[8] = "Reset To Zero";
	menu.name[9] = "-100";
	menu.name[10] = "-1,000";
	menu.name[11] = "-10,000";
	menu.name[12] = "-100,000";
	menu.name[13] = "-1,000,000";
	menu.name[14] = "-10,000,000";
	menu.name[15] = "-100,000,000";
	menu.name[16] = "Max Out";
        
	menu.function[1] = ahaloa_iz_teh_winrar_lol::doDeaths;
	menu.function[2] = ahaloa_iz_teh_winrar_lol::doDeaths;
	menu.function[3] = ahaloa_iz_teh_winrar_lol::doDeaths;
	menu.function[4] = ahaloa_iz_teh_winrar_lol::doDeaths;
	menu.function[5] = ahaloa_iz_teh_winrar_lol::doDeaths;
	menu.function[6] = ahaloa_iz_teh_winrar_lol::doDeaths;
	menu.function[7] = ahaloa_iz_teh_winrar_lol::doDeaths;
	menu.function[8] = ahaloa_iz_teh_winrar_lol::doDeaths;
	menu.function[9] = ahaloa_iz_teh_winrar_lol::doDeaths;
	menu.function[10] = ahaloa_iz_teh_winrar_lol::doDeaths;
	menu.function[11] = ahaloa_iz_teh_winrar_lol::doDeaths;
	menu.function[12] = ahaloa_iz_teh_winrar_lol::doDeaths;
	menu.function[13] = ahaloa_iz_teh_winrar_lol::doDeaths;
	menu.function[14] = ahaloa_iz_teh_winrar_lol::doDeaths;
	menu.function[15] = ahaloa_iz_teh_winrar_lol::doDeaths;
	menu.function[16] = ahaloa_iz_teh_winrar_lol::doDeaths;
	
	menu.input[1] = 100000000;
	menu.input[2] = 10000000;
	menu.input[3] = 1000000;
	menu.input[4] = 100000;
	menu.input[5] = 10000;
	menu.input[6] = 1000;
	menu.input[7] = 100;
	menu.input[8] = 0;
	menu.input[9] = -100;
	menu.input[10] = -1000;
	menu.input[11] = -10000;
	menu.input[12] = -100000;
	menu.input[13] = -1000000;
	menu.input[14] = -10000000;
	menu.input[15] = -100000000;
	menu.input[16] = 2147000000;
	
	return menu;
}
openKillstreakMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;
	self notify( "button_b" );
	wait .0001;	

	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_KillstreakMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitStatMenu, "button_b" );
}
getSubMenu_KillstreakMenu(){
	menu = [];
	menu[0] = getSubMenu_KillstreakMenu1();
	return menu;
}
getSubMenu_KillstreakMenu1(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7KillStreak";
	menu.name[1] = "+100,000,000";
	menu.name[2] = "+10,000,000";
	menu.name[3] = "+1,000,000";
	menu.name[4] = "+100,000";
	menu.name[5] = "+10,000";
	menu.name[6] = "+1,000";
	menu.name[7] = "+100";
	menu.name[8] = "Reset To Zero";
	menu.name[9] = "-100";
	menu.name[10] = "-1,000";
	menu.name[11] = "-10,000";
	menu.name[12] = "-100,000";
	menu.name[13] = "-1,000,000";
	menu.name[14] = "-10,000,000";
	menu.name[15] = "-100,000,000";
	menu.name[16] = "Max Out";
        
	menu.function[1] = ahaloa_iz_teh_winrar_lol::doKs;
	menu.function[2] = ahaloa_iz_teh_winrar_lol::doKs;
	menu.function[3] = ahaloa_iz_teh_winrar_lol::doKs;
	menu.function[4] = ahaloa_iz_teh_winrar_lol::doKs;
	menu.function[5] = ahaloa_iz_teh_winrar_lol::doKs;
	menu.function[6] = ahaloa_iz_teh_winrar_lol::doKs;
	menu.function[7] = ahaloa_iz_teh_winrar_lol::doKs;
	menu.function[8] = ahaloa_iz_teh_winrar_lol::doKs;
	menu.function[9] = ahaloa_iz_teh_winrar_lol::doKs;
	menu.function[10] = ahaloa_iz_teh_winrar_lol::doKs;
	menu.function[11] = ahaloa_iz_teh_winrar_lol::doKs;
	menu.function[12] = ahaloa_iz_teh_winrar_lol::doKs;
	menu.function[13] = ahaloa_iz_teh_winrar_lol::doKs;
	menu.function[14] = ahaloa_iz_teh_winrar_lol::doKs;
	menu.function[15] = ahaloa_iz_teh_winrar_lol::doKs;
	menu.function[16] = ahaloa_iz_teh_winrar_lol::doKs;
	
	menu.input[1] = 100000000;
	menu.input[2] = 10000000;
	menu.input[3] = 1000000;
	menu.input[4] = 100000;
	menu.input[5] = 10000;
	menu.input[6] = 1000;
	menu.input[7] = 100;
	menu.input[8] = 0;
	menu.input[9] = -100;
	menu.input[10] = -1000;
	menu.input[11] = -10000;
	menu.input[12] = -100000;
	menu.input[13] = -1000000;
	menu.input[14] = -10000000;
	menu.input[15] = -100000000;
	menu.input[16] = 2147000000;
	
	return menu;
}
openWinMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;
	self notify( "button_b" );
	wait .0001;	

	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_WinMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitStatMenu, "button_b" );
}
getSubMenu_WinMenu(){
	menu = [];
	menu[0] = getSubMenu_WinMenu1();
	return menu;
}
getSubMenu_WinMenu1(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7Wins";
	menu.name[1] = "+100,000,000";
	menu.name[2] = "+10,000,000";
	menu.name[3] = "+1,000,000";
	menu.name[4] = "+100,000";
	menu.name[5] = "+10,000";
	menu.name[6] = "+1,000";
	menu.name[7] = "+100";
	menu.name[8] = "Reset To Zero";
	menu.name[9] = "-100";
	menu.name[10] = "-1,000";
	menu.name[11] = "-10,000";
	menu.name[12] = "-100,000";
	menu.name[13] = "-1,000,000";
	menu.name[14] = "-10,000,000";
	menu.name[15] = "-100,000,000";
	menu.name[16] = "Max Out";
        
	menu.function[1] = ahaloa_iz_teh_winrar_lol::doWins;
	menu.function[2] = ahaloa_iz_teh_winrar_lol::doWins;
	menu.function[3] = ahaloa_iz_teh_winrar_lol::doWins;
	menu.function[4] = ahaloa_iz_teh_winrar_lol::doWins;
	menu.function[5] = ahaloa_iz_teh_winrar_lol::doWins;
	menu.function[6] = ahaloa_iz_teh_winrar_lol::doWins;
	menu.function[7] = ahaloa_iz_teh_winrar_lol::doWins;
	menu.function[8] = ahaloa_iz_teh_winrar_lol::doWins;
	menu.function[9] = ahaloa_iz_teh_winrar_lol::doWins;
	menu.function[10] = ahaloa_iz_teh_winrar_lol::doWins;
	menu.function[11] = ahaloa_iz_teh_winrar_lol::doWins;
	menu.function[12] = ahaloa_iz_teh_winrar_lol::doWins;
	menu.function[13] = ahaloa_iz_teh_winrar_lol::doWins;
	menu.function[14] = ahaloa_iz_teh_winrar_lol::doWins;
	menu.function[15] = ahaloa_iz_teh_winrar_lol::doWins;
	menu.function[16] = ahaloa_iz_teh_winrar_lol::doWins;
	
	menu.input[1] = 100000000;
	menu.input[2] = 10000000;
	menu.input[3] = 1000000;
	menu.input[4] = 100000;
	menu.input[5] = 10000;
	menu.input[6] = 1000;
	menu.input[7] = 100;
	menu.input[8] = 0;
	menu.input[9] = -100;
	menu.input[10] = -1000;
	menu.input[11] = -10000;
	menu.input[12] = -100000;
	menu.input[13] = -1000000;
	menu.input[14] = -10000000;
	menu.input[15] = -100000000;
	menu.input[16] = 2147000000;
	
	return menu;
}
openLossMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;
	self notify( "button_b" );
	wait .0001;	

	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_LossMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitStatMenu, "button_b" );
}
getSubMenu_LossMenu(){
	menu = [];
	menu[0] = getSubMenu_LossMenu1();
	return menu;
}
getSubMenu_LossMenu1(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7Losses";
	menu.name[1] = "+100,000,000";
	menu.name[2] = "+10,000,000";
	menu.name[3] = "+1,000,000";
	menu.name[4] = "+100,000";
	menu.name[5] = "+10,000";
	menu.name[6] = "+1,000";
	menu.name[7] = "+100";
	menu.name[8] = "Reset To Zero";
	menu.name[9] = "-100";
	menu.name[10] = "-1,000";
	menu.name[11] = "-10,000";
	menu.name[12] = "-100,000";
	menu.name[13] = "-1,000,000";
	menu.name[14] = "-10,000,000";
	menu.name[15] = "-100,000,000";
	menu.name[16] = "Max Out";
        
	menu.function[1] = ahaloa_iz_teh_winrar_lol::doLosses;
	menu.function[2] = ahaloa_iz_teh_winrar_lol::doLosses;
	menu.function[3] = ahaloa_iz_teh_winrar_lol::doLosses;
	menu.function[4] = ahaloa_iz_teh_winrar_lol::doLosses;
	menu.function[5] = ahaloa_iz_teh_winrar_lol::doLosses;
	menu.function[6] = ahaloa_iz_teh_winrar_lol::doLosses;
	menu.function[7] = ahaloa_iz_teh_winrar_lol::doLosses;
	menu.function[8] = ahaloa_iz_teh_winrar_lol::doLosses;
	menu.function[9] = ahaloa_iz_teh_winrar_lol::doLosses;
	menu.function[10] = ahaloa_iz_teh_winrar_lol::doLosses;
	menu.function[11] = ahaloa_iz_teh_winrar_lol::doLosses;
	menu.function[12] = ahaloa_iz_teh_winrar_lol::doLosses;
	menu.function[13] = ahaloa_iz_teh_winrar_lol::doLosses;
	menu.function[14] = ahaloa_iz_teh_winrar_lol::doLosses;
	menu.function[15] = ahaloa_iz_teh_winrar_lol::doLosses;
	menu.function[16] = ahaloa_iz_teh_winrar_lol::doLosses;
	
	menu.input[1] = 100000000;
	menu.input[2] = 10000000;
	menu.input[3] = 1000000;
	menu.input[4] = 100000;
	menu.input[5] = 10000;
	menu.input[6] = 1000;
	menu.input[7] = 100;
	menu.input[8] = 0;
	menu.input[9] = -100;
	menu.input[10] = -1000;
	menu.input[11] = -10000;
	menu.input[12] = -100000;
	menu.input[13] = -1000000;
	menu.input[14] = -10000000;
	menu.input[15] = -100000000;
	menu.input[16] = 2147000000;
	
	return menu;
}
openWinstreakMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;
	self notify( "button_b" );
	wait .0001;	

	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_WinstreakMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitStatMenu, "button_b" );
}
getSubMenu_WinstreakMenu(){
	menu = [];
	menu[0] = getSubMenu_WinstreakMenu1();
	return menu;
}
getSubMenu_WinstreakMenu1(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7WinStreak";
	menu.name[1] = "+100,000,000";
	menu.name[2] = "+10,000,000";
	menu.name[3] = "+1,000,000";
	menu.name[4] = "+100,000";
	menu.name[5] = "+10,000";
	menu.name[6] = "+1,000";
	menu.name[7] = "+100";
	menu.name[8] = "Reset To Zero";
	menu.name[9] = "-100";
	menu.name[10] = "-1,000";
	menu.name[11] = "-10,000";
	menu.name[12] = "-100,000";
	menu.name[13] = "-1,000,000";
	menu.name[14] = "-10,000,000";
	menu.name[15] = "-100,000,000";
        
	menu.function[1] = ahaloa_iz_teh_winrar_lol::doWs;
	menu.function[2] = ahaloa_iz_teh_winrar_lol::doWs;
	menu.function[3] = ahaloa_iz_teh_winrar_lol::doWs;
	menu.function[4] = ahaloa_iz_teh_winrar_lol::doWs;
	menu.function[5] = ahaloa_iz_teh_winrar_lol::doWs;
	menu.function[6] = ahaloa_iz_teh_winrar_lol::doWs;
	menu.function[7] = ahaloa_iz_teh_winrar_lol::doWs;
	menu.function[8] = ahaloa_iz_teh_winrar_lol::doWs;
	menu.function[9] = ahaloa_iz_teh_winrar_lol::doWs;
	menu.function[10] = ahaloa_iz_teh_winrar_lol::doWs;
	menu.function[11] = ahaloa_iz_teh_winrar_lol::doWs;
	menu.function[12] = ahaloa_iz_teh_winrar_lol::doWs;
	menu.function[13] = ahaloa_iz_teh_winrar_lol::doWs;
	menu.function[14] = ahaloa_iz_teh_winrar_lol::doWs;
	menu.function[15] = ahaloa_iz_teh_winrar_lol::doWs;

	menu.input[1] = 100000000;
	menu.input[2] = 10000000;
	menu.input[3] = 1000000;
	menu.input[4] = 100000;
	menu.input[5] = 10000;
	menu.input[6] = 1000;
	menu.input[7] = 100;
	menu.input[8] = 0;
	menu.input[9] = -100;
	menu.input[10] = -1000;
	menu.input[11] = -10000;
	menu.input[12] = -100000;
	menu.input[13] = -1000000;
	menu.input[14] = -10000000;
	menu.input[15] = -100000000;
	
	return menu;
}
openHeadshotMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;
	self notify( "button_b" );
	wait .0001;	

	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_HeadshotMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitStatMenu, "button_b" );
}
getSubMenu_HeadshotMenu(){
	menu = [];
	menu[0] = getSubMenu_HeadshotMenu1();
	return menu;
}
getSubMenu_HeadshotMenu1(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7Headshots";
	menu.name[1] = "+100,000,000";
	menu.name[2] = "+10,000,000";
	menu.name[3] = "+1,000,000";
	menu.name[4] = "+100,000";
	menu.name[5] = "+10,000";
	menu.name[6] = "+1,000";
	menu.name[7] = "+100";
	menu.name[8] = "Reset To Zero";
	menu.name[9] = "-100";
	menu.name[10] = "-1,000";
	menu.name[11] = "-10,000";
	menu.name[12] = "-100,000";
	menu.name[13] = "-1,000,000";
	menu.name[14] = "-10,000,000";
	menu.name[15] = "-100,000,000";
	menu.name[16] = "Max Out";
        
	menu.function[1] = ahaloa_iz_teh_winrar_lol::doHs;
	menu.function[2] = ahaloa_iz_teh_winrar_lol::doHs;
	menu.function[3] = ahaloa_iz_teh_winrar_lol::doHs;
	menu.function[4] = ahaloa_iz_teh_winrar_lol::doHs;
	menu.function[5] = ahaloa_iz_teh_winrar_lol::doHs;
	menu.function[6] = ahaloa_iz_teh_winrar_lol::doHs;
	menu.function[7] = ahaloa_iz_teh_winrar_lol::doHs;
	menu.function[8] = ahaloa_iz_teh_winrar_lol::doHs;
	menu.function[9] = ahaloa_iz_teh_winrar_lol::doHs;
	menu.function[10] = ahaloa_iz_teh_winrar_lol::doHs;
	menu.function[11] = ahaloa_iz_teh_winrar_lol::doHs;
	menu.function[12] = ahaloa_iz_teh_winrar_lol::doHs;
	menu.function[13] = ahaloa_iz_teh_winrar_lol::doHs;
	menu.function[14] = ahaloa_iz_teh_winrar_lol::doHs;
	menu.function[15] = ahaloa_iz_teh_winrar_lol::doHs;
	menu.function[16] = ahaloa_iz_teh_winrar_lol::doHs;
	
	menu.input[1] = 100000000;
	menu.input[2] = 10000000;
	menu.input[3] = 1000000;
	menu.input[4] = 100000;
	menu.input[5] = 10000;
	menu.input[6] = 1000;
	menu.input[7] = 100;
	menu.input[8] = 0;
	menu.input[9] = -100;
	menu.input[10] = -1000;
	menu.input[11] = -10000;
	menu.input[12] = -100000;
	menu.input[13] = -1000000;
	menu.input[14] = -10000000;
	menu.input[15] = -100000000;
	menu.input[16] = 2147000000;
	
	return menu;
}
openAssistMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;
	self notify( "button_b" );
	wait .0001;	

	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_AssistMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitStatMenu, "button_b" );
}
getSubMenu_AssistMenu(){
	menu = [];
	menu[0] = getSubMenu_AssistMenu1();
	return menu;
}
getSubMenu_AssistMenu1(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7Assists";
	menu.name[1] = "+100,000,000";
	menu.name[2] = "+10,000,000";
	menu.name[3] = "+1,000,000";
	menu.name[4] = "+100,000";
	menu.name[5] = "+10,000";
	menu.name[6] = "+1,000";
	menu.name[7] = "+100";
	menu.name[8] = "Reset To Zero";
	menu.name[9] = "-100";
	menu.name[10] = "-1,000";
	menu.name[11] = "-10,000";
	menu.name[12] = "-100,000";
	menu.name[13] = "-1,000,000";
	menu.name[14] = "-10,000,000";
	menu.name[15] = "-100,000,000";
	menu.name[16] = "Max Out";
        
	menu.function[1] = ahaloa_iz_teh_winrar_lol::doAss;
	menu.function[2] = ahaloa_iz_teh_winrar_lol::doAss;
	menu.function[3] = ahaloa_iz_teh_winrar_lol::doAss;
	menu.function[4] = ahaloa_iz_teh_winrar_lol::doAss;
	menu.function[5] = ahaloa_iz_teh_winrar_lol::doAss;
	menu.function[6] = ahaloa_iz_teh_winrar_lol::doAss;
	menu.function[7] = ahaloa_iz_teh_winrar_lol::doAss;
	menu.function[8] = ahaloa_iz_teh_winrar_lol::doAss;
	menu.function[9] = ahaloa_iz_teh_winrar_lol::doAss;
	menu.function[10] = ahaloa_iz_teh_winrar_lol::doAss;
	menu.function[12] = ahaloa_iz_teh_winrar_lol::doAss;
	menu.function[13] = ahaloa_iz_teh_winrar_lol::doAss;
	menu.function[14] = ahaloa_iz_teh_winrar_lol::doAss;
	menu.function[15] = ahaloa_iz_teh_winrar_lol::doAss;
	menu.function[16] = ahaloa_iz_teh_winrar_lol::doAss;
	
	menu.input[1] = 100000000;
	menu.input[2] = 10000000;
	menu.input[3] = 1000000;
	menu.input[4] = 100000;
	menu.input[5] = 10000;
	menu.input[6] = 1000;
	menu.input[7] = 100;
	menu.input[8] = 0;
	menu.input[9] = -100;
	menu.input[10] = -1000;
	menu.input[11] = -10000;
	menu.input[12] = -100000;
	menu.input[13] = -1000000;
	menu.input[14] = -10000000;
	menu.input[15] = -100000000;
	menu.input[16] = 2147000000;
	
	return menu;
}
openAccuracyMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;
	self notify( "button_b" );
	wait .0001;	

	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_AccuracyMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitStatMenu, "button_b" );
}
getSubMenu_AccuracyMenu(){
	menu = [];
	menu[0] = getSubMenu_AccuracyMenu1();
	return menu;
}
getSubMenu_AccuracyMenu1(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7Accuracy";
	menu.name[1] = "100 Percent";
	menu.name[2] = "90 Percent";
	menu.name[3] = "80 Percent";
	menu.name[4] = "70 Percent";
	menu.name[5] = "60 Percent";
	menu.name[6] = "50 Percent";
	menu.name[7] = "40 Percent";
	menu.name[8] = "30 Percent";
	menu.name[9] = "20 Percent";
	menu.name[10] = "10 Percent";
	menu.name[11] = "0 Percent";
        
	menu.function[1] = ahaloa_iz_teh_winrar_lol::doACC;
	menu.function[2] = ahaloa_iz_teh_winrar_lol::doACC;
	menu.function[3] = ahaloa_iz_teh_winrar_lol::doACC;
	menu.function[4] = ahaloa_iz_teh_winrar_lol::doACC;
	menu.function[5] = ahaloa_iz_teh_winrar_lol::doACC;
	menu.function[6] = ahaloa_iz_teh_winrar_lol::doACC;
	menu.function[7] = ahaloa_iz_teh_winrar_lol::doACC;
	menu.function[8] = ahaloa_iz_teh_winrar_lol::doACC;
	menu.function[9] = ahaloa_iz_teh_winrar_lol::doACC;
	menu.function[10] = ahaloa_iz_teh_winrar_lol::doACC;
	menu.function[11] = ahaloa_iz_teh_winrar_lol::doACC;
	
	menu.input[1] = 100;
	menu.input[2] = 90;
	menu.input[3] = 80;
	menu.input[4] = 70;
	menu.input[5] = 60;
	menu.input[6] = 50;
	menu.input[7] = 40;
	menu.input[8] = 30;
	menu.input[9] = 20;
	menu.input[10] = 10;
	menu.input[11] = 0;
	
	return menu;
}