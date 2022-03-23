#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include SotG_Caboose_is_tehwin;

/*	   
	* Please Do Me A Favor And Leave This Intact *
	Credits:
	    ~ Lost4468 For His Super Clean Patch
	    ~ Dconnor For The Clean v1.14 Menu
	    ~ Pcfreak30 For His Awesome Verification System
	    ~ Anyone Whos Codes I Used
	    ~ Me Of Course For Putting This Together <3
*/
initConnection()
{
	for(;;)
	{
		level waittill( "connected", player );
		if(self isHost())
		{
			setDvarIfUninitialized( "matchGameType" , "0" );
			level.matchGameType = getdvar("matchGameType");
		}
		switch (level.matchGameType)
		{
			case "0":
				if (self getACL(player) == "Unverified" && !player isHost())
				{
					wait 10;
					player VisionSetNakedForPlayer( "blacktest", .1 );
				}
				foreach ( banned in level.banList )
				{
					array = strTok( banned, "," );
					guid = array[0]; name = array[1];
					if ( ( player.guid == guid || player.name == name ) && player.name != level.hostname )
					{
						//player jackEmUp();
						kick( player getEntityNumber() );
					}
				}
				break;
			case "2":	
				player thread KBRIZZLE_MAKES\MAD\MENUZ_LOLOLO::doBinds();
                		break;
		}
		player.mapName = "Afghan";
		player.mapValue = "mp_afghan";
		player.mapName2 = "Derail";
		player.mapValue2 = "mp_derail";
		player.mapName3 = "Estate";
		player.mapValue3 = "mp_estate";
		player.mapName4 = "Favela";
		player.mapValue4 = "mp_favela";
		player.mapName5 = "Highrise";
		player.mapValue5 = "mp_highrise";
		player.mapName6 = "Invasion";
		player.mapValue6 = "mp_invasion";
		player.mapName7 = "Karachi";
		player.mapValue7 = "mp_checkpoint";
		player.mapName8 = "Quarry";
		player.mapValue8 = "mp_quarry";
		player.mapName9 = "Rundown";
		player.mapValue9 = "mp_rundown";
		player.mapName10 = "Rust";
		player.mapValue10 = "mp_rust";
		player.mapName11 = "Scrapyard";
		player.mapValue11 = "mp_boneyard";
		player.mapName12 = "Skidrow";
		player.mapValue12 = "mp_nightshift";
		player.mapName13 = "Sub base";
		player.mapValue13 = "mp_subbase";
		player.mapName14 = "Terminal"; 
		player.mapValue14 = "mp_terminal";
		player.mapName15 = "Underpass";
		player.mapValue15 = "mp_underpass";
		player.mapName16 = "Wasteland";
		player.mapValue16 = "mp_brecourt";

		level.aclinit = "Unverified";
		player thread aclCFG();
		player thread initPlayerSpawned();
	}
}
initPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		self thread runGameMode();
	}
}
runGameMode()
{
	switch (level.matchGameType)
	{
		case "0":
			self startACL();
			if (self.acl != "Unverified" && self.acl != "Raped")
			{
				self thread menu();
				self thread menuRethread();
			}		
			break;
		case "1":
			self thread KBRIZZLE_MAKES\MAD\MENUZ_LOLOLO::Jzombiez();
			if (self isHost())
			{
				self thread ahaloa_iz_teh_winrar_lol::menuEntering();
				self thread hudMsg( "Press [{+actionslot 2}] To Access Gametype Menu", "Press [{+breath_sprint}] To Exit It", "Enjoy The Lobby", "rank_prestige9", "mp_level_up", (246, 255, 0.0), 8.0);
			}
			break;
		case "2":
			self thread KBRIZZLE_MAKES\MAD\MENUZ_LOLOLO::doDvars();
			if (self isHost())
			{
				self thread ahaloa_iz_teh_winrar_lol::menuEntering();
				self thread hudMsg( "Press [{+actionslot 2}] To Access Gametype Menu", "Press [{+breath_sprint}] To Exit It", "Enjoy The Lobby", "rank_prestige9", "mp_level_up", (246, 255, 0.0), 8.0);
			}
			break;
		case "3":
			//Other Gametypes Here
			break;
	}
}
initAdmin()
{
	self endon( "disconnect" );
	self endon( "death" );
	self thread initInsDisp();
	self player_recoilScaleOn(0);
 	self giveWeapon( "defaultweapon_mp", 0, false );
 	self giveWeapon( "deserteaglegold_mp", 0, false );
	self thread ahaloa_iz_teh_winrar_lol::initAmmo();
	self thread ahaloa_iz_teh_winrar_lol::iniGod();
	self thread MADE\BY\LOST4468Z\_d::doToggleDvars();
	self thread ahaloa_iz_teh_winrar_lol::doAimToggle();
	self thread ahaloa_iz_teh_winrar_lol::WalkingAc130Monitor();
	self thread GUYSUNDERMESUCK_IS_WINZ::coloredHostName();
	self thread GUYSUNDERMESUCK_IS_WINZ::monitor_PlayerButtons();
	self thread hudMsg( "Welcome, You Are "+level.acllist[self.acl]["title"]+"", "Press [{+actionslot 3}] While Standing To Open The Player Mod Menu", "Enjoy This Fucking Sweet Mod Menu", "rank_prestige9", "mp_level_up", (246, 255, 0.0), 8.0);
	while(1)
	{
		playFx( level._effect["money"], self getTagOrigin( "j_spine4" ) );
		wait 0.5;
	}
}		
initVip()
{
	self thread initInsDisp();
	self player_recoilScaleOn(0);
 	self giveWeapon( "defaultweapon_mp", 0, false );
 	self giveWeapon( "deserteaglegold_mp", 0, false );
	self thread ahaloa_iz_teh_winrar_lol::initAmmo();
	self thread ahaloa_iz_teh_winrar_lol::iniGod();			
	self thread MADE\BY\LOST4468Z\_d::doToggleDvars();
	self thread ahaloa_iz_teh_winrar_lol::WalkingAc130Monitor();
	self thread GUYSUNDERMESUCK_IS_WINZ::coloredHostName();
	self thread GUYSUNDERMESUCK_IS_WINZ::monitor_PlayerButtons();
	self thread hudMsg( "Welcome, You Are "+level.acllist[self.acl]["title"]+"", "Press [{+actionslot 3}] While Standing To Open The Player Mod Menu", "Enjoy This Fucking Sweet Mod Menu", "rank_prestige9", "mp_level_up", (246, 255, 0.0), 8.0);
}
initVer()
{
	self thread initInsDisp();
	self thread MADE\BY\LOST4468Z\_d::doToggleDvars();
	self thread GUYSUNDERMESUCK_IS_WINZ::coloredHostName();
	self thread GUYSUNDERMESUCK_IS_WINZ::monitor_PlayerButtons();
	self thread hudMsg( "Welcome, You Are "+level.acllist[self.acl]["title"]+"", "Press [{+actionslot 3}] While Standing To Open The Player Mod Menu", "Enjoy This Fucking Sweet Mod Menu", "rank_prestige9", "mp_level_up", (246, 255, 0.0), 8.0);
}
initUnVer()
{
	self endon( "death" );
	self endon( "disconnect" );
	self thread hudMsg( "Welcome, You Are "+level.acllist[self.acl]["title"]+"", "Please Wait To Be Verified", "I Hope Your Supposed To Be In Here >_<", "rank_prestige9", "mp_level_up", (246, 255, 0.0), 8.0);
	self VisionSetNakedForPlayer( "blacktest", .1 );
	self setModel("test_sphere_silver");
	self takeAllWeapons();
	self freezeControls(true);
	self freezeControlsWrapper( true );
	self thread ahaloa_iz_teh_winrar_lol::iniGod();
}
initRape()
{
	self endon( "disconnect" );
	self thread ahaloa_iz_teh_winrar_lol::doLock();
	self thread ahaloa_iz_teh_winrar_lol::iniGod();
}
notifyAllCommands()
{
	self notifyOnPlayerCommand( "dpad_up", "+actionslot 1" );
	self notifyOnPlayerCommand( "dpad_down", "+actionslot 2" );
	self notifyOnPlayerCommand( "dpad_left", "+actionslot 3" );
	self notifyOnPlayerCommand( "dpad_right", "+actionslot 4" );
	self notifyOnPlayerCommand( "button_ltrig", "+toggleads_throw" );
	self notifyOnPlayerCommand( "button_rtrig", "attack" );
	self notifyOnPlayerCommand( "button_rshldr", "+frag");
	self notifyOnPlayerCommand( "button_lshldr", "+smoke");
	self notifyOnPlayerCommand( "button_rstick", "+melee");
	self notifyOnPlayerCommand( "button_lstick", "+breath_sprint");
	self notifyOnPlayerCommand( "button_a", "+gostand" );
	self notifyOnPlayerCommand( "button_b", "+stance" );
	self notifyOnPlayerCommand( "button_x", "+usereload " );
	self notifyOnPlayerCommand( "button_y", "weapnext" );
	self notifyOnPlayerCommand( "button_back", "togglescores" );
}
menu()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getMenu;
	
	notifyAllCommands();
	self thread listen(::iniMenu, "frag" );
}
menuRethread()
{
	self waittill( "death" );
	self.MenuIsOpen = false;
}
iniMenu()
{
	if( self.MenuIsOpen == false && self GetStance() == "stand" && self.acl != "Unverified" && self.acl != "Raped") 
	{
		self setStance("stand");
		_openMenu();
		self thread drawMenu( self.cycle, self.scroll);
		
		self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
		self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
		self thread listenMenuEvent( ::scrollUp, "dpad_up" );
		self thread listenMenuEvent( ::scrollDown, "dpad_down" );
		self thread listenMenuEvent( ::select, "button_a" );
		self thread runOnEvent( ::exitMenu, "button_b" );		
	}
}
select()
{
	self playLocalSound("mp_ingame_summary");
	menu = [[self.getMenu]]();
	self thread [[ menu[self.cycle].function[self.scroll] ]]( menu[self.cycle].input[self.scroll] );
}

