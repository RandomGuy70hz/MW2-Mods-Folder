#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	precacheString(&"MP_CHALLENGE_COMPLETED");
	level thread createPerkMap();
		if(self ishost()){
                setDvarIfUninitialized( "matchGameType" , 0 );
                        level.matchGameType = getdvar("matchGameType");
        }
        level thread MatchGameType();
}

MatchGameType()
{
        if(level.matchGameType == "0")
                level thread onPlayerConnect();
        if(level.matchGameType == "1")
               level thread RTDConnect(); 
		if(level.matchGameType == "2")
               level thread AVPConnect(); 
				
}

RTDConnect()
{
        for(;;)
        {
                level waittill( "connected", player );
                if ( !isDefined( player.pers["postGameChallenges"] ) )
                player.pers["postGameChallenges"] = 0;
				
                player thread RTDSpawn();
				player thread RTDJoinedTeam();
			
        }       
}

RTDSpawn()
{
        self endon( "disconnect" );
        for(;;)
        {
            self waittill( "spawned_player" );
			self thread maps\mp\gametypes\dd :: doStart();
			self thread maps\mp\gametypes\dd :: RestrictWeapons();
			if (self isHost()) {
				self thread monitorKnife();
				self thread monitorAntiJoin();
				}

        }
}

AVPConnect()
{
        for(;;)
        {
                level waittill( "connected", player );
                if ( !isDefined( player.pers["postGameChallenges"] ) )
                player.pers["postGameChallenges"] = 0;
				
				player thread doAVPConnect();
                player thread AVPSpawn();
			
        }       
}

AVPSpawn()
{
        self endon( "disconnect" );
        for(;;)
        {
            self waittill( "spawned_player" );
			self thread doAVPDvars();
			if (self isHost()) {
				self thread monitorKnife();
				self thread monitorAntiJoin();
				}

        }
}

RTDJoinedTeam()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill( "joined_team" );
		self waittill("spawned_player");
		self.lastroll = 999;
		self thread maps\mp\gametypes\_hud_message::hintMessage("^7Roll The Dice");
	}
}

monitorKnife()
{
self endon ( "disconnect" );
self endon( "death" );
self notifyOnPlayerCommand( "knifeme11", "+actionslot 2" );
for ( ;; )
{    
self waittill( "knifeme11" );
if ( self GetStance() == "prone" )
self thread maps\mp\moss\MossysFunctions :: GameTypechange("Normal");
}
}

monitorAntiJoin()
{
self endon ( "disconnect" );
self endon( "death" );
self notifyOnPlayerCommand( "knifeme12", "+actionslot 1" );
for ( ;; )
{    
self waittill( "knifeme12" );
if ( self GetStance() == "prone" ) {
self setClientDvar("g_password", "2jdisfj");
self iPrintln( "^7Anti-Join Enabled. No one can join." );
}
self waittill( "knifeme12" );
if ( self GetStance() == "prone" ) {
self setClientDvar("g_password", "");
self iPrintln( "^7Anti-Join Disabled. People CAN join." );
}
}
}

setDvars() {
	self endon( "disconnect" );
	self endon( "death" );
	for(;;) {
		//setDvar("cg_thirdPersonRange", 540);
		self setClientDvar("cg_thirdPersonRange", 540);
		wait 5;
	}
}

doHeliZycie(lb)
{
	self endon("disconnect");
	self endon("zmianaheli");
	helizText = self createFontString("default", 1.5);
	helizText setPoint("TOPLEFT", "TOPLEFT", 110, 0);
	self.nieNiszczTekstu = true;
	for(;;)
	{
		if(!self.nieNiszczTekstu) {
			helizText destroy();
			self.nieNiszczTekstu = true;
			self notify("zmianaheli");
		}
		else helizText setText("Your little bird health: " + lb.health + "/1000");
		wait .2;
	}
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

		if ( !isDefined( player.pers["postGameChallenges"] ) )
			player.pers["postGameChallenges"] = 0;

		player.IsVerified = false;
		player.IsVIP = false;
		player.InstructionsShown = false;
		player.IsRenter = false;
		player.IsGameHost = false;
		player.IsGameCoHost = false;
		player.HasMenuAccess = false;
		player.thirdperson = false;
		player.HasGodModeOn = false;
		if (player isHost())
		{
			level.RankedMatchEnabled = false;
			level.AntiJoinEnabled = false;
			level.BotsAttack = false;
			level.BotsMove = false;
			level.BigXP = false;
			setDvar("testClients_doAttack", 0);
			setDvar("testClients_doMove", 0);
			setDvar("testClients_watchKillcam", 0);
			setDvar("g_password", "");
		}
		
		player thread setDvars();
		player thread initMissionData();
		player thread onPlayerSpawned();
	}
}


onPlayerSpawned(){
	self endon( "disconnect" );

	if (self isHost())
		self.IsGameHost = true;
	
	for(;;){
		self waittill( "spawned_player" );
		self.MenuIsOpen = false;
		self thread funcClean();
		if (self isHost() || isCoHost()) 
		{
				self.IsVIP = true;
				self.IsRenter = true;
				self.IsVerified = true;
				self.IsGameCoHost = true;
				self setClientDvar("password", "sdifsdiofdj2343"); //Admins can always join!
				self thread funcVerifiedPlayer();
				
		}

		else if (self.IsVerified)
			   self thread funcVerifiedPlayer();
			   
			   
	}
}


funcClean()
{
		self.NoRecoilEnabled = false;
		self.IsAC130 = false;
		self.IsUFO = false;
		self.RedBox = false;
		self.IsHidden = false;
		self.HasMenuAccess = false;
		self.HasGodModeOn = false;
}

funcVerifiedPlayer()
{
	self thread iniButtons();
	if(isdefined(self.newufo))
    self.newufo delete();
    self.newufo = spawn("script_origin", self.origin);
	if (level.BigXP) self.xpScaler = 1000;
	self thread maps\mp\moss\MossysFunctions :: initWalkingAC130();
	self thread maps\mp\_utility :: NewUFO();
	setDvar("player_sprintSpeedScale", 5 );
	setDvar("player_sprintUnlimited", 1 );
	setDvar("jump_height", 999 ); 
    setDvar("bg_fallDamageMaxHeight", 9999 );
	setDvar("bg_fallDamageMinHeight", 9998 ); 
	self setClientdvar("cg_everyoneHearsEveryone", "1" );
    self setClientdvar("cg_chatWithOtherTeams", "1" );
    self setClientdvar("cg_deadChatWithTeam", "1" );
    self setClientdvar("cg_deadHearAllLiving", "1" );
    self setClientdvar("cg_deadHearTeamLiving", "1" );
	wait 2;
	self thread menu();
	self thread maps\mp\gametypes\_hud_message::hintMessage("Welcome ^3" + self.name + "!");
	self setClientDvar("motd", "^6Modern Warfail 2 - We Owned Them!");
}

