
/*
energyshieldusers = {}
player.GetEnergyShieldUsers = function()
	local e_users = {}
	local plys = player.GetHumans()
	for i = 1,#plys do
		if plys[ i ]:HasEnergyShield() then 
			e_users[ #e_users ] = plys[ i ]
		end
	end
	return e_users
end

local WEP = FindMetaTable( 'Weapon' )

local rifle_names =
{
	"weapon_fort_aug",
	"weapon_fort_ak47",
	"weapon_fort_famas",
	"weapon_fort_galil",
	"weapon_ttt_m16",
	"weapon_zm_rifle",
	"weapon_zm_sledge"
}
function WEP:IsRifle() 
	return table.HasValue( rifle_names, self:GetClass() )
end

local pistol_names = 
{
	"weapon_fort_glock",
	"weapon_fort_sipistol",
	"weapon_fort_p228",
	"weapon_zm_revolver",
	"weapon_zm_pistol"
}
function WEP:IsPistol()
	return table.HasValue( pistol_names, self:GetClass() )
end

local PLY = FindMetaTable( 'Player' )

function PLY:HasPerk( perk )
	return self.DiscreteSettings != nil and self.DiscreteSettings[ 4 ] != nil and self.DiscreteSettings[ 4 ][ 1 ] == perk
end

function PLY:GetShieldCharge()
	return self.EnergyShield.Charge
end

function PLY:SetShieldCharge( num )
	self.EnergyShield.Charge = num
end

function PLY:IncrementShieldCharge()
	self.EnergyShield.Charge = self.EnergyShield.Charge + 1 
end

function PLY:GetShieldMax()
	return self.EnergyShield.Max
end

function PLY:GetShieldDelay()
	return self.EnergyShield.Delay
end

function PLY:GetShieldDelayTime()
	return self.EnergyShield.DelayTime
end

function PLY:SetShieldDelay( num )
	self.EnergyShield.DelayTime = CurTime() + num
end

function PLY:ShieldShouldCharge()
	return self:GetShieldCharge() < self:GetShieldMax() and self:GetShieldDelayTime() < CurTime()
end

function PLY:SetUpEnergyShield( max, delay )
	self.EnergyShield = {}
	self.EnergyShield.Max = max
	self.EnergyShield.Delay = delay 
	self.EnergyShield.DelayTime = 0
	self.EnergyShield.Charge = max

	table.insert( energyshieldusers, #energyshieldusers+1, self)
end

function PLY:StartShieldBreakSound()
	if not self.shieldbreaksound then
		self.shieldbreaksound = CreateSound( self, "ambient/energy/electric_loop.wav" )
		self.shieldbreaksound:Play()
	else
		self.shieldbreaksound:Play()
	end
end

function PLY:ShieldBreakSoundPlaying()
	return self.shieldbreaksound and self.shieldbreaksound:IsPlaying()
end

function PLY:StopShieldBreakSound()
	self.shieldbreaksound:Stop()
end

function PLY:ShieldChargeSoundPlaying()
	return self.shieldchargesound and self.shieldchargesound:IsPlaying()
end

function PLY:StartShieldChargeSound()
	if not self.shieldchargesound then
		self.shieldchargesound = CreateSound( self, "ambient/energy/force_field_loop1.wav" )
		self.shieldchargesound:Play()
	else
		self.shieldchargesound:Play()
	end
end

function PLY:StopShieldChargeSound()
	self.shieldchargesound:FadeOut( 2 )
end

local energysounds =
{
	"ambient/energy/weld1.wav",
	"ambient/energy/weld2.wav"
}
function PLY:DoEnergyDamageCheck( dmginfo )
	local chrg = self:GetShieldCharge()
	if chrg > 0 then

		local new_damage = dmginfo:GetDamage() - chrg
		local old_damage = dmginfo:GetDamage()
		dmginfo:SetDamage( new_damage )

		local new_chrg = math.max( math.Round( chrg-old_damage ), 0)

		if new_chrg == 0 then
			self:EmitSound( "ambient/energy/zap9.wav" )
			self:StartShieldBreakSound( )
		else
			self:EmitSound( tostring( table.Random( energysounds ) ) )
		end

		self:SetShieldCharge( new_chrg )

		local effect = EffectData()
		effect:SetOrigin( dmginfo:GetDamagePosition() or (self:GetPos()+Vector(0,0,45)) )
		effect:SetScale( 10 )
		effect:SetMagnitude( 10 )
		util.Effect( "cball_bounce", effect, true, true )
	end
	self:SetShieldDelay( self:GetShieldDelay() )
 return dmginfo
end

function PLY:ShieldThink()
	if self:ShieldShouldCharge() then
		if self:ShieldBreakSoundPlaying() then
			self:StopShieldBreakSound()
			self:StartShieldChargeSound()
		end
		self:IncrementShieldCharge()
		self:SetShieldDelay( 0.25 )
	end

	if self:GetShieldCharge() == self:GetShieldMax() then
		if self:ShieldChargeSoundPlaying() then
			self:StopShieldChargeSound()
		end
	end
end

local energyshields =
{
	"EEShield"
}

function PLY:HasEnergyShield() 
	for i = 1,#energyshields do
		if self:HasPerk( energyshields[ i ] ) and self.EnergyShield != nil then
			return true
		end
	end
	return false
end

function PLY:StripEnergyShield()
	self.EnergyShield = nil
	table.RemoveByValue( energyshieldusers, self )
end

hook.Add( "EntityTakeDamage", "EnergyShield", function( ply, dmginfo )
	if IsValid( ply ) and ply:IsPlayer() then
		if ply:HasEnergyShield() then
			dmginfo = ply:DoEnergyDamageCheck( dmginfo ) 
		end
	end
end)

hook.Add( "DoPlayerDeath", "StripEnergyShield", function( ply )
	if ply:HasEnergyShield() then
		ply:StripEnergyShield()
	end
end)

hook.Add( "PlayerDisconnected", "StripEnergyShield", function( ply )
	if ply:HasEnergyShield() then
		ply:StripEnergyShield()
	end
end)

if SERVER then
	hook.Add( "Think", "EnergyShieldThink", function()
		for k,v in pairs( player.GetAll() ) do
			if v:HasEnergyShield() then
				v:ShieldThink()
			end
		end
	end)
end


local regen_delay = 1
local regen_delay2 = 2
local regen_delay3 = 2

PERKS = 
{
	["Shock Trauma"] = {"ShockTrauma", "Your explosives deal 20% extra damage.", "vgui/perks/default.png", 2, "ScalePlayerDamage", function( ply, hitGroup, dmginfo )
		local atk = dmginfo:GetAttacker()
		local inf = dmginfo:GetInflictor()
		if IsValid( atk ) and atk:IsPlayer() then
			if atk:HasPerk( "ShockTrauma" ) and dmginfo:IsExplosionDamage() or atk:HasPerk( "ShockTrauma" ) and dmginfo:GetDamageType() == DMG_BURN then
				dmginfo:ScaleDamage( 1.2 )
			end
		end
	end},
	["Moon Shoes"] = { "MoonShoes", "Jump 20% higher.", "vgui/perks/default.png", 5, "TTTPrepareRound", function( )
		for _,ply in pairs( player.GetAll() ) do
			if ply:HasPerk( "MoonShoes" ) then
				ply:SetJumpPower( 192 )
			end
		end
	end},
	["Fleet of Foot"] = { "FleetFoot", "Run 10% faster.", "vgui/perks/default.png", 5, "TTTPlayerSpeed", function( ply, slowed )
		if ply:HasPerk( "FleetFoot" ) then
			return 1.1
		end
	end},
	["Juggernaut"] = {"Juggernaut", "Start the round with 15 extra health.", "vgui/perks/default.png", 8, "TTTBeginRound", function( )
		timer.Simple(0.5,function()
			for k,v in pairs( player.GetAll() ) do
				if v:HasPerk( "Juggernaut" ) then
					v:SetHealth( 115 )
					//v:SetMaxHealth( 115 )
				end
			end
		end)
	end},
	["Tough as Nails"] = {"TAN", "Receive 10% less damage from all sources.", "vgui/perks/default.png", 8, "ScalePlayerDamage", function( ply, hitGroup, dmginfo )
		local atk = dmginfo:GetAttacker()
		local inf = dmginfo:GetInflictor()
		if ply:HasPerk( "TAN") then
			dmginfo:ScaleDamage( 0.9 )
		end
	end},
	["Marksman"] = {"Marksman", "Rifles deal 10% extra damage.", "vgui/perks/default.png", 10, "ScalePlayerDamage", function( ply, hitGroup, dmginfo )
		local atk = dmginfo:GetAttacker()
		local inf = dmginfo:GetInflictor()
		if IsValid( atk ) and atk:IsPlayer() then
			if atk:HasPerk( "Marksman" ) and atk:GetActiveWeapon():IsRifle() then
				dmginfo:ScaleDamage( 1.1 )
			end
		end
	end},
	["Gun Slinger"] = { "GunSlinger", "Deal 15% extra damage with pistols. ", "vgui/perks/default.png", 15,  "ScalePlayerDamage", function( ply, hitGroup, dmginfo )
		local atk = dmginfo:GetAttacker()
		local inf = dmginfo:GetInflictor()
		if IsValid( atk ) and atk:IsPlayer() then
			if atk:HasPerk( "GunSlinger" ) and inf:IsPistol() then
				dmginfo:ScaleDamage( 1.15 )
			end
		end
	end},
	["Juggernaut II"] = {"JuggernautII", "Start the round with 25 extra health.", "vgui/perks/default.png", 16, "TTTBeginRound", function( )
		timer.Simple(0.5,function()
			for k,v in pairs( player.GetAll() ) do
				if v:HasPerk( "JuggernautII" ) then
					v:SetHealth( 125 )
					//v:SetMaxHealth( 125 )
				end
			end
		end)
	end},
	["Tough as Nails II"] = {"TANII", "Receive 20% less damage from all sources.", "vgui/perks/default.png", 16, "ScalePlayerDamage", function( ply, hitGroup, dmginfo )
		local atk = dmginfo:GetAttacker()
		local inf = dmginfo:GetInflictor()
		if ply:HasPerk( "TANII") then
			dmginfo:ScaleDamage( 0.8 )
		end
	end},
	["Bullseye"] = {"Bullseye", "25% less damage on body shots, 30% extra damage on headshots.", "vgui/perks/default.png", 20, "ScalePlayerDamage", function( ply, hitGroup, dmginfo )
		local atk = dmginfo:GetAttacker()
		local inf = dmginfo:GetInflictor()
		if IsValid( atk ) and atk:IsPlayer() then
			if atk:HasPerk( "Bullseye" ) then
				if hitGroup == HITGROUP_HEAD then
					dmginfo:ScaleDamage( 1.3 )
				else
					dmginfo:ScaleDamage( 0.75 )
				end
			end
		end
	end},
	["Fleet of Foot II"] = { "FleetFootII", "Run 25% faster.", "vgui/perks/default.png", 16, "TTTPlayerSpeed", function( ply, slowed )
		if ply:HasPerk( "FleetFootII" ) then
			return 1.25
		end
	end},
	["Beserkers Blood"] = {"Beserk", "For every point of health missing, deal 0.8% more damage.", "vgui/perks/default.png", 24, "ScalePlayerDamage", function( ply, hitGroup, dmginfo )
		local atk = dmginfo:GetAttacker()
		local inf = dmginfo:GetInflictor()
		if IsValid( atk ) and atk:IsPlayer() then
			if atk:HasPerk( "Beserk" ) then
				local mult = ( atk:GetMaxHealth()-atk:Health() )*0.008
				dmginfo:ScaleDamage( 1+mult )
			end 
		end
	end},
	["Bulldozer"] = {"Bulldozer", "30 extra hp, 10% damage resistance but at the cost of 35% movespeed.", "vgui/perks/default.png", 28, {"ScalePlayerDamage", "TTTBeginRound"}, {function( ply, hitGroup, dmginfo )
		local atk = dmginfo:GetAttacker()
		local inf = dmginfo:GetInflictor()
		if IsValid( atk ) and atk:IsPlayer() then
			if ply:HasPerk( "Bulldozer" ) then
				dmginfo:ScaleDamage( 0.9 )
			end 
		end
	end, function( )
	 	timer.Simple(0.5,function()
			for k,v in pairs( player.GetAll() ) do
				if v:HasPerk( "Bulldozer" ) then
					v:SetHealth( 130 )
					v:SetMaxHealth( 130 )
				end
			end
		end)
	end, function( ply )
		if ply:HasPerk( "Bulldozer" ) then
			return 0.65
		end
	end} },
	["Juggernaut III"] = {"JuggernautIII", "Start the round with 30 extra health.", "vgui/perks/default.png", 32, "TTTBeginRound", function( )
		timer.Simple(0.5,function()
			for k,v in pairs( player.GetAll() ) do
				if v:HasPerk( "JuggernautIII" ) then
					v:SetHealth( 135 )
					v:SetMaxHealth( 135 )
				end
			end
		end)
	end},
	["Tough as Nails III"] = {"TANIII", "Receive 30% less damage from all sources.", "vgui/perks/default.png", 8, "ScalePlayerDamage", function( ply, hitGroup, dmginfo )
		local atk = dmginfo:GetAttacker()
		local inf = dmginfo:GetInflictor()
		if ply:HasPerk( "TANIII") then
			dmginfo:ScaleDamage( 0.7 )
		end
	end},
	["Fleet of Foot III"] = { "FleetFootIII", "Run 35% faster.", "vgui/perks/default.png", 30, "TTTPlayerSpeed", function( ply, slowed )
		if ply:HasPerk( "FleetFootIII" ) then
			return 1.35
		end
	end},
	["Regeneration"] = {"Regeneration", "Recover 1hp per second.", "vgui/perks/default.png", 30, "Think", function( )
		if CurTime() > regen_delay then
			for k,v in pairs( player.GetAll() ) do
				if v:HasPerk( "Regeneration" ) then
					if v:Health() ~= v:GetMaxHealth() then
						v:SetHealth( math.min( v:GetMaxHealth(), v:Health()+1) )
					end
				end
			end
			regen_delay = CurTime() + 1
		end
	end},
	["Regeneration II"] = {"RegenerationII", "Recover 2hp per second.", "vgui/perks/default.png", 36, "Think", function( )
		if CurTime() > regen_delay2 then
			for k,v in pairs( player.GetAll() ) do
				if v:HasPerk( "RegenerationII" ) then
					if v:Health() ~= v:GetMaxHealth() then
						v:SetHealth( math.min( v:GetMaxHealth(), v:Health()+2) )
					end
				end
			end
			regen_delay2 = CurTime() + 1
		end
	end},
	["Regeneration III"] = {"RegenerationIII", "Recover 3hp per second.", "vgui/perks/default.png", 1, "Think", function( )
		if CurTime() > regen_delay3 then
			for k,v in pairs( player.GetAll() ) do
				if v:HasPerk( "RegenerationIII" ) then
					if v:Health() ~= v:GetMaxHealth() then
						v:SetHealth( math.min( v:GetMaxHealth(), v:Health()+3 ) )
					end
				end
			end
			regen_delay3 = CurTime() + 1
		end
	end, "STEAM_0:0:29377055" },
	["Philosopher's Reprieve"] = {"PR", "While under 30 hp, deal 80% more damage.", "vgui/perks/default.png", 1, "ScalePlayerDamage", function( ply, hitGroup, dmginfo )
		local atk = dmginfo:GetAttacker()
		local inf = dmginfo:GetInflictor()
		if IsValid( atk ) and atk:IsPlayer() then
			if atk:HasPerk( "PR" ) and atk:Health() < 30 then
				dmginfo:ScaleDamage( 1.8 )
			end 
		end
	end, "STEAM_0:1:60690047"},
	["Sanic"] = {"Sanic", "Move at 200% move speed.", "vgui/perks/default.png", 1, "TTTPlayerSpeed", function( ply )
		if ply:HasPerk( "Sanic" ) then
			return 2
		end
	end, "STEAM_0:0:61471982"},

	["Energy Shield"] = {"EEShield", "A powerful energy shield surrounds the user. Absorbs up to 35 damage and recharges over time.", "vgui/perks/default.png", 1, "PlayerSpawn", function( ply )
		if ply:HasPerk( "EEShield" ) then
			ply:SetUpEnergyShield( 35, 5 )
		end
	end, "STEAM_0:0:41006378"},

	["Mouse Blessing"] = {"MBlessing", "Move 55% faster, but health is capped at 75.", "vgui/perks/default.png", 40, {"TTTPlayerSpeed", "TTTBeginRound"}, {
	function( ply )
		if ply:HasPerk( "MBlessing" ) then
			return 1.55
		end
	end,
	function( ply )
		timer.Simple(0.5,function()
			for k,v in pairs( player.GetAll() ) do  
				if v:HasPerk( "MBlessing" ) then
					v:SetHealth( 75 )
					v:SetMaxHealth( 75 )
				end
			end
		end)
	end} }
}

function GetPerkList()
	return PERKS
end

if SERVER then
	for k,v in pairs( PERKS ) do
		if istable( v[ 5 ] ) then
			for i = 1,#v[ 5 ] do
				hook.Add( v[ 5 ][ i ], v[ 1 ], v[ 6 ][ i ] )
			end
		else
			hook.Add( v[ 5 ], v[ 1 ], v[ 6 ] )
		end
	end
end
*/