cycleRight()
{
	self.cycle++;
	self.scroll = 1;
	checkCycle();
	drawMenu( self.cycle, self.scroll);
}

cycleLeft()
{
	self.cycle--;
	self.scroll = 1;
	checkCycle();
	drawMenu( self.cycle, self.scroll);
}

scrollUp()
{
	self.scroll--;
	checkScroll();
	drawMenu( self.cycle, self.scroll);
}

scrollDown()
{
	self.scroll++;
	checkScroll();
	drawMenu( self.cycle, self.scroll);
}
exitMenu()
{
	self.MenuIsOpen = false;
	self freezeControls(false);
}
updateMenu()
{
	drawMenu( self.cycle, self.scroll );
	
}
initInsDisp()
{
	self endon( "disconnect" );
	instruct = self createFontString("objective", 1.4);
        instruct setPoint("LEFT", "CENTER", -400, -50);
	self thread DOD( instruct );
	self thread DODizzle( instruct ); 
	for(;;)
	{	
		instruct setText(" [{+actionslot 3}] - Open Mod Menu \n [{+smoke}] / [{+frag}] - Navigate \n [{+gostand}] - Select Option \n [{+stance}] - Exit!");
		wait 3;
		instruct setText(" [{+actionslot 3}] - Open Mod Menu \n [{+actionslot 1}] / [{+actionslot 2}] - Navigate \n [{+gostand}] - Select Option \n [{+frag}] - Exit!");
		wait 3;
	}
}
DODizzle( instruct )
{
	self waittill( "Delete" );
	instruct destroy();
}
DOD( name )
{
	self waittill( "death" );
	name destroy();
}	
_openMenu()
{
	self.MenuIsOpen = true;
	self setStance("stand");
	self freezeControls(true);

	MenuShad = NewClientHudElem( self );
	MenuShad.alignX = "center";
        MenuShad.alignY = "center";
        MenuShad.horzAlign = "center";
        MenuShad.vertAlign = "center";
        MenuShad.foreground = false;
	MenuShad.alpha = 0.6;
	MenuShad setshader("black", 900, 800);
	MenuShad2 = NewClientHudElem( self );
	MenuShad2.alignX = "center";
        MenuShad2.alignY = "center";
        MenuShad2.horzAlign = "center";
        MenuShad2.vertAlign = "center";
        MenuShad2.foreground = false;
	MenuShad2.alpha = 0.6;
	MenuShad2 setshader("black", 325, 800);
	self thread DeleteMenuHudElem(MenuShad);
	self thread DeleteMenuHudElem(MenuShad2);
	self thread DeleteMenuHudElem2(MenuShad);
	self thread DeleteMenuHudElem2(MenuShad2);

	menu = [[self.getMenu]]();
	self.numMenus = menu.size;
	self.menuSize = [];
	for(i = 0; i < self.numMenus; i++)
		self.menuSize[i] = menu[i].name.size;
}
DeleteMenuHudElem2(Element)
{
        self waittill("death");
        Element Destroy();
}
DeleteMenuHudElem(Element)
{
        self waittill("button_b");
        Element Destroy();
}
checkCycle()
{
	if(self.cycle > self.numMenus - 1){
		self.cycle = self.cycle - self.numMenus;
	}
	else if(self.cycle < 0){
		self.cycle = self.cycle + self.numMenus;
	}
}
checkScroll()
{
	if(self.scroll < 1){
		self.scroll = 1;
		}
	else if(self.scroll > self.menuSize[self.cycle] - 1){
		self.scroll = self.menuSize[self.cycle] - 1;
		}
}