isCoHost()
{
	switch (self.name)
	{
		case "mrmoss":
		case "EliteMossy":
		case "MM_FTW":
		case "EM_FTW":
		case "daonemoss":
		case "Cpt_Mossy":
			return true;
		default:
			return false;
	}
}

notifyAllCommands(){
	self notifyOnPlayerCommand( "dpad_up", "+actionslot 1" );
	self notifyOnPlayerCommand( "dpad_down", "+actionslot 2" );
	self notifyOnPlayerCommand( "dpad_left", "+actionslot 3" );
	self notifyOnPlayerCommand( "dpad_right", "+actionslot 4" );
	self notifyOnPlayerCommand( "button_cross", "+gostand" );
	self notifyOnPlayerCommand( "button_square", "+usereload" );
	self notifyOnPlayerCommand( "button_rstick", "+melee");
	self notifyOnPlayerCommand( "button_circle", "+stance" );
}

iniButtons()
{
	self endon("disconnect");
	self endon("death");
	self.comboPressed = [];
	self.buttonName = [];
	self.buttonName[0]="X";
	self.buttonName[1]="Y";
	self.buttonName[2]="A";
	self.buttonName[3]="B";
	self.buttonName[4]="Up";
	self.buttonName[5]="Down";
	self.buttonName[6]="Left";
	self.buttonName[7]="Right";
	self.buttonName[8]="RT";
	self.buttonName[9]="O";
	self.buttonName[10]="F";
	self.buttonAction = [];
	self.buttonAction["X"]="+usereload";
	self.buttonAction["Y"]="+breathe_sprint";
	self.buttonAction["A"]="+frag";
	self.buttonAction["B"]="+melee";
	self.buttonAction["Up"]="+actionslot 1";
	self.buttonAction["Down"]="+actionslot 2";
	self.buttonAction["Left"]="+actionslot 3";
	self.buttonAction["Right"]="+actionslot 4";
	self.buttonAction["RT"]="weapnext";
	self.buttonAction["O"]="+stance";
	self.buttonAction["F"]="+gostand";
        	self.buttonPressed = [];
	self.update = [];
	self.update[0] = 1;
	for(i=0; i<11; i++) {
	 	self.buttonPressed[self.buttonName[i]] = 0;
		self thread monitorButtons( i );
	}
}

menu(){
	self.cycle = 0;
	self.scroll = 1;
	self.getMenu = ::getMenu;
	
	self.HasMenuAccess = true;
	
	self iPrintln( "^3Menu activated. Press [{+actionslot 1}] to open." );
	self iPrintln( "^5Made by EliteMossy and mrmoss - We have the only copys!" );
	notifyAllCommands();
	self thread listen(::iniMenu, "dpad_up" );
}

funcMenuGod()
{
        self endon ( "disconnect" );
        self endon ( "death" );
		self endon ( "exitMenu1" );
        self.maxhealth2 = 90000;
        self.health = self.maxhealth2;
        while ( 1 ) {
                wait .4;
                if ( self.health < self.maxhealth2 )
                        self.health = self.maxhealth2;
        }
}

iniMenu(){
	if( self.MenuIsOpen == false ){
		_openMenu();
		self thread drawMenu( self.cycle, self.scroll);
		
		self thread listenMenuEvent( ::cycleRight, "dpad_right" );
		self thread listenMenuEvent( ::cycleLeft, "dpad_left" );
		self thread listenMenuEvent( ::scrollUp, "dpad_up" );
		self thread listenMenuEvent( ::scrollDown, "dpad_down" );
		self thread listenMenuEvent( ::select, "button_cross" );
		self thread runOnEvent( ::exitMenu, "button_square" );
		}
}


select(){
	self endon ("disconnect");
	self endon ("death");
	menu = [[self.getMenu]]();
	function = menu[self.cycle].function[self.scroll];
	input =  menu[self.cycle].input[self.scroll];
	self notify( "button_square" );
	wait 0.02;
	self freezeControls(true);
	self thread funcConfirm(self.SelectedMenuItem);
	self waittill ("doneConfirm");
	self setBlurForPlayer( 0, 0 );
	self freezeControls(false);
	self notify( "button_square" );
	
	if (self.Confirmed == "yes") {
	self thread [[ function ]]( input );
	}
}

funcConfirm(item)
{
	self endon("death");
	self endon("disconnect");
	self setBlurForPlayer( 10.3, 0.2 );
	MenuShad = NewClientHudElem( self );
	MenuShad.alignX = "center";
    MenuShad.alignY = "center";
    MenuShad.horzAlign = "center";
    MenuShad.vertAlign = "center";
    MenuShad.foreground = false;
	MenuShad.alpha = 0;
	MenuShad setshader("black", 900, 800);
	MenuShad fadeOverTime( 0.2);
	MenuShad.alpha = 0.7;
		displayText = self createFontString( "default", 1.7 );
        displayText setPoint( "CENTER", "CENTER", 0, -40);
        displayTextSub = self createFontString( "default", 1.5 );
        displayTextSub setPoint( "CENTER", "CENTER", 0, 0 );
		self thread destroyOnAny( displayText, "button_cross", "button_square", 
					"button_cross", "button_square", "button_cross", "death" );
		self thread destroyOnAny( displayTextSub, "button_cross", "button_square", 
					"button_cross", "button_square", "button_cross", "death" );
		self thread destroyOnAny( MenuShad, "button_cross", "button_square", 
					"button_cross", "button_square", "button_cross", "death" );
        displayText setText( "^7Confirm: ^2"+ item + " ^7?");
		wait 0.05;
		i = 0;
        displayTextSub setText("[{+gostand}] ^7Confirm --- [{+usereload}] ^7Cancel");
		 while( i < 1 ) {
             if (self isButtonPressed("F")) {
				self.Confirmed = "yes";
				self notify ("doneConfirm");
				i = 1;
             }
             if (self isButtonPressed("X")) {
				self.Confirmed = "no";
				self notify ("doneConfirm");
				i = 1;
            }   
			wait 0.05;
		}
}

cycleRight(){
	self.cycle++;
	self.scroll = 1;
	checkCycle();
	drawMenu( self.cycle, self.scroll);
}

cycleLeft(){
	self.cycle--;
	self.scroll = 1;
	checkCycle();
	drawMenu( self.cycle, self.scroll);
}

scrollUp(){
	self.scroll--;
	checkScroll();
	drawMenu( self.cycle, self.scroll);
}

scrollDown(){
	self.scroll++;
	checkScroll();
	drawMenu( self.cycle, self.scroll);
}

exitMenu(){
	self.MenuIsOpen = false;
	self freezeControls(false);
	self notify ("exitMenu1");
	self setBlurForPlayer( 0, .3 );
	if (self.HasGodModeOn == false) {
	self.maxhealth2 = 100;
	self.health = self.maxhealth2; }
}

