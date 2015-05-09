
function DrawPLMS()
	local targets = {}
	for k,v in pairs( player.GetAll() ) do
		if IsValid( v:GetNWEntity( "PLMTarget" ) ) then
			if v == LocalPlayer() then
				if v:Alive() and v:GetActiveWeapon():GetClass() == "weapon_ttt_plm" then
					local targ = v:GetNWEntity( "PLMTarget" ) 
					if targ:IsPlayer() then
							halo.Add( {targ,targ:GetActiveWeapon()}, Color( 255*(1-(targ:Health()/targ:GetMaxHealth())), 255*(targ:Health()/targ:GetMaxHealth()), 50, 255 ), 2, 2 , 3, true, true )
					else
						halo.Add( {targ}, Color( 255,255,255,255 ), 2, 2 , 3, true, true )
					end
				end
			end
		end
	end
end
hook.Add("PreDrawHalos", "Draw PLM Targets", DrawPLMS )

surface.CreateFont( "trap_smooth", { font = "Trebuchet18", size = 18, weight = 700, antialias = true } )


function PLMHUD()
	if not IsValid(LocalPlayer()) then return end
	for k,v in pairs( player.GetAll() ) do
		if IsValid( v:GetNWEntity( "PLMTarget" ) ) then 
			if v == LocalPlayer() then
				if v:Alive() and v:GetActiveWeapon():GetClass() == "weapon_ttt_plm" then
					
					if v:GetNWEntity( "PLMTarget" ):IsPlayer() then
						local targ = v:GetNWEntity( "PLMTarget" ) 

						local pos = targ:GetPos()
						local scrpos = ( pos + Vector(0,0,70) ):ToScreen()
						local width,height = 110,17
									
						scrpos.x = math.Clamp(scrpos.x, width/2, ScrW() - width/2)
						scrpos.y = math.Clamp(scrpos.y, height/2, ScrH() - height/2)
						
						local hp_p = (targ:Health()/targ:GetMaxHealth())
									
						local col = Color( 255*(1-hp_p), 200*hp_p, 50, 255 )
						local col_b = Color( 255*(1-hp_p), 200*hp_p, 50, 35 )
						draw.RoundedBox( 8, scrpos.x - width/2, scrpos.y - height/2, width, height, col_b )
						draw.RoundedBox( 8, scrpos.x - width/2, scrpos.y - height/2, width*hp_p, height, col )
									
						surface.SetFont("trap_smooth")
									
						local text = "Health: "..targ:Health()
						local w,h = surface.GetTextSize( text )
									
						surface.SetTextColor(Color(255,255,255,255))
						surface.SetTextPos(scrpos.x -w/2 , scrpos.y - h/2 )
						surface.DrawText( text )
					else
					
						local targ = v:GetNWEntity( "PLMTarget" ) 

						local pos = targ:GetPos()
						local scrpos = ( pos + Vector(0,0,15) ):ToScreen()
						local width,height = 110,17
									
						scrpos.x = math.Clamp(scrpos.x, width/2, ScrW() - width/2)
						scrpos.y = math.Clamp(scrpos.y, height/2, ScrH() - height/2)
						
									
						local col = Color( 175, 175, 175, 255 )
						draw.RoundedBox( 8, scrpos.x - width/2, scrpos.y - height/2, width, height, col )
									
						surface.SetFont("trap_smooth")
									
						local text = "Deceased"
						local w,h = surface.GetTextSize( text )
									
						surface.SetTextColor(Color(255,255,255,255))
						surface.SetTextPos(scrpos.x -w/2 , scrpos.y - h/2 )
						surface.DrawText( text )
						
					end
				end
			end
		end
	end
end
hook.Add("HUDPaint", "Draw PLM HUD", PLMHUD )
