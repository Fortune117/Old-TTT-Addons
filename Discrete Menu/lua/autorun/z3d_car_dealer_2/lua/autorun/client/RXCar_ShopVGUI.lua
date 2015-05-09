local meta = FindMetaTable("Player");

hook.Add("RXCar_InvAdjusted","Inventory Update",function()
	if D3DCarShopPanel and D3DCarShopPanel:IsValid() then
		if D3DCarShopPanel.Canvas and D3DCarShopPanel.Canvas:IsValid() then
			if D3DCarShopPanel.Canvas.CarList and D3DCarShopPanel.Canvas.CarList:IsValid() and D3DCarShopPanel.Canvas.CarList.CarInventoryList then
				D3DCarShopPanel.Canvas.CarList:UpdateList()
			end
		end
	end
end)

function D3DCarDealer_Get3DWorldCamAngle()
	if D3DCarShopPanel and D3DCarShopPanel:IsValid() then
		if D3DCarShopPanel.BGBackGroundPanel and D3DCarShopPanel.BGBackGroundPanel:IsValid() then
			return D3DCarShopPanel.BGBackGroundPanel.CamAngle
		end
	end
end

function D3DCarDealer_Open(SellerNPC)
	LoadRXTuner()
	if D3DCarShopPanel and D3DCarShopPanel:IsValid() then
		D3DCarShopPanel:Remove()
		D3DCarShopPanel = nil
	end
		
	D3DCarShopPanel = vgui.Create("D3D_CarShop")
	D3DCarShopPanel:SetPos(0,0)
	D3DCarShopPanel:SetSize(ScrW(),ScrH())
	D3DCarShopPanel.SellerNPC = SellerNPC
	D3DCarShopPanel:Install()
	D3DCarShopPanel:MakePopup()
	
	return D3DCarShopPanel
end

if CLIENT then -- PANEL : D3D_CarShop

local PANEL = {}
RXCarPanel_Tuner = PANEL
function PANEL:Init()
	self:ShowCloseButton(true)
	self:SetTitle(" ")
	self:SetDraggable(false)
	self:ShowCloseButton(false)
end

function PANEL:ReBulidCanvas()
	if self.Canvas and self.Canvas:IsValid() then
		self.Canvas:Remove()
		self.Canvas = nil
	end
		self.Canvas = vgui.Create("DPanel",self)
		self.Canvas:SetPos(0,self.TopPanel:GetTall())
		self.Canvas:SetSize(self:GetWide(),self:GetTall() - self.TopPanel:GetTall())
		self.Canvas.Paint = function(slf)
		
		end
	return self.Canvas
end

function PANEL:Think()
	if input.IsKeyDown( KEY_ESCAPE ) then
		self:Remove()
		return
	end
end

function PANEL:FreeCamMode()

	local Canvas = self:ReBulidCanvas()
	Canvas.Name = "Free Cam"
	Canvas.CantSpin = true
	
	Canvas.Paint = function(slf)
		local Speed = 1
		
		if input.IsKeyDown(KEY_LSHIFT) then
			Speed = Speed * 2
		end
		if input.IsKeyDown(KEY_W) then
			self.BGBackGroundPanel.CamPos = self.BGBackGroundPanel.CamPos + self.BGBackGroundPanel.CamAngle:Forward() *Speed
		end
		if input.IsKeyDown(KEY_S) then
			self.BGBackGroundPanel.CamPos = self.BGBackGroundPanel.CamPos - self.BGBackGroundPanel.CamAngle:Forward() *Speed
		end
		if input.IsKeyDown(KEY_A) then
			self.BGBackGroundPanel.CamPos = self.BGBackGroundPanel.CamPos - self.BGBackGroundPanel.CamAngle:Right() *Speed
		end
		if input.IsKeyDown(KEY_D) then
			self.BGBackGroundPanel.CamPos = self.BGBackGroundPanel.CamPos + self.BGBackGroundPanel.CamAngle:Right() *Speed
		end
		if input.IsKeyDown(KEY_SPACE) then
			self.BGBackGroundPanel.CamPos = self.BGBackGroundPanel.CamPos + self.BGBackGroundPanel.CamAngle:Up() *Speed
		end

		if input.IsMouseDown(MOUSE_LEFT) then
			if !self.LM then
				self.LM = true
				local MX,MY = gui.MousePos()
				self.LastMousePos_X = MX
				self.LastMousePos_Y = MY
			else
				local CX,CY = gui.MousePos()
				local DX,DY = self.LastMousePos_X-CX,self.LastMousePos_Y-CY
				
				self.BGBackGroundPanel.CamAngle.p = self.BGBackGroundPanel.CamAngle.p - DY/3
				
				if self.BGBackGroundPanel.CamAngle.p > 90 then
					self.BGBackGroundPanel.CamAngle.p = 90
				end
				if self.BGBackGroundPanel.CamAngle.p < -90 then
					self.BGBackGroundPanel.CamAngle.p = -90
				end
				
				
				self.BGBackGroundPanel.CamAngle.y = self.BGBackGroundPanel.CamAngle.y + DX/6
				
				self.LastMousePos_X = CX
				self.LastMousePos_Y = CY
			end
		else
			if self.LM then
				self.LM = false
			end
		end
	
	
		self.BGBackGroundPanel.CamPos.x = math.min(self.BGBackGroundPanel.CamPos.x,530)
		self.BGBackGroundPanel.CamPos.x = math.max(self.BGBackGroundPanel.CamPos.x,-530)
		
		self.BGBackGroundPanel.CamPos.y = math.min(self.BGBackGroundPanel.CamPos.y,530)
		self.BGBackGroundPanel.CamPos.y = math.max(self.BGBackGroundPanel.CamPos.y,-530)
		
		self.BGBackGroundPanel.CamPos.z = math.min(self.BGBackGroundPanel.CamPos.z,200)
		self.BGBackGroundPanel.CamPos.z = math.max(self.BGBackGroundPanel.CamPos.z,10)
		
		draw.SimpleText("W A S D : Move", "RXCarFont_TrebOut_S22", 20,slf:GetTall()-80, Color(255,255,255,255))
		draw.SimpleText("Shift : Boost", "RXCarFont_TrebOut_S22", 20,slf:GetTall()-60, Color(255,255,255,255))
		draw.SimpleText("Left Click drag : Turn", "RXCarFont_TrebOut_S22", 20,slf:GetTall()-40, Color(255,255,255,255))
	end
	