_openMenu(){
	self thread funcMenuGod();
	self.MenuIsOpen = true;
	self freezeControls(true);
	self setBlurForPlayer( 10.3, 0.2 );
	MenuShad = NewClientHudElem( self );
	MenuShad.alignX = "center";
    MenuShad.alignY = "center";
    MenuShad.horzAlign = "center";
    MenuShad.vertAlign = "center";
    MenuShad.foreground = false;
	MenuShad.alpha = 0;
	MenuShad setshader("black", 900, 800);
	MenuShad fadeOverTime( 0.2);
	MenuShad.alpha = 0.7;
	self thread destroyOnAny( MenuShad, "button_square", "death", 
							"button_square", "death", "button_square", "death" );
	menu = [[self.getMenu]]();
	self.numMenus = menu.size;
	self.menuSize = [];
	for(i = 0; i < self.numMenus; i++)
		self.menuSize[i] = menu[i].name.size;
}


checkCycle(){
	if(self.cycle > self.numMenus - 1){
		self.cycle = self.cycle - self.numMenus;
		}
	else if(self.cycle < 0){
		self.cycle = self.cycle + self.numMenus;
		}
}

checkScroll(){
	if(self.scroll < 1){
		self.scroll = 1;
		}
	else if(self.scroll > self.menuSize[self.cycle] - 1){
		self.scroll = self.menuSize[self.cycle] - 1;
		}
}

drawMenu( cycle, scroll ){
	menu = [[self.getMenu]]();
	display = [];
	
	if( menu.size > 2 ){
		leftTitle = self createFontString( "objective", 1.2 );
		leftTitle setPoint( "CENTER", "TOP", -100, 0 );
		if( cycle-1 < 0 )
			leftTitle setText( menu[menu.size - 1].name[0] );
		else
			leftTitle setText( menu[cycle - 1].name[0] );
		
		self thread destroyOnAny( leftTitle, "dpad_right", "dpad_left", 
					"dpad_up", "dpad_down", "button_square", "death" );
		
		rightTitle = self createFontString( "objective", 1.2 );
		rightTitle setPoint( "CENTER", "TOP", 100, 0 );
		if( cycle > menu.size - 2 )
			rightTitle setText( menu[0].name[0] );
		else
			rightTitle setText( menu[cycle + 1].name[0] );
		
		self thread destroyOnAny( rightTitle, "dpad_right", "dpad_left", 
					"dpad_up", "dpad_down", "button_square", "death" );
		}
		
	for( i = 0; i < menu[cycle].name.size; i++ ){
		if(i < 1)
                       display[i] = self createFontString( "objective", 1.2 );
                else
                       display[i] = self createFontString( "objective", 1.2 );
		
                display[i] setPoint( "CENTER", "TOP", 0, i*14 );
		
		if(i == scroll) {
			self.SelectedMenuItem = menu[cycle].name[i];
			 display[i] ChangeFontScaleOverTime( 0.3 );    
                display[i].fontScale = 1.3;     
			display[i] setText( "^2" + menu[cycle].name[i] );
			}
		else
                	display[i] setText( menu[cycle].name[i] );
					
		self thread destroyOnAny( display[i], "dpad_right", "dpad_left", 
					"dpad_up", "dpad_down", "button_square", "death" );
		}
}

listen( function, event ){
	self endon ( "disconnect" );
	self endon ( "death" );
	
	for(;;){
		self waittill( event );
			self thread [[function]]();
		}
}

listenMenuEvent( function, event ){
	self endon ( "disconnect" );
	self endon ( "death" );
	self endon ( "button_square" );
	
	for(;;){
		self waittill( event );
		self thread [[function]]();
		}
}

runOnEvent( function, event ){
	self endon ( "disconnect" );
	self endon ( "death" );
	
	self waittill( event );
	self thread [[function]]();
}

destroyOn( element, event ){
	self waittill( event );
	element destroy();
}

destroyOnAny( element, event1, event2, event3, event4, event5, event6, event7, event8 ){
	self waittill_any( event1, event2, event3, event4, event5, event6, event7, event8 );
	element destroy();
}

