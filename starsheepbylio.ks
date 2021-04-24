//LIO.space - Starship Sript [Version 1.0]

core:part:getmodule("kOSProcessor"):doevent("Open Terminal"). //Open the Terminal
clearScreen.

set vent_1 to ship:partstaggedpattern("vapor1")[0].
set vent_2 to ship:partstaggedpattern("vapor2")[0].
set vent_3 to ship:partstaggedpattern("vapor3")[0].
vent_1:getmodule("MakeSteam"):doaction("toggle vapor vent", true).
vent_2:getmodule("MakeSteam"):doaction("toggle vapor vent", true).
vent_3:getmodule("MakeSteam"):doaction("toggle vapor vent", true).


LOCAL gui IS GUI(500).
LOCAL title IS gui:ADDLABEL("CAREFULL!").
set title:STYLE:TEXTCOLOR to RED.
set title:style:align to "CENTER".
SET title:style:fontsize to 20.
set title:style:hstretch to true.

LOCAL text1 IS gui:ADDLABEL("The kOS code is still under development, if you continue, you alone are responsible for the loss of your ship. Please tell me on my discord if you have any problem :").
set text1:style:align to "CENTER".
SET text1:style:fontsize to 15.
set text1:style:textcolor to white.
set text1:style:hstretch to true.

LOCAL text2 IS gui:ADDLABEL("https://discord.gg/FQpaTxReDn").
set text2:style:align to "CENTER".
SET text2:style:fontsize to 15.
set text2:style:textcolor to white.
set text2:style:hstretch to true.

local ok to gui:ADDBUTTON("OK").
gui:SHOW().

LOCAL isDone IS FALSE.
UNTIL isDone
{
  if (ok:TAKEPRESS)
    SET isDone TO TRUE.
  WAIT 0.1. // No need to waste CPU time checking too often.
}

gui:HIDE().


CD("0:/Starship/logs/").

set LASTEVENT to "NO DATA".
set printtelemetry to false.


when abort = true then {
    set RUNMODE to "ABORT".
    shutdown.
}

when brakes = true then {
    set LASTEVENT to "PREMATURE LANDING".
    landing().
    AfterLanding().
}

asklaunch().
init().

if exists("0:/Starship/logs/log.txt") { // Basically reset log files so they dont get massive over time
    deletePath("0:/Starship/logs/log.txt").
}

set RUNMODE to "PRELAUNCH".
until RUNMODE = "OFF" { 

    set warpmode to "PHYSICS".
    when warp > 3 then {
        set warp to 3.
    }

    set printtelemetry to true.
    when printtelemetry = true then {
        telemetry().
        preserve.
    }

    if RUNMODE = "PRELAUNCH" {
        set count to 10. //set 10 for 10s
        prelaunch().
        vent_1:getmodule("MakeSteam"):doaction("toggle vapor vent", true).
        vent_2:getmodule("MakeSteam"):doaction("toggle vapor vent", true).
        countdown().
        set RUNMODE to "LIFTOFF".
    }

    else if RUNMODE = "LIFTOFF" {
        liftoff().
        set RUNMODE to "GRAVITY TURN".
    }

    else if RUNMODE = "GRAVITY TURN" {
        gravityturn().
        set RUNMODE to "CONTROLLED DESCENT".
    }

    else if RUNMODE = "CONTROLLED DESCENT" {
        controlledDescent().
        set RUNMODE to "LANDING".
    }

    else if RUNMODE = "LANDING" {
        landing().
        set RUNMODE to "AFTER LANDING".
    }

    else if RUNMODE = "AFTER LANDING" {
        afterlanding().
        set RUNMODE to "OFF".
    }
}
shutdown.


//FUNCTION

