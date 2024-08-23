-- Eleen's Pressure Mechanic Script
-- Made for Psych Engine
-- Used in mods from Team Eleen

-- This is the pressure script for Project: Monsoon, for Rainmaker's week.
-- Each difficulty; standard, greened and uber has it's own initial pressure value.
-- The pressure increases when the player misses notes.
-- Why should boyfriend be the only one to damage the other singer?
-- Rainmaker passively damages the player while she sings; though, the player can only faint when they miss notes at low health.

local pressure = 0.01 -- we do not start at 0. this prevents the player from not getting damaged by the opponent.

-- for the test build; we want to see if the difficulty's starting pressure is actually fine
-- TODO: remove debug text for when the mod goes public
-- TODO TODO: Adjust pressure values for each difficulty; balancing challenge and not making it expurgation levels of brutal
-- difficulty 0 is standard. Since this mod is currently only a one-shot, traditional difficulty naming conventions are ignored.
-- difficulty 1 is Greened. This is a term used in clash that means that some folks are causing other players to die; so here we're amping up the challenge.
-- difficulty 2 is Uber. Usually, in clash that's just a toon with a limit on their health. Here, it means that You might wanna brace yer face somethin' painful. 
-- TO OTHER TEAM MEMBERS: Do NOT DELETE THE PRESSURE SCRIPT! If it's too hard; go here and adjust values!
-- Also; please make sure you mention changes in the commit. 
-- TO OTHER TEAM MEMBERS: Playtest your changes; and have fun with it.

function onCountdownStarted()
    debugPrint("Current difficulty: " .. tostring(difficulty))  -- Debugging line to check the difficulty being fetched
    if difficulty == 0 then
        pressure = pressure + 0.06
        debugPrint("Is this set to Standard? It should be 0.07.") -- debug text; if it works it should be fine
    elseif difficulty == 1 then
        pressure = pressure + 0.07
        debugPrint("Is this set to Greened? It should be 0.08.") -- public build won't have this text
    elseif difficulty == 2 then
        pressure = pressure + 0.09
        debugPrint("Is this set to Uber? It should be 0.1.") -- i wrote this code for a different mod; so i KNOW this works
    end
    debugPrint("Pressure set to: " .. tostring(pressure))  -- Debugging line to check the pressure value after the difficulty check. FUCK me if this doesn't work
end

-- ok so this part:
-- notes the difficulty of the song, then checks the pressure.
-- each difficulty has it's own pressure values that it adds on miss. 

function noteMiss()
    if pressure >= 0.01 then
        if difficulty == 0 then
            pressure = pressure + 0.03
        elseif difficulty == 1 then
            pressure = pressure + 0.04
        elseif difficulty == 2 then
            pressure = pressure + 0.06
        end
    end;
end

-- psych engine doesn't let us do this easy with base sourcecode
-- so we have to do this weirdness for the score text; just to show the mechanic
-- TODO: make this look better?

function onUpdatePost(elasped)
    setTextString('scoreTxt', 'Score: '.. score .. ' | Misses: '.. misses .. ' | Combo Quality: '.. ratingName..' ('.. ratingFC ..') | Pressure: '.. pressure ..'pon')
end

function goodNoteHit()
-- should there be anything for a good note hit?
-- nah.
end

-- hit the player when opponent sings for pressure times 0.012 times whatever the health loss multiplier is.
-- this is to make the player lose health when the opponent sings.
-- the player cannot die. 
-- the pressure is dynamic; and increases when the player misses notes.
-- it gives the feeling of when the battle is going reaaal wrong in corporate clash; folks are poppin' unites and trying to stay alive. 
-- unlike clash; there ain't any unites to save you
-- play good! or miss a couple, to make it challenging for yourself

function onBeatHit()
        function opponentNoteHit()
            health = getProperty('health')
            if getProperty('health') > 0.55 then
                if difficulty == 0 then
                    setProperty('health', health-(pressure * 0.012 * healthLossMult)); -- Standard has a slower health loss rate. 
                elseif difficulty == 1 then
                    setProperty('health', health-(pressure * 0.2 * healthLossMult)); -- Greened is gonna be brutal.
                elseif difficulty == 2 then
                    setProperty('health', health-(pressure * 0.4 * healthLossMult)); -- Uber sure is one of the most difficulties of all time. 
                end
            end
        end
end