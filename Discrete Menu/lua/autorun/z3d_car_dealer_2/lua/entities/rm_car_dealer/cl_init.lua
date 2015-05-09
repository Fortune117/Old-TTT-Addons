include('shared.lua')


hook.Add("PostDrawOpaqueRenderables", "RM CarDealer Head", function()
	for _, ent in pairs (ents.FindByClass("rm_car_dealer")) do
		if ent:GetPos():Distance(LocalPlayer():GetPos()) < 1000 then
			local Ang = ent:GetAngles()

			Ang:RotateAroundAxis( Ang:Forward(), 90)
			Ang:RotateAroundAxis( Ang:Right(), -90)
		
			cam.Start3D2D(ent:GetPos()+ent:GetUp()*80, Ang, 0.35)
				draw.SimpleTextOutlined( 'Car Dealer', "RXCarFont_Treb_S50", 0, 0, Color( 0, 150, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))			
			cam.End3D2D()
		end
	end
end)

function GetRoofPos(Ent)
	local pos = Ent:GetPos()
	
	local tracedata = {}
	tracedata.start = pos + Vector(0,0,120)
	tracedata.endpos = pos + Vector(0,0,400)
	local trace = util.TraceLine(tracedata)
	
	if trace.HitWorld then
		local Pos = Ent:GetPos()
		Pos.z = trace.HitPos.z
		return Pos
	else
		return Ent:GetPos() + Vector(0,0,400)
	end
end