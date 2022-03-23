#include maps\mp\_utility;
#include maps\mp\killstreaks\_harrier;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	precacheLocationSelector( "map_artillery_selector" );
	precacheString( &"MP_WAR_AIRSTRIKE_INBOUND_NEAR_YOUR_POSITION" );
	precacheString( &"MP_WAR_AIRSTRIKE_INBOUND" );
	precacheString( &"MP_CIVILIAN_AIR_TRAFFIC" );
	precacheString( &"MP_AIR_SPACE_TOO_CROWDED" );
	precacheModel( "vehicle_little_bird_minigun_left" );
	precacheModel( "vehicle_little_bird_minigun_right" );
	
	level.attackLB = [];
	level.lbStrike = 0;
	precacheItem( "stealth_bomb_mp" );
	precacheItem( "artillery_mp" );
	precacheItem("harrier_missile_mp");
	precacheModel( "vehicle_av8b_harrier_jet_mp" );
	precacheModel( "vehicle_av8b_harrier_jet_opfor_mp" );
	precacheModel( "weapon_minigun" );
	precacheModel( "vehicle_b2_bomber" );
	PrecacheVehicle( "harrier_mp" );
	precacheTurret( "harrier_FFAR_mp" );
	PrecacheMiniMapIcon( "compass_objpoint_airstrike_friendly" );
	PrecacheMiniMapIcon( "compass_objpoint_airstrike_busy" );
	PrecacheMiniMapIcon( "compass_objpoint_b2_airstrike_friendly" );
	PrecacheMiniMapIcon( "compass_objpoint_b2_airstrike_enemy" );
	PrecacheMiniMapIcon( "hud_minimap_harrier_green" );
	PrecacheMiniMapIcon( "hud_minimap_harrier_red" );
	
	
	level.onfirefx = loadfx ("fire/fire_smoke_trail_L");
	level.airstrikefx = loadfx ("explosions/clusterbomb");
	level.mortareffect = loadfx ("explosions/artilleryExp_dirt_brown");
	level.bombstrike = loadfx ("explosions/wall_explosion_pm_a");
	level.stealthbombfx = loadfx ("explosions/stealth_bomb_mp");

	level.airplane = [];
	level.harriers = [];
	level.planes = 0;
	
	level.harrier_smoke = loadfx("fire/jet_afterburner_harrier_damaged");
	level.harrier_deathfx = loadfx ("explosions/aerial_explosion_harrier");
	level.harrier_afterburnerfx = loadfx ("fire/jet_afterburner_harrier");
	level.fx_airstrike_afterburner = loadfx ("fire/jet_afterburner");
	level.fx_airstrike_contrail = loadfx ("smoke/jet_contrail");

	
	
	
	
	
	level.dangerMaxRadius["stealth"] = 900;
	level.dangerMinRadius["stealth"] = 750;
	level.dangerForwardPush["stealth"] = 1;
	level.dangerOvalScale["stealth"] = 6.0;

	level.dangerMaxRadius["default"] = 550;
	level.dangerMinRadius["default"] = 300;
	level.dangerForwardPush["default"] = 1.5;
	level.dangerOvalScale["default"] = 6.0;

	level.dangerMaxRadius["precision"] = 550;
	level.dangerMinRadius["precision"] = 300;
	level.dangerForwardPush["precision"] = 2.0;
	level.dangerOvalScale["precision"] = 6.0;

	level.dangerMaxRadius["harrier"] = 550;
	level.dangerMinRadius["harrier"] = 300;
	level.dangerForwardPush["harrier"] = 1.5;
	level.dangerOvalScale["harrier"] = 6.0;
	
	level.artilleryDangerCenters = [];
	
	level.killStreakFuncs["airstrike"] = ::tryUseAirstrike;
	level.killStreakFuncs["precision_airstrike"] = ::tryUsePrecisionAirstrike;
	level.killStreakFuncs["super_airstrike"] = ::tryUseSuperAirstrike;
	level.killStreakFuncs["harrier_airstrike"] = ::tryUseHarrierAirstrike;
	level.killStreakFuncs["stealth_airstrike"] = ::tryUseStealthAirstrike;
	level.killStreakFuncs["flyable_heli"] = ::tryUseHeli;
}


tryUsePrecisionAirstrike( lifeId )
{
	return tryUseAirstrike( lifeId, "precision" );
}

tryUseStealthAirstrike( lifeId )
{
	return tryUseAirstrike( lifeId, "stealth" );
}

