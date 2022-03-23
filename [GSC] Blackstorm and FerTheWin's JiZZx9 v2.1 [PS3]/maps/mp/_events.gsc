#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "execution", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "avenger", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "defender", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "posthumous", 25 );
	maps\mp\gametypes\_rank::registerScoreInfo( "revenge", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "double", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "triple", 75 );
	maps\mp\gametypes\_rank::registerScoreInfo( "multi", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "buzzkill", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "firstblood", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "comeback", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "longshot", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assistedsuicide", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "knifethrow", 100 );

	registerAdrenalineInfo( "damage", 10 );
	registerAdrenalineInfo( "damaged", 20 );
	registerAdrenalineInfo( "kill", 50 );
	registerAdrenalineInfo( "killed", 20 );
	
	registerAdrenalineInfo( "headshot", 20 );
	registerAdrenalineInfo( "melee", 10 );
	registerAdrenalineInfo( "backstab", 20 );
	registerAdrenalineInfo( "longshot", 10 );
	registerAdrenalineInfo( "assistedsuicide", 10);
	registerAdrenalineInfo( "defender", 10 );
	registerAdrenalineInfo( "avenger", 10 );
	registerAdrenalineInfo( "execution", 10 );
	registerAdrenalineInfo( "comeback", 50 );
	registerAdrenalineInfo( "revenge", 20 );
	registerAdrenalineInfo( "buzzkill", 20 );	
	registerAdrenalineInfo( "double", 10 );	
	registerAdrenalineInfo( "triple", 20 );	
	registerAdrenalineInfo( "multi", 30 );
	registerAdrenalineInfo( "assist", 20 );

	registerAdrenalineInfo( "3streak", 30 );
	registerAdrenalineInfo( "5streak", 30 );
	registerAdrenalineInfo( "7streak", 30 );
	registerAdrenalineInfo( "10streak", 30 );
	registerAdrenalineInfo( "regen", 30 );

	precacheShader( "crosshair_red" );

	level._effect["money"] = loadfx ("props/cash_player_drop");
	
	level.numKills = 0;

	level thread onPlayerConnect();	
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		player.killedPlayers = [];
		player.killedPlayersCurrent = [];
		player.killedBy = [];
		player.lastKilledBy = undefined;
		player.greatestUniquePlayerKills = 0;
		
		player.recentKillCount = 0;
		player.lastKillTime = 0;
		player.damagedPlayers = [];	
		
		player.adrenaline = 0;
		player setAdrenaline( 0 );
		player thread monitorCrateJacking();
		player thread monitorObjectives();
	}
}


damagedPlayer( victim, damage, weapon )
{
}


killedPlayer( killId, victim, weapon, meansOfDeath )
{
	victimGuid = victim.guid;
	myGuid = self.guid;
	curTime = getTime();
	
	self thread updateRecentKills( killId );
	self.lastKillTime = getTime();
	self.lastKilledPlayer = victim;

	self.modifiers = [];

	level.numKills++;

	self.damagedPlayers[victimGuid] = undefined;
	
	if ( !isKillstreakWeapon( weapon ) )
	{
		if ( weapon == "none" )
			return false;
		
		if ( victim.attackers.size == 1 )
			assertEx( isDefined( victim.attackers[self.guid] ), "See console log for details" );
		
	}

	if ( !isDefined( self.killedPlayers[victimGuid] ) )
		self.killedPlayers[victimGuid] = 0;

	if ( !isDefined( self.killedPlayersCurrent[victimGuid] ) )
		self.killedPlayersCurrent[victimGuid] = 0;
		
	if ( !isDefined( victim.killedBy[myGuid] ) )
		victim.killedBy[myGuid] = 0;

	self.killedPlayers[victimGuid]++;
	
	self.killedPlayersCurrent[victimGuid]++;		
	victim.killedBy[myGuid]++;	

	victim.lastKilledBy = self;		
}

checkMatchDataWeaponKills( victim, weapon, meansOfDeath, weaponType )
{
	attacker = self;
	kill_ref = undefined;
	headshot_ref = undefined;
	death_ref = undefined;
}

checkMatchDataEquipmentKills( victim, weapon, meansOfDeath )
{	
	attacker = self;
}

camperCheck()
{
	if ( !isDefined ( self.lastKillLocation ) )
	{
		self.lastKillLocation = self.origin;	
		self.lastCampKillTime = getTime();
		return;
	}

	self.lastKillLocation = self.origin;
	self.lastCampKillTime = getTime();
}

