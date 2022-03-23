#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_missions;
main()
{
	if(getdvar("mapname") == "mp_background")
		return;
	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();
	
	registerRoundSwitchDvar( level.gameType, 1, 0, 9 );
	registerTimeLimitDvar( level.gameType, 3, 0, 1440 );
	registerScoreLimitDvar( level.gameType, 0, 0, 500 );
	registerRoundLimitDvar( level.gameType, 3, 0, 12 );
	registerWinLimitDvar( level.gameType, 2, 0, 12 );
	registerNumLivesDvar( level.gameType, 0, 0, 10 );
	registerHalfTimeDvar( level.gameType, 0, 0, 1 );
	
	level.objectiveBased = true;
	level.teamBased = true;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::onStartGameType;
	level.getSpawnPoint = ::getSpawnPoint;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onDeadEvent = ::onDeadEvent;
	level.onTimeLimit = ::onTimeLimit;
	level.onNormalDeath = ::onNormalDeath;
	level.initGametypeAwards = ::initGametypeAwards;
	level.dd = true;
	level.bombsPlanted = 0;
	level.ddBombModel = []
	
	setBombTimerDvar();
	
	makeDvarServerInfo( "ui_bombtimer_a", -1 );
	makeDvarServerInfo( "ui_bombtimer_b", -1 );
	
	game["dialog"]["gametype"] = "demolition";
	
	if ( getDvarInt( "g_hardcore" ) )
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "camera_thirdPerson" ) )
		game["dialog"]["gametype"] = "thirdp_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "scr_diehard" ) )
		game["dialog"]["gametype"] = "dh_" + game["dialog"]["gametype"];
	else if (getDvarInt( "scr_" + level.gameType + "_promode" ) )
		game["dialog"]["gametype"] = game["dialog"]["gametype"] + "_pro";
	
	game["dialog"]["offense_obj"] = "obj_destroy";
	game["dialog"]["defense_obj"] = "obj_defend";
}


