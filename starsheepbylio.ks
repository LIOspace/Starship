//LIO.space - Starship Sript [Version 2.0.0]

core:part:getmodule("kOSProcessor"):doevent("Open Terminal"). //Open the Terminal
clearScreen.

askstart().
init().
windowcarefull().

set count to 10.
set LASTEVENT to "NO DATA".
set RUNMODE to "ON".
set warpmode to "PHYSICS".

findrunmode().
until RUNMODE = "OFF" {
    when warp > 3 then {
        set warp to 3.
    }

    set setup to true.
    when setup = true then {
        telemetry().
        wait 0.01.
        preserve.
    }

    verif().

    if RUNMODE = "PRELAUNCH" {
        prelaunch().
        countdown().
        liftoff().
        set RUNMODE to "GRAVITY TURN".
    }
    else if RUNMODE = "GRAVITY TURN" {
        gravityturn().
        set RUNMODE to "LANDING".
    }
    else if RUNMODE = "LANDING" {
        landing().
        set RUNMODE to "OFF".
    }

    wait 0.1.
}

shutdown.


function askstart {
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
    set g to constant:g * body:mass / body:radius^2.

    set eng1 to ship:partstaggedpattern("raptor1")[0].
    set eng2 to ship:partstaggedpattern("raptor2")[0].
    set eng3 to ship:partstaggedpattern("raptor3")[0].
    set comp to ship:partstaggedpattern("computer")[0].

    lock eng1twr to eng1:availableThrust / (mass*100) * g.
    lock eng2twr to eng2:availableThrust / (mass*100) * g.
    lock eng3twr to eng3:availableThrust / (mass*100) * g.
    lock availabletwr to availableThrust / (mass*100) * g.

    set height to 20.74.
    lock trueRadar to alt:radar - height.

    set steeringManager:maxstoppingtime to 0.5.
    set steeringManager:rollts to 20.

    set aoa to 0.
    set errorScaling to 1.
    set targettwr to 0.

    lock LatErrorMulti to 110.
    lock LngErrorMulti to 110.

    lock maxDecel to ship:availablethrust / ship:mass - g.
    lock stopDist to ship:verticalspeed ^ 2 / (2 * maxDecel).
    
    lock trueRadar to alt:radar - height.
    lock idealThrottle to stopDist / trueRadar.
    lock impactTime to trueRadar / abs(ship:verticalspeed).
    lock Thrott to targettwr * (ship:mass * g / ship:availablethrust).
    //lock VerticalEc to 1/2 * ship:mass * ship:verticalSpeed^2.

    local latError is latError().
    local lngError is lngError().
}

function windowcarefull {
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

    set done to false.
    when (ok:TAKEPRESS) then {
        gui:HIDE().
        WAIT 0.1. // No need to waste CPU time checking too often.
        set done to true.
    }

    until done = true {
        wait 0.
    }
}

function verif {
    if ABORT = true {
        set RUNMODE to "OFF".
    }

    if ship:Q > 0.2073 {
        set LASTEVENT to "TOO MUCH DYNAMIC PRESSURE".
    }

    if trueRadar > ap {
        set LASTEVENT to "TARGET ALTITUDE REACHED!".
    }
}

    //FOR LANDING -->
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
    //<-- FOR LANDING

function telemetry {
    print "---------------------------------------" at (1 , 0).
    print "|" at (0, 1). print "VESSEL INFORMATION" at (20 - 8, 1).                                             print "|" at (39, 1).
    print "|" at (0, 2).                                                                                        print "|" at (39, 2).
    print "|" at (0, 3). print "NAME: " + shipName + "             " at (2, 3).                                 print "|" at (39, 3).
    print "|" at (0, 4). print "MASS (T): " + round(mass, 2) + "             " at (2, 4).                       print "|" at (39, 4).
    print "|" at (0, 5). print "HEIGHT (M): " + height + "             " at (2, 5).                     print "|" at (39, 5).
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
    print "|" at (0, 16). print "APO(M): " + round(apoapsis - height) + "             " at (2, 16).                       print "|" at (39, 16).
    print "|" at (0, 17). print "THROTTLE(%): " + round(throttle, 2) * 100 + "             " at (2, 17).         print "|" at (39, 17).
    print "|" at (0, 18). print "TWR POSSIBLE: " + round(availabletwr, 2) + "             " at (2, 18).           print "|" at (39, 18).
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
    print "|" at (0, 31).  when ship:status = "FLYING" then {print "T+ " + round(missionTime) at (2, 31).}    print "|" at (39, 31).
    print "|" at (0, 32).                                                                                        print "|" at (39, 32).
    print "BY LIO.SPACE ------------------------" at (1 , 33).
}