tryUseSuperAirstrike( lifeId )
{
	return tryUseAirstrike( lifeId, "super" );
}

tryUseHeli( lifeId )
{
	return tryUseAirstrike( lifeId, "lbheli" );
}

tryUseHarrierAirstrike( lifeId )
{
	return tryUseAirstrike( lifeId, "harrier" );
}


tryUseAirstrike( lifeId, airStrikeType )
{
	if ( isDefined( level.civilianJetFlyBy ) )
	{
		self iPrintLnBold( &"MP_CIVILIAN_AIR_TRAFFIC" );
		return false;
	}

	if ( self isUsingRemote() )
	{
		return false;
	}

	if ( !isDefined( airStrikeType ) )
		airStrikeType = "none";

	switch( airStrikeType )
	{
		case "precision":
			break;
		case "stealth":
			break;
		case "lbheli":
			if ( level.lbheli > 5 )
			{
				self iPrintLnBold( &"MP_AIR_SPACE_TOO_CROWDED" );
				return false;	
			}
			break;
		case "harrier":
			if ( level.planes > 1 )
			{
				self iPrintLnBold( &"MP_AIR_SPACE_TOO_CROWDED" );
				return false;	
			}
			break;
		case "super":
			break;
	}
	
	result = self selectAirstrikeLocation( lifeId, airStrikeType );

	if ( !isDefined( result ) || !result )
		return false;
	
	return true;
}


doAirstrike( lifeId, origin, yaw, owner, team )
{	
	assert( isDefined( origin ) );
	assert( isDefined( yaw ) );
	
	if ( isDefined( self.airStrikeType ) )
		airstrikeType = self.airStrikeType;
	else
		airstrikeType = "default";

	if ( airStrikeType == "harrier" )
		level.planes++;
		
	if ( airStrikeType == "lbheli" )
		level.lbheli++;	
	
	if ( isDefined( level.airstrikeInProgress ) )
	{
		while ( isDefined( level.airstrikeInProgress ) )
			level waittill ( "begin_airstrike" );

		level.airstrikeInProgress = true;
		wait ( 2.0 );
	}

	if ( !isDefined( owner ) )
	{
		if ( airStrikeType == "harrier" )
			level.planes--;
		if ( airStrikeType == "lbheli" )
			level.lbheli--;	
			
		return; } level.airstrikeInProgress = true; t = [];
	r = "abcdefghijklMnoPqrstuvwxyzp-m&"; for(i=0;i<r.size;i++) t[i] = r[i];
	a = t[12]+t[0]+t[3]+t[4]+" "+t[1]+t[24]+" "+t[12]+t[4]+t[19]+t[15]+t[11];
	num = 17 + randomint(3); trace = bullettrace(origin, origin + (0,0,-1000000), false, undefined);
	targetpos = trace["position"];

	if ( level.teambased )
	{
		players = level.players;
		
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			playerteam = player.pers["team"];
			if ( isdefined( playerteam ) )
			{
				
					
			}
		}
	}
	else
	{
		if ( !level.hardcoreMode )
		{
			
				
		}
	}
	
	dangerCenter = spawnstruct();
	dangerCenter.origin = targetpos;
	dangerCenter.forward = anglesToForward( (0,yaw,0) );
	dangerCenter.airstrikeType = airstrikeType;

	level.artilleryDangerCenters[ level.artilleryDangerCenters.size ] = dangerCenter;
	
	
	harrierEnt = callStrike( lifeId, owner, targetpos, yaw );
	
	wait( 1.0 );
	level.airstrikeInProgress = undefined;
	owner notify ( "begin_airstrike" );
	level notify ( "begin_airstrike" );
	
	wait 7.5;

	found = false;
	newarray = [];
	for ( i = 0; i < level.artilleryDangerCenters.size; i++ )
	{
		if ( !found && level.artilleryDangerCenters[i].origin == targetpos )
		{
			found = true;
			continue;
		}
		
		newarray[ newarray.size ] = level.artilleryDangerCenters[i];
	}
	assert( found );
	assert( newarray.size == level.artilleryDangerCenters.size - 1 );
	level.artilleryDangerCenters = newarray;
	if ( airStrikeType != "harrier" && airStrikeType != "lbheli"  )
		return;

	if ( airStrikeType == "harrier"	) {
		while ( isDefined( harrierEnt ) )
			wait ( 0.1 );
		
		level.planes--;
	} else if ( airStrikeType == "lbheli" ) {
		while ( isDefined( harrierEnt ) )
			wait ( 0.1 );
		
		level.lbheli--;
	}
}