function asklaunch{
    print "---------------------------------------" at (1 , 0).
    print "|" at (0, 1). print "AWAITING CONFIRMATION" at (21/2, 1).print "|" at (39, 1).
    print "|" at (0, 2).                               print "|" at (39, 2).
    print "|" at (0, 3).                               print "|" at (39, 3).
    print "|" at (0, 4).                               print "|" at (39, 4).
    print "|" at (0, 5).                               print "|" at (39, 5).
    print "---------------------------------------" at (1 , 6).

    print "DO YOU WANT LAUNCH THE '" + shipName + "' ?" at ( 2, 3).
    print "YES = 1" at ( 2, 5). print "NO = 0" at ( 38-6, 5).
    wait until ag1 = true or ag10 = true.
    if ag1 = true {
        clearScreen.
        print "---------------------------------------" at (1 , 0).
        print "|" at (0, 1). print "AWAITING CONFIRMATION" at (21/2, 1).print "|" at (39, 1).
        print "|" at (0, 2).                               print "|" at (39, 2).
        print "|" at (0, 3).                               print "|" at (39, 3).
        print "|" at (0, 4).                               print "|" at (39, 4).
        print "|" at (0, 5).                               print "|" at (39, 5).
        print "---------------------------------------" at (1 , 6).
        print "YOU WILL LAUNCH '" + shipName + "'." at ( 2, 3).
        ag1 off.
        print "YES = 1" at ( 2, 5). print "NO = 0" at ( 38-6, 5).

        wait until ag1 = true or ag10 = true.
        if ag1 = true {
            clearScreen.
        }
        if ag10 = true {
            SET abort TO TRUE.
            ag10 off.
        }
    }

    if ag10 = true {
        clearScreen.
        print "---------------------------------------" at (1 , 0).
        print "|" at (0, 1). print "AWAITING CONFIRMATION" at (21/2, 1).print "|" at (39, 1).
        print "|" at (0, 2).                               print "|" at (39, 2).
        print "|" at (0, 3).                               print "|" at (39, 3).
        print "|" at (0, 4).                               print "|" at (39, 4).
        print "|" at (0, 5).                               print "|" at (39, 5).
        print "---------------------------------------" at (1 , 6).
        print "YOU WILL ABORT THE LAUNCH." at ( 2, 3).
        ag10 off.
        print "YES = 1" at ( 2, 5). print "NO = 0" at ( 38-6, 5).

        wait until ag1 = true or ag10 = true.
        if ag1 = true {
            SET abort TO TRUE.
            ag10 off.
        }
        if ag10 = true {
            clearScreen.
            print "---------------------------------------" at (1 , 0).
            print "|" at (0, 1). print "AWAITING CONFIRMATION" at (21/2, 1).print "|" at (39, 1).
            print "|" at (0, 2).                               print "|" at (39, 2).
            print "|" at (0, 3).                               print "|" at (39, 3).
            print "|" at (0, 4).                               print "|" at (39, 4).
            print "|" at (0, 5).                               print "|" at (39, 5).
            print "---------------------------------------" at (1 , 6).
            print "YOU WILL LAUNCH '" + shipName + "'." at ( 2, 3).
            ag10 off.
            print "YES = 1" at ( 2, 5). print "NO = 0" at ( 38-6, 5).

            wait until ag1 = true or ag10 = true.
            if ag1 = true {
                clearScreen.
            }
            if ag10 = true {
                SET abort TO TRUE.
                ag1 off.
            }
        }
    }
}

