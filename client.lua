
Citizen.CreateThread(function()
	while true do
		inRange = false

		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		for k, v in pairs(Config.StashCoords) do
			if #(coords - Config.StashCoords[k].coords) < 3.0 then
				inRange = true
				DrawText3D(Config.StashCoords[k].coords.x,Config.StashCoords[k].coords.y,Config.StashCoords[k].coords.z, "[E] Stash")
				if IsControlJustPressed(0, 38) and #Config.StashCoords[k].job == 0 then
					TriggerEvent("inventory:client:SetCurrentStash", Config.StashCoords[k].name)
					TriggerServerEvent("inventory:server:OpenInventory", "stash", Config.StashCoords[k].name, {
						maxweight = 4000000,
						slots = 500,
					})
				elseif IsControlJustPressed(0, 38) and #Config.StashCoords[k].job ~= 0 then
					if isAuthorized(QBCore.Functions.GetPlayerData().job.name, k) then
						TriggerEvent("inventory:client:SetCurrentStash", Config.StashCoords[k].name)
						TriggerServerEvent("inventory:server:OpenInventory", "stash", Config.StashCoords[k].name, {
							maxweight = 4000000,
							slots = 500,
						})
					else
						QBCore.Functions.Notify("Not authorized", "error")
					end
				end
			end
		end
		if not inRange then
			Citizen.Wait(3000)
		end
	end
end)

function isAuthorized(job, k)
	for a=1, #Config.StashCoords[k].job do
		
		if job == Config.StashCoords[k].job[a] then
			return true
		end
	end
	return false
end

---For bt-target

RegisterNetEvent("client:setStash")
AddEventHandler("client:setStash", function(params)
	TriggerEvent("inventory:client:SetCurrentStash", params.name)
	TriggerServerEvent("inventory:server:OpenInventory", "stash", params.name, {
		maxweight = 4000000,
		slots = 500,
	})
end)

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
