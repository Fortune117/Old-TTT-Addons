function RXCar_Util_GetVehicleData(VehicleName)
	return list.Get('Vehicles')[VehicleName] or list.Get('SCarsList')[VehicleName]
end

function RXCar_Util_GetCarData(VehicleName)
	for k,v in pairs(D3DCarConfig.Car) do
		if v.VehicleName == VehicleName then
			return v
		end
	end
end