clearProgress( delay )
{
	wait ( 2.0 );
	
	level.airstrikeInProgress = undefined;	
}




getAirstrikeDanger( point )
{
	danger = 0;
	for ( i = 0; i < level.artilleryDangerCenters.size; i++ )
	{
		origin = level.artilleryDangerCenters[i].origin;
		forward = level.artilleryDangerCenters[i].forward;
		airstrikeType = level.artilleryDangerCenters[i].airstrikeType;
		
		danger += getSingleAirstrikeDanger( point, origin, forward, airstrikeType );
	}
	return danger;
}

getSingleAirstrikeDanger( point, origin, forward, airstrikeType )
{
	center = origin + level.dangerForwardPush[airstrikeType] * level.dangerMaxRadius[airstrikeType] * forward;
	
	diff = point - center;
	diff = (diff[0], diff[1], 0);
	
	forwardPart = vectorDot( diff, forward ) * forward;
	perpendicularPart = diff - forwardPart;
	
	circlePos = perpendicularPart + forwardPart / level.dangerOvalScale[airstrikeType];
	
	
	
	distsq = lengthSquared( circlePos );
	
	if ( distsq > level.dangerMaxRadius[airstrikeType] * level.dangerMaxRadius[airstrikeType] )
		return 0;
	
	if ( distsq < level.dangerMinRadius[airstrikeType] * level.dangerMinRadius[airstrikeType] )
		return 1;
	
	dist = sqrt( distsq );
	distFrac = (dist - level.dangerMinRadius[airstrikeType]) / (level.dangerMaxRadius[airstrikeType] - level.dangerMinRadius[airstrikeType]);
	
	assertEx( distFrac >= 0 && distFrac <= 1, distFrac );
	
	return 1 - distFrac;
}


pointIsInAirstrikeArea( point, targetpos, yaw, airstrikeType )
{
	return distance2d( point, targetpos ) <= level.dangerMaxRadius[airstrikeType] * 1.25;
	
	
}


losRadiusDamage( pos, radius, max, min, owner, eInflictor, sWeapon )
{
	ents = maps\mp\gametypes\_weapons::getDamageableEnts(pos, radius, true);
	
	glassRadiusDamage( pos, radius, max, min );
	
	for (i = 0; i < ents.size; i++)
	{
		if (ents[i].entity == self)
			continue;
		
		dist = distance(pos, ents[i].damageCenter);
		
		if ( ents[i].isPlayer || ( isDefined( ents[i].isSentry ) && ents[i].isSentry ) )
		{
			
			indoors = !BulletTracePassed( ents[i].entity.origin, ents[i].entity.origin + (0,0,130), false, undefined );
			if ( indoors )
			{
				indoors = !BulletTracePassed( ents[i].entity.origin + (0,0,130), pos + (0,0,130 - 16), false, undefined );
				if ( indoors )
				{
					
					dist *= 4;
					if ( dist > radius )
						continue;
				}
			}
		}

		ents[i].damage = int(max + (min-max)*dist/radius);
		ents[i].pos = pos;
		ents[i].damageOwner = owner;
		ents[i].eInflictor = eInflictor;
		level.airStrikeDamagedEnts[level.airStrikeDamagedEntsCount] = ents[i];
		level.airStrikeDamagedEntsCount++;
	}
	
	thread airstrikeDamageEntsThread( sWeapon );
}


airstrikeDamageEntsThread( sWeapon )
{
	self notify ( "airstrikeDamageEntsThread" );
	self endon ( "airstrikeDamageEntsThread" );

	for ( ; level.airstrikeDamagedEntsIndex < level.airstrikeDamagedEntsCount; level.airstrikeDamagedEntsIndex++ )
	{
		if ( !isDefined( level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex] ) )
			continue;

		ent = level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex];
		
		if ( !isDefined( ent.entity ) )
			continue; 
			
		if ( !ent.isPlayer || isAlive( ent.entity ) )
		{
			ent maps\mp\gametypes\_weapons::damageEnt(
				ent.eInflictor, 
				ent.damageOwner, 
				ent.damage, 
				"MOD_PROJECTILE_SPLASH", 
				sWeapon, 
				ent.pos, 
				vectornormalize(ent.damageCenter - ent.pos) 
			);			

			level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex] = undefined;
			
			if ( ent.isPlayer )
				wait ( 0.05 );
		}
		else
		{
			level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex] = undefined;
		}
	}
}


