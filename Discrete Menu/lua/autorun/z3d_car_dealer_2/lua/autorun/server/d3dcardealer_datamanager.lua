local function ConvertTXTIntoMySQL()
	MsgN("\n")
			
	local db = RXCar_Provider_GetSQL()
			
	local Files , Dirs = file.Find( "rm_car_dealer2/inventory/*", "DATA" )
	local FilesAmount = #Files
	MsgN("Time to finish : " .. math.Round((FilesAmount*0.3)/60,1) .. " Minutes")
	
	MsgN("Found " .. FilesAmount .. " Data")
	for k,v in pairs(Files) do
		timer.Simple(0.3*k,function()
			local Data = file.Read( "rm_car_dealer2/inventory/" .. v )
			
			local SteamIDG = string.gsub(v,"_",":")
			SteamIDG = string.gsub(SteamIDG,".txt","")
			
			local QUERY = "INSERT INTO "
			QUERY = QUERY .. "cardealer_inventory "
			QUERY = QUERY .. "(`ID`,`JSONData`) "
			QUERY = QUERY .. "VALUES ('"..SteamIDG.."' ,'"..Data.."')"
			local q = db:query( QUERY ) -- 데이터 삽입
			function q:onSuccess(data)
				MsgN("[" .. k .. "/" .. FilesAmount .. "] Success ")
			end
			function q:onError(err, sql)
				MsgN('3D Car dealer 2 : There is error on MySQL Module')
				MsgN(err)
			end
			q:start()
			
		end)
	end
	
	return #Files*0.3
end

concommand.Add("cardealer_convertdatatxt2mysql",function(ply)
	
	if !D3DCarConfig:IsAdmin(ply) then
		ply:ChatPrint("You are not admin!")
		return
	end
	
	MsgN("========== 3D Car dealer 2 ===========")
	MsgN("Transfering data into MySQL")
	MsgN("Please DONT DO ANYTHING AND WAIT UNTIL ITS FINISHED!!")
	
	ConvertTXTIntoMySQL()
end)