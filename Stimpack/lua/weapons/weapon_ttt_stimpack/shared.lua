
if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddFile( "materials/vgui/ttt/icons/stimpack.vmt")
end

SWEP.HoldType			= "slam"

if CLIENT then
   SWEP.PrintName = "Stimpack"
   SWEP.Slot = 7

   SWEP.ViewModelFOV = 10

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Use this for a quick health boost. Made by Fortune"
   };

   SWEP.Icon = "vgui/ttt/icons/stimpack"
end
 resource.AddFile("vgui/icon/stimpack")
SWEP.Base = "weapon_tttbase"

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/Items/HealthKit.mdl"

SWEP.DrawCrosshair		= false
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Delay = 5
SWEP.Primary.Ammo		= "none"


SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_TRAITOR} -- only detectives can buy
SWEP.WeaponID = AMMO_STIMPACK
SWEP.LimitedStock = true

function SWEP:Deploy()
self:SetNoDraw(true)

end

--SWEP.AllowDrop = false
local failsound = Sound("items/medshotno1.wav")
local healsound = Sound("items/medshot4.wav")
function SWEP:PrimaryAttack()

  if SERVER then
  local health = self.Owner:Health()
  if not self:CanPrimaryAttack() then return end

  if health >= 100 then
    self:EmitSound(failsound)
    return
  end



  self.Owner:SetHealth(health + 60)
  local postheal = self.Owner:Health(health + 60)
  
  if  postheal > 100 then
  self.Owner:SetHealth( 100 )
  
  end 
  self:EmitSound(healsound)
  self:TakePrimaryAmmo( 1 )
  self:Remove()
  end

end

function SWEP:SecondaryAttack()
return false
end




function SWEP:Reload()
   return false
end

function SWEP:Deploy()
   if SERVER and IsValid(self.Owner) then
    --  self.Owner:DrawViewModel(false)
   end
   return true
end


function SWEP:OnDrop()
end