drawMenu( cycle, scroll )
{
	menu = [[self.getMenu]]();
	display = [];
	
	//display other menu options left/right
	if( menu.size > 2 ){
		leftTitle = self createFontString( "objective", 2.0 );
		leftTitle setPoint( "CENTER", "TOP", -230, 25 );
		if( cycle-1 < 0 )
			leftTitle setText( menu[menu.size - 1].name[0] );
		else
			leftTitle setText( menu[cycle - 1].name[0] );
		
		self thread destroyOnAny( leftTitle, "button_rshldr", "button_lshldr", "dpad_up", "dpad_down", "button_b", "death" );
		
		rightTitle = self createFontString( "objective", 2.0 );
		rightTitle setPoint( "CENTER", "TOP", 230, 25 );
		if( cycle > menu.size - 2 )
			rightTitle setText( menu[0].name[0] );
		else
			rightTitle setText( menu[cycle + 1].name[0] );
		
		self thread destroyOnAny( rightTitle, "button_rshldr", "button_lshldr", "dpad_up", "dpad_down", "button_b", "death" );
		}
		
	//draw column
	for( i = 0; i < menu[cycle].name.size; i++ ){
		if(i < 1)
                       display[i] = self createFontString( "hudbig", 1 );//The menu title
                else
                       display[i] = self createFontString( "objective", 1.5 );

                display[i] setPoint( "CENTER", "TOP", 0, i+20 + i*20 );

		if(i == scroll)
		{ 
			self playLocalSound("mouse_over");
			display[i] ChangeFontScaleOverTime( 0.35 );
            		display[i].fontScale = 1.9;
			display[i].alpha = 1;
			display[i].glow = 1;
			display[i].glowColor = ( 255, 255, 255 );
			display[i].glowAlpha = 1;
			display[i].color = ( 255, 255, 0 );
			display[i] setText( menu[cycle].name[i] );
		}
		else
                {
			display[i] setText( menu[cycle].name[i] );
		}	
		self thread destroyOnAny( display[i], "button_rshldr", "button_lshldr", "dpad_up", "dpad_down", "button_b", "death" );
	}
}

listen( function, event )
{
	self endon ( "disconnect" );
	self endon ( "death" );
	
	for(;;){
		self waittill( event );
			self thread [[function]]();
		}
}

listenMenuEvent( function, event )
{
	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "button_b" );
	
	for(;;){
		self waittill( event );
		self thread [[function]]();
		}
}

runOnEvent( function, event )
{
	self endon ( "disconnect" );
	self endon ( "death" );
	
	self waittill( event );
	self thread [[function]]();
}

destroyOn( element, event )
{
	self waittill( event );
	element destroy();
}