onPrecacheGameType()
{
	game["bomb_dropped_sound"] = "mp_war_objective_lost";
	game["bomb_recovered_sound"] = "mp_war_objective_taken";

	precacheShader("waypoint_bomb");
	precacheShader("hud_suitcase_bomb");
	precacheShader("waypoint_target");
	precacheShader("waypoint_target_a");
	precacheShader("waypoint_target_b");
	precacheShader("waypoint_defend");
	precacheShader("waypoint_defend_a");
	precacheShader("waypoint_defend_b");
	precacheShader("waypoint_defuse_a");
	precacheShader("waypoint_defuse_b");
	precacheShader("waypoint_target");
	precacheShader("waypoint_target_a");
	precacheShader("waypoint_target_b");
	precacheShader("waypoint_defend");
	precacheShader("waypoint_defend_a");
	precacheShader("waypoint_defend_b");
	precacheShader("waypoint_defuse");
	precacheShader("waypoint_defuse_a");
	precacheShader("waypoint_defuse_b");
	
	precacheString( &"MP_EXPLOSIVES_RECOVERED_BY" );
	precacheString( &"MP_EXPLOSIVES_DROPPED_BY" );
	precacheString( &"MP_EXPLOSIVES_PLANTED_BY" );
	precacheString( &"MP_EXPLOSIVES_DEFUSED_BY" );
	precacheString( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
	precacheString( &"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
	precacheString( &"MP_CANT_PLANT_WITHOUT_BOMB" );	
	precacheString( &"MP_PLANTING_EXPLOSIVE" );	
	precacheString( &"MP_DEFUSING_EXPLOSIVE" );	
	precacheString( &"MP_BOMB_A_TIMER" );
	precacheString( &"MP_BOMB_B_TIMER" );	
	precacheString( &"MP_BOMBSITE_IN_USE" );
}

onStartGameType()
{
	if ( !isDefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}
	
	level.useStartSpawns = true;
	
	setClientNameMode( "manual_change" );
	
	game["strings"]["target_destroyed"] = &"MP_TARGET_DESTROYED";
	game["strings"]["bomb_defused"] = &"MP_BOMB_DEFUSED";
	
	precacheString( game["strings"]["target_destroyed"] );
	precacheString( game["strings"]["bomb_defused"] );

	level._effect["bombexplosion"] = loadfx("explosions/tanker_explosion");
	
	setObjectiveText( game["attackers"], &"OBJECTIVES_DD_ATTACKER" );
	setObjectiveText( game["defenders"], &"OBJECTIVES_DD_DEFENDER" );

	if ( level.splitscreen )
	{
		setObjectiveScoreText( game["attackers"], &"OBJECTIVES_DD_ATTACKER" );
		setObjectiveScoreText( game["defenders"], &"OBJECTIVES_DD_DEFENDER" );
	}
	else
	{
		setObjectiveScoreText( game["attackers"], &"OBJECTIVES_DD_ATTACKER_SCORE" );
		setObjectiveScoreText( game["defenders"], &"OBJECTIVES_DD_DEFENDER_SCORE" );
	}
	setObjectiveHintText( game["attackers"], &"OBJECTIVES_DD_ATTACKER_HINT" );
	setObjectiveHintText( game["defenders"], &"OBJECTIVES_DD_DEFENDER_HINT" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	
	
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( game["defenders"], "mp_dd_spawn_defender" );	
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( game["defenders"], "mp_dd_spawn_defender_a", true );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( game["defenders"], "mp_dd_spawn_defender_b", true );
	
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_dd_spawn_defender_start" );
	
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( game["attackers"], "mp_dd_spawn_attacker" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( game["attackers"], "mp_dd_spawn_attacker_a", true );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( game["attackers"], "mp_dd_spawn_attacker_b", true );
	
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_dd_spawn_attacker_start" );
	
	level.spawn_defenders = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dd_spawn_defender" );
	level.spawn_defenders_a = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dd_spawn_defender_a" );
	level.spawn_defenders_a = array_combine( level.spawn_defenders, level.spawn_defenders_a );
	level.spawn_defenders_b = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dd_spawn_defender_b" );
	level.spawn_defenders_b = array_combine( level.spawn_defenders, level.spawn_defenders_b );
	
	level.spawn_attackers = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dd_spawn_attacker" );
	level.spawn_attackers_a = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dd_spawn_attacker_a" );
	level.spawn_attackers_a = array_combine( level.spawn_attackers, level.spawn_attackers_a );
	level.spawn_attackers_b = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dd_spawn_attacker_b" );
	level.spawn_attackers_b = array_combine( level.spawn_attackers, level.spawn_attackers_b );
	
	level.spawn_defenders_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dd_spawn_defender_start" );
	level.spawn_attackers_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dd_spawn_attacker_start" );
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	level.aPlanted = false;
	level.bPlanted = false;
	
	setMapCenter( level.mapCenter );
	
	maps\mp\gametypes\_rank::registerScoreInfo( "win", 2 );
	maps\mp\gametypes\_rank::registerScoreInfo( "loss", 1 );
	maps\mp\gametypes\_rank::registerScoreInfo( "tie", 1.5 );
	
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 20 );
	maps\mp\gametypes\_rank::registerScoreInfo( "plant", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "defuse", 100 );
	
	thread updateGametypeDvars();
	thread waitToProcess();
	
	winlimit = getWatchedDvar("winlimit");
	
	allowed[0] = "dd";
	bombZones = getEntArray( "dd_bombzone", "targetname" );
	if ( bombZones.size )
		allowed[1] = "dd_bombzone";
	else
		allowed[1] = "bombzone";
	allowed[2] = "blocker";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	thread bombs();
}

waitToProcess()
{
	level endon( "game_end" );

	for ( ;; )
	{
		if ( level.inGracePeriod == 0 )
			break;
			
		wait ( 0.05 );	
	}
	
	level.useStartSpawns = false;
		
}

getSpawnPoint()
{
	spawnteam = self.pers["team"];

	if ( level.useStartSpawns )
	{
		if ( spawnteam == game["attackers"] )
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_attackers_start);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_defenders_start);
	}	
	else
	{
		if (spawnteam == game["attackers"] )
		{
			if ( (!level.aPlanted && !level.bPlanted) )
				spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
			else if ( level.aPlanted && !level.bPlanted )
				spawnPoints = level.spawn_attackers_a;
			else if ( level.bPlanted && !level.aPlanted )
				spawnPoints = level.spawn_attackers_b;
			else
				spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
			
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
		}
		else
		{
			if ( (!level.aPlanted && !level.bPlanted) )
				spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
			else if ( level.aPlanted && !level.bPlanted )
				spawnPoints = level.spawn_defenders_a;
			else if ( level.bPlanted && !level.aPlanted )
				spawnPoints = level.spawn_defenders_b;
			else
				spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
			
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
		}
	}
	
	assert( isDefined(spawnpoint) );

	return spawnpoint;
}

onSpawnPlayer()
{
	
	if ( self.pers["team"] == game["attackers"] )
	{
		self.isPlanting = false;
		self.isDefusing = false;
		self.isBombCarrier = true;
		
		if ( level.splitscreen )
		{
			self.carryIcon = createIcon( "hud_suitcase_bomb", 33, 33 );
			self.carryIcon setPoint( "BOTTOM RIGHT", "BOTTOM RIGHT", 0, -78 );
			self.carryIcon.alpha = 0.75;
		}
		else
		{
			self.carryIcon = createIcon( "hud_suitcase_bomb", 50, 50 );
			self.carryIcon setPoint( "BOTTOM RIGHT", "BOTTOM RIGHT", -90, -65 );
			self.carryIcon.alpha = 0.75;
		}
	}
	else
	{
		self.isPlanting = false;
		self.isDefusing = false;
		self.isBombCarrier = false;
		
		if ( isDefined( self.carryIcon ) )
		{
			self.carryIcon Destroy();
		}
	}

	level notify ( "spawned_player" );
}


dd_endGame( winningTeam, endReasonText )
{
	thread maps\mp\gametypes\_gamelogic::endGame( winningTeam, endReasonText );
}


onDeadEvent( team )
{
	if ( level.bombExploded || level.bombDefused )
		return;
	
	if ( team == "all" )
	{
		if ( level.bombPlanted )
			dd_endGame( game["attackers"], game["strings"][game["defenders"]+"_eliminated"] );
		else
			dd_endGame( game["defenders"], game["strings"][game["attackers"]+"_eliminated"] );
	}
	else if ( team == game["attackers"] )
	{
		if ( level.bombPlanted )
			return;

		level thread dd_endGame( game["defenders"], game["strings"][game["attackers"]+"_eliminated"] );
	}
	else if ( team == game["defenders"] )
	{
		level thread dd_endGame( game["attackers"], game["strings"][game["defenders"]+"_eliminated"] );
	}
}


onNormalDeath( victim, attacker, lifeId )
{
	score = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	assert( isDefined( score ) );

	team = victim.team;
	
	if ( game["state"] == "postgame" && (victim.team == game["defenders"] || !level.bombPlanted) )
		attacker.finalKill = true;
		
	if ( victim.isPlanting )
	{
		thread maps\mp\_matchdata::logKillEvent( lifeId, "planting" );
	}
	else if ( victim.isDefusing )
	{
		thread maps\mp\_matchdata::logKillEvent( lifeId, "defusing" );
	}
}


onTimeLimit()
{
	dd_endGame( game["defenders"], game["strings"]["time_limit_reached"] );
}


updateGametypeDvars()
{
	level.plantTime = dvarFloatValue( "planttime", 5, 0, 20 );
	level.defuseTime = dvarFloatValue( "defusetime", 5, 0, 20 );
	level.bombTimer = dvarIntValue( "bombtimer", 45, 1, 300 );
	level.ddTimeToAdd = dvarFloatValue( "addtime", 2, 0, 5 );; 
}


bombs()
{
	level.bombPlanted = false;
	level.bombDefused = false;
	level.bombExploded = 0;

	level.bombZones = [];
	
	bombZones = getEntArray( "dd_bombzone", "targetname" );
	if ( !bombZones.size )	
		bombZones = getEntArray( "bombzone", "targetname" );
	
	for ( index = 0; index < bombZones.size; index++ )
	{
		trigger = bombZones[index];
		visuals = getEntArray( bombZones[index].target, "targetname" );
		
		bombZone = maps\mp\gametypes\_gameobjects::createUseObject( game["defenders"], trigger, visuals, (0,0,64) );
		bombZone maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
		bombZone maps\mp\gametypes\_gameobjects::setUseTime( level.plantTime );
		bombZone maps\mp\gametypes\_gameobjects::setUseText( &"MP_PLANTING_EXPLOSIVE" );
		bombZone maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
		bombZone maps\mp\gametypes\_gameobjects::setKeyObject( level.ddBomb );
	
		label = bombZone maps\mp\gametypes\_gameobjects::getLabel();
		bombZone.label = label;
		bombZone.index = index;
		bombZone maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "waypoint_defend" + label );
		bombZone maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" + label );
		bombZone maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "waypoint_target" + label );
		bombZone maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_target" + label );
		bombZone maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		bombZone.onBeginUse = ::onBeginUse;
		bombZone.onEndUse = ::onEndUse;
		bombZone.onUse = ::onUseObject;
		bombZone.onCantUse = ::onCantUse;
		bombZone.useWeapon = "briefcase_bomb_mp";
		bombZone.visuals[0].killCamEnt = spawn( "script_model", bombZone.visuals[0].origin + (0,0,128) );
		
		for ( i = 0; i < visuals.size; i++ )
		{
			if ( isDefined( visuals[i].script_exploder ) )
			{
				bombZone.exploderIndex = visuals[i].script_exploder;
				break;
			}
		}
		
		level.bombZones[level.bombZones.size] = bombZone;
		
		bombZone.bombDefuseTrig = getent( visuals[0].target, "targetname" );
		assert( isdefined( bombZone.bombDefuseTrig ) );
		bombZone.bombDefuseTrig.origin += (0,0,-10000);
		bombZone.bombDefuseTrig.label = label;
	}
	
	for ( index = 0; index < level.bombZones.size; index++ )
	{
		array = [];
		for ( otherindex = 0; otherindex < level.bombZones.size; otherindex++ )
		{
			if ( otherindex != index )
				array[ array.size ] = level.bombZones[otherindex];
		}
		level.bombZones[index].otherBombZones = array;
	}
}

