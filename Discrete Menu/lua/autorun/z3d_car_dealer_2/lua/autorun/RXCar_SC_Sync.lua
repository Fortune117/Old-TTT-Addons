local meta = FindMetaTable("Player")

if SERVER then -- Shop Open
	util.AddNetworkString( "RXCAR_OpenShop_S2C" )
	function meta:RXCar_OpenShop(ShopEnt)
		net.Start( "RXCAR_OpenShop_S2C" )
			net.WriteEntity(ShopEnt)
		net.Send(self)
	end
else
	net.Receive( "RXCAR_OpenShop_S2C", function( len,ply )
		D3DCarDealer_Open(net.ReadEntity())
	end)
end

if SERVER then -- Notice
	util.AddNetworkString( "RXCAR_Notice_S2C" )
	function meta:Send3DShopNotice(txt)
		net.Start( "RXCAR_Notice_S2C" )
			net.WriteString(txt)
		net.Send(self)
	end
else
	function RXCar_ShowNotice(txt)
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
		Button_FreeCam:SetPos(D3DNoticePanel:GetWide()/2-100,D3DNoticePanel:GetTall()/3*2)
		Button_FreeCam:SetSize(200,30)
		Button_FreeCam:SetTexts("Okay")
		Button_FreeCam.Click = function(slf)
			D3DNoticePanel:Remove()
			D3DNoticePanel = nil
		end
	end
	net.Receive( "RXCAR_Notice_S2C", function( len,ply )
		local txt = net.ReadString()
		RXCar_ShowNotice(txt)
	end)
end

if SERVER then -- Buy Car into inventory
	util.AddNetworkString( "RXCar_BuyCar_C2S" )
	net.Receive( "RXCar_BuyCar_C2S", function( len,ply )
		local CarVehicleName = net.ReadString()
		if !ply:RXCar_PlayerCanBuyCar(CarVehicleName) then return end
		
		ply:RXCar_BuyAndStore(CarVehicleName)
	end)
else
	function RXCar_BuyIntoInventory(CarVehicleName)
		net.Start( "RXCar_BuyCar_C2S" )
			net.WriteString(CarVehicleName)
		net.SendToServer()
	end
end

if SERVER then -- Sync Inventory
	util.AddNetworkString( "RXCar_INVSync_S2C" )
	function meta:RXCar_SyncInv(DataOverride)
		RXCar_Provider_GetInventory(self:SteamID(),function(InventoryData)
			local Data2Send = DataOverride or InventoryData
			net.Start( "RXCar_INVSync_S2C" )
				net.WriteString(util.TableToJSON(Data2Send))
			net.Send(self)
		end)
	end
else
	net.Receive( "RXCar_INVSync_S2C", function( len,ply )
		local DATA = util.JSONToTable(net.ReadString())
		RX3DCar_Inventory = DATA
		hook.Run("RXCar_InvAdjusted")
	end)
end

if SERVER then -- Refund Stored Car
	util.AddNetworkString( "RXCar_RefundStoredCar_C2S" )
	net.Receive( "RXCar_RefundStoredCar_C2S", function( len,ply )
		local CarUID = net.ReadString()
		CarUID = tonumber(CarUID)
		
		ply:RXCar_RefundStoredCar(CarUID)
	end)
else
	function RXCar_RefundStoredCar(CarUID)
		net.Start( "RXCar_RefundStoredCar_C2S" )
			net.WriteString(CarUID)
		net.SendToServer()
	end
end

if SERVER then -- Update Tune into server inventory
	util.AddNetworkString( "RXCar_UpdateTuneData_C2S" )
	net.Receive( "RXCar_UpdateTuneData_C2S", function( len,ply )
		local DB = net.ReadString()
		DB = util.JSONToTable(DB)
		local UID = DB.UID
		local TuneData = DB.TuneData
		
		RXCar_Provider_GetInventory(ply:SteamID(),function(InventoryData)
			if !InventoryData[UID] then
				ply:Send3DShopNotice("There was an error. please try again later")
				return
			end
			
			InventoryData[UID].TuneData = TuneData
			
			RXCar_Provider_SaveInventory(ply:SteamID(),InventoryData,function(Done)
				ply:Send3DShopNotice("New Tuning data is updated.")
				ply:RXCar_SyncInv(InventoryData)
			end)
		end)
	end)
else
	function RXCar_UpdateTuneData(UID,TuneData)
		net.Start( "RXCar_UpdateTuneData_C2S" )
			net.WriteString(util.TableToJSON({UID=UID,TuneData=TuneData}))
		net.SendToServer()
	end
end