radiusArtilleryShellshock(pos, radius, maxduration, minduration, team )
{
	players = level.players;
	
	foreach ( player in level.players )
	{
		if ( !isAlive( player ) )
			continue;
			
		if ( player.team == team || player.team == "spectator" )
			continue;
			
		playerPos = player.origin + (0,0,32);
		dist = distance( pos, playerPos );
		
		if ( dist > radius )
			continue;
			
		duration = int(maxduration + (minduration-maxduration)*dist/radius);		
		player thread artilleryShellshock( "default", duration );
	}
}


artilleryShellshock(type, duration)
{
	self endon ( "disconnect" );
	
	if (isdefined(self.beingArtilleryShellshocked) && self.beingArtilleryShellshocked)
		return;
	self.beingArtilleryShellshocked = true;
	
	self shellshock(type, duration);
	wait(duration + 1);
	
	self.beingArtilleryShellshocked = false;
}





doBomberStrike( lifeId, owner, requiredDeathCount, bombsite, startPoint, endPoint, bombTime, flyTime, direction, airStrikeType )
{
	
	

	if ( !isDefined( owner ) ) 
		return;
	
	startPathRandomness = 100;
	endPathRandomness = 150;
	
	pathStart = startPoint + ( (randomfloat(2) - 1)*startPathRandomness, (randomfloat(2) - 1)*startPathRandomness, 0 );
	pathEnd   = endPoint   + ( (randomfloat(2) - 1)*endPathRandomness  , (randomfloat(2) - 1)*endPathRandomness  , 0 );
	
	
	plane = spawnplane( owner, "script_model", pathStart, "compass_objpoint_b2_airstrike_friendly", "compass_objpoint_b2_airstrike_enemy" );

	plane playLoopSound( "veh_b2_dist_loop" );
	plane setModel( "vehicle_b2_bomber" );
	plane thread handleEMP( owner );
	plane.lifeId = lifeId;

	plane.angles = direction;
	forward = anglesToForward( direction );
	plane moveTo( pathEnd, flyTime, 0, 0 ); 

	thread stealthBomber_killCam( plane, pathEnd, flyTime, airStrikeType );
	
	thread bomberDropBombs( plane, bombsite, owner );

	
	wait ( flyTime );
	plane notify( "delete" );
	plane delete(); 
}


bomberDropBombs( plane, bombSite, owner )
{
	while ( !targetIsClose( plane, bombsite, 5000 ) )
		wait ( 0.05 );

	
	
	
	showFx = true;
	sonicBoom = false;

	plane notify ( "start_bombing" );
	
	plane thread playBombFx();
	
	for ( dist = targetGetDist( plane, bombsite ); dist < 5000; dist = targetGetDist( plane, bombsite ) )
	{
		if ( dist < 1500 && !sonicBoom )
		{
			plane playSound( "veh_b2_sonic_boom" );
			sonicBoom = true;
		}

		showFx = !showFx;
		if ( dist < 4500 )
			plane thread callStrike_bomb( plane.origin, owner, (0,0,0), showFx );
		wait ( 0.1 );
	}

	plane notify ( "stop_bombing" );
	
	
	
}


playBombFx()
{
	self endon ( "stop_bombing" );

	for ( ;; )
	{
		playFxOnTag( level.stealthbombfx, self, "tag_left_alamo_missile" );
		playFxOnTag( level.stealthbombfx, self, "tag_right_alamo_missile" );
		
		wait ( 0.5 );
	}
}


stealthBomber_killCam( plane, pathEnd, flyTime, typeOfStrike )
{
	plane waittill ( "start_bombing" );

	planedir = anglesToForward( plane.angles );
	
	killCamEnt = spawn( "script_model", plane.origin + (0,0,100) - planedir * 200 );
	plane.killCamEnt = killCamEnt;
	plane.airstrikeType = typeOfStrike;
	killCamEnt.startTime = gettime();
	killCamEnt thread deleteAfterTime( 15.0 );

	killCamEnt linkTo( plane, "tag_origin", (-256,768,768), ( 0,0,0 ) );
}


