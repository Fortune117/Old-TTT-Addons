AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/props_junk/PopCan01a.mdl" )
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(false)
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	
	self.TuneData = {}
end

hook.Add("KeyPress","RXCar Element Bind",function(ply,Key)
	local PlyVehicle = ply:GetVehicle()
	
	if PlyVehicle.IsScarSeat then
		PlyVehicle = PlyVehicle.EntOwner
	end
	
	if PlyVehicle and PlyVehicle:IsValid() and PlyVehicle.TuneSys then
		for UID,DB in pairs(PlyVehicle.TuneSys.TuneData.Elements or {}) do
			local ElementDB = RXCar_Tuners[DB.Type]
			if ElementDB then
				ElementDB:SV_KeyPressed(PlyVehicle.TuneSys,DB.Vars,Key,DB.UniqueID)
			end
		end	
	end
end)	

function ENT:GetDriver()
	if !self.Mother or !self.Mother:IsValid() then return false end
	
		local Driver = self.Mother:GetDriver()
		if !Driver or !Driver:IsValid() or !Driver:IsPlayer() then return false end
		
		return Driver

end

function ENT:SetTuneData(TuneData)
	self.TuneData = TuneData
	
	for UID,DB in pairs(TuneData.Elements or {}) do
		local ElementDB = RXCar_Tuners[DB.Type]
		if ElementDB then
			ElementDB:SV_OnCreated(self,DB.Vars)
		end
	end	
end

function ENT:Think()

	for UID,DB in pairs(self.TuneData.Elements or {}) do
		local ElementDB = RXCar_Tuners[DB.Type]
		if ElementDB then
			ElementDB:SV_Think(self,DB.Vars)
		end
	end

	if self.Mother and self.Mother:IsValid() then
		self.Mother:SetColor(self.TuneData.Color or Color(255,255,255,255))
	end
end


util.AddNetworkString( "RXCAR_RequestTuneData_C2S" )
util.AddNetworkString( "RXCAR_TuneData_S2C" )


	net.Receive( "RXCAR_RequestTuneData_C2S", function( len,ply )
		local TB = net.ReadTable()
		local Ent = TB.Ent
		if Ent and Ent:IsValid() and Ent:GetClass() == "rm_car_tune_sys" then
			net.Start( "RXCAR_TuneData_S2C" )
				net.WriteTable( {Ent = Ent,TuneData = Ent.TuneData} )
			net.Send(ply)
		else
			MsgN("PROBLEM")
		end
	end)