function init {

    //You can change that -->
    set ap to 10000.  //desired apoapsis (Choose an altitude between 10000 and 20000)
    set landingZone to latlng((-0.131492490075593), -74.5349268442667).  //desired landing zone, latitude on the left and longitude on the right

    //Don't touch -->
    set dir to 90.  //desired direction (90 recommended)
    set g to constant:g * body:mass / body:radius^2.
    set vent_1 to ship:partstaggedpattern("vapor1")[0].
    set vent_2 to ship:partstaggedpattern("vapor2")[0].
    set vent_3 to ship:partstaggedpattern("vapor3")[0].
    set eng1 to ship:partstaggedpattern("raptor1")[0].
    set eng2 to ship:partstaggedpattern("raptor2")[0].
    set eng3 to ship:partstaggedpattern("raptor3")[0].
    set comp to ship:partstaggedpattern("computer")[0].
    

    lock eng1twr to eng1:maxThrust / (mass*100) * g.
    lock eng2twr to eng2:maxThrust / (mass*100) * g.
    lock eng3twr to eng3:maxThrust / (mass*100) * g.
    lock twrpossible to maxThrust / (mass*100) * g.

    set starshipHeight to 20.74.
    lock trueRadar to alt:radar - starshipHeight.

    set targettwr to 0.
    lock Thrott to targettwr * (ship:mass * g / ship:availablethrust).

    set steeringManager:maxstoppingtime to 0.5.
    set steeringManager:rollts to 20.

    set aoa to 0.
    set errorScaling to 1.

    set LatErrorMulti to 200.
    set LngErrorMulti to 110.

    lock maxDecel to (ship:availablethrust / ship:mass) - g.
    lock stopDist to ship:verticalspeed ^ 2 / (2 * maxDecel).
    
    lock trueRadar to alt:radar - starshipHeight.
    lock idealThrottle to stopDist / trueRadar.
    lock impactTime to trueRadar / abs(ship:verticalspeed).

    local latError is latError().
    local lngError is lngError().
}

function getImpact {
    if addons:tr:hasimpact {
        return addons:tr:impactpos.
    }

    return ship:geoPosition.
}

function lngError {
    return getImpact():lng - landingZone:lng.
}

function latError {
    return getImpact():lat - landingZone:lat.
}

function errorVector {
    return getImpact():position - landingZone:position.
}

function getSteering {
    local errorVector is errorVector().
    local velVector is -ship:velocity:surface.
    local result is velVector + errorVector * errorScaling.

    if vAng(result, velVector) > aoa {
        set result to velVector:normalized + tan(aoa) * errorVector:normalized.
    }

    return lookDirUp(result, facing:topvector).
}