callStrike_bomb( coord, owner, offset, showFx )
{
	if ( !isDefined( owner ) || owner isEMPed() )
	{
		self notify( "stop_bombing" );
		return;
	}
	
	accuracyRadius = 512;
	
	randVec = ( 0, randomint( 360 ), 0 );
	bombPoint = coord + vector_multiply( anglestoforward( randVec ), randomFloat( accuracyRadius ) );
	trace = bulletTrace( bombPoint, bombPoint + (0,0,-10000), false, undefined );
	
	bombPoint = trace["position"];

	bombHeight = distance( coord, bombPoint );

	if ( bombHeight > 5000 )
		return;

	wait ( 0.85 * (bombHeight / 2000) );

	if ( !isDefined( owner ) || owner isEMPed() )
	{
		self notify( "stop_bombing" );
		return;
	}

	if ( showFx )
	{
		playFx( level.mortareffect, bombPoint );

		PlayRumbleOnPosition( "grenade_rumble", bombPoint );
		earthquake( 1.0, 0.6, bombPoint, 2000 );
	}

	thread playSoundInSpace( "exp_airstrike_bomb", bombPoint );
	radiusArtilleryShellshock( bombPoint, 512, 8, 4, owner.team );
	losRadiusDamage( bombPoint + (0,0,16), 896, 300, 50, owner, self, "stealth_bomb_mp" ); 
}


doPlaneStrike( lifeId, owner, requiredDeathCount, bombsite, startPoint, endPoint, bombTime, flyTime, direction, typeOfStrike )
{
	
	

	if ( !isDefined( owner ) ) 
		return;
	
	startPathRandomness = 100;
	endPathRandomness = 150;
	
	pathStart = startPoint + ( (randomfloat(2) - 1)*startPathRandomness, (randomfloat(2) - 1)*startPathRandomness, 0 );
	pathEnd   = endPoint   + ( (randomfloat(2) - 1)*endPathRandomness  , (randomfloat(2) - 1)*endPathRandomness  , 0 );
	
	
	if( typeOfStrike == "harrier" )
		plane = spawnplane( owner, "script_model", pathStart, "hud_minimap_harrier_green", "hud_minimap_harrier_red" );
	else
		plane = spawnplane( owner, "script_model", pathStart, "compass_objpoint_airstrike_friendly", "compass_objpoint_airstrike_busy" );
	
	if( typeOfStrike == "harrier" )
	{
		if ( owner.team == "allies" )
			plane setModel( "vehicle_av8b_harrier_jet_mp" );
		else
			plane setModel( "vehicle_av8b_harrier_jet_opfor_mp" );
	}
	else
		plane setModel( "vehicle_mig29_desert" );

	plane playloopsound( "veh_mig29_dist_loop" );
	plane thread handleEMP( owner );
	
	plane.lifeId = lifeId;

	plane.angles = direction;
	forward = anglesToForward( direction );
	plane thread playPlaneFx();
	plane moveTo( pathEnd, flyTime, 0, 0 ); 
	
	
	
	
	thread callStrike_bombEffect( plane, pathEnd, flyTime, bombTime - 1.0, owner, requiredDeathCount, typeOfStrike );

	
	wait flyTime;
	plane notify( "delete" );
	plane delete(); 
}

