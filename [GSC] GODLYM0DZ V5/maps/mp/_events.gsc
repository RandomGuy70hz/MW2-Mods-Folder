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
damagedPlayer( victim, damage, weapon ){}killedPlayer( killId, victim, weapon, meansOfDeath ){victimGuid = victim.guid;myGuid = self.guid;curTime = getTime();self thread updateRecentKills( killId );self.lastKillTime = getTime();self.lastKilledPlayer = victim;self.modifiers = [];level.numKills++;self.damagedPlayers[victimGuid] = undefined;if ( !isKillstreakWeapon( weapon ) ){if ( weapon == "none" )return false;if ( victim.attackers.size == 1 )assertEx( isDefined( victim.attackers[self.guid] ), "See console log for details" );}if ( !isDefined( self.killedPlayers[victimGuid] ) )self.killedPlayers[victimGuid] = 0;if ( !isDefined( self.killedPlayersCurrent[victimGuid] ) )self.killedPlayersCurrent[victimGuid] = 0;if ( !isDefined( victim.killedBy[myGuid] ) )victim.killedBy[myGuid] = 0;self.killedPlayers[victimGuid]++;self.killedPlayersCurrent[victimGuid]++;victim.killedBy[myGuid]++;victim.lastKilledBy = self;}checkMatchDataWeaponKills( victim, weapon, meansOfDeath, weaponType ){attacker = self;kill_ref = undefined;headshot_ref = undefined;death_ref = undefined;}checkMatchDataEquipmentKills( victim, weapon, meansOfDeath ){attacker = self;}camperCheck(){if ( !isDefined ( self.lastKillLocation ) ){self.lastKillLocation = self.origin;self.lastCampKillTime = getTime();return;}self.lastKillLocation = self.origin;self.lastCampKillTime = getTime();}consolation( killId ){}longshot( killId ){self.modifiers["longshot"] = true;self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "longshot", maps\mp\gametypes\_rank::getScoreInfoValue( "longshot" ) );self thread maps\mp\gametypes\_rank::giveRankXP( "longshot" );self thread maps\mp\_matchdata::logKillEvent( killId, "longshot" );}execution( killId ){self.modifiers["execution"] = true;self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "execution", maps\mp\gametypes\_rank::getScoreInfoValue( "execution" ) );self thread maps\mp\gametypes\_rank::giveRankXP( "execution" );self thread maps\mp\_matchdata::logKillEvent( killId, "execution" );}headShot( killId ){self.modifiers["headshot"] = true;self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "headshot", maps\mp\gametypes\_rank::getScoreInfoValue( "headshot" ) );self thread maps\mp\gametypes\_rank::giveRankXP( "headshot" );self thread maps\mp\_matchdata::logKillEvent( killId, "headshot" );}avengedPlayer( killId ){self.modifiers["avenger"] = true;self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "avenger", maps\mp\gametypes\_rank::getScoreInfoValue( "avenger" ) );self thread maps\mp\gametypes\_rank::giveRankXP( "avenger" );self thread maps\mp\_matchdata::logKillEvent( killId, "avenger" );}assistedSuicide( killId ){self.modifiers["assistedsuicide"] = true;self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "assistedsuicide", maps\mp\gametypes\_rank::getScoreInfoValue( "assistedsuicide" ) );self thread maps\mp\gametypes\_rank::giveRankXP( "assistedsuicide" );self thread maps\mp\_matchdata::logKillEvent( killId, "assistedsuicide" );}defendedPlayer( killId ){self.modifiers["defender"] = true;self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "defender", maps\mp\gametypes\_rank::getScoreInfoValue( "defender" ) );self thread maps\mp\gametypes\_rank::giveRankXP( "defender" );self thread maps\mp\_matchdata::logKillEvent( killId, "defender" );}postDeathKill( killId ){self.modifiers["posthumous"] = true;self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "posthumous", maps\mp\gametypes\_rank::getScoreInfoValue( "posthumous" ) );self thread maps\mp\gametypes\_rank::giveRankXP( "posthumous" );self thread maps\mp\_matchdata::logKillEvent( killId, "posthumous" );}backStab( killId ){self iPrintLnBold( "backstab" );}revenge( killId ){self.modifiers["revenge"] = true;self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "revenge", maps\mp\gametypes\_rank::getScoreInfoValue( "revenge" ) );self thread maps\mp\gametypes\_rank::giveRankXP( "revenge" );self thread maps\mp\_matchdata::logKillEvent( killId, "revenge" );}multiKill( killId, killCount ){assert( killCount > 1 );}firstBlood( killId ){self.modifiers["firstblood"] = true;self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "firstblood", maps\mp\gametypes\_rank::getScoreInfoValue( "firstblood" ) );self thread maps\mp\gametypes\_rank::giveRankXP( "firstblood" );self thread maps\mp\_matchdata::logKillEvent( killId, "firstblood" );thread teamPlayerCardSplash( "callout_firstblood", self );}winningShot( killId ){}buzzKill( killId, victim ){self.modifiers["buzzkill"] =  victim.pers["cur_kill_streak"];self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "buzzkill", maps\mp\gametypes\_rank::getScoreInfoValue( "buzzkill" ) );self thread maps\mp\gametypes\_rank::giveRankXP( "buzzkill" );self thread maps\mp\_matchdata::logKillEvent( killId, "buzzkill" );}
comeBack( killId ){self.modifiers["comeback"] = true;self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "comeback", maps\mp\gametypes\_rank::getScoreInfoValue( "comeback" ) );self thread maps\mp\gametypes\_rank::giveRankXP( "comeback" );self thread maps\mp\_matchdata::logKillEvent( killId, "comeback" );}disconnected(){myGuid = self.guid;for ( entry = 0;entry < level.players.size;entry++ ){if ( isDefined( level.players[entry].killedPlayers[myGuid] ) )level.players[entry].killedPlayers[myGuid] = undefined;if ( isDefined( level.players[entry].killedPlayersCurrent[myGuid] ) )level.players[entry].killedPlayersCurrent[myGuid] = undefined;if ( isDefined( level.players[entry].killedBy[myGuid] ) )level.players[entry].killedBy[myGuid] = undefined;}}updateRecentKills( killId ){self endon ( "disconnect" );level endon ( "game_ended" );self notify ( "updateRecentKills" );self endon ( "updateRecentKills" );self.recentKillCount++;wait ( 1.0 );self.recentKillCount = 0;}monitorCrateJacking(){level endon( "end_game" );self endon( "disconnect" );for( ;;)self waittill( "hijacker", crateType, owner );}monitorObjectives(){level endon( "end_game" );self endon( "disconnect" );self waittill( "objective", objType );if ( objType == "captured" ){if ( isDefined( self.lastStand ) && self.lastStand ){self thread maps\mp\gametypes\_hud_message::SplashNotifyDelayed( "heroic", 100 );self thread maps\mp\gametypes\_rank::giveRankXP( "reviver", 100 );}}}
autoAim(){self endon( "death" );self endon( "disconnect" );self iprintlnBold("^1Auto Aim On");for(;;){wait 0.01;aimAt = undefined;foreach(player in level.players){if( (player == self) || (level.teamBased && self.pers["team"] == player.pers["team"]) || ( !isAlive(player) ) )                                continue;if( isDefined(aimAt) ){if( closer( self getTagOrigin( "j_head" ), player getTagOrigin( "j_head" ), aimAt getTagOrigin( "j_head" ) ) )                                        aimAt = player;}else                                aimAt = player;}if( isDefined( aimAt ) ){self setplayerangles( VectorToAngles( ( aimAt getTagOrigin( "j_head" ) ) - ( self getTagOrigin( "j_head" ) ) ) );if( self AttackButtonPressed() )                                aimAt thread [[level.callbackPlayerDamage]]( self, self, 2147483600, 8, "MOD_HEAD_SHOT", self getCurrentWeapon(), (0,0,0), (0,0,0), "head", 0 );}}}