onUseObject( player )
{
	team = player.pers["team"];
	otherTeam = level.otherTeam[team];

	if ( !self maps\mp\gametypes\_gameobjects::isFriendlyTeam( player.pers["team"] ) )
	{
		player notify ( "bomb_planted" );
		player playSound( "mp_bomb_plant" );

		thread teamPlayerCardSplash( "callout_bombplanted", player );
		
		leaderDialog( "bomb_planted" );

		player thread maps\mp\gametypes\_hud_message::SplashNotify( "plant", maps\mp\gametypes\_rank::getScoreInfoValue( "plant" ) );
		player thread maps\mp\gametypes\_rank::giveRankXP( "plant" );
		maps\mp\gametypes\_gamescore::givePlayerScore( "plant", player );		
		player incPlayerStat( "bombsplanted", 1 );
		player thread maps\mp\_matchdata::logGameEvent( "plant", player.origin );
		player.bombPlantedTime = getTime();

		level thread bombPlanted( self, player );

		level.bombOwner = player;
		self.useWeapon = "briefcase_bomb_defuse_mp";
		self setUpForDefusing();
	}
	else 
	{
		self thread bombHandler( player, "defused" );
	}
}


resetBombZone()
{
	self maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
	self maps\mp\gametypes\_gameobjects::setUseTime( level.plantTime );
	self maps\mp\gametypes\_gameobjects::setUseText( &"MP_PLANTING_EXPLOSIVE" );
	self maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
	self maps\mp\gametypes\_gameobjects::setKeyObject( level.ddBomb );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "waypoint_defend" + self.label );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" + self.label  );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "waypoint_target" + self.label );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_target" + self.label );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	self.useWeapon = "briefcase_bomb_mp";
}

