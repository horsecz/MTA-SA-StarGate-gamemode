-- sound_c.lua: Stargate sounds module; client-side

-- PlaySound3D but from triggered server-side event with additional data
-- > plays in set distance
-- > played in dimension where stargate is placed
-- > exception is sound of milkyway ring rotating
--		> this sound is played periodically
--- REQUIRED PARAMETERS:
--> stargateID		string		ID of stargate
--> soundpath		string		file path of sound
--> x, y, z			int			world position, where will be sound played
--> distance		int			range, in which will be sound heard
--> soundAttrib		string		custom sound attribute (to identify the sound)
function playSound3DFromServerSG(stargateID, soundpath, x, y, z, distance, soundAttrib)
	local s = playSound3D(soundpath, x, y, z)
	local planet = planet_getElementOccupiedPlanet(stargate_getElement(stargateID))
	setElementDimension(s, planet_getPlanetDimension(planet)) -- need to use setElementDimension immediately
    planet_setElementOccupiedPlanet(s, planet)		


	if distance then
		setSoundMaxDistance(s, distance)
	else
		local distance = 150
	end
	setElementData(getElementByID(stargateID), soundAttrib, s)

	if soundAttrib == "sound_ring_rotate" then
		local beginSoundLength = getSoundLength(s)*1000
		local continueRotationSound = setTimer(function(stargateID, distance)
			local ls = playSound3D("sounds/mw_ring_rotate.mp3", x, y, z)
			setElementDimension(ls, planet_getPlanetDimension(planet)) -- need to use setElementDimension immediately
			planet_setElementOccupiedPlanet(ls, planet)		
			setSoundMaxDistance(ls, distance)
			setElementData(getElementByID(stargateID), "sound_ring_rotate_long", ls)
		end
		, beginSoundLength-100, 1, stargateID, distance)
		setElementData(getElementByID(stargateID), "sound_ring_rotate_long_t", continueRotationSound)
	end
end
addEvent("clientPlaySound3D", true)
addEventHandler("clientPlaySound3D", root, playSound3DFromServerSG)

-- StopSound from triggered server-side event
--- REQUIRED PARAMETERS:
--> stargateID		string		ID of stargate
--> soundAttribute	string		attribute key, which identifies the sound
function stopSoundFromServerSG(stargateID, soundAttribute)
	local sound = getElementData(getElementByID(stargateID), soundAttribute)
	if isElement(sound) and getElementType(sound) == "sound" then
		stopSound(sound)
	end
	if soundAttribute == "sound_ring_rotate" then
		local timer = getElementData(getElementByID(stargateID), "sound_ring_rotate_long_t")
		if isTimer(timer) then
			killTimer(timer)
		else
			local l_sound = getElementData(getElementByID(stargateID), "sound_ring_rotate_long")
			if isElement(l_sound) and getElementType(l_sound) == "sound" then
				stopSound(l_sound)
			end
		end
	end
end
addEvent("clientStopSound", true)
addEventHandler("clientStopSound", root, stopSoundFromServerSG)