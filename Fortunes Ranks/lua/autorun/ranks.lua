timer.Simple( 5, function() 
	local PLY = FindMetaTable('Player')


	if SERVER then

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

	AddDir( "materials/vgui/ranks" )

		hook.Add("PlayerInitialSpawn", "belg", function( ply )
			if not ply:GetPData("XP",0) then
				ply:SetPData("XP", 0 )
			end
			ply:SetNWInt("XP", ply:GetPData("XP") )
		end)
	end

	RANKS = {}
	RANKS.LIST = {
	{"Recruit", 0, Material( "vgui/ranks/recruit.png", "noclamp smooth")},
	{"Private", 750, Material( "vgui/ranks/private.png", "noclamp smooth")},
	{"Corporal", 1000, Material( "vgui/ranks/corporal.png", "noclamp smooth")},
	{"Corporal I", 1500, Material( "vgui/ranks/corporal_1.png", "noclamp smooth")},
	{"Sergeant", 2000, Material( "vgui/ranks/sergeant.png", "noclamp smooth")},
	{"Sergeant I", 2625, Material( "vgui/ranks/sergeant_1.png", "noclamp smooth")},
	{"Sergeant II", 3250, Material( "vgui/ranks/sergeant_2.png", "noclamp smooth")},
	{"Warrant Officer", 4500, Material( "vgui/ranks/warrant.png", "noclamp smooth")},
	{"Warrant Officer I", 7800, Material( "vgui/ranks/warrant_1.png", "noclamp smooth")},
	{"Warrant Officer II", 11000, Material( "vgui/ranks/warrant_2.png", "noclamp smooth")},
	{"Warrant Officer III", 14400, Material( "vgui/ranks/warrant_3.png", "noclamp smooth")},
	{"Captain", 21000, Material( "vgui/ranks/captain.png", "noclamp smooth") },
	{"Captain I", 23300, Material( "vgui/ranks/captain_1.png", "noclamp smooth")},
	{"Captain II", 25600, Material( "vgui/ranks/captain_2.png", "noclamp smooth")},
	{"Captain III", 27900, Material( "vgui/ranks/captain_3.png", "noclamp smooth")},
	{"Major", 32500, Material( "vgui/ranks/major.png", "noclamp smooth")},
	{"Major I", 35000, Material( "vgui/ranks/major_1.png", "noclamp smooth")},
	{"Major II", 37500, Material( "vgui/ranks/major_2.png", "noclamp smooth")},
	{"Major III", 40000, Material( "vgui/ranks/major_3.png", "noclamp smooth")},
	{"Lt Colonel", 45000, Material( "vgui/ranks/ltcolonel.png", "noclamp smooth")},
	{"Lt Colonel I", 48000, Material( "vgui/ranks/ltcolonel_1.png", "noclamp smooth")},
	{"Lt Colonel II", 51000, Material( "vgui/ranks/ltcolonel_2.png", "noclamp smooth")},
	{"Lt Colonel III", 54000, Material( "vgui/ranks/ltcolonel_3.png", "noclamp smooth") },
	{"Commander", 60000, Material( "vgui/ranks/commander.png", "noclamp smooth")},
	{"Commander I", 65000, Material( "vgui/ranks/commander_1.png", "noclamp smooth")},
	{"Commander II", 70000, Material( "vgui/ranks/commander_2.png", "noclamp smooth")},
	{"Commander III", 75000, Material("vgui/ranks/commander_3.png", "noclamp smooth")},
	{"Colonel", 85000, Material( "vgui/ranks/colonel.png", "noclamp smooth")},
	{"Colonel I", 96000, Material( "vgui/ranks/colonel_1.png", "noclamp smooth")},
	{"Colonel II", 107000, Material( "vgui/ranks/colonel_2.png", "noclamp smooth")},
	{"Colonel III", 118000, Material( "vgui/ranks/colonel_3.png", "noclamp smooth")},
	{"Brigadier", 140000, Material( "vgui/ranks/brigadier.png", "noclamp smooth")},
	{"Brigadier I", 152000, Material( "vgui/ranks/brigadier_1.png", "noclamp smooth")},
	{"Brigadier II", 164000, Material( "vgui/ranks/brigadier_2.png", "noclamp smooth")},
	{"Brigadier III", 176000, Material( "vgui/ranks/brigadier_3.png", "noclamp smooth")},
	{"General", 200000, Material( "vgui/ranks/general.png", "noclamp smooth")},
	{"General I", 220000, Material( "vgui/ranks/general_1.png", "noclamp smooth")},
	{"General II", 235000, Material( "vgui/ranks/general_2.png", "noclamp smooth")},
	{"General II", 235000, Material( "vgui/ranks/general_2.png", "noclamp smooth")},
	{"General IV", 265000, Material( "vgui/ranks/general_4.png", "noclamp smooth")},
	{"Field Marshall", 300000, Material( "vgui/ranks/marshall.png", "noclamp smooth")},
	{"Hero", 370000, Material( "vgui/ranks/hero.png", "noclamp smooth")},
	{"Legend", 460000, Material( "vgui/ranks/legend.png", "noclamp smooth")},
	{"Mythic", 565000, Material( "vgui/ranks/mythic.png", "noclamp smooth")},
	{"Noble", 700000, Material( "vgui/ranks/noble.png", "noclamp smooth")},
	{"Eclipse", 850000, Material( "vgui/ranks/eclipse.png", "noclamp smooth")},
	{"Nova", 1100000, Material( "vgui/ranks/nova.png", "noclamp smooth")},
	{"ForeRunner", 1300000, Material( "vgui/ranks/forerunner.png", "noclamp smooth")},
	{"Reclaimer", 1650000, Material( "vgui/ranks/reclaimer.png", "noclamp smooth")},
	{"Inheritor", 2000000, Material( "vgui/ranks/inheritor.png", "noclamp smooth")},
	}

	if SERVER then
		util.AddNetworkString("XPNotification")
		util.AddNetworkString("SyncXP")
		
		net.Receive( "ReactionTime", function( len, ply )
			local time = net.ReadFloat()
			
			if time < tonumber(ply:GetNWFloat("ReactionTime")) then
				ply:SetNWFloat("ReactionTime", time )
				ply:SetPData("ReactionTime", time )
			end
		end)
		
		function PLY:SyncXP()
			self:SetPData("XP", self:GetNWInt("XP") )
			net.Start("SyncXP")
				net.WriteInt( self:GetNWInt("XP"), 128 )
			net.Send( self )
		end
		
		function PLY:SyncRoundData()
			self:SetPData("Rounds", self:GetNWInt("Rounds") )
			self:SetPData("Wins", self:GetNWInt("Wins") )
			net.Start("SyncRoundData")
				net.WriteInt( self:GetNWInt("Rounds"), 132 )
				net.WriteInt( self:GetNWInt("Wins"), 128 )
			net.Send( self )
		end
		
		function PLY:SetXP( num )
			self:SetPData("XP", 0 )
			self:SyncXP()
		end
		

		function PLY:GiveXP( num, reason )
			self:SetNWInt("XP", self:GetNWInt("XP") + num )
			net.Start("XPNotification")
				net.WriteInt( num, 32 )
				net.WriteString( reason )
			net.Send( self )
			self:SyncXP()
		end

		local XpRewards = --{Victim, Attacker. Reward, Reason}
		{
			{ ROLE_DETECTIVE, ROLE_TRAITOR, 200, "You killed a Detective!" },
			{ ROLE_TRAITOR, ROLE_DETECTIVE, 250, "You killed a Traitor!"},
			{ ROLE_INNOCENT, ROLE_TRAITOR, 75, "You killed an innocent!" },
			{ ROLE_TRAITOR, ROLE_INNOCENT, 200, "You killed a Traitor!" },
			{ ROLE_INNOCENT, ROLE_INNOCENT, 0, "You killed an innocent... as an innocent!" },
			{ ROLE_TRAITOR, ROLE_TRAITOR, 0, "You killed a traitor... as a traitor! Dumbass! :D" },
			{ ROLE_DETECTIVE, ROLE_DETECTIVE, 0, "You killed a fellow detective... :/" }
		}
		function CalculateXP( vic, atk, dmginfo )
			for k,v in pairs( XpRewards ) do
				if v[1] == vic:GetRole() and v[2] == atk:GetRole() then
					return {v[3], v[4]}
				end
			end
		end

		hook.Add( "DoPlayerDeath", "XPCalculations", function( ply, atk, dmginfo )
			/*
			if atk == ply then return end
			
			if atk:IsPlayer() then
				if not atk.XPRewards then atk.XPRewards = {} end
				atk.XPRewards[#atk.XPRewards+1] = CalculateXP(ply, atk, dmginfo)
				PrintTable( atk.XPRewards )
			end
			*/
		end)

		hook.Add( "TTTEndRound", "GiveXPRewards", function()
			for k,v in pairs( player.GetAll() ) do 
				if v.XPRewards then
					PrintTable( v.XPRewards )
					for i = 1,#v.XPRewards do
						v:GiveXP( unpack( v.XPRewards[i] ) )
						v:SyncXP()
					end
					v.XPRewards = {}
				end
			end
		end)

		concommand.Add( "FixMyLevel", function( ply )
			if ply:IsSuperAdmin() and ply:GetPData("XPGiven") != 1 then
				ply:GiveXP( 70000, "Ayyyy" )
				ply:SetPData("XPGiven", 1)
			end
		end)

	end


	function PLY:GetXP()
		return tonumber(self:GetNWInt("XP" ,0))
	end


	function PLY:GetRank()
		for k,v in pairs( RANKS.LIST ) do
			if self:GetXP() < v[2] then
				return RANKS.LIST[k-1][1], k-1, RANKS.LIST[k-1][3]
			end
		end
	return "King of Deathrun", #RANKS.LIST
	end

	function PLY:GetRankNumber()
		for k,v in pairs( RANKS.LIST ) do
			if self:GetXP() < v[2] then
				return k-1
			end
		end
	end

	function PLY:GetXPToNextRank()
		for k,v in pairs( RANKS.LIST ) do
			if self:GetXP() < v[2] then
				return v[2] - RANKS.LIST[k-1][2]
			end
		end
	return 0
	end

	function PLY:GetNextRankXP()
		local _,pos = self:GetRank()
		pos = math.Clamp( pos + 1, 1, #RANKS.LIST )
		return RANKS.List[pos][2]
	end

	function PLY:GetNextRankXP()
		for k,v in pairs( RANKS.LIST ) do
			if self:GetXP() < v[2] then
				return v[2]
			end
		end
	end

	function PLY:GetRelativeXP()
		local _,pos = self:GetRank()
		return ( self:GetXP() - RANKS.LIST[pos][2])
	end

	function PLY:GetXPPercentage()
		local _,pos = self:GetRank()
		return ( self:GetXP() - RANKS.LIST[pos][2])/self:GetXPToNextRank()
	end

	if CLIENT then

		surface.CreateFont( "Deathrun_SmoothBig", { font = "Trebuchet18", size = 34, weight = 700, antialias = true } )
		net.Receive( "SyncXP", function( len )
			local ply = LocalPlayer()
			ply:SetPData("XP", net.ReadInt( 128 ) )
		end)
		
		net.Receive("XPNotification", function( len )
		
			local xp = net.ReadInt( 32 )
			local reason = net.ReadString()
			local ply = LocalPlayer()
			local add = 4
			
			if not ply.xp_n or ply.xp_n and #ply.xp_n == 0 then
				ply.xp_n_delay = CurTime() + 4
				ply.xp_n = {{ xp, reason }}
			else
				table.insert( ply.xp_n, #ply.xp_n+1, {xp, reason} ) 
			end
		end)
		
		hook.Add("HUDPaint", "XP Notification", function()
			local ply = LocalPlayer()
			
			if ply.xp_n and #ply.xp_n > 0 then
				if not ply.xp_label then
					ply.xp_label = vgui.Create("DPanel")
					ply.xp_label:SetSize( 275, 50 )
					ply.xp_label:SetPos( -ply.xp_label:GetWide(),(ScrH()*0.3) )
					ply.xp_label.Paint = function( stuff, w, h )
						surface.SetDrawColor( Color(33,33,33,230) )
						surface.DrawRect( 0, 0, w, h )
						
						surface.SetFont("Deathrun_SmoothBig")
						local _, y_sz = surface.GetTextSize( ply.xp_n[1][2] )
						
						surface.SetFont("Deathrun_SmoothBig")
						local x_sz,_ = surface.GetTextSize( "+"..ply.xp_n[1][1].."XP, "..ply.xp_n[1][2] )
						
						if x_sz > w-90 then
							ply.xp_label:SetWide( x_sz + 70 )
						end
						
						draw.AAText( "+"..ply.xp_n[1][1].."XP, "..ply.xp_n[1][2], "Deathrun_SmoothBig", 35, ply.xp_label:GetTall()/2 - y_sz/2, Color(255,255,255,255), TEXT_ALIGN_LEFT )
					end
					ply.xp_label:MoveTo( -25,(ScrH()*0.3), 0.3, 0, 0.4 )
					timer.Simple( 2.25, function()
						if IsValid( ply ) then
							ply.xp_label:MoveTo( 0,(ScrH()*0.3), 0.3, 0, 0.5 )
						end
					end)
					timer.Simple( 2.55, function()
						if IsValid( ply ) then
							ply.xp_label:MoveTo( -ply.xp_label:GetWide(), (ScrH()*0.3), 0.6, 0, 0.4 )
						end
					end)
				end
			end
		end)
		
		hook.Add("Think", "CleanUpXPNotificationsTable", function()
			local ply = LocalPlayer()
			
			if not ply.xp_n then return end
			
			if #ply.xp_n > 0 then
				if CurTime() > ply.xp_n_delay then
					table.remove( ply.xp_n, 1 )
					ply.xp_n_delay = CurTime() + 4
					ply.xp_label:Remove()
					ply.xp_label = nil
				end
			end
			
		end)
		
	end
end)