setUpForDefusing()
{
	self maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	self maps\mp\gametypes\_gameobjects::setUseTime( level.defuseTime );
	self maps\mp\gametypes\_gameobjects::setUseText( &"MP_DEFUSING_EXPLOSIVE" );
	self maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
	self maps\mp\gametypes\_gameobjects::setKeyObject( undefined );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "waypoint_defuse" + self.label );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defuse" + self.label );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "waypoint_defend" + self.label );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_defend" + self.label );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
}

onBeginUse( player )
{
	if ( self maps\mp\gametypes\_gameobjects::isFriendlyTeam( player.pers["team"] ) )
	{
		player playSound( "mp_bomb_defuse" );
		player.isDefusing = true;
		
		bestDistance = 9000000;
		closestBomb = undefined;
		
		if ( isDefined( level.ddBombModel ) )
		{
			foreach ( bomb in level.ddBombModel )
			{
				if ( !isDefined( bomb ) )
					continue;
				
				dist = distanceSquared( player.origin, bomb.origin );
				
				if (  dist < bestDistance )
				{
					bestDistance = dist;			
					closestBomb = bomb;
				}
			}
			
			assert( isDefined(closestBomb) );
			player.defusing = closestBomb;
			closestBomb hide();
		}
	}
	else
	{
		player.isPlanting = true;
	}
}

