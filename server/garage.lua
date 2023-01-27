ESX.RegisterServerCallback('panama_garaza:getVehicles', function(source, cb)
    print('uzima iz baze')
	local _source = source
	local identifier = ""
    identifier = ESX.GetPlayerFromId(_source).identifier
    if identifier ~= "" then
	    MySQL.Async.fetchAll("SELECT vehicle, `stored`, garage, description FROM owned_vehicles WHERE owner = @identifier", {
	    	['@identifier'] = identifier,
	    }, function(result)
            cb(result)
        end)
    else
        print('[Panama_Garaza] >> Za igraca ' .. _source .. 'nije nadjen identifier!')
    end
end)

ESX.RegisterServerCallback('panama_garaza:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	print(xPlayer.getMoney())
	if xPlayer.getMoney() >= Config.PaukPayPrice then
		cb(true)
	else
		cb(false)
	end
end)

AddEventHandler('onMySQLReady', function()
	MySQL.Async.execute("UPDATE owned_vehicles SET `stored`=true WHERE `stored`=false", {})
end)

ESX.RegisterServerCallback('panama_garaza:changeVehicleProps', function(source, cb , vehicleProps,  garage_name)
	local identifier = ""
	local _source = source
	identifier = ESX.GetPlayerFromId(_source).identifier
	local vehplate = vehicleProps.plate
	local vehiclemodel = vehicleProps.model
    MySQL.Async.fetchAll("SELECT vehicle FROM owned_vehicles where plate=@plate and owner=@identifier",
    {
        ['@plate'] = vehplate, 
        ['@identifier'] = identifier, 
    }, function(result)
		if result[1] ~= nil then
			local vehprop = json.encode(vehicleProps)
			local originalvehprops = json.decode(result[1].vehicle)
			if originalvehprops.model == vehiclemodel then
				MySQL.Async.execute("UPDATE owned_vehicles SET vehicle=@vehprop WHERE plate=@plate",{
					['@vehprop'] = vehprop,
					['@plate'] = vehplate
				}, function(rowsChanged)
					cb(true)
				end)
			else
				print("[panama_garaza] player "..identifier..' tried to spawn a vehicle with hash:'..vehiclemodel..". his original vehicle: "..originalvehprops.model)
				cb(false)
			end
		else
			cb(false)
		end
	end)
end)

RegisterServerEvent('panama_garaza:modifystate')
AddEventHandler('panama_garaza:modifystate', function(plate, stored, garage)
	MySQL.Async.execute("UPDATE owned_vehicles SET `stored`=@stored, garage=@garage WHERE plate=@plate",{
		['@stored'] = stored,
		['@plate'] = plate,
		['@garage'] = garage
	})
end)	