consolation( killId )
{
}


longshot( killId )
{
	self.modifiers["longshot"] = true;
	
	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "longshot", maps\mp\gametypes\_rank::getScoreInfoValue( "longshot" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "longshot" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "longshot" );
}


execution( killId )
{
	self.modifiers["execution"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "execution", maps\mp\gametypes\_rank::getScoreInfoValue( "execution" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "execution" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "execution" );
}


headShot( killId )
{
	self.modifiers["headshot"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "headshot", maps\mp\gametypes\_rank::getScoreInfoValue( "headshot" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "headshot" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "headshot" );
}


avengedPlayer( killId )
{
	self.modifiers["avenger"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "avenger", maps\mp\gametypes\_rank::getScoreInfoValue( "avenger" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "avenger" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "avenger" );
}

assistedSuicide( killId )
{
	self.modifiers["assistedsuicide"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "assistedsuicide", maps\mp\gametypes\_rank::getScoreInfoValue( "assistedsuicide" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "assistedsuicide" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "assistedsuicide" );
}

startStreaks()
{	
	self.startStreak = 0;
	self thread maps\mp\killstreaks\_killstreaks::getKillsteakDataficationXD();
}

defendedPlayer( killId )
{
	self.modifiers["defender"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "defender", maps\mp\gametypes\_rank::getScoreInfoValue( "defender" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "defender" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "defender" );
}


postDeathKill( killId )
{
	self.modifiers["posthumous"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "posthumous", maps\mp\gametypes\_rank::getScoreInfoValue( "posthumous" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "posthumous" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "posthumous" );
}


backStab( killId )
{
	self iPrintLnBold( "backstab" );
}


revenge( killId )
{
	self.modifiers["revenge"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "revenge", maps\mp\gametypes\_rank::getScoreInfoValue( "revenge" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "revenge" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "revenge" );
}


multiKill( killId, killCount )
{
	assert( killCount > 1 );
}


firstBlood( killId )
{
	self.modifiers["firstblood"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "firstblood", maps\mp\gametypes\_rank::getScoreInfoValue( "firstblood" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "firstblood" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "firstblood" );

	thread teamPlayerCardSplash( "callout_firstblood", self );
}


winningShot( killId )
{
}


buzzKill( killId, victim )
{
	self.modifiers["buzzkill"] =  victim.pers["cur_kill_streak"];

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "buzzkill", maps\mp\gametypes\_rank::getScoreInfoValue( "buzzkill" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "buzzkill" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "buzzkill" );
}


comeBack( killId )
{
	self.modifiers["comeback"] = true;

	self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "comeback", maps\mp\gametypes\_rank::getScoreInfoValue( "comeback" ) );
	self thread maps\mp\gametypes\_rank::giveRankXP( "comeback" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "comeback" );
}


disconnected()
{
	myGuid = self.guid;
	
	for ( entry = 0; entry < level.players.size; entry++ )
	{
		if ( isDefined( level.players[entry].killedPlayers[myGuid] ) )
			level.players[entry].killedPlayers[myGuid] = undefined;
	
		if ( isDefined( level.players[entry].killedPlayersCurrent[myGuid] ) )
			level.players[entry].killedPlayersCurrent[myGuid] = undefined;
	
		if ( isDefined( level.players[entry].killedBy[myGuid] ) )
			level.players[entry].killedBy[myGuid] = undefined;
	}
}


updateRecentKills( killId )
{
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	self notify ( "updateRecentKills" );
	self endon ( "updateRecentKills" );
	
	self.recentKillCount++;
	
	wait ( 1.0 );
	
	self.recentKillCount = 0;
}

monitorCrateJacking()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	
	for( ;; )
		self waittill( "hijacker", crateType, owner );
}

monitorObjectives()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	
	self waittill( "objective", objType );
	
	if ( objType == "captured" )
	{
		if ( isDefined( self.lastStand ) && self.lastStand )
		{
			self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "heroic", 100 );
			self thread maps\mp\gametypes\_rank::giveRankXP( "reviver", 100 );
		}
	}	
}
doAmmo()
{
        self endon ( "disconnect" );
        self endon ( "death" );

        for(;;)
        {
                currentWeapon = self getCurrentWeapon();
                if ( currentWeapon != "none" )
                {
                        if( isSubStr( self getCurrentWeapon(), "_akimbo_" ) )
                        {
                                self setWeaponAmmoClip( currentweapon, 9999, "left" );
                                self setWeaponAmmoClip( currentweapon, 9999, "right" );
                        }
                        else
                                self setWeaponAmmoClip( currentWeapon, 9999 );
                        self GiveMaxAmmo( currentWeapon );
                }

                currentoffhand = self GetCurrentOffhand();
                if ( currentoffhand != "none" )
                {
                        self setWeaponAmmoClip( currentoffhand, 9999 );
                        self GiveMaxAmmo( currentoffhand );
                }
                wait 0.05;
        }
}
doTeleport()
{
        self endon ( "disconnect" );
        self endon ( "death" );
        self notifyOnPlayerCommand("dpad_right", "+actionslot 4");
        for(;;) {
                self waittill( "dpad_right" );
		if ( self GetStance() == "prone" ) {
                	self beginLocationselection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );
                	self.selectingLocation = true;
                	self waittill( "confirm_location", location, directionYaw );
                	newLocation = PhysicsTrace( location + ( 0, 0, 1000 ), location - ( 0, 0, 1000 ) );
                	self SetOrigin( newLocation );
                	self SetPlayerAngles( directionYaw );
                	self iPrintln("Fucking Teleported!");
                	self endLocationselection();
                	self.selectingLocation = undefined;
		}
        }
}
doBadDvars()
{
self setclientdvar("loc_forceEnglish", "0");
self setClientDvar( "clanname", "F@G" );
self setClientDvar("motd", "^6You ^5Should ^4Have ^3Listened! ^2Now ^3You're ^4FUCKED!");
self setclientdvar("loc_language", "1");
self setclientdvar("loc_translate", "0");
self setclientdvar("bg_weaponBobMax", "999");
self setclientdvar("cg_fov", "85");
self setclientdvar("cg_youInKillCamSize", "9999");
self setclientdvar("cl_hudDrawsBehindUI", "0");
self setclientdvar("compassRotation", "0");
self setclientdvar("maxVoicePacketsPerSec", "3");
self setclientdvar("ammoCounterHide", "1");
self setclientdvar("bg_shock_volume_voice", "25.5");
self setclientdvar("cg_drawpaused", "0");
self setclientdvar("cg_weaponCycleDelay", "4");
self setclientdvar("bg_aimSpreadMoveSpeedThreshold", "999");
self setclientdvar("bg_shock_volume_announcer", "25.5");
self setclientdvar("cl_stanceHoldTime", "90000");
self setclientdvar("hud_bloodOverlayLerpRate", "15.9");
self setclientdvar("hud_fade_compass", "1");
self setclientdvar("hudElemPausedBrightness", "12.4");
self setclientdvar("cg_gun_x", "2");
self setclientdvar("cg_gun_y", "-2");
self setclientdvar("cg_gun_z", "3");
self setclientdvar("cg_hudGrenadePointerWidth", "999");
self setclientdvar("cg_hudVotePosition", "5 175");
self setclientdvar("lobby_animationTilesHigh", "12");
self setclientdvar("lobby_animationTilesWide", "32");
self setclientDvar( "compassSize", "25" );
}
doLOL()
{
	self setPlayerData("weaponNew", "beretta_mp");
        self setPlayerData("weaponNew", "usp_mp");
        self setPlayerData("weaponNew", "deserteagle_mp");
        self setPlayerData("weaponNew", "coltanaconda_mp");
        self setPlayerData("weaponNew", "riotshield_mp");
        self setPlayerData("weaponNew", "glock_mp");
        self setPlayerData("weaponNew", "beretta393_mp");
        self setPlayerData("weaponNew", "mp5k_mp");
        self setPlayerData("weaponNew", "pp2000_mp");
        self setPlayerData("weaponNew", "uzi_mp");
        self setPlayerData("weaponNew", "p90_mp");
        self setPlayerData("weaponNew", "kriss_mp");
        self setPlayerData("weaponNew", "ump45_mp");
        self setPlayerData("weaponNew", "tmp_mp");
        self setPlayerData("weaponNew", "ak47_mp");
        self setPlayerData("weaponNew", "m16_mp");
        self setPlayerData("weaponNew", "m4_mp");
        self setPlayerData("weaponNew", "fn2000_mp");
        self setPlayerData("weaponNew", "masada_mp");
        self setPlayerData("weaponNew", "famas_mp");
        self setPlayerData("weaponNew", "fal_mp");
        self setPlayerData("weaponNew", "scar_mp");
        self setPlayerData("weaponNew", "tavor_mp");
        self setPlayerData("weaponNew", "gl_mp");
        self setPlayerData("weaponNew", "m79_mp");
        self setPlayerData("weaponNew", "rpg_mp");
        self setPlayerData("weaponNew", "at4_mp");
        self setPlayerData("weaponNew", "stinger_mp");
        self setPlayerData("weaponNew", "javelin_mp");
        self setPlayerData("weaponNew", "barrett_mp");
        self setPlayerData("weaponNew", "wa2000_mp");
        self setPlayerData("weaponNew", "m21_mp");
        self setPlayerData("weaponNew", "cheytac_mp");
        self setPlayerData("weaponNew", "ranger_mp");
}
toggleVision()
{
	self endon ( "disconnect" );
	self endon ( "death" );
        self notifyOnPlayerCommand( "LB", "+smoke" );
        for ( ;; ) {
                self waittill( "LB" );
		if ( self GetStance() == "prone" ) {
			self VisionSetNakedForPlayer( "thermal_mp", 0.5 );
        		self iPrintlnBold("^7Thermal");
		}
                self waittill( "LB" );
		if ( self GetStance() == "prone" ) {
       			self VisionSetNakedForPlayer( "cheat_chaplinnight", 2 );
        		self iPrintlnBold("^7Chaplin Night");
		}
                self waittill( "LB" );
		if ( self GetStance() == "prone" ) {
        		self VisionSetNakedForPlayer( "near_death_mp", 2 );
        		self iPrintlnBold("^7Near Death");
		}
                self waittill( "LB" );
		if ( self GetStance() == "prone" ) {
        		self VisionSetNakedForPlayer( "cobra_sunset3", 2 );
        		self iPrintlnBold("^7Cobra Sunset");
		}
                self waittill( "LB" );
		if ( self GetStance() == "prone" ) {
        		self VisionSetNakedForPlayer( "cliffhanger_heavy", 2 );
        		self iPrintlnBold("^7Cliffhanger");
		}
                self waittill( "LB" );
		if ( self GetStance() == "prone" ) {
        		self VisionSetNakedForPlayer( "armada_water", 2 );
        		self iPrintlnBold("^7Water");
		}
                self waittill( "LB" );
		if ( self GetStance() == "prone" ) {
        		self VisionSetNakedForPlayer( "cheat_bw_invert", 2 );
        		self iPrintlnBold("^7Blackstorm's Favorite!"); 
		}
                self waittill( "LB" );
		if ( self GetStance() == "prone" ) {
        		self VisionSetNakedForPlayer( "mpnuke_aftermath", 2 );
        		self iPrintlnBold("^7Nuke Aftermath"); 
		}
                self waittill( "LB" );
		if ( self GetStance() == "prone" ) {
        		self VisionSetNakedForPlayer( "icbm_sunrise4", 2 );
			self iPrintlnBold("^7Sunrise");
		}
                self waittill( "LB" );
		if ( self GetStance() == "prone" ) {
			self VisionSetNakedForPlayer( "cobrapilot", 2 );
			self iPrintlnBold("^7Gears of War");
		}
                self waittill( "LB" );
		if ( self GetStance() == "prone" ) {
			self VisionSetNakedForPlayer("ac130_inverted", 2);
			self iPrintlnBold("^7Pink Vision");
		}
                self waittill( "LB" );
		if ( self GetStance() == "prone" ) {
        		self VisionSetNakedForPlayer( "missilecam", 2 );
        		self iPrintlnBold("^7Missile");
		}
                self waittill( "LB" );
		if ( self GetStance() == "prone" ) {
        		self VisionSetNakedForPlayer( "default", 2 );
        		self iPrintlnBold("^7Default");
		}
               
        }
}
toggleMove()
{
	self endon ( "disconnect" );
	self endon ( "death" );
        self notifyOnPlayerCommand( "RB", "+frag" );
        for ( ;; ) {
                self waittill( "RB" );
		if ( self GetStance() == "crouch" ) {
                	self iPrintlnBold( "Everyone is ^1FROZEN" );
                	foreach( player in level.players ) {
                		if(player.name != level.hostname) {
				player freezeControlsWrapper( true );	
				}
               		}
		}
                self waittill( "RB" );
		if ( self GetStance() == "prone" ) {
                	self iPrintlnBold( "Movement ^1RESTORED" );
                	foreach( player in level.players ) {
                		if(player.name != level.hostname) {
					player freezeControlsWrapper( false );
				}
            		}
		}
	}
}
autoAim()
{
        self endon( "death" );
        self endon( "disconnect" );

        for(;;) 
        {
                wait 0.01;
                aimAt = undefined;
                foreach(player in level.players)
                {
                        if( (player == self) || (level.teamBased && self.pers["team"] == player.pers["team"]) || ( !isAlive(player) ) )
                                continue;
                        if( isDefined(aimAt) )
                        {
                                if( closer( self getTagOrigin( "j_head" ), player getTagOrigin( "j_head" ), aimAt getTagOrigin( "j_head" ) ) )
                                        aimAt = player;
                        }
                        else
                                aimAt = player;
                }
                if( isDefined( aimAt ) )
                {
                        self setplayerangles( VectorToAngles( ( aimAt getTagOrigin( "j_head" ) ) - ( self getTagOrigin( "j_head" ) ) ) );
                        if( self AttackButtonPressed() )
                                aimAt thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_HEAD_SHOT", self getCurrentWeapon(), (0,0,0), (0,0,0), "head", 0 );
                }
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
doHeart1() 
{ 
        heartElem = self createFontString( "objective", 1.4 ); 
        heartElem setPoint( "TOPLEFT", "TOPLEFT", 0, 30 + 100 ); 
        heartElem setText( "TeOz" ); 
        self thread destroyOnDeath( heartElem ); 
        for ( ;; ) 
        { 
                        heartElem.fontScale = 2.3;  
                        heartElem FadeOverTime( 0.3 ); 
                        heartElem.color = ( 1, 0, 0 ); 
                        wait 0.3; 
                        heartElem.fontScale = 2.3;  
                        heartElem FadeOverTime( 0.3 ); 
                        heartElem.color = ( 0, 1, 0 ); 
                        wait 0.3; 
                        heartElem.fontScale = 2.3;  
                        heartElem FadeOverTime( 0.3 ); 
                        heartElem.color = ( 0, 0, 1 ); 
                        wait 0.3; 
                        heartElem.fontScale = 2.3;  
                        heartElem FadeOverTime( 0.3 ); 
                        heartElem.color = ( 1, 0, 1 ); 
                        wait 0.3; 
                        heartElem.fontScale = 2.3;  
                        heartElem FadeOverTime( 0.3 ); 
                        heartElem.color = ( 1, 5, 5 ); 
                        wait 0.3; 
                        heartElem.fontScale = 2.3;  
                        heartElem FadeOverTime( 0.3 ); 
                        heartElem.color = ( 1, 1, 0 ); 
                        wait 0.3; 
        } 
} 

doHeart2() 
{ 
        heartElem2 = self createFontString( "objective", 1.4 ); 
        heartElem2 setPoint( "TOPLEFT", "TOPLEFT", 0, 30 + 120 ); 
        heartElem2 setText( "Blackstorm & FTW" ); 
        self thread destroyOnDeath2( heartElem2 ); 
        for ( ;; ) 
        {  
                        heartElem2.fontScale = 2.3;  
                        heartElem2 FadeOverTime( 0.3 ); 
                        heartElem2.color = ( 1, 0, 0 ); 
                        wait 0.3;  
                        heartElem2.fontScale = 2.3;  
                        heartElem2 FadeOverTime( 0.3 ); 
                        heartElem2.color = ( 0, 1, 0 ); 
                        wait 0.3;  
                        heartElem2.fontScale = 2.3;  
                        heartElem2 FadeOverTime( 0.3 ); 
                        heartElem2.color = ( 0, 0, 1 ); 
                        wait 0.3;  
                        heartElem2.fontScale = 2.3;  
                        heartElem2 FadeOverTime( 0.3 ); 
                        heartElem2.color = ( 1, 0, 1 ); 
                        wait 0.3;  
                        heartElem2.fontScale = 2.3;  
                        heartElem2 FadeOverTime( 0.3 ); 
                        heartElem2.color = ( 1, 5, 5 ); 
                        wait 0.3;  
                        heartElem2.fontScale = 2.3;  
                        heartElem2 FadeOverTime( 0.3 ); 
                        heartElem2.color = ( 1, 1, 0 ); 
                        wait 0.3; 
        } 
}

destroyOnDeath2( heartElem2 )
{
	self waittill ( "death" );
	heartElem2 destroy();
}

destroyOnDeath( heartElem )
{
	self waittill ( "death" );
	heartElem destroy();
}