end

function PANEL:BuildShop()
local MainPanel = self
	self.CurMode = "shop"
	
	local Canvas = self:ReBulidCanvas()
	Canvas.Name = "Car Shop"
	Canvas.SelectedCarNum = 1
	Canvas.SelectedCarData = D3DCarConfig.Car[Number]
	Canvas.Paint = function(slf)
		draw.SimpleText("You have " .. D3DCar_Meta:GetMoney(LocalPlayer()) .. " $", "RXCarFont_TrebOut_S25", 20,slf:GetTall()-80, Color(255,255,255,255))
	end
	function Canvas:SelectCar(Number)
		self.SelectedCarNum = Number
		self.SelectedCarData = D3DCarConfig.Car[Number]
		self.SelectedCarVehicleData = RXCar_Util_GetVehicleData(self.SelectedCarData.VehicleName)
		
		MainPanel.BGBackGroundPanel:SetCar(self.SelectedCarData.VehicleName,self.SelectedCarVehicleData)
		MainPanel.BGBackGroundPanel:SetTuneData(nil)

		local BGPanelCarEntity = MainPanel.BGBackGroundPanel:GetCarEntity()
		
		self.CarInfoLister:Clear()
		
		local BGColor = Color(0,0,0,200)
		local SubTextColor = Color(210,210,210,255)
		
		local function CreateTitle(Text)
			local Label = vgui.Create("DPanel")
			Label:SetTall(30)
			Label.Paint = function(slf)
				surface.SetDrawColor(Color(BGColor.r,BGColor.g,BGColor.b,255))
				surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
				draw.SimpleText(Text, "RXCarFont_TrebLW_S30", 10,slf:GetTall()/2, Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			end
			self.CarInfoLister:AddItem(Label)
		end
		
		-- CAR
		CreateTitle(self.SelectedCarData.CarName)
		
			local Label = vgui.Create("DPanel")
			Label:SetTall(40)
			Label.Paint = function(slf)
				surface.SetDrawColor(BGColor)
				surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
				draw.SimpleText("Price : ", "RXCarFont_TrebLW_S25", 10,slf:GetTall()/2, SubTextColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				draw.SimpleText(string.Comma(self.SelectedCarData.CarPrice), "RXCarFont_TrebLW_S25", slf:GetWide()-10,slf:GetTall()/2, Color(0,255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			end
			self.CarInfoLister:AddItem(Label)
		
		-- Skins
		CreateTitle("Skins")
		local Label = vgui.Create("DPanel")
		Label:SetTall(40)
		Label.Paint = function(slf)
			surface.SetDrawColor(BGColor)
			surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
			draw.SimpleText("Skins", "RXCarFont_TrebLW_S25", 10,slf:GetTall()/2, SubTextColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText(BGPanelCarEntity:SkinCount(), "RXCarFont_TrebLW_S25", slf:GetWide()-10,slf:GetTall()/2, Color(0,255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		end
		self.CarInfoLister:AddItem(Label)
		
		-- BodyGroups
		CreateTitle("BodyGroups")
		
		for k,v in pairs(BGPanelCarEntity:GetBodyGroups()) do
			local Label = vgui.Create("DPanel")
			Label:SetTall(30)
			Label.Paint = function(slf)
				surface.SetDrawColor(BGColor)
				surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
				draw.SimpleText(v.name, "RXCarFont_TrebLW_S23", 10,slf:GetTall()/2, SubTextColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				draw.SimpleText(v.num, "RXCarFont_TrebLW_S23", slf:GetWide()-10,slf:GetTall()/2, Color(0,255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			end
			self.CarInfoLister:AddItem(Label)
		end
		
		-- Descriptions
		if self.SelectedCarData.Description then
			CreateTitle("Descriptions")
			
			local LABEL = vgui.Create("DLabel") self.CarInfoLister:AddItem(LABEL)
			LABEL:SetAutoStretchVertical(true)
			LABEL:SetWrap(true)
			LABEL:SetText(self.SelectedCarData.Description .. " \n  ")
			LABEL:SetColor(SubTextColor)
			LABEL:SetFont("RXCarFont_TrebLWOut_S20")
			LABEL.Paint = function(slf)
				surface.SetDrawColor(BGColor)
				surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
			end
		end
		
		-- Purchase
		CreateTitle("Purchase")
		
		local CanBuy,Reason = LocalPlayer():RXCar_PlayerCanBuyCar(self.SelectedCarData.VehicleName)
		if CanBuy then
			local Button_BuyToINV = vgui.Create("RXCAR_DSWButton")
			Button_BuyToINV:SetTall(40)
			Button_BuyToINV:SetTexts("Buy into inventory")
			Button_BuyToINV.BoarderCol = Color(0,0,0,0)
			Button_BuyToINV.ClickSound = "buttons/blip1.wav"
			Button_BuyToINV.Click = function(slf)
				RXCar_ShowAsker("Are you sure you wish to buy this car for " .. self.SelectedCarData.CarPrice .. " ?",function()
					RXCar_BuyIntoInventory(self.SelectedCarData.VehicleName)
				end)
			end
			self.CarInfoLister:AddItem(Button_BuyToINV)
		else
			local Label = vgui.Create("DPanel")
			Label:SetTall(40)
			Label.Paint = function(slf)
				surface.SetDrawColor(Color(BGColor.r,BGColor.g,BGColor.b,255))
				surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
				draw.SimpleText(Reason, "RXCarFont_TrebLW_S30", 10,slf:GetTall()/2, Color(255,50,0,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			end
			self.CarInfoLister:AddItem(Label)
		end

	end
	
	function Canvas:SelectNextCar(int)
		self.SelectedCarNum = self.SelectedCarNum + int
		if self.SelectedCarNum <= 0 then
			self.SelectedCarNum = #D3DCarConfig.Car
		end
		if self.SelectedCarNum > #D3DCarConfig.Car then
			self.SelectedCarNum = 1
		end
		
		self:SelectCar(self.SelectedCarNum)
	end
	
	Canvas.OnMouseWheeled = function(slf,mc)
		slf:SelectNextCar(mc)
	end
	
	local BottomBar = vgui.Create("DPanel",Canvas)
	BottomBar:SetSize(Canvas:GetWide(),50)
	BottomBar:SetPos(0,Canvas:GetTall() - BottomBar:GetTall())
	BottomBar.Paint = function(slf)
		surface.SetDrawColor(0,0,0,210)
		surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
		surface.SetDrawColor(255,255,255,210)
		surface.DrawRect(0,0,slf:GetWide(),2)
		
		draw.SimpleText(Canvas.SelectedCarData.CarName, "RXCarFont_TrebLW_S40", slf:GetWide()/2,slf:GetTall()/2, Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	
	local Button_Left = vgui.Create("RXCAR_DSWButton",BottomBar)
	Button_Left:SetPos(BottomBar:GetWide()/2-240,5)
	Button_Left:SetSize(40,40)
	Button_Left:SetTexts("<")
	Button_Left.BoarderCol = Color(0,0,0,0)
	Button_Left.Click = function(slf)
		Canvas:SelectNextCar(-1)
	end
	
	local Button_Right = vgui.Create("RXCAR_DSWButton",BottomBar)
	Button_Right:SetPos(BottomBar:GetWide()/2+200,5)
	Button_Right:SetSize(40,40)
	Button_Right:SetTexts(">")
	Button_Right.BoarderCol = Color(0,0,0,0)
	Button_Right.Click = function(slf)
		Canvas:SelectNextCar(1)
	end
	
	local CarInfoLister = vgui.Create("DPanelList",Canvas) Canvas.CarInfoLister = CarInfoLister
	CarInfoLister:SetSize(300,Canvas:GetTall()-100)
	CarInfoLister:SetPos(Canvas:GetWide() - CarInfoLister:GetWide() - 20,20)
	CarInfoLister:EnableVerticalScrollbar( true )
	CarInfoLister:EnableHorizontal( false )
	CarInfoLister:RXCAR_PaintListBarC()
	
	
	local CarsListBG = vgui.Create("DPanel",Canvas)
	CarsListBG:SetSize(300,Canvas:GetTall()-200)
	CarsListBG:SetPos(20,20)
	CarsListBG.Paint = function(slf)
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawRect(0,0,slf:GetWide(),40)
		draw.SimpleText("Cars Available", "RXCarFont_TrebLW_S30", 10,20, Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end
	
	local CarList = vgui.Create("DPanelList",CarsListBG) Canvas.CarList = CarList
	CarList:SetPos(0,40)
	CarList:SetSize(CarsListBG:GetWide(),CarsListBG:GetTall()-40)
	CarList:EnableVerticalScrollbar( true )
	CarList:EnableHorizontal( false )
	CarList:RXCAR_PaintListBarC()
	
	local Sorted = {}
	
	for k,v in pairs(D3DCarConfig.Car or {}) do
		if !RXCar_Util_GetVehicleData(v.VehicleName) then continue end
		if !RXCar_Util_GetCarData(v.VehicleName) then continue end
		
		table.insert(Sorted,{k=k,v=v,Name=v.CarName})
	end
	if D3DCarConfig.Sort == 1 then
		table.SortByMember(Sorted, "Name")
	else
		table.SortByMember(Sorted, "Name", function(a, b) return a > b end)
	end
	
	
	for _,DB in pairs(Sorted) do
		local k = DB.k
		local v = DB.v
		
		local Label = vgui.Create("DButton")
		Label:SetTall(30)
		Label.DoClick = function(slf)
			Canvas:SelectCar(k)
		end
		Label:SetText("")
		Label.Paint = function(slf)
			surface.SetDrawColor(Color(0,0,0,250))
			surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
			
			if Canvas.SelectedCarNum == k then
				surface.SetDrawColor(255,255,255,30)
				surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
				surface.SetDrawColor(255,255,255,255)
				surface.DrawRect(0,0,5,slf:GetTall())
			end
			draw.SimpleText(v.CarName, "RXCarFont_TrebLW_S25", 10,15, Color(210,210,210,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		end
		CarList:AddItem(Label)
		
		if !Canvas.FirstInit then
			Canvas.FirstInit = true
			Canvas:SelectCar(k)
		end
	end
end

function PANEL:BuildInventory(ForceSelectUID)
	local MainPanel = self
		
	local Canvas = self:ReBulidCanvas()
	Canvas.Name = "My Inventory"
	Canvas.SelectedCarNum = nil
	Canvas.SelectedCarData = nil
	Canvas.SelectedCarVehicleData = nil
	Canvas.Paint = function(slf)
		draw.SimpleText("You have " .. D3DCar_Meta:GetMoney(LocalPlayer()) .. " $", "RXCarFont_TrebOut_S25", 20,slf:GetTall()-80, Color(255,255,255,255))
	end

	function Canvas:SelectCar(UID,InventoryData)
		self.SelectedCarNum = UID
		self.SelectedCarVehicleData = RXCar_Util_GetVehicleData(InventoryData.VehicleName)
		
		for k,v in pairs(D3DCarConfig.Car) do
			if v.VehicleName == InventoryData.VehicleName then
				self.SelectedCarData = v
			end
		end
		
		
		MainPanel.BGBackGroundPanel:SetCar(InventoryData.VehicleName,self.SelectedCarVehicleData)
		MainPanel.BGBackGroundPanel:SetTuneData(InventoryData.TuneData)

		local BGPanelCarEntity = MainPanel.BGBackGroundPanel:GetCarEntity()
		
		self.CarInfoLister:Clear()
		
		local BGColor = Color(0,0,0,200)
		local SubTextColor = Color(210,210,210,255)
		
		local function CreateTitle(Text)
			local Label = vgui.Create("DPanel")
			Label:SetTall(30)
			Label.Paint = function(slf)
				surface.SetDrawColor(Color(BGColor.r,BGColor.g,BGColor.b,255))
				surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
				draw.SimpleText(Text, "RXCarFont_TrebLW_S30", 10,slf:GetTall()/2, Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			end
			self.CarInfoLister:AddItem(Label)
		end
		
		-- CAR
		CreateTitle(self.SelectedCarData.CarName)
		
			local Label = vgui.Create("DPanel")
			Label:SetTall(40)
			Label.Paint = function(slf)
				surface.SetDrawColor(BGColor)
				surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
				draw.SimpleText("Refund : ", "RXCarFont_TrebLW_S25", 10,slf:GetTall()/2, SubTextColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				draw.SimpleText(string.Comma(self.SelectedCarData.CarRefund), "RXCarFont_TrebLW_S25", slf:GetWide()-10,slf:GetTall()/2, Color(0,255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			end
			self.CarInfoLister:AddItem(Label)
		
		-- Skins
		CreateTitle("Skins")
		local Label = vgui.Create("DPanel")
		Label:SetTall(40)
		Label.Paint = function(slf)
			surface.SetDrawColor(BGColor)
			surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
			draw.SimpleText("Skins", "RXCarFont_TrebLW_S25", 10,slf:GetTall()/2, SubTextColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText(BGPanelCarEntity:SkinCount(), "RXCarFont_TrebLW_S25", slf:GetWide()-10,slf:GetTall()/2, Color(0,255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		end
		self.CarInfoLister:AddItem(Label)
		
		-- BodyGroups
		CreateTitle("BodyGroups")
		
		for k,v in pairs(BGPanelCarEntity:GetBodyGroups()) do
			local Label = vgui.Create("DPanel")
			Label:SetTall(30)
			Label.Paint = function(slf)
				surface.SetDrawColor(BGColor)
				surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
				draw.SimpleText(v.name, "RXCarFont_TrebLW_S23", 10,slf:GetTall()/2, SubTextColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				draw.SimpleText(v.num, "RXCarFont_TrebLW_S23", slf:GetWide()-10,slf:GetTall()/2, Color(0,255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			end
			self.CarInfoLister:AddItem(Label)
		end
		
		-- Descriptions
		if self.SelectedCarData.Description then
			CreateTitle("Descriptions")
			
			local LABEL = vgui.Create("DLabel") self.CarInfoLister:AddItem(LABEL)
			LABEL:SetAutoStretchVertical(true)
			LABEL:SetWrap(true)
			LABEL:SetText(self.SelectedCarData.Description .. " \n  ")
			LABEL:SetColor(SubTextColor)
			LABEL:SetFont("RXCarFont_TrebLWOut_S20")
			LABEL.Paint = function(slf)
				surface.SetDrawColor(BGColor)
				surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
			end
		end
		
		-- Refund
		CreateTitle("Refund")
		
			local Button_BuyToINV = vgui.Create("RXCAR_DSWButton")
			Button_BuyToINV:SetTall(40)
			Button_BuyToINV:SetTexts("Refund")
			Button_BuyToINV.BoarderCol = Color(0,0,0,0)
			Button_BuyToINV.ClickSound = "buttons/blip1.wav"
			Button_BuyToINV.Click = function(slf)
				RXCar_ShowAsker("Are you sure you wish to refund this car?",function()
					RXCar_RefundStoredCar(UID)
					self.CarInfoLister:Clear()
				end)
			end
			self.CarInfoLister:AddItem(Button_BuyToINV)

		-- Tune
		CreateTitle("Tune")
		
			local Button_BuyToINV = vgui.Create("RXCAR_DSWButton")
			Button_BuyToINV:SetTall(40)
			Button_BuyToINV:SetTexts("Tune")
			Button_BuyToINV.BoarderCol = Color(0,0,0,0)
			Button_BuyToINV.ClickSound = "buttons/blip1.wav"
			Button_BuyToINV.Click = function(slf)
				MainPanel:BuildTuner(UID,InventoryData.TuneData or {})
			end
			self.CarInfoLister:AddItem(Button_BuyToINV)

		-- Take Out
		CreateTitle("Take Out")
		
		local CanBuy,Reason = LocalPlayer():RXCar_PlayerCanSpawnCar(InventoryData.VehicleName)
		if !CanBuy then
		--
			local Label = vgui.Create("DPanel")
			Label:SetTall(40)
			Label.Paint = function(slf)
				surface.SetDrawColor(Color(BGColor.r,BGColor.g,BGColor.b,255))
				surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
				draw.SimpleText(Reason, "RXCarFont_TrebLW_S30", 10,slf:GetTall()/2, Color(255,50,0,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			end
			self.CarInfoLister:AddItem(Label)
		else
			local Button_BuyToINV = vgui.Create("RXCAR_DSWButton")
			Button_BuyToINV:SetTall(40)
			Button_BuyToINV:SetTexts("Take Out")
			Button_BuyToINV.BoarderCol = Color(0,0,0,0)
			Button_BuyToINV.ClickSound = "buttons/blip1.wav"
			Button_BuyToINV.Click = function(slf)
				RXCar_ShowAsker("Are you sure you wish to take out this car?",function()
					RXCar_Switch2CarSpawner(UID,BGPanelCarEntity:GetModel(),MainPanel.SellerNPC)
					MainPanel:Remove()
				end)
			end
			self.CarInfoLister:AddItem(Button_BuyToINV)
		end
			
	end
	
	
		
	local BottomBar = vgui.Create("DPanel",Canvas)
	BottomBar:SetSize(Canvas:GetWide(),50)
	BottomBar:SetPos(0,Canvas:GetTall() - BottomBar:GetTall())
	BottomBar.Paint = function(slf)
		surface.SetDrawColor(0,0,0,210)
		surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
		surface.SetDrawColor(255,255,255,210)
		surface.DrawRect(0,0,slf:GetWide(),2)
		
		if Canvas.SelectedCarData then
			draw.SimpleText(Canvas.SelectedCarData.CarName, "RXCarFont_TrebLW_S40", slf:GetWide()/2,slf:GetTall()/2, Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
	
	local CarInfoLister = vgui.Create("DPanelList",Canvas) Canvas.CarInfoLister = CarInfoLister
	CarInfoLister:SetSize(300,Canvas:GetTall()-100)
	CarInfoLister:SetPos(Canvas:GetWide() - CarInfoLister:GetWide() - 20,20)
	CarInfoLister:EnableVerticalScrollbar( true )
	CarInfoLister:EnableHorizontal( false )
	CarInfoLister:RXCAR_PaintListBarC()
	
	local CarsListBG = vgui.Create("DPanel",Canvas)
	CarsListBG:SetSize(300,Canvas:GetTall()-200)
	CarsListBG:SetPos(20,20)
	CarsListBG.Paint = function(slf)
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawRect(0,0,slf:GetWide(),40)
		draw.SimpleText("Cars Stored", "RXCarFont_TrebLW_S30", 10,20, Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end
	
	local CarList = vgui.Create("DPanelList",CarsListBG) Canvas.CarList = CarList
	CarList.CarInventoryList = true
	CarList:SetPos(0,40)
	CarList:SetSize(CarsListBG:GetWide(),CarsListBG:GetTall()-40)
	CarList:EnableVerticalScrollbar( true )
	CarList:EnableHorizontal( false )
	CarList:RXCAR_PaintListBarC()
	
	function CarList:UpdateList()
		self:Clear()
		
		local Sorted = {}
		for k,v in pairs(RX3DCar_Inventory or {}) do
			if !RXCar_Util_GetVehicleData(v.VehicleName) then continue end
			if !RXCar_Util_GetCarData(v.VehicleName) then continue end
			
			table.insert(Sorted,{k=k,v=v,Name=v.CarName})
		end
		if D3DCarConfig.Sort == 1 then
			table.SortByMember(Sorted, "Name")
		else
			table.SortByMember(Sorted, "Name", function(a, b) return a > b end)
		end
		
		for _,DB in pairs(Sorted) do
			local UID = DB.k
			local v = DB.v
			
			local CarData = RXCar_Util_GetCarData(v.VehicleName)
			
			local Label = vgui.Create("DButton")
			Label:SetTall(30)
			Label.DoClick = function(slf)
				Canvas:SelectCar(UID,v)
			end
			Label:SetText("")
			Label.Paint = function(slf)
				surface.SetDrawColor(Color(0,0,0,250))
				surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
				
				if Canvas.SelectedCarNum == UID then
					surface.SetDrawColor(255,255,255,30)
					surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
					surface.SetDrawColor(255,255,255,255)
					surface.DrawRect(0,0,5,slf:GetTall())
				end
				draw.SimpleText(CarData.CarName, "RXCarFont_TrebLW_S25", 10,15, Color(210,210,210,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			end
			self:AddItem(Label)
			
			if !ForceSelectUID and !Canvas.FirstInit then
				Canvas.FirstInit = true
				Canvas:SelectCar(UID,v)
			end
			if ForceSelectUID and UID == ForceSelectUID then
				Canvas:SelectCar(UID,v)
			end
		end
	end
	CarList:UpdateList()

end

function PANEL:Install()
	self.BGBackGroundPanel = vgui.Create("D3D_CarShop_BGBackGround",self)
	self.BGBackGroundPanel:SetSize(self:GetWide()-4,self:GetTall()-4)
	self.BGBackGroundPanel.Mother = self
	self.BGBackGroundPanel:Center()
	self.BGBackGroundPanel:Install()
	
	local TopPanel = vgui.Create("DPanel",self) self.TopPanel = TopPanel
	TopPanel:SetPos(0,0)
	TopPanel:SetSize(self:GetWide(),50)
	TopPanel.Paint = function(slf)
		surface.SetDrawColor(0,0,0,240)
		surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
		surface.SetDrawColor(255,255,255,210)
		surface.DrawRect(0,slf:GetTall()-2,slf:GetWide(),2)
		
		local Name = "Car Dealer"
		if self.Canvas and self.Canvas.Name then
			Name = self.Canvas.Name
		end
		draw.SimpleText(Name, "RXCarFont_Treb_S40", 10,5, Color(255,255,255,255))
	end
	
		local FuncButton = vgui.Create("RXCAR_DSWButton",TopPanel)
		FuncButton:SetPos(TopPanel:GetWide()-140,10)
		FuncButton:SetSize(120,TopPanel:GetTall()-12)
		FuncButton:SetTexts("Close")
		FuncButton.BoarderCol = Color(0,0,0,0)
		FuncButton.BGCol = Color(0,0,0,0)
		FuncButton.Click = function(slf)
			self:Remove()
		end
		
		local FuncButton = vgui.Create("RXCAR_DSWButton",TopPanel)
		FuncButton:SetPos(TopPanel:GetWide()-280,10)
		FuncButton:SetSize(120,TopPanel:GetTall()-12)
		FuncButton:SetTexts("Buy")
		FuncButton.BoarderCol = Color(0,0,0,0)
		FuncButton.BGCol = Color(0,0,0,0)
		FuncButton.Click = function(slf)
			self:BuildShop()
		end
		local FuncButton = vgui.Create("RXCAR_DSWButton",TopPanel)
		FuncButton:SetPos(TopPanel:GetWide()-420,10)
		FuncButton:SetSize(120,TopPanel:GetTall()-12)
		FuncButton:SetTexts("Store")
		FuncButton.BoarderCol = Color(0,0,0,0)
		FuncButton.BGCol = Color(0,0,0,0)
		FuncButton.Click = function(slf)
			RXCar_Switch2CarStorer(self.SellerNPC)
			self:Remove()
		end
		
		local FuncButton = vgui.Create("RXCAR_DSWButton",TopPanel)
		FuncButton:SetPos(TopPanel:GetWide()-560,10)
		FuncButton:SetSize(120,TopPanel:GetTall()-12)
		FuncButton:SetTexts("Inventory")
		FuncButton.BoarderCol = Color(0,0,0,0)
		FuncButton.BGCol = Color(0,0,0,0)
		FuncButton.Click = function(slf)
			self:BuildInventory()
		end
		
		local FuncButton = vgui.Create("RXCAR_DSWButton",TopPanel)
		FuncButton:SetPos(TopPanel:GetWide()-700,10)
		FuncButton:SetSize(120,TopPanel:GetTall()-12)
		FuncButton:SetTexts("FreeCam")
		FuncButton.BoarderCol = Color(0,0,0,0)
		FuncButton.BGCol = Color(0,0,0,0)
		FuncButton.Click = function(slf)
			self:FreeCamMode()
		end
		
		
	
	self:BuildShop()
end

vgui.Register("D3D_CarShop",PANEL,"DFrame")



end






if CLIENT then -- PANEL : D3D_CarShop_BGBackGround

local function GetMaterialK(Dir)
	local params = {
		["$basetexture"] = Dir,
		["$ignorez"] = 0,
	}
	return CreateMaterial("eq " .. Dir,"UnlitGeneric",params)
end

local function GetMaterialM(Dir)
	local params = {
		["$basetexture"] = Dir,
		["$model"] = 1,
	}
	return CreateMaterial("meq " .. Dir,"UnlitGeneric",params)
end





local WorldProps = {}
-- Center Circle
table.insert(WorldProps,{
	Model = "models/mechanics/wheels/wheel_speed_72.mdl",
	Material = GetMaterialM("phoenix_storms/gear"),
	Pos = Vector(0,0,0),
	Angle = Angle(0,0,0),
	Size = Vector(4,4,0.1),
	Color = Color(200,200,200,255)
})
table.insert(WorldProps,{
	Model = "models/mechanics/wheels/wheel_speed_72.mdl",
	Material = GetMaterialM("phoenix_storms/dome"),
	Pos = Vector(0,0,1),
	Angle = Angle(0,0,0),
	Size = Vector(3.8,3.8,0.1),
	Color = Color(100,100,100,255)
})

-- Deco
table.insert(WorldProps,{
	Model = "models/props_lab/workspace003.mdl",
	Pos = Vector(-480,-480,0),
	Angle = Angle(0,0,0),
	Size = Vector(1,1,1),
	Color = Color(255,255,255,255)
})
table.insert(WorldProps,{
	Model = "models/props_lab/partsbin01.mdl",
	Pos = Vector(-480,300,65),
	Angle = Angle(0,0,0),
	Size = Vector(5,5,5),
	Color = Color(255,255,255,255)
})

table.insert(WorldProps,{
	Model = "models/props_wasteland/controlroom_desk001a.mdl",
	Pos = Vector(-350,0,20),
	Angle = Angle(0,180,0),
	Size = Vector(1,1,1),
	Color = Color(255,255,255,255)
})
table.insert(WorldProps,{
	Model = "models/props_lab/clipboard.mdl",
	Pos = Vector(-350,0,38),
	Angle = Angle(0,78,0),
	Size = Vector(2,2,1),
	Color = Color(255,255,255,255)
})

table.insert(WorldProps,{
	Model = "models/props_wasteland/gaspump001a.mdl",
	Pos = Vector(350,0,10),
	Angle = Angle(0,180,0),
	Size = Vector(1,1,1),
	Color = Color(255,255,255,255)
})

-- Light
for k = 0,2 do
	for i = 0,2 do
		table.insert(WorldProps,{
			Model = "models/props_lab/lab_flourescentlight001a.mdl",
			Pos = Vector(-250 + 250*k,-250 + 250*i,230),
			Angle = Angle(0,0,0),
			Size = Vector(1,1,0.5),
			Color = Color(255,255,255,255)
		})
		table.insert(WorldProps,{
			Model = "models/effects/vol_light128x128.mdl",
			Pos = Vector(-250 + 250*k,-250 + 250*i,230),
			Angle = Angle(90,0,0),
			Size = Vector(0.2,1,0.5),
			Color = Color(255,255,255,20)
		})
		table.insert(WorldProps,{
			Model = "models/effects/vol_light128x128.mdl",
			Pos = Vector(-250 + 250*k,-250 + 250*i,230),
			Angle = Angle(270,0,0),
			Size = Vector(0.2,1,0.5),
			Color = Color(255,255,255,20)
		})
		
	end
end


local World3DTexture = {}
-- Floor
local FlootMAT = GetMaterialK("concrete/concretefloor016a")
local FlootMAT = GetMaterialK("tile/tilefloor016a")
for x=0,3 do
	for y=0,3 do
		table.insert(World3DTexture,{
			Pos = Vector(-500+250*x,-500+250*y,0),
			Angle = Angle(0,90,0),
			Size = Vector(500,500,1),
			Color = Color(255,255,255,255),
			Material = FlootMAT
		})
	end
end

-- Top
local FlootMAT = GetMaterialK("tile/prodceilingtilea")
for x=0,3 do
	for y=0,3 do
		table.insert(World3DTexture,{
			Pos = Vector(-250+250*x,-500+250*y,250),
			Angle = Angle(180,90,0),
			Size = Vector(500,500,1),
			Color = Color(255,255,255,255),
			Material = FlootMAT
		})
	end
end

-- Wall
local WallMAT = GetMaterialK("metal/metalwall018f")
for i=0,3 do
		table.insert(World3DTexture,{
			Pos = Vector(500,-250+250*i,250),
			Angle = Angle(90,270,0),
			Size = Vector(500,500,1),
			Color = Color(255,255,255,255),
			Material = WallMAT
		})
		table.insert(World3DTexture,{
			Pos = Vector(-500,-500+250*i,250),
			Angle = Angle(270,90,0),
			Size = Vector(500,500,1),
			Color = Color(255,255,255,255),
			Material = WallMAT
		})
		
end
for i=0,3 do
		table.insert(World3DTexture,{
			Pos = Vector(-250+250*i,-500,250),
			Angle = Angle(0,180,270),
			Size = Vector(500,500,1),
			Color = Color(255,255,255,255),
			Material = WallMAT
		})
		table.insert(World3DTexture,{
			Pos = Vector(-500+250*i,500,250),
			Angle = Angle(0,0,90),
			Size = Vector(500,500,1),
			Color = Color(255,255,255,255),
			Material = WallMAT
		})
end


local PANEL = {}
function PANEL:Init()
	self.CamPos = Vector(300,0,125)
	self.CamAngle = (Vector(0,0,30)-self.CamPos):Angle()
	
	self.CarCModel = ClientsideModel("models/props_junk/PopCan01a.mdl",RENDER_GROUP_VIEW_MODEL_OPAQUE)
	self.CarCModel:SetNoDraw(true)
	
	self.TireCModel = ClientsideModel("models/props_junk/PopCan01a.mdl",RENDER_GROUP_VIEW_MODEL_OPAQUE)
	self.TireCModel:SetNoDraw(true)
	
	
	self.RollSpeed = 10
	
	self.CarAngle = Angle(0,0,0)
	
	self.TuneData = {}
end

function PANEL:GetCarEntity()
	return self.CarCModel
end

function PANEL:OnRemove()
	self.CarCModel:Remove()
	self.TireCModel:Remove()
end

local Glow1 = Material("sprites/gmdm_pickups/light")

function PANEL:Draw3DWorld()
	--	render.ResetModelLighting( 1, 1, 1 )
	--	render.SetLightingOrigin( Vector(0,0,0) )
		
	for k,v in pairs(World3DTexture) do
		local SAng = Angle(0,0,0)
		SAng:RotateAroundAxis(SAng:Forward(), v.Angle.r)
		SAng:RotateAroundAxis(SAng:Right(), v.Angle.p)
		SAng:RotateAroundAxis(SAng:Up(), v.Angle.y)
	 
		cam.Start3D2D( v.Pos,SAng, 0.5 )
			surface.SetMaterial(v.Material)
			surface.SetDrawColor(v.Color)
			surface.DrawTexturedRect(0,0,v.Size.x,v.Size.y)
		cam.End3D2D()
	end
	
		cam.Start3D2D( Vector(-500,-120,150),Angle(0,90,90), 0.7)
			draw.SimpleText("3D Car Dealer 2", "RXCarFont_TrebOut_S60", 0,0, Color(255,255,255,255))
			draw.SimpleText("Made by RocketMania", "RXCarFont_TrebOut_S30", 30,50, Color(255,255,255,255))
		cam.End3D2D()
	
	for k,v in pairs(WorldProps) do
		local SAng = Angle(0,0,0)
		local CModel = RXC_CMODEL_MASTER
		if v.ModelScale then
			CModel = RXC_CMODEL_MASTER_MS
		end
		CModel:SetModel(v.Model)
		CModel:SetRenderOrigin(v.Pos)
		
		SAng:RotateAroundAxis(SAng:Forward(), v.Angle.r)
		SAng:RotateAroundAxis(SAng:Right(), v.Angle.p)
		SAng:RotateAroundAxis(SAng:Up(), v.Angle.y)
		CModel:SetRenderAngles(SAng)
		
		render.SetColorModulation(v.Color.r/255, v.Color.g/255, v.Color.b/255)
		render.SetBlend(v.Color.a/255)
		CModel:SetMaterial(v.Material)
		
		if v.Size then
			local mat = Matrix()
			mat:Scale( v.Size )
			CModel:EnableMatrix("RenderMultiply", mat)
		end
		if v.ModelScale then
			CModel:SetModelScale(v.ModelScale,0)
		end
		
			CModel:SetupBones()
			CModel:DrawModel()
	end
	
	render.SetBlend(1)
	render.SetMaterial( Glow1 )
	for k = 1,10 do
		local Pos = Vector(0,0,3) + Angle(0,360/10*k,0):Forward()*120
		render.DrawQuadEasy( Pos, Vector(0,0,1), 60,60, Color( 255, 255, 255, 255 ),0 )
	end	
	
	-- Lights
	
	--
end

function PANEL:CantSpin()
	if self.Mother and self.Mother.Canvas and self.Mother.Canvas.CantSpin then
		return true
	end
	return false
end

function PANEL:RenderCar()
	if !self:CantSpin() then
		self.CarAngle.y = self.CarAngle.y + self.RollSpeed * FrameTime()
	end
	
	local PosZ = 0
	if self.CarData and self.CarData.IsSCar then
		PosZ = 40
	end
	
	render.SetColorModulation(self.TuneData.Color.r/255,self.TuneData.Color.g/255,self.TuneData.Color.b/255)
	self.CarCModel:SetPos(Vector(0,0,PosZ))
	self.CarCModel:SetRenderOrigin(Vector(0,0,PosZ))
	self.CarCModel:SetRenderAngles(self.CarAngle)
	self.CarCModel:DrawModel()
	render.SetColorModulation(1,1,1)
	
	-- SCAR WHEELS
	if self.CarData.IsSCar then
		self.TireCModel:SetModel(self.VehicleData.TireModel)
		for k,v in pairs(self.VehicleData.WheelInfo or {}) do
			--local SAng = Angle(0,self.CAngle,0)
			
			local RPos = self.CarCModel:GetPos()
			RPos = RPos + self.CarAngle:Forward() * v.Pos.x
			RPos = RPos + self.CarAngle:Right() * v.Pos.y
			RPos = RPos + self.CarAngle:Up() * v.Pos.z
			
			self.TireCModel:SetRenderOrigin(RPos)
			self.TireCModel:SetRenderAngles(self.CarAngle)
			self.TireCModel:SetupBones()
			self.TireCModel:DrawModel()
		end
	end
	
	for UID,DB in pairs(self.TuneData.Elements or {}) do
		local ElementDB = RXCar_Tuners[DB.Type]
		if ElementDB then
			ElementDB:Render(self.CarCModel,DB.Vars)
			ElementDB:RenderOnEditor(self.CarCModel,DB.Vars)
		end
	end
end

function PANEL:Paint()
	local x, y = self:LocalToScreen( 0, 0 )
	local w, h = self:GetSize()
	
	cam.Start3D( self.CamPos, self.CamAngle, 70, x, y, w, h)
		render.SuppressEngineLighting( false )
		self:Draw3DWorld()
		render.SuppressEngineLighting( true )
		self:RenderCar()
		render.SuppressEngineLighting( false )
	cam.End3D()
end

function PANEL:SetCar(VehicleName,VehicleData)
	self.CarCModel:SetModel(VehicleData.Model or VehicleData.CarModel)
	
	self.CarData = RXCar_Util_GetCarData(VehicleName)
	self.VehicleData = RXCar_Util_GetVehicleData(VehicleName)
end
function PANEL:SetTuneData(data)
	data = data or {}
	RXCar_InitTuneData(data)
	
	self.TuneData = data
end

function PANEL:Install()
	self.TuneData = {}
	self.TuneData.Color = Color(255,255,255,255)

end

vgui.Register("D3D_CarShop_BGBackGround",PANEL,"DPanel")
end