function findrunmode {
    if ship:status = "PRELAUNCH" {
        set RUNMODE to "PRELAUNCH".
    }

    else if ship:status = "FLYING" and ship:verticalspeed < 5 and ship:verticalspeed > 5{
        set RUNMODE to "LIFTOFF".
    }

    else if ship:status = "FLYING" or ship:status = "SUB_ORBITAL" or ship:status = "ORBITING" or ship:status = "ESCAPING" and ship:verticalspeed > 5 {
        set RUNMODE to "GRAVITY TURN".
    }

    else if ship:status = "FLYING" or ship:status = "SUB_ORBITAL" or ship:status = "ORBITING" or ship:status = "ESCAPING" and ship:verticalspeed < -5 {
        set RUNMODE to "LANDING".
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

    if ap < 5000 or ap > 20000 {
        set LASTEVENT to "AP INCORECT".
        set abort to true.
    }

    if SHIP:LIQUIDFUEL < 7500 { 
        set LASTEVENT to "FUEL INSUFFICIENT".
        set abort to true.
    }

    if SHIP:OXIDIZER < 9000 { 
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

function countdown {
    until count = 2 {
        set count to count - 1.
        PRINT "T- " + count + "s     " at ( 2 ,31). 
        WAIT 1. // pauses the script here for 1 second.
    }
} 

function liftoff {
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

    set targettwr to 1.20.

    IF availabletwr < 1.01 {
        print "TWR < 1 (Problem)" + "               " at (14, 30).
        SET ABORT TO TRUE.
    }
}

function gravityturn {
    lock targetPitch to 90 - 0.03 * alt:radar^0.409511.
    lock steering to heading(90, targetPitch, SHIP:DIRECTION:ROLL).

    until ship:verticalspeed > 40 {
        verif().
        wait 0.
    }

    local latError is latError().
    local lngError is lngError().

    set LatCorrection to 0.
    set LngCorrection to 0.

    until apoapsis > ap - verticalSpeed * 5 {

        if LatCorrection > 45 {set LatCorrection to 45.}
        if LatCorrection < -45  {set LatCorrection to -45.}
        if LngCorrection > 20 {set LngCorrection to 20.}
        if LngCorrection < -20 {set LngCorrection to -20.}

        lock LatCorrection to (latError * LatErrorMulti * 5).
        lock steering to heading(90 + LatCorrection, targetPitch, SHIP:DIRECTION:ROLL).

        if trueRadar > ap/3 and availabletwr > 1 and eng2twr + eng3twr > 1 or trueRadar > ap/3 and availabletwr > 1 and eng1twr + eng3twr > 1 {
            lock targetPitch to 90 - 0.05 * alt:radar^0.409511.

            if LatError < 0 {
                eng1:shutdown.
                set LASTEVENT to "ENG1 SHUTDOWN".
                ag2 off. //This is an indicator that will be used later if the engines 1 are off or not.
            }

            if LatError > 0 {
                eng2:shutdown.
                set LASTEVENT to "ENG2 SHUTDOWN".
                ag3 off. //This is an indicator that will be used later if the engines 2 are off or not.
            }
        }

        if trueRadar > ap/2 and availabletwr > 2 {
            if ag2 = false {
                eng2:shutdown.
                set LASTEVENT to "ENG2 SHUTDOWN".
                ag3 off. //This is an indicator that will be used later if the engines 2 are off or not.
            }

            if ag3 = false {
                eng1:shutdown.
                set LASTEVENT to "ENG1 SHUTDOWN".
                ag2 off. //This is an indicator that will be used later if the engines 1 are off or not.
            }
        }
    }

    until trueRadar > ap {

        if ship:verticalSpeed < 50 {
            set targettwr to targettwr + 0.1.
        } 

        if ship:verticalSpeed > 50 {
            set targettwr to targettwr - 0.1.
        } 

        if targettwr < 0.1 {
            set targettwr to 0.1.
        }

        wait 0.
    }

    until ship:verticalSpeed < -1 {
        set targettwr to 0.25.
        wait 0.
    }
}

function landing {
    lock steering to heading(90, 110, 90).
    ag6 on. //Bottom wings 
    set LASTEVENT to "BOTTOM WINGS DEPLOYED".
    ag5 on. //Bottom wings 
    set LASTEVENT to "TOP WINGS DEPLOYED".
    
    lock throttle to 0.

    until ship:verticalSpeed < -20 {
        wait 0.
    }

    eng3:shutdown.
    ag4 off.
    set LASTEVENT to "ENGINE SHUTDOWN".

    toggle ag7. //lock gimbal
    set LASTEVENT to "GIMBAL LOCK".

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

    until (trueRadar < stopDist + 500) {

        unlock steering.

        set LatCorrection to (latError * LatErrorMulti * 11). 
        set LngCorrection to (lngError * LngErrorMulti * 11).
        
        if LatCorrection > 60 {set LatCorrection to 60.}
        if LatCorrection < -60 {set LatCorrection to -60.}
        if LngCorrection > 20 {set LngCorrection to 20.}
        if LngCorrection < -20 {set LngCorrection to -20.}


        lock steering to heading(270, (0 - LngCorrection), (180 + (LatCorrection))).

        if rcs = true {
            rcs off.
            set LASTEVENT to "RCS OFF".
        }
    }

    lock idealThrottle to stopDist / trueRadar.
    when impactTime < 3 then {gear on.}
    when impactTime < 1 then {set cf to facing. lock steering to cf.}

    set aoa to -1.5.
    toggle ag8.
    set LASTEVENT to "GIMBAL UNLOCK".
    lock throttle to (idealThrottle + 0.1).
    lock steering to getSteering().
    ag5 off.

    lock throttle to idealThrottle.
    until ship:verticalspeed > -40 {
        wait 0.
    }
    ag5 on.
    lock throttle to (idealThrottle + 0.1).

    until ship:status = "LANDED" {
        wait 0.
    }

    lock throttle to 0.

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
    set LASTEVENT to "RCS OFF ".

    set RUNMODE to "OFF".
}