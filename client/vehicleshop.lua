local Categories, BoatCategories, Vehicles, Boats, NumberCharset, Charset, loaded = {}, {}, {}, {}, {}, {}, {}
loaded['car'], loaded['boat'], isVip = false, false, 0
for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

RegisterNUICallback('buyvehicle', function(data, cb)
    local dataTable = data
	--exports['mythic_notify']:PersistentHudText('START','waiting','vermelho',_U('wait_vehicle'))
    ESX.TriggerServerCallback('panama_autosalon:buyVehicle', function(hasEnoughMoney)
		--exports['mythic_notify']:PersistentHudText('END','waiting')
		if hasEnoughMoney then
		ESX.Game.SpawnVehicle(dataTable.model, Config.Shops[data.vehicleType].vehiclespawn.coords, Config.Shops[data.vehicleType].vehiclespawn.heading, function (vehicle)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				local newPlate     = GeneratePlate()
				local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
				vehicleProps.plate = newPlate
				SetVehicleNumberPlateText(vehicle, newPlate)
				TriggerServerEvent('panama_autosalon:setVehicleOwner', vehicleProps, dataTable.vehicleType, dataTable.img, dataTable.name, dataTable.brand)
				TriggerEvent('panama_notifikacije:sendNotification', 'fas fa-check', 'Auto je uspesno kupljeno!', 4000)
			end)
		else
			TriggerEvent('panama_notifikacije:sendNotification', 'fas fa-exclamation', 'Nemate dovoljno para!', 4000)
		end
	end, dataTable.price)

end)

RegisterNUICallback('close', function()
	SetNuiFocus(false, false) 
end)

RegisterNetEvent('panama_autosalon:sendCategories')
AddEventHandler('panama_autosalon:sendCategories', function (categories)
	Categories = categories
end)

RegisterNetEvent('panama_autosalon:sendVehicles')
AddEventHandler('panama_autosalon:sendVehicles', function (vehicles)
	Vehicles = vehicles
end)

RegisterNetEvent('panama_autosalon:changeVipStatus', function(tinyInt) 
	print(tinyInt)
	if tinyInt == false then
		ESX.ShowNotification('izgubili ste vipa')
		isVip = false
	elseif tinyInt == true then
		ESX.ShowNotification('dobili ste vipa')
		isVip = true
	end
end)

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(10000)

	local vip = ESX.GetPlayerData().commonData.vip
	if vip == 0 then
		isVip = false
	else
		isVip = true
	end

	ESX.TriggerServerCallback('panama_autosalon:getCategories', function(categories)
		Categories = categories
	end)

	ESX.TriggerServerCallback('panama_autosalon:getVehicles', function(vehicles)
		Vehicles = vehicles
		loaded['car'] = true
	end)

	ESX.TriggerServerCallback('panama_autosalon:getBoatCategories', function(categories)
		BoatCategories = categories
	end)

	ESX.TriggerServerCallback('panama_autosalon:getBoats', function(boats)
		Boats = boats
		loaded['boat'] = true
	end)

	Citizen.Wait(10000)
end)

RegisterNUICallback('testvehicle', function(data)
	TriggerServerEvent('panama_autosalon:checkTestSession', data.vehicleType, GetEntityCoords(PlayerPedId()), data.model)
end)

RegisterNetEvent('panama_autosalon:spawnTestVehicle')
AddEventHandler('panama_autosalon:spawnTestVehicle', function(model, key, oldCoords)
	ESX.Game.SpawnVehicle(model, vector3(-1733.25, -2901.43, 13.94), 326, function(vehicle)
		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
		SetVehicleNumberPlateText(vehicle, "PANAMA")
		TriggerServerEvent('panama_autosalon:startSession', key, vehicle, oldCoords)
	end)
end)

RegisterNetEvent('panama_autosalon:setCoords', function(coords)
	SetEntityCoords(PlayerPedId(), coords, false, false, false, false)
end)

RegisterNetEvent('panama_autosalon:deleteVehicle')
AddEventHandler('panama_autosalon:deleteVehicle', function(vehicleId)
	DeleteVehicle(vehicleId)
end)

Citizen.CreateThread(function()
    for _, info in pairs(Config.Shops) do
      info.blip = AddBlipForCoord(info.entering)
      if _ == 'car' then
        SetBlipSprite(info.blip, 225)
      else
        SetBlipSprite(info.blip, 410)
      end
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 1.0)
      SetBlipColour(info.blip, 3)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.label)
      EndTextCommandSetBlipName(info.blip)
    end
end)

Citizen.CreateThread(function() 
	local showed = false;
	local key = nil;
	while true do 
		Citizen.Wait(0)
		letSleep = true
		if key == nil then 
			for k,v in pairs(Config.Shops) do
				local coords = GetEntityCoords(PlayerPedId())
				local distance = #(coords - v.entering)
				if distance <= 20.0 then
					letSleep = false
					DrawMarker(v.marker, v.entering, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0,0,120, 100, false, true, 2, true, false, false, false)
				end
				if distance <= 2.0 then
					key = k
				end
			end
		end
		if key then
			local coords = GetEntityCoords(PlayerPedId())
			local distance = #(coords - Config.Shops[key].entering)
			letSleep = true
			if distance <= 20.0 then
				letSleep = false
				DrawMarker(Config.Shops[key].marker, Config.Shops[key].entering, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0,0,120, 100, false, true, 2, true, false, false, false)
			end
			if distance <= 2.0 and not showed then
				showed = true
				TriggerEvent('panama_notifikacije:sendFloatingText', Config.Shops[key].hint)
			elseif distance > 2.0 and showed then
				TriggerEvent('panama_notifikacije:sendFloatingText')
				showed = false
				key = nil
			end
			if IsControlJustReleased(1,38) and showed then
				if key == 'car' then
					SendNUIMessage({action = 'show', vehicles = Vehicles, isLoaded = loaded['car'], vip = isVip, vehicleType = key})
					SetNuiFocus(true,true)
				elseif key == 'boat' then
					SendNUIMessage({action = 'show', vehicles = Boats, isLoaded = loaded['boat'], vip = isVip, vehicleType = key})
					SetNuiFocus(true,true)
				end
			end
		end
		if letSleep then
			Citizen.Wait(2000)
		end
	end
end)

--Resource Manifest------------------------------
AddEventHandler('onResourceStop', function()
	if (GetCurrentResourceName() ~= 'panama_autosalon') then
	  return
	end
	SetNuiFocus(false, false)
end)

----------------------UTILIS-------------------------------
function GeneratePlate()
	local generatedPlate
	local doBreak = false
	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers))	
		ESX.TriggerServerCallback('panama_autosalon:isPlateTaken', function (isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end
	return generatedPlate
end

function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('panama_autosalon:isPlateTaken', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Citizen.Wait(0)
	end

	return callback
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

--Citizen.CreateThread(function() while true do Citizen.Wait(1000) print(GetEntityCoords(PlayerPedId())) end end)