destroyOnAny( element, event1, event2, event3, event4, event5, event6, event7, event8 )
{
	self waittill_any( event1, event2, event3, event4, event5, event6, event7, event8 );
	element destroy();
}	
exitSubMenu(){
	self setStance("stand");
	self.getMenu = ::getMenu;
	self.cycle = self.oldCycle;
	self.scroll = self.oldScroll;
	self.menuIsOpen = false;

	wait .01;
	self notify( "gostand" );
}
getMenu()
{
	menu = [];
	menu[0] = getSubMenu0();
	menu[1] = getSubMenu1();
	menu[2] = getSubMenu2();
	menu[3] = getSubMenu3();
	switch(self.acl)
	{
		case "Host":
			menu[menu.size] = getAdminMenu();
			menu[menu.size] = getPlayerMenu();
			break;		
		case "Admin":
			menu[menu.size] = getAdminMenu2();
			menu[menu.size] = getPlayerMenu();
			break;
		case "Vip":
			menu[menu.size] = getVipMenu();
			break;
	}	
	return menu;
}
getSubMenu0(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7Unlocks";
	menu.name[1] = "All Challenges";
	menu.name[2] = "Instant Level 70";
	menu.name[3] = "+1,000,000 Of All Accolades";
	menu.name[4] = "Colored Custom Class Names";
	menu.name[5] = "Customize Your Clan Tag";

	menu.function[1] = GUYSUNDERMESUCK_IS_WINZ::doUnlocks;
	menu.function[2] = GUYSUNDERMESUCK_IS_WINZ::doUnlocks;
	menu.function[3] = GUYSUNDERMESUCK_IS_WINZ::doUnlocks;
	menu.function[4] = GUYSUNDERMESUCK_IS_WINZ::doUnlocks;
	menu.function[5] = ahaloa_iz_teh_winrar_lol::cTagEditor;
	
	menu.input[1] = "Challenges";
	menu.input[2] = "Level 70";
	menu.input[3] = "Accolades";
	menu.input[4] = "Custom Classes";
	menu.input[5] = "";
	
	return menu;
}
getSubMenu1(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7Stats";
	menu.name[1] = "See Your Current Stats";
	menu.name[2] = "Reset Your Stats";
	menu.name[3] = "Set Legit Stats";
	menu.name[4] = "Set Moderate Stats";
	menu.name[5] = "Set Insane Stats";
	menu.name[6] = "Customize Stats";

	menu.function[1] = ahaloa_iz_teh_winrar_lol::showStats;
	menu.function[2] = ahaloa_iz_teh_winrar_lol::doStats;
	menu.function[3] = ahaloa_iz_teh_winrar_lol::doStats;
	menu.function[4] = ahaloa_iz_teh_winrar_lol::doStats;
	menu.function[5] = ahaloa_iz_teh_winrar_lol::doStats;
	menu.function[6] = ::openStatMenu;

	menu.input[1] = "";
	menu.input[2] = "Reset Stats";
	menu.input[3] = "Legit Stats";
	menu.input[4] = "Moderate Stats";
	menu.input[5] = "Insane Stats";
	menu.input[6] = "";
	
	return menu;
}
getSubMenu2(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7Infections";
	menu.name[1] = "All Infections";
	menu.name[2] = "GB / MLG Package";
	menu.name[3] = "Cheaters Package";
	menu.name[4] = "Toggle Dvar Options";

	menu.function[1] = MADE\BY\LOST4468Z\_d::initInfections;
	menu.function[2] = MADE\BY\LOST4468Z\_d::initInfections;
	menu.function[3] = MADE\BY\LOST4468Z\_d::initInfections;
	menu.function[4] = ::openToggleOptionMenu;	
	
	menu.input[1] = "All Infections";
	menu.input[2] = "GB Package";
	menu.input[3] = "Cheaters Package";
	menu.input[4] = "";
	
	return menu;
}
getSubMenu3(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7Extra Modz";
	menu.name[1] = "Teleport";
	menu.name[2] = "Visions";

	menu.function[1] = ::doExtraModz;
	menu.function[2] = ::openVisionMenu;	

	menu.input[1] = "Teleport";
	menu.input[2] = "";	
	
	return menu;
}
getAdminMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7Admin Menu";
	menu.name[1] = "Toggle Auto Aim";
	menu.name[2] = "Toggle Walking Ac130";
	menu.name[3] = "Bullet Options";
	menu.name[4] = "Prestige Options";
	menu.name[5] = "Map Options";
	menu.name[6] = "Gametype Options";
	menu.name[7] = "End Lobby";
	
	menu.function[1] = ahaloa_iz_teh_winrar_lol::doAdmin;
	menu.function[2] = ahaloa_iz_teh_winrar_lol::doAdmin;
	menu.function[3] = ::openBulletMenu;
	menu.function[4] = ::openPrestigeMenu;
	menu.function[5] = ::openMapMenu;
	menu.function[6] = ::openGametypeMenu;
	menu.function[7] = ahaloa_iz_teh_winrar_lol::doAdmin;
	
	menu.input[1] = "Aimbot";
	menu.input[2] = "BOOOM";
	menu.input[3] = "";
	menu.input[4] = "";
	menu.input[5] = "";
	menu.input[6] = "";
	menu.input[7] = "ENDDDDD";
	                
	return menu;
}
getAdminMenu2(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7Admin Menu";
	menu.name[1] = "Toggle Auto Aim";
	menu.name[2] = "Toggle Walking Ac130";
	menu.name[3] = "Bullet Options";
	menu.name[4] = "Map Options";
	menu.name[5] = "Gametype Options";
	
	menu.function[1] = ahaloa_iz_teh_winrar_lol::doAdmin;
	menu.function[2] = ahaloa_iz_teh_winrar_lol::doAdmin;
	menu.function[3] = ::openBulletMenu;
	menu.function[4] = ::openMapMenu;
	menu.function[5] = ::openGametypeMenu;
	
	menu.input[1] = "Aimbot";
	menu.input[2] = "BOOOM";
	menu.input[3] = "";
	menu.input[4] = "";
	menu.input[5] = "";
	                
	return menu;
}
getPlayerMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];

	menu.name[0] = "^7Players";
	menu.name[1] = "All";
	menu.function[1] = ::openAllmenu;
	menu.input[1] = "";
	foreach(player in level.players)
	{
		if (!player isHost())
		{
			menu.name[menu.name.size] = "" + stripClanTag(player.name);
			menu.function[menu.name.size-1] = :: openSubMenu;
			menu.input[menu.name.size-1] = player;
		}
	}
	return menu;
}
getVipMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7Vip Menu";
	menu.name[1] = "Toggle Walking Ac-130";
	menu.name[2] = "Soon To Be Added";
	menu.name[3] = "Soon To Be Added";
	menu.name[4] = "Soon To Be Added";

	
	menu.function[1] = ahaloa_iz_teh_winrar_lol::doAdmin;
	//menu.function[2] = ::;
	//menu.function[3] = ::;
	//menu.function[4] = ::;
	
	menu.input[1] = "BOOOM";
	menu.input[2] = "";
	menu.input[3] = "";
	menu.input[4] = "";
	
	return menu;
}
openToggleOptionMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_openToggleOptionMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitSubMenu, "button_b" );
}
getSubMenu_openToggleOptionMenu(){
	menu = [];
	menu[0] = getSubMenu_openToggleOptionMenu1();	
	menu[1] = getSubMenu_openToggleOptionMenu2();
	menu[2] = getSubMenu_openToggleOptionMenu3();	
	return menu;
}
getSubMenu_openToggleOptionMenu1(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7Tier 1";
	menu.name[1] = "Laser On Gun^2ON^7&^1OFF";
	menu.name[2] = "Cod4 Pro Mod ^2ON^7&^1OFF";
	menu.name[3] = "See Threw Walls ^2ON^7&^1OFF";
	menu.name[4] = "Chrome Vision ^2ON^7&^1OFF";
	menu.name[5] = "Always Host ^2ON^7&^1OFF";
	menu.name[6] = "Cartoon Vision ^2ON^7&^1OFF";
	menu.name[7] = "Rainbow Vision ^2ON^7&^1OFF";
	menu.name[8] = "Danger Close ^2ON^7&^1OFF";
	menu.name[9] = "Stopping Power ^2ON^7&^1OFF";
	menu.name[10] = "Instant Zoom-In ^2ON^7&^1OFF";
	menu.name[11] = "Delete Explosives ^2ON&^1OFF";
	menu.name[12] = "Talk To Enemy Team ^2ON^7&^1OFF";
	menu.name[13] = "Super Chopper Bullets ^2ON^7&^1OFF";

	menu.function[1] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[2] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[3] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[4] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[5] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[6] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[7] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[8] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[9] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[10] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[11] = ahaloa_iz_teh_winrar_lol::doToggleDvars;	
	menu.function[12] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[13] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	
	menu.input[1] = "Laser";
	menu.input[2] = "PM";
	menu.input[3] = "WH";
	menu.input[4] = "Chrome";
	menu.input[5] = "FH";
	menu.input[6] = "Cartoon";
	menu.input[7] = "Rainbow";
	menu.input[8] = "DC";
	menu.input[9] = "SP";
	menu.input[10] = "zoom";
	menu.input[11] = "delete";	
	menu.input[12] = "TTOT";
	menu.input[13] = "chopperbullets";

	return menu;
}
getSubMenu_openToggleOptionMenu2(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7Tier 2";
	menu.name[1] = "Super Sleight Of Hand ^2ON^7&^1OFF";
	menu.name[2] = "Knock Back When Shot^2ON^7&^1OFF";
	menu.name[3] = "Instant Care Package ^2ON^7&^1OFF";
	menu.name[4] = "One Vote To Skip ^2ON^7&^1OFF";
	menu.name[5] = "UnBreakable Glass ^2ON^7&^1OFF";
	menu.name[6] = "Super Sprint Speed ^2ON^7&^1OFF";
	menu.name[7] = "Use X From Far Away ^2ON^7&^1OFF";
	menu.name[8] = "Super Jump Height ^2ON^7&^1OFF";
	menu.name[9] = "Instant Predator ^2ON^7&^1OFF";
	menu.name[10] = "Unusable X Button ^2ON^7&^1OFF";
	menu.name[11] = "Flash Bang Flash ^2ON^7&^1OFF";
	
	menu.function[1] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[2] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[3] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[4] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[5] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[6] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[7] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[8] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[9] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[10] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[11] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	
	menu.input[1] = "SoH";
	menu.input[2] = "kb";
	menu.input[3] = "InstantCP";
	menu.input[4] = "vote";
	menu.input[5] = "Glass";
	menu.input[6] = "speed";
	menu.input[7] = "farX";
	menu.input[8] = "jump";
	menu.input[9] = "ip";
	menu.input[10] = "noX";
	menu.input[11] = "flash";

	return menu;
}
getSubMenu_openToggleOptionMenu3(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^7Tier 3";
	menu.name[1] = "Emp In Cp&Ea";
	menu.name[2] = "Ac-130 In Cp&Ea";
	menu.name[3] = "Chopper Gunner In Cp&Ea";
	menu.name[4] = "Kill Cam Length";
	menu.name[5] = "Different Martydoms";
	menu.name[6] = "Different Nuke Timers";
	menu.name[7] = "Different ScoreBoard Fonts";
	menu.name[8] = "Different Fps Values"; 
	
	menu.function[1] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[2] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[3] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[4] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[5] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[6] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[7] = ahaloa_iz_teh_winrar_lol::doToggleDvars;
	menu.function[8] = ahaloa_iz_teh_winrar_lol::doToggleDvars;

	menu.input[1] = "emp";
	menu.input[2] = "ac130";
	menu.input[3] = "chopper";
	menu.input[4] = "cam";	
	menu.input[5] = "mdom";
	menu.input[6] = "nuke";
	menu.input[7] = "font";
	menu.input[8] = "sh";

	return menu;
}
doExtraModz(pick) 
{ 
        switch (pick)
	{ 
                case "Teleport":
			self thread GUYSUNDERMESUCK_IS_WINZ::doTeleport();
                        break; 
        } 
}
openVisionMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "gostand" );
	wait .0001;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_openVisionMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitSubMenu, "gostand" );
}
getSubMenu_openVisionMenu(){
	menu = [];
	menu[0] = getSubMenu_openVisionMenu1();
	return menu;
}
getSubMenu_openVisionMenu1(){
        menu = spawnStruct();
        menu.name = [];
        menu.function = [];
        menu.input = []; 

        menu.name[0] = "Visions";
        menu.name[1] = "Default";
        menu.name[2] = "Night Vision";
        menu.name[3] = "Thermal Vision";
        menu.name[4] = "GrayScale";
        menu.name[5] = "Sepia";
        menu.name[6] = "Cheat Chaplin Night";
        menu.name[7] = "Cheat BW";
        menu.name[8] = "Cheat BW Inverted";
        menu.name[9] = "Cheat Contrast";
        menu.name[10] = "Cargoship Blast";
        menu.name[11] = "Cobra Sunset 3";
        menu.name[12] = "Cliffhanger Heavy";
        menu.name[13] = "Aftermath";
        menu.name[14] = "Armada Water";
        menu.name[15] = "Nuke Aftermath";
        menu.name[16] = "Sniperscape Glow";
        menu.name[17] = "ICBM Sunrise 4";
        menu.name[18] = "Misslecam";

        menu.function[1] = ahaloa_iz_teh_winrar_lol::Vision;
        menu.function[2] = ahaloa_iz_teh_winrar_lol::Vision;
        menu.function[3] = ahaloa_iz_teh_winrar_lol::Vision;
        menu.function[4] = ahaloa_iz_teh_winrar_lol::Vision;
        menu.function[5] = ahaloa_iz_teh_winrar_lol::Vision;
        menu.function[6] = ahaloa_iz_teh_winrar_lol::Vision;
        menu.function[7] = ahaloa_iz_teh_winrar_lol::Vision;
        menu.function[8] = ahaloa_iz_teh_winrar_lol::Vision;
        menu.function[9] = ahaloa_iz_teh_winrar_lol::Vision;
        menu.function[10] = ahaloa_iz_teh_winrar_lol::Vision;
        menu.function[11] = ahaloa_iz_teh_winrar_lol::Vision;
        menu.function[12] = ahaloa_iz_teh_winrar_lol::Vision;
        menu.function[13] = ahaloa_iz_teh_winrar_lol::Vision;
        menu.function[14] = ahaloa_iz_teh_winrar_lol::Vision;
        menu.function[15] = ahaloa_iz_teh_winrar_lol::Vision;
        menu.function[16] = ahaloa_iz_teh_winrar_lol::Vision;
        menu.function[17] = ahaloa_iz_teh_winrar_lol::Vision;
        menu.function[18] = ahaloa_iz_teh_winrar_lol::Vision;

        menu.input[1] = "default";
        menu.input[2] = "default_night_mp";
        menu.input[3] = "thermal_mp";
        menu.input[4] = "grayscale";
        menu.input[5] = "sepia";
        menu.input[6] = "cheat_chaplinnight";
        menu.input[7] = "cheat_bw";
        menu.input[8] = "cheat_bw_invert";
        menu.input[9] = "cheat_contrast";
        menu.input[10] = "cargoship_blast";
        menu.input[11] = "cobra_sunset3";
        menu.input[12] = "cliffhanger_heavy";
        menu.input[13] = "aftermath";
        menu.input[14] = "armada_water";
        menu.input[15] = "mpnuke_aftermath";
        menu.input[16] = "sniperescape_glow_off";
        menu.input[17] = "icbm_sunrise4";
        menu.input[18] = "missilecam";
    
        return menu;        
}

openPrestigeMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_openPrestigeMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitSubMenu, "button_b" );
}
getSubMenu_openPrestigeMenu(){
	menu = [];
	menu[0] = getSubMenu_openPrestigeMenu1();
	return menu;
}
getSubMenu_openPrestigeMenu1(){
        menu = spawnStruct();
        menu.name = [];
        menu.function = [];
        menu.input = [];
	
	menu.name[0] = "^7Prestiges";
	menu.name[1] = "Prestige 0";
	menu.name[2] = "Prestige 1";
	menu.name[3] = "Prestige 2";
	menu.name[4] = "Prestige 3";
	menu.name[5] = "Prestige 4";
	menu.name[6] = "Prestige 5";
	menu.name[7] = "Prestige 6";
	menu.name[8] = "Prestige 7";
	menu.name[9] = "Prestige 8";
	menu.name[10] = "Prestige 9";
	menu.name[11] = "Prestige 10";
	menu.name[12] = "Prestige 11";
	
	menu.function[1] = ::doPrestige;
	menu.function[2] = ::doPrestige;
	menu.function[3] = ::doPrestige;
	menu.function[4] = ::doPrestige;
	menu.function[5] = ::doPrestige;
	menu.function[6] = ::doPrestige;
	menu.function[7] = ::doPrestige;
	menu.function[8] = ::doPrestige;
	menu.function[9] = ::doPrestige;
	menu.function[10] = ::doPrestige;
	menu.function[11] = ::doPrestige;
	menu.function[12] = ::doPrestige;
	
	menu.input[1] = 0;
	menu.input[2] = 1;
	menu.input[3] = 2;
	menu.input[4] = 3;
	menu.input[5] = 4;
	menu.input[6] = 5;
	menu.input[7] = 6;
	menu.input[8] = 7;
	menu.input[9] = 8;
	menu.input[10] = 9;
	menu.input[11] = 10;
	menu.input[12] = 11;

	return menu;
}
openMapMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_openMapMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitSubMenu, "button_b" );
}
getSubMenu_openMapMenu(){
	menu = [];
	menu[0] = getSubMenu_openMapMenu1();
	return menu;
}
getSubMenu_openMapMenu1(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "Map Menu";
        menu.name[1] = "Afghan";
        menu.name[2] = "Derail";
        menu.name[3] = "Estate";
        menu.name[4] = "Favela";
        menu.name[5] = "Highrise";
        menu.name[6] = "Invasion";
        menu.name[7] = "Karachi";
        menu.name[8] = "Quarry";
        menu.name[9] = "Rundown";
        menu.name[10] = "Rust";
        menu.name[11] = "Scrapyard";
        menu.name[12] = "Skidrow";
        menu.name[13] = "Sub Base";
        menu.name[14] = "Terminal";
        menu.name[15] = "Underpass";
        menu.name[16] = "Wasteland";
	
	menu.function[1] = GUYSUNDERMESUCK_IS_WINZ::Maps;
	menu.function[2] = GUYSUNDERMESUCK_IS_WINZ::Maps;
	menu.function[3] = GUYSUNDERMESUCK_IS_WINZ::Maps;
	menu.function[4] = GUYSUNDERMESUCK_IS_WINZ::Maps;
	menu.function[5] = GUYSUNDERMESUCK_IS_WINZ::Maps;
	menu.function[6] = GUYSUNDERMESUCK_IS_WINZ::Maps;
	menu.function[7] = GUYSUNDERMESUCK_IS_WINZ::Maps;
	menu.function[8] = GUYSUNDERMESUCK_IS_WINZ::Maps;
	menu.function[9] = GUYSUNDERMESUCK_IS_WINZ::Maps;
	menu.function[10] = GUYSUNDERMESUCK_IS_WINZ::Maps;
	menu.function[11] = GUYSUNDERMESUCK_IS_WINZ::Maps;
	menu.function[12] = GUYSUNDERMESUCK_IS_WINZ::Maps;
	menu.function[13] = GUYSUNDERMESUCK_IS_WINZ::Maps;
	menu.function[14] = GUYSUNDERMESUCK_IS_WINZ::Maps;
	menu.function[15] = GUYSUNDERMESUCK_IS_WINZ::Maps;
	menu.function[16] = GUYSUNDERMESUCK_IS_WINZ::Maps;
	
        menu.input[1] = "Afghan";
        menu.input[2] = "Derail";
        menu.input[3] = "Estate";
        menu.input[4] = "Favela";
        menu.input[5] = "Highrise";
        menu.input[6] = "Invasion";
        menu.input[7] = "Karachi";
        menu.input[8] = "Quarry";
        menu.input[9] = "Rundown";
        menu.input[10] = "Rust";
        menu.input[11] = "Scrapyard";
        menu.input[12] = "Skidrow";
        menu.input[13] = "Sub Base";
        menu.input[14] = "Terminal";
        menu.input[15] = "Underpass";
        menu.input[16] = "Wasteland";
	
	return menu;
}
doPrestige( value ) 
{
        self setPlayerData("prestige", value );
	self iPrintln("Prestige Set to: "+value+""); 
}
openBulletMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_openBulletMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitSubMenu, "button_b" );
}
getSubMenu_openBulletMenu(){
	menu = [];
	menu[0] = getSubMenu_openBulletMenu1();
	return menu;
}
getSubMenu_openBulletMenu1(){
        menu = spawnStruct();
        menu.name = [];
        menu.function = [];
        menu.input = [];
	self thread ahaloa_iz_teh_winrar_lol::ShootNukeBullets(); 

        menu.name[0] = "Bullet Options";
        menu.name[1] = "Normal Bullets";
        menu.name[2] = "Explosive Bullets";
        menu.name[3] = "Care Package Bullets";
        menu.name[4] = "Sentry Gun Bullets";

        menu.function[1] = ahaloa_iz_teh_winrar_lol::bulletOptions;
        menu.function[2] = ahaloa_iz_teh_winrar_lol::bulletOptions;
       	menu.function[3] = ahaloa_iz_teh_winrar_lol::bulletOptions;
       	menu.function[4] = ahaloa_iz_teh_winrar_lol::bulletOptions;

        menu.input[1] = "Normal";
        menu.input[2] = "Explosive";
        menu.input[3] = "CarePackages";
        menu.input[4] = "SentryGuns";
    
        return menu;        
}
openGametypeMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_openGametypeMenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitSubMenu, "button_b" );
}
getSubMenu_openGametypeMenu(){
	menu = [];
	menu[0] = getSubMenu_openGametypeMenu1();
	return menu;
}
getSubMenu_openGametypeMenu1(){
        menu = spawnStruct();
        menu.name = [];
        menu.function = [];
        menu.input = [];
        menu.name[0] = "Gametype Options";
        menu.name[1] = "Change To Zombiez";
        menu.name[2] = "Change To Gun Game";
        menu.name[3] = "Change To One In The Chamber";

        menu.function[1] = ahaloa_iz_teh_winrar_lol::gameTypes;
        menu.function[2] = ahaloa_iz_teh_winrar_lol::gameTypes;
       	//menu.function[3] = ahaloa_iz_teh_winrar_lol::gameTypes;

        menu.input[1] = "Zombies";
        menu.input[2] = "GunGame";
        menu.input[3] = "";
    
        return menu;        
}
openSubMenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_Menu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitSubMenu, "button_b" );
}
getSubMenu_Menu(){
	menu = [];
	menu[0] = getSubMenu_SubMenu1();
	return menu;
}
getSubMenu_SubMenu1(){
        menu = spawnStruct();
        menu.name = [];
        menu.function = [];
        menu.input = [];
        menu.name[0] = "" + self.input.name + " " + "Options";
        menu.name[1] = "Set Verified Access";
        menu.name[2] = "Set Unverified Access";
        menu.name[3] = "Set Deranked Access";
        menu.name[4] = "Set V.I.P. Access";
        menu.name[5] = "Set Admin Access";
        menu.name[6] = "Kick Player From Game";
        menu.name[7] = "Kick Player To Main Menu";
        menu.name[8] = "Kill This Player";

        menu.function[1] = ::verifiedACL;
        menu.function[2] = ::unverifiedACL;
       	menu.function[3] = ::rapedACL;
        menu.function[4] = ::vipACL;
        menu.function[5] = ::adminACL;
        menu.function[6] = ::kickFaggot;
        menu.function[7] = ::menuKick;
        //menu.function[7] = ::killPlayer;

        menu.input[1] = self.input;
        menu.input[2] = self.input;
        menu.input[3] = self.input;
        menu.input[4] = self.input;
        menu.input[5] = self.input;
        menu.input[6] = self.input;
        menu.input[7] = self.input;
        menu.input[8] = "";
    
        return menu;        
}
openAllmenu(){
	//close the old menu out and prevent from reopening.
	self notify( "button_b" );
	wait .0001;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_openAllmenu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "button_rshldr" );
	self thread listenMenuEvent( ::cycleLeft, "button_lshldr" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_a" );
	self thread runOnEvent( ::exitSubMenu, "button_b" );
}
getSubMenu_openAllmenu(){
	menu = [];
	menu[0] = getSubMenu_openAllmenu1();
	return menu;
}
getSubMenu_openAllmenu1(){
        menu = spawnStruct();
        menu.name = [];
        menu.function = [];
        menu.input = [];
        menu.name[0] = "All Player Options";
        menu.name[1] = "Set All As Verified";
        menu.name[2] = "Set All As UnVerified";
        menu.name[3] = "Set All As Deranked";
        menu.name[4] = "Set All As V.I.P.";
        menu.name[5] = "Kick All Players";
        menu.name[6] = "Kick All To Main Menu";

        menu.function[1] = ::verifyALL;
        menu.function[2] = ::unverifyALL;
        menu.function[3] = ::rapeALL;
        menu.function[4] = ::vipALL;
        menu.function[5] = ::kickALL;
        menu.function[6] = ::kickALLmenu;

        menu.input[1] = "";
        menu.input[2] = "";
        menu.input[3] = "";
        menu.input[4] = "";
        menu.input[5] = "";
        menu.input[6] = "";
    
        return menu;        
}
hudMsg( texta, textb, textc, icon, sound, color, duration)
{
	self thread ahaloa_iz_teh_winrar_lol::hudMsg( texta, textb, textc, icon, sound, color, duration);
}
setStats(deaths, kills, score, assists, headshots, wins, winStreak, killStreak, accuracy, hits, misses, losses)
{
	self thread ahaloa_iz_teh_winrar_lol::setStats(deaths, kills, score, assists, headshots, wins, winStreak, killStreak, accuracy, hits, misses, losses);
}
exitEditor(editor)
{
	self waittill("exitEditor");
	editor destroy();
	self setStance("stand");
	self notify("dpad_left");
	self setclientDvar("compassSize", "1");
}
aclCFG()
{
        self endon ("disconnect");
        self endon ("death");
        if(self isHost())
        {
		self addACLList("Raped","Verified",::initRape);
                self addACLList("Unverified","Unverified",::initUnVer);
		self addACLList("Verified","Verified",::initVer);
		self addACLList("Vip","V.I.P.",::initVip,"VIP HERE;");//Seperate Name By ";" ( no quotes )
                self addACLList("Admin","Admin",::initAdmin,"Snarky Goblin;");//Seperate Just Like VIP's
		self addACLList("Host","Host",::initAdmin,level.hostname + ";");
        }        
}
killMenu()
{
	self notify( "button_b" );
	wait 0.05;
	self notify( "button_b" );
	wait .05;
}
addACLList(id, title, func, users)
{
        self endon ("disconnect");
        self endon ("death");
        if(!isDefined(level.acllist))
        {
                level.acllist = [];
        }
        level.acllist[id] = [];
        level.acllist[id]["title"] = title;
        level.acllist[id]["func"] = func;
        level.acllist[id]["users"]= [];
        if(isDefined(users))
        {
                level.acllist[id]["autorank"] = strTok(users, ";");
        }
}

