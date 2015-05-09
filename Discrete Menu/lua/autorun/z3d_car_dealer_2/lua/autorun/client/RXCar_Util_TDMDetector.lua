concommand.Add("RXCar_GenerateTDMCodes",function(ply)
	local MsgReturn = "\n"
	
	for k,v in pairs(list.Get('Vehicles') or {}) do
		if string.find(k,"tdm") then
			MsgReturn = MsgReturn .. "	local TB2Insert = {} \n"
			MsgReturn = MsgReturn .. "		TB2Insert.VehicleName = '" .. k .. "' \n"
			MsgReturn = MsgReturn .. "		TB2Insert.CarName = '" .. v.Name .. "' \n"
			MsgReturn = MsgReturn .. "		TB2Insert.CarPrice = 10000 \n"
			MsgReturn = MsgReturn .. "		TB2Insert.CarRefund = 10000 \n"
			MsgReturn = MsgReturn .. "		TB2Insert.Description = '" .. v.Information .. "' \n"
			MsgReturn = MsgReturn .. "	table.insert(D3DCarConfig.Car,TB2Insert) \n\n"
		end
	end
	
	MsgN(MsgReturn)
	SetClipboardText(MsgReturn)
	
	MsgN("Car codes are copied on your clipboard. goto addcars.lua and paste these")
end)