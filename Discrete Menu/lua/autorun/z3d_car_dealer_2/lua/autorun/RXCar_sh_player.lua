local meta = FindMetaTable("Player")

function meta:RXCar_PlayerCanBuyCar(CarVehicleName)
	local CarData = RXCar_Util_GetCarData(CarVehicleName)
	local CarVehicleData = RXCar_Util_GetVehicleData(CarVehicleName)
	
	if !CarData then 
		return false,"Error 1"
	end
	
	if !CarVehicleData then
		return false,"Error 2"
	end
	
	if D3DCar_Meta:GetMoney(self) < CarData.CarPrice then
		return false,"Not Enough Money"
	end
	
	for k,v in pairs(CarData.AvailableTeam or {}) do
		if !table.HasValue(CarData.AvailableTeam,self:Team()) then
			return false,"Job Limitation"
		end
	end
	
	for k,v in pairs(CarData.AvaliableGroup or {}) do
		if !table.HasValue(CarData.AvaliableGroup,string.lower(self:GetNWString("usergroup"))) then
			return false,"ULX Rank Limitation"
		end
	end
	
	
	
	
	return true
end

function meta:RXCar_PlayerCanSpawnCar(CarVehicleName,InvUID)
	local CarData = RXCar_Util_GetCarData(CarVehicleName)
	local CarVehicleData = RXCar_Util_GetVehicleData(CarVehicleName)
	
	if !CarData then 
		return false,"Error 1"
	end
	
	if !CarVehicleData then
		return false,"Error 2"
	end
	
	for k,v in pairs(CarData.AvailableTeam or {}) do
		if !table.HasValue(CarData.AvailableTeam,self:Team()) then
			return false,"Job Limitation"
		end
	end
	
	for k,v in pairs(CarData.AvaliableGroup or {}) do
		if !table.HasValue(CarData.AvaliableGroup,string.lower(self:GetNWString("usergroup"))) then
			return false,"ULX Rank Limitation"
		end
	end
	
	
	return true
end