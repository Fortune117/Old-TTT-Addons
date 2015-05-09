concommand.Add("RXCar_GetMyPos",function(ply,cmd,args)
	local Pos = ply:GetPos()
	
	MsgN("table.insert(D3DCarConfig.SpawnSpots,Vector(" .. Pos.x .. "," .. Pos.y .. "," .. Pos.z .. "))")
end)


function RXCar_ShowAsker(txt,AgreeCallback,DenyCallback)
	if D3DNoticePanel and D3DNoticePanel:IsValid() then
		D3DNoticePanel:Remove()
		D3DNoticePanel = nil
	end	
		D3DNoticePanel = vgui.Create("DPanel")
		D3DNoticePanel:SetSize(ScrW(),ScrH())
		D3DNoticePanel.Paint = function(slf)
			surface.SetDrawColor( Color(0,0,0,200) )
			surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
				
			draw.SimpleText(txt, "RXCarFont_Treb_S30", ScrW()/2,ScrH()/2, Color(0,255,255,255), TEXT_ALIGN_CENTER)
		end
		D3DNoticePanel:MakePopup()

		
	local Button_FreeCam = vgui.Create("RXCAR_DSWButton",D3DNoticePanel)
	Button_FreeCam:SetPos(D3DNoticePanel:GetWide()/2-220,D3DNoticePanel:GetTall()/3*2)
	Button_FreeCam:SetSize(200,30)
	Button_FreeCam:SetTexts("Okay")
	Button_FreeCam.Click = function(slf)
		D3DNoticePanel:Remove()
		D3DNoticePanel = nil
		if AgreeCallback then AgreeCallback() end
	end
	local Button_FreeCam = vgui.Create("RXCAR_DSWButton",D3DNoticePanel)
	Button_FreeCam:SetPos(D3DNoticePanel:GetWide()/2+20,D3DNoticePanel:GetTall()/3*2)
	Button_FreeCam:SetSize(200,30)
	Button_FreeCam:SetTexts("Deny")
	Button_FreeCam.Click = function(slf)
		D3DNoticePanel:Remove()
		D3DNoticePanel = nil
		if DenyCallback then DenyCallback() end
	end
	
end