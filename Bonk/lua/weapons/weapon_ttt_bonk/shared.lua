
AddCSLuaFile()

SWEP.HoldType = "slam"


if CLIENT then
   SWEP.PrintName = "Bonk Atomic Punch"
   SWEP.Slot = 6
   
   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Grants the user damage immunity for 15 seconds,\nas well as increasing their movement speed by 50%.\nHowever, the user cannot attack untill after the\nduration. "
   };
   
   SWEP.Icon = "vgui/ttt/icon_defuser"
end

SWEP.Base				= "weapon_tttbase"

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
SWEP.LimitedStock = false

SWEP.Spawnable = false


SWEP.AutoSpawnable      = true

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 10
SWEP.ViewModel			= "models/weapons/c_slam.mdl"
SWEP.WorldModel			= "models/props_junk/PopCan01a.mdl"
SWEP.Weight			= 5

function SWEP:Initialize()
	if SERVER then
		self:SetWeaponHoldType( self.HoldType )
	end
end
function SWEP:Equip()
	self.Owner.Bonked = false
end

function SWEP:PrimaryAttack()
	if self.Owner.Bonked == false then
		self.Owner.Bonked = true
		self.Owner.SpeedMult = 1.5
		if IsFirstTimePredicted() then
			self.Owner:EmitSound("bonk_drink.wav")
		end
		self:SetWeaponHoldType( "normal" )
		timer.Simple(12,function()
			if IsValid(self) and IsValid(self.Owner) and self.Owner:Alive() then
				self.Owner.Bonked = false
				self.Owner.SpeedMult = 1
				if SERVER then
					self:Remove()
				end
			end
		end)
	end
end

local poseparams = {
   "aim_yaw", "move_yaw", "aim_pitch",
--   "spine_yaw", "head_yaw", "head_pitch"
};
function SWEP:Think()
	if SERVER then
		if self.Owner.Bonked == true then
			local ply = self.Owner
			
			local data = {
			  pos      = ply:GetPos(),
			  ang      = ply:GetAngles(),
			  sequence = ply:GetSequence(),
			  cycle    = ply:GetCycle()
		   };

		   for _, param in pairs(poseparams) do
			  data[param] = ply:GetPoseParameter(param)
		   end
		   
			local dist = 3
			local effect = EffectData()
			effect:SetEntity(self.Owner)
			effect:SetOrigin(data.pos + Vector(math.Rand(-dist,dist),math.Rand(-dist,dist),math.Rand(-dist,dist)) + (self.Owner:GetVelocity()):GetNormal()*15 )
			effect:SetAngles(data.ang)
			effect:SetColor( data.sequence)
			effect:SetScale( data.cycle )
			effect:SetStart(Vector(self.Owner:GetPoseParameter("aim_yaw"), self.Owner:GetPoseParameter("aim_pitch"),self.Owner:GetPoseParameter("move_yaw")))

			util.Effect("bonk_effect", effect, true, true)
		end
	end
end

function SWEP:Holster()
	if self.Owner.Bonked == true then
		return false
	end
return true
end
