function RXCar_Provider_GetInventory(PlySID,CallBack)
	PlySID = string.gsub(PlySID,":","_")
		
	local Data = {}
	if file.Exists( "rm_car_dealer2/inventory/" .. PlySID .. ".txt" ,"DATA") then
		Data = util.JSONToTable(file.Read( "rm_car_dealer2/inventory/" .. PlySID .. ".txt" ))
	end
	
	CallBack(Data)
end

function RXCar_Provider_SaveInventory(PlySID,InventoryData,CallBack)
	PlySID = string.gsub(PlySID,":","_")
		
	local Data = InventoryData or {}
	file.Write("rm_car_dealer2/inventory/" .. PlySID .. ".txt", util.TableToJSON(Data))
	CallBack(Data)
end

