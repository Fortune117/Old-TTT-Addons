local meta = FindMetaTable("Player")

if CLIENT then
	function RXCar_Switch2CarSpawner(INVUID,CarModel,SellerNPC)
		if D3DCarConfig.SpawnMode == 1 then
			RXCar_EnableThirdPerson(true,SellerNPC)
			RXCar_CarSpawnMode(SellerNPC,CarModel,INVUID)
		else
			RXCar_DoSpawnCar(nil,nil,INVUID)
		end
		
	end
	function RXCar_Switch2CarStorer(SellerNPC)
		RXCar_EnableThirdPerson(true,SellerNPC)
		RXCar_CarStoreMode(SellerNPC)
	end
	
	function RXCar_MousePos()
		local tracedata = {}
		tracedata.start = LocalPlayer().RXCarThirdPos
		tracedata.endpos = LocalPlayer().RXCarThirdPos + gui.ScreenToVector( gui.MousePos() )*20000
		local trace = util.TraceLine(tracedata)
		return trace
	end
end

if SERVER then -- Third Person C2S
	util.AddNetworkString( "RXCar_ThirdPerson_C2S" )
	net.Receive( "RXCar_ThirdPerson_C2S", function( len,ply )
		local TB = net.ReadTable()
		
		local DealerEnt = TB.DealerEnt
		local Bool = TB.Bool
		
		if !Bool then
			ply:SetViewEntity(nil)
			ply:Freeze(false)
		end
		
		
		if !DealerEnt or !DealerEnt:IsValid() or DealerEnt:GetClass() != "rm_car_dealer" then return end
	
		if Bool then
			ply:SetViewEntity(DealerEnt)
			ply:Freeze(true)
		else
			ply:SetViewEntity(nil)
			ply:Freeze(false)
		end
	end)
else
	function RXCar_EnableThirdPerson(Bool,DealerEnt)
		net.Start( "RXCar_ThirdPerson_C2S" )
			net.WriteTable({Bool=Bool,DealerEnt=DealerEnt})
		net.SendToServer()
	end

end


function RXCar_PlayerMaxCarAmountCheck(ply)
	local MyCars = RXCar_GetPlayer3DCars(ply)
	
	if table.Count(MyCars) >= D3DCarConfig.PlayerMaxCarAmount then
		local Amount2Remove = D3DCarConfig.PlayerMaxCarAmount - table.Count(MyCars) + 1
		
		for i=1,Amount2Remove do
			ply:RXCar_SaveCarIntoInventory(table.Random(MyCars),false)
		end
		ply:RXCarNotify("You reached max car limit. your old " .. Amount2Remove .. " cars are removed and saved into your inventory.")
	end
end

