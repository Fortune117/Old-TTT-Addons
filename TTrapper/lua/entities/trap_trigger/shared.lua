
if SERVER then 
AddCSLuaFile("shared.lua")
 end

if CLIENT then
   ENT.PrintName = "Trap Trigger"
end

ENT.Type = "anim"
ENT.Model = "models/maxofs2d/hover_plate.mdl"
//ENT.Model = "models/xqm/button2.mdl"

ENT.CanUseKey = false

function ENT:Initialize()
	if SERVER then
		self.Entity:SetModel( self.Model )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_PLAYER )
		self.Entity:SetMoveType( MOVETYPE_NONE )
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:SetTrigger( true )
		self:DrawShadow(false)
	end
end

local TouchDelay = CurTime() + 0.5
function ENT:Touch(hitEnt)
	if CurTime() > TouchDelay then
		if IsValid(hitEnt) and hitEnt:IsPlayer() and not hitEnt:IsTraitor() then
			local E = ents.FindByClass("dart_trap")
			for k,v in pairs(E) do
				if IsValid(v) and v.Placer == self.Placer and v.SteppedOn == false then
					timer.Simple(0.01,function()
						v:FireLaser()
						v.SteppedOn = false
					end)
				end
			end
		end
		TouchDelay = CurTime() + 0.5
	end
end

if CLIENT then
	function ENT:Draw()
		if LocalPlayer():IsActiveTraitor() then
			self:DrawModel()
		end
	end
end
