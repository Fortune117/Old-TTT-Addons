hook.Add("PhysgunPickup", "RXCar Allow Vehicle Pickup", function(ply, ent)
	if ent and ent:IsValid() and ent.RX3DCar then
	
		if D3DCarConfig.PlayerCanPickupVehicles then
			if ent.OwnerID == ply:SteamID() then
				return true
			end
		end
		
		if D3DCarConfig:IsAdmin(ply) then
			return true
		end
	end
end)


hook.Add("OnPlayerChangedTeam","3DCAR PlayerChangeJob",function(ply,PrevTeam,NewTeam)
	if D3DCarConfig.Check_Remove_JobOnlyCars then
	
		for k,v in pairs(RXCar_GetPlayer3DCars(ply)) do
			if v.CData.AvaliableTeam then
				if !table.HasValue(v.CData.AvaliableTeam,ply:Team()) then
					ply:RXCar_SaveCarIntoInventory(v)
					D3DCar_Meta:Notify(ply,"Your " .. v.CData.CarName .. " was removed and saved to your inventory because of job limitation")
				end
			end
		end
	end
end)