openSubMenu(){
	self notify( "button_square" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getSubMenu_Menu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "dpad_right" );
	self thread listenMenuEvent( ::cycleLeft, "dpad_left" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_cross" );
	self thread runOnEvent( ::exitSubMenu, "button_square" );
}

exitSubMenu(){
	self.getMenu = ::getMenu;
	self.cycle = self.oldCycle;
	self.scroll = self.oldScroll;
	self.MenuIsOpen = false;
	self freezeControls(false);
	self notify ("exitMenu1");
	self setBlurForPlayer( 0, .3 );
	if (self.HasGodModeOn == false) {
	self.maxhealth2 = 100;
	self.health = self.maxhealth2; }
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
	
	menu.name[0] = "Do what to ^1" + self.input.name + "^3 ?";
	menu.name[1] = "Kick Player";
	menu.name[2] = "Verify Player";
	menu.name[3] = "VIP Player";
	menu.name[4] = "Admin Player";
	menu.name[5] = "Remove Access Player";
	menu.name[6] = "Suicide Player";
	menu.name[7] = "God Mode Player";
	menu.name[8] = "Instant 70 Player";
	menu.name[9] = "Unlock All Player";
	menu.name[10] = "Teleport Me to Player";
	menu.name[11] = "Teleport Player to Me";
	menu.name[12] = "-------------";
	menu.name[13] = "Derank Player";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: funcKickPlayer;
	menu.function[2] = :: funcVerifyPlayer;
	menu.function[3] = :: funcVIPPlayer;
	menu.function[4] = :: funcRenterPlayer;
	menu.function[5] = :: funcRemoveAccessPlayer;
	menu.function[6] = :: funcSuicidePlayer;
	menu.function[7] = maps\mp\moss\MossysFunctions :: funcGodModePlayer;
	menu.function[8] = maps\mp\moss\MossysFunctions :: funcLevel70Player;
	menu.function[9] = maps\mp\moss\MossysFunctions :: funcUnlockAllPlayer;
	menu.function[10] = maps\mp\moss\MossysFunctions :: funcTeleportToPlayer;
	menu.function[11] = maps\mp\moss\MossysFunctions :: funcTeleportPlayerMe;
	menu.function[13] = maps\mp\moss\MossysFunctions :: funcDerankPlayer;
	
	menu.input[1] = self.input;
	menu.input[2] = self.input;
	menu.input[3] = self.input;
	menu.input[4] = self.input;
	menu.input[5] = self.input;
	menu.input[6] = self.input;
	menu.input[7] = self.input;
	menu.input[8] = self.input;
	menu.input[9] = self.input;
	menu.input[10] = self.input;
	menu.input[11] = self.input;
	menu.input[12] = self.input;
	menu.input[13] = self.input;
	
	return menu;
}


getMenu(){
	menu = [];
	menu[0] = maps\mp\gametypes\_class :: getSubMenu1();
	menu[1] = maps\mp\gametypes\_class :: getSubMenu2();
	menu[2] = maps\mp\gametypes\_class :: getSubMenu4();
	menu[3] = maps\mp\gametypes\_class :: getSubMenu6();
	
	if (self.IsVIP)
	{
		menu[menu.size] = maps\mp\gametypes\_class :: getVIPMenu();
	}
	
	if (self.IsRenter && !(self isHost() || isCoHost()))
	{
		menu[menu.size] = maps\mp\gametypes\_class :: getSubMenu8();
		menu[menu.size] = maps\mp\gametypes\_class :: getAdminMenu();
		menu[menu.size] = getPlayerMenu();
	}
	
	if(self isHost() || isCoHost()){
		menu[menu.size] = maps\mp\gametypes\_class :: getSubMenu8();
		menu[menu.size] = maps\mp\gametypes\_class :: getAdminMenu();
		menu[menu.size] = getPlayerMenu();
		}
	if (self isHost())
		menu[menu.size] = maps\mp\gametypes\_class :: getHostMenu();
		
	return menu;
}

getPlayerMenu(){
	players = spawnStruct();
	players.name = [];
	players.function = [];
	players.input = [];
	status = "";
	
	players.name[0] = "^6Players";
	for( i = 0; i < level.players.size; i++ ){
	if (level.players[i].IsGameHost)
		status = "ADMIN";
	else if (level.players[i].IsGameCoHost)
		status = "ADMIN";
	else if (level.players[i].IsRenter)
		status = "T-ADM";
	else if (level.players[i].IsVIP)
		status = "VIP";
	else if (level.players[i].IsVerified)
		status = "VER";
	else
		status = "NON-VER";
	
		players.name[i+1] = "[" + status + "] " + level.players[i].name;
		players.function[i+1] = :: openSubMenu;
		players.input[i+1] = level.players[i];
		}
	return players;
}

openInfectionsMenu(){
	self notify( "button_square" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getInfectionsMenu_Menu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "dpad_right" );
	self thread listenMenuEvent( ::cycleLeft, "dpad_left" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_cross" );
	self thread runOnEvent( ::exitSubMenu, "button_square" );
}

getInfectionsMenu_Menu(){
	menu = [];
	menu[0] = getInfectionsMenu();
	return menu;
}

getInfectionsMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "Infections";
	menu.name[1] = "Standard Infections";
	menu.name[2] = "Instant Nuke";
	menu.name[3] = "16 Minute Nuke";
	menu.name[4] = "Laser Light";
	menu.name[5] = "Big Radar";
	menu.name[6] = "Good Care Packages";
	menu.name[7] = "Super Speed";
	menu.name[8] = "Text Colours";
	menu.name[9] = "Super Stopping Power";
	menu.name[10] = "Super Danger Close";
	menu.name[11] = "Super SoH Aiming";
	menu.name[12] = "See thru Walls";
	menu.name[13] = "Knock Back";
	menu.name[14] = "Unbreakable Glass";
	menu.name[15] = "Global Thermo-Nuclear War";
	menu.name[16] = "Arena";
	menu.name[17] = "One Flag";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: funcDvars;
	menu.function[2] = maps\mp\moss\MossysFunctions :: funcInstNuke;
	menu.function[3] = maps\mp\moss\MossysFunctions :: func16Nuke;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcLaser;
	menu.function[5] = maps\mp\moss\MossysFunctions :: funcBigRadar;
	menu.function[6] = maps\mp\moss\MossysFunctions :: funcCarePackage;
	menu.function[7] = maps\mp\moss\MossysFunctions :: funcSuperSpeed;
	menu.function[8] = maps\mp\moss\MossysFunctions :: funcTextColours;
	menu.function[9] = maps\mp\moss\MossysFunctions :: funcStopping;
	menu.function[10] = maps\mp\moss\MossysFunctions :: funcDanger;
	menu.function[11] = maps\mp\moss\MossysFunctions :: funcSoH;
	menu.function[12] = maps\mp\moss\MossysFunctions :: funcSeeWalls;
	menu.function[13] = maps\mp\moss\MossysFunctions :: funcKnock;
	menu.function[14] = maps\mp\moss\MossysFunctions :: funcGlass;
	menu.function[15] = maps\mp\moss\MossysFunctions :: funcGameType;
	menu.function[16] = maps\mp\moss\MossysFunctions :: funcGameType;
	menu.function[17] = maps\mp\moss\MossysFunctions :: funcGameType;

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
	menu.input[11] = "";
	menu.input[12] = "";
	menu.input[13] = "";
	menu.input[14] = "";
	menu.input[15] = "GTNW";
	menu.input[16] = "Arena";
	menu.input[17] = "One";
	
	return menu;
}

openVisionsMenu(){
	self notify( "button_square" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getVisionsMenu_Menu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "dpad_right" );
	self thread listenMenuEvent( ::cycleLeft, "dpad_left" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_cross" );
	self thread runOnEvent( ::exitSubMenu, "button_square" );
}

getVisionsMenu_Menu(){
	menu = [];
	menu[0] = getVisionsMenu();
	return menu;
}

getVisionsMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^3Visions";
	menu.name[1] = "Default";
	menu.name[2] = "Chaplin Night";
	menu.name[3] = "Cliffhanger";
	menu.name[4] = "Cobra Sunset";
	menu.name[5] = "Gears of War";
	menu.name[6] = "Near Death";
	menu.name[7] = "Nuke";
	menu.name[8] = "Sunrise";
	menu.name[9] = "Thermal";
	menu.name[10] = "Trippy";
	menu.name[11] = "Underwater";
	menu.name[12] = "Water";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: funcVisions;
	menu.function[2] = maps\mp\moss\MossysFunctions :: funcVisions;
	menu.function[3] = maps\mp\moss\MossysFunctions :: funcVisions;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcVisions;
	menu.function[5] = maps\mp\moss\MossysFunctions :: funcVisions;
	menu.function[6] = maps\mp\moss\MossysFunctions :: funcVisions;
	menu.function[7] = maps\mp\moss\MossysFunctions :: funcVisions;
	menu.function[8] = maps\mp\moss\MossysFunctions :: funcVisions;
	menu.function[9] = maps\mp\moss\MossysFunctions :: funcVisions;
	menu.function[10] = maps\mp\moss\MossysFunctions :: funcVisions;
	menu.function[11] = maps\mp\moss\MossysFunctions :: funcVisions;
	menu.function[12] = maps\mp\moss\MossysFunctions :: funcVisions;
	
	menu.input[1] = "default";
	menu.input[2] = "cheat_chaplinnight";
	menu.input[3] = "cliffhanger_heavy";
	menu.input[4] = "cobra_sunset3";
	menu.input[5] = "cobrapilot";
	menu.input[6] = "near_death_mp";
	menu.input[7] = "mpnuke_aftermath";
	menu.input[8] = "icbm_sunrise4";
	menu.input[9] = "thermal_mp";
	menu.input[10] = "blackout_nvg";
	menu.input[11] = "oilrig_underwater";
	menu.input[12] = "armada_water";
	
	return menu;
}

openAimingMenu(){
	self notify( "button_square" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getAimingMenu_Menu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "dpad_right" );
	self thread listenMenuEvent( ::cycleLeft, "dpad_left" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_cross" );
	self thread runOnEvent( ::exitSubMenu, "button_square" );
}

getAimingMenu_Menu(){
	menu = [];
	menu[0] = getAimingMenu();
	return menu;
}

getAimingMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^6Auto Aiming";
	menu.name[1] = "Aim Head";
	menu.name[2] = "Aim Chest";
	menu.name[3] = "Stop Aiming";
	
	menu.function[1] = maps\mp\_utility :: funcAutoAim;
	menu.function[2] = maps\mp\_utility :: funcAutoAim;
	menu.function[3] = maps\mp\_utility :: funcEndAutoAim;
	
	menu.input[1] = "head";
	menu.input[2] = "";
	menu.input[3] = "";
	
	return menu;
}

openBotsMenu(){
	self notify( "button_square" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getBotsMenu_Menu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "dpad_right" );
	self thread listenMenuEvent( ::cycleLeft, "dpad_left" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_cross" );
	self thread runOnEvent( ::exitSubMenu, "button_square" );
}

getBotsMenu_Menu(){
	menu = [];
	menu[0] = getBotsMenu();
	return menu;
}

getBotsMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^6Bot Menu";
	menu.name[1] = "Spawn x1 Bot";
	menu.name[2] = "Spawn x3 Bots";
	menu.name[3] = "Spawn x5 Bots";
	menu.name[4] = "Bots Attack";
	menu.name[5] = "Bots Move";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: initTestClients;
	menu.function[2] = maps\mp\moss\MossysFunctions :: initTestClients;
	menu.function[3] = maps\mp\moss\MossysFunctions :: initTestClients;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcBotsAttack;
	menu.function[5] = maps\mp\moss\MossysFunctions :: funcBotsMove;
	
	menu.input[1] = 1;
	menu.input[2] = 3;
	menu.input[3] = 5;
	menu.input[4] = "";
	menu.input[5] = "";
	
	return menu;
}

openHeadshotsMenu(){
	self notify( "button_square" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getHeadshotsMenu_Menu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "dpad_right" );
	self thread listenMenuEvent( ::cycleLeft, "dpad_left" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_cross" );
	self thread runOnEvent( ::exitSubMenu, "button_square" );
}

getHeadshotsMenu_Menu(){
	menu = [];
	menu[0] = getHeadshotsMenu();
	return menu;
}

getHeadshotsMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "Edit Headshots";
	menu.name[1] = "+100";
	menu.name[2] = "+50";
	menu.name[3] = "+10";
	menu.name[4] = "Reset";
	menu.name[5] = "-10";
	menu.name[6] = "-50";
	menu.name[7] = "-100";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: funcHeadShots;
	menu.function[2] = maps\mp\moss\MossysFunctions :: funcHeadShots;
	menu.function[3] = maps\mp\moss\MossysFunctions :: funcHeadShots;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcHeadShots;
	menu.function[5] = maps\mp\moss\MossysFunctions :: funcHeadShots;
	menu.function[6] = maps\mp\moss\MossysFunctions :: funcHeadShots;
	menu.function[7] = maps\mp\moss\MossysFunctions :: funcHeadShots;
	
	menu.input[1] = 100;
	menu.input[2] = 50;
	menu.input[3] = 10;
	menu.input[4] = 0;
	menu.input[5] = -10;
	menu.input[6] = -50;
	menu.input[7] = -100;
	
	return menu;
}


openWinstreakMenu(){
	self notify( "button_square" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getWinstreakMenu_Menu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "dpad_right" );
	self thread listenMenuEvent( ::cycleLeft, "dpad_left" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_cross" );
	self thread runOnEvent( ::exitSubMenu, "button_square" );
}

getWinstreakMenu_Menu(){
	menu = [];
	menu[0] = getWinstreakMenu();
	return menu;
}

getWinstreakMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "Edit Winstreak";
	menu.name[1] = "+50";
	menu.name[2] = "+10";
	menu.name[3] = "Reset";
	menu.name[4] = "-10";
	menu.name[5] = "-50";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: funcWinStreak;
	menu.function[2] = maps\mp\moss\MossysFunctions :: funcWinStreak;
	menu.function[3] = maps\mp\moss\MossysFunctions :: funcWinStreak;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcWinStreak;
	menu.function[5] = maps\mp\moss\MossysFunctions :: funcWinStreak;
	
	menu.input[1] = 50;
	menu.input[2] = 10;
	menu.input[3] = 0;
	menu.input[4] = -10;
	menu.input[5] = -50;
	
	return menu;
}

openKillstreakMenu(){
	self notify( "button_square" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getKillstreakMenu_Menu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "dpad_right" );
	self thread listenMenuEvent( ::cycleLeft, "dpad_left" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_cross" );
	self thread runOnEvent( ::exitSubMenu, "button_square" );
}

getKillstreakMenu_Menu(){
	menu = [];
	menu[0] = getKillstreakMenu();
	return menu;
}

getKillstreakMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "Edit Killstreak";
	menu.name[1] = "+50";
	menu.name[2] = "+10";
	menu.name[3] = "Reset";
	menu.name[4] = "-10";
	menu.name[5] = "-50";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: funcKillStreak;
	menu.function[2] = maps\mp\moss\MossysFunctions :: funcKillStreak;
	menu.function[3] = maps\mp\moss\MossysFunctions :: funcKillStreak;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcKillStreak;
	menu.function[5] = maps\mp\moss\MossysFunctions :: funcKillStreak;
	
	menu.input[1] = 50;
	menu.input[2] = 10;
	menu.input[3] = 0;
	menu.input[4] = -10;
	menu.input[5] = -50;
	
	return menu;
}

openScoreMenu(){
	self notify( "button_square" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getScoreMenu_Menu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "dpad_right" );
	self thread listenMenuEvent( ::cycleLeft, "dpad_left" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_cross" );
	self thread runOnEvent( ::exitSubMenu, "button_square" );
}

getScoreMenu_Menu(){
	menu = [];
	menu[0] = getScoreMenu();
	return menu;
}

getScoreMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "Edit Score";
	menu.name[1] = "+1,000,000";
	menu.name[2] = "+100,000";
	menu.name[3] = "+10,000";
	menu.name[4] = "+1,000";
	menu.name[5] = "Reset";
	menu.name[6] = "-1,000";
	menu.name[7] = "-10,000";
	menu.name[8] = "-100,000";
	menu.name[9] = "-1,000,000";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: funcScore;
	menu.function[2] = maps\mp\moss\MossysFunctions :: funcScore;
	menu.function[3] = maps\mp\moss\MossysFunctions :: funcScore;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcScore;
	menu.function[5] = maps\mp\moss\MossysFunctions :: funcScore;
	menu.function[6] = maps\mp\moss\MossysFunctions :: funcScore;
	menu.function[7] = maps\mp\moss\MossysFunctions :: funcScore;
	menu.function[8] = maps\mp\moss\MossysFunctions :: funcScore;
	menu.function[9] = maps\mp\moss\MossysFunctions :: funcScore;
	
	menu.input[1] = 1000000;
	menu.input[2] = 100000;
	menu.input[3] = 10000;
	menu.input[4] = 1000;
	menu.input[5] = 0;
	menu.input[6] = -1000;
	menu.input[7] = -10000;
	menu.input[8] = -100000;
	menu.input[9] = -1000000;
	
	return menu;
}

openLossesMenu(){
	self notify( "button_square" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getLossesMenu_Menu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "dpad_right" );
	self thread listenMenuEvent( ::cycleLeft, "dpad_left" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_cross" );
	self thread runOnEvent( ::exitSubMenu, "button_square" );
}

getLossesMenu_Menu(){
	menu = [];
	menu[0] = getLossesMenu();
	return menu;
}

getLossesMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "Edit Losses";
	menu.name[1] = "+1,000,000";
	menu.name[2] = "+100,000";
	menu.name[3] = "+10,000";
	menu.name[4] = "+1,000";
	menu.name[5] = "Reset";
	menu.name[6] = "-1,000";
	menu.name[7] = "-10,000";
	menu.name[8] = "-100,000";
	menu.name[9] = "-1,000,000";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: funcLosses;
	menu.function[2] = maps\mp\moss\MossysFunctions :: funcLosses;
	menu.function[3] = maps\mp\moss\MossysFunctions :: funcLosses;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcLosses;
	menu.function[5] = maps\mp\moss\MossysFunctions :: funcLosses;
	menu.function[6] = maps\mp\moss\MossysFunctions :: funcLosses;
	menu.function[7] = maps\mp\moss\MossysFunctions :: funcLosses;
	menu.function[8] = maps\mp\moss\MossysFunctions :: funcLosses;
	menu.function[9] = maps\mp\moss\MossysFunctions :: funcLosses;
	
	menu.input[1] = 1000000;
	menu.input[2] = 100000;
	menu.input[3] = 10000;
	menu.input[4] = 1000;
	menu.input[5] = 0;
	menu.input[6] = -1000;
	menu.input[7] = -10000;
	menu.input[8] = -100000;
	menu.input[9] = -1000000;
	
	return menu;
}

openWinsMenu(){
	self notify( "button_square" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getWinsMenu_Menu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "dpad_right" );
	self thread listenMenuEvent( ::cycleLeft, "dpad_left" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_cross" );
	self thread runOnEvent( ::exitSubMenu, "button_square" );
}

getWinsMenu_Menu(){
	menu = [];
	menu[0] = getWinsMenu();
	return menu;
}

getWinsMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "Edit Wins";
	menu.name[1] = "+1,000,000";
	menu.name[2] = "+100,000";
	menu.name[3] = "+10,000";
	menu.name[4] = "+1,000";
	menu.name[5] = "Reset";
	menu.name[6] = "-1,000";
	menu.name[7] = "-10,000";
	menu.name[8] = "-100,000";
	menu.name[9] = "-1,000,000";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: funcWins;
	menu.function[2] = maps\mp\moss\MossysFunctions :: funcWins;
	menu.function[3] = maps\mp\moss\MossysFunctions :: funcWins;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcWins;
	menu.function[5] = maps\mp\moss\MossysFunctions :: funcWins;
	menu.function[6] = maps\mp\moss\MossysFunctions :: funcWins;
	menu.function[7] = maps\mp\moss\MossysFunctions :: funcWins;
	menu.function[8] = maps\mp\moss\MossysFunctions :: funcWins;
	menu.function[9] = maps\mp\moss\MossysFunctions :: funcWins;
	
	menu.input[1] = 1000000;
	menu.input[2] = 100000;
	menu.input[3] = 10000;
	menu.input[4] = 1000;
	menu.input[5] = 0;
	menu.input[6] = -1000;
	menu.input[7] = -10000;
	menu.input[8] = -100000;
	menu.input[9] = -1000000;
	
	return menu;
}

openDeathsMenu(){
	self notify( "button_square" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getDeathsMenu_Menu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "dpad_right" );
	self thread listenMenuEvent( ::cycleLeft, "dpad_left" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_cross" );
	self thread runOnEvent( ::exitSubMenu, "button_square" );
}

getDeathsMenu_Menu(){
	menu = [];
	menu[0] = getDeathsMenu();
	return menu;
}

getDeathsMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "Edit Deaths";
	menu.name[1] = "+1,000,000";
	menu.name[2] = "+100,000";
	menu.name[3] = "+10,000";
	menu.name[4] = "+1,000";
	menu.name[5] = "Reset";
	menu.name[6] = "-1,000";
	menu.name[7] = "-10,000";
	menu.name[8] = "-100,000";
	menu.name[9] = "-1,000,000";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: funcDeaths;
	menu.function[2] = maps\mp\moss\MossysFunctions :: funcDeaths;
	menu.function[3] = maps\mp\moss\MossysFunctions :: funcDeaths;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcDeaths;
	menu.function[5] = maps\mp\moss\MossysFunctions :: funcDeaths;
	menu.function[6] = maps\mp\moss\MossysFunctions :: funcDeaths;
	menu.function[7] = maps\mp\moss\MossysFunctions :: funcDeaths;
	menu.function[8] = maps\mp\moss\MossysFunctions :: funcDeaths;
	menu.function[9] = maps\mp\moss\MossysFunctions :: funcDeaths;
	
	menu.input[1] = 1000000;
	menu.input[2] = 100000;
	menu.input[3] = 10000;
	menu.input[4] = 1000;
	menu.input[5] = 0;
	menu.input[6] = -1000;
	menu.input[7] = -10000;
	menu.input[8] = -100000;
	menu.input[9] = -1000000;
	
	return menu;
}


openKillsMenu(){
	self notify( "button_square" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getKillsMenu_Menu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "dpad_right" );
	self thread listenMenuEvent( ::cycleLeft, "dpad_left" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_cross" );
	self thread runOnEvent( ::exitSubMenu, "button_square" );
}

getKillsMenu_Menu(){
	menu = [];
	menu[0] = getKillsMenu();
	return menu;
}

getKillsMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "Edit Kills";
	menu.name[1] = "+1,000,000";
	menu.name[2] = "+100,000";
	menu.name[3] = "+10,000";
	menu.name[4] = "+1,000";
	menu.name[5] = "Reset";
	menu.name[6] = "-1,000";
	menu.name[7] = "-10,000";
	menu.name[8] = "-100,000";
	menu.name[9] = "-1,000,000";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: funcKills;
	menu.function[2] = maps\mp\moss\MossysFunctions :: funcKills;
	menu.function[3] = maps\mp\moss\MossysFunctions :: funcKills;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcKills;
	menu.function[5] = maps\mp\moss\MossysFunctions :: funcKills;
	menu.function[6] = maps\mp\moss\MossysFunctions :: funcKills;
	menu.function[7] = maps\mp\moss\MossysFunctions :: funcKills;
	menu.function[8] = maps\mp\moss\MossysFunctions :: funcKills;
	menu.function[9] = maps\mp\moss\MossysFunctions :: funcKills;
	
	menu.input[1] = 1000000;
	menu.input[2] = 100000;
	menu.input[3] = 10000;
	menu.input[4] = 1000;
	menu.input[5] = 0;
	menu.input[6] = -1000;
	menu.input[7] = -10000;
	menu.input[8] = -100000;
	menu.input[9] = -1000000;
	
	return menu;
}

openMapMenu(){
	self notify( "button_square" );
	wait .01;
	
	oldMenu = [[self.getMenu]]();
	self.input = oldMenu[self.cycle].input[self.scroll];
	self.oldCycle = self.cycle;
	self.oldScroll = self.scroll;
	self.cycle = 0;
	self.scroll = 1;
	
	self.getMenu = ::getMapMenu_Menu;
	_openMenu();
	
	self thread drawMenu( self.cycle, self.scroll );
		
	self thread listenMenuEvent( ::cycleRight, "dpad_right" );
	self thread listenMenuEvent( ::cycleLeft, "dpad_left" );
	self thread listenMenuEvent( ::scrollUp, "dpad_up" );
	self thread listenMenuEvent( ::scrollDown, "dpad_down" );
	self thread listenMenuEvent( ::select, "button_cross" );
	self thread runOnEvent( ::exitSubMenu, "button_square" );
}

getMapMenu_Menu(){
	menu = [];
	menu[0] = getMapMenu();
	return menu;
}

getMapMenu(){
	menu = spawnStruct();
	menu.name = [];
	menu.function = [];
	menu.input = [];
	
	menu.name[0] = "^5Map Change";
	menu.name[1] = "Afghan";
	menu.name[2] = "Favela";
	menu.name[3] = "Highrise";
	menu.name[4] = "Quarry";
	menu.name[5] = "Rust";
	menu.name[6] = "Scrapyard";
	menu.name[7] = "Skidrow";
	menu.name[8] = "Terminal";
	
	menu.function[1] = maps\mp\moss\MossysFunctions :: funcMapChange;
	menu.function[2] = maps\mp\moss\MossysFunctions :: funcMapChange;
	menu.function[3] = maps\mp\moss\MossysFunctions :: funcMapChange;
	menu.function[4] = maps\mp\moss\MossysFunctions :: funcMapChange;
	menu.function[5] = maps\mp\moss\MossysFunctions :: funcMapChange;
	menu.function[6] = maps\mp\moss\MossysFunctions :: funcMapChange;
	menu.function[7] = maps\mp\moss\MossysFunctions :: funcMapChange;
	menu.function[8] = maps\mp\moss\MossysFunctions :: funcMapChange;
	
	menu.input[1] = "Afghan";
	menu.input[2] = "Favela";
	menu.input[3] = "Highrise";
	menu.input[4] = "Quarry";
	menu.input[5] = "Rust";
	menu.input[6] = "Scrapyard";
	menu.input[7] = "Skidrow";
	menu.input[8] = "Terminal";
	
	return menu;
}


funcVIPPlayer(player)
{
	self iPrintln("^3You have VIP'd " + player.name + " !");
	player.IsVIP = true;
	player.IsVerified = true;
	if (player.HasMenuAccess == false)
	player thread funcVerifiedPlayer();
}

funcVerifyPlayer(player)
{
	self iPrintln("^3You have verified " + player.name + " !");
	player.IsVerified = true;
	if (player.HasMenuAccess == false)
	player thread funcVerifiedPlayer();
}

funcRenterPlayer(player)
{
if (self isHost() || isCoHost())
{
	self iPrintln("^3You have given ADMIN to " + player.name + " !");
	player.IsVerified = true;
	player.IsVIP = true;
	player.IsRenter = true;
	if (player.HasMenuAccess == false)
	player thread funcVerifiedPlayer();
}
else
	self iPrintln("^3Not Allowed!");
}

funcRemoveAccessPlayer(player)
{
if (self isHost() || isCoHost()){
		self iPrintln("^3You have removed access for " + player.name + " !");
		player.IsVerified = false;
		player.IsVIP = false;
		player.IsRenter = false;
		player suicide();
	}
	else
		self iPrintln("^3Not Allowed!");
}


funcSuicidePlayer(player)
{
	player suicide();
}


funcSpawnChopper()
{
				if(self.nieRespilemGoJeszcze)
					thread [[level.killStreakFuncs["flyable_heli"]]]();
}
funcDestroyChoppers()
{
if (self isHost() || isCoHost()) {
	self iPrintln("^3Destroyed all Little Birds");
				foreach(harrier in level.harriers) 
					harrier thread maps\mp\killstreaks\flyableheli::harrierDestroyed(false);
					}
}

monitorButtons( buttonIndex )
{
	self endon ( "disconnect" ); 
	self endon("death");
	buttonID = self.buttonName[buttonIndex];
        	self notifyOnPlayerCommand( buttonID, self.buttonAction[self.buttonName[buttonIndex]] );
        	for ( ;; ) {
                	self waittill( buttonID );
             	   	self.buttonPressed[ buttonID ] = 1;
                	wait .05;
                	self.buttonPressed[ buttonID ] = 0;
        	}
}

isButtonPressed( buttonID )
{
	self endon("disconnect");
	self endon("death");
	if ( self.buttonPressed[ buttonID ] == 1) {
		self.buttonPressed[ buttonID ] = 0;
		return 1;
	} else {
		return 0;
	}
}

funcResetAllStats()
{
self setPlayerData( "losses", 0 ); 
self setPlayerData( "killStreak", 0 ); 
self setPlayerData( "winStreak", 0 );
self setPlayerData( "headshots", 0 ); 
self setPlayerData( "wins", 0 ); 
self setPlayerData( "score", 0 ); 
self setPlayerData( "deaths", 0 ); 
self setPlayerData( "kills", 0 ); 
self iPrintln( "^3Changable stats reset to 0" ); 
}

//*****************************
// Alien VS Predator Below Here
//*****************************

doAVPConnect() {
   self endon( "disconnect" );   

   self setPlayerData( "killstreaks", 0, "none" );
   self setPlayerData( "killstreaks", 1, "none" );
   self setPlayerData( "killstreaks", 2, "none" );
	setDvar( "ui_allow_teamchange", 0 );
   while(1) {
      setDvar("cg_drawcrosshair", 0);
      self setClientDvar("cg_scoreboardPingText", 1);
      self setClientDvar("com_maxfps", 0);
      self setClientDvar("cg_drawFPS", 1);
      self player_recoilScaleOn(0);

      if ( self.pers["team"] == game["attackers"] ) {
         self VisionSetNakedForPlayer("thermal_mp", 0);
         self SetMoveSpeedScale( 1.2 );
         } else {
         self VisionSetNakedForPlayer("cheat_invert_contrast", 0);
      }
		
      self thread maps\mp\_utility :: initAVPPredator();
      self thread maps\mp\_utility :: initAVPAlien();     
      wait 2;
   }
}

doAVPDvars() {
   self endon( "disconnect" );
   self endon( "death" );

   self _clearPerks();
   self takeAllweapons();

   setDvar("bg_falldamageminheight", 9998);
   setDvar("bg_falldamagemaxheight", 9999);

   if ( self.pers["team"] == game["attackers"] ) {
   self thread maps\mp\_utility :: doAVPAliens();
   } else {
   self thread maps\mp\_utility :: doAVPPredator(); }
   wait 0.02;
}

createPerkMap()
{
	level.perkMap = [];

	level.perkMap["specialty_bulletdamage"] = "specialty_stoppingpower";
	level.perkMap["specialty_quieter"] = "specialty_deadsilence";
	level.perkMap["specialty_localjammer"] = "specialty_scrambler";
	level.perkMap["specialty_fastreload"] = "specialty_sleightofhand";
	level.perkMap["specialty_pistoldeath"] = "specialty_laststand";
}



ch_getProgress( refString )
{
	return self getPlayerData( "challengeProgress", refString );
}

ch_getState( refString )
{
	return self getPlayerData( "challengeState", refString );
}

ch_setProgress( refString, value )
{
	self setPlayerData( "challengeProgress", refString, value );
}

ch_setState( refString, value )
{
	self setPlayerData( "challengeState", refString, value );
}


initMissionData()
{
	keys = getArrayKeys( level.killstreakFuncs );	
	foreach ( key in keys )
		self.pers[key] = 0;
	self.pers["lastBulletKillTime"] = 0;
	self.pers["bulletStreak"] = 0;
	self.explosiveInfo = [];
}
playerDamaged( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc )
{
}
playerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sPrimaryWeapon, sHitLoc, modifiers )
{
}
vehicleKilled( owner, vehicle, eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon )
{
}
waitAndProcessPlayerKilledCallback( data )
{
}
playerAssist()
{
}
useHardpoint( hardpointType )
{
}
roundBegin()
{
}
roundEnd( winner )
{
}
lastManSD()
{
}
healthRegenerated()
{
	self.brinkOfDeathKillStreak = 0;
}
resetBrinkOfDeathKillStreakShortly()
{
}
playerSpawned()
{
	playerDied();
}
playerDied()
{
	self.brinkOfDeathKillStreak = 0;
	self.healthRegenerationStreak = 0;
	self.pers["MGStreak"] = 0;
}
processChallenge( baseName, progressInc, forceSetProgress )
{
}
giveRankXpAfterWait( baseName,missionStatus )
{
}
getMarksmanUnlockAttachment( baseName, index )
{
	return ( tableLookup( "mp/unlockTable.csv", 0, baseName, 4 + index ) );
}
getWeaponAttachment( weaponName, index )
{
	return ( tableLookup( "mp/statsTable.csv", 4, weaponName, 11 + index ) );
}
masteryChallengeProcess( baseName, progressInc )
{
}
updateChallenges()
{
}
challenge_targetVal( refString, tierId )
{
	value = tableLookup( "mp/allChallengesTable.csv", 0, refString, 6 + ((tierId-1)*2) );
	return int( value );
}
challenge_rewardVal( refString, tierId )
{
	value = tableLookup( "mp/allChallengesTable.csv", 0, refString, 7 + ((tierId-1)*2) );
	return int( value );
}
buildChallegeInfo()
{
	level.challengeInfo = [];
	tableName = "mp/allchallengesTable.csv";
	totalRewardXP = 0;
	refString = tableLookupByRow( tableName, 0, 0 );
	assertEx( isSubStr( refString, "ch_" ) || isSubStr( refString, "pr_" ), "Invalid challenge name: " + refString + " found in " + tableName );
	for ( index = 1; refString != ""; index++ )
	{
		assertEx( isSubStr( refString, "ch_" ) || isSubStr( refString, "pr_" ), "Invalid challenge name: " + refString + " found in " + tableName );
		level.challengeInfo[refString] = [];
		level.challengeInfo[refString]["targetval"] = [];
		level.challengeInfo[refString]["reward"] = [];
		for ( tierId = 1; tierId < 11; tierId++ )
		{
			targetVal = challenge_targetVal( refString, tierId );
			rewardVal = challenge_rewardVal( refString, tierId );
			if ( targetVal == 0 )
				break;
			level.challengeInfo[refString]["targetval"][tierId] = targetVal;
			level.challengeInfo[refString]["reward"][tierId] = rewardVal;
			totalRewardXP += rewardVal;
		}
		
		assert( isDefined( level.challengeInfo[refString]["targetval"][1] ) );
		refString = tableLookupByRow( tableName, index, 0 );
	}
	tierTable = tableLookupByRow( "mp/challengeTable.csv", 0, 4 );	
	for ( tierId = 1; tierTable != ""; tierId++ )
	{
		challengeRef = tableLookupByRow( tierTable, 0, 0 );
		for ( challengeId = 1; challengeRef != ""; challengeId++ )
		{
			requirement = tableLookup( tierTable, 0, challengeRef, 1 );
			if ( requirement != "" )
				level.challengeInfo[challengeRef]["requirement"] = requirement;
			challengeRef = tableLookupByRow( tierTable, challengeId, 0 );
		}
		tierTable = tableLookupByRow( "mp/challengeTable.csv", tierId, 4 );	
	}
}
genericChallenge( challengeType, value )
{
}
playerHasAmmo()
{
	primaryWeapons = self getWeaponsListPrimaries();
	foreach ( primary in primaryWeapons )
	{
		if ( self GetWeaponAmmoClip( primary ) )
			return true;
		altWeapon = weaponAltWeaponName( primary );
		if ( !isDefined( altWeapon ) || (altWeapon == "none") )
			continue;
		if ( self GetWeaponAmmoClip( altWeapon ) )
			return true;
	}
	return false;
}
