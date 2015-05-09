
AddCSLuaFile()

SWEP.HoldType = "slam"


if CLIENT then
   SWEP.PrintName = "Portable Life Monitor"
   SWEP.Slot = 6
   
   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Place this device on a player or to\ntrack them at all times! \n\nProvides info on the tracked player. (e.g HP )."
   };
   
   SWEP.Icon = "vgui/ttt/icon_defuser"
end

SWEP.Base				= "weapon_tttbase"

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_DETECTIVE}
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
return true
end

function SWEP:Think()
	if self.Placed == true then return end
	
	local tr = util.QuickTrace( self.Owner:GetShootPos(), self.Owner:GetAimVector()*70, {self, self.Owner} )
	
	if tr.Entity:IsPlayer() and self.Raised == false then
		self.Raised = true
		self:SendWeaponAnim( self.CanPlaceAnim )
	elseif tr.HitWorld and self.Raised == true or not tr.Hit and self.Raised == true then
		self.Raised = false
		self:SendWeaponAnim(self.IdleAnim)
	end
	
end

function SWEP:PrimaryAttack()	
	if self.Placed == false then
		self.Owner:LagCompensation( true )
		local tr = util.QuickTrace( self.Owner:GetShootPos(), self.Owner:GetAimVector()*70, {self, self.Owner})
		self.Owner:LagCompensation( false )
		if tr.Hit and tr.HitNonWorld then
		
			if tr.Entity:IsPlayer() then
			
				if IsFirstTimePredicted() then
					self.Owner:EmitSound("physics/cardboard/cardboard_box_break3.wav")
					self:SendWeaponAnim( self.PlaceAnim )
				end
				
				self.Owner:SetNWEntity("PLMTarget", tr.Entity )
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

function SWEP:Holster()
	return self.CanHolster
end

function SWEP:OnDrop()
	self.OldOwner = self.Owner
end