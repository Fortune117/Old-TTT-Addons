AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/Humans/Group02/male_09.mdl" )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
 
	self:SetMaxYawSpeed( 180 )
end

function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
    local ent = ents.Create( "rm_car_dealer" )
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 ) 
    ent:Spawn()
    ent:Activate()
 
    return ent
end
function ENT:AcceptInput( Name, Activator, Caller )
	if Name == "Use" and Caller:IsPlayer() then
		Caller:RXCar_SyncInv()
		Caller:RXCar_OpenShop(self)
	end
end


----------- DarkRP function
function ENT:PhysgunPickup(ply) -- for DarkRP
	if D3DCarConfig:IsAdmin(ply) then
		return true
	else
		return false
	end
end

function ENT:CanTool(ply, trace, mode)  -- for DarkRP
	if D3DCarConfig:IsAdmin(ply) then 
		return true 
	else
		return false
	end
end