if SERVER then -- DoSpawn C2S
	util.AddNetworkString( "RXCar_DoSpawn_C2S" )
	net.Receive( "RXCar_DoSpawn_C2S", function( len,ply )
		local TB = net.ReadTable()
		
		local SpawnPos = TB.Pos
		local SpawnAngle = TB.AngleK or Angle(0,0,0)
		local INVUID = TB.INVUID
		
		-- Spot Spawn Mode
		if D3DCarConfig.SpawnMode == 2 then
			local AvailableSpots = {}
			local function CheckAvailable(Pos)
				for k,v in pairs(ents.FindInSphere(Pos,D3DCarConfig.SpotDistanceCheck)) do
					if v:IsPlayer() and v != ply then
						return false
					end
					if v.RX3DCar then
						return false
					end
				end
				return true
			end
			local function CheckPosZ(Pos)
				local Cal = 1752
				local Cal2 = 1227
				return Cal1 + Cal2 - Pos.z
			end
		
			for k,v in pairs(D3DCarConfig.SpawnSpots or {}) do
				local IsOkay = CheckAvailable(v)
				if IsOkay then
					table.insert(AvailableSpots,v)
				end
			end
			
			if table.Count(AvailableSpots) > 0 then
				SpawnPos = table.Random(AvailableSpots)
			else
				ply:Send3DShopNotice("There are no spot available. please try spawn cars later.")
				return
			end
		end
		
		
		-- PlayerMaxCarAmount Check. --
		RXCar_PlayerMaxCarAmountCheck(ply)
		
		
		RXCar_Provider_GetInventory(ply:SteamID(),function(InventoryData)
			if !InventoryData[INVUID] then
				ply:Send3DShopNotice("There was an error. please try again later")
				return
			end
			
			local INVData = InventoryData[INVUID]
			
			local VehicleName = INVData.VehicleName
			local TuneData = INVData.TuneData
			local VehicleData = RXCar_Util_GetVehicleData(VehicleName)
			local CarData = RXCar_Util_GetCarData(VehicleName)
			
			local CanSpawn , Reason = ply:RXCar_PlayerCanSpawnCar(VehicleName)
			if !CanSpawn then
				ply:RXCarNotify("You are not allowed to spawn the car.")
				ply:RXCarNotify("Reason : " .. Reason)
				return
			end
			
			local CarEnt
			if !CarData.IsSCar then
				CarEnt = ents.Create(VehicleData.Class)
				CarEnt:SetModel(VehicleData.Model)
				for k, v in pairs (VehicleData.KeyValues) do
					CarEnt:SetKeyValue(k, v)
				end
			else
				CarEnt = ents.Create(VehicleData.ClassName)
				CarEnt:Activate()
				CarEnt.IsCar = true
			end
			
				CarEnt:SetPos(SpawnPos + Vector(0,0,50))
				CarEnt:SetAngles(SpawnAngle)
				CarEnt:SetSkin(TuneData.SkinNumber or 0)
				CarEnt:SetNWInt("OwnerSID",ply:SteamID())
				CarEnt:Spawn()
				
				CarEnt.Owner = ply
				CarEnt.OwnerID = ply:SteamID()
				CarEnt.SID = ply.SID
				CarEnt.RX3DCar = true
				CarEnt.SpawnTime = CurTime()
				CarEnt.TuneData = TuneData
				CarEnt.CData = CarData
				D3DCar_Meta:OwnCar(ply,CarEnt)
				
				for k,v in pairs(TuneData.BodyGroups or {}) do
					timer.Simple(0,function()
						CarEnt:SetBodygroup(k,v)
					end)
				end
				
				-- for Passenger Mod. Maybe
				CarEnt.VehicleName = VehicleName
				CarEnt.VehicleTable = VehicleData
				-- for Passenger Mod. Maybe
						
				local TuneSys = ents.Create("rm_car_tune_sys")
				TuneSys:SetPos(CarEnt:GetPos())
				TuneSys:SetAngles(CarEnt:GetAngles())
				TuneSys:Spawn()
				TuneSys:SetTuneData(TuneData)
				TuneSys.Mother = CarEnt
				TuneSys:SetParent(CarEnt)
				CarEnt.TuneSys = TuneSys
				
				D3DCarCrashSaver:AddCar(ply,CarEnt)
				RX3DCar_AddCar(CarEnt)
			
			if !CarData.IsSCar then
				if D3DCarConfig.DarkRPIs2_5_0 then
					hook.Call("PlayerSpawnedVehicle", GAMEMODE, ply, CarEnt)
					hook.Call("playerBoughtVehicle", GAMEMODE,CarEnt, CarEnt)
				else
					hook.Call("PlayerSpawnedVehicle", GAMEMODE, ply, CarEnt)
					hook.Call("playerBoughtVehicle", GAMEMODE, ply, Vehicle, CarEnt)
				end
			end
			
				InventoryData[INVUID] = nil
				RXCar_Provider_SaveInventory(ply:SteamID(),InventoryData,function(Done)
					ply:Send3DShopNotice("You spanwed car")
					ply:RXCar_SyncInv(InventoryData)
				end)
				
			
				if D3DCarConfig.EnterTheCarAfterSpawn then
					ply:EnterVehicle(CarEnt)
				else
					if D3DCarConfig.LockCarAfterSpawn then
						if CarEnt.KeysLock then 
							CarEnt:KeysLock()
						elseif CarEnt.keysLock then
							CarEnt:keysLock()
						end
					end
				end
		end)
		
	end)
