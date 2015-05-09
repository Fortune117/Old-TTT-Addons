local STR = TunerElement_CreateStruct("ledstrip")
STR.PrintName = "LED Strip"
STR.Icon = "rainbow"
STR.Max = 2

STR:Editor_AddSpacer("Position")

local VAR = STR:AddVars("Pos_x","number")
VAR.Min = -100 VAR.Max = 100 

local VAR = STR:AddVars("Pos_y","number")
VAR.Min = -100 VAR.Max = 100 

local VAR = STR:AddVars("Pos_z","number")
VAR.Min = -100 VAR.Max = 100 VAR.StartValue = 10

STR:Editor_AddSpacer("Angle")

local VAR = STR:AddVars("Angle_P","number")
VAR.Min = 0 VAR.Max = 360 

local VAR = STR:AddVars("Angle_Y","number")
VAR.Min = 0 VAR.Max = 360 

STR:Editor_AddSpacer("Etc")

local VAR = STR:AddVars("Width","number")
VAR.Min = 1 VAR.Max = 500 VAR.StartValue = 250

local VAR = STR:AddVars("Thick","number")
VAR.Min = 1 VAR.Max = 20 VAR.StartValue = 5

STR:Editor_AddSpacer("Color")

STR:AddVars("Color","color")


local MAT_BEAM = Material("sprites/physgbeamb")
	function STR:Render(TuneSysEnt,Vars)
		render.SetMaterial( MAT_BEAM )
		
		local EntAngle = TuneSysEnt:GetAngles()
		
		local Pos1 = TuneSysEnt:GetPos()
		Pos1 = Pos1 + EntAngle:Forward() * Vars["Pos_x"]
		Pos1 = Pos1 + EntAngle:Right() * Vars["Pos_y"]
		Pos1 = Pos1 + EntAngle:Up() * Vars["Pos_z"]
		
		local AngleK = Angle(Vars["Angle_P"],Vars["Angle_Y"],0)
		
		AngleK = AngleK + TuneSysEnt:GetAngles()
		local Pos2 = Pos1 + AngleK:Forward() * Vars["Width"]
		
		render.DrawBeam( Pos1,Pos2, Vars["Thick"], 1, 1, Vars["Color"] ) 
	end

TunerElement_Register(STR)