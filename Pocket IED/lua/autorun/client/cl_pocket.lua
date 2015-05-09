
function DrawHalos()
	/*
	local targets = {}
	for k,v in pairs( player.GetAll() ) do
		if v:IsTraitor() then
			if IsValid( v:GetNWEntity( "IEDTarget" ) ) then
				table.insert( targets, v:GetNWEntity( "IEDTarget" ) )
			end
		end
	end
	
	halo.Add( targets, Color( 255, 50, 50, 255 ), 12, 12 , 3, true, false )
	*/
end
hook.Add("PreDrawHalos", "Draw IED Targets", DrawHalos )

surface.CreateFont( "trap_smooth", { font = "Trebuchet18", size = 18, weight = 700, antialias = true } )

function EntCanSee( ent, targ ,isPlayer )
	local trd = {}
	local start = ent:GetShootPos()
	local _end
	
	if isPlayer == true then
		_end = targ:GetShootPos()
	else
		_end = targ:GetPos()
	end
	
	trd.start = start
	trd.endpos = _end
	trd.filter = {ent}
	trd.mask = MASK_SOLID
	local tr = util.TraceLine(trd)
	
	if tr.Entity == targ then
		return true
	end
return false
end

function IEDHUD()
	/*
	if not IsValid(LocalPlayer()) then return end
	for k,v in pairs( player.GetAll() ) do
		if v:IsTraitor() then
			if IsValid( v:GetNWEntity( "IEDTarget" ) ) and v:GetNWEntity( "IEDTarget" ):IsPlayer() and v:GetNWEntity( "IEDTarget" ):Alive() then 
			
					local targ = v:GetNWEntity( "IEDTarget" ) 

					
					if EntCanSee( v, targ, true ) then	
						local pos = targ:GetPos()
						local scrpos = ( pos + Vector(0,0,80) ):ToScreen()
						local width,height = 110,50
						
						scrpos.x = math.Clamp(scrpos.x, width/2, ScrW() - width/2)
						scrpos.y = math.Clamp(scrpos.y, height/2, ScrH() - height/2)
						
						surface.SetDrawColor(Color(225,25,25,200))
						surface.DrawRect(scrpos.x - width/2,scrpos.y - height/2,width,height)
						
						surface.SetFont("trap_smooth")
						
						local w,h = surface.GetTextSize( "IED Target" )
						
						surface.SetTextColor(Color(255,255,255,255))
						surface.SetTextPos(scrpos.x -w/2 , scrpos.y - h/2 )
						surface.DrawText("IED Target")
					end
					
			elseif IsValid(v:GetNWEntity( "IEDTarget" )) then
			
				local targ = v:GetNWEntity( "IEDTarget" ) 
					
				if EntCanSee( v, targ, false ) then	
					local pos = targ:GetPos()
					local scrpos = ( pos ):ToScreen()
					local width,height = 110,50
						
					scrpos.x = math.Clamp(scrpos.x, width/2, ScrW() - width/2)
					scrpos.y = math.Clamp(scrpos.y, height/2, ScrH() - height/2)
						
					surface.SetDrawColor(Color(225,25,25,200))
					surface.DrawRect(scrpos.x - width/2,scrpos.y - height/2,width,height)
						
					surface.SetFont("trap_smooth")
						
					local w,h = surface.GetTextSize( "IED Target" )
						
					surface.SetTextColor(Color(255,255,255,255))
					surface.SetTextPos(scrpos.x -w/2 , scrpos.y - h/2 )
					surface.DrawText("IED Target")
				end	
			end
		end
	end
	*/
end
hook.Add("HUDPaint", "Draw IED HUD", IEDHUD )