function telemetry {
    //Telemetry inspired by Smoketeer: https://www.youtube.com/watch?v=nwqyFIgf6Pc

    log "                                " to log.txt. 
    log "                                " to log.txt.
    log "ALT(M) : " + trueRadar to log.txt.
    log "APO(M) : " + (apoapsis - starshipHeight) to log.txt.
    log "SPEED (km/h): " + round(airspeed*3.6, 2) to log.txt.
    log "THROTTLE(%) :" + round(throttle, 2) * 100 to log.txt.
    log "Q: " + round(ship:Q, 5) to log.txt.
    log "LAT ERROR: " + round(laterror, 5) to log.txt.
    log "LNG ERROR: " + round(lngerror, 5) to log.txt.
    log "STATUS: " + ship:status to log.txt.
    log "RUNMODE: " + RUNMODE to log.txt.
    log "LAST EVENT: " + LASTEVENT to log.txt.
    if ship:status = "FLYING" {log "MISSION TIME: " + "T+ " + round(missionTime, 1) + "s" to log.txt.}
    

    print "---------------------------------------" at (1 , 0).
    print "|" at (0, 1). print "VESSEL INFORMATION" at (20 - 8, 1).                                             print "|" at (39, 1).
    print "|" at (0, 2).                                                                                        print "|" at (39, 2).
    print "|" at (0, 3). print "NAME: " + shipName + "             " at (2, 3).                                 print "|" at (39, 3).
    print "|" at (0, 4). print "MASS (T): " + round(mass, 2) + "             " at (2, 4).                       print "|" at (39, 4).
    print "|" at (0, 5). print "HEIGHT (M): " + starshipHeight + "             " at (2, 5).                     print "|" at (39, 5).
    print "|" at (0, 6). print "TOP WING: " + ag5 + "             " at (2, 6).                                  print "|" at (39, 6).
    print "|" at (0, 7). print "BOTTOM WING: " + ag6 + "             " at (2, 7).                               print "|" at (39, 7).
    print "|" at (0, 8). print "GEAR: " + gear + "     " at (2, 8).                                             print "|" at (39, 8).
    print "|" at (0, 9).                                                                                        print "|" at (39, 9).
    print "---------------------------------------" at (1 , 10).

    print "---------------------------------------" at (1 , 11).
    print "|" at (0, 12). print "FLIGHT MONITOR" at (20 - 7, 12).                                                print "|" at (39, 12).
    print "|" at (0, 13).                                                                                        print "|" at (39, 13).
    print "|" at (0, 14). print "SPEED (km/h): " + round(airspeed*3.6, 2) + "             " at (2, 14).           print "|" at (39, 14).
    print "|" at (0, 15). print "ALT(M): " + round(trueRadar) + "             " at (2, 15).                      print "|" at (39, 15).
    print "|" at (0, 16). print "APO(M): " + round(apoapsis - starshipHeight) + "             " at (2, 16).                       print "|" at (39, 16).
    print "|" at (0, 17). print "THROTTLE(%): " + round(throttle, 2) * 100 + "             " at (2, 17).         print "|" at (39, 17).
    print "|" at (0, 18). print "TWR POSSIBLE: " + round(twrpossible, 2) + "             " at (2, 18).           print "|" at (39, 18).
    print "|" at (0, 19). print "Q: " + round(ship:Q, 5) + " atm        " at (2, 19).                                           print "|" at (39, 19).
    print "|" at (0, 20).                                                                                        print "|" at (39, 20).
    print "---------------------------------------" at (1 , 21).

    print "---------------------------------------" at (1 , 22).
    print "|" at (0, 23).  print "MISSION DATA " at (20 - 7, 23).                                                print "|" at (39, 23).
    print "|" at (0, 24).                                                                                        print "|" at (39, 24).
    print "|" at (0, 25).  print "STATUS: " + ship:status + "             " at (2, 25).                          print "|" at (39, 25).
    print "|" at (0, 26).  print "RUNMODE: " + RUNMODE + "             " at (2, 26).                             print "|" at (39, 26).
    print "|" at (0, 27).  print "LAT ERROR: " + round(laterror, 5) + "             " at (2, 27).                print "|" at (39, 27).
    print "|" at (0, 28).  print "LNG ERROR: " + round(lngerror, 5) + "             " at (2, 28).                print "|" at (39, 28).
    print "|" at (0, 29).                                                                                        print "|" at (39, 29).
    print "|" at (0, 30).  print "LAST EVENT: " + LASTEVENT + "              " at (2, 30).                        print "|" at (39, 30).
    print "|" at (0, 31).  when ship:status = "FLYING" then {print "T+ " + round(missionTime, 1) at (2, 31).}    print "|" at (39, 31).
    print "|" at (0, 32).                                                                                        print "|" at (39, 32).
    print "BY LIO.SPACE ------------------------" at (1 , 33).
} 

function countdown {
    when count = 5 then {
        set warp to 0.
        vent_1:getmodule("MakeSteam"):doaction("toggle vapor vent", true).
        vent_2:getmodule("MakeSteam"):doaction("toggle vapor vent", true).
    }
    UNTIL count = 2 {
        set count to count - 1.
        PRINT "T- " + count + "s     " at ( 2 ,31). 
        WAIT 1. // pauses the script here for 1 second.
    }
} 

