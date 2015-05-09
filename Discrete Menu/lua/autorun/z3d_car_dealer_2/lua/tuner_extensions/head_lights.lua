local STR = TunerElement_CreateStruct("head_light")
STR.PrintName = "Head Light"
STR.Icon = "transmit"
STR.Max = 2

local KEY = STR:AddVars("Key","optionselect")
KEY:AddOption(IN_ATTACK,{PrintName = "Left Mouse"})
KEY:AddOption(IN_ATTACK2,{PrintName = "Right Mouse"})
KEY:AddOption(IN_RELOAD,{PrintName = "R"})
KEY:AddOption(IN_JUMP,{PrintName = "Space"})
KEY:AddOption(IN_DUCK,{PrintName = "Ctrl"})
KEY:AddOption(IN_WALK,{PrintName = "Alt"})
KEY:AddOption(IN_ZOOM,{PrintName = "ZOOM"})

local VAR = STR:AddVars("Pos_x","number")
VAR.Min = -300 VAR.Max = 300 

local VAR = STR:AddVars("Pos_y","number")
VAR.Min = -300 VAR.Max = 300 

local VAR = STR:AddVars("Pos_z","number")
VAR.Min = -300 VAR.Max = 300 VAR.StartValue = 10


local VAR = STR:AddVars("Angle_p","number")
VAR.Min = 0 VAR.Max = 360 

local VAR = STR:AddVars("Angle_y","number")
VAR.Min = 0 VAR.Max = 360 


local MAT_LIGHT = Material("sprites/gmdm_pickups/light")
local MAT_BEAM = Material("sprites/physgbeamb")

	function STR:SV_KeyPressed(TuneSysEnt,Vars,Key,UniqueID) -- FormatData.UniqueID
		local PlyKey = Vars["Key"]
		if PlyKey and Key == PlyKey then
		
			TuneSysEnt.ToggleLight = TuneSysEnt.ToggleLight or false
			
			if (TuneSysEnt.RearLightSwitchDelay or 0) < SysTime() then
				TuneSysEnt.RearLightSwitchDelay = SysTime() + 0.1
				if TuneSysEnt.ToggleLight then TuneSysEnt.ToggleLight = false else TuneSysEnt.ToggleLight = true end
			end
			
			TuneSysEnt:SetDTBool(0,TuneSysEnt.ToggleLight)
			
			TuneSysEnt.Lights = TuneSysEnt.Lights or {}
			
			if !TuneSysEnt.ToggleLight then
				for k,v in pairs(TuneSysEnt.Lights) do
					v:Remove()
				end
				TuneSysEnt.Lights = {}
			else
				local EntAngle = TuneSysEnt:GetAngles()
				
				local Pos1 = TuneSysEnt:GetPos()
				Pos1 = Pos1 + EntAngle:Forward() * Vars["Pos_x"]
				Pos1 = Pos1 + EntAngle:Right() * Vars["Pos_y"]
				Pos1 = Pos1 + EntAngle:Up() * Vars["Pos_z"]	
				
				
				local ColorK = Color(255,255,255,255)
				local Brightness = 1
				
				local FlashLight = ents.Create( "env_projectedtexture" )
				FlashLight:SetParent(TuneSysEnt)
				FlashLight:SetPos(Pos1)
				FlashLight:SetAngles(EntAngle + Angle(Vars["Angle_p"],Vars["Angle_y"],0))
				FlashLight:SetKeyValue("enableshadows",1)
				FlashLight:SetKeyValue("nearz",5)
				FlashLight:SetKeyValue("farz",3000)
				FlashLight:SetKeyValue("lightfov",60)
				FlashLight:SetKeyValue("lightcolor",Format( "%i %i %i 255", ColorK.r, ColorK.g, ColorK.b ) )
				FlashLight:Spawn()
				
				table.insert(TuneSysEnt.Lights,FlashLight)
			end
		end
	end
	
	function STR:Render(TuneSysEnt,Vars,ForceRender)
		if !ForceRender and !TuneSysEnt:GetDTBool(0) then return end
		
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
			150,150,              --size of the rect
			Color(255,255,255,255),  --color
		90                     --rotate 90 degrees
		) 
		
	end
	
	function STR:RenderOnEditor(TuneSysEnt,Vars)
		self:Render(TuneSysEnt,Vars,true)
		render.SetMaterial( MAT_BEAM )
		
		local EntAngle = TuneSysEnt:GetAngles()
		
		local Pos1 = TuneSysEnt:GetPos()
		Pos1 = Pos1 + EntAngle:Forward() * Vars["Pos_x"]
		Pos1 = Pos1 + EntAngle:Right() * Vars["Pos_y"]
		Pos1 = Pos1 + EntAngle:Up() * Vars["Pos_z"]
		
		local AngleK = Angle(Vars["Angle_p"],Vars["Angle_y"],0)
		
		AngleK = AngleK + TuneSysEnt:GetAngles()
		local Pos2 = Pos1 + AngleK:Forward() * 50
		
		render.DrawBeam( Pos1,Pos2, 1, 1, 1, Color(255,255,255,255) ) 
		render.DrawBeam( Pos2,Pos2 + AngleK:Right()*5 - AngleK:Forward()*5, 1, 1, 1, Color(255,255,255,255) ) 
		render.DrawBeam( Pos2,Pos2 - AngleK:Right()*5 - AngleK:Forward()*5, 1, 1, 1, Color(255,255,255,255) ) 
	end
	
	

TunerElement_Register(STR)