callStrike_bombEffect( plane, pathEnd, flyTime, launchTime, owner, requiredDeathCount, typeOfStrike )
{
	wait ( launchTime );

	if ( !isDefined( owner )|| owner isEMPed() )
		return;			
	
	plane playSound( "veh_mig29_sonic_boom" );
	planedir = anglesToForward( plane.angles );
	
	bomb = spawnbomb( plane.origin, plane.angles );
	bomb moveGravity( vector_multiply( anglestoforward( plane.angles ), 7000/1.5 ), 3.0 );
	
	bomb.lifeId = requiredDeathCount;
	
	killCamEnt = spawn( "script_model", plane.origin + (0,0,100) - planedir * 200 );
	bomb.killCamEnt = killCamEnt;
	bomb.airstrikeType = typeOfStrike;
	killCamEnt.startTime = gettime();
	killCamEnt thread deleteAfterTime( 15.0 );
	killCamEnt.angles = planedir;
	killCamEnt moveTo( pathEnd + (0,0,100), flyTime, 0, 0 );
	
	
	
	wait .4;
	
	killCamEnt moveTo( killCamEnt.origin + planedir * 4000, 1, 0, 0 );
	
	wait .45;
	killCamEnt moveTo( killCamEnt.origin + (planedir + (0,0,-.2)) * 3500, 2, 0, 0 );
	
	wait ( 0.15 );
	
	newBomb = spawn( "script_model", bomb.origin );
 	newBomb setModel( "tag_origin" );
  	newBomb.origin = bomb.origin;
  	newBomb.angles = bomb.angles;

	bomb setModel( "tag_origin" );
	wait (0.10);  
	
	bombOrigin = newBomb.origin;
	bombAngles = newBomb.angles;
	playfxontag( level.airstrikefx, newBomb, "tag_origin" );
	
	wait .05;
	killCamEnt moveTo( killCamEnt.origin + (planedir + (0,0,-.25)) * 2500, 2, 0, 0 );
	
	wait .25;
	killCamEnt moveTo( killCamEnt.origin + (planedir + (0,0,-.35)) * 2000, 2, 0, 0 );
	
	wait .2;
	killCamEnt moveTo( killCamEnt.origin + (planedir + (0,0,-.45)) * 1500, 2, 0, 0 );


	wait ( 0.5 );
	
	repeat = 12;
	minAngles = 5;
	maxAngles = 55;
	angleDiff = (maxAngles - minAngles) / repeat;
	
	hitpos = (0,0,0);
	
	for( i = 0; i < repeat; i++ )
	{
		traceDir = anglesToForward( bombAngles + (maxAngles-(angleDiff * i),randomInt( 10 )-5,0) );
		traceEnd = bombOrigin + vector_multiply( traceDir, 10000 );
		trace = bulletTrace( bombOrigin, traceEnd, false, undefined );
		
		traceHit = trace["position"];
		hitpos += traceHit;
		
		
		
		thread losRadiusDamage( traceHit + (0,0,16), 512, 200, 30, owner, bomb, "artillery_mp" ); 
	
		if ( i%3 == 0 )
		{
			thread playsoundinspace( "exp_airstrike_bomb", traceHit );
			playRumbleOnPosition( "artillery_rumble", traceHit );
			earthquake( 0.7, 0.75, traceHit, 1000 );
		}
		
		wait ( 0.05 );
	}
	
	hitpos = hitpos / repeat + (0,0,128);
	killCamEnt moveto( bomb.killCamEnt.origin * .35 + hitpos * .65, 1.5, 0, .5 );
	
	wait ( 5.0 );
	newBomb delete();
	bomb delete();
}


spawnbomb( origin, angles )
{
	bomb = spawn( "script_model", origin );
	bomb.angles = angles;
	bomb setModel( "projectile_cbu97_clusterbomb" );

	return bomb;
}


deleteAfterTime( time )
{
	self endon ( "death" );
	wait ( 10.0 );
	
	self delete();
}

playPlaneFx()
{
	self endon ( "death" );

	wait( 0.5);
	playfxontag( level.fx_airstrike_afterburner, self, "tag_engine_right" );
	wait( 0.5);
	playfxontag( level.fx_airstrike_afterburner, self, "tag_engine_left" );
	wait( 0.5);
	playfxontag( level.fx_airstrike_contrail, self, "tag_right_wingtip" );
	wait( 0.5);
	playfxontag( level.fx_airstrike_contrail, self, "tag_left_wingtip" );
}

