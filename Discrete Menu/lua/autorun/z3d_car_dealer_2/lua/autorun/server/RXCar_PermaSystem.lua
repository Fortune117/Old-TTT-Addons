if SERVER then
	RX3DCar_Cars = RX3DCar_Cars or {}
	function RX3DCar_AddCar(ent)
		RX3DCar_Cars[ent] = ent
	end
	function RX3DCar_RemoveCar(ent)
		RX3DCar_Cars[ent] = nil
	end
	
	function RXCar_Get3DCars()
		local TB2Return = {}
		for k,v in pairs(RX3DCar_Cars) do
			if v and v:IsValid() then
				table.insert(TB2Return,v)
			end
		end
		return TB2Return
	end
	
	function RXCar_GetPlayer3DCars(ply)
		local MyCars = {}
		for k,v in pairs(RXCar_Get3DCars()) do
			if v.OwnerID == ply:SteamID() then
				table.insert(MyCars,v)
			end
		end
		return MyCars
	end

	hook.Add( "PlayerDisconnected", "1 RX3DCar Save", function(ply)
		for k,v in pairs(RXCar_Get3DCars()) do
			if v.OwnerID == ply:SteamID() then
				ply:RXCar_SaveCarIntoInventory(v)
			end
		end
	end)
	
	hook.Add( "EntityRemoved", "1 RXCar Save", function(ent)
		if ent.RX3DCar then
			if ent.RXCar_IgnoreRemoveHook then
				return true
			end
			if ent.IgnoreRemoveHookTime then
				if CurTime() < ent.IgnoreRemoveHookTime then
					return true
				end
			end
			if ent.Owner and ent.Owner:IsValid() then
				ent.Owner:RXCar_SaveCarIntoInventory(ent,true)
			end
		end
	end)
	
end