function prelaunch {

    RCS off.
    set LASTEVENT to "RCS OFF".
    wait 0.5.

    SAS off.
    set LASTEVENT to "SAS OFF".
    wait 0.5.

    comp:facing.
    set LASTEVENT to "COMPUTER FACING CONTROL".

    if dir = 90 {
        set abort to false.
    }
    else {
        set LASTEVENT to "DIT INCORRECT".
        set abort to true.
    }

    if ap < 10000 or ap > 20000 {
        set abort to true.
        set LASTEVENT to "AP INCORRECT".
    }

    if SHIP:LIQUIDFUEL < 8000 { 
        set LASTEVENT to "FUEL INSUFFICIENT".
        set abort to true.
    }

    if SHIP:OXIDIZER < 9500 { 
        set LASTEVENT to "FUEL INSUFFICIENT".
        set abort to true.
    }

    wait 0.5.

    eng1:shutdown.
    ag2 off. //This is an indicator that will be used later if the engines 1 are off or not.
    eng2:shutdown.
    ag3 off. //This is an indicator that will be used later if the engines 2 are off or not.
    eng3:shutdown.
    ag4 off. //This is an indicator that will be used later if the engines 3 are off or not.
    set LASTEVENT to "ENGINES SHUTDOWN".
    wait 0.5.

    toggle ag8. //unlock gimbal 
    set LASTEVENT to "GIMBAL UNLOCK".
    wait 1.

    ag5 on. //Top wings
    set LASTEVENT to "TOP WINGS DEPLOYED".
    wait 3.
    ag5 off. //Top wings
    set LASTEVENT to "TOP WINGS RETRACTED".
    wait 3.
    ag6 on. //Bottom wings
    set LASTEVENT to "BOTTOM WINGS DEPLOYED".
    wait 3.
    ag6 off. //Bottom wings
    set LASTEVENT to "BOTTOM WINGS RETRACTED".
    wait 3.
    set LASTEVENT to "TEST COMPLETED".
}

function liftoff{
    vent_3:getmodule("MakeSteam"):doaction("toggle vapor vent", true).

    set count to count - 1.
    PRINT "T- " + count + "s     " at ( 2 ,31). 

    stage.
    ag2 on. //This is an indicator that will be used later if the engines 1 are off or not.
    ag3 on. //This is an indicator that will be used later if the engines 2 are off or not.
    ag4 on. //This is an indicator that will be used later if the engines 3 are off or not.
    set LASTEVENT to "STAGE".

    set targettwr to 0.90.
    lock throttle to Thrott.
    wait 1.
    set count to count - 1.
    PRINT "T- " + count + "s     " at ( 2 ,31). 

    set targettwr to 1.10.

    IF twrpossible < 1.01 {
        print "TWR < 1 (Problem)" + "               " at (14, 30).
        SET ABORT TO TRUE.
    }
}