else
	function RXCar_SpawnInventoryCar(Pos,AngleK,INVUID)
		net.Start( "RXCar_DoSpawn_C2S" )
			net.WriteTable({Pos=Pos,AngleK=AngleK,INVUID=INVUID})
		net.SendToServer()
	end

end

if SERVER then -- DoStore C2S
	util.AddNetworkString( "RXCar_DoStore_C2S" )
	net.Receive( "RXCar_DoStore_C2S", function( len,ply )
		local Ent = net.ReadEntity()
		
		if Ent and Ent:IsValid() and Ent.RX3DCar and Ent.OwnerID == ply:SteamID() then
			ply:RXCar_SaveCarIntoInventory(Ent)
			ply:Send3DShopNotice("Your car has been saved")
		end
	end)
else
	function RXCar_StoreCar(Ent)
		net.Start( "RXCar_DoStore_C2S" )
			net.WriteEntity(Ent)
		net.SendToServer()
	end

end

function RXCar_DoSpawnCar(Pos,Angle,INVUID)
	gui.EnableScreenClicker(false)
	hook.Remove("CalcView","RXCar ThirdView")
	hook.Remove("HUDPaint","RXCar Guide")
	hook.Remove("PostDrawOpaqueRenderables","RXCar Render")
	hook.Remove("GUIMousePressed","RXCar SpawnClick")
	RXCar_EnableThirdPerson(false)
	
	RXCar_SpawnInventoryCar(Pos,Angle,INVUID)
end

function RXCar_DoStoreCar(Ent)
	gui.EnableScreenClicker(false)
	hook.Remove("CalcView","RXCar ThirdView")
	hook.Remove("HUDPaint","RXCar Guide")
	hook.Remove("GUIMousePressed","RXCar SpawnClick")
	hook.Remove("PreDrawHalos", "RXCar Halo")
	RXCar_EnableThirdPerson(false)
	
	RXCar_StoreCar(Ent)
end


