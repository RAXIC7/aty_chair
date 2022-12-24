local QBCore = exports['qb-core']:GetCoreObject()

local isSitting = false
local haschairalready
local attachedProp = 0

function attachAProp(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp()
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent 
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end
	attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedProp, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
	SetModelAsNoLongerNeeded(attachModel)
end

function removeAttachedProp()
	DeleteEntity(attachedProp)
	attachedProp = 0
end

function loadModel(modelName)
    RequestModel(GetHashKey(modelName))
    while not HasModelLoaded(GetHashKey(modelName)) do
        RequestModel(GetHashKey(modelName))
        Citizen.Wait(1)
    end
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

Citizen.CreateThread(function()
	local sleep = 200
	while true do
		if isSitting then
			sleep = 1
			if IsControlJustReleased(0, 38) then
				chair()
				exports['mythic_notify']:SendAlert('inform', 'Kalktın')
				TriggerServerEvent("addChair")
			end
		else
			sleep = 200
		end
		Citizen.Wait(sleep)
	end
end)

RegisterCommand('chair', function()
	QBCore.Functions.TriggerCallback("aty:ChairChecked", function(cb)
		if cb and not isSitting then
			exports['mythic_notify']:SendAlert('inform', 'Kalkmak için [E] tuşuna basın')
			chair()
		elseif isSitting then
			exports['mythic_notify']:SendAlert('error', 'Zaten oturuyorsun!')
		elseif cb == false then
			exports['mythic_notify']:SendAlert('error', 'Sandalyen yok!')
		end
	end)
end, false)

RegisterCommand('clearprop', function()
	FreezeEntityPosition(PlayerPedId(),false)
	removeAttachedProp()
end)

function chair()
	if not haschairalready then
		haschairalready = true
		isSitting = true
		local coords = GetEntityCoords(PlayerPedId())
		local animDict = "timetable@ron@ig_3_couch"
		local animation = "base"
		attachAProp("hei_prop_hei_skid_chair", 0, 0, 0.0, -0.22, 3.4, 0.4, 180.0, 0.0, false, false, false, false, 2, true)
		loadAnimDict(animDict)
		local animLength = GetAnimDuration(animDict, animation)
		TaskPlayAnim(PlayerPedId(), animDict, animation, 4.0, 4.0, animLength, 1, 0, 0, 0, 0)
	else
		haschairalready = false
		isSitting = false
		FreezeEntityPosition(PlayerPedId(),false)
		removeAttachedProp()
		ClearPedTasks(PlayerPedId())
	end
end