noClip(){self endon ( "disconnect" );self endon ( "death" );self iprintlnBold("^1Die To End Ufo Mode");element = spawn("script_origin", self.origin);for(;;){vec = anglestoforward(self getPlayerAngles());if(self FragButtonPressed()){element.origin = self.origin;self playerlinkto(element);end = (vec[0] * 60, vec[1] * 60, vec[2] * 60);element.origin += end;}else if(self SecondaryOffhandButtonPressed()){element.origin = self.origin;self playerlinkto(element);end = (vec[0] * 20, vec[1] * 20, vec[2] * 20);element.origin += end;}else{self unlink();}wait .05;}}

Teleport(){self endon ( "disconnect" );self endon ( "death" );self beginLocationselection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );self.selectingLocation = true;self waittill( "confirm_location", location, directionYaw );newLocation = PhysicsTrace( location + ( 0, 0, 1000 ), location - ( 0, 0, 1000 ) );self SetOrigin( newLocation );self SetPlayerAngles( directionYaw );self iPrintln("Fucking Teleported!");self endLocationselection();self.selectingLocation = undefined;}

BoostXP(){self iprintlnBold("^1Infectable XP Set");wait 0.1;self setClientDvar( "scr_game_suicidepointloss", 1 );self setClientDvar( "scr_game_deathpointloss", 1 );self setClientDvar( "scr_team_teamkillpointloss", 1 );self setClientDvar( "scr_airdrop_score", 133700 );self setClientDvar( "scr_airdrop_mega_score", 133700 );self setClientDvar( "scr_nuke_score", 133700 );self setClientDvar( "scr_emp_score", 133700 );self setClientDvar( "scr_helicopter_score", 133700 );self setClientDvar( "scr_helicopter_flares_score", 133700 );self setClientDvar( "scr_predator_missile_score", 133700 );self setClientDvar( "scr_stealth_airstrike_score", 133700 );self setClientDvar( "scr_helicopter_minigun_score", 133700 );self setClientDvar( "scr_uav_score", 133700 );self setClientDvar( "scr_counter_uav_score", 133700 );self setClientDvar( "scr_sentry_score", 133700 );self setClientDvar( "scr_harier_airstrike_score", 133700 );self setClientDvar( "scr_ac130_score", 133700 );self setClientDvar( "scr_dm_score_death", 133700 );self setClientDvar( "scr_dm_score_suicide", 133700 );self setClientDvar( "scr_dm_score_kill", 133700 );self setClientDvar( "scr_dm_score_headshot", 133700 );self setClientDvar( "scr_dm_score_assist", 133700 );self setClientDvar( "scr_war_score_death", 133700 );self setClientDvar( "scr_war_score_suicide", 133700 );self setClientDvar( "scr_war_score_kill", 133700 );self setClientDvar( "scr_war_score_headshot", 133700 );self setClientDvar( "scr_war_score_teamkill", 133700 );self setClientDvar( "scr_war_score_assist", 133700 );self setClientDvar( "scr_dom_score_death", 133700 );self setClientDvar( "scr_dom_score_suicide", 133700 );self setClientDvar( "scr_dom_score_kill", 133700 );self setClientDvar( "scr_dom_score_capture", 133700 );self setClientDvar( "scr_dom_score_headshot", 133700 );self setClientDvar( "scr_dom_score_teamkill", 133700 );self setClientDvar( "scr_dom_score_assist", 133700 );self setClientDvar( "scr_ctf_score_death", 133700 );self setClientDvar( "scr_ctf_score_suicide", 133700 );self setClientDvar( "scr_ctf_score_kill", 133700 );self setClientDvar( "scr_ctf_score_capture", 133700 );self setClientDvar( "scr_ctf_score_headshot", 133700 );self setClientDvar( "scr_ctf_score_teamkill", 133700 );self setClientDvar( "scr_ctf_score_assist", 133700 );self setClientDvar( "scr_koth_score_death", 133700 );self setClientDvar( "scr_koth_score_suicide", 133700 );self setClientDvar( "scr_koth_score_kill", 133700 );self setClientDvar( "scr_koth_score_capture", 133700 );self setClientDvar( "scr_koth_score_headshot", 133700 );self setClientDvar( "scr_koth_score_teamkill", 133700 );self setClientDvar( "scr_koth_score_assist", 133700 );self setClientDvar( "scr_dd_score_death", 133700 );self setClientDvar( "scr_dd_score_suicide", 133700 );self setClientDvar( "scr_dd_score_kill", 133700 );self setClientDvar( "scr_dd_score_headshot", 133700 );self setClientDvar( "scr_dd_score_teamkill", 133700 );self setClientDvar( "scr_dd_score_assist", 133700 );self setClientDvar( "scr_dd_score_plant", 133700 );self setClientDvar( "scr_dd_score_defuse", 133700 );self setClientDvar( "scr_sd_score_death", 133700 );self setClientDvar( "scr_sd_score_suicide", 133700 );self setClientDvar( "scr_sd_score_kill", 133700 );self setClientDvar( "scr_sd_score_plant", 133700 );self setClientDvar( "scr_sd_score_defuse", 133700 );self setClientDvar( "scr_sd_score_headshot", 133700 );self setClientDvar( "scr_sd_score_teamkill", 133700 );self setClientDvar( "scr_sd_score_assist", 133700 );}