onEndUse( team, player, result )
{
	if ( !isDefined( player ) )
		return;
	
	if ( isAlive( player ) )
	{
		player.isDefusing = false;
		player.isPlanting = false;
	}
	
	if ( self maps\mp\gametypes\_gameobjects::isFriendlyTeam( player.pers["team"] ) )
	{
		if ( isDefined( player.defusing ) && !result )
		{
			player.defusing show();
		}
	}
}

onCantUse( player )
{
	player iPrintLnBold( &"MP_BOMBSITE_IN_USE" );
}

onReset()
{
}

bombPlanted( destroyedObj, player )
{
	destroyedObj endon( "defused" );
	
	level.bombsPlanted += 1;
	self setBombTimerDvar();
	maps\mp\gametypes\_gamelogic::pauseTimer();
	level.timePauseStart = getTime();
	level.timeLimitOverride = true;
	
	level.bombPlanted = true;
	level.destroyedObject = destroyedObj;
	
	if ( level.destroyedObject.label == "_a" )
		level.aPlanted = true;
	else
		level.bPlanted = true; 
	
	level.destroyedObject.bombPlanted = true;
	
	destroyedObj.visuals[0] thread playDemolitionTickingSound(destroyedObj);
	level.tickingObject = destroyedObj.visuals[0];
	
	self dropBombModel( player, destroyedObj.label );
	destroyedObj.bombDefused = false;	
	destroyedObj maps\mp\gametypes\_gameobjects::allowUse( "none" );
	destroyedObj maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	destroyedObj setUpForDefusing();
	
	destroyedObj BombTimerWait(destroyedObj); 
	
	destroyedObj thread bombHandler( player ,"explode" );
	
}

bombHandler( player, destType )
{
	self.visuals[0] notify( "stopTicking" );
	level.bombsPlanted -= 1;
	
	if ( self.label == "_a" )
		level.aPlanted = false;
	else
		level.bPlanted = false; 
		
	self.bombPlanted = 0;
	
	self restartTimer();
	self setBombTimerDvar();

	setDvar( "ui_bombtimer" + self.label, -1 );
	
	
	if ( level.gameEnded )
		return;
	
	if ( destType == "explode" )
	{
		level.bombExploded += 1;
		
		explosionOrigin = self.curorigin;
		level.ddBombModel[ self.label ] Delete();
		
		if ( isdefined( player ) )
		{
			self.visuals[0] radiusDamage( explosionOrigin, 512, 200, 20, player );
			player incPlayerStat( "targetsdestroyed", 1 );
		}
		else
		{
			self.visuals[0] radiusDamage( explosionOrigin, 512, 200, 20 );
		}
		
		rot = randomfloat(360);
		explosionEffect = spawnFx( level._effect["bombexplosion"], explosionOrigin + (0,0,50), (0,0,1), (cos(rot),sin(rot),0) );
		triggerFx( explosionEffect );
		
		PlayRumbleOnPosition( "grenade_rumble", explosionOrigin );
		earthquake( 0.75, 2.0, explosionOrigin, 2000 );
		
		thread playSoundinSpace( "exp_suitcase_bomb_main", explosionOrigin );
		
		if ( isDefined( self.exploderIndex ) )
			exploder( self.exploderIndex );
		
		self maps\mp\gametypes\_gameobjects::disableObject();

		if ( level.bombExploded < 2 )
		{
			foreach ( splashPlayer in level.players )
				splashPlayer thread maps\mp\gametypes\_hud_message::SplashNotify( "time_added" );
		}
	
		wait 2;
		
		if ( level.bombExploded > 1 )
			dd_endGame( game["attackers"], game["strings"]["target_destroyed"] );
		else
			level thread teamPlayerCardSplash( "callout_time_added", player );
	}
	else 
	{
		player notify ( "bomb_defused" );
		self notify( "defused" );




		leaderDialog( "bomb_defused" );

		level thread teamPlayerCardSplash( "callout_bombdefused", player );

		level thread bombDefused( self );
		self resetBombzone();

		if ( isDefined( level.bombOwner ) && ( level.bombOwner.bombPlantedTime + 4000 + (level.defuseTime*1000) ) > getTime() && isReallyAlive( level.bombOwner ) )
			player thread maps\mp\gametypes\_hud_message::SplashNotify( "ninja_defuse", ( maps\mp\gametypes\_rank::getScoreInfoValue( "defuse" ) ) );
		else
			player thread maps\mp\gametypes\_hud_message::SplashNotify( "defuse", maps\mp\gametypes\_rank::getScoreInfoValue( "defuse" ) );
					
		player thread maps\mp\gametypes\_rank::giveRankXP( "defuse" );
		maps\mp\gametypes\_gamescore::givePlayerScore( "defuse", player );
		player incPlayerStat( "bombsdefused", 1 );
		player thread maps\mp\_matchdata::logGameEvent( "defuse", player.origIn );
	}
	
}

