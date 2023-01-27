vehiclesInGarage, carInstance = {}, {}

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(10000)
end)

RegisterNetEvent('panama_garaza:emptyGarage')
AddEventHandler('panama_garaza:emptyGarage', function()
    vehiclesInGarage = {}
end)

Citizen.CreateThread(function()
    for _, info in pairs(Config.Garage) do
      info.blip = AddBlipForCoord(info.pos)
      if info.type == 'car' then
        SetBlipSprite(info.blip, 357)
      else
        SetBlipSprite(info.blip, 427)
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

function GetVehiclesClient(type, garage)
    ESX.TriggerServerCallback('panama_garaza:getVehicles', function(result)
        local vehiclePropList = {}
        if not isTableEmpty(result) then
            for k, v in pairs(result) do
                local desc = json.decode(v.description)
                local vehicleProps = json.decode(v.vehicle)
                vehiclePropList[vehicleProps.plate] = vehicleProps

                if v.vehiclename then
					vehicleName = v.vehiclename					
				else
					vehicleName = GetDisplayNameFromVehicleModel(vehicleProps.model)
                end
                vehiclesInGarage[vehicleProps.plate] = {
                    imgsrc = desc.img,
                    name = desc.name,
                    brand = desc.brand,
                    vehicleName = vehicleName,
                    stored = v.stored,
                    garage = v.garage,
                    body = vehicleProps.bodyHealth,
                    fuel = vehicleProps.fuelLevel,
                    engineHP = vehicleProps.engineHealth,
                    carProps = vehicleProps
                }
            end
            SendNUIMessage({action = 'garage', garage = garage, garageList = vehiclesInGarage, isEmpty = false})
        else
            SendNUIMessage({action = 'garage', garage = garage, garageList = vehiclesInGarage, isEmpty = true})
        end
    end)
end

Citizen.CreateThread(function()
    local showed = false
    local deleteShowed = false
    local key = nil
    while true do 
        Citizen.Wait(0)
        local letSleep = true
        if key == nil then
            for k,v in pairs(Config.Garage) do
                local coords = GetEntityCoords(PlayerPedId())
                local distance = #(coords - v.pos)
                local deleteDistance = #(coords - v.DeletePoint.pos)
                if distance <= 40.0 or deleteDistance <= 40.0 then
                    key = k
                end
            end
        end
        if key then
            local coords = GetEntityCoords(PlayerPedId())
            local distance = #(coords - Config.Garage[key].pos)
            local deleteDistance = #(coords - Config.Garage[key].DeletePoint.pos)
            if distance <= 20.0 then
                letSleep = false
                DrawMarker(Config.Garage[key].marker, Config.Garage[key].pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0,0,120, 100, false, true, 2, true, false, false, false)
            end
            if distance <= 2.0 and not showed then
                showed = true
                TriggerEvent('panama_notifikacije:sendFloatingText', Config.Garage[key].hint)
            elseif distance > 2.0 and showed then
                TriggerEvent('panama_notifikacije:sendFloatingText')
                showed = false
            end
            if IsControlJustReleased(1,38) and showed then
                if isTableEmpty(vehiclesInGarage) then
                    GetVehiclesClient(Config.Garage[key].type, key)
                else
                    SendNUIMessage({action = 'garage', garage = key ,garageList = vehiclesInGarage, isEmpty = false})
                end
                SetNuiFocus(true,true)
            end	
            --delete point
            if deleteDistance <= 20.0 then
                letSleep = false
                DrawMarker(Config.Garage[key].marker, Config.Garage[key].DeletePoint.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 120,0,0, 100, false, true, 2, true, false, false, false)
            elseif deleteDistance > 20.0 or distance > 20.0 then
                key = nil
            end
            if deleteDistance <= 2.0 and not deleteShowed then
                deleteShowed = true
                TriggerEvent('panama_notifikacije:sendFloatingText', 'Pritisnite <span>E</span> da ostavite <span>vozilo</span> u garazi.')
            elseif deleteDistance > 2.0 and deleteShowed then
                TriggerEvent('panama_notifikacije:sendFloatingText')
                deleteShowed = false
            end
            if IsControlJustReleased(1,38) and deleteShowed then
                returnVehicle(key)
            end	
        end
        if letSleep then
            Citizen.Wait(1500)
        end
    end
end)

function isTableEmpty(self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end

--Does Player Drive a car
function DoesAPlayerDrivesCar(plate)
	local isVehicleTaken = false
	local players  = ESX.Game.GetPlayers()
	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])
		if target ~= PlayerPedId() then
			local plate1 = GetVehicleNumberPlateText(GetVehiclePedIsIn(target, true))
			local plate2 = GetVehicleNumberPlateText(GetVehiclePedIsIn(target, false))
			if plate == plate1 or plate == plate2 then
				isVehicleTaken = true
				break
			end
		end
	end
	return isVehicleTaken
end
--VEHICLE PROPERTIES--
function SetVehicleProperties(vehicle, vehicleProps)
    ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
    --Windows
    --[[if vehicleProps["windows"] then
        for windowId = 1, 9, 1 do
            print('------')
            print(vehicleProps['windows'][windowId])
            if vehicleProps["windows"][windowId] == false then
                SmashVehicleWindow(vehicle, windowId)
            end
        end
    end--]]

    if vehicleProps["tyres"] then
        for tyreId = 1, 7, 1 do
            if vehicleProps["tyres"][tyreId] ~= false then
                SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
            end
        end
    end

    if vehicleProps["doors"] then
        for doorId = 0, 5, 1 do
            if vehicleProps["doors"][doorId] ~= false then
                SetVehicleDoorBroken(vehicle, doorId - 1, true)
            end
        end
    end
    if vehicleProps.vehicleHeadLight then SetVehicleHeadlightsColour(vehicle, vehicleProps.vehicleHeadLight) end
    SetVehicleEngineHealth(vehicle, vehicleProps["engineHealth"] and vehicleProps["engineHealth"] + 0.0 or 1000.0)
    SetVehicleBodyHealth(vehicle, vehicleProps["bodyHealth"] and vehicleProps["bodyHealth"] + 0.0 or 1000.0)
	
