local STR = TunerElement_CreateStruct("horn")
STR.PrintName = "Horn"
STR.Icon = "music"
STR.Max = 1

local KEY = STR:AddVars("Key","optionselect")
KEY:AddOption(IN_ATTACK,{PrintName = "Left Mouse"})
KEY:AddOption(IN_ATTACK2,{PrintName = "Right Mouse"})
KEY:AddOption(IN_RELOAD,{PrintName = "R"})
KEY:AddOption(IN_JUMP,{PrintName = "Space"})
KEY:AddOption(IN_DUCK,{PrintName = "Ctrl"})
KEY:AddOption(IN_WALK,{PrintName = "Alt"})
KEY:AddOption(IN_ZOOM,{PrintName = "ZOOM"})

local Sounds = STR:AddVars("Sounds","optionselect")
Sounds:AddOption("ambient/alarms/train_horn2.wav",{PrintName = "Train Horn",PlayTime=10})
Sounds:AddOption("ambient/alarms/razortrain_horn1.wav",{PrintName = "Razor Train Horn",PlayTime=6})
Sounds:AddOption("Resource/warning.wav",{PrintName = "Warning Horn",PlayTime=0.2})


	function STR:SV_KeyPressed(TuneSysEnt,Vars,Key)
		local PlyKey = Vars["Key"]
		if PlyKey and Key == PlyKey then
			local HSound = Vars["Sounds"]
			if HSound then
				local PlayTime = self.Vars["Sounds"].Options[HSound].DataTable.PlayTime or 5
				if (TuneSysEnt.HornSoundDelay or 0) < CurTime() then
					TuneSysEnt.HornSoundDelay = CurTime() + PlayTime
					TuneSysEnt:EmitSound(HSound)
				end
			end
		end
	end


TunerElement_Register(STR)