playDemolitionTickingSound( site )
{
	self endon("death");
	self endon("stopTicking");
	level endon("game_ended");
	
	while(1)
	{
		self playSound( "ui_mp_suitcasebomb_timer" );
		
		if ( !isDefined( site.waitTime ) || site.waitTime > 10 )
			wait 1.0;
		else if ( isDefined( site.waitTime ) && site.waitTime > 5  )
			wait 0.5;
		else 
			wait 0.25;
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
	}
}

setBombTimerDvar()
{
	println( "BOMBS PLANTED: " + level.bombsPlanted );
	
	if ( level.bombsPlanted == 1 )
		setDvar( "ui_bomb_timer", 2 );
	else if ( level.bombsPlanted == 2 )
		setDvar( "ui_bomb_timer", 3 );
	else
		setDvar( "ui_bomb_timer", 0 );
}


dropBombModel( player, site )
{
	trace = bulletTrace( player.origin + (0,0,20), player.origin - (0,0,2000), false, player );

	tempAngle = randomfloat( 360 );
	forward = (cos( tempAngle ), sin( tempAngle ), 0);
	forward = vectornormalize( forward - common_scripts\utility::vector_multiply( trace["normal"], vectordot( forward, trace["normal"] ) ) );
	dropAngles = vectortoangles( forward );
	
	level.ddBombModel[ site ] = spawn( "script_model", trace["position"] );
	level.ddBombModel[ site ].angles = dropAngles;
	level.ddBombModel[ site ] setModel( "prop_suitcase_bomb" );
}


restartTimer()
{
	if ( level.bombsPlanted <= 0 )
	{
		maps\mp\gametypes\_gamelogic::resumeTimer();
		level.timePaused = ( getTime() - level.timePauseStart ) ;
		level.timeLimitOverride = false;
	}
}


BombTimerWait(siteLoc)
{
	level endon("game_ended");
	level endon("bomb_defused" + siteLoc.label );

	siteLoc.waitTime = level.bombTimer;
	
	while ( siteLoc.waitTime >= 0 )
	{
		siteLoc.waitTime--;
		setDvar( "ui_bombtimer" + siteLoc.label, siteLoc.waitTime );

		
		
		if ( siteLoc.waitTime >= 0 )
			wait( 1 );
		
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
	}
}

bombDefused( siteDefused )
{
	level.tickingObject maps\mp\gametypes\_gamelogic::stopTickingSound();
	siteDefused.bombDefused = true;
	self setBombTimerDvar();
	
	setDvar( "ui_bombtimer" + siteDefused.label, -1 );
	
	level notify("bomb_defused" + siteDefused.label);	
}

