hook.Add("Initialize", "3DCarDealer Dir Check", function()
	file.CreateDir("rm_car_dealer2")
	file.CreateDir("rm_car_dealer2/inventory")
	file.CreateDir("rm_car_dealer2/crashsaver")
	file.CreateDir("rm_car_dealer2/mapsave")
end)

concommand.Add("D3DCarDealer_Save",function(ply,cmd,args)

	local UG = ply:GetNWString("usergroup")
	UG = string.lower(UG)
	ply:RXCarNotify("3D Car dealer :: Saving start..")
	if !D3DCarConfig:IsAdmin(ply) then 
		ply:RXCarNotify("3D Car dealer :: Warning. you can't save car dealer. you are not admin.")
		return 
	end
		
		MsgN("3DCarDealer - Saving all")
		local TB2Save = {}
		for k,v in pairs(ents.FindByClass("rm_car_dealer")) do
			local TB2Insert = {}
			TB2Insert.Pos = v:GetPos()
			TB2Insert.Angle = v:GetAngles()
			table.insert(TB2Save,TB2Insert)
		end
		
		local Map = string.lower(game.GetMap())
		file.Write("rm_car_dealer2/mapsave/" .. Map .. ".txt", util.TableToJSON(TB2Save))
		
		ply:RXCarNotify("3D Car dealer :: Car dealers are saved.")
		D3DCar_Meta:Notify( ply,"Car dealer has been saved")
end)
	
	hook.Add( "InitPostEntity", "3DCarDealer Entity Post", function()
	local Map = string.lower(game.GetMap())
		local Data = {}
		if file.Exists( "rm_car_dealer2/mapsave/" .. Map .. ".txt" ,"DATA") then
			Data = util.JSONToTable(file.Read( "rm_car_dealer2/mapsave/" .. Map .. ".txt" ))
		end
		MsgN("3DCarDealer - Spawning all")
		for k,v in pairs(Data) do
			local ATM = ents.Create("rm_car_dealer")
			ATM:SetPos(v.Pos)
			ATM:SetAngles(v.Angle)
			ATM:Spawn()
		end
		MsgN("3DCarDealer - Spawning Complete. [ " .. #Data .. " ] ")
	end )