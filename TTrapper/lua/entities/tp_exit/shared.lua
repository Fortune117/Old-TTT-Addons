
if SERVER then 
AddCSLuaFile("shared.lua")
 end

if CLIENT then
   ENT.PrintName = "Trap Trigger"
end

ENT.Type = "anim"
ENT.Model = "models/props_junk/sawblade001a.mdl"
//ENT.Model = "models/xqm/button2.mdl"

ENT.CanUseKey = false

function ENT:Initialize()
	if SERVER then
		self.Entity:SetModel( self.Model )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_PLAYER )
		self.Entity:SetMoveType( MOVETYPE_NONE )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		self.Entity:SetTrigger( true )
		self:DrawShadow(false)
	end
end


function ENT:BringPlayer( ply )
	if IsValid(ply) then
		ply:SetPos( self:GetPos() + Vector(0,0,10) )
		ply:Freeze(false)
		
		local explosioneffect = ents.Create( "prop_combine_ball" )
	    explosioneffect:SetPos(self:GetPos())
	    explosioneffect:Spawn()
	    explosioneffect:Fire( "explode", "", 0 )
		
		local effect = EffectData()
		effect:SetOrigin( self:GetPos() )
		effect:SetScale(100)
		util.Effect( "ThumperDust", effect, true, true )
	end
end

if CLIENT then
function ENT:Draw()
	if LocalPlayer():IsActiveTraitor() then
		self:DrawModel()
	end
end
end
