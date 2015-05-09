
function AddDir(directory)
	local files, folders = file.Find(directory.."/*", "GAME")
	for _, dir in pairs(folders) do
		if dir != ".svn" then
			AddDir(directory.."/"..dir)
		end
	end
	for k,v in pairs(files) do
		resource.AddFile(directory.."/"..v)
	end
end

AddDir( "materials/vgui/perks" )

util.AddNetworkString( "UpdatePlayerModel" )
util.AddNetworkString( "UpdatePrimary" )
util.AddNetworkString( "UpdateSecondary" )
util.AddNetworkString( "UpdatePerk" )
util.AddNetworkString( "PurchaseUpgrade" )

if not file.Exists( "discrete_settings", "DATA" ) then
	file.CreateDir( "discrete_settings", "DATA" )
end

hook.Add( "OnDiscreteSettingsChanged", "UpdateSaves", function( ply )
	ply:SaveDiscreteSettings()
end)


hook.Add("ShowSpare1", "Discrete F3", function(ply)
	ply:ConCommand("discrete_menu")
	hook.Call( "OnDiscreteSettingsChanged", GAMEMODE, ply )
end)

hook.Add( "PlayerInitialSpawn", "SetUpDiscreteSettings", function( ply )
	ply:LoadDiscreteSettings()
end)

net.Receive( "UpdatePlayerModel", function( len, ply )
	local model = net.ReadString()
	ply.DiscreteSettings[ 1 ] = model
	hook.Call( "OnDiscreteSettingsChanged", GAMEMODE, ply )
end)

net.Receive( "UpdatePrimary", function( len, ply )
	local primary = net.ReadString()
	ply.DiscreteSettings[ 2 ] = primary
	hook.Call( "OnDiscreteSettingsChanged", GAMEMODE, ply )
end)

net.Receive( "UpdateSecondary", function( len, ply ) 
	local secondary = net.ReadString()
	ply.DiscreteSettings[ 3 ] = secondary
	hook.Call( "OnDiscreteSettingsChanged", GAMEMODE, ply )
end)

net.Receive( "UpdatePerk", function( len, ply ) 
	local perk = net.ReadTable()
	ply.DiscreteSettings[ 4 ] = perk
	hook.Call( "OnDiscreteSettingsChanged", GAMEMODE, ply )
end)

net.Receive( "PurchaseUpgrade", function( len, ply )
	local tbl = net.ReadTable()
	local weapon = tbl[ 1 ]
	local upgrades = tbl[ 2 ]
	local cost = tbl[ 3 ]
	
	for k,v in pairs( ply:GetWeapons() ) do
		if v == weapon then
			v:ApplyUpgrades( upgrades )
		end
	end
	ply:AddCredits( -cost )
end)

local PLY = FindMetaTable( "Player" )

function PLY:DiscreteSetUp( tbl )
	for k, v in pairs( tbl ) do
		if k == 1 then
			if tbl[ 1 ] then
				self:SetModel( tbl[ 1 ] )
			end
		elseif k == 2 then
			 if tbl[ 2 ] then
				self:Give( tbl[ 2 ] )
			 end
		elseif k == 3 then
			if tbl[ 3 ] then
				self:Give( tbl[ 3 ] )
			end
		end
	end
end

function PLY:LoadDiscreteSettings()
	local file_path = "discrete_settings/"..self:SteamID64()..".txt"
	if file.Exists( file_path, "DATA" ) then
		local tbl = file.Read( file_path )
		self.DiscreteSettings = util.JSONToTable( tbl )
	else
		self.DiscreteSettings = {}
		self:SaveDiscreteSettings()
	end
end

function PLY:SaveDiscreteSettings()
	file.Write( "discrete_settings/"..self:SteamID64()..".txt", util.TableToJSON( self.DiscreteSettings ) )
end

hook.Add( "TTTPrepareRound", "Apply Discrete Settings", function()
	timer.Simple( 5, function()
		for k,v in pairs( player.GetAll() ) do
			if IsValid( v ) and v:Alive() and not v:IsSpec() then
				v:DiscreteSetUp( v.DiscreteSettings )
			end
		end
	end)
end)
	
	