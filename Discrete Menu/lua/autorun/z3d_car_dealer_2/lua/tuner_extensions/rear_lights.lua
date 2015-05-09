local STR = TunerElement_CreateStruct("rear_light")
STR.PrintName = "Rear Light"
STR.Icon = "asterisk_orange"
STR.Max = 4

local VAR = STR:AddVars("Pos_x","number")
VAR.Min = -300 VAR.Max = 300 

local VAR = STR:AddVars("Pos_y","number")
VAR.Min = -300 VAR.Max = 300 

local VAR = STR:AddVars("Pos_z","number")
VAR.Min = -300 VAR.Max = 300 VAR.StartValue = 10


local Scale = STR:AddVars("Scale","number")
Scale.Min = 0 Scale.Max = 150


local MAT_LIGHT = Material("sprites/gmdm_pickups/light")

	function STR:SV_Think(TuneSysEnt,Vars)
		local Driver = TuneSysEnt:GetDriver()
		if Driver and ( Driver:KeyDown(IN_JUMP) or Driver:KeyDown(IN_BACK)) then
			TuneSysEnt:SetDTBool(1,true)
		else
			TuneSysEnt:SetDTBool(1,false)
		end
	end

	function STR:Render(TuneSysEnt,Vars)
		
		local Multi = 1
		if TuneSysEnt:GetDTBool(1) then
			Multi = 1.5
		end
		
		local EntAngle = TuneSysEnt:GetAngles()
		
		local Pos1 = TuneSysEnt:GetPos()
		Pos1 = Pos1 + EntAngle:Forward() * Vars["Pos_x"]
		Pos1 = Pos1 + EntAngle:Right() * Vars["Pos_y"]
		Pos1 = Pos1 + EntAngle:Up() * Vars["Pos_z"]	
		
		render.SetMaterial( MAT_LIGHT )
		
		local AngleK = EyeAngles():Forward() * -1
		
		local DAngle = D3DCarDealer_Get3DWorldCamAngle()
		if DAngle then AngleK = DAngle:Forward() end
		
		render.DrawQuadEasy( Pos1,    --position of the rect
			AngleK,        --direction to face in
			Vars["Scale"]*Multi,Vars["Scale"]*Multi,              --size of the rect
			Color(255,0,0,255),  --color
		90                     --rotate 90 degrees
		) 
		
	end

TunerElement_Register(STR)