function RXCar_CarStoreMode(DealerEnt)
		local LP = LocalPlayer()
		local PosLock = DealerEnt:GetPos()
		LP.RXCarThirdPos = GetRoofPos(DealerEnt)
		
		
		gui.EnableScreenClicker(true)
		hook.Add("CalcView","RXCar ThirdView", function( ply, origin, angles, fov )
			return GAMEMODE:CalcView(ply, ply.RXCarThirdPos, Angle(90,0,0), fov)
		end)
			
		hook.Add("HUDPaint","RXCar Guide", function()
			draw.SimpleText("Left Click your car you want to store.", "RXCarFont_TrebLWOut_S45", ScrW()/2,ScrH()-100, Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText("Right Click to cancel", "RXCarFont_TrebLWOut_S30", ScrW()/2,ScrH()-70, Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		
			draw.SimpleText("You can move cam position by moving your cursor to edge of screen.", "RXCarFont_TrebLWOut_S20", ScrW()/2,ScrH()-40, Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText("Press W and S to zoom & unzoom", "RXCarFont_TrebLWOut_S20", ScrW()/2,ScrH()-20, Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			
				local MX,MY = gui.MouseX() , gui.MouseY()
				
				local Speed = FrameTime()*500
				
				if MX < 5 then
					LP.RXCarThirdPos.y = LP.RXCarThirdPos.y + Speed
				end
				if MX > ScrW()-5 then
					LP.RXCarThirdPos.y = LP.RXCarThirdPos.y - Speed
				end
				if MY < 5 then
					LP.RXCarThirdPos.x = LP.RXCarThirdPos.x + Speed
				end
				if MY > ScrH()-5 then
					LP.RXCarThirdPos.x = LP.RXCarThirdPos.x - Speed
				end
				
				LP.RXCarThirdPos.x = math.max(LP.RXCarThirdPos.x,PosLock.x - D3DCarConfig.CarSpawnRange/2)
				LP.RXCarThirdPos.x = math.min(LP.RXCarThirdPos.x,PosLock.x + D3DCarConfig.CarSpawnRange/2)
				
				LP.RXCarThirdPos.y = math.max(LP.RXCarThirdPos.y,PosLock.y - D3DCarConfig.CarSpawnRange/2)
				LP.RXCarThirdPos.y = math.min(LP.RXCarThirdPos.y,PosLock.y + D3DCarConfig.CarSpawnRange/2)
				
				if input.IsKeyDown(KEY_W) then
					LP.RXCarThirdPos.z = LP.RXCarThirdPos.z - Speed
				end
				if input.IsKeyDown(KEY_S) then
					LP.RXCarThirdPos.z = LP.RXCarThirdPos.z + Speed
				end
		end)
			
		hook.Add("GUIMousePressed","RXCar SpawnClick", function(MC)
			if MC == MOUSE_RIGHT then
				gui.EnableScreenClicker(false)
				hook.Remove("CalcView","RXCar ThirdView")
				hook.Remove("HUDPaint","RXCar Guide")
				hook.Remove("GUIMousePressed","RXCar SpawnClick")
				hook.Remove("PreDrawHalos", "RXCar Halo")
				RXCar_EnableThirdPerson(false)
			end
			
			if MC == MOUSE_LEFT then
				local MouseTR = RXCar_MousePos()
				if MouseTR.Entity and MouseTR.Entity:IsValid() and MouseTR.Entity:IsVehicle() then
					RXCar_DoStoreCar(MouseTR.Entity)
				end
			end
		end)
			
		hook.Add("PreDrawHalos", "RXCar Halo", function()
			local MouseTR = RXCar_MousePos()
			
			for k,v in pairs(ents.FindInSphere(PosLock,D3DCarConfig.CarStoreRange+300)) do
				if v:IsVehicle() and v:GetNWInt("OwnerSID") == LocalPlayer():SteamID() then
					halo.Add({v}, Color(0, 255, 0), 5, 5, 1)
				end
			end
			
			if MouseTR.Entity and MouseTR.Entity:IsValid() and MouseTR.Entity:IsVehicle() then
				halo.Add({MouseTR.Entity}, Color(255, 0, 0), 5, 5, 1)
			end
			
		end)
end

function RXCar_CarSpawnMode(DealerEnt,CarModel,INVUID)
		local LP = LocalPlayer()
		local PosLock = DealerEnt:GetPos()
		LP.RXCarThirdPos = GetRoofPos(DealerEnt)
		
		local SelectedSpawnedPos = nil
		local SelectedCarAngle = Angle(0,0,0)
		
			gui.EnableScreenClicker(true)
			hook.Add("CalcView","RXCar ThirdView", function( ply, origin, angles, fov )
				return GAMEMODE:CalcView(ply, ply.RXCarThirdPos, Angle(90,0,0), fov)
			end)
			
			hook.Add("HUDPaint","RXCar Guide", function()
				draw.SimpleText("Press Left mouse to set position to spawn cars", "RXCarFont_TrebLWOut_S45", ScrW()/2,ScrH()-120, Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				draw.SimpleText("You can move cam position by moving your cursor to edge of screen.", "RXCarFont_TrebLWOut_S20", ScrW()/2,ScrH()-60, Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				draw.SimpleText("Press W and S to zoom & unzoom", "RXCarFont_TrebLWOut_S20", ScrW()/2,ScrH()-80, Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			
				local MX,MY = gui.MouseX() , gui.MouseY()
				
				local Speed = FrameTime()*500
				
				if MX < 5 then
					LP.RXCarThirdPos.y = LP.RXCarThirdPos.y + Speed
				end
				if MX > ScrW()-5 then
					LP.RXCarThirdPos.y = LP.RXCarThirdPos.y - Speed
				end
				if MY < 5 then
					LP.RXCarThirdPos.x = LP.RXCarThirdPos.x + Speed
				end
				if MY > ScrH()-5 then
					LP.RXCarThirdPos.x = LP.RXCarThirdPos.x - Speed
				end
				
				LP.RXCarThirdPos.x = math.max(LP.RXCarThirdPos.x,PosLock.x - D3DCarConfig.CarSpawnRange/2)
				LP.RXCarThirdPos.x = math.min(LP.RXCarThirdPos.x,PosLock.x + D3DCarConfig.CarSpawnRange/2)
				
				LP.RXCarThirdPos.y = math.max(LP.RXCarThirdPos.y,PosLock.y - D3DCarConfig.CarSpawnRange/2)
				LP.RXCarThirdPos.y = math.min(LP.RXCarThirdPos.y,PosLock.y + D3DCarConfig.CarSpawnRange/2)
				
				if input.IsKeyDown(KEY_W) then
					LP.RXCarThirdPos.z = LP.RXCarThirdPos.z - Speed
				end
				if input.IsKeyDown(KEY_S) then
					LP.RXCarThirdPos.z = LP.RXCarThirdPos.z + Speed
				end
			end)
			
			hook.Add("GUIMousePressed","RXCar SpawnClick", function()
				local MouseTR = RXCar_MousePos()
				
				local Dist = PosLock:Distance(MouseTR.HitPos)
				if Dist > D3DCarConfig.CarSpawnRange then
					return
				end
				
				SelectedSpawnedPos = MouseTR.HitPos
				
				hook.Add("HUDPaint","RXCar Guide", function()
					draw.SimpleText("Press Left mouse to set angle to spawn cars", "RXCarFont_TrebLWOut_S45", ScrW()/2,ScrH()-100, Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				end)
				hook.Add("GUIMousePressed","RXCar SpawnClick", function()
					local MouseTR = RXCar_MousePos()
					RXCar_DoSpawnCar(SelectedSpawnedPos,(MouseTR.HitPos-SelectedSpawnedPos):Angle(),INVUID)
				end)
			end)
			
			
			local MAT_BEAM = Material("sprites/physgbeamb")
			hook.Add("PostDrawOpaqueRenderables","RXCar Render", function()
				local MouseTR = RXCar_MousePos()
				
				local CarPos = SelectedSpawnedPos or MouseTR.HitPos
				
				RXC_CMODEL_CAR:SetRenderOrigin(CarPos)
				RXC_CMODEL_CAR:SetRenderAngles(SelectedCarAngle)
				RXC_CMODEL_CAR:SetModel(CarModel)
				
				render.SetMaterial( MAT_BEAM )
				local Dist = PosLock:Distance(CarPos)
				if Dist < D3DCarConfig.CarSpawnRange then
					render.DrawBeam( PosLock,CarPos, 5, 1, 1, Color(0,255,255,255) ) 
				else
					render.DrawBeam( PosLock,CarPos, 5, 1, 1, Color(255,0,0,255) ) 
				end
				
				if SelectedSpawnedPos then
					render.DrawBeam( MouseTR.HitPos,SelectedSpawnedPos, 5, 1, 1, Color(0,255,0,255) ) 
					SelectedCarAngle = (MouseTR.HitPos-SelectedSpawnedPos):Angle()
				end
				

				render.SetBlend(0.5)
					RXC_CMODEL_CAR:DrawModel()
				render.SetBlend(1)
			end)
end