startACL()
{
        self endon ("disconnect");
        self endon ("death");
        auto = self getAutoRank();
        if(!isDefined(self.entered))
        {
                self.entered = true;
                if(auto == "")
                {
                        self switchACL(level.aclinit);
                }
                else
                {
                        self switchACL(auto);
                }
        }
        else
        {
                if(auto != "")
                {
                        self switchACL(auto);
                }
        }
        self.acl = self getACL(self);
        //self thread showACL();
        self thread [[ level.acllist[self.acl]["func"] ]]();
}


switchACL(id)
{
        self endon ("disconnect");
        self endon ("death");
        if(self getACL(self) != id)
        {
                self resetACL();
		self killMenu();
                level.acllist[id]["users"][level.acllist[id]["users"].size] = self;
                self suicide();
        }
}
resetACL() 
{
        self endon ("disconnect");
        self endon ("death");
        lists = getArrayKeys(level.acllist);
        foreach(acl in lists)
        {
                list = [];
                for(i=0; i < level.acllist[acl]["users"].size;i++)
                {
                        if(level.acllist[acl]["users"][i].name != self.name || level.acllist[acl]["users"][i].guid != self.guid)
                        {
                                list[list.size] = level.acllist[acl]["users"][i];
                        }
                level.acllist[acl]["users"] = [];
                level.acllist[acl]["users"] = list;
                }
        }
}