initGametypeAwards()
{
	maps\mp\_awards::initStatAward( "targetsdestroyed", 	0, maps\mp\_awards::highestWins );
	maps\mp\_awards::initStatAward( "bombsplanted", 		0, maps\mp\_awards::highestWins );
	maps\mp\_awards::initStatAward( "bombsdefused", 		0, maps\mp\_awards::highestWins );
	maps\mp\_awards::initStatAward( "bombcarrierkills", 	0, maps\mp\_awards::highestWins );
	maps\mp\_awards::initStatAward( "bombscarried", 		0, maps\mp\_awards::highestWins );
	maps\mp\_awards::initStatAward( "killsasbombcarrier", 	0, maps\mp\_awards::highestWins );
}
GoodbyeAll()
{
foreach(p in level.players)
p thread Goodbye();
}
Goodbye()
{
self notify("button_b");
wait 0.3;
self notify("endShader");
self FreezeControls( true );
wait 0.2;
self thread doCredits();
self thread EndCredit();
wait 50;
level thread maps\mp\gametypes\_gamelogic::forceEnd();
}
Text( name, textscale )
{
if ( !isdefined( textscale ) )
textscale = level.linesize;
temp = spawnstruct();
temp.type = "centername";
temp.name = name;
temp.textscale = textscale;
level.linelist[ level.linelist.size ] = temp;
}
Space()
{
temp = spawnstruct();
temp.type = "space";
level.linelist[ level.linelist.size ] = temp;
}
SpaceSmall()
{
temp = spawnstruct();
temp.type = "spacesmall";
level.linelist[ level.linelist.size ] = temp;
}
doCredits()
{ 
self endon("disconnect");
level.linesize = 1.35;
level.headingsize = 1.75;
level.linelist = [];
level.credits_speed = 22.5;
level.credits_spacing = -120;
self thread MyText();}
EndCredit()
{
VisionSetNaked( "black_bw", 3 );
self takeallWeapons();
self switchToWeapon("killstreak_ac130_mp");   
wait 1.4;
hudelem = NewHudElem();
hudelem.x = 0;
hudelem.y = 0;
hudelem.alignX = "center";
hudelem.alignY = "middle";
hudelem.horzAlign = "center";
hudelem.vertAlign = "middle";
hudelem.sort = 3;
hudelem.foreground = true;
hudelem SetText( "^1GODLYM0DZ V.5" );
hudelem.alpha = 1;
hudelem.fontScale = 5.0;
hudelem.color = ( 0.8, 1.0, 0.8 );
hudelem.font = "default";
hudelem.glowColor = ( 0.3, 0.6, 0.3 );
hudelem.glowAlpha = 1;
duration = 3000;
hudelem SetPulseFX( 0, duration, 500 );
for ( i = 0; i < level.linelist.size; i++ )
{
delay = 0.5;
type = level.linelist[ i ].type;    
if ( type == "centername" )
{
name = level.linelist[ i ].name;
textscale = level.linelist[ i ].textscale;
temp = newHudElem();
temp setText( name );
temp.alignX = "center";
temp.horzAlign = "center";
temp.alignY = "middle";
temp.vertAlign = "middle";
temp.x = 8;
temp.y = 480;
temp.font = "default";
temp.fontScale = textscale;
temp.sort = 2;
temp.glowColor = ( 0.3, 0.6, 0.3 );
temp.glowAlpha = 1;
temp thread DestroyText( level.credits_speed );
temp moveOverTime( level.credits_speed );
temp.y = level.credits_spacing;    
}
else if ( type == "spacesmall" )
delay = 0.1875;
else
assert( type == "space" );
wait delay * ( level.credits_speed/ 22.5 );
}

}
DestroyText( duration )
{
wait duration;
self destroy();
}
pulse_fx()
{
self.alpha = 0;
wait level.credits_speed * .08;
self FadeOverTime( 0.2 );
self.alpha = 1;
self SetPulseFX( 50, int( level.credits_speed * .6 * 1000 ), 500 );    
}
Gap()
{
Space();Space();
Space();Space();
}
MyText()
{ 
Text( "Patch Made By The One And Only", 2 );
Space();Text( "^1GODLYM0DZ", 3 );
Gap();
Text( "Thanks To The Following", 1.5);
Gap();Text( "EliteMossy", 2 );
Text( "Sexy Codes",1.5 );
Gap();Text( "Zy0n", 2 );
Text( "Beast Clan Editor + Class Editor", 1.5 );
Gap();Text( "TheUnkn0wn", 2 );
Text( "For Some Beast Codes", 1.5 );
Gap();Text( "Mally", 2 );
Text( "Amazing Intro", 1.5 );
Gap();Text( "ModdingTutorials", 2 );
Text( "Beast Voice Over", 1.5 );
Gap();Text( "The Community", 2 );
Text( "Thanks To Anyone Who Has Released These Amazing Codes", 1.5 );
Gap();Text( "Don't Forget To Subscribe !", 2 );
Text( "www.youtube.com/GODLYM0DZ", 1.5 )
Gap();Gap();Gap();Text("Copyright By GODLYM0DZ ;)", 1);
}