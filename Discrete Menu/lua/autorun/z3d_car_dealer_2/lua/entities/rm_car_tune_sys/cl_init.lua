include('shared.lua')

	net.Receive( "RXCAR_TuneData_S2C", function( len,ply )
		local TB = net.ReadTable()
		local Ent = TB.Ent
		local TuneData = TB.TuneData
		if Ent and Ent:IsValid() and Ent:GetClass() == "rm_car_tune_sys" then
			Ent:SetTuneData(TuneData)
		end
	end)

	
function ENT:Initialize()
	self:SetRenderBounds( Vector(-300,-300,-300),Vector(300,300,300) )
end

function ENT:Draw()
	if !self.TuneData then
		self.TuneData = {}
		net.Start( "RXCAR_RequestTuneData_C2S" )
			net.WriteTable( {Ent = self} )
		net.SendToServer()
	end
end

function ENT:Think()
	if self.TuneData then
		for UID,DB in pairs(self.TuneData.Elements or {}) do
			local ElementDB = RXCar_Tuners[DB.Type]
			if ElementDB then
				ElementDB:CL_Think(self,DB.Vars)
			end
		end
	end
end

hook.Add("PostDrawTranslucentRenderables", "RM CAR Tune System Drawing", function( )
	for k,v in pairs(ents.FindByClass("rm_car_tune_sys")) do
		v:DrawElements(v.TuneData or {})
	end
end)

function ENT:SetTuneData(Data)
	self.TuneData = Data
end

function ENT:DrawElements(TuneData)
	cam.Start3D(EyePos(), EyeAngles())
		for UID,DB in pairs(TuneData.Elements or {}) do
			local ElementDB = RXCar_Tuners[DB.Type]
			if ElementDB then
				ElementDB:Render(self,DB.Vars)
			end
		end
	cam.End3D()
end