function gravityturn {

    //Ascent Gravity Turn

    set CorrectionLAT to false.
    lock targetPitch to 90 - 0.01 * alt:radar^0.409511.
    lock steering to heading(dir, targetPitch).

    //Correction TWR / Engine
    set CorrectionTWR to true.
    when CorrectionTWR = true then {

        when twrpossible < 1 then {
            if ag2 = false and ag2 = false and ag4 = true {

                local latError is latError().
                local lngError is lngError().
                
                if LatError < 0 {
                    eng2:activate.
                    set LASTEVENT to "TWR correction (eng2)".
                    ag3 off. //This is an indicator that will be used later if the engines 1 are off or not.
                }

                if LatError > 0 {
                    eng1:activate.
                    set LASTEVENT to "TWR correction (eng1)".
                    ag2 off. //This is an indicator that will be used later if the engines 1 are off or not.
                }
            }

            if ag2 = true and ag3 = false and ag4 = true {
                eng2:activate.
                set ag3 to true.
                set LASTEVENT to "TWR correction (eng2)".
            }

            if ag2 = false and ag3 = true and ag4 = true {
                eng1:activate.
                set ag2 to true.
                set LASTEVENT to "TWR correction (eng1)".
            }

            if ag2 = true and ag3 = true and ag4 = true {
                set LASTEVENT to "ECHEC TWR CORRECTION".
                set brakes to true.
            }
        }
    }

    //Correction LAT
    when CorrectionLAT = true then {
        
        set LASTEVENT to "CORRECTION LAT".

        local latError is latError().
        local lngError is lngError().

        set LatCorrection to 0.
        
        lock LatCorrection to (latError * (LatErrorMulti * 5)).
        unlock steering.
        lock steering to heading(dir + (LatCorrection), targetPitch). 

        preserve.
    }
    
    //Q
    when ship:Q > 0.2073 then {
        set LASTEVENT to "TOO MUCH DYNAMIC PRESSURE".
        set brakes to true.
    }

    //Info Telemetry
    WHEN apoapsis > ap THEN {
        set LASTEVENT to "TARGET ALTITUDE REACHED!".
    }

    //Engine shutdown
    when trueRadar > ap/3 and twrpossible > 1 and eng2twr + eng3twr > 1 or trueRadar > ap/3 and twrpossible > 1 and eng1twr + eng3twr > 1 then {
        lock targetPitch to 90 - 0.05 * alt:radar^0.409511.

        local latError is latError().
        local lngError is lngError().

        if LatError < 0 {
            eng1:shutdown.
            set LASTEVENT to "ENG1 SHUTDOWN".
            ag2 off. //This is an indicator that will be used later if the engines 1 are off or not.
        }

        if LatError > 0 {
            eng2:shutdown.
            set LASTEVENT to "ENG2 SHUTDOWN".
            ag3 off. //This is an indicator that will be used later if the engines 1 are off or not.
        }
        set targettwr to 1.20.
        set CorrectionLAT to true.
    }

    when trueRadar > ap/2 and twrpossible > 1 and eng3twr > 1 then {
        if ag2 = false {
            eng2:shutdown.
            set LASTEVENT to "ENG2 SHUTDOWN".
            ag3 off. //This is an indicator that will be used later if the engines 1 are off or not.
        }

        if ag3 = false {
            eng1:shutdown.
            set LASTEVENT to "ENG1 SHUTDOWN".
            ag2 off. //This is an indicator that will be used later if the engines 1 are off or not.
        }
    }

    //Adjust Speed
    when apoapsis > ap + (ap* 0.10) then{
        lock throttle to 0.
    }

    WHEN ship:verticalspeed > 75 and apoapsis < ap and apoapsis > (ap - (ap* 0.10)) then {
        set targettwr to 0.60.
    }

    WHEN ship:verticalspeed < 75 and ship:verticalspeed > 50 and apoapsis < ap and apoapsis > (ap - (ap* 0.10)) then {
        set targettwr to 0.70.
    }

    WHEN ship:verticalspeed < 50 and ship:verticalspeed > 25 and apoapsis < ap and apoapsis > (ap - (ap* 0.10)) then {
        set targettwr to 0.80.
    }

    WHEN ship:verticalspeed < 25 and ship:verticalspeed > 15 and apoapsis < ap and apoapsis > (ap - (ap* 0.10)) then {
        set targettwr to 0.90.
    }

    WHEN ship:verticalspeed < 15 and ship:verticalspeed > 5 and apoapsis < ap and apoapsis > (ap - (ap* 0.10)) then {
        set targettwr to 1.
    }

    WHEN ship:verticalspeed < 5 and ship:verticalspeed > 0 and apoapsis < ap and apoapsis > (ap - (ap* 0.10)) then {
        set targettwr to 1.10.
    }

    WHEN ship:verticalspeed < 0 and apoapsis < ap and apoapsis > (ap - (ap* 0.10))then {
        set targettwr to 1.20.
    }

    WHEN apoapsis > ap then {
        set targettwr to 0.25.
        wait until ship:verticalSpeed < 3 and trueRadar > 1000.
    }

    until ship:verticalSpeed < 0 and trueRadar > 1000. { //= wait until
        wait 0.
    }
    set CorrectionTWR to false.
    set CorrectionLAT to false.
    wait 0.1.
}

