
AddCSLuaFile()

SWEP.HoldType = "slam"


if CLIENT then
   SWEP.PrintName = "Pocket IED"
   SWEP.Slot = 6
   
   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Place this device on a player or a\ncorpse, then right click to detonate! Have fun!"
   };
   
  SWEP.Icon = "vgui/ttt/icons/icon_ied"
end

SWEP.Base				= "weapon_tttbase"

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true

SWEP.Spawnable = false


SWEP.AutoSpawnable      = true

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel			= "models/weapons/c_slam.mdl"
SWEP.WorldModel			= "models/weapons/w_slam.mdl"
SWEP.Weight			= 5

SWEP.Placed = false
SWEP.Raised = false

SWEP.CanPlace = false
SWEP.DrawAnim = ACT_SLAM_TRIPMINE_DRAW
SWEP.CanPlaceAnim = ACT_SLAM_TRIPMINE_ATTACH
SWEP.IdleAnim = ACT_SLAM_TRIPMINE_IDLE
SWEP.PlaceAnim = ACT_SLAM_TRIPMINE_ATTACH2

SWEP.DrawAnim_Placed = ACT_SLAM_DETONATOR_DRAW
SWEP.Detonate = ACT_SLAM_DETONATOR_DETONATE
SWEP.DetIdle = ACT_SLAM_DETONATOR_IDLE
SWEP.ChangeAnim = ACT_SLAM_TRIPMINE_TO_THROW_ND

SWEP.CanHolster = true

SWEP.Detonated = false

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	self:SetDeploySpeed( 1.3 )
end

function SWEP:Deploy()

	if self.Placed == false then
		self:SendWeaponAnim( self.DrawAnim )
	else
		self:SendWeaponAnim( self.DrawAnim_Placed )
	end
	
end

function SWEP:Think()
	if self.Placed == true then return end
	
	local tr = util.QuickTrace( self.Owner:GetShootPos(), self.Owner:GetAimVector()*70, {self, self.Owner} )
	
	if tr.Entity:IsPlayer() and self.Raised == false or IsValid(tr.Entity) and tr.Entity:GetClass() == "prop_ragdoll" and self.Raised == false  then
		self.Raised = true
		self:SendWeaponAnim( self.CanPlaceAnim )
	elseif tr.HitWorld and self.Raised == true or not tr.Hit and self.Raised == true then
		self.Raised = false
		self:SendWeaponAnim(self.IdleAnim)
	end
	
end

function SWEP:PrimaryAttack()	
	if self.Placed == false then
		local tr = util.QuickTrace( self.Owner:GetShootPos(), self.Owner:GetAimVector()*70, {self, self.Owner})
		
		if tr.Hit and tr.HitNonWorld then
		
			if tr.Entity:IsPlayer() or tr.Entity:GetClass() == "prop_ragdoll" then
			
				if IsFirstTimePredicted() then
					self.Owner:EmitSound("physics/cardboard/cardboard_box_break3.wav")
					self:SendWeaponAnim( self.PlaceAnim )
				end
				
				self.Owner:SetNWEntity("IEDTarget", tr.Entity )
				self.Placed = true
				self.CanHolster = false
				timer.Simple(0.7,function()
					if IsValid(self) and IsValid(self.Owner) then
						self:SendWeaponAnim( self.DrawAnim_Placed )
						self.CanHolster = true
					end
				end)
			end
			
		end
	end
end

function SWEP:Explode( targ, owner )
	
	if IsFirstTimePredicted() then
		targ:EmitSound("npc/attack_helicopter/aheli_charge_up.wav")
	end
	
	timer.Simple(1.8769,function()
		if IsValid(targ) then
			if IsValid(owner) then
				local effect = EffectData()
				effect:SetOrigin( targ:GetPos() )
				effect:SetRadius( 300 )
				effect:SetMagnitude( 150 )
				effect:SetScale ( 300 )
				util.Effect( "Explosion", effect, true, true )
				util.BlastDamage( owner, owner, targ:GetPos(), 300, 150 )
				
				owner:SetNWEntity("IEDTarget", nil )
			end
		end
	end)
	
end

function SWEP:SecondaryAttack()
	if self.Placed == false then return end
	if self.Detonated == true then return end
	
	if IsFirstTimePredicted() then
		self:SendWeaponAnim( self.Detonate )
		self:EmitSound("buttons/blip2.wav")
	end
	
	for k,v in pairs(ents.GetAll()) do
		if IsValid(v) then
			if v == self.Owner:GetNWEntity("IEDTarget") then
				self:Explode(v, self.Owner)
				self.Detonated = true
			end
		end
	end
	
end

function SWEP:Holster()
	return self.CanHolster
end

function SWEP:OnDrop()
	self.OldOwner = self.Owner
end