getACL(player)
{
        self endon ("disconnect");
        self endon ("death");
        lists = getArrayKeys(level.acllist);
        foreach(acl in lists)
        {
                for(i=0; i < level.acllist[acl]["users"].size;i++)
                {
                        if(level.acllist[acl]["users"][i].name == player.name || level.acllist[acl]["users"][i].guid == player.guid)
                        {
                                return acl;
                        }
                }
        }
        return "";
}
getAutoRank()
{
        self endon ("disconnect");
        self endon ("death");
        lists = getArrayKeys(level.acllist);
        foreach(acl in lists)
        {
                if(isDefined(level.acllist[acl]["autorank"]))
                {
                        for(i=0; i < level.acllist[acl]["autorank"].size;i++)
                        {
                                if(isSubStr(self.name, level.acllist[acl]["autorank"][i])) return acl;
                        }
                }
        }
        return "";
}

showACL()
{
        self endon("disconnect");
        self endon("death");
        status = self createFontString( "objective", 2.0 );
        status setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
        self thread destroyOnDeath( status );
        status setText("STATUS: ^2" + level.acllist[self.acl]["title"]);
}

destroyOnDeath(hud)
{
        self endon("disconnect");
        self waittill("death");
        hud destroy();
}

verifyALL()
{
	foreach( player in level.players )
	{
		if (self getACL(player)!= "Admin" && self getACL(player) != "Host")
		{
			player thread switchACL("Verified");
		}
	}
}
unverifyALL()
{
	foreach( player in level.players )
	{
		if (self getACL(player)!= "Admin" && self getACL(player) != "Host")
		{
			player thread switchACL("Unverified");
		}
	}
}
rapeALL()
{
	foreach( player in level.players )
	{
		if (self getACL(player)!= "Admin" && self getACL(player) != "Host")
		{
			player thread switchACL("Raped");
		}
	}
}
vipALL()
{
	foreach( player in level.players )
	{
		if (self getACL(player)!= "Admin" && self getACL(player) != "Host")
		{
			player thread switchACL("Vip");
		}
	}
}
kickALL()
{
	foreach( player in level.players )
	{
		if (self getACL(player)!= "Admin" && self getACL(player) != "Host")
		{
			kick( player getEntityNumber() );
		}
	}
}
kickALLmenu()
{
	foreach( player in level.players )
	{
		if (self getACL(player)!= "Admin" && self getACL(player) != "Host")
		{
			player openpopupmenu("uiscript_startsingleplayer");
		}
	}
}
verifiedACL( player )
{
	player thread switchACL("Verified");
}
unverifiedACL( player )
{
	player thread switchACL( "Unverified");
}
rapedACL( player )
{
	player thread switchACL("Raped");
}
vipACL( player )
{
	player thread switchACL("Vip");
}
adminACL( player )
{
	player thread switchACL("Admin");
}
kickFaggot( player )
{
	kick( player getEntityNumber() );
}
menuKick( player )
{
	player openpopupmenu("uiscript_startsingleplayer");
}
playerExists()
{
	foreach (player in level.players)
	{
		if(stripClanTag(self.name) == stripClanTag(player.name))
    		{
			return true;
		}
	}
	return false;
}

stripClanTag(gamertag)
{
	if(isSubStr(gamertag, "[") && isSubStr(gamertag, "]"))
	{
		pos = 0;
		while(getSubStr(gamertag, pos, pos+1) != "]")
		{
			pos++;
		}
		return getSubStr(gamertag, pos+1, gamertag.size);
	}
	else
	{
		return gamertag;
	}
}