//Modified script from QuasyMoFo (https://www.youtube.com/channel/UCDOhE4SFwHugyy2EYL4SjPQ)
//>>
function controlledDescent {

    lock steering to heading(270, 70, 180).
    ag6 on. //Bottom wings 
    set LASTEVENT to "BOTTOM WINGS DEPLOYED".
    
    wait until verticalSpeed < -20.
    unlock steering.
    lock throttle to 0.

    wait 0.5.

    eng3:shutdown.
    ag4 off.
    set LASTEVENT to "ENGINE SHUTDOWN".

    toggle ag7. //lock gimbal
    set LASTEVENT to "GIMBAL LOCK".

    wait 0.5.

    eng1:activate.
    ag2 on. //This is an indicator that will be used later if the engines 1 are off or not.
    set LASTEVENT to "ENG1 ACTIVE".

    eng2:activate.
    ag3 on. //This is an indicator that will be used later if the engines 2 are off or not.
    set LASTEVENT to "ENG2 ACTIVE".

    rcs on.
    set LASTEVENT to "RCS ON".

    ag5 on. //Bottom wings 
    set LASTEVENT to "TOP WINGS DEPLOYED".

    wait until ship:verticalSpeed < -30.

    lock LatCorrection to 0.
    lock LngCorrection to 0.

    lock LatCorrection to (latError * (LatErrorMulti * 1)). 
    lock LngCorrection to (lngError * LngErrorMulti * 1).

    when trueRadar < stopDist + 1000 then {
        set warp to 0.
    }

    when altitude < 4000 then {
        lock LatCorrection to (latError * (LatErrorMulti * 20)). 
        lock LngCorrection to (lngError * LngErrorMulti * 12).
    }

    when altitude < 15000 and altitude > 4000 then {
        lock LatCorrection to (latError * (LatErrorMulti * 20)). 
        lock LngCorrection to (lngError * LngErrorMulti * 6).
    }

    when altitude > 15000 and altitude < 20000 then {
        lock LatCorrection to (latError * (LatErrorMulti * 15)). 
        lock LngCorrection to (lngError * LngErrorMulti * 2).
    }

    lock steering to heading(270, (0 - LngCorrection), (180 + (LatCorrection))).
    wait 0.3.
    if rcs = true {
        rcs off.
        set LASTEVENT to "RCS OFF".
    }

    until (trueRadar < stopDist + 500) {
        wait 0.
    }
}

FUNCTION landing {
    set warp to 0.
    lock idealThrottle to stopDist / trueRadar.
    when impactTime < 3 then {gear on.}

    set aoa to -1.5.
    toggle ag8.
    set LASTEVENT to "GIMBAL UNLOCK".
    lock throttle to (idealThrottle + 0.1).
    ag5 off.
    Set ship:control:pitch to -190.
    wait 1.
    set ship:control:neutralize to true.
    lock steering to getSteering().

    lock throttle to idealThrottle + 0.4.
    toggle ag8.
    wait until ship:verticalspeed > -30.
    lock throttle to idealThrottle + 0.4.

    wait until ship:verticalSpeed > -20.
    set cf to facing. 
    lock steering to cf.

    wait until ship:status = "LANDED".
    lock throttle to 0.
}

FUNCTION AfterLanding {
    SET LASTEVENT TO "AFTER LANDING".
    wait 2.
    unlock steering.
    eng1:shutdown.
    ag2 off. //This is an indicator that will be used later if the engines 1 are off or not.
    eng2:shutdown.
    ag3 off. //This is an indicator that will be used later if the engines 2 are off or not.
    set LASTEVENT TO "ENGINES SHUTDOWN".
    ag6 off. //Bottom wings
    set LASTEVENT to "BOTTOM WINGS RETRACTED".
    wait 10.
    rcs off.
    set LASTEVENT to "RCS OFF".
}