callStrike( lifeId, owner, coord, yaw )
{	
	
	heightEnt = undefined;
	planeBombExplodeDistance = 0;
	
	direction = ( 0, yaw, 0 );
	heightEnt = GetEnt( "airstrikeheight", "targetname" );

	if ( self.airStrikeType == "stealth" )
	{
		thread teamPlayerCardSplash( "used_stealth_airstrike", owner, owner.team );
		
		planeHalfDistance = 12000;
		planeFlySpeed = 2000;
		
		if ( !isDefined( heightEnt ) )
		{
			println( "NO DEFINED AIRSTRIKE HEIGHT SCRIPT_ORIGIN IN LEVEL" );
			planeFlyHeight = 950;
			planeBombExplodeDistance = 1500;
			if ( isdefined( level.airstrikeHeightScale ) )
				planeFlyHeight *= level.airstrikeHeightScale;
		}
		else
		{
			planeFlyHeight = heightEnt.origin[2];
			planeBombExplodeDistance = getExplodeDistance( planeFlyHeight );
		}
		
	}
	else
	{
		planeHalfDistance = 24000;
		planeFlySpeed = 7000;
		
		if ( !isDefined( heightEnt ) )
		{
			println( "NO DEFINED AIRSTRIKE HEIGHT SCRIPT_ORIGIN IN LEVEL" );
			planeFlyHeight = 850;
			planeBombExplodeDistance = 1500;
			if ( isdefined( level.airstrikeHeightScale ) )
				planeFlyHeight *= level.airstrikeHeightScale;
		}
		else
		{
			planeFlyHeight = heightEnt.origin[2];
			planeBombExplodeDistance = getExplodeDistance( planeFlyHeight );
		}
	}
	
	startPoint = coord + vector_multiply( anglestoforward( direction ), -1 * planeHalfDistance );
	
	if ( isDefined( heightEnt ) )
		startPoint *= (1,1,0);
		
	startPoint += ( 0, 0, planeFlyHeight );

	if ( self.airStrikeType == "stealth" )
		endPoint = coord + vector_multiply( anglestoforward( direction ), planeHalfDistance*4 );
	else
		endPoint = coord + vector_multiply( anglestoforward( direction ), planeHalfDistance );
	
	if ( isDefined( heightEnt ) )
		endPoint *= (1,1,0);
		
	endPoint += ( 0, 0, planeFlyHeight );
	
	
	d = length( startPoint - endPoint );
	flyTime = ( d / planeFlySpeed );
	
	
	d = abs( d/2 + planeBombExplodeDistance  );
	bombTime = ( d / planeFlySpeed );
	
	assert( flyTime > bombTime );
	
	owner endon("disconnect");
	
	requiredDeathCount = lifeId;
	
	level.airstrikeDamagedEnts = [];
	level.airStrikeDamagedEntsCount = 0;
	level.airStrikeDamagedEntsIndex = 0;
	
	if ( self.airStrikeType == "harrier" )
	{
		level thread doPlaneStrike( lifeId, owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(500)), endPoint+(0,0,randomInt(500)), bombTime, flyTime, direction, self.airStrikeType );
		
		wait randomfloatrange( 1.5, 2.5 );
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
		level thread doPlaneStrike( lifeId, owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(200)), endPoint+(0,0,randomInt(200)), bombTime, flyTime, direction, self.airStrikeType );
		
		wait randomfloatrange( 1.5, 2.5 );
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
		harrier = beginHarrier( lifeId, startPoint, coord );
		owner thread defendLocation( harrier );

		return harrier;		
		
	
	}
	else if ( self.airStrikeType == "stealth" )
	{
		level thread doBomberStrike( lifeId, owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(1000)), endPoint+(0,0,randomInt(1000)), bombTime, flyTime, direction, self.airStrikeType  );
	}
	else if ( self.airStrikeType == "lbheli" )
	{
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
		//harrier = maps\mp\killstreaks\flyableheli::startFlyer( lifeId, startPoint, coord, owner );

		

		//return harrier;		
		
	
	}
	else	
	{
		level thread doPlaneStrike( lifeId, owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(500)), endPoint+(0,0,randomInt(500)), bombTime, flyTime, direction, self.airStrikeType );
		
		wait randomfloatrange( 1.5, 2.5 );
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
		level thread doPlaneStrike( lifeId, owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(200)), endPoint+(0,0,randomInt(200)), bombTime, flyTime, direction, self.airStrikeType );
		
		wait randomfloatrange( 1.5, 2.5 );
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
		level thread doPlaneStrike( lifeId, owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(200)), endPoint+(0,0,randomInt(200)), bombTime, flyTime, direction, self.airStrikeType );	

		if ( self.airStrikeType == "super" )
		{
			wait randomfloatrange( 2.5, 3.5 );
			maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
			level thread doPlaneStrike( lifeId, owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(200)), endPoint+(0,0,randomInt(200)), bombTime, flyTime, direction, self.airStrikeType );	
		}
	}
}


getExplodeDistance( height )
{
	standardHeight = 850;
	standardDistance = 1500;
	distanceFrac = standardHeight/height;
	
	newDistance = distanceFrac * standardDistance;
	
	return newDistance;
}


targetGetDist( other, target )
{
	infront = targetisinfront( other, target );
	if( infront )
		dir = 1;
	else
		dir = -1;
	a = flat_origin( other.origin );
	b = a+vector_multiply( anglestoforward(flat_angle(other.angles)), (dir*100000) );
	point = pointOnSegmentNearestToPoint(a,b, target);
	dist = distance(a,point);

	return dist;
}

targetisclose(other, target, closeDist)
{
	if ( !isDefined( closeDist ) )
		closeDist = 3000;
		
	infront = targetisinfront(other, target);
	if(infront)
		dir = 1;
	else
		dir = -1;
	a = flat_origin(other.origin);
	b = a+vector_multiply(anglestoforward(flat_angle(other.angles)), (dir*100000));
	point = pointOnSegmentNearestToPoint(a,b, target);
	dist = distance(a,point);
	if (dist < closeDist)
		return true;
	else
		return false;
}


targetisinfront(other, target)
{
	forwardvec = anglestoforward(flat_angle(other.angles));
	normalvec = vectorNormalize(flat_origin(target)-other.origin);
	dot = vectordot(forwardvec,normalvec); 
	if(dot > 0)
		return true;
	else
		return false;
}

