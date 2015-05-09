local STR = TunerElement_CreateStruct("underneon")
STR.PrintName = "Under Neon"
STR.Icon = "asterisk_yellow"
STR.Max = 1

local Scale = STR:AddVars("Scale","number")
Scale.Min = 0 Scale.Max = 500

STR:AddVars("Color","color")

function STR:CL_Think(TuneSysEnt,Vars)
	local EntAngle = TuneSysEnt:GetAngles()
	local Pos1 = TuneSysEnt:GetPos()
	
	local dlight = DynamicLight( TuneSysEnt:EntIndex() )
	if ( dlight ) then
		dlight.Pos = Pos1
		dlight.r = Vars["Color"].r
		dlight.g = Vars["Color"].g
		dlight.b = Vars["Color"].b
		dlight.Brightness = 1
		dlight.Size = Vars["Scale"]
		dlight.Decay = Vars["Scale"]*5
		dlight.DieTime = CurTime() + 0.3
		
	end
end

TunerElement_Register(STR)