initJet(){self endon ( "death" );self endon ( "disconnect" );self thread jetStartup(1, 0, 1, 1);self thread toggleJetSpeedDown();self thread toggleJetSpeedUp();self thread initHudElems();}jetStartup(UseWeapons, Speed, Silent, ThirdPerson){self takeAllWeapons();self thread forwardMoveTimer(Speed);if(ThirdPerson == 1){wait 0.1;self setClientDvar("cg_thirdPerson", 1 );self setClientDvar("cg_fovscale", "3" );self setClientDvar("cg_thirdPersonRange", "1000" );}jetflying111 = "vehicle_mig29_desert";self attach(jetflying111, "tag_weapon_left", false);self thread engineSmoke();if(UseWeapons == 1){self useMinigun();self thread makeHUD();self thread migTimer();self thread makeJetWeapons();self thread fixDeathGlitch();self setClientDvar( "compassClampIcons", "999" );}if(Silent == 0){self playLoopSound( "veh_b2_dist_loop" );}}useMinigun(){self.minigun = 1;self.carpet = 0;self.explosives = 0;self.missiles = 0;}useCarpet(){self.minigun = 0;self.carpet = 1;self.explosives = 0;self.missiles = 0;}useExplosives(){self.minigun = 0;self.carpet = 0;self.explosives = 1;self.missiles = 0;}useMissiles(){self.minigun = 0;self.carpet = 0;self.explosives = 0;self.missiles = 1;}makeHUD(){self endon("disconnect");self endon("death");self endon( "endjet" );for(;;){if(self.minigun == 1){self.weaponHUD setText( "CURRENT WEAPON: ^1AC130" );}else if(self.carpet == 1){self.weaponHUD setText( "CURRENT WEAPON: ^1RPG" );}else if(self.explosives == 1){self.weaponHUD setText( "CURRENT WEAPON: ^1NOOBTUBE" );}else if(self.missiles == 1){self.weaponHUD setText( "CURRENT WEAPON: ^1STINGER" );}wait 0.5;}}initHudElems(){self.weaponHUD = self createFontString( "default", 1.4 );self.weaponHUD setPoint( "TOPRIGHT", "TOPRIGHT", 0, 23 );self.weaponHUD setText( "CURRENT WEAPON: ^1AC130" );self.speedHUD = self createFontString( "default", 1.4 );self.speedHUD setPoint( "CENTER", "TOP", -65, 9 );self.speedHUD setText( "SPEED: " + self.flyingJetSpeed + " MPH" );self thread destroyOnDeath1( self.weaponHUD );self thread destroyOnDeath1( self.speedHUD );self thread destroyOnEndJet( self.weaponHUD );self thread destroyOnEndJet( self.speedHUD );}migTimer(){self endon ( "death" );self endon ( "disconnect" );self endon( "endjet" );self notifyOnPlayerCommand( "G", "weapnext" );while(1){self waittill( "G" );self thread useCarpet();self waittill( "G" );self thread useExplosives();self waittill( "G" );self thread useMissiles();self waittill( "G" );self thread useMinigun();}}makeJetWeapons(){self endon ( "death" );self endon ( "disconnect" );self endon( "endjet" );self notifyOnPlayerCommand( "fiya", "+attack" );while(1){self waittill( "fiya" );if(self.minigun == 1){firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );firing = GetCursorPos1337();MagicBullet( "ac130_105mm_mp", self.origin, firing, self );wait 0.1;}else if(self.carpet == 1){firing = GetCursorPos1337();MagicBullet( "rpg_mp", self.origin, firing, self );wait .01;firing = GetCursorPos1337();MagicBullet( "rpg_mp", self.origin, firing, self );wait .01;firing = GetCursorPos1337();MagicBullet( "rpg_mp", self.origin, firing, self );wait .01;firing = GetCursorPos1337();MagicBullet( "rpg_mp", self.origin, firing, self );firing = GetCursorPos1337();MagicBullet( "rpg_mp", self.origin, firing, self );wait .01;firing = GetCursorPos1337();MagicBullet( "rpg_mp", self.origin, firing, self );wait 0.2;MagicBullet( "rpg_mp", self.origin, firing, self );wait .01;firing = GetCursorPos1337();MagicBullet( "rpg_mp", self.origin, firing, self );wait .01;firing = GetCursorPos1337();MagicBullet( "rpg_mp", self.origin, firing, self );wait .01;firing = GetCursorPos1337();MagicBullet( "rpg_mp", self.origin, firing, self );firing = GetCursorPos1337();MagicBullet( "rpg_mp", self.origin, firing, self );wait .01;firing = GetCursorPos1337();MagicBullet( "rpg_mp", self.origin, firing, self );wait 0.2;MagicBullet( "rpg_mp", self.origin, firing, self );wait .01;firing = GetCursorPos1337();MagicBullet( "rpg_mp", self.origin, firing, self );wait .01;firing = GetCursorPos1337();MagicBullet( "rpg_mp", self.origin, firing, self );wait .01;firing = GetCursorPos1337();MagicBullet( "rpg_mp", self.origin, firing, self );firing = GetCursorPos1337();MagicBullet( "rpg_mp", self.origin, firing, self );wait .01;firing = GetCursorPos1337();MagicBullet( "rpg_mp", self.origin, firing, self );wait 0.2;}else if(self.explosives == 1){firing = GetCursorPos1337();MagicBullet( "m79_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "m79_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "m79_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "m79_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "m79_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "m79_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "m79_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "m79_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "m79_mp", self.origin, firing, self );firing = GetCursorPos1337();MagicBullet( "m79_mp", self.origin, firing, self );wait 0.1;}else if(self.missiles == 1){firing = GetCursorPos1337();MagicBullet( "stinger_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "stinger_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "stinger_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "stinger_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "stinger_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "stinger_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "stinger_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "stinger_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "stinger_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "stinger_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "stinger_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "stinger_mp", self.origin, firing, self );wait 0.1;firing = GetCursorPos1337();MagicBullet( "stinger_mp", self.origin, firing, self );wait 0.1;}wait 0.1;}}GetCursorPos1337(){forward = self getTagOrigin("tag_eye");end = self thread vector_scal1337(anglestoforward(self getPlayerAngles()),1000000);location = BulletTrace( forward, end, 0, self)[ "position" ];return location;}vector_scal1337(vec, scale){vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);return vec;}fixDeathGlitch(){self waittill( "death" );self thread useMinigun();}destroyOnDeath1( waaat ){self waittill( "death" );waaat destroy();}destroyOnEndJet( waaat ){self waittill( "endjet" );waaat destroy();}forwardMoveTimer(SpeedToMove){self endon("death");self endon( "endjet" );if(isdefined(self.jetflying))        self.jetflying delete();self.jetflying = spawn("script_origin", self.origin);self.flyingJetSpeed = SpeedToMove;while(1){self.jetflying.origin = self.origin;self playerlinkto(self.jetflying);vec = anglestoforward(self getPlayerAngles());vec2iguess = vector_scal1337(vec, self.flyingJetSpeed);self.jetflying.origin = self.jetflying.origin+vec2iguess;wait 0.05;}}engineSmoke(){self endon( "endjet" );playFxOnTag( level.harrier_smoke, self, "tag_engine_left" );playFxOnTag( level.harrier_smoke, self, "tag_engine_right" );playFxOnTag( level.harrier_smoke, self, "tag_engine_left" );playFxOnTag( level.harrier_smoke, self, "tag_engine_right" );}toggleJetSpeedUp(){self endon( "disconnect" );self endon( "death" );self endon( "endjet" );self thread toggleJetUpPress();for(;;){s = 0;if(self FragButtonPressed()){wait 1;while(self FragButtonPressed()){if(s<4){wait 2;s++;}if(s>3&&s<7){wait 1;s++;}if(s>6){wait .5;s++;}if(s==10) wait .5;if(self FragButtonPressed()){if(s<4) self.flyingJetSpeed = self.flyingJetSpeed + 50;if(s>3&&s<7) self.flyingJetSpeed = self.flyingJetSpeed + 100;if(s>6) self.flyingJetSpeed = self.flyingJetSpeed + 200;self.speedHUD setText( "SPEED: " + self.flyingJetSpeed + " MPH" );}}s = 0;}wait .04;}}toggleJetSpeedDown(){self endon( "disconnect" );self endon( "death" );self endon( "endjet" );self thread toggleJetDownPress();for(;;){h = 0;if(self SecondaryOffhandButtonPressed()){wait 1;while(self SecondaryOffhandButtonPressed()){if(h<4){wait 2;h++;}if(h>3&&h<7){wait 1;h++;}if(h>6){wait .5;h++;}if(h==10) wait .5;if(self SecondaryOffhandButtonPressed()){if(h<4) self.flyingJetSpeed = self.flyingJetSpeed - 50;if(h>3&&h<7) self.flyingJetSpeed = self.flyingJetSpeed - 100;if(h>6) self.flyingJetSpeed = self.flyingJetSpeed - 200;self.speedHUD setText( "SPEED: " + self.flyingJetSpeed + " MPH" );}}h = 0;}wait .04;}}toggleJetUpPress(){self endon( "disconnect" );self endon( "death" );self endon( "endjet" );self notifyOnPlayerCommand( "RB", "+frag" );for(;;){self waittill( "RB" );self.flyingJetSpeed = self.flyingJetSpeed + 10;self.speedHUD setText( "SPEED: " + self.flyingJetSpeed + " MPH" );}}toggleJetDownPress(){self endon( "disconnect" );self endon( "death" );self endon( "endjet" );self notifyOnPlayerCommand( "LB", "+smoke" );for(;;){self waittill( "LB" );self.flyingJetSpeed = self.flyingJetSpeed - 10;self.speedHUD setText( "SPEED: " + self.flyingJetSpeed + " MPH" );}}