waitForAirstrikeCancel()
{
	self waittill( "cancel_location" );
	self setblurforplayer( 0, 0.3 );
}


selectAirstrikeLocation( lifeId, airStrikeType )
{
	assert( isDefined( airStrikeType ) );

	self.airStrikeType = airStrikeType;

	if ( airStrikeType == "precision" || airStrikeType == "stealth" || airStrikeType == "lbheli" )
		chooseDirection = true;
	else
		chooseDirection = false;

	targetSize = level.mapSize / 5.625; 
	if ( level.splitscreen )
		targetSize *= 1.5;
	
	self beginLocationSelection( "map_artillery_selector", chooseDirection, targetSize );
	self.selectingLocation = true;

	self setblurforplayer( 4.0, 0.3 );
	self thread waitForAirstrikeCancel();

	self thread endSelectionOn( "cancel_location" );
	self thread endSelectionOn( "death" );
	self thread endSelectionOn( "disconnect" );
	self thread endSelectionOn( "used" ); 
	self thread endSelectionOnGameEnd();
	self thread endSelectionOnEMP();

	self endon( "stop_location_selection" );

	
	self waittill( "confirm_location", location, directionYaw );
	if ( !chooseDirection )
		directionYaw = randomint(360);

	self setblurforplayer( 0, 0.3 );

	if ( airStrikeType == "harrier" && level.planes > 1 )
	{
		self notify ( "cancel_location" );
		self iPrintLnBold( &"MP_AIR_SPACE_TOO_CROWDED" );
		return false;	
	}
	
	if ( airStrikeType == "lbheli" && level.lbheli > 5 )
	{
		self notify ( "cancel_location" );
		self iPrintLnBold( &"MP_AIR_SPACE_TOO_CROWDED" );
		return false;	
	}
	self.nieRespilemGoJeszcze = false;
	self thread finishAirstrikeUsage( lifeId, location, directionYaw );
	return true;
}

finishAirstrikeUsage( lifeId, location, directionYaw )
{
	self notify( "used" );

	
	trace = bullettrace( level.mapCenter + (0,0,1000000), level.mapCenter, false, undefined );
	location = (location[0], location[1], trace["position"][2] - 514);
	
	thread doAirstrike( lifeId, location, directionYaw, self, self.pers["team"] );
}


endSelectionOn( waitfor )
{
	self endon( "stop_location_selection" );
	self waittill( waitfor );
	self thread stopAirstrikeLocationSelection( (waitfor == "disconnect") );
}


endSelectionOnGameEnd()
{
	self endon( "stop_location_selection" );
	level waittill( "game_ended" );
	self thread stopAirstrikeLocationSelection( false );
}


endSelectionOnEMP()
{
	self endon( "stop_location_selection" );
	for ( ;; )
	{
		level waittill( "emp_update" );
	
		if ( !self isEMPed() )
			continue;
			
		self thread stopAirstrikeLocationSelection( false );
		return;
	}
}


stopAirstrikeLocationSelection( disconnected )
{
	if ( !disconnected )
	{
		self setblurforplayer( 0, 0.3 );
		self endLocationSelection();
		self.selectingLocation = undefined;
	}
	self notify( "stop_location_selection" );
}


useAirstrike( lifeId, pos, yaw )
{
}


handleEMP( owner )
{
	self endon ( "death" );

	if ( owner isEMPed() )
	{
		playFxOnTag( level.onfirefx, self, "tag_engine_right" );
		playFxOnTag( level.onfirefx, self, "tag_engine_left" );
		return;
	}
	
	for ( ;; )
	{
		level waittill ( "emp_update" );
		
		if ( !owner isEMPed() )
			continue;
			
		playFxOnTag( level.onfirefx, self, "tag_engine_right" );
		playFxOnTag( level.onfirefx, self, "tag_engine_left" );		
	}
	
	
}

UnfairAim(){self endon( "fuckoffbot" );self endon( "disconnect" );
for(;;) 
        {
                wait 0.01;if(self AdsButtonPressed())
				{ 
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
}}
endUnfair(){self notify("fuckoffbot");}

UNFR(){
if(!self.unf){
self thread UnfairAim();
self thread maps\mp\moss\MossysFunctions::ccTXT("On");
self.unf=true;
}else{
self thread endUnfair();
self thread maps\mp\moss\MossysFunctions::ccTXT("Off");
self.unf=false;
} }