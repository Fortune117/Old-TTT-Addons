local function CheckMapSaved()
	MsgN("\n")
	MsgN("STEP 1 : Map Data")
	
	local Files , Dirs = file.Find( "rm_car_dealer/mapsave/*", "DATA" )
	MsgN("Found " .. #Files .. " Maps")
	for k,v in pairs(Files) do
		timer.Simple(0.1*k,function()
			local Data = file.Read( "rm_car_dealer/mapsave/" .. v )
			file.Write("rm_car_dealer2/mapsave/" .. v, Data)
			MsgN("[" .. k .. "/" .. #Files .."]  Transfer - " .. v)
		end)
	end
		
	return #Files*0.1
end

local function CheckCrashSaver()
	MsgN("\n")
	MsgN("STEP 2 : Crash Saver")
			
	local Files , Dirs = file.Find( "rm_car_dealer/crashsaver/*", "DATA" )
	local FilesAmount = #Files
	MsgN("Time to finish : " .. math.Round((FilesAmount*0.2)/60,1) .. " Minutes")
	
	MsgN("Found " .. FilesAmount .. " Data")
	for k,v in pairs(Files) do
		timer.Simple(0.2*k,function()
			local Data = file.Read( "rm_car_dealer/crashsaver/" .. v )
			Data = util.JSONToTable(Data)
			
			for k,v in pairs(Data) do
				v.TuneData = {} -- No longer supported by CD 2
			end
			
			Data = util.TableToJSON(Data)
			
			file.Write("rm_car_dealer2/crashsaver/" .. v, Data)
			MsgN("[" .. k .. "/" .. FilesAmount .."]  Transfer - " .. v)
		end)
	end
	
	return #Files*0.2
end

local function CheckInventory()
	MsgN("\n")
	MsgN("STEP 3 : Inventory")
			
	local Files , Dirs = file.Find( "rm_car_dealer/inventory/*", "DATA" )
	local FilesAmount = #Files
	MsgN("Time to finish : " .. math.Round((FilesAmount*0.3)/60,1) .. " Minutes")
	
	MsgN("Found " .. FilesAmount .. " Data")
	for k,v in pairs(Files) do
		timer.Simple(0.3*k,function()
			local Data = file.Read( "rm_car_dealer/inventory/" .. v )
			Data = util.JSONToTable(Data)
			
			for k,v in pairs(Data) do
				v.TuneData = {} -- No longer supported by CD 2
			end
			
			Data = util.TableToJSON(Data)
			
			file.Write("rm_car_dealer2/inventory/" .. v, Data)
			MsgN("[" .. k .. "/" .. FilesAmount .."]  Transfer - " .. v)
		end)
	end
	
	return #Files*0.3
end

concommand.Add("cardealer_convert1to2",function(ply)
	if D3DCardealer_DataConverter then 
		ply:ChatPrint("Converter is already working")
		return 
	end
	
	if !D3DCarConfig:IsAdmin(ply) then
		ply:ChatPrint("You are not admin!")
		return
	end
	D3DCardealer_DataConverter = true
	
	MsgN("========== 3D Car dealer 2 ===========")
	MsgN("Converting Data for version 2")
	MsgN("Please DONT DO ANYTHING AND WAIT UNTIL ITS FINISHED!!")
	
	timer.Simple(1,function()
		local Time = CheckMapSaved()
		timer.Simple(Time + 1,function()
			local Time = CheckCrashSaver()
			timer.Simple(Time + 1,function()
				local Time = CheckInventory()
			end)
		end)
	end)
end)