end

function GetVehicleProperties(vehicle)
    if DoesEntityExist(vehicle) then
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
        vehicleProps["tyres"] = {}
        vehicleProps["windows"] = {}
        vehicleProps["doors"] = {}

        for id = 1, 7 do
            local tyreId = IsVehicleTyreBurst(vehicle, id, false)
            if tyreId then
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = tyreId
        
                if tyreId == false then
                    tyreId = IsVehicleTyreBurst(vehicle, id, true)
                    vehicleProps["tyres"][ #vehicleProps["tyres"]] = tyreId
                end
            else
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = false
            end
        end
        --[[for id = 1, 3 do
            if id ~= 8 then
                local windowId = IsVehicleWindowIntact(vehicle, id)
            end
            print('-------')            
            print(windowId)
            if windowId ~= nil then
                vehicleProps['windows'][#vehicleProps['windows'] + 1] = windowId
            else
                vehicleProps["windows"][#vehicleProps["windows"] + 1] = true 
            end
        end--]]
        
        for id = 0, 5 do
            local doorId = IsVehicleDoorDamaged(vehicle, id)
            if doorId then
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = doorId
            else
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = false
            end
        end
		vehicleProps["vehicleHeadLight"]  = GetVehicleHeadlightsColour(vehicle)
        vehicleProps["bodyHealth"] = GetVehicleBodyHealth(vehicle)
        vehicleProps["engineHealth"] = GetVehicleEngineHealth(vehicle)
        return vehicleProps
	else
		return nil
    end
end

function SpawnVehicle(vehicleProps, garage, engine, body, fuel)
    vehicleProps.engineHealth = engine
    vehicleProps.bodyHealth = body
    vehicleProps.fuelLevel = fuel
    ESX.Game.SpawnVehicle(vehicleProps.model, {
		x = Config.Garage[garage].SpawnPoint.x,	
		y = Config.Garage[garage].SpawnPoint.y,	
		z = Config.Garage[garage].SpawnPoint.z										
        },200.0, function(callback_vehicle)
            SetVehicleProperties(callback_vehicle, vehicleProps)
            SetVehRadioStation(callback_vehicle, "OFF")
			TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
			local carplate = GetVehicleNumberPlateText(callback_vehicle)
            table.insert(carInstance, {vehicleentity = callback_vehicle, plate = carplate})
		end)
	TriggerServerEvent('panama_garaza:modifystate', vehicleProps.plate, false, 'pauk')
end

RegisterNUICallback('takeVehicleOut', function(data)
    local doesVehicleExist = false
    if data.garage ~= 'pauk' then
        for k,v in pairs (carInstance) do
            if ESX.Math.Trim(v.plate) == ESX.Math.Trim(data.plate) then
                if DoesEntityExist(v.vehicleentity) then
                    doesVehicleExist = true
                else
                    table.remove(carInstance, k)
                    doesVehicleExist = false
                end
            end
        end 
        
        if data.stored then
            SpawnVehicle(data.props, data.garage, data.engineHP, data.body, data.fuel)
            vehiclesInGarage[data.plate].stored = false
            vehiclesInGarage[data.plate].garage = 'pauk'
        end
    end
    if data.garage == 'pauk' then
        ESX.TriggerServerCallback('panama_garaza:checkMoney', function(hasEnoughMoney)
            if hasEnoughMoney then
                for k,v in pairs (carInstance) do
                    if ESX.Math.Trim(v.plate) == ESX.Math.Trim(data.plate) then
                        if DoesEntityExist(v.vehicleentity) then
                            doesVehicleExist = true
                        else
                            table.remove(carInstance, k)
                            doesVehicleExist = false
                        end
                    end
                end 
                
                if data.stored then
                    SpawnVehicle(data.props, data.garage, data.engineHP, data.body, data.fuel)
                    vehiclesInGarage[data.plate].stored = false
                    vehiclesInGarage[data.plate].garage = 'pauk'
                end
            end
        end)
    end
end)

function returnVehicle(garage)
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if GetPedInVehicleSeat(vehicle, -1) == playerPed then
            local vehProps = GetVehicleProperties(vehicle)
            if vehProps ~= nil then
                ESX.TriggerServerCallback('panama_garaza:changeVehicleProps', function(valid)
                    if valid then
                        for k,v in pairs(carInstance) do
                            if ESX.Math.Trim(v.plate) == ESX.Math.Trim(vehProps.plate) then
                                    table.remove(carInstance, k)
                            end
                        end
                            DeleteEntity(vehicle)
                            if not isTableEmpty(vehiclesInGarage) then
                                vehiclesInGarage[vehProps.plate].stored = true
                                vehiclesInGarage[vehProps.plate].garage = garage
                                vehiclesInGarage[vehProps.plate].carProps = vehProps
                                vehiclesInGarage[vehProps.plate].body = vehProps.bodyHealth
                                vehiclesInGarage[vehProps.plate].fuel = vehProps.fuelLevel
                                vehiclesInGarage[vehProps.plate].engineHP = vehProps.engineHealth
                            end
                            TriggerServerEvent('panama_garaza:modifystate', vehProps.plate, true, garage)
                    end
                end, vehProps, garage)
            else
                print('vehprops is nil')
            end
        else
            print('no driving')
        end
    else
        print('no car')
    end
end
